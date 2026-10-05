package com.cdurgun.learning.config;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.QuestionOption;
import com.cdurgun.learning.domain.Role;
import com.cdurgun.learning.domain.User;
import com.cdurgun.learning.repository.CourseRepository;
import com.cdurgun.learning.repository.QuestionOptionRepository;
import com.cdurgun.learning.repository.QuestionRepository;
import com.cdurgun.learning.repository.UserRepository;
import com.cdurgun.learning.service.QuizService;
import com.cdurgun.learning.web.quiz.QuizQuestionView;
import com.jayway.jsonpath.JsonPath;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

import static org.assertj.core.api.Assertions.assertThat;
import static org.hamcrest.Matchers.containsString;
import static org.hamcrest.Matchers.endsWith;
import static org.hamcrest.Matchers.not;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * Course seviyesi erişim kuralı ({@link CourseAccessPolicy}) -- ders içeriği (topic
 * sayfası/PDF) tüm kurslarda herkese açık; quiz'ler ve Practice için anonim: yalnızca
 * Java, girişli: tüm kurslar. Gerçek güvenlik zinciri + gerçek Flyway verisiyle, her
 * giriş noktası için (topic sayfası/PDF/eski URL, sabit quiz submit, Quiz Area,
 * Practice, navigasyon, sitemap). Korunan sayfa GET'leri login'e 302, korunan JSON uç
 * noktaları yönlendirmesiz, gövdesiz 401 bekler -- gövdede doğru cevap/açıklama/skor
 * OLMAMALI.
 *
 * <p>Fixture'lar gerçek seed verisinden: {@code enum} (Java) ve
 * {@code dependency-injection} (Spring Boot) topic'leri, ikisinin de {@code default}
 * sabit quiz'i; {@code basic-java} ve {@code spring-core} Quiz Area tanımları.</p>
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class CourseAccessControlTest {

    private static final String JAVA_TOPIC = "enum";
    private static final String SPRING_TOPIC = "dependency-injection";
    private static final String JAVA_QUIZ_DEFINITION = "basic-java";
    private static final String SPRING_QUIZ_DEFINITION = "spring-core";

    @Autowired
    private MockMvc mockMvc;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private PasswordEncoder passwordEncoder;
    @Autowired
    private QuizService quizService;
    @Autowired
    private CourseRepository courseRepository;
    @Autowired
    private QuestionRepository questionRepository;
    @Autowired
    private QuestionOptionRepository questionOptionRepository;

    // ---- yardımcılar ----

    private MockHttpSession loggedInSession() throws Exception {
        String email = "course-access-" + UUID.randomUUID() + "@example.com";
        userRepository.save(User.builder()
                .email(email)
                .passwordHash(passwordEncoder.encode("correct-password"))
                .displayName("Course Access Tester")
                .role(Role.USER)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build());
        return (MockHttpSession) mockMvc.perform(post("/en/login")
                        .param("username", email)
                        .param("password", "correct-password")
                        .with(csrf()))
                .andExpect(status().is3xxRedirection())
                .andReturn().getRequest().getSession(false);
    }

    /** Sabit quiz'in TÜM soruları için (sözleşme bunu şart koşuyor) ilk şıkkı seçen gövde. */
    private String fixedQuizBody(String topicSlug) {
        Long quizId = quizService.resolveQuiz(topicSlug, Language.EN, "default").orElseThrow().id();
        List<QuizQuestionView> questions = quizService.loadQuiz(quizId);
        return answersJson(questions.stream()
                .collect(Collectors.toMap(QuizQuestionView::id, q -> q.options().get(0).id())));
    }

    /** Verilen kursun havuzundan gerçek PUBLISHED EN soru(lar) için ilk şıkkı seçen gövde. */
    private String poolBody(String courseSlug, int count) {
        Long courseId = courseRepository.findBySlug(courseSlug).orElseThrow().getId();
        List<Long> questionIds = questionRepository
                .findRandomPublishedPoolByCourseAndCategories(courseId, null, "en", null, null, count)
                .stream().map(q -> q.getId()).toList();
        assertThat(questionIds).isNotEmpty();
        Map<Long, Long> firstOptionByQuestion = questionOptionRepository
                .findByQuestionIdInOrderBySortOrderAsc(questionIds).stream()
                .collect(Collectors.toMap(o -> o.getQuestion().getId(), QuestionOption::getId, (a, b) -> a));
        return answersJson(firstOptionByQuestion);
    }

    private static String answersJson(Map<Long, Long> optionByQuestion) {
        return optionByQuestion.entrySet().stream()
                .map(e -> "{\"questionId\":" + e.getKey() + ",\"selectedOptionIds\":[" + e.getValue() + "]}")
                .collect(Collectors.joining(",", "{\"answers\":[", "]}"));
    }

    private ResultActions postJson(String url, String body, MockHttpSession session) throws Exception {
        var request = post(url).contentType(MediaType.APPLICATION_JSON).content(body);
        return mockMvc.perform(session == null ? request : request.session(session));
    }

    /** Korunan JSON uç noktası: 401, yönlendirme yok, gövde boş (cevap/açıklama/skor sızmaz). */
    private static void assertUnauthorizedWithoutLeak(ResultActions result) throws Exception {
        result.andExpect(status().isUnauthorized())
                .andExpect(header().doesNotExist("Location"))
                .andExpect(content().string(""));
    }

    private static void assertRedirectsToLogin(ResultActions result) throws Exception {
        result.andExpect(status().isFound())
                .andExpect(header().string("Location", endsWith("/en/login")));
    }

    // ---- topic sayfası / PDF / eski URL ----

    @Test
    void anonymousCanAccessJavaTopic() throws Exception {
        mockMvc.perform(get("/en/topics/" + JAVA_TOPIC)).andExpect(status().isOk());
        mockMvc.perform(get("/tr/topics/" + JAVA_TOPIC)).andExpect(status().isOk());
    }

    @Test
    void anonymousCanReadNonJavaTopicPageAndPdf() throws Exception {
        mockMvc.perform(get("/en/topics/" + SPRING_TOPIC)).andExpect(status().isOk());
        mockMvc.perform(get("/tr/topics/" + SPRING_TOPIC)).andExpect(status().isOk());
        mockMvc.perform(get("/en/topics/" + SPRING_TOPIC + "/pdf")).andExpect(status().isOk());
    }

    @Test
    void anonymousNonJavaTopicPageShowsSignInPromptInsteadOfQuiz() throws Exception {
        mockMvc.perform(get("/en/topics/" + SPRING_TOPIC))
                .andExpect(content().string(containsString("Sign in to take the quiz for this lesson.")))
                .andExpect(content().string(not(containsString("id=\"quiz-section\""))));
        mockMvc.perform(get("/en/topics/" + JAVA_TOPIC))
                .andExpect(content().string(containsString("id=\"quiz-section\"")));
        mockMvc.perform(get("/en/topics/" + SPRING_TOPIC).session(loggedInSession()))
                .andExpect(content().string(containsString("id=\"quiz-section\"")))
                .andExpect(content().string(not(containsString("Sign in to take the quiz for this lesson."))));
    }

    @Test
    void topicPageTitleIsRenderedFromTranslation() throws Exception {
        mockMvc.perform(get("/en/topics/" + JAVA_TOPIC))
                .andExpect(content().string(not(containsString("<title>translation.seoTitle"))))
                .andExpect(content().string(containsString(" | LearnForgeX</title>")));
    }

    @Test
    void authenticatedUserCanAccessJavaAndNonJavaTopics() throws Exception {
        MockHttpSession session = loggedInSession();
        mockMvc.perform(get("/en/topics/" + JAVA_TOPIC).session(session)).andExpect(status().isOk());
        mockMvc.perform(get("/en/topics/" + SPRING_TOPIC).session(session)).andExpect(status().isOk());
    }

    @Test
    void unknownTopicSlugStillReturns404ForAnonymous() throws Exception {
        mockMvc.perform(get("/en/topics/does-not-exist")).andExpect(status().isNotFound());
    }

    // ---- sabit topic quiz submit ----

    @Test
    void anonymousFixedQuizSubmitOnNonJavaTopicIsUnauthorized() throws Exception {
        assertUnauthorizedWithoutLeak(postJson(
                "/en/topics/" + SPRING_TOPIC + "/quiz/default/submit", fixedQuizBody(SPRING_TOPIC), null));
    }

    @Test
    void anonymousFixedQuizSubmitOnJavaTopicStillWorks() throws Exception {
        postJson("/en/topics/" + JAVA_TOPIC + "/quiz/default/submit", fixedQuizBody(JAVA_TOPIC), null)
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.results").isArray());
    }

    @Test
    void authenticatedFixedQuizSubmitOnNonJavaTopicWorks() throws Exception {
        postJson("/en/topics/" + SPRING_TOPIC + "/quiz/default/submit", fixedQuizBody(SPRING_TOPIC), loggedInSession())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.results").isArray());
    }

    // ---- Quiz Area ----

    @Test
    void anonymousQuizAreaJavaIsAccessibleButNonJavaIsNot() throws Exception {
        mockMvc.perform(get("/en/quiz")).andExpect(status().isOk());
        mockMvc.perform(get("/en/quiz/" + JAVA_QUIZ_DEFINITION)).andExpect(status().isOk());
        assertRedirectsToLogin(mockMvc.perform(get("/en/quiz/" + SPRING_QUIZ_DEFINITION)));
        assertUnauthorizedWithoutLeak(postJson(
                "/en/quiz/" + SPRING_QUIZ_DEFINITION + "/submit", poolBody("spring-boot", 3), null));
    }

    @Test
    void anonymousCannotBypassViaJavaQuizAreaSubmitWithNonJavaQuestionIds() throws Exception {
        assertUnauthorizedWithoutLeak(postJson(
                "/en/quiz/" + JAVA_QUIZ_DEFINITION + "/submit", poolBody("spring-boot", 3), null));
    }

    @Test
    void anonymousJavaQuizAreaSubmitStillWorks() throws Exception {
        postJson("/en/quiz/" + JAVA_QUIZ_DEFINITION + "/submit", poolBody("java", 3), null)
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.results").isArray());
    }

    @Test
    void authenticatedQuizAreaNonJavaWorks() throws Exception {
        MockHttpSession session = loggedInSession();
        mockMvc.perform(get("/en/quiz/" + SPRING_QUIZ_DEFINITION).session(session)).andExpect(status().isOk());
        postJson("/en/quiz/" + SPRING_QUIZ_DEFINITION + "/submit", poolBody("spring-boot", 3), session)
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.results").isArray());
    }

    // ---- Practice ----

    @Test
    void anonymousPracticeDrawWithoutFilterOnlyReturnsJavaQuestions() throws Exception {
        String json = mockMvc.perform(get("/en/practice").param("count", "50"))
                .andExpect(status().isOk())
                .andReturn().getResponse().getContentAsString();
        List<Integer> ids = JsonPath.read(json, "$[*].id");
        assertThat(ids).isNotEmpty();
        assertThat(questionRepository.findDistinctCourseSlugsByQuestionIds(
                ids.stream().map(Integer::longValue).toList())).containsExactly("java");
    }

    @Test
    void anonymousPracticeDrawForNonJavaTopicIsUnauthorized() throws Exception {
        assertUnauthorizedWithoutLeak(mockMvc.perform(get("/en/practice").param("topic", SPRING_TOPIC)));
        mockMvc.perform(get("/en/practice").param("topic", JAVA_TOPIC)).andExpect(status().isOk());
    }

    @Test
    void anonymousPracticeSubmitWithNonJavaQuestionIdsIsUnauthorized() throws Exception {
        assertUnauthorizedWithoutLeak(postJson("/en/practice/submit", poolBody("spring-boot", 3), null));
    }

    @Test
    void anonymousPracticeSubmitWithJavaQuestionIdsStillWorks() throws Exception {
        postJson("/en/practice/submit", poolBody("java", 3), null)
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.results").isArray());
    }

    @Test
    void authenticatedPracticeCoversNonJavaContent() throws Exception {
        MockHttpSession session = loggedInSession();
        mockMvc.perform(get("/en/practice").param("topic", SPRING_TOPIC).session(session))
                .andExpect(status().isOk());
        postJson("/en/practice/submit", poolBody("spring-boot", 3), session)
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.results").isArray());
    }

    // ---- navigasyon ----

    @Test
    void loggedOutNavigationLinksAllCourseTopicsButKeepsNonJavaQuizzesDisabled() throws Exception {
        mockMvc.perform(get("/en"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("href=\"/en/topics/" + JAVA_TOPIC + "\"")))
                .andExpect(content().string(containsString("href=\"/en/topics/" + SPRING_TOPIC + "\"")));

        mockMvc.perform(get("/en/quiz"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("href=\"/en/quiz/" + JAVA_QUIZ_DEFINITION + "\"")))
                .andExpect(content().string(not(containsString("href=\"/en/quiz/" + SPRING_QUIZ_DEFINITION + "\""))))
                .andExpect(content().string(containsString("Sign in to access")));
    }

    @Test
    void loggedInNavigationShowsProtectedCoursesEnabled() throws Exception {
        MockHttpSession session = loggedInSession();
        mockMvc.perform(get("/en").session(session))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("href=\"/en/topics/" + JAVA_TOPIC + "\"")))
                .andExpect(content().string(containsString("href=\"/en/topics/" + SPRING_TOPIC + "\"")));

        mockMvc.perform(get("/en/quiz").session(session))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("href=\"/en/quiz/" + SPRING_QUIZ_DEFINITION + "\"")))
                .andExpect(content().string(not(containsString("Sign in to access"))));
    }

    // ---- sitemap ----

    @Test
    void sitemapListsTopicsOfAllCourses() throws Exception {
        mockMvc.perform(get("/sitemap.xml"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("/en/topics/" + JAVA_TOPIC + "</loc>")))
                .andExpect(content().string(containsString("/en/topics/" + SPRING_TOPIC + "</loc>")));
    }
}
