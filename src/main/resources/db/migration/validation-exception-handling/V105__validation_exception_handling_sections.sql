-- Validation & Exception Handling konusu, 14 örneğin tamamı. Dosyaların kendisi
-- examples/validation-exception-handling/ altında.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@NotNull, @NotEmpty, @NotBlank: Boşluk Farkları', 'NotNullBlankEmptyExample', 1
FROM topic WHERE slug = 'validation-exception-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@Size, @Min, @Max: Sayısal ve Uzunluk Sınırları', 'SizeMinMaxExample', 2
FROM topic WHERE slug = 'validation-exception-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@Email ve @Pattern: Biçim Doğrulama', 'EmailPatternExample', 3
FROM topic WHERE slug = 'validation-exception-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@Valid ile İstek Gövdesini Doğrulamak', 'ValidRequestBodyExample', 4
FROM topic WHERE slug = 'validation-exception-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@Valid''in Perde Arkası: Validator ve ConstraintViolation', 'ManualValidatorExample', 5
FROM topic WHERE slug = 'validation-exception-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'İç İçe Nesnelerde Doğrulama: Cascading ile @Valid', 'NestedValidationExample', 6
FROM topic WHERE slug = 'validation-exception-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Controller-Seviyesinde Hata Yakalama: @ExceptionHandler', 'ExceptionHandlerBasicExample', 7
FROM topic WHERE slug = 'validation-exception-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Global Hata Yönetimi: @RestControllerAdvice', 'RestControllerAdviceExample', 8
FROM topic WHERE slug = 'validation-exception-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'ProblemDetail: RFC 7807 ile Standart Hata Gövdesi', 'ProblemDetailBasicExample', 9
FROM topic WHERE slug = 'validation-exception-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Doğrulama Hatalarını ProblemDetail''e Dönüştürmek', 'ProblemDetailValidationExample', 10
FROM topic WHERE slug = 'validation-exception-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Kullanıcı Kayıt Formu — Controller', 'UserRegistrationController', 11
FROM topic WHERE slug = 'validation-exception-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Kullanıcı Kayıt Formu — Çalıştırma', 'UserRegistrationDemo', 12
FROM topic WHERE slug = 'validation-exception-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Ürün Kataloğu API''si', 'ProductCatalogApi', 13
FROM topic WHERE slug = 'validation-exception-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Ürün Kataloğu API''sini Çalıştırmak', 'ProductCatalogApiDemo', 14
FROM topic WHERE slug = 'validation-exception-handling';
