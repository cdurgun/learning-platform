-- PostgreSQL kursu, PostgreSQL Foundations kategorisi, Topic 3:
-- "Databases, Schemas, Tables, and Basic SQL Syntax"
-- (connecting-to-postgresql'in hemen ardına, sort_order=3). Kod embed'i
-- YOK -- SQL örnekleri, bu projenin kendi GERÇEK V1__init_schema.sql'inden
-- (course/category tabloları) alıntılanmış inline ```sql fence'ler, ayrı bir
-- "sections" migration'ı gerektirmiyor. TR published=true, EN
-- published=false.
INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'databases-schemas-tables-and-basic-sql', 'BEGINNER', 20, 3
FROM category
WHERE slug = 'postgresql-foundations';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Databases, Schemas, Tables, and Basic SQL Syntax',
       'Sunucu → veritabanı → şema → tablo hiyerarşisi, CREATE TABLE sözdizimi bu projenin kendi gerçek V1__init_schema.sql''i üzerinden okunarak, kolon tanımları/kısıtlar, SQL yorumları, ve DDL ile DML arasındaki ilk ayrım. PostgreSQL Foundations kategorisinin 3.''sü.',
       'PostgreSQL''de Veritabanı, Şema, Tablo ve Temel SQL Sözdizimi',
       'PostgreSQL''de veritabanı-şema-tablo hiyerarşisi ve CREATE TABLE sözdizimi, bu projenin kendi gerçek migration şemasıyla anlatılıyor.',
       true
FROM topic
WHERE slug = 'databases-schemas-tables-and-basic-sql';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Databases, Schemas, Tables, and Basic SQL Syntax',
       'The server → database → schema → table hierarchy, CREATE TABLE syntax read through this project''s own real V1__init_schema.sql, column definitions/constraints, SQL comments, and a first distinction between DDL and DML. The 3rd lesson in the PostgreSQL Foundations category.',
       'Databases, Schemas, Tables, and Basic SQL Syntax in PostgreSQL',
       'The database-schema-table hierarchy in PostgreSQL and CREATE TABLE syntax, explained through this project''s own real migration schema.',
       false
FROM topic
WHERE slug = 'databases-schemas-tables-and-basic-sql';
