package com.cdurgun.learning.web.ingest;

/**
 * POST /api/internal/questions/ingest 201 yanıt gövdesi. {@code status}/{@code source}
 * burada, sunucunun GERÇEKTEN ne kaydettiğini n8n tarafının doğrulayabilmesi için
 * dönülür (her zaman "PENDING_REVIEW"/"AI" olmalı — bkz. QuestionIngestRequest javadoc).
 */
public record QuestionIngestResponse(Long id, String status, String source) {
}
