package com.cdurgun.learning.domain;

/**
 * Desteklenen içerik dilleri. URL'lerde ve dosya yollarında ({@code content/{code}/...})
 * bu enum'un {@link #getCode()} değeri kullanılır.
 */
public enum Language {

    TR("tr"),
    EN("en");

    private final String code;

    Language(String code) {
        this.code = code;
    }

    public String getCode() {
        return code;
    }

    /**
     * Yalnızca iki dil olduğu için basit bir "diğer dil" yardımcı metodu.
     * Üçüncü bir dil eklenirse bu metot anlamını yitirir ve kaldırılmalıdır.
     */
    public Language other() {
        return this == TR ? EN : TR;
    }

    public static Language fromCode(String code) {
        for (Language language : values()) {
            if (language.code.equalsIgnoreCase(code)) {
                return language;
            }
        }
        throw new IllegalArgumentException("Bilinmeyen dil kodu: " + code);
    }
}
