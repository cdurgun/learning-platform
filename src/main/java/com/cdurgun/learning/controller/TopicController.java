package com.cdurgun.learning.controller;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.Topic;
import com.cdurgun.learning.domain.TopicTranslation;
import com.cdurgun.learning.repository.TopicRepository;
import com.cdurgun.learning.repository.TopicTranslationRepository;
import com.cdurgun.learning.service.ContentResolver;
import com.cdurgun.learning.service.MarkdownService;
import com.cdurgun.learning.service.NavigationService;
import com.cdurgun.learning.service.PdfExportService;
import com.cdurgun.learning.service.QuizService;
import com.cdurgun.learning.web.nav.SequencedTopic;
import com.cdurgun.learning.web.quiz.QuizSubmitRequest;
import com.cdurgun.learning.web.quiz.QuizSubmitResponse;
import org.springframework.context.MessageSource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.server.ResponseStatusException;

import java.net.URI;
import java.util.List;
import java.util.Locale;
import java.util.Optional;

@Controller
public class TopicController {

    private final TopicRepository topicRepository;
    private final TopicTranslationRepository topicTranslationRepository;
    private final ContentResolver contentResolver;
    private final MarkdownService markdownService;
    private final NavigationService navigationService;
    private final MessageSource messageSource;
    private final PdfExportService pdfExportService;
    private final QuizService quizService;

    public TopicController(TopicRepository topicRepository,
                            TopicTranslationRepository topicTranslationRepository,
                            ContentResolver contentResolver,
                            MarkdownService markdownService,
                            NavigationService navigationService,
                            MessageSource messageSource,
                            PdfExportService pdfExportService,
                            QuizService quizService) {
        this.topicRepository = topicRepository;
        this.topicTranslationRepository = topicTranslationRepository;
        this.contentResolver = contentResolver;
        this.markdownService = markdownService;
        this.navigationService = navigationService;
        this.messageSource = messageSource;
        this.pdfExportService = pdfExportService;
        this.quizService = quizService;
    }

    /**
     * Eski (Faz 63'e kadar geçerli) {@code /topics/{slug}?lang=..} URL'lerine gelen
     * istekleri yeni path-bazlı adrese kalıcı olarak (301) yönlendirir. Bu, hem
     * kullanıcının kendi tarayıcısında/yer imlerinde kalmış eski linkleri kırmamak
     * hem de Google zaten bu eski URL'yi taramışsa index'ini yeni adrese aktarmasını
     * sağlamak için gerekli — bkz. Faz 64 notu. `lang` eksik/geçersizse eski
     * `LangParamLocaleResolver`'ın varsayılanıyla (EN) aynı davranışı koruyoruz.
     */
    @GetMapping("/topics/{slug}")
    public ResponseEntity<Void> legacyRedirect(@PathVariable String slug,
                                                @RequestParam(required = false) String lang) {
        Language language = resolveLegacyLanguage(lang);
        return ResponseEntity.status(HttpStatus.MOVED_PERMANENTLY)
                .location(URI.create("/" + language.getCode() + "/topics/" + slug))
                .build();
    }

    /**
     * `{lang:en|tr}` regex kısıtı, `HomeController.index()`'teki aynı gerekçeyle
     * eklendi: yalnızca gerçek dil kodları bu mapping'e düşsün, başka hiçbir tek/çok
     * segmentli yol yanlışlıkla buraya sapmasın.
     */
    @GetMapping("/{lang:en|tr}/topics/{slug}")
    public String show(@PathVariable String lang,
                        @PathVariable String slug,
                        Model model) {
        Language language = Language.fromCode(lang);

        // Konu gerçekten yoksa bu gerçek bir 404'tür. Category + Course'u join fetch ile
        // birlikte getiriyoruz — breadcrumb ve prev/next bunlara ihtiyaç duyuyor, ve bunu
        // lazy-loading'e/open-in-view'a bırakmak yerine tek sorguda açıkça çözmek istiyoruz.
        Topic topic = topicRepository.findBySlugWithCategoryAndCourse(slug)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Konu bulunamadı: " + slug));

        Language otherLanguage = language.other();
        boolean otherLanguageAvailable = isPublished(topic.getId(), otherLanguage);

        model.addAttribute("topic", topic);
        model.addAttribute("language", language);
        model.addAttribute("otherLanguage", otherLanguage);
        model.addAttribute("otherLanguageAvailable", otherLanguageAvailable);
        model.addAttribute("nav", navigationService.buildNavigation(language));
        model.addAttribute("activeTopicSlug", slug);

        // Breadcrumb: Ana Sayfa > Kategori > Konu (Kurs crumb'ını bilerek eklemedik —
        // şu an tek kurs var ve o zaten "Ana Sayfa" ile aynı adrese gidiyor, iki crumb'ın
        // aynı linke gitmesi kafa karıştırırdı).
        model.addAttribute("categoryName", topic.getCategory().getName());

        Optional<TopicTranslation> translation = topicTranslationRepository
                .findByTopicIdAndLanguage(topic.getId(), language)
                .filter(TopicTranslation::isPublished);

        if (translation.isEmpty()) {
            // Konu var ama bu dilde yayında değil: 404 değil, kullanıcı dostu bir sayfa.
            model.addAttribute("contentAvailable", false);
            model.addAttribute("unavailableMessage", buildUnavailableMessage(language));
            return "topic";
        }

        Optional<String> rawMarkdown = contentResolver.resolve(slug, language);
        if (rawMarkdown.isEmpty()) {
            // Çeviri DB'de yayında ama dosya bulunamadı (veri tutarsızlığı) — güvenli tarafta kal.
            model.addAttribute("contentAvailable", false);
            model.addAttribute("unavailableMessage", buildUnavailableMessage(language));
            return "topic";
        }

        model.addAttribute("contentAvailable", true);
        model.addAttribute("translation", translation.get());

        MarkdownService.MarkdownRenderResult rendered = markdownService.render(rawMarkdown.get(), slug);
        model.addAttribute("contentHtml", rendered.html());
        model.addAttribute("toc", rendered.toc());
        model.addAttribute("quizQuestions", quizService.loadQuiz(topic.getId(), language));

        addPreviousAndNext(model, topic, slug, language);

        return "topic";
    }

    /**
     * Faz 81: enum konusu için quiz submit. Şu an yalnızca enum'a hardcode —
     * kullanıcı bu ilk sürümde başka konulara genellemeyi kasıtlı olarak kapsam dışı
     * bıraktı. Business logic burada YOK, tamamı QuizService'te (bkz. mimari kuralı).
     */
    @PostMapping("/{lang:en|tr}/topics/enum/quiz/submit")
    @ResponseBody
    public ResponseEntity<QuizSubmitResponse> submitQuiz(@PathVariable String lang,
                                                           @RequestBody QuizSubmitRequest request) {
        Language language = Language.fromCode(lang);
        Topic topic = topicRepository.findBySlug("enum")
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Konu bulunamadı: enum"));
        return ResponseEntity.ok(quizService.submit(topic.getId(), language, request));
    }

    /**
     * Faz 77: "PDF İndir". {@code show()}'a KASITLI OLARAK dokunulmadı (bkz. CLAUDE.md
     * "ilgisiz kodu refactor etme") -- bu metot, aynı içerik-çözümleme adımlarını (translation
     * yayında mı, markdown dosyası var mı, {@code MarkdownService.render}) kendi başına, küçük
     * bir tekrarla yapıyor; ikisi de aynı iki kaynağa (DB + {@code content/{lang}/{slug}.md})
     * bakıyor, bu yüzden davranışları asla birbirinden sapamaz. Çeviri bu dilde yayında değilse
     * (ya da dosya eksikse) 404 döner -- {@code show()}'daki "dostane mesaj" burada anlamsız,
     * çünkü buton zaten yalnızca {@code contentAvailable=true} iken gösteriliyor (bkz.
     * topic.html); bu 404, yalnızca eski bir bookmark/doğrudan URL isteği gibi kenar
     * durumlar için bir güvenlik ağı.
     */
    @GetMapping("/{lang:en|tr}/topics/{slug}/pdf")
    public ResponseEntity<byte[]> pdf(@PathVariable String lang, @PathVariable String slug) {
        Language language = Language.fromCode(lang);

        Topic topic = topicRepository.findBySlugWithCategoryAndCourse(slug)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Konu bulunamadı: " + slug));

        TopicTranslation translation = topicTranslationRepository
                .findByTopicIdAndLanguage(topic.getId(), language)
                .filter(TopicTranslation::isPublished)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "Bu içerik " + lang + " dilinde henüz yayında değil: " + slug));

        String rawMarkdown = contentResolver.resolve(slug, language)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "İçerik dosyası bulunamadı: " + slug));

        MarkdownService.MarkdownRenderResult rendered = markdownService.render(rawMarkdown, slug);
        byte[] pdfBytes = pdfExportService.renderTopicPdf(topic, translation, language, rendered.html());

        String filename = slug + "-" + lang + ".pdf";
        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_PDF)
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filename + "\"")
                .body(pdfBytes);
    }

    /**
     * Kursun tüm (bu dilde yayınlanmış) konularını sırayla tarayıp mevcut konunun bir
     * öncekini/sonrakini bulur. Kategori sınırını geçmek otomatik olur çünkü sıra zaten
     * kategori sort_order + konu sort_order'a göre kurulu — bkz. buildCourseSequence.
     */
    private void addPreviousAndNext(Model model, Topic topic, String slug, Language language) {
        List<SequencedTopic> sequence = navigationService.buildCourseSequence(
                topic.getCategory().getCourse().getId(), language);

        int currentIndex = -1;
        for (int i = 0; i < sequence.size(); i++) {
            if (sequence.get(i).slug().equals(slug)) {
                currentIndex = i;
                break;
            }
        }

        SequencedTopic previous = currentIndex > 0 ? sequence.get(currentIndex - 1) : null;
        SequencedTopic next = (currentIndex != -1 && currentIndex < sequence.size() - 1)
                ? sequence.get(currentIndex + 1) : null;

        model.addAttribute("previousTopic", previous);
        model.addAttribute("nextTopic", next);
    }

    private Language resolveLegacyLanguage(String lang) {
        if (lang == null) {
            return Language.EN;
        }
        try {
            return Language.fromCode(lang);
        } catch (IllegalArgumentException e) {
            return Language.EN;
        }
    }

    private boolean isPublished(Long topicId, Language language) {
        return topicTranslationRepository.findByTopicIdAndLanguage(topicId, language)
                .map(TopicTranslation::isPublished)
                .orElse(false);
    }

    /**
     * "Bu içerik Türkçe dilde henüz mevcut değil." / "This content is not yet available
     * in English." — Türkçe ve İngilizce cümle yapısında dil adının konumu farklı olduğu
     * için tek bir prefix+isim+suffix şablonu ikisine birden uymuyor. Bu yüzden
     * {topic.unavailable} mesajı {0} parametreli tanımlanıyor ve kelime sırasını her
     * dil kendi mesaj dosyasında belirliyor; parametre olarak da hedef dilin adını YİNE
     * o dilin kendi locale'inde çözüyoruz (örn. eksik olan İngilizce ise "English",
     * eksik olan Türkçe ise "Türkçe" — {@code language.name} anahtarı üzerinden).
     */
    private String buildUnavailableMessage(Language language) {
        Locale locale = Locale.forLanguageTag(language.getCode());
        String languageName = messageSource.getMessage("language.name", null, locale);
        return messageSource.getMessage("topic.unavailable", new Object[]{languageName}, locale);
    }
}
