package com.cdurgun.learning.web.internal;

/**
 * {@code GET /api/internal/questions/existing} yanıtındaki tek bir satır --
 * question generation tooling'in (n8n) tekrar/near-duplicate kontrolü için
 * kullandığı minimal görünüm. Bilinçli olarak yalnızca {@code id}+{@code
 * question} taşır (şıklar/doğruluk bilgisi YOK) -- bu salt bir metin
 * karşılaştırma girdisi, review-seviyesi bir görünüm değil.
 */
public record ExistingQuestionView(Long id, String question) {
}
