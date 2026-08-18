package com.cdurgun.learning.controller;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.TopicTranslation;
import com.cdurgun.learning.repository.TopicTranslationRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.EnumSet;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

/**
 * {@code /sitemap.xml}'i elle üretir — projede bunun için hazır bir kütüphane
 * (örn. sitemap4j) yok, ve ihtiyaç (iki dil, ~40 konu, lastmod yok) böyle bir bağımlılığı
 * gerektirmeyecek kadar basit. {@code Topic}'in hiçbir timestamp alanı olmadığı için
 * (bkz. {@code Topic.java}) {@code <lastmod>} ETİKETİ BİLİNÇLİ OLARAK EKLENMEDİ —
 * uydurma/yanlış bir tarih vermektense hiç vermemek tercih edildi (bkz. Faz 65 notu).
 *
 * <p>Her URL girdisi, Google'ın çok-dilli sitemap rehberinin önerdiği şekilde kendi
 * {@code <xhtml:link rel="alternate" hreflang="...">} cross-reference'larını taşır —
 * {@code topic.html}'deki hreflang mantığıyla birebir aynı kural: yalnızca GERÇEKTEN
 * yayında olan diller birbirine bağlanır, x-default İngilizce'ye (yoksa mevcut tek dile)
 * işaret eder.</p>
 */
@RestController
public class SitemapController {

    private final TopicTranslationRepository topicTranslationRepository;
    private final String baseUrl;

    public SitemapController(TopicTranslationRepository topicTranslationRepository,
                              @Value("${app.base-url}") String baseUrl) {
        this.topicTranslationRepository = topicTranslationRepository;
        this.baseUrl = baseUrl;
    }

    @GetMapping(value = "/sitemap.xml", produces = MediaType.APPLICATION_XML_VALUE)
    public ResponseEntity<String> sitemap() {
        // slug -> bu slug'da HANGİ dillerin yayında olduğu (hreflang cross-reference'ı
        // kurmak için). TreeMap: çıktı slug'a göre alfabetik ve deterministik olsun —
        // her istek/deploy'da aynı sitemap üretilsin, diff'lenebilir kalsın.
        Map<String, Set<Language>> availableLanguagesBySlug = new TreeMap<>();
        for (TopicTranslation translation : topicTranslationRepository.findAllPublishedWithTopic()) {
            availableLanguagesBySlug
                    .computeIfAbsent(translation.getTopic().getSlug(), slug -> EnumSet.noneOf(Language.class))
                    .add(translation.getLanguage());
        }

        StringBuilder xml = new StringBuilder();
        xml.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
        xml.append("<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\" ")
                .append("xmlns:xhtml=\"http://www.w3.org/1999/xhtml\">\n");

        appendHomeUrls(xml);
        for (Map.Entry<String, Set<Language>> entry : availableLanguagesBySlug.entrySet()) {
            String slug = entry.getKey();
            Set<Language> availableLanguages = entry.getValue();
            for (Language language : availableLanguages) {
                appendTopicUrl(xml, language, slug, availableLanguages);
            }
        }

        xml.append("</urlset>\n");

        return ResponseEntity.ok().contentType(MediaType.APPLICATION_XML).body(xml.toString());
    }

    /**
     * Anasayfanın iki dil sürümü de her zaman var (bkz. {@code HomeController#index}) —
     * topic URL'lerinden farklı olarak burada "yayında mı" kontrolüne gerek yok.
     */
    private void appendHomeUrls(StringBuilder xml) {
        for (Language language : Language.values()) {
            xml.append("  <url>\n");
            xml.append("    <loc>").append(baseUrl).append('/').append(language.getCode()).append("</loc>\n");
            xml.append("    <xhtml:link rel=\"alternate\" hreflang=\"en\" href=\"")
                    .append(baseUrl).append("/en\"/>\n");
            xml.append("    <xhtml:link rel=\"alternate\" hreflang=\"tr\" href=\"")
                    .append(baseUrl).append("/tr\"/>\n");
            xml.append("    <xhtml:link rel=\"alternate\" hreflang=\"x-default\" href=\"")
                    .append(baseUrl).append("/en\"/>\n");
            xml.append("  </url>\n");
        }
    }

    private void appendTopicUrl(StringBuilder xml, Language language, String slug, Set<Language> availableLanguages) {
        Language xDefault = availableLanguages.contains(Language.EN) ? Language.EN : Language.TR;

        xml.append("  <url>\n");
        xml.append("    <loc>").append(topicUrl(language, slug)).append("</loc>\n");
        for (Language alternate : availableLanguages) {
            xml.append("    <xhtml:link rel=\"alternate\" hreflang=\"").append(alternate.getCode())
                    .append("\" href=\"").append(topicUrl(alternate, slug)).append("\"/>\n");
        }
        xml.append("    <xhtml:link rel=\"alternate\" hreflang=\"x-default\" href=\"")
                .append(topicUrl(xDefault, slug)).append("\"/>\n");
        xml.append("  </url>\n");
    }

    private String topicUrl(Language language, String slug) {
        return baseUrl + "/" + language.getCode() + "/topics/" + slug;
    }
}
