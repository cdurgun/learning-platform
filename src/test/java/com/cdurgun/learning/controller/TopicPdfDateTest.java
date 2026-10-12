package com.cdurgun.learning.controller;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.TopicTranslation;
import com.cdurgun.learning.repository.TopicTranslationRepository;
import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;

/**
 * Ders PDF'indeki tarih: yalnızca dersin {@code updated_at} değeri, ders sayfasındaki
 * "Son güncelleme" satırıyla aynı etiket ve biçimde. PDF'in üretildiği gün ve yazar adı
 * BİLİNÇLİ OLARAK yoktur. Metin, gerçek PDF çıktısından PDFBox ile çıkarılır; beklenen tarih
 * veritabanından okunur.
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class TopicPdfDateTest {

    /** EN ve TR güncellenme tarihleri farklı olan bir ders: yanlış dilin tarihi yakalanır. */
    private static final String SLUG = "wrapper-classes";
    private static final DateTimeFormatter EN = DateTimeFormatter.ofPattern("MMMM d, yyyy", Locale.ENGLISH);
    private static final DateTimeFormatter TR = DateTimeFormatter.ofPattern("d MMMM yyyy", Locale.forLanguageTag("tr"));

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private TopicTranslationRepository topicTranslationRepository;

    private MockHttpServletResponse download(Language language) throws Exception {
        return mockMvc.perform(get("/" + language.getCode() + "/topics/" + SLUG + "/pdf")).andReturn().getResponse();
    }

    private String pdfText(Language language) throws Exception {
        try (PDDocument document = Loader.loadPDF(download(language).getContentAsByteArray())) {
            return new PDFTextStripper().getText(document).replaceAll("\\s+", " ");
        }
    }

    private LocalDate updatedAt(Language language) {
        return topicTranslationRepository.findAllPublishedWithTopic().stream()
                .filter(tt -> tt.getTopic().getSlug().equals(SLUG) && tt.getLanguage() == language)
                .map(TopicTranslation::getUpdatedAt)
                .findFirst().orElseThrow();
    }

    @Test
    void englishPdfShowsTheLessonsLastUpdatedDate() throws Exception {
        assertThat(pdfText(Language.EN)).contains("Last updated: " + updatedAt(Language.EN).format(EN));
    }

    @Test
    void turkishPdfShowsTheLessonsLastUpdatedDate() throws Exception {
        assertThat(pdfText(Language.TR)).contains("Son güncelleme: " + updatedAt(Language.TR).format(TR));
    }

    @Test
    void pdfShowsNeitherItsGenerationDateNorTheAuthor() throws Exception {
        LocalDate today = LocalDate.now();
        for (Language language : Language.values()) {
            String text = pdfText(language);

            assertThat(text).doesNotContain("Generated on").doesNotContain("Oluşturulma tarihi")
                    .doesNotContain("??").doesNotContain("Cemalettin").doesNotContain("Yazan:");
            // Bugünün tarihi hiçbir yazımla geçmez (dersin updated_at değeri bugün değilse).
            if (!updatedAt(language).equals(today)) {
                assertThat(text).doesNotContain(today.format(EN)).doesNotContain(today.format(TR))
                        .doesNotContain(today.format(DateTimeFormatter.ofPattern("d MMMM yyyy", Locale.ENGLISH)));
            }
            // Tek bir "son güncelleme" satırı vardır.
            String label = language == Language.EN ? "Last updated:" : "Son güncelleme:";
            assertThat(text.split(java.util.regex.Pattern.quote(label), -1).length - 1).isEqualTo(1);
        }
    }

    @Test
    void downloadBehaviourIsUnchanged() throws Exception {
        MockHttpServletResponse response = download(Language.TR);

        assertThat(response.getStatus()).isEqualTo(200);
        assertThat(response.getContentType()).isEqualTo("application/pdf");
        assertThat(response.getHeader("Content-Disposition")).isEqualTo("attachment; filename=\"" + SLUG + "-tr.pdf\"");
        assertThat(response.getHeader("X-Robots-Tag")).isEqualTo("noindex");
    }
}
