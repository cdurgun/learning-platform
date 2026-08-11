-- Spring MVC kategorisinin yedinci konusu: Advanced Spring MVC --
-- HandlerInterceptor (preHandle/postHandle/afterCompletion), Filter vs Interceptor,
-- WebMvcConfigurer (interceptor kaydı + CORS), CORS (same-origin policy, preflight,
-- @CrossOrigin), multipart file upload (MultipartFile, boyut sınırları).
-- spring-mvc-views-thymeleaf=6'dan sonra sort_order=7 -- kategorinin ilk ADVANCED
-- konusu (önceki beşi INTERMEDIATE'ti).
--
-- Kullanıcı kararıyla bu fazdan itibaren TR tamamlanır tamamlanmaz EN de onay
-- beklenmeden yazılıyor (bkz. CLAUDE.md "Sıradaki Adım") -- yine de tarihsel
-- tutarlılık için TR önce published=true, EN published=false olarak ekleniyor,
-- ayrı bir "publish_..._english" migration'ıyla hemen ardından yayına alınıyor.
-- NOT: Bu migration'da literal dolar-süslü-parantez sözdizimi YAZILMADI (Faz
-- 23'te yaşanan Flyway placeholder hatası nedeniyle -- bkz. CLAUDE.md
-- "Kesinlikle Değişmeyecek Kurallar" bölümündeki ilgili madde); zaten bu
-- konunun metninde $ işaretli bir sözdizimi geçmiyor.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'advanced-spring-mvc', 'ADVANCED', 5, 7
FROM category
WHERE slug = 'spring-mvc';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Advanced Spring MVC',
       'HandlerInterceptor (preHandle/postHandle/afterCompletion) ve Filter vs Interceptor ayrımı; WebMvcConfigurer ile interceptor kaydı ve global CORS yapılandırması; same-origin policy, preflight request ve @CrossOrigin; MultipartFile ile dosya yükleme ve boyut sınırları.',
       'Spring MVC''de Interceptor, CORS ve Dosya Yükleme | Gerçek Örneklerle',
       'Spring MVC''de HandlerInterceptor yaşam döngüsü, Filter vs Interceptor, WebMvcConfigurer ile interceptor kaydı ve CORS yapılandırması, same-origin policy ve preflight request, @CrossOrigin, MultipartFile ile dosya yükleme ve boyut sınırları gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'advanced-spring-mvc';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Advanced Spring MVC',
       'HandlerInterceptor (preHandle/postHandle/afterCompletion) and the Filter vs. Interceptor distinction; registering interceptors and configuring global CORS with WebMvcConfigurer; same-origin policy, the preflight request, and @CrossOrigin; file uploads with MultipartFile and size limits.',
       'Interceptors, CORS, and File Upload in Spring MVC | With Real Examples',
       'The HandlerInterceptor lifecycle in Spring MVC, Filter vs. Interceptor, registering interceptors and configuring CORS with WebMvcConfigurer, same-origin policy and the preflight request, @CrossOrigin, and file uploads with MultipartFile and size limits, all with real examples.',
       false
FROM topic
WHERE slug = 'advanced-spring-mvc';
