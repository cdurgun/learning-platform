-- PostgreSQL kursu, PostgreSQL Foundations kategorisi, Topic 9:
-- "JOINs"
-- (sorting-limiting-and-pagination'ın hemen ardına, sort_order=9,
-- INTERMEDIATE -- onaylanan roadmap'te belirtildiği gibi). Kod embed'i
-- YOK -- SQL örnekleri bu projenin kendi GERÇEK topic/category/course
-- tablosu ve GERÇEK TopicRepository.findBySlugWithCategoryAndCourse
-- JPQL'i üzerinde yazılmış inline ```sql/```java fence'ler, ayrı bir
-- "sections" migration'ı gerektirmiyor. TR published=true, EN
-- published=false.
INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'joins', 'INTERMEDIATE', 25, 9
FROM category
WHERE slug = 'postgresql-foundations';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'JOINs',
       'INNER/LEFT/RIGHT/FULL JOIN, bu projenin kendi gerçek topic→category→course zinciriyle ve gerçek TopicRepository.findBySlugWithCategoryAndCourse JPQL join fetch''iyle -- ve "henüz İngilizce''de yayınlanmamış topic''leri bulma" gibi gerçek bir LEFT JOIN örneğiyle. PostgreSQL Foundations kategorisinin 9.''u.',
       'PostgreSQL''de JOIN''ler',
       'INNER JOIN, LEFT JOIN, RIGHT JOIN, ve FULL JOIN, bu projenin kendi gerçek şeması ve JPQL join fetch''iyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'joins';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'JOINs',
       'INNER/LEFT/RIGHT/FULL JOIN, with this project''s own real topic→category→course chain and its real TopicRepository.findBySlugWithCategoryAndCourse JPQL join fetch -- plus a real LEFT JOIN example finding topics not yet published in English. The 9th lesson in the PostgreSQL Foundations category.',
       'JOINs in PostgreSQL',
       'INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL JOIN, explained with this project''s own real schema and JPQL join fetch.',
       false
FROM topic
WHERE slug = 'joins';
