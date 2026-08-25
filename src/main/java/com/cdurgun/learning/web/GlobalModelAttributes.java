package com.cdurgun.learning.web;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.User;
import com.cdurgun.learning.repository.UserRepository;
import com.cdurgun.learning.service.QuizNavigationService;
import com.cdurgun.learning.web.nav.QuizNav;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import java.util.List;

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
 *
 * <p>{@code quizNav} de burada, {@code baseUrl} gibi sitewide enjekte edilir (bkz. plan,
 * "Web layer") -- var olan {@code nav} (CourseNav) attribute'unun aksine (yalnızca
 * HomeController/TopicController'da, sayfa bazlı opt-in), Quiz Area kataloğu her sayfada
 * sidebar'da görünmesi gereken küçük, sabit bir liste olduğu için BİLİNÇLİ OLARAK global
 * yapıldı -- bu, her `@RequestMapping` çağrısında bir DB sorgusu (join-fetch, ucuz) çalışır
 * anlamına gelir, `nav`'ın sayfa-bazlı opt-in deseninden küçük bir bilinçli sapma.</p>
 */
@ControllerAdvice
public class GlobalModelAttributes {

    private final String baseUrl;
    private final UserRepository userRepository;
    private final QuizNavigationService quizNavigationService;

    public GlobalModelAttributes(@Value("${app.base-url}") String baseUrl, UserRepository userRepository,
                                  QuizNavigationService quizNavigationService) {
        this.baseUrl = baseUrl;
        this.userRepository = userRepository;
        this.quizNavigationService = quizNavigationService;
    }

    @ModelAttribute("baseUrl")
    public String baseUrl() {
        return baseUrl;
    }

    /**
     * {@code config.LangPath} (auth handler'larının login/logout sonrası dil çözümlemesi
     * için kullandığı aynı mantık) paket-private olduğu için buraya paylaşılamıyor --
     * {@code LangPath}'in kendi javadoc'unun da açıkladığı gibi, bu proje bu tek satırlık
     * "URI'nin ilk path segmentini oku" mantığını cross-package paylaşım yerine küçük,
     * bağımsız bir kopya olarak tekrarlamayı tercih ediyor; burada da AYNI hassas
     * gerekçeyle tekrarlanıyor.
     */
    @ModelAttribute("quizNav")
    public List<QuizNav> quizNav(HttpServletRequest request) {
        return quizNavigationService.buildQuizNav(resolveLanguage(request.getRequestURI()));
    }

    private static Language resolveLanguage(String requestUri) {
        String withoutLeadingSlash = requestUri.startsWith("/") ? requestUri.substring(1) : requestUri;
        int nextSlash = withoutLeadingSlash.indexOf('/');
        String firstSegment = nextSlash == -1 ? withoutLeadingSlash : withoutLeadingSlash.substring(0, nextSlash);

        try {
            return Language.fromCode(firstSegment);
        } catch (IllegalArgumentException e) {
            return Language.EN;
        }
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
