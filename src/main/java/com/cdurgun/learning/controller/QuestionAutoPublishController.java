package com.cdurgun.learning.controller;

import com.cdurgun.learning.service.QuestionReviewService;
import com.cdurgun.learning.web.publish.QuestionAutoPublishRequest;
import com.cdurgun.learning.web.publish.QuestionAutoPublishResponse;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * n8n'in AI Judge aşaması bir soruyu APPROVE ettikten SONRA çağırdığı, {@code
 * /api/internal/questions/ingest} ile AYNI {@code X-Api-Key}/CSRF-muafiyet korumasına
 * ({@code /api/internal/**} kapsamı) tabi dar bir uç nokta. Business logic (kill
 * switch, PENDING_REVIEW-only geçiş, denetim kaydı) tamamen {@link
 * QuestionReviewService#autoPublish}'te -- {@link QuestionReviewController}'ın insan
 * ADMIN Publish/Reject akışına HİÇ dokunulmadı, bu tamamen ayrı bir çağıran yolu.
 */
@Controller
public class QuestionAutoPublishController {

    private final QuestionReviewService questionReviewService;

    public QuestionAutoPublishController(QuestionReviewService questionReviewService) {
        this.questionReviewService = questionReviewService;
    }

    @PostMapping("/api/internal/questions/{id}/auto-publish")
    @ResponseBody
    public QuestionAutoPublishResponse autoPublish(@PathVariable Long id,
                                                     @RequestBody(required = false) QuestionAutoPublishRequest request) {
        return questionReviewService.autoPublish(id, request);
    }
}
