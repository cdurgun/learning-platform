package com.cdurgun.learning.controller;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.repository.TopicTranslationRepository;
import com.cdurgun.learning.service.NavigationService;
import com.cdurgun.learning.web.nav.CourseNav;
import org.springframework.context.MessageSource;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Locale;

/**
 * Kurs açılış sayfası: bir kursun, o dilde yayında olan tüm konularını kategorileriyle
 * listeler. Yeni bir veri modeli yok -- sidebar ve anasayfayla AYNI
 * {@link NavigationService#buildNavigation} ağacından tek bir kurs seçilir, bu yüzden
 * sayfada görünen konular menüdekilerle hiçbir zaman ayrışamaz.
 *
 * <p>Sayfa yalnızca konu başlıklarını/özetlerini listeler; ders içeriği gibi tüm
 * kurslarda anonim erişime açıktır (bkz. {@code CourseAccessPolicy} -- kural yalnızca
 * quiz/Practice içindir, burada soru içeriği yoktur).</p>
 */
@Controller
public class CourseController {

    private final NavigationService navigationService;
    private final TopicTranslationRepository topicTranslationRepository;
    private final MessageSource messageSource;

    public CourseController(NavigationService navigationService,
                            TopicTranslationRepository topicTranslationRepository,
                            MessageSource messageSource) {
        this.navigationService = navigationService;
        this.topicTranslationRepository = topicTranslationRepository;
        this.messageSource = messageSource;
    }

    @GetMapping("/{lang:en|tr}/courses/{courseSlug}")
    public String show(@PathVariable String lang, @PathVariable String courseSlug, Model model) {
        Language language = Language.fromCode(lang);
        List<CourseNav> nav = navigationService.buildNavigation(language);

        // buildNavigation yalnızca bu dilde yayında konusu olan kursları içerir; listede
        // olmayan bir slug ya hiç yoktur ya da bu dilde gösterilecek içeriği yoktur -- 404.
        CourseNav course = nav.stream()
                .filter(candidate -> candidate.slug().equals(courseSlug))
                .findFirst()
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Kurs bulunamadı: " + courseSlug));

        Locale locale = Locale.forLanguageTag(language.getCode());
        int topicCount = course.categories().stream().mapToInt(category -> category.topics().size()).sum();

        model.addAttribute("language", language);
        model.addAttribute("otherLanguage", language.other());
        model.addAttribute("otherLanguageAvailable",
                topicTranslationRepository.existsPublishedInCourse(courseSlug, language.other()));
        model.addAttribute("nav", nav);
        model.addAttribute("course", course);
        model.addAttribute("topicCount", topicCount);
        model.addAttribute("pageTitle",
                messageSource.getMessage("course.pageTitle", new Object[]{course.name()}, locale));
        model.addAttribute("courseDescription", courseDescription(course, locale));
        return "course";
    }

    /** Kursa özel açıklama {@code course.{slug}.description}; yeni bir kurs için henüz yazılmadıysa genel metin. */
    private String courseDescription(CourseNav course, Locale locale) {
        String fallback = messageSource.getMessage("course.description.default", new Object[]{course.name()}, locale);
        return messageSource.getMessage("course." + course.slug() + ".description", null, fallback, locale);
    }
}
