package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.Topic;
import com.cdurgun.learning.domain.TopicTranslation;
import com.cdurgun.learning.repository.TopicRepository;
import com.cdurgun.learning.repository.TopicTranslationRepository;
import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.MessageSource;
import org.springframework.test.context.ActiveProfiles;

import java.util.Locale;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * "Beklenen Çıktı" panelinin uygulamanın gerçek bileşenleriyle birlikte çalışması: dile göre
 * etiket (gerçek {@code messages*.properties}) ve PDF'te çıktının basılması (web sayfasıyla
 * aynı HTML'den, gerçek openhtmltopdf render'ı). Panel, test fixture'ından
 * ({@code examples/expected-output-fixture/}) gelir; PDF'in başlık/tarih bölümü için var olan
 * gerçek bir ders kullanılır.
 */
@SpringBootTest
@ActiveProfiles("test")
class ExpectedOutputPanelIntegrationTest {

    private static final String LESSON_SLUG = "wrapper-classes";

    @Autowired
    private MessageSource messageSource;

    @Autowired
    private MarkdownService markdownService;

    @Autowired
    private PdfExportService pdfExportService;

    @Autowired
    private TopicRepository topicRepository;

    @Autowired
    private TopicTranslationRepository topicTranslationRepository;

    private String label(Language language) {
        return messageSource.getMessage("example.expectedOutput", null, Locale.forLanguageTag(language.getCode()));
    }

    @Test
    void labelIsInThePagesOwnLanguage() {
        assertThat(label(Language.TR)).isEqualTo("Beklenen Çıktı");
        assertThat(label(Language.EN)).isEqualTo("Expected Output");
    }

    @Test
    void pdfPrintsTheLabelAndTheOutputInBothLanguages() throws Exception {
        Topic topic = topicRepository.findBySlugWithCategoryAndCourse(LESSON_SLUG).orElseThrow();

        for (Language language : Language.values()) {
            TopicTranslation translation = topicTranslationRepository
                    .findByTopicIdAndLanguage(topic.getId(), language).orElseThrow();
            String html = markdownService
                    .render("Intro.\n\n{{MultiLine.java}}\n\nAfter.", "expected-output-fixture", label(language))
                    .html();

            byte[] pdf = pdfExportService.renderTopicPdf(topic, translation, language, html);

            try (PDDocument document = Loader.loadPDF(pdf)) {
                String text = new PDFTextStripper().getText(document);
                assertThat(text).contains(label(language));
                assertThat(text).contains("1 2 3 4 5").contains("5050");
            }
        }
    }
}
