package com.cdurgun.learning.domain;

/**
 * Bir {@link Question}'ın kökeni -- yalnızca denetim/filtreleme amaçlı, davranışı
 * değiştirmez (davranışı belirleyen {@link QuestionStatus}'tur).
 */
public enum QuestionSource {
    MANUAL,
    AI
}
