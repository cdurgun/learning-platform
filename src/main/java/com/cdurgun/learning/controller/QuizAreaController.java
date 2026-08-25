package com.cdurgun.learning.controller;

import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.service.PracticeService;
import com.cdurgun.learning.service.QuizDefinitionService;
import com.cdurgun.learning.web.quiz.PracticeSubmitRequest;
import com.cdurgun.learning.web.quiz.PracticeSubmitResponse;
import com.cdurgun.learning.web.quiz.QuestionView;
import org.springframework.context.MessageSource;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Locale;

/**
 * Quiz Area: kategori-kapsamlı, rastgele soru çekilen, yeniden kullanılabilir quiz
 * tanımlarının (bkz. {@link com.cdurgun.learning.domain.QuizDefinition}) oynanma/submit
 * uç noktaları -- var olan sabit/topic-gömülü quiz'in ({@code TopicController.submitQuiz},
 * {@link com.cdurgun.learning.service.QuizService}) BİLİNÇLİ OLARAK AYRI bir controller'ı.
 * Bu controller'da business logic YOK (proje mimarisi kuralı): draw {@link
 * QuizDefinitionService#draw} tarafından, puanlama AYNEN {@link PracticeService#submit}
 * tarafından yapılır -- Quiz Area'nın submit'i Practice'in submit'inden hiçbir şekilde
 * farklı DEĞİL (her ikisi de bağımsız, tam-küme-zorunluluğu OLMAYAN cevap doğrulaması
 * yapar), bu yüzden yeni bir servis metodu YAZILMADI, doğrudan çağrıldı.
 */
@Controller
public class QuizAreaController {

    private final QuizDefinitionService quizDefinitionService;
    private final PracticeService practiceService;
    private final MessageSource messageSource;

    public QuizAreaController(QuizDefinitionService quizDefinitionService,
                               PracticeService practiceService,
                               MessageSource messageSource) {
        this.quizDefinitionService = quizDefinitionService;
        this.practiceService = practiceService;
        this.messageSource = messageSource;
    }

    /**
     * Quiz katalog sayfası -- ayrıca bir sorgu YAPMAZ, {@code quizNav}
     * {@code GlobalModelAttributes} tarafından zaten her sayfaya sitewide enjekte
     * edilmiş durumda (bkz. Faz 139), bu metot yalnızca {@code language}'ı ekler.
     */
    @GetMapping("/{lang:en|tr}/quiz")
    public String index(@PathVariable String lang, Model model) {
        model.addAttribute("language", Language.fromCode(lang));
        return "quiz-index";
    }

    /**
     * {@code definitionSlug} aktif bir {@link com.cdurgun.learning.domain.QuizDefinition}'a
     * çözülemezse {@link QuizDefinitionService#draw} zaten 404 fırlatır -- {@code
     * TopicController}'daki bilinmeyen slug deseniyle AYNI (bkz. o dosyadaki
     * {@code ResponseStatusException(NOT_FOUND)} kullanımları), burada ekstra bir
     * kontrol GEREKMEZ.
     */
    @GetMapping("/{lang:en|tr}/quiz/{definitionSlug}")
    public String play(@PathVariable String lang, @PathVariable String definitionSlug, Model model) {
        Language language = Language.fromCode(lang);
        List<QuestionView> questions = quizDefinitionService.draw(language, definitionSlug);
        Locale locale = Locale.forLanguageTag(language.getCode());
        String quizTitle = messageSource.getMessage("quiz.def." + definitionSlug + ".title", null, definitionSlug, locale);

        model.addAttribute("language", language);
        model.addAttribute("definitionSlug", definitionSlug);
        model.addAttribute("quizTitle", quizTitle);
        model.addAttribute("quizQuestions", questions);
        return "quiz-play";
    }

    /**
     * {@code definitionSlug} yalnızca URL simetrisi için burada -- puanlama kapsamdan
     * bağımsız (bkz. sınıf javadoc'u), submit'e hiç aktarılmaz.
     */
    @PostMapping("/{lang:en|tr}/quiz/{definitionSlug}/submit")
    @ResponseBody
    public ResponseEntity<PracticeSubmitResponse> submit(@PathVariable String lang,
                                                           @PathVariable String definitionSlug,
                                                           @RequestBody PracticeSubmitRequest request) {
        Language language = Language.fromCode(lang);
        return ResponseEntity.ok(practiceService.submit(language, request));
    }
}
