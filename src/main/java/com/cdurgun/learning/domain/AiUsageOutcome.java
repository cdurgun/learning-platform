package com.cdurgun.learning.domain;

/**
 * Bir {@link AiUsageLog} satırının sonucu. {@code ERROR} satırları da maliyet taşıyabilir:
 * sağlayıcı bir hata yanıtında token bildirdiyse ya da istek zaman aşımına uğradıysa (en kötü
 * durum) harcama yine kaydedilir.
 */
public enum AiUsageOutcome {
    SUCCESS,
    ERROR
}
