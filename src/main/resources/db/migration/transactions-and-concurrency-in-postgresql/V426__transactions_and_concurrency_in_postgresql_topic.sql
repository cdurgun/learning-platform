-- PostgreSQL kursu, Advanced PostgreSQL kategorisi, Topic 4 (SON):
-- "Transactions and Concurrency in PostgreSQL"
-- (indexes-and-query-performance-with-explain'in hemen ardına,
-- sort_order=4, ADVANCED -- onaylanan roadmap'te belirtildiği gibi, bu
-- topic'le hem Advanced PostgreSQL kategorisi (4/4) HEM DE tüm PostgreSQL
-- kursu (14/14) TAMAMLANIYOR). Kod embed'i YOK -- SQL örnekleri bu
-- projenin kendi GERÇEK topic tablosu üzerinde yazılmış, BEGIN/COMMIT/
-- ROLLBACK ve FOR UPDATE'i gösteren inline ```sql fence'ler, ayrı bir
-- "sections" migration'ı gerektirmiyor. TR published=true, EN
-- published=false.
INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'transactions-and-concurrency-in-postgresql', 'ADVANCED', 30, 4
FROM category
WHERE slug = 'advanced-postgresql';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Transactions and Concurrency in PostgreSQL',
       'psql''de gerçek BEGIN/COMMIT/ROLLBACK, MVCC''nin mekanik açıklaması (xmin/xmax), SELECT ... FOR UPDATE ile satır-seviyesi kilitleme, ve bilerek üretilip açıklanan bir deadlock -- "Transaction Management"in isolation kapsamını TEKRARLAMADAN. Advanced PostgreSQL kategorisinin 4.''ü ve SONUNCUSU -- PostgreSQL kursunun 14/14 topic''ini tamamlıyor.',
       'PostgreSQL''de Transaction''lar ve Concurrency',
       'BEGIN/COMMIT/ROLLBACK, MVCC, SELECT ... FOR UPDATE satır kilitleme, ve deadlock''lar bu projenin kendi gerçek verisiyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'transactions-and-concurrency-in-postgresql';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Transactions and Concurrency in PostgreSQL',
       'Real BEGIN/COMMIT/ROLLBACK in psql, MVCC explained mechanically (xmin/xmax), row-level locking with SELECT ... FOR UPDATE, and a deadlock produced and explained on purpose -- without repeating "Transaction Management"''s isolation coverage. The 4th and FINAL lesson in the Advanced PostgreSQL category -- completing 14/14 topics in the PostgreSQL course.',
       'Transactions and Concurrency in PostgreSQL',
       'BEGIN/COMMIT/ROLLBACK, MVCC, SELECT ... FOR UPDATE row locking, and deadlocks, explained with this project''s own real data.',
       false
FROM topic
WHERE slug = 'transactions-and-concurrency-in-postgresql';
