package com.cdurgun.learning.domain;

/**
 * Bir {@link QuestionPublishLog} satırının sonucu. {@code SUCCESS}, sorunun gerçekten
 * {@code PUBLISHED}'a geçtiği anlamına gelir; {@code FAILED} ise (ör. soru zaten
 * {@code PENDING_REVIEW} dışında bir durumdaydı, 409) hiçbir durum değişikliği
 * OLMADAN kaydedilen bir başarısız deneme satırıdır.
 */
public enum PublishLogStatus {
    SUCCESS,
    FAILED
}
