package com.cdurgun.learning.controller;

import com.cdurgun.learning.domain.Difficulty;
import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.Question;
import com.cdurgun.learning.domain.QuestionOption;
import com.cdurgun.learning.domain.QuestionSource;
import com.cdurgun.learning.domain.QuestionStatus;
import com.cdurgun.learning.domain.QuestionType;
import com.cdurgun.learning.domain.Role;
import com.cdurgun.learning.domain.Topic;
import com.cdurgun.learning.domain.User;
import com.cdurgun.learning.repository.QuestionOptionRepository;
import com.cdurgun.learning.repository.QuestionRepository;
import com.cdurgun.learning.repository.TopicRepository;
import com.cdurgun.learning.repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * Faz B (listeleme) + Faz C (Publish/Reject) -- review ekranının gerçek İÇERİĞİ VE
 * durum geçişleri (yalnızca yetkilendirme değil, bkz. {@code AdminAuthorizationTest}
 * o sınırı test ediyor). {@code @Transactional} BİLİNÇLİ OLARAK eklendi -- MockMvc
 * üzerinden eklenen fixture {@code Question}/{@code QuestionOption} satırları test
 * sonunda GERİ ALINMALI, aksi halde "kaç pending soru var" gibi sayı-bağımlı testler
 * sonraki test çalıştırmalarında birikip kırılırdı (bu projenin diğer testlerinin --
 * örn. {@code AuthenticationFlowTest} -- kalıcı bıraktığı `User` satırlarından
 * FARKLI olarak, buradaki satırlar sayılabilir/karşılaştırılabilir durumu
 * etkiliyor).
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class QuestionReviewControllerTest {

    @Autowired
    private MockMvc mockMvc;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private PasswordEncoder passwordEncoder;
    @Autowired
    private TopicRepository topicRepository;
    @Autowired
    private QuestionRepository questionRepository;
    @Autowired
    private QuestionOptionRepository questionOptionRepository;

    private MockHttpSession loginAsNewAdmin() throws Exception {
        return loginAsNewAdmin("review-admin-" + UUID.randomUUID() + "@example.com");
    }

    @Test
    void pendingQuestionIsListedWithCorrectAnswerVisibleAndActionFormsPresent() throws Exception {
        Question question = fixturePendingQuestion();
        MockHttpSession session = loginAsNewAdmin();

        mockMvc.perform(get("/en/admin/questions").session(session))
                .andExpect(status().isOk())
                .andExpect(content().string(org.hamcrest.Matchers.allOf(
                        org.hamcrest.Matchers.containsString("QuestionReviewControllerTest fixture question?"),
                        org.hamcrest.Matchers.containsString("Correct fixture option"),
                        org.hamcrest.Matchers.containsString("Wrong fixture option"),
                        org.hamcrest.Matchers.containsString("QuestionReviewControllerTest fixture explanation."),
                        org.hamcrest.Matchers.containsString("PENDING_REVIEW"),
                        org.hamcrest.Matchers.containsString("/en/admin/questions/" + question.getId() + "/publish"),
                        org.hamcrest.Matchers.containsString("/en/admin/questions/" + question.getId() + "/reject"))));
    }

    @Test
    void noPendingQuestionsShowsEmptyState() throws Exception {
        MockHttpSession session = loginAsNewAdmin();

        mockMvc.perform(get("/en/admin/questions").session(session))
                .andExpect(status().isOk())
                .andExpect(content().string(org.hamcrest.Matchers.containsString("Pending Questions: 0")));
    }

    // ---- Faz C: Publish/Reject durum geçişleri ----

    @Test
    void adminCanPublishPendingQuestionAndItBecomesEligibleForPublicPool() throws Exception {
        Question question = fixturePendingQuestion();
        String adminEmail = "publish-admin-" + UUID.randomUUID() + "@example.com";
        MockHttpSession session = loginAsNewAdmin(adminEmail);

        mockMvc.perform(post("/en/admin/questions/" + question.getId() + "/publish").session(session).with(csrf()))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/en/admin/questions"));

        Question reloaded = questionRepository.findById(question.getId()).orElseThrow();
        assertThat(reloaded.getStatus()).isEqualTo(QuestionStatus.PUBLISHED);
        assertThat(reloaded.getReviewedBy()).isEqualTo(adminEmail);
        assertThat(reloaded.getReviewedAt()).isNotNull();

        // "Yayınlandıktan sonra public quiz havuzunda uygun hale gelmeli" -- var olan,
        // hiç dokunulmayan pool sorgusuyla GERÇEKTEN doğrulanıyor (status='PUBLISHED'
        // sabit yazılı filtre, publish() burada hiçbir ek "public'e ekle" adımı
        // GEREKTİRMEDİ).
        List<Question> pool = questionRepository.findRandomPublishedPool(
                question.getTopic().getId(), "en", null, null, 100);
        assertThat(pool).extracting(Question::getId).contains(question.getId());
    }

    @Test
    void adminCanRejectPendingQuestionAndItStaysExcludedFromPublicPool() throws Exception {
        Question question = fixturePendingQuestion();
        String adminEmail = "reject-admin-" + UUID.randomUUID() + "@example.com";
        MockHttpSession session = loginAsNewAdmin(adminEmail);

        mockMvc.perform(post("/en/admin/questions/" + question.getId() + "/reject").session(session).with(csrf()))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/en/admin/questions"));

        Question reloaded = questionRepository.findById(question.getId()).orElseThrow();
        assertThat(reloaded.getStatus()).isEqualTo(QuestionStatus.REJECTED);
        assertThat(reloaded.getReviewedBy()).isEqualTo(adminEmail);
        assertThat(reloaded.getReviewedAt()).isNotNull();

        List<Question> pool = questionRepository.findRandomPublishedPool(
                question.getTopic().getId(), "en", null, null, 100);
        assertThat(pool).extracting(Question::getId).doesNotContain(question.getId());
    }

    @Test
    void publishingAlreadyPublishedQuestionIsRejectedWithConflict() throws Exception {
        Question question = fixtureQuestionWithStatus(QuestionStatus.PUBLISHED);
        MockHttpSession session = loginAsNewAdmin();

        mockMvc.perform(post("/en/admin/questions/" + question.getId() + "/publish").session(session).with(csrf()))
                .andExpect(status().isConflict());

        assertThat(questionRepository.findById(question.getId()).orElseThrow().getStatus())
                .isEqualTo(QuestionStatus.PUBLISHED);
    }

    @Test
    void rejectingAlreadyRejectedQuestionIsRejectedWithConflict() throws Exception {
        Question question = fixtureQuestionWithStatus(QuestionStatus.REJECTED);
        MockHttpSession session = loginAsNewAdmin();

        mockMvc.perform(post("/en/admin/questions/" + question.getId() + "/reject").session(session).with(csrf()))
                .andExpect(status().isConflict());

        assertThat(questionRepository.findById(question.getId()).orElseThrow().getStatus())
                .isEqualTo(QuestionStatus.REJECTED);
    }

    @Test
    void normalUserCannotPublishOrReject() throws Exception {
        Question question = fixturePendingQuestion();
        String email = "review-user-" + UUID.randomUUID() + "@example.com";
        User user = User.builder()
                .email(email)
                .passwordHash(passwordEncoder.encode("correct-password"))
                .displayName("Review Test User")
                .role(Role.USER)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();
        userRepository.save(user);
        MvcResult loginResult = mockMvc.perform(post("/en/login")
                        .param("username", email)
                        .param("password", "correct-password")
                        .with(csrf()))
                .andExpect(status().is3xxRedirection())
                .andReturn();
        MockHttpSession session = (MockHttpSession) loginResult.getRequest().getSession(false);

        mockMvc.perform(post("/en/admin/questions/" + question.getId() + "/publish").session(session).with(csrf()))
                .andExpect(status().isForbidden());

        assertThat(questionRepository.findById(question.getId()).orElseThrow().getStatus())
                .isEqualTo(QuestionStatus.PENDING_REVIEW);
    }

    @Test
    void anonymousCannotPublishOrReject() throws Exception {
        Question question = fixturePendingQuestion();

        mockMvc.perform(post("/en/admin/questions/" + question.getId() + "/publish").with(csrf()))
                .andExpect(status().is3xxRedirection());

        assertThat(questionRepository.findById(question.getId()).orElseThrow().getStatus())
                .isEqualTo(QuestionStatus.PENDING_REVIEW);
    }

    private MockHttpSession loginAsNewAdmin(String email) throws Exception {
        User admin = User.builder()
                .email(email)
                .passwordHash(passwordEncoder.encode("correct-password"))
                .displayName("Review Admin")
                .role(Role.ADMIN)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();
        userRepository.save(admin);

        MvcResult result = mockMvc.perform(post("/en/login")
                        .param("username", email)
                        .param("password", "correct-password")
                        .with(csrf()))
                .andExpect(status().is3xxRedirection())
                .andReturn();
        HttpSession session = result.getRequest().getSession(false);
        return (MockHttpSession) session;
    }

    private Question fixturePendingQuestion() {
        return fixtureQuestionWithStatus(QuestionStatus.PENDING_REVIEW);
    }

    private Question fixtureQuestionWithStatus(QuestionStatus status) {
        Topic enumTopic = topicRepository.findBySlug("enum").orElseThrow();

        Question question = Question.builder()
                .topic(enumTopic)
                .language(Language.EN)
                .type(QuestionType.SINGLE_CHOICE)
                .difficulty(Difficulty.BEGINNER)
                .status(status)
                .source(QuestionSource.MANUAL)
                .question("QuestionReviewControllerTest fixture question?")
                .explanation("QuestionReviewControllerTest fixture explanation.")
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();
        question = questionRepository.save(question);

        questionOptionRepository.save(QuestionOption.builder()
                .question(question).optionText("Correct fixture option").correct(true).sortOrder(0).build());
        questionOptionRepository.save(QuestionOption.builder()
                .question(question).optionText("Wrong fixture option").correct(false).sortOrder(1).build());

        return question;
    }
}
