-- `sets` konusu, 6 örneğin tamamı -- hepsi bu sandbox'ta javac+java ile gerçekten
-- derlenip çalıştırılarak doğrulandı (bkz. V204'teki not).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Temel Set İşlemleri', 'SetBasicsExample', 1
FROM topic WHERE slug = 'sets';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'LinkedHashSet: Eklenme Sırasını Korumak', 'LinkedHashSetExample', 2
FROM topic WHERE slug = 'sets';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'TreeSet ve NavigableSet', 'TreeSetExample', 3
FROM topic WHERE slug = 'sets';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'equals() ve hashCode() Sözleşmesi', 'HashSetEqualsHashCodeExample', 4
FROM topic WHERE slug = 'sets';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Birleşim, Kesişim, Fark', 'SetOperationsExample', 5
FROM topic WHERE slug = 'sets';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'List/HashSet/TreeSet Performans Karşılaştırması', 'SetPerformanceExample', 6
FROM topic WHERE slug = 'sets';
