package com.cdurgun.learning.service.ai;

/** Sağlayıcı hatalarının, ham sağlayıcı ayrıntısı taşımayan iç sınıflandırması. */
public enum AiErrorCategory {
    /** Tutor kapalı ya da API anahtarı yok; ağa hiç çıkılmadı. */
    DISABLED,
    /** 400/422: isteği BİZ yanlış kurduk. */
    INVALID_REQUEST,
    /** 401: anahtar yanlış ya da iptal edilmiş. */
    AUTHENTICATION,
    /** 402: DeepSeek hesabında bakiye yok. */
    INSUFFICIENT_BALANCE,
    /** 429: eşzamanlılık/hız sınırı. */
    RATE_LIMITED,
    /** 503: sunucu meşgul. */
    OVERLOADED,
    /**
     * 500, beklenmeyen bir durum kodu ya da {@code finish_reason = aborted} /
     * {@code insufficient_system_resource}.
     */
    PROVIDER_ERROR,
    /** Toplam süre sınırı aşıldı. */
    TIMEOUT,
    /** Bağlantı kurulamadı ya da koptu. */
    NETWORK,
    /** Yanıt boş, JSON değil ya da beklenen alanlar eksik. */
    INVALID_RESPONSE,
    /** {@code finish_reason = content_filter}. */
    CONTENT_FILTERED
}
