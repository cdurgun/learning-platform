package com.cdurgun.learning.controller;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.TopicTranslation;
import com.cdurgun.learning.repository.TopicTranslationRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.json.JsonParserFactory;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;

/**
 * Ders sayfasındaki yazar + "Son güncelleme" satırı ve JSON-LD'deki {@code author} /
 * {@code dateModified} alanları. {@code datePublished} BİLİNÇLİ OLARAK yoktur:
 * {@code published_at} ilk git commit tarihidir, gerçek yayın tarihini garanti etmez.
 * Beklenen tarihler teste sabit
 * yazılmaz, veritabanından okunur: bir dersin {@code updated_at} değeri ileride bir
 * migration'la ilerletildiğinde bu testler değişmeden geçmeye devam eder.
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class TopicBylineTest {

    private static final String SLUG = "enum";
    private static final String AUTHOR = "Cemalettin Durgun";
    private static final Pattern BYLINE = Pattern.compile("<p class=\"topic-byline[^\"]*\">(.*?)</p>", Pattern.DOTALL);
    private static final Pattern JSON_LD =
            Pattern.compile("<script type=\"application/ld\\+json\">(.*?)</script>", Pattern.DOTALL);
    private static final Pattern ISO_DATE = Pattern.compile("\\d{4}-\\d{2}-\\d{2}");

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private TopicTranslationRepository topicTranslationRepository;

    @Value("${app.base-url}")
    private String baseUrl;

    private String page(Language language) throws Exception {
        return mockMvc.perform(get("/" + language.getCode() + "/topics/" + SLUG))
                .andReturn().getResponse().getContentAsString(StandardCharsets.UTF_8);
    }

    private TopicTranslation translation(Language language) {
        return topicTranslationRepository.findAllPublishedWithTopic().stream()
                .filter(tt -> tt.getTopic().getSlug().equals(SLUG) && tt.getLanguage() == language)
                .findFirst().orElseThrow();
    }

    private String bylineHtml(String html) {
        Matcher byline = BYLINE.matcher(html);
        assertThat(byline.find()).as("page has a byline").isTrue();
        assertThat(byline.find()).as("page has only one byline").isFalse();
        byline.reset();
        byline.find();
        return byline.group(1);
    }

    private static String visibleText(String html) {
        return html.replaceAll("<[^>]+>", " ").replaceAll("\\s+", " ").strip();
    }

    @SuppressWarnings("unchecked")
    private Map<String, Object> learningResource(String html) {
        Matcher script = JSON_LD.matcher(html);
        while (script.find()) {
            // Geçersiz JSON burada istisna fırlatır ve testi düşürür.
            Map<String, Object> json = JsonParserFactory.getJsonParser().parseMap(script.group(1));
            if ("LearningResource".equals(json.get("@type"))) {
                return json;
            }
        }
        throw new AssertionError("no LearningResource JSON-LD block");
    }

    @Test
    void englishPageShowsAuthorAndLastUpdatedDate() throws Exception {
        LocalDate updated = translation(Language.EN).getUpdatedAt();
        String byline = bylineHtml(page(Language.EN));

        assertThat(visibleText(byline)).isEqualTo("By " + AUTHOR + " · Last updated: "
                + updated.format(DateTimeFormatter.ofPattern("MMMM d, yyyy", Locale.ENGLISH)));
        assertThat(visibleText(byline)).matches(".*Last updated: [A-Z][a-z]+ \\d{1,2}, \\d{4}");
        assertThat(byline).contains("href=\"/en/about\"").contains(">" + AUTHOR + "</a>");
        assertThat(byline).contains("<time datetime=\"" + updated + "\">");
    }

    @Test
    void turkishPageShowsAuthorAndLastUpdatedDate() throws Exception {
        LocalDate updated = translation(Language.TR).getUpdatedAt();
        String byline = bylineHtml(page(Language.TR));

        assertThat(visibleText(byline)).isEqualTo("Yazan: " + AUTHOR + " · Son güncelleme: "
                + updated.format(DateTimeFormatter.ofPattern("d MMMM yyyy", Locale.forLanguageTag("tr"))));
        assertThat(visibleText(byline)).matches(".*Son güncelleme: \\d{1,2} "
                + "(Ocak|Şubat|Mart|Nisan|Mayıs|Haziran|Temmuz|Ağustos|Eylül|Ekim|Kasım|Aralık) \\d{4}");
        assertThat(byline).contains("href=\"/tr/about\"").contains(">" + AUTHOR + "</a>");
        assertThat(byline).contains("<time datetime=\"" + updated + "\">");
    }

    @Test
    void publishedDateIsNotVisibleAndNoMessageKeyLeaks() throws Exception {
        for (Language language : Language.values()) {
            String html = page(language);
            String byline = bylineHtml(html);

            // Görünür tek tarih "son güncelleme"dir: satırda tek <time> vardır, saat/saat dilimi yoktur.
            assertThat(byline.split("<time", -1).length - 1).isEqualTo(1);
            Matcher datetime = Pattern.compile("datetime=\"([^\"]*)\"").matcher(byline);
            assertThat(datetime.find()).isTrue();
            assertThat(datetime.group(1)).matches(ISO_DATE.pattern());
            assertThat(html).doesNotContain("??topic.byline").doesNotContain("??site.author");
            assertThat(html).doesNotContain("dateModified\":[");
            // published_at hiçbir biçimde yayınlanmaz.
            assertThat(html).doesNotContain("datePublished");
        }
    }

    @Test
    @SuppressWarnings("unchecked")
    void jsonLdCarriesAuthorAndDateModifiedButNoDatePublished() throws Exception {
        for (Language language : Language.values()) {
            TopicTranslation translation = translation(language);
            Map<String, Object> json = learningResource(page(language));

            Map<String, Object> author = (Map<String, Object>) json.get("author");
            assertThat(author).containsEntry("@type", "Person").containsEntry("name", AUTHOR)
                    .containsEntry("url", baseUrl + "/" + language.getCode() + "/about");

            assertThat(json.get("dateModified")).isEqualTo(translation.getUpdatedAt().toString());
            assertThat((String) json.get("dateModified")).matches(ISO_DATE.pattern());
            assertThat(json).doesNotContainKey("datePublished");

            // Önceden var olan alanlar yerinde.
            Map<String, Object> provider = (Map<String, Object>) json.get("provider");
            assertThat(provider).containsEntry("@type", "Organization").containsEntry("name", "LearnForgeX");
            assertThat(((Map<String, Object>) json.get("isPartOf"))).containsEntry("@type", "Course");
            assertThat(json).containsEntry("learningResourceType", "Lesson")
                    .containsEntry("inLanguage", language.getCode())
                    .containsEntry("url", baseUrl + "/" + language.getCode() + "/topics/" + SLUG)
                    .containsKeys("name", "description", "educationalLevel");
        }
    }

    @Test
    void unavailableTranslationPageHasNoBylineOrDates() throws Exception {
        // Yayında olmayan tek çeviri: bu sayfa "içerik yok" uyarısı gösterir, tarih/yazar göstermez.
        TopicTranslation unpublishedSibling = topicTranslationRepository.findAllPublishedWithTopic().stream()
                .filter(tt -> topicTranslationRepository.findAllPublishedWithTopic().stream()
                        .noneMatch(other -> other.getTopic().getId().equals(tt.getTopic().getId())
                                && other.getLanguage() != tt.getLanguage()))
                .findFirst().orElse(null);
        if (unpublishedSibling == null) {
            return;
        }
        String html = mockMvc.perform(get("/" + unpublishedSibling.getLanguage().other().getCode()
                        + "/topics/" + unpublishedSibling.getTopic().getSlug()))
                .andReturn().getResponse().getContentAsString(StandardCharsets.UTF_8);

        assertThat(html).doesNotContain("topic-byline").doesNotContain("dateModified");
    }
}
