package com.cdurgun.learning.domain;

/**
 * Bir {@link Question}'ın yayın/review durumu. Yalnızca {@code PUBLISHED} olan
 * sorular Practice havuzunda ya da bir {@code Quiz}'e eklenebilir şekilde görünür --
 * AI ingestion her zaman {@code PENDING_REVIEW} ile başlar, asla doğrudan
 * {@code PUBLISHED} olamaz (bkz. plan bölüm 6).
 */
public enum QuestionStatus {
    DRAFT,
    PENDING_REVIEW,
    PUBLISHED,
    REJECTED
}
