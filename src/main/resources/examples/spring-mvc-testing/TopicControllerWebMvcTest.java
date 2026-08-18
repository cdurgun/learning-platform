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

// Bu projenin GERÇEK TopicController'ı için @WebMvcTest -- 6 bağımlılığın TAMAMI
// @MockitoBean ile sahtelenir (bkz. TopicController'ın constructor'ı). TopicTestFixtures
// bu testin fixture'larını (Course/Category/Topic/TopicTranslation) üretmek için kullanılıyor.
// Faz 64'ten beri controller'da iki mapping var: `/{lang:en|tr}/topics/{slug}` (gerçek
// içerik) ve eski `?lang=` URL'lerini kalıcı olarak yönlendiren `/topics/{slug}` (SEO
// gerekçesiyle path-bazlı URL yapısına geçişin bir parçası) -- ikisi de aynı
// controller'da yaşadığı için tek @WebMvcTest slice'ı ikisini de test edebiliyor.
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

        // Controller kodunda bkz: ResponseStatusException(HttpStatus.NOT_FOUND, ...) --
        // gerçek bir @ControllerAdvice olmadan bile, Spring'in varsayılan exception
        // çözümü ResponseStatusException'ı doğru HTTP durumuna çevirir.
        mockMvc.perform(get("/en/topics/does-not-exist"))
                .andExpect(status().isNotFound());
    }

    @Test
    void legacyQueryParamUrlRedirectsPermanentlyToPathBasedUrl() throws Exception {
        // Faz 64 öncesinin `/topics/{slug}?lang=..` URL'leri artık render etmiyor,
        // yeni `/{lang}/topics/{slug}` adresine 301 (kalıcı) yönlendiriyor -- bu
        // controller metodu hiçbir repository/servise dokunmadığı için burada mock
        // kurmaya gerek yok. `redirectedUrl(...)`, Location header'ını doğrudan
        // doğrulayan bir matcher.
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

        // Dil artık `?lang=` yerine URL path'inin bir parçası -- `/tr/...` isteği
        // doğrudan Language.TR'yi hedefliyor, ortam/varsayılan locale'e bağlı değil.
        mockMvc.perform(get("/tr/topics/spring-mvc-testing"))
                .andExpect(status().isOk())
                .andExpect(view().name("topic"))
                .andExpect(model().attribute("contentAvailable", true))
                .andExpect(model().attribute("otherLanguageAvailable", false));

        // Not: burada mock'lanan her değer, TopicController'ın PRODUCTION'da gerçek
        // servislerden aldığı değerlerle aynı tiptedir (gerçek Topic, gerçek
        // MarkdownRenderResult record'u) -- bu yüzden templates/topic.html, gerçek bir
        // isteği işliyormuş gibi normal şekilde render edilir.
    }
}
