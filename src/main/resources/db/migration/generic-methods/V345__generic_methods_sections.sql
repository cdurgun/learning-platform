-- `generic-methods` konusu, 5 örneğin tamamı. Kod yorumları ve açıklama
-- metinleri İNGİLİZCE yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Generic Metot Temelleri', 'GenericMethodBasicsExample', 1
FROM topic WHERE slug = 'generic-methods';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Birden Fazla Tür Parametresi', 'MultipleTypeParametersMethodExample', 2
FROM topic WHERE slug = 'generic-methods';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Tür Çıkarımı ve Tür Tanığı', 'TypeInferenceExample', 3
FROM topic WHERE slug = 'generic-methods';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Metot vs Sınıf Tür Parametresi', 'GenericMethodInGenericClassExample', 4
FROM topic WHERE slug = 'generic-methods';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Pratik Örnek: Array Swap', 'PracticalArraySwapExample', 5
FROM topic WHERE slug = 'generic-methods';
