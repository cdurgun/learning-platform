-- `generics-with-collections` konusu, 5 örneğin tamamı. Kod yorumları ve
-- açıklama metinleri İNGİLİZCE yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Generic Koleksiyon API''leri: List/Set/Map', 'GenericCollectionApisExample', 1
FROM topic WHERE slug = 'generics-with-collections';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Koleksiyonlarla Tür Güvenliği', 'CollectionTypeSafetyExample', 2
FROM topic WHERE slug = 'generics-with-collections';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'List Değişmezliği (Invariance)', 'ListInvarianceExample', 3
FROM topic WHERE slug = 'generics-with-collections';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Diamond Operatörü ve var ile Tür Çıkarımı', 'DiamondOperatorInferenceExample', 4
FROM topic WHERE slug = 'generics-with-collections';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Pratik Örnek: Kelime Frekansı', 'PracticalWordFrequencyExample', 5
FROM topic WHERE slug = 'generics-with-collections';
