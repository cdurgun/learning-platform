-- Spring MVC kategorisinin dokuzuncu ve son konusu: Spring MVC'de Test Yazmak --
-- MockMvc ve @WebMvcTest ile web katmanı testleri, @MockitoBean ile bağımlılıkları
-- sahteleme, model()/view()/jsonPath() matcher'ları, request body/path variable/
-- query param/validation/multipart testleri.
-- rest-api-design=8'den sonra sort_order=9, üçüncü ADVANCED konu -- Spring MVC
-- kategorisinin planlanan son (9/9) konusu.
--
-- TR ve EN aynı fazda birlikte yazıldı (bkz. CLAUDE.md "Sıradaki Adım") -- yine de
-- tarihsel tutarlılık için TR önce published=true, EN published=false olarak
-- ekleniyor, ayrı bir "publish_..._english" migration'ıyla hemen ardından yayına
-- alınıyor. Bu migration'da literal dolar-süslü-parantez sözdizimi kullanılmadı
-- (bkz. CLAUDE.md "Kesinlikle Değişmeyecek Kurallar").

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'spring-mvc-testing', 'ADVANCED', 5, 9
FROM category
WHERE slug = 'spring-mvc';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Spring MVC''de Test Yazmak',
       'MockMvc ve @WebMvcTest ile web katmanı testleri; @MockitoBean ile bağımlılıkları sahteleme; model(), view() ve jsonPath() ile doğrulama; request body, path variable/query param, validation hataları ve multipart dosya yükleme testleri; bu projenin gerçek HomeController''ı ve TopicController''ı için gerçek testler.',
       'Spring MVC''de Test Yazmak | MockMvc, @WebMvcTest, @MockitoBean',
       'Spring MVC''de MockMvc ve @WebMvcTest ile web katmanı testleri, @MockitoBean ile bağımlılık sahteleme, jsonPath ile JSON doğrulama, validation ve multipart testleri, gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'spring-mvc-testing';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Testing in Spring MVC',
       'Web layer tests with MockMvc and @WebMvcTest; faking dependencies with @MockitoBean; verifying with model(), view(), and jsonPath(); testing request bodies, path variables/query params, validation errors, and multipart uploads; real tests of this project''s own HomeController and TopicController.',
       'Testing in Spring MVC | MockMvc, @WebMvcTest, @MockitoBean',
       'Web layer testing in Spring MVC with MockMvc and @WebMvcTest, faking dependencies with @MockitoBean, verifying JSON with jsonPath, and testing validation and multipart uploads, all with real examples.',
       false
FROM topic
WHERE slug = 'spring-mvc-testing';
