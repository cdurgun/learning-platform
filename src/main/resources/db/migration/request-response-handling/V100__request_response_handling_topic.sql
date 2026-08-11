-- Spring MVC kategorisinin dördüncü konusu: Request & Response Handling --
-- @RequestBody/HttpMessageConverter, ResponseEntity, HTTP durum kodları (2xx/4xx/5xx),
-- content negotiation. path-variables-request-parameters=3'ten sonra sort_order=4,
-- aynı INTERMEDIATE zorlukta.
--
-- Kullanıcı kararıyla bu fazdan itibaren TR tamamlanır tamamlanmaz EN de onay
-- beklenmeden yazılıyor (bkz. CLAUDE.md "Sıradaki Adım") -- yine de tarihsel
-- tutarlılık için TR önce published=true, EN published=false olarak ekleniyor,
-- ayrı bir "publish_..._english" migration'ıyla hemen ardından yayına alınıyor.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'request-response-handling', 'INTERMEDIATE', 5, 4
FROM category
WHERE slug = 'spring-mvc';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Request ve Response Handling',
       '@RequestBody ile istek gövdesini nesneye çevirmek, ResponseEntity ile yanıtı tam kontrol etmek, HTTP durum kodları ve content negotiation.',
       'Spring MVC''de @RequestBody, ResponseEntity ve HTTP Durum Kodları | Örneklerle',
       'Spring MVC''de @RequestBody ile JSON deserialize etmek, HttpMessageConverter mekanizması, ResponseEntity ile durum kodu/header kontrolü, 2xx/4xx/5xx durum kodları ve content negotiation gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'request-response-handling';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Request and Response Handling',
       'Turning a request body into an object with @RequestBody, taking full control of a response with ResponseEntity, HTTP status codes, and content negotiation.',
       '@RequestBody, ResponseEntity, and HTTP Status Codes in Spring MVC | With Examples',
       'Deserializing JSON with @RequestBody in Spring MVC, the HttpMessageConverter mechanism, controlling status codes/headers with ResponseEntity, 2xx/4xx/5xx status codes, and content negotiation -- all with real examples.',
       false
FROM topic
WHERE slug = 'request-response-handling';
