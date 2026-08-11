-- Spring MVC kategorisinin altıncı konusu: Spring MVC Views ve Thymeleaf --
-- Model/ModelMap/ModelAndView, Thymeleaf'in "natural templating" felsefesi,
-- Thymeleaf değişken/link/mesaj ifadeleri (@{...}, #{...} ve dolar-süslü-parantez erişimi), th:if/th:each/th:fragment, SpringEL seçim
-- ifadeleri (.?[...] / #vars), th:object/th:field (kısa bakış), ve MVC vs REST
-- karşılaştırması -- projenin kendi fragments/layout.html ve topic.html'ine
-- referansla anlatılıyor.
-- validation-exception-handling=5'ten sonra sort_order=6, aynı INTERMEDIATE
-- zorlukta.
--
-- Kullanıcı kararıyla bu fazdan itibaren TR tamamlanır tamamlanmaz EN de onay
-- beklenmeden yazılıyor (bkz. CLAUDE.md "Sıradaki Adım") -- yine de tarihsel
-- tutarlılık için TR önce published=true, EN published=false olarak ekleniyor,
-- ayrı bir "publish_..._english" migration'ıyla hemen ardından yayına alınıyor.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'spring-mvc-views-thymeleaf', 'INTERMEDIATE', 5, 6
FROM category
WHERE slug = 'spring-mvc';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Spring MVC Views ve Thymeleaf',
       'Model, ModelMap ve ModelAndView ile view''a veri taşımanın üç yolu; Thymeleaf''in "natural templating" felsefesi; Thymeleaf değişken/link/mesaj ifadeleri (@{...}, #{...} ve dolar-süslü-parantez erişimi); th:if, th:each, th:fragment; SpringEL seçim ifadeleri (.?[...] / #vars); ve projenin kendi layout''una referansla MVC vs REST karşılaştırması.',
       'Spring MVC''de View Katmanı ve Thymeleaf | Gerçek Örneklerle',
       'Spring MVC''de Model/ModelAndView, Thymeleaf''in natural templating felsefesi, Thymeleaf değişken/link/mesaj ifadeleri (@{...}, #{...} ve dolar-süslü-parantez erişimi), th:if/th:each/th:fragment, SpringEL seçim ifadeleri (.?[...] / #vars) ve th:object/th:field gerçek örneklerle, projenin kendi layout.html''ine referansla anlatılıyor.',
       true
FROM topic
WHERE slug = 'spring-mvc-views-thymeleaf';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Spring MVC Views and Thymeleaf',
       'Three ways to carry data to the view with Model, ModelMap, and ModelAndView; Thymeleaf''s "natural templating" philosophy; Thymeleaf variable/link/message expressions (@{...}, #{...}, and dollar-brace variable access); th:if, th:each, th:fragment; SpringEL selection expressions (.?[...] / #vars); and MVC vs. REST, with reference to this project''s own layout.',
       'Spring MVC View Layer and Thymeleaf | With Real Examples',
       'Model/ModelAndView in Spring MVC, Thymeleaf''s natural templating philosophy, Thymeleaf variable/link/message expressions (@{...}, #{...}, and dollar-brace variable access), th:if/th:each/th:fragment, SpringEL selection expressions (.?[...] / #vars), and th:object/th:field, all with real examples referencing this project''s own layout.html.',
       false
FROM topic
WHERE slug = 'spring-mvc-views-thymeleaf';
