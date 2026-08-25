-- PostgreSQL kursu, Advanced PostgreSQL kategorisi, Topic 3:
-- "Indexes and Query Performance with EXPLAIN"
-- (postgresql-specific-data-types'ın hemen ardına, sort_order=3, ADVANCED
-- -- onaylanan roadmap'te belirtildiği gibi). Kod embed'i YOK -- SQL
-- örnekleri bu projenin kendi GERÇEK V1__init_schema.sql index'leri
-- (idx_topic_category vb.) üzerinde yazılmış inline ```sql/```text
-- fence'ler, ayrı bir "sections" migration'ı gerektirmiyor. TR
-- published=true, EN published=false.
INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'indexes-and-query-performance-with-explain', 'ADVANCED', 30, 3
FROM category
WHERE slug = 'advanced-postgresql';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Indexes and Query Performance with EXPLAIN',
       'EXPLAIN/EXPLAIN ANALYZE, Seq Scan vs. Index Scan, bu projenin kendi gerçek idx_topic_category B-tree index''iyle CREATE INDEX, partial/expression index''ler, ve OFFSET''in maliyetine keyset pagination''la geri dönüş. Advanced PostgreSQL kategorisinin 3.''ü.',
       'PostgreSQL''de Index''ler ve EXPLAIN ile Sorgu Performansı',
       'EXPLAIN, EXPLAIN ANALYZE, Seq Scan vs. Index Scan, B-tree index''ler, partial/expression index''ler, ve keyset pagination bu projenin kendi gerçek şemasıyla anlatılıyor.',
       true
FROM topic
WHERE slug = 'indexes-and-query-performance-with-explain';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Indexes and Query Performance with EXPLAIN',
       'EXPLAIN/EXPLAIN ANALYZE, Seq Scan vs. Index Scan, CREATE INDEX with this project''s own real idx_topic_category B-tree index, partial/expression indexes, and revisiting OFFSET''s cost with keyset pagination. The 3rd lesson in the Advanced PostgreSQL category.',
       'Indexes and Query Performance with EXPLAIN in PostgreSQL',
       'EXPLAIN, EXPLAIN ANALYZE, Seq Scan vs. Index Scan, B-tree indexes, partial/expression indexes, and keyset pagination, explained with this project''s own real schema.',
       false
FROM topic
WHERE slug = 'indexes-and-query-performance-with-explain';
