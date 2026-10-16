package com.cdurgun.learning.controller;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.TopicTranslation;
import com.cdurgun.learning.repository.TopicTranslationRepository;
import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.common.PDRectangle;
import org.apache.pdfbox.pdmodel.interactive.action.PDActionURI;
import org.apache.pdfbox.pdmodel.interactive.annotation.PDAnnotation;
import org.apache.pdfbox.pdmodel.interactive.annotation.PDAnnotationLink;
import org.apache.pdfbox.text.PDFTextStripper;
import org.apache.pdfbox.text.PDFTextStripperByArea;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import java.awt.geom.Rectangle2D;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;

/**
 * Ders PDF'indeki bağlantı hedefleri -- gerçek PDF çıktısındaki bağlantı anotasyonlarından
 * (PDFBox) okunur. Kurallar: ders metnindeki kök-göreli bağlantı ({@code /en/topics/x}) PDF'te
 * {@code app.base-url} ile mutlak adrese döner (göreli adresi PDF görüntüleyiciler çözemez);
 * zaten mutlak olan harici bağlantı değişmez; bağlantı metni korunur; çok satırlı callout
 * içindeki bağlantı da doğru hedefle yer alır; son güncelleme tarihi değişmez.
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class TopicPdfLinkTest {

    @Autowired
    private MockMvc mockMvc;
    @Autowired
    private TopicTranslationRepository topicTranslationRepository;
    @Value("${app.base-url}")
    private String baseUrl;

    @Test
    void lessonLinkInAParagraphPointsToTheAbsoluteLessonUrl() throws Exception {
        Map<String, String> links = linkTargets("/en/topics/arrays/pdf");

        assertThat(links).containsEntry(baseUrl + "/en/topics/stream-fundamentals", "Stream API Fundamentals");
        assertThat(pdfText("/en/topics/arrays/pdf")).contains("(see the \"Stream API Fundamentals\" lesson)");
        assertThat(links.keySet()).noneMatch(uri -> uri.startsWith("/"));
    }

    @Test
    void lessonLinkInsideAMultiLineCalloutPointsToTheAbsoluteLessonUrl() throws Exception {
        // en/wrapper-classes: çok satırlı Tip; tr/arrays: çok satırlı Warning.
        assertThat(linkTargets("/en/topics/wrapper-classes/pdf"))
                .containsEntry(baseUrl + "/en/topics/scanner", "Scanner");
        assertThat(linkTargets("/tr/topics/arrays/pdf"))
                .containsEntry(baseUrl + "/tr/topics/string", "String");
        assertThat(pdfText("/tr/topics/arrays/pdf")).contains("(bkz. \"String\" dersi)");
    }

    @Test
    void linkUsesTheSameHostAndPathAsThePdfsOwnCanonicalLink() throws Exception {
        Map<String, String> links = linkTargets("/tr/topics/sets/pdf");

        // PDF'in kendi "çevrimiçi oku" bağlantısı: aynı base-url, aynı yol deseni.
        assertThat(links).containsKey(baseUrl + "/tr/topics/sets");
        assertThat(links).containsEntry(baseUrl + "/tr/topics/lists", "Lists");
        assertThat(pdfText("/tr/topics/sets/pdf")).contains("\"Lists\" dersinde gördüğün");
    }

    @Test
    void alreadyAbsoluteExternalLinkIsUnchanged() throws Exception {
        assertThat(linkTargets("/en/topics/build-deployment/pdf")).containsEntry("https://vercel.com", "vercel.com");
    }

    @Test
    void lastUpdatedDateIsStillTheLessonsUpdatedAt() throws Exception {
        String date = topicTranslationRepository.findAllPublishedWithTopic().stream()
                .filter(tt -> tt.getTopic().getSlug().equals("arrays") && tt.getLanguage() == Language.EN)
                .map(TopicTranslation::getUpdatedAt).findFirst().orElseThrow()
                .format(DateTimeFormatter.ofPattern("MMMM d, yyyy", Locale.ENGLISH));

        assertThat(pdfText("/en/topics/arrays/pdf")).contains("Last updated: " + date);
    }

    private String pdfText(String path) throws Exception {
        try (PDDocument document = Loader.loadPDF(download(path))) {
            // Bağlantı ayrı bir metin parçası olarak çizildiği için konuma göre sıralanmazsa
            // çıkarılan metinde yerinden kayar.
            PDFTextStripper stripper = new PDFTextStripper();
            stripper.setSortByPosition(true);
            return stripper.getText(document).replaceAll("\\s+", " ");
        }
    }

    private byte[] download(String path) throws Exception {
        return mockMvc.perform(get(path)).andReturn().getResponse().getContentAsByteArray();
    }

    /**
     * Bağlantı hedefi -> bağlantının üstündeki metin (satır kırılınca parçalar birleştirilir).
     * Alan bazlı çıkarım, bağlantı satırın ilk karakteriyle başladığında sınırdaki açılış
     * tırnağını kaçırabildiği için tırnaklar karşılaştırma dışı; tırnaklı hâl tam metinden sınanır.
     */
    private Map<String, String> linkTargets(String path) throws Exception {
        Map<String, List<String>> parts = new LinkedHashMap<>();
        try (PDDocument document = Loader.loadPDF(download(path))) {
            for (PDPage page : document.getPages()) {
                PDFTextStripperByArea stripper = new PDFTextStripperByArea();
                List<PDAnnotationLink> pageLinks = new ArrayList<>();
                for (PDAnnotation annotation : page.getAnnotations()) {
                    if (annotation instanceof PDAnnotationLink link && link.getAction() instanceof PDActionURI) {
                        PDRectangle r = link.getRectangle();
                        float top = page.getMediaBox().getHeight() - r.getUpperRightY();
                        stripper.addRegion("l" + pageLinks.size(),
                                new Rectangle2D.Float(r.getLowerLeftX(), top, r.getWidth(), r.getHeight()));
                        pageLinks.add(link);
                    }
                }
                stripper.extractRegions(page);
                for (int i = 0; i < pageLinks.size(); i++) {
                    String uri = ((PDActionURI) pageLinks.get(i).getAction()).getURI();
                    parts.computeIfAbsent(uri, k -> new ArrayList<>()).add(stripper.getTextForRegion("l" + i).strip());
                }
            }
        }
        Map<String, String> result = new LinkedHashMap<>();
        parts.forEach((uri, texts) -> result.put(uri, String.join(" ", texts).replaceAll("\\s+", " ").replace("\"", "").strip()));
        return result;
    }
}
