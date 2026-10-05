package com.cdurgun.learning.controller;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.service.ContentResolver;
import com.cdurgun.learning.service.MarkdownService;
import com.cdurgun.learning.service.NavigationService;
import com.cdurgun.learning.web.StaticPage;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.server.ResponseStatusException;

/**
 * Sabit bilgi sayfaları: Hakkında, İletişim, Gizlilik Politikası, Kullanım Koşulları.
 * Hangi sayfaların var olduğu {@link StaticPage}'de; yoldaki regex yalnızca başka tek
 * segmentli rotalarla ({@code /{lang}/login}, {@code /{lang}/quiz}) çakışmayı önler.
 */
@Controller
public class PageController {

    private final ContentResolver contentResolver;
    private final MarkdownService markdownService;
    private final NavigationService navigationService;

    public PageController(ContentResolver contentResolver,
                          MarkdownService markdownService,
                          NavigationService navigationService) {
        this.contentResolver = contentResolver;
        this.markdownService = markdownService;
        this.navigationService = navigationService;
    }

    @GetMapping("/{lang:en|tr}/{pageSlug:about|contact|privacy|terms}")
    public String show(@PathVariable String lang, @PathVariable String pageSlug, Model model) {
        Language language = Language.fromCode(lang);
        StaticPage page = StaticPage.fromSlug(pageSlug)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
        String markdown = contentResolver.resolvePage(page.getSlug(), language)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));

        model.addAttribute("language", language);
        model.addAttribute("nav", navigationService.buildNavigation(language));
        model.addAttribute("page", page);
        model.addAttribute("contentHtml", markdownService.render(markdown, page.getSlug()).html());
        return "page";
    }
}
