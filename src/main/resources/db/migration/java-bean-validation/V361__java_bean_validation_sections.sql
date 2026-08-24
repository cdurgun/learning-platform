-- `java-bean-validation` konusu, 7 örneğin tamamı. Kod yorumları ve
-- açıklama metinleri İNGİLİZCE yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'İşaret Kısıtları: @Positive/@Negative', 'SignConstraintsExample', 1
FROM topic WHERE slug = 'java-bean-validation';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Tarih/Saat Kısıtları: @Past/@Future', 'DateTimeConstraintsExample', 2
FROM topic WHERE slug = 'java-bean-validation';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Ondalık Sınırlar: @DecimalMin/@DecimalMax/@Digits', 'DecimalBoundsAndDigitsExample', 3
FROM topic WHERE slug = 'java-bean-validation';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Gerçekçi Bir DTO''da Kısıtları Birleştirmek', 'CombinedConstraintsProductDtoExample', 4
FROM topic WHERE slug = 'java-bean-validation';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Validation Mesajlarını Özelleştirmek', 'CustomValidationMessageExample', 5
FROM topic WHERE slug = 'java-bean-validation';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Custom, Çapraz Alan Kısıtı', 'CrossFieldCustomConstraintExample', 6
FROM topic WHERE slug = 'java-bean-validation';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Validation Grupları', 'ValidationGroupsExample', 7
FROM topic WHERE slug = 'java-bean-validation';
