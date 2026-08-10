package com.cdurgun.learning.controller;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.Topic;
import com.cdurgun.learning.domain.TopicTranslation;
import com.cdurgun.learning.repository.TopicRepository;
import com.cdurgun.learning.repository.TopicTranslationRepository;
import com.cdurgun.learning.service.ContentResolver;
import com.cdurgun.learning.service.MarkdownService;
import com.cdurgun.learning.service.NavigationService;
import com.cdurgun.learning.web.nav.SequencedTopic;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Locale;
import java.util.Optional;

@Controller
@RequestMapping("/topics")
public class TopicController {

    private final TopicRepository topicRepository;
    private final TopicTranslationRepository topicTranslationRepository;
    private final ContentResolver contentResolver;
    private final MarkdownService markdownService;
    private final NavigationService navigationService;
    private final MessageSource messageSource;

    public TopicController(TopicRepository topicRepository,
                            TopicTranslationRepository topicTranslationRepository,
                            ContentResolver contentResolver,
                            MarkdownService markdownService,
                            NavigationService navigationService,
                            MessageSource messageSource) {
        this.topicRepository = topicRepository;
        this.topicTranslationRepository = topicTranslationRepository;
        this.contentResolver = contentResolver;
        this.markdownService = markdownService;
        this.navigationService = navigationService;
        this.messageSource = messageSource;
    }

    @GetMapping("/{slug}")
    public String show(@PathVariable String slug,
                        @RequestParam(required = false) String lang,
                        Model model) {
        // Konu gerçekten yoksa bu gerçek bir 404'tür. Category + Course'u join fetch ile
        // birlikte getiriyoruz — breadcrumb ve prev/next bunlara ihtiyaç duyuyor, ve bunu
        // lazy-loading'e/open-in-view'a bırakmak yerine tek sorguda açıkça çözmek istiyoruz.
        Topic topic = topicRepository.findBySlugWithCategoryAndCourse(slug)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Konu bulunamadı: " + slug));

        // `lang` verilmemişse LangParamLocaleResolver'ın çözdüğü varsayılan locale'i
        // kullan (arayüz metinleriyle aynı kaynak); açıkça verilmiş ama bozuk bir `lang`
        // için ise (Anasayfa'nın aksine) burada bilerek 400 döndürüyoruz.
        Language language;
        if (lang == null) {
            language = Language.fromCode(LocaleContextHolder.getLocale().getLanguage());
        } else {
            try {
                language = Language.fromCode(lang);
            } catch (IllegalArgumentException e) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Bilinmeyen dil: " + lang);
            }
        }

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

        addPreviousAndNext(model, topic, slug, language);

        return "topic";
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
