package com.cdurgun.learning.controller;

import com.cdurgun.learning.domain.Category;
import com.cdurgun.learning.domain.Course;
import com.cdurgun.learning.repository.CategoryRepository;
import com.cdurgun.learning.repository.CourseRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.context.MessageSource;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Locale;

import static org.assertj.core.api.Assertions.assertThat;
import static org.hamcrest.Matchers.containsString;
import static org.hamcrest.Matchers.not;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * Kurs açılış sayfaları ({@code /{lang}/courses/{slug}}), bunlara verilen linkler, sitemap
 * girdileri ve konu sayfasındaki BreadcrumbList -- gerçek Flyway verisiyle.
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class CourseControllerTest {

    @Autowired
    private MockMvc mockMvc;
    @Autowired
    private CourseRepository courseRepository;
    @Autowired
    private CategoryRepository categoryRepository;
    @Autowired
    private MessageSource messageSource;

    @Test
    void coursePageListsItsLessonsInBothLanguages() throws Exception {
        mockMvc.perform(get("/en/courses/java"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("<title>Java Course | LearnForgeX</title>")))
                .andExpect(content().string(containsString("<h1 class=\"mb-2\">Java Course</h1>")))
                .andExpect(content().string(containsString("id=\"control-flow\"")))
                .andExpect(content().string(containsString("href=\"/en/topics/enum\"")))
                .andExpect(content().string(containsString("href=\"/en/topics/if-else\"")));

        mockMvc.perform(get("/tr/courses/spring-boot"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("<title>Spring Boot Kursu | LearnForgeX</title>")))
                .andExpect(content().string(containsString("<h1 class=\"mb-2\">Spring Boot Kursu</h1>")))
                .andExpect(content().string(containsString("href=\"/tr/topics/dependency-injection\"")));
    }

    @Test
    void anonymousVisitorCanOpenEveryCoursePageAndEachHasItsOwnDescription() throws Exception {
        for (Course course : courseRepository.findAllByOrderBySortOrderAsc()) {
            for (String lang : new String[]{"en", "tr"}) {
                String html = mockMvc.perform(get("/" + lang + "/courses/" + course.getSlug()))
                        .andExpect(status().isOk())
                        .andReturn().getResponse().getContentAsString();
                assertThat(html).as(lang + "/" + course.getSlug()).doesNotContain("??");
                // Genel yedek metin değil, kursa özel açıklama kullanılıyor.
                assertThat(html).as(lang + "/" + course.getSlug())
                        .doesNotContain("Free, hands-on " + course.getName() + " lessons")
                        .doesNotContain("uygulamalı " + course.getName() + " dersleri");
            }
        }
    }

    @Test
    void coursePageCarriesCanonicalHreflangAndStructuredData() throws Exception {
        mockMvc.perform(get("/en/courses/java"))
                .andExpect(content().string(containsString("<link rel=\"canonical\" href=\"http://localhost:8080/en/courses/java\"/>")))
                .andExpect(content().string(containsString("hreflang=\"tr\"")))
                .andExpect(content().string(containsString("href=\"http://localhost:8080/tr/courses/java\"")))
                .andExpect(content().string(containsString("\"@type\": \"Course\"")))
                .andExpect(content().string(containsString("\"@type\": \"BreadcrumbList\"")));
    }

    // ---- kurs ve kategori adlarının dile göre gösterimi ----

    @Test
    void coursePageShowsCourseAndCategoryNamesInThePageLanguage() throws Exception {
        mockMvc.perform(get("/tr/courses/ai"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("<title>Yapay Zeka Kursu | LearnForgeX</title>")))
                .andExpect(content().string(containsString("<h1 class=\"mb-2\">Yapay Zeka Kursu</h1>")))
                .andExpect(content().string(containsString("<h2 class=\"h4\">Büyük Dil Modelleri</h2>")))
                .andExpect(content().string(not(containsString("<h2 class=\"h4\">Large Language Models</h2>"))))
                // slug'lar ve adresler çevrilmez
                .andExpect(content().string(containsString("id=\"large-language-models\"")))
                .andExpect(content().string(containsString("<link rel=\"canonical\" href=\"http://localhost:8080/tr/courses/ai\"/>")))
                .andExpect(content().string(containsString("\"name\": \"Yapay Zeka\"")));

        mockMvc.perform(get("/en/courses/ai"))
                .andExpect(content().string(containsString("<title>Artificial Intelligence Course | LearnForgeX</title>")))
                .andExpect(content().string(containsString("<h2 class=\"h4\">Large Language Models</h2>")))
                .andExpect(content().string(not(containsString("Büyük Dil Modelleri"))))
                .andExpect(content().string(containsString("\"name\": \"Artificial Intelligence\"")));
    }

    @Test
    void homeAndSidebarShowNamesInThePageLanguage() throws Exception {
        mockMvc.perform(get("/tr"))
                .andExpect(content().string(containsString("Kontrol Akışı")))
                .andExpect(content().string(containsString("Nesne Yönelimli Programlama")))
                .andExpect(content().string(not(containsString(">Control Flow<"))))
                .andExpect(content().string(containsString("href=\"/tr/courses/java\"")));

        mockMvc.perform(get("/en"))
                .andExpect(content().string(containsString(">Control Flow<")))
                .andExpect(content().string(not(containsString("Kontrol Akışı"))));
    }

    @Test
    void topicBreadcrumbAndStructuredDataUseNamesInThePageLanguage() throws Exception {
        mockMvc.perform(get("/tr/topics/if-else"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("href=\"/tr/courses/java#control-flow\"")))
                .andExpect(content().string(containsString(">Kontrol Akışı</a>")))
                .andExpect(content().string(containsString("\"name\": \"Kontrol Akışı\"")))
                // Ders metninin kendisi kategoriyi İngilizce adıyla anabilir; burada denetlenen
                // arayüz: breadcrumb, yan menü ve yapılandırılmış veri.
                .andExpect(content().string(not(containsString(">Control Flow</a>"))))
                .andExpect(content().string(not(containsString(">Control Flow</span>"))))
                .andExpect(content().string(not(containsString("\"name\": \"Control Flow\""))))
                .andExpect(content().string(containsString("<link rel=\"canonical\" href=\"http://localhost:8080/tr/topics/if-else\"/>")));

        mockMvc.perform(get("/en/topics/if-else"))
                .andExpect(content().string(containsString(">Control Flow</a>")))
                .andExpect(content().string(containsString("\"name\": \"Control Flow\"")))
                .andExpect(content().string(not(containsString("Kontrol Akışı"))));

        mockMvc.perform(get("/tr/topics/what-is-ai"))
                .andExpect(content().string(containsString("\"name\": \"Yapay Zeka\"")))
                .andExpect(content().string(containsString("href=\"/tr/courses/ai\"")));
    }

    @Test
    void everyCourseAndCategoryHasANameInBothLanguages() {
        for (String lang : new String[]{"en", "tr"}) {
            Locale locale = Locale.forLanguageTag(lang);
            for (Course course : courseRepository.findAll()) {
                assertThat(messageSource.getMessage("course." + course.getSlug() + ".name", null, null, locale))
                        .as("course." + course.getSlug() + ".name [" + lang + "]").isNotBlank();
            }
            for (Category category : categoryRepository.findAll()) {
                assertThat(messageSource.getMessage("category." + category.getSlug() + ".name", null, null, locale))
                        .as("category." + category.getSlug() + ".name [" + lang + "]").isNotBlank();
            }
        }
        // İngilizce ad, veritabanındaki adla aynı kalır: EN sayfalarda hiçbir şey değişmedi.
        for (Course course : courseRepository.findAll()) {
            assertThat(messageSource.getMessage("course." + course.getSlug() + ".name", null, null, Locale.ENGLISH))
                    .isEqualTo(course.getName());
        }
        for (Category category : categoryRepository.findAll()) {
            assertThat(messageSource.getMessage("category." + category.getSlug() + ".name", null, null, Locale.ENGLISH))
                    .isEqualTo(category.getName());
        }
    }

    @Test
    void unknownCourseIsNotFound() throws Exception {
        mockMvc.perform(get("/en/courses/does-not-exist")).andExpect(status().isNotFound());
        mockMvc.perform(get("/de/courses/java")).andExpect(status().isNotFound());
    }

    @Test
    void homeAndSidebarLinkToCoursePages() throws Exception {
        mockMvc.perform(get("/en"))
                .andExpect(content().string(containsString("href=\"/en/courses/java\"")))
                .andExpect(content().string(containsString("href=\"/en/courses/docker\"")));
    }

    @Test
    void topicPageBreadcrumbLeadsThroughItsCourse() throws Exception {
        mockMvc.perform(get("/en/topics/if-else"))
                .andExpect(status().isOk())
                // görünür breadcrumb
                .andExpect(content().string(containsString("href=\"/en/courses/java\"")))
                .andExpect(content().string(containsString("href=\"/en/courses/java#control-flow\"")))
                // yapılandırılmış veri
                .andExpect(content().string(containsString("\"@type\": \"BreadcrumbList\"")))
                .andExpect(content().string(containsString("courses\\/java#control-flow")))
                // ders adresi ve var olan yapılandırılmış veri değişmedi
                .andExpect(content().string(containsString("<link rel=\"canonical\" href=\"http://localhost:8080/en/topics/if-else\"/>")))
                .andExpect(content().string(containsString("\"@type\": \"LearningResource\"")));
    }

    @Test
    void sitemapListsCoursePagesAlongsideLessons() throws Exception {
        mockMvc.perform(get("/sitemap.xml"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("<loc>http://localhost:8080/en/courses/java</loc>")))
                .andExpect(content().string(containsString("<loc>http://localhost:8080/tr/courses/docker</loc>")))
                .andExpect(content().string(containsString("<loc>http://localhost:8080/en/topics/enum</loc>")))
                .andExpect(content().string(not(containsString("/courses/does-not-exist"))));
    }
}
