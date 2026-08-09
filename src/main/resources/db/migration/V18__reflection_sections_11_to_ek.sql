-- Reflection konusu, 11-17. bölümler (Annotation'larla Çalışmak, Gerçek Dünya Kullanım
-- Alanları, Performans Değerlendirmeleri, Güvenlik Değerlendirmeleri, Best Practices,
-- Yaygın Hatalar, Özet) ile iki mini proje ekinin (DI Container, Object Inspector)
-- örnek metadata'sı. Dosyaların kendisi examples/reflection/ altında; bağlantı, önceki
-- konularda olduğu gibi slug + example_name convention'ıyla kurulur.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Annotation Okuma (RUNTIME Retention)', 'AnnotationExample', 9
FROM topic WHERE slug = 'reflection';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Test Runner (JUnit Mekanizması)', 'MiniTestRunner', 10
FROM topic WHERE slug = 'reflection';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Klasik Reflection vs MethodHandle', 'MethodHandleExample', 11
FROM topic WHERE slug = 'reflection';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Basit DI Container', 'SimpleContainer', 12
FROM topic WHERE slug = 'reflection';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: DI Container Kullanımı', 'SimpleContainerDemo', 13
FROM topic WHERE slug = 'reflection';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Object Inspector', 'ObjectInspector', 14
FROM topic WHERE slug = 'reflection';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Object Inspector Kullanımı', 'ObjectInspectorDemo', 15
FROM topic WHERE slug = 'reflection';
