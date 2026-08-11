-- Mapping Annotation'ları ve HTTP Metotları konusu, 12 örneğin tamamı (TR içerik tek
-- seferde tamamlandı). Dosyaların kendisi
-- examples/mapping-annotations-http-methods/ altında.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@RequestMapping: Temel Mapping Annotation''ı', 'RequestMappingBaseExample', 1
FROM topic WHERE slug = 'mapping-annotations-http-methods';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@GetMapping, @PostMapping ve Diğer Kısayollar', 'ShortcutMappingAnnotationsExample', 2
FROM topic WHERE slug = 'mapping-annotations-http-methods';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Sınıf ve Metot Seviyesinde @RequestMapping''i Birleştirmek', 'ClassLevelRequestMappingExample', 3
FROM topic WHERE slug = 'mapping-annotations-http-methods';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Content Type Belirtmek: consumes ve produces', 'ConsumesProducesExample', 4
FROM topic WHERE slug = 'mapping-annotations-http-methods';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'HTTP Metotları: Safe ve Idempotent Kavramları', 'SafeAndIdempotentExample', 5
FROM topic WHERE slug = 'mapping-annotations-http-methods';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Aynı Path, Farklı HTTP Metotları', 'HttpMethodDisambiguationExample', 6
FROM topic WHERE slug = 'mapping-annotations-http-methods';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'PUT vs PATCH: Tam Güncelleme vs Kısmi Güncelleme', 'PutVsPatchExample', 7
FROM topic WHERE slug = 'mapping-annotations-http-methods';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'DELETE ve Idempotency', 'DeleteIdempotencyExample', 8
FROM topic WHERE slug = 'mapping-annotations-http-methods';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Basit Bir Kitap CRUD API''si — Controller', 'BookCrudController', 9
FROM topic WHERE slug = 'mapping-annotations-http-methods';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Basit Bir Kitap CRUD API''si — Çalıştırma', 'BookCrudDemo', 10
FROM topic WHERE slug = 'mapping-annotations-http-methods';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: HTTP Metodu Duyarlı Router — Simülasyon', 'RouterWithMethodSimulation', 11
FROM topic WHERE slug = 'mapping-annotations-http-methods';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: HTTP Metodu Duyarlı Router — Çalıştırma', 'RouterWithMethodDemo', 12
FROM topic WHERE slug = 'mapping-annotations-http-methods';
