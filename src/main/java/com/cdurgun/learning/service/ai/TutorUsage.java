package com.cdurgun.learning.service.ai;

/**
 * Sağlayıcının bildirdiği token sayıları -- tahmin DEĞİL. {@code reasoningTokens}, thinking
 * kapalıyken 0 ya da yok ({@code null}) olmalı.
 */
public record TutorUsage(int promptCacheHitTokens,
                         int promptCacheMissTokens,
                         int completionTokens,
                         Integer reasoningTokens) {
}
