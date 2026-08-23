-- `configuration-management` konusu, 5 örneğin tamamı -- Maven Central bu
-- sandbox'tan engelli olduğu için gerçek mvn/Spring Cloud Config ile derlenip
-- çalıştırılamadı (bkz. V300'deki not) -- kategorinin bilinen sandbox kısıtı,
-- önceki topic'lerle aynı. Kod yorumları ve açıklama metinleri İNGİLİZCE
-- yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Config Server Uygulaması', 'ConfigServerApplication', 1
FROM topic WHERE slug = 'configuration-management';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Config Server''in Kendi Yapılandırması', 'ConfigServerConfig', 2
FROM topic WHERE slug = 'configuration-management';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Config Repository''deki order-service Dosyası', 'OrderServiceExternalConfig', 3
FROM topic WHERE slug = 'configuration-management';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'order-service''i Config Client Yapmak', 'OrderServiceConfigClientConfig', 4
FROM topic WHERE slug = 'configuration-management';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@RefreshScope ile Canlı Güncellenen Bir Controller', 'RefreshableGreetingController', 5
FROM topic WHERE slug = 'configuration-management';
