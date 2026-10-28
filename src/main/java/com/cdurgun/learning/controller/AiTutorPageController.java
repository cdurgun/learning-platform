package com.cdurgun.learning.controller;

import com.cdurgun.learning.config.AiTutorSettings;
import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.service.NavigationService;
import com.cdurgun.learning.web.nav.CourseNav;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Optional;

/**
 * AI Tutor'un ayrı yönetici sayfası (plan §8, adım 10). Yalnızca görünüm: soru-cevap
 * {@link AiTutorController}'ın JSON uç noktalarıyla yapılır. Erişim {@code /{lang}/admin/**}
 * kuralıyla (ADMIN) korunur.
 *
 * <p>Ders seçimi isteğe bağlı bir {@code ?topic=slug} parametresidir. Liste, o dilde YAYINDA olan
 * dersleri veren mevcut menü verisinden gelir; listede olmayan bir slug sayfada yok sayılır (bir
 * uyarıyla). Bu yalnızca arayüz kolaylığı: asıl doğrulama her soruda sunucuda tekrar yapılır
 * ({@code LessonContextBuilder}).</p>
 *
 * <p>Tutor kapalıysa (varsayılan) ya da yapılandırma eksikse sayfa açılır ama sohbet formu ve
 * betik hiç render edilmez; yalnızca "kullanılamıyor" mesajı görünür.</p>
 */
@Controller
public class AiTutorPageController {

    private final AiTutorSettings settings;
    private final NavigationService navigationService;

    public AiTutorPageController(AiTutorSettings settings, NavigationService navigationService) {
        this.settings = settings;
        this.navigationService = navigationService;
    }

    @GetMapping("/{lang:en|tr}/admin/ai-tutor")
    public String page(@PathVariable String lang,
                       @RequestParam(name = "topic", required = false) String topic,
                       Model model) {
        Language language = Language.fromCode(lang);
        model.addAttribute("language", language);
        model.addAttribute("tutorAvailable", settings.isUsable());

        List<CourseNav> courses = navigationService.buildNavigation(language);
        model.addAttribute("tutorCourses", courses);

        boolean topicRequested = topic != null && !topic.isBlank();
        Optional<CourseNav.TopicNavItem> selected = topicRequested ? find(courses, topic) : Optional.empty();
        model.addAttribute("tutorTopic", selected.orElse(null));
        model.addAttribute("tutorTopicNotFound", topicRequested && selected.isEmpty());
        return "admin/ai-tutor";
    }

    private static Optional<CourseNav.TopicNavItem> find(List<CourseNav> courses, String slug) {
        return courses.stream()
                .flatMap(course -> course.categories().stream())
                .flatMap(category -> category.topics().stream())
                .filter(item -> item.slug().equals(slug))
                .findFirst();
    }
}
