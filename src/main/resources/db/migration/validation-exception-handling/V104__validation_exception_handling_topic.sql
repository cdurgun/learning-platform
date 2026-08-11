-- Spring MVC kategorisinin beşinci konusu: Validation & Exception Handling --
-- Bean Validation (@NotNull/@NotBlank/@Size/@Email/@Pattern), @Valid, cascading,
-- @ExceptionHandler, @RestControllerAdvice, ProblemDetail (RFC 7807).
-- request-response-handling=4'ten sonra sort_order=5, aynı INTERMEDIATE zorlukta.
--
-- Kullanıcı kararıyla bu fazdan itibaren TR tamamlanır tamamlanmaz EN de onay
-- beklenmeden yazılıyor (bkz. CLAUDE.md "Sıradaki Adım") -- yine de tarihsel
-- tutarlılık için TR önce published=true, EN published=false olarak ekleniyor,
-- ayrı bir "publish_..._english" migration'ıyla hemen ardından yayına alınıyor.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'validation-exception-handling', 'INTERMEDIATE', 5, 5
FROM category
WHERE slug = 'spring-mvc';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Validation & Exception Handling',
       'Bean Validation (@NotBlank, @Size, @Email, @Pattern) ile @Valid, iç içe nesnelerde cascading, @ExceptionHandler, @RestControllerAdvice ve RFC 7807 ProblemDetail ile standart hata yönetimi.',
       'Spring MVC''de Bean Validation ve Exception Handling | @Valid, ProblemDetail Örnekleriyle',
       'Spring MVC''de @NotBlank/@Size/@Email/@Pattern ile Bean Validation, @Valid''in perde arkası, iç içe nesnelerde cascading, @ExceptionHandler ve @RestControllerAdvice ile hata yönetimi, RFC 7807 ProblemDetail gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'validation-exception-handling';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Validation & Exception Handling',
       'Bean Validation (@NotBlank, @Size, @Email, @Pattern) with @Valid, cascading for nested objects, @ExceptionHandler, @RestControllerAdvice, and standardized error handling with RFC 7807 ProblemDetail.',
       'Bean Validation and Exception Handling in Spring MVC | With @Valid and ProblemDetail Examples',
       'Bean Validation with @NotBlank/@Size/@Email/@Pattern in Spring MVC, the machinery behind @Valid, cascading for nested objects, error handling with @ExceptionHandler and @RestControllerAdvice, and RFC 7807 ProblemDetail -- all with real examples.',
       false
FROM topic
WHERE slug = 'validation-exception-handling';
