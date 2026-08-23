-- `introduction-to-generics` konusu, 5 örneğin tamamı. Kod yorumları ve
-- açıklama metinleri İNGİLİZCE yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Pre-Generics Cast Sorunu', 'PreGenericsCastingProblemExample', 1
FROM topic WHERE slug = 'introduction-to-generics';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Generic Box Sınıfı', 'GenericBoxClassExample', 2
FROM topic WHERE slug = 'introduction-to-generics';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'İki Tür Parametreli Pair Sınıfı', 'GenericPairClassExample', 3
FROM topic WHERE slug = 'introduction-to-generics';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Generic Interface', 'GenericInterfaceExample', 4
FROM topic WHERE slug = 'introduction-to-generics';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Derleme Zamanında Tür Güvenliği', 'TypeSafetyCompileTimeCheckExample', 5
FROM topic WHERE slug = 'introduction-to-generics';
