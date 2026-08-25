-- PostgreSQL kursu, PostgreSQL Foundations kategorisi, Topic 4:
-- "PostgreSQL Data Types"
-- (databases-schemas-tables-and-basic-sql'in hemen ardına, sort_order=4).
-- Kod embed'i YOK -- SQL/Java örnekleri bu projenin kendi GERÇEK
-- Topic/TopicTranslation/Question entity'lerinden ve V1__init_schema.sql/
-- V289__question_add_type_difficulty_status_source.sql migration'larından
-- alıntılanmış inline ```sql/```java fence'ler, ayrı bir "sections"
-- migration'ı gerektirmiyor. TR published=true, EN published=false.
INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'postgresql-data-types', 'BEGINNER', 20, 4
FROM category
WHERE slug = 'postgresql-foundations';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'PostgreSQL Data Types',
       'INTEGER/BIGINT/BIGSERIAL, VARCHAR/TEXT, BOOLEAN, ve DATE/TIMESTAMP/TIMESTAMPTZ -- her birinin bu projenin kendi gerçek Topic/TopicTranslation/Question entity''lerindeki karşılık gelen Java alan türüne (Long/String/boolean/LocalDateTime) nasıl eşlendiği. PostgreSQL Foundations kategorisinin 4.''sü.',
       'PostgreSQL Veri Türleri ve Java Karşılıkları',
       'PostgreSQL''in temel veri türleri (sayısal, metin, boolean, tarih/zaman) ve bunların Java/JPA alan türlerine nasıl eşlendiği, bu projenin kendi gerçek entity''leriyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'postgresql-data-types';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'PostgreSQL Data Types',
       'INTEGER/BIGINT/BIGSERIAL, VARCHAR/TEXT, BOOLEAN, and DATE/TIMESTAMP/TIMESTAMPTZ -- how each one maps to its corresponding Java field type (Long/String/boolean/LocalDateTime) in this project''s own real Topic/TopicTranslation/Question entities. The 4th lesson in the PostgreSQL Foundations category.',
       'PostgreSQL Data Types and Their Java Equivalents',
       'PostgreSQL''s core data types (numeric, text, boolean, date/time) and how they map to Java/JPA field types, explained with this project''s own real entities.',
       false
FROM topic
WHERE slug = 'postgresql-data-types';
