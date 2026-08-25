-- PostgreSQL kursu, PostgreSQL Foundations kategorisi, Topic 2:
-- "Connecting to PostgreSQL: psql and a Real Spring Boot DataSource"
-- (postgresql-foundations kategorisi zaten V400'de oluşturuldu, sort_order=1
-- topic zaten mevcut -- bu migration sort_order=2 topic'i ekliyor).
-- Kod embed'i YOK (creating-a-react-application.md'deki CLI/terminal dersi
-- deseniyle aynı -- inline ```bash fence'ler), bu yüzden ayrı bir "sections"
-- migration'ı yok. TR published=true, EN published=false (çeviri henüz
-- yayına alınmadı, bir sonraki migration'da alınacak).
INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'connecting-to-postgresql', 'BEGINNER', 15, 2
FROM category
WHERE slug = 'postgresql-foundations';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'PostgreSQL''e Bağlanmak: psql ve Gerçek Bir Spring Boot DataSource',
       'Docker ile yerel bir PostgreSQL çalıştır, psql ile doğrudan bağlan, ve bu projenin kendi Spring Boot DataSource yapılandırmasının PostgreSQL seviyesinde gerçekte ne anlama geldiğini gör. PostgreSQL Foundations kategorisinin 2.''si.',
       'psql ile PostgreSQL''e Bağlanmak',
       'Docker ile PostgreSQL çalıştırma, psql komut satırı istemcisi, ve bir Spring Boot DataSource''unun JDBC URL''i gerçekte ne anlama gelir -- gerçek proje yapılandırmasıyla anlatılıyor.',
       true
FROM topic
WHERE slug = 'connecting-to-postgresql';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Connecting to PostgreSQL: psql and a Real Spring Boot DataSource',
       'Run PostgreSQL locally with Docker, connect directly with psql, and see what this project''s own Spring Boot DataSource configuration actually means at the PostgreSQL level. The 2nd lesson in the PostgreSQL Foundations category.',
       'Connecting to PostgreSQL with psql',
       'Running PostgreSQL with Docker, the psql command-line client, and what a Spring Boot DataSource''s JDBC URL actually means -- explained with a real project configuration.',
       false
FROM topic
WHERE slug = 'connecting-to-postgresql';
