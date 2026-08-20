package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.Topic;
import com.cdurgun.learning.domain.TopicTranslation;
import com.openhtmltopdf.extend.FSSupplier;
import com.openhtmltopdf.outputdevice.helper.BaseRendererBuilder.FontStyle;
import com.openhtmltopdf.pdfboxout.PdfRendererBuilder;
import org.jsoup.Jsoup;
import org.jsoup.helper.W3CDom;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.thymeleaf.ITemplateEngine;
import org.thymeleaf.context.Context;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UncheckedIOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

/**
 * Bir konuyu (Faz 77'den itibaren) indirilebilir bir PDF'e çevirir.
 *
 * <p><b>Neden {@code io.github.openhtmltopdf} (ve {@code com.openhtmltopdf} DEĞİL):</b>
 * kütüphane bir süre önce Maven Central'ın domain-doğrulaması gerektirmeyen {@code io.github.*}
 * namespace'ine taşındı; eski {@code com.openhtmltopdf} grubu 1.0.10'da (4+ yıl önce) donmuş,
 * aktif geliştirme artık {@code io.github.openhtmltopdf} altında (bkz. pom.xml yorumu). Bu proje
 * için pure-Java (native binary/wkhtmltopdf gerektirmiyor, Docker/Render deploy'una uygun)
 * olması tercih sebebiydi.</p>
 *
 * <p><b>Neden jsoup + {@code W3CDom} (openhtmltopdf'in kendi {@code withHtmlContent(...)}'i
 * DEĞİL):</b> openhtmltopdf'in dahili XML parser'ı sıkı/well-formed XHTML bekliyor;
 * {@link MarkdownService#render} çıktısı (CommonMark + callout post-process) genelde temiz
 * ama garanti değil (ör. kaçışsız bir {@code &} kullanıcı içeriğinden -- ders markdown'ından --
 * gelebilir). jsoup'un HTML5 (lenient) parser'ıyla ayrıştırıp {@code W3CDom} ile W3C
 * {@code Document}'e çevirmek, tarayıcıların da yaptığı gibi küçük düzensizlikleri tolere eder
 * -- bu, openhtmltopdf'in kendi wiki'sinin de (jsoup DOM converter modülü kaldırıldıktan sonra)
 * önerdiği güncel yöntem.</p>
 *
 * <p><b>Türkçe karakterler:</b> PDF'in varsayılan (base-14) fontları Latin Extended karakterleri
 * (ğ, ş, ı, ö, ü, ç) güvenilir şekilde içermez -- bu yüzden {@code src/main/resources/fonts/}
 * altındaki DejaVu Sans/DejaVu Sans Mono (Bitstream Vera lisansı, serbestçe gömülüp
 * dağıtılabilir -- bkz. {@code fonts/LICENSE-DejaVu.txt}) programatik olarak
 * {@code useFont(...)} ile embed edilir; CSS'te doğrudan {@code font-family: 'PDF Body'} /
 * {@code 'PDF Mono'} olarak referans verilir, ayrıca bir {@code @font-face} kuralı gerekmez.</p>
 *
 * <p><b>Sandbox notu (Faz 77):</b> Maven Central bu geliştirme ortamında engelli olduğu için bu
 * yeni bağımlılıklar (ve bu sınıfın tamamı) gerçek {@code mvn compile}/PDF render ile
 * doğrulanamadı -- API imzaları (özellikle {@code useFont}, {@code withW3cDocument},
 * {@code FontStyle}) kütüphanenin GitHub kaynak koduna ve resmi wiki'sine bakılarak dikkatle
 * yazıldı, ama kullanıcının kendi ortamında derleyip gerçek bir PDF indirmesi ŞART.</p>
 */
@Service
public class PdfExportService {

    private static final String[] FONT_FAMILY_REGULAR = {"fonts/DejaVuSans.ttf"};
    private static final String[] FONT_FAMILY_BOLD = {"fonts/DejaVuSans-Bold.ttf"};
    private static final String[] FONT_FAMILY_MONO = {"fonts/DejaVuSansMono.ttf"};

    private final ITemplateEngine templateEngine;
    private final MessageSource messageSource;
    private final String baseUrl;

    public PdfExportService(ITemplateEngine templateEngine,
                             MessageSource messageSource,
                             @Value("${app.base-url}") String baseUrl) {
        this.templateEngine = templateEngine;
        this.messageSource = messageSource;
        this.baseUrl = baseUrl;
    }

    /**
     * @param topic       dil-bağımsız konu metadata'sı (zorluk, süre, kategori/kurs adı için)
     * @param translation bu dildeki başlık/özet
     * @param language    hangi dilde üretileceği (yazı yönü değil, mesaj/tarih/URL için)
     * @param contentHtml {@link MarkdownService#render} çıktısı -- web sayfasında gösterilenle
     *                    BİREBİR AYNI HTML (tek doğruluk kaynağı korunur, PDF için ayrı bir
     *                    render yolu yok)
     */
    public byte[] renderTopicPdf(Topic topic, TopicTranslation translation, Language language, String contentHtml) {
        String html = templateEngine.process("topic-pdf", buildContext(topic, translation, language, contentHtml));

        org.jsoup.nodes.Document jsoupDocument = Jsoup.parse(html, baseUrl);
        org.w3c.dom.Document w3cDocument = new W3CDom().fromJsoup(jsoupDocument);

        ByteArrayOutputStream output = new ByteArrayOutputStream();
        try {
            PdfRendererBuilder builder = new PdfRendererBuilder();
            builder.useFastMode();
            registerFonts(builder);
            builder.withW3cDocument(w3cDocument, baseUrl);
            builder.toStream(output);
            builder.run();
        } catch (IOException e) {
            throw new UncheckedIOException(
                    "PDF üretilemedi (konu: " + topic.getSlug() + ", dil: " + language.getCode() + ")", e);
        }
        return output.toByteArray();
    }

    private Context buildContext(Topic topic, TopicTranslation translation, Language language, String contentHtml) {
        Locale locale = Locale.forLanguageTag(language.getCode());
        Context context = new Context(locale);

        context.setVariable("translation", translation);
        context.setVariable("difficultyLabel",
                messageSource.getMessage("difficulty." + topic.getDifficulty(), null, locale));
        context.setVariable("estimatedMinutes", topic.getEstimatedMinutes());
        context.setVariable("minutesShortLabel", messageSource.getMessage("time.minutesShort", null, locale));
        context.setVariable("courseName", topic.getCategory().getCourse().getName());
        context.setVariable("categoryName", topic.getCategory().getName());
        context.setVariable("contentHtml", contentHtml);

        String canonicalUrl = baseUrl + "/" + language.getCode() + "/topics/" + topic.getSlug();
        context.setVariable("canonicalUrl", canonicalUrl);

        String generatedOnLabel = messageSource.getMessage("pdf.generatedOn",
                new Object[]{formatDate(locale)}, locale);
        context.setVariable("generatedOnLabel", generatedOnLabel);
        context.setVariable("readOnlineLabel", messageSource.getMessage("pdf.readOnline", null, locale));
        context.setVariable("pageFooterPrefix", messageSource.getMessage("pdf.pageFooterPrefix", null, locale));
        context.setVariable("pageFooterConnector", messageSource.getMessage("pdf.pageFooterConnector", null, locale));

        return context;
    }

    private String formatDate(Locale locale) {
        return LocalDate.now().format(DateTimeFormatter.ofPattern("d MMMM yyyy", locale));
    }

    private void registerFonts(PdfRendererBuilder builder) {
        builder.useFont(fontSupplier(FONT_FAMILY_REGULAR[0]), "PDF Body", 400, FontStyle.NORMAL, true);
        builder.useFont(fontSupplier(FONT_FAMILY_BOLD[0]), "PDF Body", 700, FontStyle.NORMAL, true);
        builder.useFont(fontSupplier(FONT_FAMILY_MONO[0]), "PDF Mono", 400, FontStyle.NORMAL, true);
    }

    private FSSupplier<InputStream> fontSupplier(String classpathResource) {
        return () -> {
            InputStream stream = getClass().getClassLoader().getResourceAsStream(classpathResource);
            if (stream == null) {
                throw new UncheckedIOException(new IOException("Font bulunamadı: " + classpathResource));
            }
            return stream;
        };
    }
}
