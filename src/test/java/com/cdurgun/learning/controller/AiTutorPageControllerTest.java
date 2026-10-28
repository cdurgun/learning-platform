package com.cdurgun.learning.controller;

import com.cdurgun.learning.domain.Role;
import com.cdurgun.learning.domain.User;
import com.cdurgun.learning.repository.UserRepository;
import com.cdurgun.learning.service.ai.TutorModelClient;
import jakarta.servlet.http.HttpSession;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Assumptions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * Ayrı AI Tutor sayfası (adım 10) ve ders sayfası paneli (adım 11), tutor AÇIK iken. Ayarlar ve mock sağlayıcı
 * {@link AiTutorControllerTest} ile aynı (aynı Spring bağlamı yeniden kullanılır); sayfa hiçbir
 * sağlayıcı çağrısı yapmaz. Kapalı (varsayılan) durum: {@link AiTutorDisabledByDefaultTest}.
 */
@SpringBootTest(properties = {
        "ai.tutor.enabled=true",
        "ai.tutor.api-key=sk-test-not-a-real-key",
        "ai.tutor.budget.daily-usd=1000",
        "ai.tutor.budget.monthly-usd=10000"})
@AutoConfigureMockMvc
@ActiveProfiles("test")
class AiTutorPageControllerTest {

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

    private final List<Long> createdUsers = new ArrayList<>();

    @AfterEach
    void removeTestUsers() {
        createdUsers.forEach(id -> jdbc.update("DELETE FROM app_user WHERE id = ?", id));
    }

    private MockHttpSession login(Role role) throws Exception {
        String email = "ai-tutor-page-" + role.name().toLowerCase() + "-" + UUID.randomUUID() + "@example.com";
        User user = userRepository.save(User.builder()
                .email(email)
                .passwordHash(passwordEncoder.encode("correct-password"))
                .displayName("AI Tutor Page " + role.name())
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

    private Document page(MockHttpSession session, String url) throws Exception {
        String html = mockMvc.perform(get(url).session(session))
                .andExpect(status().isOk())
                .andReturn().getResponse().getContentAsString();
        return Jsoup.parse(html);
    }

    @Test
    void anonymousIsSentToLoginAndUserIsForbidden() throws Exception {
        mockMvc.perform(get("/en/admin/ai-tutor"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/en/login"));
        mockMvc.perform(get("/tr/admin/ai-tutor").session(login(Role.USER)))
                .andExpect(status().isForbidden());
    }

    @Test
    void adminGetsTheChatWiredToTheControllerContract() throws Exception {
        Document doc = page(login(Role.ADMIN), "/en/admin/ai-tutor");

        Element chat = doc.selectFirst("section.ai-tutor");
        assertThat(chat).isNotNull();
        assertThat(chat.attr("data-messages-url")).isEqualTo("/en/admin/ai-tutor/messages");
        assertThat(chat.attr("data-conversations-url")).isEqualTo("/en/admin/ai-tutor/conversations");
        assertThat(chat.hasAttr("data-topic-slug")).isFalse();
        assertThat(chat.attr("data-msg-not-saved")).contains("could not be saved");
        assertThat(chat.attr("data-msg-turns-remaining")).contains("{0}");

        // CSRF: token + başlık adı meta etiketlerinde (ai-tutor.js bunları başlık olarak gönderir).
        assertThat(doc.selectFirst("meta[name=_csrf]").attr("content")).isNotBlank();
        assertThat(doc.selectFirst("meta[name=_csrf_header]").attr("content")).isEqualTo("X-CSRF-TOKEN");
        assertThat(doc.select("script[src^=\"/js/ai-tutor\"]")).hasSize(1);

        // Erişilebilirlik: etiketli alanlar, canlı bölge, sınırlı uzunluk.
        Element input = doc.selectFirst("textarea#ai-tutor-input");
        assertThat(input.attr("maxlength")).isEqualTo("4000");
        assertThat(doc.select("label[for=ai-tutor-input]")).hasSize(1);
        assertThat(doc.select("label[for=ai-tutor-topic]")).hasSize(1);
        assertThat(doc.selectFirst(".ai-tutor-messages").attr("aria-live")).isEqualTo("polite");
        assertThat(doc.selectFirst(".ai-tutor-status").attr("role")).isEqualTo("status");
        assertThat(doc.selectFirst(".ai-tutor-delete").hasAttr("disabled")).isTrue();

        // Ders listesi yalnızca yayındaki derslerden; varsayılan "ders yok".
        assertThat(doc.select("#ai-tutor-topic option[value=enum]")).hasSize(1);
        assertThat(doc.selectFirst("#ai-tutor-topic option[selected]")).isNull();
        assertThat(doc.selectFirst("meta[name=robots]").attr("content")).contains("noindex");
        verifyNoInteractions(client);
    }

    @Test
    void selectedLessonIsPassedAsSlugAndShown() throws Exception {
        Document doc = page(login(Role.ADMIN), "/en/admin/ai-tutor?topic=enum");

        assertThat(doc.selectFirst("section.ai-tutor").attr("data-topic-slug")).isEqualTo("enum");
        assertThat(doc.selectFirst("#ai-tutor-topic option[selected]").attr("value")).isEqualTo("enum");
        assertThat(doc.select(".badge").text()).startsWith("Using lesson:");
        // Diğer dile geçiş aynı dersi korur.
        assertThat(doc.select("a[href=\"/tr/admin/ai-tutor?topic=enum\"]")).hasSize(1);
    }

    @Test
    void unknownLessonFallsBackToGeneralQuestions() throws Exception {
        Document doc = page(login(Role.ADMIN), "/en/admin/ai-tutor?topic=no-such-topic");

        assertThat(doc.selectFirst("section.ai-tutor").hasAttr("data-topic-slug")).isFalse();
        assertThat(doc.select(".alert-warning[role=alert]").text()).contains("not found");
        // İstenen değer sayfaya geri yansıtılmaz.
        assertThat(doc.html()).doesNotContain("no-such-topic");
    }

    @Test
    void turkishPageUsesTurkishTextsAndEndpoints() throws Exception {
        Document doc = page(login(Role.ADMIN), "/tr/admin/ai-tutor");

        assertThat(doc.selectFirst("html").attr("lang")).isEqualTo("tr");
        Element chat = doc.selectFirst("section.ai-tutor");
        assertThat(chat.attr("data-messages-url")).isEqualTo("/tr/admin/ai-tutor/messages");
        assertThat(doc.selectFirst("label[for=ai-tutor-input]").text()).isEqualTo("Sorunuz");
        assertThat(doc.select("a[href=\"/en/admin/ai-tutor\"]").text()).isEqualTo("English");
    }

    @Test
    void sidebarLinkIsOnlyRenderedForAdmins() throws Exception {
        String adminHome = mockMvc.perform(get("/en").session(login(Role.ADMIN)))
                .andExpect(status().isOk()).andReturn().getResponse().getContentAsString();
        String userHome = mockMvc.perform(get("/en").session(login(Role.USER)))
                .andExpect(status().isOk()).andReturn().getResponse().getContentAsString();
        String anonymousHome = mockMvc.perform(get("/en"))
                .andExpect(status().isOk()).andReturn().getResponse().getContentAsString();

        assertThat(Jsoup.parse(adminHome).select("a[href=\"/en/admin/ai-tutor\"]")).hasSize(1);
        assertThat(userHome).doesNotContain("/admin/ai-tutor").doesNotContain("/js/ai-tutor");
        assertThat(anonymousHome).doesNotContain("/admin/ai-tutor").doesNotContain("/js/ai-tutor");
    }

    // --- ders sayfası paneli (adım 11) ---

    private static void assertLessonPageStillWorks(Document doc) {
        // Mevcut ders özellikleri: içerik, sabit quiz, kod renklendirme, quiz.js, sağdaki TOC.
        assertThat(doc.select("article.markdown-content pre code")).isNotEmpty();
        assertThat(doc.select("#quiz-section")).hasSize(1);
        assertThat(doc.select("script[src^=\"/js/quiz\"]")).hasSize(1);
        assertThat(doc.select("script:containsData(hljs.highlightAll)")).hasSize(1);
        assertThat(doc.select("nav.toc-sticky")).hasSize(1);
        assertThat(doc.select("#sidebarOffcanvas")).hasSize(1);
    }

    private static void assertNoTutor(Document doc) {
        assertThat(doc.select("#aiTutorPanel, .ai-tutor-open, section.ai-tutor")).isEmpty();
        assertThat(doc.select("script[src^=\"/js/ai-tutor\"], meta[name=_csrf], meta[name=_csrf_header]")).isEmpty();
    }

    @Test
    void lessonPageHasNoTutorForAnonymousOrRegularUsers() throws Exception {
        Document anonymous = Jsoup.parse(mockMvc.perform(get("/en/topics/enum"))
                .andExpect(status().isOk()).andReturn().getResponse().getContentAsString());
        Document user = page(login(Role.USER), "/en/topics/enum");

        assertNoTutor(anonymous);
        assertNoTutor(user);
        assertLessonPageStillWorks(anonymous);
        assertLessonPageStillWorks(user);
    }

    @Test
    void adminLessonPageOpensTheSharedChatWithThisLessonAndLanguage() throws Exception {
        Document doc = page(login(Role.ADMIN), "/en/topics/enum");

        Element button = doc.selectFirst("button.ai-tutor-open");
        assertThat(button.attr("data-bs-toggle")).isEqualTo("offcanvas");
        assertThat(button.attr("data-bs-target")).isEqualTo("#aiTutorPanel");
        Element panel = doc.selectFirst("#aiTutorPanel.offcanvas.offcanvas-end");
        assertThat(panel.attr("aria-labelledby")).isEqualTo("aiTutorPanelLabel");
        assertThat(panel.select(".badge").text()).isEqualTo("Using lesson: " + doc.selectFirst("h1").text());

        Element chat = panel.selectFirst("section.ai-tutor");
        assertThat(chat.attr("data-topic-slug")).isEqualTo("enum");
        assertThat(chat.attr("data-messages-url")).isEqualTo("/en/admin/ai-tutor/messages");
        assertThat(chat.attr("data-conversations-url")).isEqualTo("/en/admin/ai-tutor/conversations");
        assertThat(doc.select("#ai-tutor-input")).hasSize(1);

        assertThat(doc.selectFirst("meta[name=_csrf]").attr("content")).isNotBlank();
        assertThat(doc.selectFirst("meta[name=_csrf_header]").attr("content")).isEqualTo("X-CSRF-TOKEN");
        assertThat(doc.select("script[src^=\"/js/ai-tutor\"]")).hasSize(1);
        assertLessonPageStillWorks(doc);
        verifyNoInteractions(client);
    }

    @Test
    void turkishLessonPageUsesTurkishTextsAndEndpoints() throws Exception {
        Document doc = page(login(Role.ADMIN), "/tr/topics/enum");

        assertThat(doc.selectFirst("button.ai-tutor-open").text()).isEqualTo("AI Tutor'a sor");
        Element chat = doc.selectFirst("#aiTutorPanel section.ai-tutor");
        assertThat(chat.attr("data-topic-slug")).isEqualTo("enum");
        assertThat(chat.attr("data-messages-url")).isEqualTo("/tr/admin/ai-tutor/messages");
        assertThat(doc.selectFirst("#aiTutorPanel .badge").text()).startsWith("Kullanılan ders: ");
    }

    @Test
    void unpublishedLessonHasNoTutorPanel() throws Exception {
        List<String> drafts = jdbc.queryForList("""
                SELECT t.slug FROM topic t
                JOIN topic_translation tt ON tt.topic_id = t.id
                WHERE tt.language = 'en' AND tt.published = false
                ORDER BY t.slug LIMIT 1""", String.class);
        Assumptions.assumeFalse(drafts.isEmpty(), "test DB has no unpublished EN translation");

        Document doc = page(login(Role.ADMIN), "/en/topics/" + drafts.getFirst());

        assertNoTutor(doc);
    }
}
