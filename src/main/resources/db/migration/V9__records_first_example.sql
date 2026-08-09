-- Record konusu, 2. bölüm ("İlk Record'unu Yazmak") için örnek metadata'sı.
-- Dosyaların kendisi examples/records/Point.java ve examples/records/PointUsage.java
-- altında; bağlantı, enum konusunda olduğu gibi slug + example_name convention'ıyla kurulur.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'İlk Record (Point)', 'Point', 1
FROM topic
WHERE slug = 'records';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Point Kullanımı', 'PointUsage', 2
FROM topic
WHERE slug = 'records';
