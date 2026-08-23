package com.cdurgun.learning.service;

import java.util.Set;

/**
 * Bir sorunun cevaplanma doğruluğunu belirleyen, tipten bağımsız TEK kural: seçilen
 * şık id kümesi, doğru şık id kümesiyle BİREBİR aynı olmalı (sıra önemsiz).
 * SINGLE_CHOICE/CODE_OUTPUT için doğru küme zaten tek elemanlı olduğundan bu, "tek
 * doğru şık seçildi mi" ile aynı anlama gelir — MULTIPLE_CHOICE için ise kısmi
 * doğru cevap KABUL EDİLMEZ, tam küme eşleşmesi gerekir. Hem sabit quiz submit'i
 * hem Practice submit'i bu tek kuralı paylaşır (bkz. plan bölüm 5/5.1).
 */
public final class QuestionScorer {

    private QuestionScorer() {
    }

    public static boolean isCorrect(Set<Long> correctOptionIds, Set<Long> selectedOptionIds) {
        return selectedOptionIds.equals(correctOptionIds);
    }
}
