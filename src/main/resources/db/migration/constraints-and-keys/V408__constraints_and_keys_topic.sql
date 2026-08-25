-- PostgreSQL kursu, PostgreSQL Foundations kategorisi, Topic 5:
-- "Constraints and Keys"
-- (postgresql-data-types'ın hemen ardına, sort_order=5). Kod embed'i YOK --
-- SQL örnekleri bu projenin kendi GERÇEK V1__init_schema.sql (ON DELETE
-- CASCADE, uq_category_course_slug) ve V290__quiz_and_quiz_question_link_schema.sql
-- (ON DELETE RESTRICT + gerçek migration yorumu) dosyalarından alıntılanmış
-- inline ```sql fence'ler, ayrı bir "sections" migration'ı gerektirmiyor.
-- TR published=true, EN published=false.
INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'constraints-and-keys', 'BEGINNER', 20, 5
FROM category
WHERE slug = 'postgresql-foundations';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Constraints and Keys',
       'PRIMARY KEY, FOREIGN KEY ve referential integrity, ON DELETE CASCADE vs. RESTRICT (bu projenin kendi quiz_question_link tablosundaki gerçek kontrastıyla), composite UNIQUE, CHECK kısıtları, ve BIGSERIAL PRIMARY KEY''in GenerationType.IDENTITY''ye nasıl bağlandığı. PostgreSQL Foundations kategorisinin 5.''si.',
       'PostgreSQL''de Constraints ve Key''ler',
       'PRIMARY KEY, FOREIGN KEY, ON DELETE davranışları, UNIQUE ve CHECK kısıtları, bu projenin kendi gerçek şema örnekleriyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'constraints-and-keys';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Constraints and Keys',
       'PRIMARY KEY, FOREIGN KEY and referential integrity, ON DELETE CASCADE vs. RESTRICT (with a real contrast from this project''s own quiz_question_link table), composite UNIQUE, CHECK constraints, and how BIGSERIAL PRIMARY KEY connects to GenerationType.IDENTITY. The 5th lesson in the PostgreSQL Foundations category.',
       'Constraints and Keys in PostgreSQL',
       'PRIMARY KEY, FOREIGN KEY, ON DELETE behaviors, UNIQUE and CHECK constraints, explained with this project''s own real schema examples.',
       false
FROM topic
WHERE slug = 'constraints-and-keys';
