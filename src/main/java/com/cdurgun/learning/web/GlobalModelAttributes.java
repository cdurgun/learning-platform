package com.cdurgun.learning.web;

import com.cdurgun.learning.domain.User;
import com.cdurgun.learning.repository.UserRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

/**
 * Tüm {@code @Controller}'lara ortak model attribute'ları enjekte eder:
 * {@code baseUrl}'i (protokol + host, sonda "/" YOK — {@code app.base-url}, bkz.
 * {@code application.yml}/{@code application-prod.yml}) her template'e otomatik olarak
 * sağlamak, böylece hreflang/canonical/Open Graph/JSON-LD gibi MUTLAK URL gerektiren
 * SEO etiketleri her sayfada tekrar tekrar `@Value` enjekte etmeden kurulabiliyor —
 * bkz. Faz 65 notu. Ayrıca {@code currentUserDisplayName}'i (girişli değilse
 * {@code null}) navbar'ın "Sign in" / "[Kullanıcı Adı] [Logout]" durumunu
 * belirleyebilmesi için sağlar (bkz. {@code fragments/layout.html :: navbar}) —
 * her controller'ın kendi metodunda ayrı ayrı {@code Authentication} enjekte edip
 * model'e eklemesine gerek kalmasın diye.
 *
 * <p>Spring bu {@code @ModelAttribute} metotlarını HER {@code @RequestMapping} çağrısından
 * önce çalıştırır, ama {@code ResponseEntity} döndüren metotlar (örn.
 * {@code HomeController#root}, {@code TopicController#legacyRedirect},
 * {@code SitemapController}) bir view render etmediği için doldurulan {@code Model}
 * hiçbir zaman kullanılmaz — pratik etkisi sıfır, sadece anlamsız bir no-op.</p>
 */
@ControllerAdvice
public class GlobalModelAttributes {

    private final String baseUrl;
    private final UserRepository userRepository;

    public GlobalModelAttributes(@Value("${app.base-url}") String baseUrl, UserRepository userRepository) {
        this.baseUrl = baseUrl;
        this.userRepository = userRepository;
    }

    @ModelAttribute("baseUrl")
    public String baseUrl() {
        return baseUrl;
    }

    /**
     * Anonim kullanıcıda Spring Security bir {@code AnonymousAuthenticationToken}
     * enjekte eder ({@code authentication} asla {@code null} olmaz) — principal'ın
     * {@code "anonymousUser"} string'i olup olmadığına bakmak, gerçek girişli bir
     * kullanıcıyı ayırt etmenin standart yolu. {@code authentication.getName()}
     * login'de kullanılan username'i (email) döndürür — navbar'da email değil
     * {@code display_name} göstermek istediğimiz için burada tek bir ek sorguyla
     * {@link com.cdurgun.learning.domain.User}'a bakıyoruz.
     */
    @ModelAttribute("currentUserDisplayName")
    public String currentUserDisplayName(Authentication authentication) {
        if (authentication == null
                || !authentication.isAuthenticated()
                || "anonymousUser".equals(authentication.getPrincipal())) {
            return null;
        }
        return userRepository.findByEmail(authentication.getName())
                .map(User::getDisplayName)
                .orElse(authentication.getName());
    }
}
