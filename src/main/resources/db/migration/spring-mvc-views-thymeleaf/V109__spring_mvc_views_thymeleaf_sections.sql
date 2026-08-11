-- Spring MVC Views ve Thymeleaf konusu, 15 örneğin tamamı. Dosyaların kendisi
-- examples/spring-mvc-views-thymeleaf/ altında.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Model, ModelMap ve ModelAndView: Veriyi View''a Taşımanın Üç Yolu', 'ModelVariantsExample', 1
FROM topic WHERE slug = 'spring-mvc-views-thymeleaf';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Thymeleaf Nedir? "Natural Templating" Felsefesi', 'NaturalTemplatingExample', 2
FROM topic WHERE slug = 'spring-mvc-views-thymeleaf';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Değişken İfadeleri: Dolar-Süslü-Parantez ile Model Verisine Erişmek', 'VariableExpressionExample', 3
FROM topic WHERE slug = 'spring-mvc-views-thymeleaf';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Link İfadeleri: @{...} ile URL Oluşturmak', 'LinkExpressionExample', 4
FROM topic WHERE slug = 'spring-mvc-views-thymeleaf';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Metin Görüntüleme: th:text vs th:utext', 'TextVsUtextExample', 5
FROM topic WHERE slug = 'spring-mvc-views-thymeleaf';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Koşullu Render: th:if ve th:unless', 'ConditionalRenderExample', 6
FROM topic WHERE slug = 'spring-mvc-views-thymeleaf';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Döngüler: th:each ile Liste Render Etmek', 'IterationExample', 7
FROM topic WHERE slug = 'spring-mvc-views-thymeleaf';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mesaj İfadeleri: #{...} ile i18n Entegrasyonu', 'MessageExpressionExample', 8
FROM topic WHERE slug = 'spring-mvc-views-thymeleaf';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Fragment''ler: th:fragment, th:insert ve th:replace', 'FragmentExample', 9
FROM topic WHERE slug = 'spring-mvc-views-thymeleaf';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'SpringEL Seçim İfadeleri: .?[...] ve #vars', 'SelectionExpressionExample', 10
FROM topic WHERE slug = 'spring-mvc-views-thymeleaf';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Form Binding (Kısa Bakış): th:object ve th:field', 'FormBindingExample', 11
FROM topic WHERE slug = 'spring-mvc-views-thymeleaf';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Basit Bir Blog Sayfası — Şablon', 'BlogPageTemplateExample', 12
FROM topic WHERE slug = 'spring-mvc-views-thymeleaf';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Basit Bir Blog Sayfası — Çalıştırma', 'BlogPageDemo', 13
FROM topic WHERE slug = 'spring-mvc-views-thymeleaf';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: i18n Destekli Ürün Kartı — Şablon', 'ProductCardTemplateExample', 14
FROM topic WHERE slug = 'spring-mvc-views-thymeleaf';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: i18n Destekli Ürün Kartı — Çalıştırma', 'ProductCardDemo', 15
FROM topic WHERE slug = 'spring-mvc-views-thymeleaf';
