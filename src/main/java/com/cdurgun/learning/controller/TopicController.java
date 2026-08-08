package com.cdurgun.learning.controller;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.Topic;
import com.cdurgun.learning.domain.TopicTranslation;
import com.cdurgun.learning.repository.TopicRepository;
import com.cdurgun.learning.repository.TopicTranslationRepository;
import com.cdurgun.learning.service.ContentResolver;
import com.cdurgun.learning.service.MarkdownService;
import com.cdurgun.learning.service.NavigationService;
import org.springframework.context.MessageSource;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.server.ResponseStatusException;

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
                        @RequestParam(defaultValue = "tr") String lang,
                        Model model) {
        // Konu gerçekten yoksa bu gerçek bir 404'tür.
        Topic topic = topicRepository.findBySlug(slug)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Konu bulunamadı: " + slug));

        Language language;
        try {
            language = Language.fromCode(lang);
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Bilinmeyen dil: " + lang);
        }

        Language otherLanguage = language.other();
        boolean otherLanguageAvailable = isPublished(topic.getId(), otherLanguage);

        model.addAttribute("topic", topic);
        model.addAttribute("language", language);
        model.addAttribute("otherLanguage", otherLanguage);
        model.addAttribute("otherLanguageAvailable", otherLanguageAvailable);
        model.addAttribute("nav", navigationService.buildNavigation(language));

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
        model.addAttribute("contentHtml", markdownService.render(rawMarkdown.get(), slug));

        return "topic";
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
