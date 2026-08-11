-- REST API Tasarımı konusu, 15 örneğin tamamı. Dosyaların kendisi
-- examples/rest-api-design/ altında.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Entity''yi Doğrudan Dışarı Vermenin Riskleri: Neden DTO?', 'EntityLeakageRiskExample', 1
FROM topic WHERE slug = 'rest-api-design';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'DTO Deseni: Record ile İstek/Yanıt Ayrımı', 'DtoRecordExample', 2
FROM topic WHERE slug = 'rest-api-design';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Entity ↔ DTO Dönüşümü: Elle Mapping', 'EntityToDtoMappingExample', 3
FROM topic WHERE slug = 'rest-api-design';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Sayfalama (Pagination): Pageable ve Page<T>', 'PaginationExample', 4
FROM topic WHERE slug = 'rest-api-design';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Sıralama (Sorting): Sort ile Çoklu Alan', 'SortingExample', 5
FROM topic WHERE slug = 'rest-api-design';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Filtreleme: Query Parametreleriyle Dinamik Sorgu', 'DynamicFilterExample', 6
FROM topic WHERE slug = 'rest-api-design';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Sayfalanmış Yanıtın Şekli: content, totalElements, totalPages', 'PagedResponseShapeExample', 7
FROM topic WHERE slug = 'rest-api-design';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'API Versioning: URI Versioning vs Header Versioning', 'ApiVersioningExample', 8
FROM topic WHERE slug = 'rest-api-design';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Idempotency Nedir? Doğal Olarak Idempotent Metotlar', 'IdempotentMethodsExample', 9
FROM topic WHERE slug = 'rest-api-design';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Idempotency-Key Header''ı ile POST''u Idempotent Yapmak', 'IdempotencyKeyExample', 10
FROM topic WHERE slug = 'rest-api-design';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'HATEOAS Nedir? (Kısa Bakış)', 'HateoasConceptExample', 11
FROM topic WHERE slug = 'rest-api-design';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Sayfalanmış ve Filtrelenmiş Konu Kataloğu — Controller', 'PaginatedCatalogController', 12
FROM topic WHERE slug = 'rest-api-design';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Sayfalanmış ve Filtrelenmiş Konu Kataloğu — Çalıştırma', 'PaginatedCatalogDemo', 13
FROM topic WHERE slug = 'rest-api-design';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Idempotency Key Destekli Sipariş Oluşturma — Controller', 'IdempotentOrderController', 14
FROM topic WHERE slug = 'rest-api-design';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Idempotency Key Destekli Sipariş Oluşturma — Çalıştırma', 'IdempotentOrderDemo', 15
FROM topic WHERE slug = 'rest-api-design';
