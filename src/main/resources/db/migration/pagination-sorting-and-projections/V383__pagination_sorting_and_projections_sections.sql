-- `pagination-sorting-and-projections` konusu, 5 örneğin tamamı. Kod
-- yorumları ve açıklama metinleri İNGİLİZCE yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Sayfalanmış Bir Repository Metodu', 'PagedRepositoryMethodExample', 1
FROM topic WHERE slug = 'pagination-sorting-and-projections';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Repository Seviyesinde Sıralama', 'SortAtRepositoryLevelExample', 2
FROM topic WHERE slug = 'pagination-sorting-and-projections';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Sayfalama + Sıralama + Filtreleme Birlikte', 'PagedAndFilteredQueryExample', 3
FROM topic WHERE slug = 'pagination-sorting-and-projections';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Interface Projection', 'InterfaceProjectionExample', 4
FROM topic WHERE slug = 'pagination-sorting-and-projections';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Record Projection', 'RecordProjectionExample', 5
FROM topic WHERE slug = 'pagination-sorting-and-projections';
