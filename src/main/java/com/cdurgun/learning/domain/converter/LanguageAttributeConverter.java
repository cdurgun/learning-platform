package com.cdurgun.learning.domain.converter;

import com.cdurgun.learning.domain.Language;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

/**
 * {@link Language} için DB temsili olarak enum sabit adı (TR/EN) yerine
 * {@link Language#getCode()} değerini (tr/en) kullanır — böylece veritabanındaki
 * değer, URL'lerde ve content/{lang}/... dosya yollarında kullandığımız kodla
 * her zaman birebir aynı olur. {@code autoApply = true} olduğu için Language tipindeki
 * her alana otomatik uygulanır; entity'lerde ayrıca {@code @Enumerated} KULLANILMAMALI.
 */
@Converter(autoApply = true)
public class LanguageAttributeConverter implements AttributeConverter<Language, String> {

    @Override
    public String convertToDatabaseColumn(Language language) {
        return language == null ? null : language.getCode();
    }

    @Override
    public Language convertToEntityAttribute(String dbValue) {
        return dbValue == null ? null : Language.fromCode(dbValue);
    }
}
