package com.cdurgun.learning.controller;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.service.DuplicateEmailException;
import com.cdurgun.learning.service.UserRegistrationService;
import com.cdurgun.learning.web.auth.RegisterForm;
import jakarta.validation.Valid;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

/**
 * Login sayfası GET'i ve register sayfasının GET+POST'u burada. Login'in POST'u
 * bu controller'da YOK -- Spring Security'nin {@code formLogin()} filtresi
 * {@code /{lang:en|tr}/login}'i kendisi işliyor (bkz. SecurityConfig), buraya hiç
 * uğramıyor.
 */
@Controller
public class AuthController {

    private final UserRegistrationService userRegistrationService;

    public AuthController(UserRegistrationService userRegistrationService) {
        this.userRegistrationService = userRegistrationService;
    }

    @GetMapping("/{lang:en|tr}/login")
    public String loginPage(@PathVariable String lang, Model model) {
        Language language = Language.fromCode(lang);

        if (isAuthenticated()) {
            return "redirect:/" + language.getCode();
        }

        model.addAttribute("language", language);
        return "auth/login";
    }

    @GetMapping("/{lang:en|tr}/register")
    public String registerPage(@PathVariable String lang, Model model) {
        Language language = Language.fromCode(lang);

        if (isAuthenticated()) {
            return "redirect:/" + language.getCode();
        }

        model.addAttribute("language", language);
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

    private boolean isAuthenticated() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return authentication != null
                && authentication.isAuthenticated()
                && !"anonymousUser".equals(authentication.getPrincipal());
    }
}
