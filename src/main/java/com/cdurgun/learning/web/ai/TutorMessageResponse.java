package com.cdurgun.learning.web.ai;

import java.util.UUID;

/**
 * Başarılı bir cevap (plan §5). {@code answerHtml} sunucuda temizlenmiş HTML'dir; istemci onu
 * olduğu gibi basabilir. {@code conversationSaved == false}: cevap gösterilebilir ama bu tur hiçbir
 * konuşmaya eklenmedi ({@code conversationId == null}, {@code turnsRemaining == 0}); bir sonraki
 * soru {@code conversationId: null} ile yeni bir konuşma başlatmalı.
 */
public record TutorMessageResponse(UUID conversationId, boolean conversationSaved, String answerHtml,
                                   boolean truncated, boolean lessonContextUsed, int turnsRemaining) {
}
