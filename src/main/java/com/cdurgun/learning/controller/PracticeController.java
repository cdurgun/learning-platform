package com.cdurgun.learning.controller;

import com.cdurgun.learning.domain.Difficulty;
import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.QuestionType;
import com.cdurgun.learning.service.PracticeService;
import com.cdurgun.learning.web.quiz.PracticeSubmitRequest;
import com.cdurgun.learning.web.quiz.PracticeSubmitResponse;
import com.cdurgun.learning.web.quiz.QuestionView;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Locale;

/**
 * FAZ C: saf bir JSON API -- şu an için özel bir Practice sayfası/template'i YOK
 * (bkz. plan: "Practice UI'ı için yeniden kullanılabilir tut", henüz kendisini
 * inşa etme). Business logic burada YOK, tamamı PracticeService'te (bkz. mimari
 * kuralı) -- bu controller yalnızca query param -> enum dönüşümü ve HTTP durumu
 * eşlemesi yapar (TopicController'daki {@code Language.fromCode(lang)} deseniyle
 * aynı, business logic sayılmaz).
 */
@Controller
public class PracticeController {

    private final PracticeService practiceService;

    public PracticeController(PracticeService practiceService) {
        this.practiceService = practiceService;
    }

    @GetMapping("/{lang:en|tr}/practice")
    @ResponseBody
    public ResponseEntity<List<QuestionView>> draw(@PathVariable String lang,
                                                     @RequestParam(required = false) String topic,
                                                     @RequestParam(required = false) String difficulty,
                                                     @RequestParam(required = false) String type,
                                                     @RequestParam(required = false) Integer count) {
        Language language = Language.fromCode(lang);
        Difficulty parsedDifficulty = parseEnum(Difficulty.class, difficulty, "difficulty");
        QuestionType parsedType = parseEnum(QuestionType.class, type, "type");
        return ResponseEntity.ok(practiceService.draw(language, topic, parsedDifficulty, parsedType, count));
    }

    @PostMapping("/{lang:en|tr}/practice/submit")
    @ResponseBody
    public ResponseEntity<PracticeSubmitResponse> submit(@PathVariable String lang,
                                                           @RequestBody PracticeSubmitRequest request) {
        Language language = Language.fromCode(lang);
        return ResponseEntity.ok(practiceService.submit(language, request));
    }

    private static <E extends Enum<E>> E parseEnum(Class<E> enumType, String rawValue, String paramName) {
        if (rawValue == null || rawValue.isBlank()) {
            return null;
        }
        try {
            return Enum.valueOf(enumType, rawValue.trim().toUpperCase(Locale.ROOT));
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "invalid " + paramName + ": " + rawValue);
        }
    }
}
