-- PostgreSQL kursu, PostgreSQL Foundations kategorisi, Topic 10 (SON):
-- "Aggregation and GROUP BY"
-- (joins'in hemen ardına, sort_order=10, INTERMEDIATE -- onaylanan
-- roadmap'te belirtildiği gibi, bu topic'le PostgreSQL Foundations
-- kategorisi 10/10 TAMAMLANIYOR). Kod embed'i YOK -- SQL örnekleri bu
-- projenin kendi GERÇEK topic/category tablosu üzerinde yazılmış inline
-- ```sql fence'ler, ayrı bir "sections" migration'ı gerektirmiyor. TR
-- published=true, EN published=false.
INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'aggregation-and-group-by', 'INTERMEDIATE', 20, 10
FROM category
WHERE slug = 'postgresql-foundations';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Aggregation and GROUP BY',
       'COUNT/SUM/AVG/MIN/MAX, GROUP BY, ve HAVING -- Spring Data JPA''nın Pageable/Sort/projection kelime dağarcığında hiç karşılığı olmayan, tamamen yeni materyal -- bu projenin kendi gerçek "kategori başına topic" LEFT JOIN + GROUP BY sorgusuyla. PostgreSQL Foundations kategorisinin 10.''u ve SONUNCUSU.',
       'PostgreSQL''de Aggregation ve GROUP BY',
       'COUNT, SUM, AVG, MIN, MAX, GROUP BY, ve HAVING, bu projenin kendi gerçek verisiyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'aggregation-and-group-by';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Aggregation and GROUP BY',
       'COUNT/SUM/AVG/MIN/MAX, GROUP BY, and HAVING -- entirely new material with no equivalent in Spring Data JPA''s Pageable/Sort/projection vocabulary -- with this project''s own real "topics per category" LEFT JOIN + GROUP BY query. The 10th and FINAL lesson in the PostgreSQL Foundations category.',
       'Aggregation and GROUP BY in PostgreSQL',
       'COUNT, SUM, AVG, MIN, MAX, GROUP BY, and HAVING, explained with this project''s own real data.',
       false
FROM topic
WHERE slug = 'aggregation-and-group-by';
