package com.cdurgun.learning.domain;

/**
 * Bir {@link Question}'ın şık/tip semantiği. {@code SINGLE_CHOICE}/{@code CODE_OUTPUT}
 * tam olarak bir doğru şık gerektirir, {@code MULTIPLE_CHOICE} bir veya daha fazla --
 * bu kısıt DB'de değil, servis/ingestion katmanında uygulanır (bkz. plan bölüm 5.1).
 */
public enum QuestionType {
    SINGLE_CHOICE,
    MULTIPLE_CHOICE,
    CODE_OUTPUT
}
