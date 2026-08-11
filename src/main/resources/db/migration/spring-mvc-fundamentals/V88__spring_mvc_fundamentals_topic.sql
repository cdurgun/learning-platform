-- Faz 18: Spring Core kategorisinin beş topic'i (Faz 13-17) TR+EN tamamlandıktan sonra,
-- spring-boot kursuna ikinci bir kategori: "Spring MVC" (category.sort_order=2,
-- spring-core'dan sonra). Bu kategori kullanıcının onayladığı sekiz topic'lik bir plana
-- göre kuruluyor (Fundamentals, Request Mapping & HTTP Methods, Request & Response
-- Handling, Validation & Exception Handling, Views & Thymeleaf, Advanced Spring MVC,
-- REST API Design, Testing) -- her biri kendi topic.sort_order'ıyla, 1'den başlayarak
-- (bkz. CLAUDE.md "Birden fazla Category olabilir" kuralı).
--
-- İlk topic "Spring MVC Fundamentals": DispatcherServlet, MVC deseni, @Controller vs
-- @RestController. Spring Core'un ilk konusu (Dependency Injection) Spring'e hiç
-- değinmeden başlamıştı; burada tam tersine, konunun kendisi zaten Spring MVC'nin
-- çekirdek mekanizması olduğu için ilk bölümden itibaren gerçek Spring annotation'ları
-- kullanılıyor -- INTERMEDIATE zorlukta işaretlendi (Component Scanning/Dependency
-- Injection'la aynı seviye; ADVANCED, Advanced Spring MVC/REST API Design/Testing
-- topic'lerine bırakıldı).
--
-- Şimdilik yalnızca iskelet var -- estimated_minutes düşük tutuldu, içerik önceki
-- konularda olduğu gibi kademeli eklenecek. Kullanıcı kararıyla bu fazda önce yalnızca
-- TR tamamlanıyor; EN çevirisi ayrı bir sonraki adımda ele alınacak (EN published=false).

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'Spring MVC', 'spring-mvc', 2
FROM course
WHERE slug = 'spring-boot';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'spring-mvc-fundamentals', 'INTERMEDIATE', 5, 1
FROM category
WHERE slug = 'spring-mvc';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Spring MVC Temelleri',
       'DispatcherServlet, MVC deseni (Model/View/Controller) ve @Controller ile @RestController arasındaki fark.',
       'Spring MVC Nedir? DispatcherServlet ve MVC Deseni | Örneklerle Anlatım',
       'Spring MVC''nin temelleri: MVC deseni, DispatcherServlet''in bir isteği nasıl işlediği, embedded Tomcat, @Controller ile HTML sayfası döndürmek, @RestController ile JSON döndürmek ve ikisi arasındaki fark gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'spring-mvc-fundamentals';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Spring MVC Fundamentals',
       'DispatcherServlet, the MVC pattern (Model/View/Controller), and the difference between @Controller and @RestController.',
       'What Is Spring MVC? DispatcherServlet and the MVC Pattern | With Examples',
       'The fundamentals of Spring MVC: the MVC pattern, how DispatcherServlet handles a request, embedded Tomcat, returning an HTML page with @Controller, returning JSON with @RestController, and the difference between the two -- with real examples.',
       false
FROM topic
WHERE slug = 'spring-mvc-fundamentals';
