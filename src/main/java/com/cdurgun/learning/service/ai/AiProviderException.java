package com.cdurgun.learning.service.ai;

/**
 * Sağlayıcı çağrısının başarısız olduğu her durum. Mesaj yalnızca kategoriden ve HTTP durum
 * kodundan kurulur: API anahtarı, istek/yanıt gövdesi ya da başlıklar ASLA içinde yer almaz.
 * {@code usage}, sağlayıcı bir hata yanıtında bile token bildirdiyse doludur (maliyet kaydı için).
 */
public class AiProviderException extends RuntimeException {

    private final AiErrorCategory category;
    private final Integer httpStatus;
    private final TutorUsage usage;

    public AiProviderException(AiErrorCategory category, Integer httpStatus, TutorUsage usage, Throwable cause) {
        super("AI provider call failed: " + category + (httpStatus == null ? "" : " (HTTP " + httpStatus + ")"), cause);
        this.category = category;
        this.httpStatus = httpStatus;
        this.usage = usage;
    }

    public AiProviderException(AiErrorCategory category, Integer httpStatus) {
        this(category, httpStatus, null, null);
    }

    public AiErrorCategory getCategory() {
        return category;
    }

    public Integer getHttpStatus() {
        return httpStatus;
    }

    public TutorUsage getUsage() {
        return usage;
    }
}
