-- PostgreSQL kursu, PostgreSQL Foundations kategorisi, Topic 6:
-- "Inserting, Updating, and Deleting Data"
-- (constraints-and-keys'in hemen ardına, sort_order=6, INTERMEDIATE --
-- onaylanan roadmap'teki gibi). Kod embed'i YOK -- SQL örnekleri bu
-- projenin kendi GERÇEK V400 (course INSERT), V403-benzeri publish
-- migration'ları (UPDATE ... WHERE), ve V132__remove_card_mini_project_examples.sql
-- (gerçek DELETE) dosyalarından alıntılanmış inline ```sql fence'ler,
-- ayrı bir "sections" migration'ı gerektirmiyor. TR published=true, EN
-- published=false.
INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'inserting-updating-and-deleting-data', 'INTERMEDIATE', 25, 6
FROM category
WHERE slug = 'postgresql-foundations';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Inserting, Updating, and Deleting Data',
       'INSERT/UPDATE/DELETE, bu projenin kendi gerçek INSERT ... SELECT ve UPDATE ... WHERE migration''larıyla, RETURNING, ON CONFLICT (upsert), ve Flyway''in migration''ların neden hiç ON CONFLICT''e ihtiyaç duymadığını nasıl garanti ettiği. PostgreSQL Foundations kategorisinin 6.''sı.',
       'PostgreSQL''de Veri Ekleme, Güncelleme ve Silme',
       'INSERT, UPDATE, DELETE, RETURNING, ve ON CONFLICT (upsert) bu projenin kendi gerçek migration''larıyla anlatılıyor.',
       true
FROM topic
WHERE slug = 'inserting-updating-and-deleting-data';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Inserting, Updating, and Deleting Data',
       'INSERT/UPDATE/DELETE, with this project''s own real INSERT ... SELECT and UPDATE ... WHERE migrations, RETURNING, ON CONFLICT (upsert), and how Flyway guarantees this project''s migrations never need ON CONFLICT. The 6th lesson in the PostgreSQL Foundations category.',
       'Inserting, Updating, and Deleting Data in PostgreSQL',
       'INSERT, UPDATE, DELETE, RETURNING, and ON CONFLICT (upsert), explained with this project''s own real migrations.',
       false
FROM topic
WHERE slug = 'inserting-updating-and-deleting-data';
