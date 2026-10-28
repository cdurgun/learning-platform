package com.cdurgun.learning.service.ai;

/**
 * AI Tutor'un dil modeli sağlayıcısına tek giriş noktası. Bir test dikişi olarak ve ileride
 * başka bir OpenAI-uyumlu sağlayıcı eklenebilsin diye var -- genel bir AI çatısı DEĞİL.
 */
public interface TutorModelClient {

    /**
     * Tek bir sohbet tamamlama isteği gönderir.
     *
     * @throws AiProviderException sağlayıcıya ulaşılamazsa, hata dönerse, zaman aşımı olursa ya da
     *         yanıt kullanılamazsa; mesajı asla API anahtarı ya da yanıt gövdesi içermez
     */
    TutorCompletion complete(TutorPrompt prompt);
}
