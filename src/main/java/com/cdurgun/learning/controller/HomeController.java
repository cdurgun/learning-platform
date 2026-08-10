package com.cdurgun.learning.controller;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.service.NavigationService;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    private final NavigationService navigationService;

    public HomeController(NavigationService navigationService) {
        this.navigationService = navigationService;
    }

    @GetMapping("/")
    public String index(Model model) {
        // Dil, LangParamLocaleResolver'ın zaten çözdüğü locale'den okunuyor -- `lang`
        // parametresini burada ayrıca okumuyoruz. Bilinmeyen/bozuk/eksik bir `lang`
        // zaten resolver tarafından sessizce DEFAULT_LOCALE'e düşürülüyor, böylece arayüz
        // metinleri (messages*.properties) ile içerik dili (TopicTranslation) her zaman
        // aynı kaynaktan, tutarlı şekilde belirleniyor.
        Language language = Language.fromCode(LocaleContextHolder.getLocale().getLanguage());

        model.addAttribute("language", language);
        model.addAttribute("nav", navigationService.buildNavigation(language));

        return "index";
    }
}
