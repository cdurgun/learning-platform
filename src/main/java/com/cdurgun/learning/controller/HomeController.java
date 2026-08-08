package com.cdurgun.learning.controller;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.service.NavigationService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class HomeController {

    private final NavigationService navigationService;

    public HomeController(NavigationService navigationService) {
        this.navigationService = navigationService;
    }

    @GetMapping("/")
    public String index(@RequestParam(defaultValue = "tr") String lang, Model model) {
        Language language = resolveLanguageOrDefault(lang);

        model.addAttribute("language", language);
        model.addAttribute("nav", navigationService.buildNavigation(language));

        return "index";
    }

    /**
     * Anasayfada bilinmeyen/bozuk bir dil parametresi 400 hatası vermemeli,
     * sessizce Türkçe'ye düşmeli — bu bir kullanıcı hatası değil, olsa olsa
     * yanlış paylaşılmış bir link.
     */
    private Language resolveLanguageOrDefault(String lang) {
        try {
            return Language.fromCode(lang);
        } catch (IllegalArgumentException e) {
            return Language.TR;
        }
    }
}
