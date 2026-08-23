package com.cdurgun.learning.controller;

import com.cdurgun.learning.service.QuestionIngestService;
import com.cdurgun.learning.web.ingest.QuestionIngestRequest;
import com.cdurgun.learning.web.ingest.QuestionIngestResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * FAZ D: AI/n8n'in soru havuzuna yazdığı iç (internal) API. Bu rotaya erişim
 * {@code config.QuizIngestApiKeyInterceptor} tarafından {@code X-Api-Key}
 * başlığıyla korunur (bkz. WebConfig#addInterceptors) -- burada AYRICA bir
 * yetkilendirme kontrolü YOK, tek sorumluluk isteği servise devretmek. Business
 * logic (doğrulama, status/source zorlaması) tamamı QuestionIngestService'te.
 */
@Controller
public class QuestionIngestController {

    private final QuestionIngestService questionIngestService;

    public QuestionIngestController(QuestionIngestService questionIngestService) {
        this.questionIngestService = questionIngestService;
    }

    @PostMapping("/api/internal/questions/ingest")
    @ResponseBody
    public ResponseEntity<QuestionIngestResponse> ingest(@RequestBody QuestionIngestRequest request) {
        QuestionIngestResponse response = questionIngestService.ingest(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }
}
