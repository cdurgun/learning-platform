-- `bounded-type-parameters` konusu, 5 örneğin tamamı. Kod yorumları ve
-- açıklama metinleri İNGİLİZCE yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Sınırsız Tür Parametresinin Kısıtı', 'UnboundedMethodCallLimitationExample', 1
FROM topic WHERE slug = 'bounded-type-parameters';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Sınıfla Üst Sınır', 'UpperBoundedSumExample', 2
FROM topic WHERE slug = 'bounded-type-parameters';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Birden Fazla Sınır', 'MultipleBoundsExample', 3
FROM topic WHERE slug = 'bounded-type-parameters';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Sınıfın Kendi Tür Parametresinde Sınır', 'BoundedGenericClassExample', 4
FROM topic WHERE slug = 'bounded-type-parameters';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Pratik Örnek: Yalnızca Interface ile Sınır', 'PracticalMaxFinderExample', 5
FROM topic WHERE slug = 'bounded-type-parameters';
