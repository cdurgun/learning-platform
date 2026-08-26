package com.cdurgun.learning.controller;

import com.cdurgun.learning.service.GenerationToolingService;
import com.cdurgun.learning.web.internal.ExistingQuestionView;
import com.cdurgun.learning.web.internal.TopicMetadataResponse;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * Question generation tooling (n8n) için salt-okunur `/api/internal/**` uç
 * noktaları -- topic metadata, topic gövde içeriği (markdown), ve mevcut soru
 * metinleri (duplicate kontrolü için). Hepsi zaten var olan {@code
 * QuizIngestApiKeyInterceptor} tarafından korunuyor ({@code WebConfig}'teki
 * {@code /api/internal/**} path pattern'i otomatik kapsıyor) -- burada AYRICA
 * bir yetkilendirme kontrolü YOK, aynı {@link QuestionIngestController}'daki
 * gibi. Bu controller HİÇBİR yazma işlemi yapmaz -- soru havuzuna yazmanın TEK
 * yolu hâlâ {@code POST /api/internal/questions/ingest}.
 */
@Controller
public class GenerationToolingController {

    private final GenerationToolingService generationToolingService;

    public GenerationToolingController(GenerationToolingService generationToolingService) {
        this.generationToolingService = generationToolingService;
    }

    @GetMapping("/api/internal/topics/{slug}")
    @ResponseBody
    public TopicMetadataResponse metadata(@PathVariable String slug) {
        return generationToolingService.getMetadata(slug);
    }

    @GetMapping(value = "/api/internal/topics/{slug}/content", produces = MediaType.TEXT_PLAIN_VALUE + ";charset=UTF-8")
    @ResponseBody
    public ResponseEntity<String> content(@PathVariable String slug, @RequestParam String lang) {
        return ResponseEntity.ok(generationToolingService.getContent(slug, lang));
    }

    @GetMapping("/api/internal/questions/existing")
    @ResponseBody
    public List<ExistingQuestionView> existing(@RequestParam String topicSlug, @RequestParam String language) {
        return generationToolingService.listExisting(topicSlug, language);
    }
}
