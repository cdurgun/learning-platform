-- Spring MVC Fundamentals konusu, TR içerik tek seferde tamamlandığı için (önceki
-- konularda olduğu gibi iki aşamalı sections_1_to_N / sections_N_to_ek bölünmesine
-- gerek kalmadan) 11 örneğin tamamı tek migration'da. Dosyaların kendisi
-- examples/spring-mvc-fundamentals/ altında; bağlantı slug + example_name convention'ıyla.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'MVC Deseni: Model, View, Controller (Saf Java)', 'MvcPatternExample', 1
FROM topic WHERE slug = 'spring-mvc-fundamentals';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'DispatcherServlet Simülasyonu: Front Controller Deseni', 'FrontControllerSimulationExample', 2
FROM topic WHERE slug = 'spring-mvc-fundamentals';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@Controller ile İlk Endpoint', 'FirstControllerExample', 3
FROM topic WHERE slug = 'spring-mvc-fundamentals';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Model ile View''a Veri Taşımak', 'ModelUsageExample', 4
FROM topic WHERE slug = 'spring-mvc-fundamentals';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'İlk @RestController: Düz Metin Yanıt', 'FirstRestControllerExample', 5
FROM topic WHERE slug = 'spring-mvc-fundamentals';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@RestController ile JSON Serileştirme', 'RestControllerJsonExample', 6
FROM topic WHERE slug = 'spring-mvc-fundamentals';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@Controller + @ResponseBody = @RestController', 'ResponseBodyMetaAnnotationExample', 7
FROM topic WHERE slug = 'spring-mvc-fundamentals';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Ürün Kataloğu — Sayfa ve API Controller''ları', 'ProductCatalogControllers', 8
FROM topic WHERE slug = 'spring-mvc-fundamentals';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Ürün Kataloğu — Controller''ları Doğrudan Çalıştırmak', 'ProductCatalogDemo', 9
FROM topic WHERE slug = 'spring-mvc-fundamentals';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Çok Controller''lı İstek Yönlendirme', 'RequestRouterSimulation', 10
FROM topic WHERE slug = 'spring-mvc-fundamentals';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: İstek Yönlendirmeyi Çalıştırmak', 'RequestRouterDemo', 11
FROM topic WHERE slug = 'spring-mvc-fundamentals';
