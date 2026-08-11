-- Request ve Response Handling konusu, 14 örneğin tamamı. Dosyaların kendisi
-- examples/request-response-handling/ altında.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@RequestBody: İstek Gövdesini Nesneye Çevirmek', 'RequestBodyBasicExample', 1
FROM topic WHERE slug = 'request-response-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'HttpMessageConverter: Perde Arkası', 'HttpMessageConverterExample', 2
FROM topic WHERE slug = 'request-response-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'İç İçe Nesneler ve Listelerin Deserialize Edilmesi', 'NestedObjectDeserializationExample', 3
FROM topic WHERE slug = 'request-response-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Eksik ya da Fazla Alanlar: Jackson Nasıl Davranır?', 'UnknownFieldsToleranceExample', 4
FROM topic WHERE slug = 'request-response-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'ResponseEntity: Yanıtı Tam Kontrol Etmek', 'ResponseEntityBasicExample', 5
FROM topic WHERE slug = 'request-response-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'ResponseEntity ile Header Eklemek', 'ResponseEntityHeadersExample', 6
FROM topic WHERE slug = 'request-response-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '2xx Başarı Kodları: 200, 201, 204', 'StatusCode2xxExample', 7
FROM topic WHERE slug = 'request-response-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '4xx İstemci Hataları: 400, 401, 403, 404, 409', 'StatusCode4xxExample', 8
FROM topic WHERE slug = 'request-response-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '5xx Sunucu Hataları: 500', 'StatusCode5xxExample', 9
FROM topic WHERE slug = 'request-response-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Content Negotiation: Accept ile Temsil Seçmek', 'ContentNegotiationExample', 10
FROM topic WHERE slug = 'request-response-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Sipariş Oluşturma API''si — Controller', 'OrderApiController', 11
FROM topic WHERE slug = 'request-response-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Sipariş Oluşturma API''si — Çalıştırma', 'OrderApiDemo', 12
FROM topic WHERE slug = 'request-response-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: HttpMessageConverter Zinciri Simülasyonu', 'MessageConverterSimulation', 13
FROM topic WHERE slug = 'request-response-handling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Converter Zincirini Çalıştırmak', 'MessageConverterDemo', 14
FROM topic WHERE slug = 'request-response-handling';
