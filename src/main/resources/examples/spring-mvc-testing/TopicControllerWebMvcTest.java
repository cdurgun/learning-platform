import com.cdurgun.learning.controller.TopicController;
import com.cdurgun.learning.domain.Category;
import com.cdurgun.learning.domain.Course;
import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.Topic;
import com.cdurgun.learning.domain.TopicTranslation;
import com.cdurgun.learning.repository.TopicRepository;
import com.cdurgun.learning.repository.TopicTranslationRepository;
import com.cdurgun.learning.service.ContentResolver;
import com.cdurgun.learning.service.MarkdownService;
import com.cdurgun.learning.service.NavigationService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.context.MessageSource;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;

// @WebMvcTest for this project's ACTUAL TopicController -- ALL 6 dependencies are
// mocked with @MockitoBean (see TopicController's constructor). TopicTestFixtures is
// used to produce this test's fixtures (Course/Category/Topic/TopicTranslation).
// Since Phase 64, the controller has had two mappings: `/{lang:en|tr}/topics/{slug}`
// (the real content) and `/topics/{slug}`, which permanently redirects legacy `?lang=`
// URLs (part of the move to a path-based URL structure for SEO reasons) -- since both
// live in the same controller, a single @WebMvcTest slice can test both.
@WebMvcTest(TopicController.class)
class TopicControllerWebMvcTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private TopicRepository topicRepository;
    @MockitoBean
    private TopicTranslationRepository topicTranslationRepository;
    @MockitoBean
    private ContentResolver contentResolver;
    @MockitoBean
    private MarkdownService markdownService;
    @MockitoBean
    private NavigationService navigationService;
    @MockitoBean
    private MessageSource messageSource;

    @Test
    void unknownSlugReturns404() throws Exception {
        when(topicRepository.findBySlugWithCategoryAndCourse("does-not-exist"))
                .thenReturn(Optional.empty());

        // See in the controller code: ResponseStatusException(HttpStatus.NOT_FOUND, ...) --
        // even without a real @ControllerAdvice, Spring's default exception resolution
        // converts ResponseStatusException to the correct HTTP status.
        mockMvc.perform(get("/en/topics/does-not-exist"))
                .andExpect(status().isNotFound());
    }

    @Test
    void legacyQueryParamUrlRedirectsPermanentlyToPathBasedUrl() throws Exception {
        // Pre-Phase-64 `/topics/{slug}?lang=..` URLs no longer render, they now
        // 301 (permanently) redirect to the new `/{lang}/topics/{slug}` address -- since
        // this controller method doesn't touch any repository/service, there's no need
        // to set up a mock here. `redirectedUrl(...)` is a matcher that directly verifies
        // the Location header.
        mockMvc.perform(get("/topics/spring-mvc-testing").param("lang", "tr"))
                .andExpect(status().isMovedPermanently())
                .andExpect(redirectedUrl("/tr/topics/spring-mvc-testing"));
    }

    @Test
    void publishedTopicRendersWithContent() throws Exception {
        Course course = TopicTestFixtures.sampleCourse();
        Category category = TopicTestFixtures.sampleCategory(course);
        Topic topic = TopicTestFixtures.sampleTopic(category);
        TopicTranslation trTranslation = TopicTestFixtures.sampleTranslation(topic, Language.TR, true);

        when(topicRepository.findBySlugWithCategoryAndCourse("spring-mvc-testing"))
                .thenReturn(Optional.of(topic));
        when(topicTranslationRepository.findByTopicIdAndLanguage(topic.getId(), Language.TR))
                .thenReturn(Optional.of(trTranslation));
        when(topicTranslationRepository.findByTopicIdAndLanguage(topic.getId(), Language.EN))
                .thenReturn(Optional.empty());
        when(contentResolver.resolve(eq("spring-mvc-testing"), eq(Language.TR)))
                .thenReturn(Optional.of("# Spring MVC'de Test Yazmak\n\nIcerik burada."));
        when(markdownService.render(any(), eq("spring-mvc-testing")))
                .thenReturn(new MarkdownService.MarkdownRenderResult("<h1>Spring MVC'de Test Yazmak</h1>", List.of()));
        when(navigationService.buildNavigation(Language.TR)).thenReturn(List.of());
        when(navigationService.buildCourseSequence(course.getId(), Language.TR)).thenReturn(List.of());

        // Language is now part of the URL path instead of `?lang=` -- a `/tr/...`
        // request targets Language.TR directly, independent of the environment/default
        // locale.
        mockMvc.perform(get("/tr/topics/spring-mvc-testing"))
                .andExpect(status().isOk())
                .andExpect(view().name("topic"))
                .andExpect(model().attribute("contentAvailable", true))
                .andExpect(model().attribute("otherLanguageAvailable", false));

        // Note: every value mocked here is of the same type that TopicController gets
        // from real services in PRODUCTION (a real Topic, a real MarkdownRenderResult
        // record) -- so templates/topic.html renders normally, as if it were handling
        // a real request.
    }
}
