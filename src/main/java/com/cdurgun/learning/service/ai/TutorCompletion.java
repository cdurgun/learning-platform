package com.cdurgun.learning.service.ai;

/**
 * Başarılı bir yanıt. {@code truncated}, cevabın {@code max_tokens}'a takılıp yarıda kaldığını
 * söyler ({@code finish_reason = length}). {@code usage} sağlayıcının kendi bildirdiği token
 * sayılarıdır; yanıtta yoksa {@code null}.
 */
public record TutorCompletion(String content, boolean truncated, String model, TutorUsage usage) {
}
