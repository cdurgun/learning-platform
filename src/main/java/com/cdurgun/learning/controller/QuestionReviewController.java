package com.cdurgun.learning.controller;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.service.QuestionReviewService;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

/**
 * Faz B (listeleme) + Faz C (Publish/Reject). Bu rota grubu {@code
 * SecurityConfig}'te (Faz A) {@code /{lang:en|tr}/admin/**} → {@code
 * hasRole("ADMIN")} ile zaten korunuyor -- yeni POST rotaları da aynı
 * wildcard deseniyle otomatik kapsandığı için burada AYRICA bir yetki
 * kontrolü ya da {@code SecurityConfig} değişikliği GEREKMEDİ.
 *
 * <p>Publish/Reject BİLİNÇLİ OLARAK CSRF muafiyet listesine EKLENMEDİ --
 * anonim/oturumsuz JSON POST'ların (quiz submit, ingestion) aksine, bunlar
 * kimlik doğrulanmış gerçek bir tarayıcı formundan geliyor (login/register/
 * logout formlarıyla AYNI kategori), bu yüzden normal CSRF koruması altında
 * kalmalı -- {@code admin/question-review.html}'deki formlar {@code
 * ${_csrf.token}} taşıyor.</p>
 */
@Controller
public class QuestionReviewController {

    private final QuestionReviewService questionReviewService;

    public QuestionReviewController(QuestionReviewService questionReviewService) {
        this.questionReviewService = questionReviewService;
    }

    @GetMapping("/{lang:en|tr}/admin/questions")
    public String pendingQuestions(@PathVariable String lang, Model model) {
        model.addAttribute("language", Language.fromCode(lang));
        model.addAttribute("pendingQuestions", questionReviewService.listPending());
        return "admin/question-review";
    }

    @PostMapping("/{lang:en|tr}/admin/questions/{id}/publish")
    public String publish(@PathVariable String lang, @PathVariable Long id, Authentication authentication) {
        questionReviewService.publish(id, authentication.getName());
        return "redirect:/" + lang + "/admin/questions";
    }

    @PostMapping("/{lang:en|tr}/admin/questions/{id}/reject")
    public String reject(@PathVariable String lang, @PathVariable Long id, Authentication authentication) {
        questionReviewService.reject(id, authentication.getName());
        return "redirect:/" + lang + "/admin/questions";
    }
}
