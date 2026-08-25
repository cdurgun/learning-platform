-- PostgreSQL kursu, Advanced PostgreSQL kategorisi, Topic 2:
-- "PostgreSQL-Specific Data Types: UUID, JSON/JSONB, and Arrays"
-- (subqueries-ctes-and-window-functions'ın hemen ardına, sort_order=2,
-- ADVANCED -- onaylanan roadmap'te belirtildiği gibi). Kod embed'i YOK --
-- SQL örnekleri bilinçli olarak illüstratif (bu projenin gerçek şemasında
-- UUID/JSON/array kolonu YOK -- ders bunu dürüstçe belirtiyor) inline
-- ```sql fence'ler, ayrı bir "sections" migration'ı gerektirmiyor. TR
-- published=true, EN published=false.
INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'postgresql-specific-data-types', 'ADVANCED', 30, 2
FROM category
WHERE slug = 'advanced-postgresql';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'PostgreSQL-Specific Data Types: UUID, JSON/JSONB, and Arrays',
       'UUID (BIGSERIAL''a alternatif olarak, trade-off''larla), JSON vs. JSONB, ->/->>/@> ile JSONB sorgulama, ve array''ler (ANY/@>/unnest) -- bu projenin gerçek şemasının hiçbirini kullanmadığı dürüstçe belirtilerek, illüstratif ama bu projenin domain''ine bağlı örneklerle. Advanced PostgreSQL kategorisinin 2.''si.',
       'PostgreSQL''e Özgü Veri Türleri: UUID, JSON/JSONB, Array',
       'UUID, JSON/JSONB, ve PostgreSQL array''leri -- bu türlerin gerçekten PostgreSQL''i PostgreSQL yapan özellikler olduğu, ne zaman gerekli oldukları anlatılıyor.',
       true
FROM topic
WHERE slug = 'postgresql-specific-data-types';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'PostgreSQL-Specific Data Types: UUID, JSON/JSONB, and Arrays',
       'UUID (as an alternative to BIGSERIAL, with trade-offs), JSON vs. JSONB, querying JSONB with ->/->>/@>, and arrays (ANY/@>/unnest) -- honestly noting this project''s real schema uses none of them, with illustrative examples grounded in this project''s own domain. The 2nd lesson in the Advanced PostgreSQL category.',
       'PostgreSQL-Specific Data Types: UUID, JSON/JSONB, Arrays',
       'UUID, JSON/JSONB, and PostgreSQL arrays -- the features that genuinely make PostgreSQL PostgreSQL, and when each is actually warranted.',
       false
FROM topic
WHERE slug = 'postgresql-specific-data-types';
