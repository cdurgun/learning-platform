-- Path Variable'lar ve Request Parametreleri konusu, 14 örneğin tamamı (TR içerik tek
-- seferde tamamlandı). Dosyaların kendisi
-- examples/path-variables-request-parameters/ altında.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@PathVariable: URL''den Değer Okumak', 'PathVariableBasicExample', 1
FROM topic WHERE slug = 'path-variables-request-parameters';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Birden Fazla Path Variable', 'MultiplePathVariablesExample', 2
FROM topic WHERE slug = 'path-variables-request-parameters';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Path Variable Adını Eşlemek: value Attribute''u', 'PathVariableNameMappingExample', 3
FROM topic WHERE slug = 'path-variables-request-parameters';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Path Variable mi, Query Parameter mı?', 'PathVsQueryParamExample', 4
FROM topic WHERE slug = 'path-variables-request-parameters';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@RequestParam: Query String''den Değer Okumak', 'RequestParamBasicExample', 5
FROM topic WHERE slug = 'path-variables-request-parameters';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Zorunlu, Opsiyonel ve Varsayılan Değerli Parametreler', 'RequestParamOptionalDefaultExample', 6
FROM topic WHERE slug = 'path-variables-request-parameters';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Birden Fazla Değerli Parametreler: List ve Array', 'RequestParamListExample', 7
FROM topic WHERE slug = 'path-variables-request-parameters';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Tüm Query Parametrelerini Almak: Map', 'RequestParamMapExample', 8
FROM topic WHERE slug = 'path-variables-request-parameters';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@RequestHeader: HTTP Header''larını Okumak', 'RequestHeaderExample', 9
FROM topic WHERE slug = 'path-variables-request-parameters';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Tip Dönüşümü ve Hatalı Değerler: 400 Bad Request', 'TypeConversionErrorExample', 10
FROM topic WHERE slug = 'path-variables-request-parameters';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Katalog Arama API''si — Controller', 'SearchApiController', 11
FROM topic WHERE slug = 'path-variables-request-parameters';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Katalog Arama API''si — Çalıştırma', 'SearchApiDemo', 12
FROM topic WHERE slug = 'path-variables-request-parameters';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Argüman Bağlayıcı Simülasyonu', 'RequestBinderSimulation', 13
FROM topic WHERE slug = 'path-variables-request-parameters';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Argüman Bağlayıcıyı Çalıştırmak', 'RequestBinderDemo', 14
FROM topic WHERE slug = 'path-variables-request-parameters';
