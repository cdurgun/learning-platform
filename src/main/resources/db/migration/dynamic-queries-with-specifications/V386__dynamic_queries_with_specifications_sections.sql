-- `dynamic-queries-with-specifications` konusu, 5 örneğin tamamı. Kod
-- yorumları ve açıklama metinleri İNGİLİZCE yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Tek Bir Specification', 'SingleSpecificationExample', 1
FROM topic WHERE slug = 'dynamic-queries-with-specifications';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'JpaSpecificationExecutor', 'JpaSpecificationExecutorExample', 2
FROM topic WHERE slug = 'dynamic-queries-with-specifications';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Specification''ları Birleştirmek', 'CombiningSpecificationsExample', 3
FROM topic WHERE slug = 'dynamic-queries-with-specifications';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Veritabanına İtilmiş İsteğe Bağlı Filtreler', 'OptionalFiltersSpecificationExample', 4
FROM topic WHERE slug = 'dynamic-queries-with-specifications';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Specification + Pageable', 'SpecificationWithPageableExample', 5
FROM topic WHERE slug = 'dynamic-queries-with-specifications';
