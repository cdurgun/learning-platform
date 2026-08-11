-- Spring MVC kategorisinin sekizinci konusu: REST API Tasarımı --
-- DTO deseni (entity'yi doğrudan dışarı vermenin riskleri, record ile istek/yanıt
-- ayrımı), Pageable/Page/Sort ile sayfalama ve sıralama, query parametreleriyle
-- filtreleme, API versioning (URI vs header), idempotency ve Idempotency-Key
-- header'ı, HATEOAS (kısa bakış -- spring-hateoas projede yok).
-- advanced-spring-mvc=7'den sonra sort_order=8, ikinci ADVANCED konu.
--
-- Kullanıcı kararıyla bu fazdan itibaren TR tamamlanır tamamlanmaz EN de onay
-- beklenmeden yazılıyor (bkz. CLAUDE.md "Sıradaki Adım") -- yine de tarihsel
-- tutarlılık için TR önce published=true, EN published=false olarak ekleniyor,
-- ayrı bir "publish_..._english" migration'ıyla hemen ardından yayına alınıyor.
-- Bu migration'da literal dolar-süslü-parantez sözdizimi kullanılmadı (Faz 23'te
-- yaşanan Flyway placeholder hatası nedeniyle -- bkz. CLAUDE.md "Kesinlikle
-- Değişmeyecek Kurallar").

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'rest-api-design', 'ADVANCED', 5, 8
FROM category
WHERE slug = 'spring-mvc';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'REST API Tasarımı',
       'Entity''yi doğrudan dışarı vermenin riskleri ve DTO deseni; Pageable/Page/Sort ile sayfalama, sıralama ve query parametreleriyle filtreleme; URI versioning vs header versioning; idempotency ve Idempotency-Key header''ı ile POST''u idempotent yapmak; HATEOAS (kısa bakış).',
       'Spring MVC''de REST API Tasarımı | DTO, Sayfalama, Versioning, Idempotency',
       'Spring MVC''de entity''yi doğrudan dışarı vermenin riskleri ve DTO deseni, Pageable/Page/Sort ile sayfalama ve filtreleme, URI vs header API versioning, idempotency ve Idempotency-Key header''ı, HATEOAS gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'rest-api-design';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'REST API Design',
       'The risks of returning an entity directly and the DTO pattern; pagination, sorting, and filtering with Pageable/Page/Sort and query parameters; URI versioning vs. header versioning; idempotency and making POST idempotent with the Idempotency-Key header; HATEOAS (a quick look).',
       'REST API Design in Spring MVC | DTOs, Pagination, Versioning, Idempotency',
       'The risks of returning an entity directly and the DTO pattern, pagination and filtering with Pageable/Page/Sort, URI vs. header API versioning, idempotency and the Idempotency-Key header, and HATEOAS in Spring MVC, all with real examples.',
       false
FROM topic
WHERE slug = 'rest-api-design';
