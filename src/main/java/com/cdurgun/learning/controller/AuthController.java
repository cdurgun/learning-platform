package com.cdurgun.learning.controller;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.service.DuplicateEmailException;
import com.cdurgun.learning.service.UserRegistrationService;
import com.cdurgun.learning.web.auth.RegisterForm;
import jakarta.validation.Valid;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Map;

/**
 * Login sayfası GET'i ve register sayfasının GET+POST'u burada. Login'in POST'u
 * bu controller'da YOK -- Spring Security'nin {@code formLogin()} filtresi
 * {@code /{lang:en|tr}/login}'i kendisi işliyor (bkz. SecurityConfig), buraya hiç
 * uğramıyor.
 */
@Controller
public class AuthController {

    /**
     * {@code ?error=...} değeri -> gösterilecek mesaj anahtarı. Boş {@code ?error} form
     * login'in kendi hatasıdır; Google akışının hataları bir kod taşır (bkz.
     * SecurityConfig#googleFailureHandler, GoogleSignInController). Listede olmayan bir
     * değer genel giriş hatası olarak gösterilir -- URL'den rastgele bir anahtar okunmaz.
     */
    private static final Map<String, String> LOGIN_ERROR_MESSAGES = Map.of(
            "google_cancelled", "auth.google.error.cancelled",
            "google_failed", "auth.google.error.failed",
            "google_email_not_verified", "auth.google.error.emailNotVerified",
            "google_expired", "auth.google.error.expired",
            "google_link_locked", "auth.google.error.linkLocked",
            "google_link_unavailable", "auth.google.error.linkUnavailable");

    private final UserRegistrationService userRegistrationService;
    private final ObjectProvider<ClientRegistrationRepository> clientRegistrations;

    public AuthController(UserRegistrationService userRegistrationService,
                          ObjectProvider<ClientRegistrationRepository> clientRegistrations) {
        this.userRegistrationService = userRegistrationService;
        this.clientRegistrations = clientRegistrations;
    }

    @GetMapping("/{lang:en|tr}/login")
    public String loginPage(@PathVariable String lang,
                            @RequestParam(required = false) String error,
                            Model model) {
        Language language = Language.fromCode(lang);

        if (isAuthenticated()) {
            return "redirect:/" + language.getCode();
        }

        model.addAttribute("language", language);
        model.addAttribute("googleSignInEnabled", isGoogleSignInEnabled());
        if (error != null) {
            model.addAttribute("loginErrorKey", LOGIN_ERROR_MESSAGES.getOrDefault(error, "auth.login.error"));
        }
        return "auth/login";
    }

    @GetMapping("/{lang:en|tr}/register")
    public String registerPage(@PathVariable String lang, Model model) {
        Language language = Language.fromCode(lang);

        if (isAuthenticated()) {
            return "redirect:/" + language.getCode();
        }

        model.addAttribute("language", language);
        model.addAttribute("googleSignInEnabled", isGoogleSignInEnabled());
        if (!model.containsAttribute("registerForm")) {
            model.addAttribute("registerForm", new RegisterForm());
        }
        return "auth/register";
    }

    @PostMapping("/{lang:en|tr}/register")
    public String register(@PathVariable String lang,
                            @Valid @ModelAttribute("registerForm") RegisterForm form,
                            BindingResult bindingResult,
                            Model model) {
        Language language = Language.fromCode(lang);
        model.addAttribute("language", language);
        model.addAttribute("googleSignInEnabled", isGoogleSignInEnabled());

        if (bindingResult.hasErrors()) {
            return "auth/register";
        }

        try {
            userRegistrationService.register(form.getEmail(), form.getPassword(), form.getDisplayName());
        } catch (DuplicateEmailException e) {
            bindingResult.rejectValue("email", "auth.validation.email.duplicate", "");
            return "auth/register";
        }

        return "redirect:/" + language.getCode() + "/login?registered";
    }

    private boolean isGoogleSignInEnabled() {
        return clientRegistrations.getIfAvailable() != null;
    }

    private boolean isAuthenticated() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return authentication != null
                && authentication.isAuthenticated()
                && !"anonymousUser".equals(authentication.getPrincipal());
    }
}
