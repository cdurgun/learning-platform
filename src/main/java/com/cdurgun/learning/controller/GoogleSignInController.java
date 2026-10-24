package com.cdurgun.learning.controller;

import com.cdurgun.learning.config.GoogleSignInConfig;
import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.User;
import com.cdurgun.learning.service.DuplicateEmailException;
import com.cdurgun.learning.service.GoogleAccountService;
import com.cdurgun.learning.service.GoogleAccountService.LinkOutcome;
import com.cdurgun.learning.service.PendingGoogleSignIn;
import com.cdurgun.learning.web.auth.GoogleSignInSession;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.security.web.context.SecurityContextRepository;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Optional;

/**
 * "Google ile devam et" akışının uygulamaya ait adımları. Google'a gidiş
 * ({@code /oauth2/authorization/google}) ve dönüş ({@code /login/oauth2/code/google}),
 * ID token doğrulaması dahil, Spring Security'nin kendi filtrelerinde; buradaki uç noktalar:
 * <ul>
 *   <li>{@code GET /{lang}/login/google} -- akışın dilini session'a yazıp Google'a yollar.</li>
 *   <li>{@code GET /{lang}/login/google/complete} -- bağlı hesabı olmayan bir Google kimliği
 *       için ya Kullanım Koşulları onayını (yeni hesap) ya da şifreyle bağlamayı (e-postası
 *       eşleşen hesap) gösterir.</li>
 *   <li>{@code POST .../terms}, {@code POST .../link}, {@code POST .../cancel} -- CSRF
 *       korumalı formlar (muafiyet listesinde DEĞİLLER).</li>
 * </ul>
 * Bütün POST'lar yalnızca bu session'daki, süresi dolmamış {@link PendingGoogleSignIn}
 * üzerinde çalışır; istemciden e-posta ya da Google kimliği ALINMAZ.
 */
@Controller
public class GoogleSignInController {

    private final ObjectProvider<ClientRegistrationRepository> clientRegistrations;
    private final GoogleAccountService googleAccountService;
    private final SecurityContextRepository securityContextRepository = new HttpSessionSecurityContextRepository();

    public GoogleSignInController(ObjectProvider<ClientRegistrationRepository> clientRegistrations,
                                  GoogleAccountService googleAccountService) {
        this.clientRegistrations = clientRegistrations;
        this.googleAccountService = googleAccountService;
    }

    @GetMapping("/{lang:en|tr}/login/google")
    public String start(@PathVariable String lang, HttpServletRequest request) {
        if (clientRegistrations.getIfAvailable() == null) {
            return "redirect:/" + lang + "/login";
        }
        if (isAuthenticated()) {
            return "redirect:/" + lang;
        }
        GoogleSignInSession.rememberLang(request, lang);
        return "redirect:" + GoogleSignInConfig.AUTHORIZATION_PATH;
    }

    @GetMapping("/{lang:en|tr}/login/google/complete")
    public String complete(@PathVariable String lang, HttpServletRequest request, Model model) {
        Optional<PendingGoogleSignIn> pending = GoogleSignInSession.pending(request);
        if (pending.isEmpty()) {
            return expired(lang);
        }
        return render(lang, pending.get(), model);
    }

    @PostMapping("/{lang:en|tr}/login/google/terms")
    public String acceptTerms(@PathVariable String lang,
                              @RequestParam(defaultValue = "false") boolean termsAccepted,
                              HttpServletRequest request,
                              HttpServletResponse response,
                              Model model) {
        Optional<PendingGoogleSignIn> pending = GoogleSignInSession.pending(request);
        if (pending.isEmpty()) {
            return expired(lang);
        }
        if (googleAccountService.hasAccountWithEmail(pending.get().email())) {
            // Bu arada aynı e-postayla bir hesap açılmış: yeni hesap değil, bağlama adımı.
            return "redirect:/" + lang + "/login/google/complete";
        }
        if (!termsAccepted) {
            model.addAttribute("termsError", true);
            return render(lang, pending.get(), model);
        }

        User user;
        try {
            user = googleAccountService.createAccount(pending.get());
        } catch (DuplicateEmailException e) {
            return "redirect:/" + lang + "/login/google/complete";
        } catch (AccessDeniedException e) {
            // Bu Google hesabı bir ADMIN hesabına bağlı: Google'la giriş yok.
            GoogleSignInSession.clear(request);
            return "redirect:/" + lang + "/login?error=google_link_unavailable";
        } catch (DataIntegrityViolationException e) {
            GoogleSignInSession.clear(request);
            return "redirect:/" + lang + "/login?error=google_failed";
        }
        signIn(user, request, response);
        return "redirect:/" + lang;
    }

    @PostMapping("/{lang:en|tr}/login/google/link")
    public String link(@PathVariable String lang,
                       @RequestParam(required = false) String password,
                       HttpServletRequest request,
                       HttpServletResponse response,
                       Model model) {
        Optional<PendingGoogleSignIn> pending = GoogleSignInSession.pending(request);
        if (pending.isEmpty()) {
            return expired(lang);
        }

        LinkOutcome outcome;
        try {
            outcome = googleAccountService.link(pending.get(), password);
        } catch (DataIntegrityViolationException e) {
            outcome = new LinkOutcome(GoogleAccountService.LinkResult.NOT_LINKABLE, null);
        }

        switch (outcome.result()) {
            case LINKED -> {
                signIn(outcome.user(), request, response);
                return "redirect:/" + lang;
            }
            case WRONG_PASSWORD -> {
                PendingGoogleSignIn updated = pending.get().withFailedPasswordAttempt();
                if (updated.attemptsExhausted()) {
                    GoogleSignInSession.clear(request);
                    return "redirect:/" + lang + "/login?error=google_link_locked";
                }
                GoogleSignInSession.storePending(request, updated);
                model.addAttribute("passwordError", true);
                return render(lang, updated, model);
            }
            default -> {
                GoogleSignInSession.clear(request);
                return "redirect:/" + lang + "/login?error=google_link_unavailable";
            }
        }
    }

    @PostMapping("/{lang:en|tr}/login/google/cancel")
    public String cancel(@PathVariable String lang, HttpServletRequest request) {
        GoogleSignInSession.clear(request);
        return "redirect:/" + lang + "/login?error=google_cancelled";
    }

    private String render(String lang, PendingGoogleSignIn pending, Model model) {
        model.addAttribute("language", Language.fromCode(lang));
        model.addAttribute("googleEmail", pending.email());
        if (googleAccountService.hasAccountWithEmail(pending.email())) {
            return "auth/google-link";
        }
        return "auth/google-terms";
    }

    private static String expired(String lang) {
        return "redirect:/" + lang + "/login?error=google_expired";
    }

    /**
     * Hesap açma/bağlama sonrası girişi tamamlar. Eski session tamamen kapatılıp yenisi
     * açılır: session fixation'a karşı yeni bir session id, yeni bir CSRF token'ı, ve
     * bekleyen Google kimliği de onunla birlikte silinmiş olur (tekrar kullanılamaz).
     */
    private void signIn(User user, HttpServletRequest request, HttpServletResponse response) {
        HttpSession oldSession = request.getSession(false);
        if (oldSession != null) {
            oldSession.invalidate();
        }
        request.getSession(true);

        SecurityContext context = SecurityContextHolder.createEmptyContext();
        context.setAuthentication(UsernamePasswordAuthenticationToken.authenticated(
                user.getEmail(), null, GoogleAccountService.authoritiesOf(user)));
        SecurityContextHolder.setContext(context);
        securityContextRepository.saveContext(context, request, response);
    }

    private static boolean isAuthenticated() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return authentication != null
                && authentication.isAuthenticated()
                && !(authentication instanceof AnonymousAuthenticationToken);
    }
}
