-- Faz 18'in ikinci bölünme parçası: orijinal "Request Mapping & HTTP Methods"
-- planının kalan yarısı -- URL mapping desenleri, @PathVariable, @RequestParam,
-- @RequestHeader. mapping-annotations-http-methods=2'den sonra sort_order=3, aynı
-- INTERMEDIATE zorlukta.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'path-variables-request-parameters', 'INTERMEDIATE', 5, 3
FROM category
WHERE slug = 'spring-mvc';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Path Variable''lar ve Request Parametreleri',
       '@PathVariable, @RequestParam ve @RequestHeader ile bir HTTP isteğinin URL''sinden ve header''larından veri okumak; path variable ile query parametresi arasındaki fark.',
       'Spring MVC''de @PathVariable ve @RequestParam Kullanımı | Örneklerle',
       'Spring MVC''de path variable''lar (@PathVariable), query parametreleri (@RequestParam) ve HTTP header''ları (@RequestHeader) okumak, List/Map bağlama, tip dönüşümü ve 400 Bad Request hataları gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'path-variables-request-parameters';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Path Variables & Request Parameters',
       'Reading data from a request''s URL and headers with @PathVariable, @RequestParam, and @RequestHeader; the difference between a path variable and a query parameter.',
       'Using @PathVariable and @RequestParam in Spring MVC | With Examples',
       'Reading path variables (@PathVariable), query parameters (@RequestParam), and HTTP headers (@RequestHeader) in Spring MVC, binding to List/Map, type conversion, and 400 Bad Request errors -- all with real examples.',
       false
FROM topic
WHERE slug = 'path-variables-request-parameters';
