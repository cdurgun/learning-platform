package com.cdurgun.learning.web.ai;

import java.util.UUID;

/**
 * {@code POST /{lang}/admin/ai-tutor/messages} gövdesi (plan §5). Ders metni ya da dil BİLİNÇLİ
 * OLARAK yok: ders yalnızca {@code topicSlug} ile sunucuda yüklenir, dil path'ten gelir.
 * {@code conversationId == null} yeni bir konuşma başlatır.
 */
public record TutorMessageRequest(UUID conversationId, String message, String topicSlug) {

    @Override
    public String toString() {
        return "TutorMessageRequest[conversationId=" + conversationId + ", messageChars="
                + (message == null ? 0 : message.length()) + ", topicSlug=" + topicSlug + "]";
    }
}
