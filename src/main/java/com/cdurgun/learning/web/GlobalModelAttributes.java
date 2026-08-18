package com.cdurgun.learning.web;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

/**
 * Tüm {@code @Controller}'lara ortak model attribute'ları enjekte eder. Şu an tek amacı:
 * {@code baseUrl}'i (protokol + host, sonda "/" YOK — {@code app.base-url}, bkz.
 * {@code application.yml}/{@code application-prod.yml}) her template'e otomatik olarak
 * sağlamak, böylece hreflang/canonical/Open Graph/JSON-LD gibi MUTLAK URL gerektiren
 * SEO etiketleri her sayfada tekrar tekrar `@Value` enjekte etmeden kurulabiliyor —
 * bkz. Faz 65 notu.
 *
 * <p>Spring bu {@code @ModelAttribute} metodunu HER {@code @RequestMapping} çağrısından
 * önce çalıştırır, ama {@code ResponseEntity} döndüren metotlar (örn.
 * {@code HomeController#root}, {@code TopicController#legacyRedirect},
 * {@code SitemapController}) bir view render etmediği için doldurulan {@code Model}
 * hiçbir zaman kullanılmaz — pratik etkisi sıfır, sadece anlamsız bir no-op.</p>
 */
@ControllerAdvice
public class GlobalModelAttributes {

    private final String baseUrl;

    public GlobalModelAttributes(@Value("${app.base-url}") String baseUrl) {
        this.baseUrl = baseUrl;
    }

    @ModelAttribute("baseUrl")
    public String baseUrl() {
        return baseUrl;
    }
}
