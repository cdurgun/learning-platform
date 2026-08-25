-- PostgreSQL kursu, YENİ kategori "Advanced PostgreSQL"
-- (advanced-postgresql, sort_order=2, postgresql-foundations'ın hemen
-- ardına), ve bu kategorinin Topic 1'i: "Subqueries, CTEs, and Window
-- Functions"
-- (subqueries-ctes-and-window-functions, sort_order=1, ADVANCED --
-- onaylanan roadmap'te belirtildiği gibi). Kod embed'i YOK -- SQL
-- örnekleri bu projenin kendi GERÇEK topic/category tablosu üzerinde
-- yazılmış inline ```sql fence'ler, ayrı bir "sections" migration'ı
-- gerektirmiyor. TR published=true, EN published=false.
INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'Advanced PostgreSQL', 'advanced-postgresql', 2
FROM course
WHERE slug = 'postgresql';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'subqueries-ctes-and-window-functions', 'ADVANCED', 30, 1
FROM category
WHERE slug = 'advanced-postgresql';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Subqueries, CTEs, and Window Functions',
       'Scalar ve korelasyonlu subquery''ler, WITH (CTE) zincirleme, ve window fonksiyonları (ROW_NUMBER, RANK, PARTITION BY) -- GROUP BY''nin aksine satırları çökertmeden onlar arasında hesaplama, bu projenin kendi gerçek topic tablosuyla. Advanced PostgreSQL kategorisinin 1.''i.',
       'PostgreSQL''de Subquery''ler, CTE''ler ve Window Fonksiyonları',
       'Scalar/korelasyonlu subquery''ler, WITH (CTE), ve ROW_NUMBER/RANK/PARTITION BY window fonksiyonları bu projenin kendi gerçek verisiyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'subqueries-ctes-and-window-functions';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Subqueries, CTEs, and Window Functions',
       'Scalar and correlated subqueries, chained WITH (CTEs), and window functions (ROW_NUMBER, RANK, PARTITION BY) -- computing across rows without collapsing them the way GROUP BY does, with this project''s own real topic table. The 1st lesson in the Advanced PostgreSQL category.',
       'Subqueries, CTEs, and Window Functions in PostgreSQL',
       'Scalar/correlated subqueries, WITH (CTEs), and ROW_NUMBER/RANK/PARTITION BY window functions, explained with this project''s own real data.',
       false
FROM topic
WHERE slug = 'subqueries-ctes-and-window-functions';
