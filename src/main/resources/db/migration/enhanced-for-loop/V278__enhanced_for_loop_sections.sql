INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Temel Enhanced for Sözdizimi (Diziler)', 'EnhancedForArrayExample', 1
FROM topic WHERE slug = 'enhanced-for-loop';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Koleksiyonlar Üzerinde Enhanced for', 'EnhancedForCollectionExample', 2
FROM topic WHERE slug = 'enhanced-for-loop';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Sınır: İndekse Erişilememesi', 'NoIndexAccessExample', 3
FROM topic WHERE slug = 'enhanced-for-loop';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Sınır: Döngü Değişkeni ve Yapısal Değişiklik', 'ModifyingDuringIterationExample', 4
FROM topic WHERE slug = 'enhanced-for-loop';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'for-each vs Klasik for: Ne Zaman Hangisi', 'ForEachVsClassicForExample', 5
FROM topic WHERE slug = 'enhanced-for-loop';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Sınır: Birden Fazla Koleksiyonu Paralel Gezmek', 'ParallelIterationLimitationExample', 6
FROM topic WHERE slug = 'enhanced-for-loop';
