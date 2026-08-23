-- `type-erasure-and-generic-limitations` konusu, 5 örneğin tamamı. Kod
-- yorumları ve açıklama metinleri İNGİLİZCE yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Çalışma Zamanında Type Erasure', 'TypeErasureRuntimeInspectionExample', 1
FROM topic WHERE slug = 'type-erasure-and-generic-limitations';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'new T() Geçici Çözümü: Supplier<T>', 'GenericMethodConstructionWorkaroundExample', 2
FROM topic WHERE slug = 'type-erasure-and-generic-limitations';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Generic Array Geçici Çözümü', 'GenericArrayWorkaroundExample', 3
FROM topic WHERE slug = 'type-erasure-and-generic-limitations';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Statik Üyeler ve Generics', 'StaticMembersAndGenericsExample', 4
FROM topic WHERE slug = 'type-erasure-and-generic-limitations';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Pratikte Heap Pollution ve Unchecked Uyarı', 'UncheckedWarningHeapPollutionExample', 5
FROM topic WHERE slug = 'type-erasure-and-generic-limitations';
