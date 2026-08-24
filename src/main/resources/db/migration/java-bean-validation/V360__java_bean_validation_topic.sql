-- Yeni `advanced-spring` kategorisine (bkz. V359), serinin 1. topic'i
-- ekleniyor: "java-bean-validation", sort_order=1.
--
-- Kullanıcı kararıyla (AskUserQuestion sonrası) bu topic, spring-mvc
-- kategorisindeki `validation-exception-handling` (Faz 22, V104-V107)
-- topic'inin ZATEN işlediği temelleri (@NotNull/@NotEmpty/@NotBlank,
-- @Size/@Min/@Max, @Email/@Pattern, @Valid, Validator/ConstraintViolation,
-- cascading) TEKRARLAMIYOR -- yalnızca gerçekten yeni ya da önemli ölçüde
-- daha derin materyale odaklanıyor: işaret kısıtları (@Positive/
-- @PositiveOrZero/@Negative/@NegativeOrZero), tarih/saat kısıtları
-- (@Past/@Future/@PastOrPresent/@FutureOrPresent), tam ondalık sınırlar
-- (@DecimalMin/@DecimalMax/@Digits), validation mesajlarını özelleştirmek,
-- custom constraint annotation + ConstraintValidator, çapraz alan
-- (cross-field/class-level) validasyonu, ve validation grupları. Her bölüm
-- `validation-exception-handling`e ("Validation & Exception Handling")
-- gerçek migration başlığıyla doğrulanmış bir referansla açılıyor.
--
-- ADVANCED zorlukta -- spring-mvc'nin advanced-spring-mvc/rest-api-design/
-- spring-mvc-testing topic'leriyle aynı seviye, açıkça temel bilgiyi zaten
-- bilen bir okuyucu varsayıyor. Format: yeni kategorinin konvansiyonu --
-- "## Ek: Mini Proje" YOK (kullanıcının açık talimatı: bu kategoriye
-- şimdilik Pratik Proje eklenmeyecek), estimated_minutes 7 örnek nedeniyle
-- biraz yüksek tutuldu.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'java-bean-validation', 'ADVANCED', 35, 1
FROM category
WHERE slug = 'advanced-spring';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Java Bean Validation',
       'Spring MVC''nin "Validation & Exception Handling" dersinin üzerine inşa edilir -- işaret kısıtları (@Positive/@PositiveOrZero/@Negative/@NegativeOrZero), tarih/saat kısıtları (@Past/@Future/@PastOrPresent/@FutureOrPresent), tam ondalık sınırlar (@DecimalMin/@DecimalMax/@Digits), validation mesajlarını özelleştirmek, custom constraint annotation + ConstraintValidator ile çapraz alan validasyonu, ve validation grupları. Advanced Spring serisinin 1.''si.',
       'Java Bean Validation''da İleri Seviye Kısıtlar',
       'Java Bean Validation''ın ileri seviye kısıtları -- işaret ve tarih kısıtları, ondalık hassasiyet, custom constraint''ler ve validation grupları gerçek Spring Boot örnekleriyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'java-bean-validation';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Java Bean Validation',
       'Builds on Spring MVC''s "Validation & Exception Handling" lesson -- sign constraints (@Positive/@PositiveOrZero/@Negative/@NegativeOrZero), date/time constraints (@Past/@Future/@PastOrPresent/@FutureOrPresent), precise decimal bounds (@DecimalMin/@DecimalMax/@Digits), customizing validation messages, custom constraint annotations with ConstraintValidator for cross-field validation, and validation groups. The 1st lesson in the Advanced Spring series.',
       'Advanced Bean Validation Constraints in Java',
       'Advanced Java Bean Validation constraints -- sign and date constraints, decimal precision, custom constraints, and validation groups, explained with real Spring Boot examples.',
       false
FROM topic
WHERE slug = 'java-bean-validation';
