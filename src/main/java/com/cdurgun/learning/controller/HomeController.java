package com.cdurgun.learning.controller;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.service.NavigationService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;

import java.net.URI;
import java.util.Locale;

@Controller
public class HomeController {

    private final NavigationService navigationService;

    public HomeController(NavigationService navigationService) {
        this.navigationService = navigationService;
    }

    /**
     * Kök adres artık içerik sunmuyor, bir dil "negotiator"ı: mevcutsa {@code ?lang=}
     * parametresine (eski yer imleri/paylaşılmış linkler için geriye dönük uyumluluk),
     * yoksa tarayıcının {@code Accept-Language} başlığına bakarak `/en` veya `/tr`'ye
     * 302 (geçici) yönlendirir -- 302 kullanıyoruz çünkü bu "içerik taşındı" değil,
     * "hangi dil varyantı gösterilecek" kararı; Google'ın çok-dilli site rehberi de
     * tam olarak bu deseni (kök sayfa negotiator + her dilin kendi sabit URL'si +
     * hreflang) öneriyor. Gerçek içerik ve indexlenen URL'ler her zaman `/en/...` ve
     * `/tr/...` altında, bu yönlendirme yalnızca kök `/` isteği için bir kolaylık.
     */
    @GetMapping("/")
    public ResponseEntity<Void> root(@RequestParam(required = false) String lang,
                                      @RequestHeader(value = "Accept-Language", required = false) String acceptLanguage) {
        Language language = resolveRootLanguage(lang, acceptLanguage);
        return ResponseEntity.status(HttpStatus.FOUND)
                .location(URI.create("/" + language.getCode()))
                .build();
    }

    /**
     * `{lang:en|tr}` regex kısıtı bilerek eklendi: bu sayede `/favicon.ico`,
     * `/robots.txt`, `/sitemap.xml` gibi tek segmentli başka yollar bu mapping'e hiç
     * girmiyor (Spring bunları statik kaynak handler'ına veya kendi özel
     * controller'larına bırakıyor) -- regex olmasaydı bu istekler buraya düşüp
     * `Language.fromCode()` patlayınca yanlışlıkla 404 dönerdi.
     */
    @GetMapping("/{lang:en|tr}")
    public String index(@PathVariable String lang, Model model) {
        Language language = Language.fromCode(lang);

        model.addAttribute("language", language);
        model.addAttribute("nav", navigationService.buildNavigation(language));

        return "index";
    }

    private Language resolveRootLanguage(String lang, String acceptLanguage) {
        if (lang != null) {
            try {
                return Language.fromCode(lang);
            } catch (IllegalArgumentException ignored) {
                // geçersiz/bozuk ?lang= değeri -- Accept-Language'e düş
            }
        }
        if (acceptLanguage != null && acceptLanguage.toLowerCase(Locale.ROOT).startsWith("tr")) {
            return Language.TR;
        }
        return Language.EN;
    }
}
