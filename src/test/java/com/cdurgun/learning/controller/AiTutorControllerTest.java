package com.cdurgun.learning.controller;

import com.cdurgun.learning.domain.Role;
import com.cdurgun.learning.domain.User;
import com.cdurgun.learning.repository.UserRepository;
import com.cdurgun.learning.service.ai.AiErrorCategory;
import com.cdurgun.learning.service.ai.AiProviderException;
import com.cdurgun.learning.service.ai.TutorCompletion;
import com.cdurgun.learning.service.ai.TutorModelClient;
import com.cdurgun.learning.service.ai.TutorPrompt;
import com.cdurgun.learning.service.ai.TutorUsage;
import com.jayway.jsonpath.JsonPath;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.context.MessageSource;
import org.springframework.http.MediaType;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * AI Tutor uç noktaları gerçek güvenlik zinciri, gerçek guard (rezervasyon + kullanım kaydı, test
 * DB'si) ve gerçek render ile. Sağlayıcı ({@link TutorModelClient}) BİR MOCK: hiçbir test DeepSeek'e
 * ya da ağa çıkmaz; anahtar sahte. Bütçe, günün başka satırlarından etkilenmesin diye yüksek; her
 * test kendi kullanıcılarının satırlarını siler.
 */
@SpringBootTest(properties = {
        "ai.tutor.enabled=true",
        "ai.tutor.api-key=sk-test-not-a-real-key",
        "ai.tutor.budget.daily-usd=1000",
        "ai.tutor.budget.monthly-usd=10000"})
@AutoConfigureMockMvc
@ActiveProfiles("test")
class AiTutorControllerTest {

    private static final String MESSAGES = "/en/admin/ai-tutor/messages";
    private static final String FAKE_KEY = "sk-test-not-a-real-key";

    @Autowired
    private MockMvc mockMvc;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private PasswordEncoder passwordEncoder;
    @Autowired
    private JdbcTemplate jdbc;
    @Autowired
    private MessageSource messageSource;

    @MockitoBean
    private TutorModelClient client;

    private final List<Long> createdUsers = new ArrayList<>();

    @AfterEach
    void removeTestRows() {
        for (Long id : createdUsers) {
            jdbc.update("DELETE FROM ai_tutor_reservation WHERE user_id = ?", id);
            jdbc.update("DELETE FROM ai_usage_log WHERE user_id = ?", id);
            jdbc.update("DELETE FROM app_user WHERE id = ?", id);
        }
    }

    private MockHttpSession login(Role role) throws Exception {
        String email = "ai-tutor-" + role.name().toLowerCase() + "-" + UUID.randomUUID() + "@example.com";
        User user = userRepository.save(User.builder()
                .email(email)
                .passwordHash(passwordEncoder.encode("correct-password"))
                .displayName("AI Tutor " + role.name())
                .role(role)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build());
        createdUsers.add(user.getId());
        MvcResult result = mockMvc.perform(post("/en/login")
                        .param("username", email)
                        .param("password", "correct-password")
                        .with(csrf()))
                .andExpect(status().is3xxRedirection())
                .andReturn();
        HttpSession session = result.getRequest().getSession(false);
        return (MockHttpSession) session;
    }

    private static MockHttpServletRequestBuilder message(String path, String json) {
        return post(path).contentType(MediaType.APPLICATION_JSON).content(json);
    }

    private static String body(String conversationId, String message, String topicSlug) {
        return "{\"conversationId\":" + quoted(conversationId) + ",\"message\":" + quoted(message)
                + ",\"topicSlug\":" + quoted(topicSlug) + "}";
    }

    private static String quoted(String value) {
        return value == null ? "null" : "\"" + value + "\"";
    }

    private Long onlyUserId() {
        return createdUsers.getLast();
    }

    private Map<String, Object> onlyUsageRow(Long userId) {
        return jdbc.queryForMap("SELECT * FROM ai_usage_log WHERE user_id = ?", userId);
    }

    private Map<String, Object> onlyReservation(Long userId) {
        return jdbc.queryForMap("SELECT * FROM ai_tutor_reservation WHERE user_id = ?", userId);
    }

    // --- yetki ve CSRF ---

    @Test
    void anonymousFetchGets401NotALoginRedirect() throws Exception {
        mockMvc.perform(message(MESSAGES, body(null, "Q", null)).with(csrf()))
                .andExpect(status().isUnauthorized())
                .andExpect(header().doesNotExist("Location"));
        mockMvc.perform(delete("/en/admin/ai-tutor/conversations/" + UUID.randomUUID()).with(csrf()))
                .andExpect(status().isUnauthorized());
        verifyNoInteractions(client);
    }

    @Test
    void regularUserIsForbidden() throws Exception {
        MockHttpSession session = login(Role.USER);

        mockMvc.perform(message(MESSAGES, body(null, "Q", null)).session(session).with(csrf()))
                .andExpect(status().isForbidden());
        verifyNoInteractions(client);
        assertThat(jdbc.queryForObject("SELECT count(*) FROM ai_tutor_reservation WHERE user_id = ?",
                Integer.class, onlyUserId())).isZero();
    }

    @Test
    void adminWithoutCsrfTokenIsRejected() throws Exception {
        MockHttpSession session = login(Role.ADMIN);

        mockMvc.perform(message(MESSAGES, body(null, "Q", null)).session(session))
                .andExpect(status().isForbidden());
        mockMvc.perform(delete("/en/admin/ai-tutor/conversations/" + UUID.randomUUID()).session(session))
                .andExpect(status().isForbidden());
        verifyNoInteractions(client);
    }

    // --- uçtan uca ---

    @Test
    void adminConversationEndToEnd() throws Exception {
        MockHttpSession session = login(Role.ADMIN);
        when(client.complete(any())).thenReturn(new TutorCompletion(
                "An **enum** is a type.\n\n<script>alert(1)</script>", false, "deepseek-flash",
                new TutorUsage(0, 1000, 200, null)));

        MvcResult first = mockMvc.perform(message(MESSAGES, body(null, "What is an enum?", "enum"))
                        .session(session).with(csrf().asHeader()))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.answerHtml").value(org.hamcrest.Matchers.containsString("<strong>enum</strong>")))
                .andExpect(jsonPath("$.answerHtml").value(org.hamcrest.Matchers.not(org.hamcrest.Matchers.containsString("<script"))))
                .andExpect(jsonPath("$.conversationSaved").value(true))
                .andExpect(jsonPath("$.conversationId").isNotEmpty())
                .andExpect(jsonPath("$.truncated").value(false))
                .andExpect(jsonPath("$.lessonContextUsed").value(true))
                .andExpect(jsonPath("$.turnsRemaining").value(5))
                .andReturn();
        String conversationId = JsonPath.read(first.getResponse().getContentAsString(), "$.conversationId");

        // Kullanım kaydı ve rezervasyon: gerçek guard üzerinden, sağlayıcının bildirdiği kullanımla.
        Long userId = onlyUserId();
        Map<String, Object> usage = onlyUsageRow(userId);
        assertThat(usage.get("outcome")).isEqualTo("SUCCESS");
        assertThat(usage.get("topic_slug")).isEqualTo("enum");
        assertThat((BigDecimal) usage.get("estimated_cost_usd")).isPositive();
        assertThat(onlyReservation(userId).get("status")).isEqualTo("SETTLED");

        // Lesson bloğu sunucuda kuruldu; ikinci soru geçmişi taşır.
        mockMvc.perform(message(MESSAGES, body(conversationId, "And EnumSet?", "enum"))
                        .session(session).with(csrf().asHeader()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.conversationId").value(conversationId))
                .andExpect(jsonPath("$.turnsRemaining").value(4));
        ArgumentCaptor<TutorPrompt> prompts = ArgumentCaptor.forClass(TutorPrompt.class);
        verify(client, org.mockito.Mockito.times(2)).complete(prompts.capture());
        List<TutorPrompt.Message> second = prompts.getAllValues().get(1).messages();
        assertThat(second.getFirst().content()).contains("<lesson>").contains("</lesson>");
        assertThat(second).extracting(TutorPrompt.Message::content).containsSubsequence("What is an enum?", "And EnumSet?");

        // Silme: bir kez 204, sonra 404; silinen konuşmaya soru 404.
        mockMvc.perform(delete("/en/admin/ai-tutor/conversations/" + conversationId).session(session).with(csrf()))
                .andExpect(status().isNoContent());
        mockMvc.perform(delete("/en/admin/ai-tutor/conversations/" + conversationId).session(session).with(csrf()))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.error").value("conversation_not_found"));
        mockMvc.perform(message(MESSAGES, body(conversationId, "Q3", "enum")).session(session).with(csrf()))
                .andExpect(status().isNotFound());
        verify(client, org.mockito.Mockito.times(2)).complete(any());
    }

    @Test
    void timeoutWithoutUsageIsChargedAtWorstCaseAndShownGenerically() throws Exception {
        MockHttpSession session = login(Role.ADMIN);
        when(client.complete(any())).thenThrow(new AiProviderException(AiErrorCategory.TIMEOUT, null));

        mockMvc.perform(message(MESSAGES, body(null, "Q", null)).session(session).with(csrf()))
                .andExpect(status().isGatewayTimeout())
                .andExpect(jsonPath("$.error").value("ai_timeout"))
                .andExpect(jsonPath("$.message").isNotEmpty());

        Long userId = onlyUserId();
        Map<String, Object> usage = onlyUsageRow(userId);
        Map<String, Object> reservation = onlyReservation(userId);
        assertThat(usage.get("outcome")).isEqualTo("ERROR");
        assertThat(usage.get("error_category")).isEqualTo("TIMEOUT");
        assertThat((BigDecimal) usage.get("estimated_cost_usd"))
                .isEqualByComparingTo((BigDecimal) reservation.get("reserved_usd"));
        assertThat(reservation.get("status")).isEqualTo("SETTLED");
    }

    @Test
    void providerBalanceErrorIsNotShownAsTheAppBudgetAndLeaksNoDetail() throws Exception {
        MockHttpSession session = login(Role.ADMIN);
        when(client.complete(any())).thenThrow(new AiProviderException(AiErrorCategory.INSUFFICIENT_BALANCE, 402));

        MvcResult result = mockMvc.perform(message("/tr" + MESSAGES.substring(3), body(null, "Q", null))
                        .session(session).with(csrf()))
                .andExpect(status().isBadGateway())
                .andExpect(jsonPath("$.error").value("ai_unavailable"))
                .andReturn();
        String response = result.getResponse().getContentAsString();
        Locale tr = Locale.forLanguageTag("tr");
        assertThat(response).doesNotContain("402").doesNotContain("INSUFFICIENT").doesNotContain(FAKE_KEY)
                .doesNotContain("deepseek")
                .contains(messageSource.getMessage("aiTutor.error.ai_unavailable", null, tr))
                .doesNotContain(messageSource.getMessage("aiTutor.error.budget_exhausted", null, tr));
        // Harcama yine kaydedildi (kullanım yok -> en kötü durum).
        assertThat(onlyUsageRow(onlyUserId()).get("error_category")).isEqualTo("INSUFFICIENT_BALANCE");
    }

    @Test
    void sessionInvalidatedDuringTheCallReturnsTheAnswerAsUnsavedWithoutRetrying() throws Exception {
        MockHttpSession session = login(Role.ADMIN);
        when(client.complete(any())).thenAnswer(invocation -> {
            session.invalidate();
            return new TutorCompletion("Answer **A**", false, "deepseek-flash", new TutorUsage(0, 100, 20, null));
        });

        mockMvc.perform(message(MESSAGES, body(null, "Q", null)).session(session).with(csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.conversationSaved").value(false))
                .andExpect(jsonPath("$.conversationId").value(org.hamcrest.Matchers.nullValue()))
                .andExpect(jsonPath("$.turnsRemaining").value(0))
                .andExpect(jsonPath("$.answerHtml").value(org.hamcrest.Matchers.containsString("<strong>A</strong>")));

        verify(client, org.mockito.Mockito.times(1)).complete(any());
        Long userId = onlyUserId();
        assertThat(onlyUsageRow(userId).get("outcome")).isEqualTo("SUCCESS");
        assertThat(onlyReservation(userId).get("status")).isEqualTo("SETTLED");
    }

    // --- sağlayıcıya gitmeden reddedilenler ---

    @Test
    void invalidRequestsNeverReachTheProvider() throws Exception {
        MockHttpSession session = login(Role.ADMIN);

        mockMvc.perform(message(MESSAGES, body(null, "Q", "no-such-topic")).session(session).with(csrf()))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.error").value("invalid_request"));
        mockMvc.perform(message(MESSAGES, body(null, "Q", "Bad Slug!")).session(session).with(csrf()))
                .andExpect(status().isBadRequest());
        mockMvc.perform(message(MESSAGES, body(null, "", null)).session(session).with(csrf()))
                .andExpect(status().isBadRequest());
        mockMvc.perform(message(MESSAGES, body(null, "x".repeat(4001), null)).session(session).with(csrf()))
                .andExpect(status().isBadRequest());
        mockMvc.perform(message(MESSAGES, "{not json").session(session).with(csrf()))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.error").value("invalid_request"));
        mockMvc.perform(message(MESSAGES, "{\"conversationId\":\"not-a-uuid\",\"message\":\"Q\"}")
                        .session(session).with(csrf()))
                .andExpect(status().isBadRequest());
        mockMvc.perform(post(MESSAGES).contentType(MediaType.TEXT_PLAIN).content("Q").session(session).with(csrf()))
                .andExpect(status().isBadRequest());
        mockMvc.perform(message(MESSAGES, body(UUID.randomUUID().toString(), "Q", null)).session(session).with(csrf()))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.error").value("conversation_not_found"));
        mockMvc.perform(delete("/en/admin/ai-tutor/conversations/not-a-uuid").session(session).with(csrf()))
                .andExpect(status().isBadRequest());

        verifyNoInteractions(client);
        assertThat(jdbc.queryForObject("SELECT count(*) FROM ai_tutor_reservation WHERE user_id = ?",
                Integer.class, onlyUserId())).isZero();
    }
}
