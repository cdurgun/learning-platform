package com.cdurgun.learning.controller;

import com.cdurgun.learning.domain.Role;
import com.cdurgun.learning.domain.User;
import com.cdurgun.learning.repository.UserRepository;
import com.cdurgun.learning.service.ai.TutorModelClient;
import jakarta.servlet.http.HttpSession;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.http.MediaType;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import java.time.LocalDateTime;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * {@code application.yml}'in varsayılanıyla ({@code ai.tutor.enabled=false}) ADMIN bile tutoru
 * kullanamaz: 503 {@code disabled}, sağlayıcıya ve rezervasyona hiç gidilmez; sayfa yalnızca
 * "kapalı" mesajını gösterir.
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class AiTutorDisabledByDefaultTest {

    @Autowired
    private MockMvc mockMvc;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private PasswordEncoder passwordEncoder;
    @Autowired
    private JdbcTemplate jdbc;

    @MockitoBean
    private TutorModelClient client;

    private Long userId;

    @AfterEach
    void removeTestUser() {
        if (userId != null) {
            jdbc.update("DELETE FROM app_user WHERE id = ?", userId);
        }
    }

    @Test
    void adminGetsDisabledAndNothingIsReserved() throws Exception {
        String email = "ai-tutor-off-" + UUID.randomUUID() + "@example.com";
        userId = userRepository.save(User.builder()
                .email(email)
                .passwordHash(passwordEncoder.encode("correct-password"))
                .displayName("AI Tutor Off")
                .role(Role.ADMIN)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build()).getId();
        MvcResult login = mockMvc.perform(post("/en/login")
                        .param("username", email)
                        .param("password", "correct-password")
                        .with(csrf()))
                .andExpect(status().is3xxRedirection())
                .andReturn();
        HttpSession session = login.getRequest().getSession(false);

        mockMvc.perform(post("/en/admin/ai-tutor/messages")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"conversationId\":null,\"message\":\"Q\",\"topicSlug\":null}")
                        .session((MockHttpSession) session)
                        .with(csrf()))
                .andExpect(status().isServiceUnavailable())
                .andExpect(jsonPath("$.error").value("disabled"));

        // Sayfa açılır ama sohbet formu, betik ve CSRF meta etiketleri hiç yoktur.
        String html = mockMvc.perform(get("/en/admin/ai-tutor").session((MockHttpSession) session))
                .andExpect(status().isOk())
                .andReturn().getResponse().getContentAsString();
        Document doc = Jsoup.parse(html);
        assertThat(doc.select("[role=status]").text()).contains("turned off");
        assertThat(doc.select("section.ai-tutor, textarea, #ai-tutor-topic")).isEmpty();
        assertThat(doc.select("script[src^=\"/js/ai-tutor\"], meta[name=_csrf], meta[name=_csrf_header]")).isEmpty();

        // Ders sayfası: ADMIN düğmeyi ve "kapalı" mesajlı paneli görür; sohbet, betik ve CSRF meta yok.
        Document lesson = Jsoup.parse(mockMvc.perform(get("/en/topics/enum").session((MockHttpSession) session))
                .andExpect(status().isOk())
                .andReturn().getResponse().getContentAsString());
        assertThat(lesson.select("button.ai-tutor-open")).hasSize(1);
        assertThat(lesson.select("#aiTutorPanel [role=status]").text()).contains("turned off");
        assertThat(lesson.select("#aiTutorPanel section.ai-tutor, #ai-tutor-input")).isEmpty();
        assertThat(lesson.select("script[src^=\"/js/ai-tutor\"], meta[name=_csrf], meta[name=_csrf_header]")).isEmpty();
        assertThat(lesson.select("#quiz-section, article.markdown-content")).hasSize(2);

        verifyNoInteractions(client);
        assertThat(jdbc.queryForObject("SELECT count(*) FROM ai_tutor_reservation WHERE user_id = ?",
                Integer.class, userId)).isZero();
    }
}
