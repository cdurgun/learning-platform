package com.cdurgun.learning.web.internal;

import java.util.List;

/**
 * {@code GET /api/internal/questions/for-translation} yanıtındaki tek bir satır --
 * EN->TR çeviri workflow'unun (n8n) bir soruyu çevirmek için ihtiyaç duyduğu TÜM
 * alanları taşır (yalnızca id+question taşıyan {@link ExistingQuestionView}'ın
 * aksine, o yalnızca duplicate-kontrolü için yeterliydi). {@code type}/{@code
 * difficulty} bilinçli olarak {@code String} -- {@link TopicMetadataResponse}'daki
 * aynı desen, JSON tarafında ek bir enum çözümlemesine gerek kalmasın diye.
 * {@code codeSnippet}/{@code codeLanguage} çeviri workflow'unda HİÇ değiştirilmeden
 * -- yalnızca doğal dil metni (question/explanation/option metinleri) çevrilir,
 * kod asla çevrilmez -- aynen ingestion isteğine geri kopyalanır. {@code source}
 * BİLİNÇLİ OLARAK dahil -- çeviri workflow'unun {@code MANUAL} kaynaklı EN
 * sorularını (bu projede EN+TR ÇİFTİ olarak yazılmış, zaten bir TR karşılığı olan)
 * atlayabilmesi için (bkz. Faz 148); ayrıca fuzzy duplicate-check hâlâ bir güvenlik
 * ağı olarak çalışır, bu filtre yalnızca gereksiz LLM çağrılarını önler.
 */
public record TranslationSourceQuestionView(Long id,
                                             String topicSlug,
                                             String type,
                                             String difficulty,
                                             String source,
                                             String question,
                                             String codeSnippet,
                                             String codeLanguage,
                                             String explanation,
                                             List<OptionView> options) {

    public record OptionView(String optionText, boolean correct) {
    }
}
