-- Forms kategorisinin iki topic'i, 10 örneğin tamamı. Dosyaların kendisi
-- examples/controlled-components/, examples/form-handling/ altında.

-- Controlled Components (5 örnek)
INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'value ile Input''u State''e Bağlamak', 'ControlledInputExample', 1
FROM topic WHERE slug = 'controlled-components';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'onChange ile State''i Güncellemek', 'WhyControlledMattersExample', 2
FROM topic WHERE slug = 'controlled-components';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Controlled Checkbox', 'ControlledCheckboxExample', 3
FROM topic WHERE slug = 'controlled-components';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Controlled Select', 'ControlledSelectExample', 4
FROM topic WHERE slug = 'controlled-components';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Neden Controlled Component?', 'ResettingControlledInputExample', 5
FROM topic WHERE slug = 'controlled-components';

-- Form Handling (5 örnek)
INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Formu Göndermek: onSubmit ile Değerleri Toplamak', 'FormSubmitExample', 1
FROM topic WHERE slug = 'form-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Birden Fazla Alanı Yönetmek', 'MultiFieldFormExample', 2
FROM topic WHERE slug = 'form-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Basit Validation (Doğrulama)', 'RequiredFieldValidationExample', 3
FROM topic WHERE slug = 'form-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Hata Mesajları Göstermek', 'EmailFormatValidationExample', 4
FROM topic WHERE slug = 'form-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Gönderim Öncesi Tüm Formu Doğrulamak', 'FullFormValidationExample', 5
FROM topic WHERE slug = 'form-handling';
