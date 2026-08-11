-- Faz 18 devamı: kullanıcı kararıyla orijinal sekiz topic'lik plandaki "Request
-- Mapping & HTTP Methods" (ChatGPT taslağının da "oldukça kapsamlı olabilir" dediği
-- konu) ikiye bölündü. Bu, bölünmenin ilk parçası -- @RequestMapping ve beş kısayolu
-- (@GetMapping/@PostMapping/@PutMapping/@PatchMapping/@DeleteMapping), consumes/
-- produces, ve HTTP metotlarının safe/idempotent semantiği. İkinci parça
-- (path-variables-request-parameters -- URL mapping desenleri, @PathVariable,
-- @RequestParam, @RequestHeader) sonraki bir fazda ele alınacak.
--
-- spring-mvc-fundamentals=1'den sonra sort_order=2. Fundamentals'la aynı
-- INTERMEDIATE zorlukta -- ADVANCED, kategorinin ilerideki konularına (Advanced
-- Spring MVC, REST API Design, Testing) bırakıldı.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'mapping-annotations-http-methods', 'INTERMEDIATE', 5, 2
FROM category
WHERE slug = 'spring-mvc';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Mapping Annotation''ları ve HTTP Metotları',
       '@RequestMapping ve beş kısayolu (@GetMapping/@PostMapping/@PutMapping/@PatchMapping/@DeleteMapping), consumes/produces ve HTTP metotlarının safe/idempotent semantiği.',
       'Spring MVC Mapping Annotation''ları: @GetMapping, @PostMapping ve Diğerleri | Örneklerle',
       'Spring MVC''de @RequestMapping ve beş kısayolu, sınıf/metot seviyesinde birleştirme, consumes/produces, HTTP metotlarının safe ve idempotent kavramları, PUT ile PATCH farkı ve 405 Method Not Allowed gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'mapping-annotations-http-methods';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Mapping Annotations & HTTP Methods',
       '@RequestMapping and its five shortcuts (@GetMapping/@PostMapping/@PutMapping/@PatchMapping/@DeleteMapping), consumes/produces, and the safe/idempotent semantics of HTTP methods.',
       'Spring MVC Mapping Annotations: @GetMapping, @PostMapping, and More | With Examples',
       'Spring MVC''s @RequestMapping and its five shortcuts, combining class/method-level mappings, consumes/produces, the safe and idempotent concepts behind HTTP methods, the PUT vs. PATCH difference, and 405 Method Not Allowed -- all with real examples.',
       false
FROM topic
WHERE slug = 'mapping-annotations-http-methods';
