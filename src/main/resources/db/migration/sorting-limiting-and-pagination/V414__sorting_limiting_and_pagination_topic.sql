-- PostgreSQL kursu, PostgreSQL Foundations kategorisi, Topic 8:
-- "Sorting, Limiting, and Pagination"
-- (select-and-filtering'in hemen ardına, sort_order=8, INTERMEDIATE --
-- onaylanan roadmap'te belirtildiği gibi). Kod embed'i YOK -- SQL örnekleri
-- bu projenin kendi GERÇEK topic tablosu (sort_order, estimated_minutes)
-- üzerinde yazılmış inline ```sql fence'ler, ayrı bir "sections"
-- migration'ı gerektirmiyor. TR published=true, EN published=false.
INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'sorting-limiting-and-pagination', 'INTERMEDIATE', 20, 8
FROM category
WHERE slug = 'postgresql-foundations';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Sorting, Limiting, and Pagination',
       'ORDER BY, LIMIT/OFFSET, ve NULLS FIRST/LAST -- Spring Data JPA kursundaki Pageable/Sort/Page<T>''in altta gerçekte hangi ham SQL''e dönüştüğü, bu projenin kendi gerçek topic tablosu üzerinde. PostgreSQL Foundations kategorisinin 8.''i.',
       'PostgreSQL''de Sıralama, Sınırlama ve Sayfalama',
       'ORDER BY, LIMIT/OFFSET, ve NULLS FIRST/LAST bu projenin kendi gerçek verisiyle anlatılıyor, Pageable/Page<T>''in altındaki gerçek SQL''e bağlanarak.',
       true
FROM topic
WHERE slug = 'sorting-limiting-and-pagination';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Sorting, Limiting, and Pagination',
       'ORDER BY, LIMIT/OFFSET, and NULLS FIRST/LAST -- what Pageable/Sort/Page<T>, already covered in the Spring Data JPA course, actually compiles down to underneath, on this project''s own real topic table. The 8th lesson in the PostgreSQL Foundations category.',
       'Sorting, Limiting, and Pagination in PostgreSQL',
       'ORDER BY, LIMIT/OFFSET, and NULLS FIRST/LAST, explained with this project''s own real data, connected back to the real SQL underneath Pageable/Page<T>.',
       false
FROM topic
WHERE slug = 'sorting-limiting-and-pagination';
