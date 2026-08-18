-- `service-discovery-eureka` konusu, 7 örneğin tamamı -- Maven Central bu sandbox'tan
-- engelli olduğu için gerçek mvn/Spring Cloud ile derlenip çalıştırılamadı (bkz. V231'deki
-- not) -- kategorinin bilinen sandbox kısıtı, önceki iki topic'le aynı. Kod yorumları ve
-- açıklama metinleri İNGİLİZCE yazıldı (bkz. Faz 53 -- örnek dosyalar dile göre
-- ayrılmadığı için tek kaynak her iki dilde de doğru görünmeli).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Eureka Server Uygulaması', 'EurekaServerApplication', 1
FROM topic WHERE slug = 'service-discovery-eureka';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Eureka Server Yapılandırması', 'EurekaServerConfig', 2
FROM topic WHERE slug = 'service-discovery-eureka';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'order-service''in Eureka Client Yapılandırması', 'OrderServiceEurekaConfig', 3
FROM topic WHERE slug = 'service-discovery-eureka';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'DiscoveryClient ile Doğrudan Sorgu', 'DiscoveryClientExample', 4
FROM topic WHERE slug = 'service-discovery-eureka';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Load-Balanced RestClient Yapılandırması', 'LoadBalancedRestClientConfig', 5
FROM topic WHERE slug = 'service-discovery-eureka';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'StockClient''ın Keşif Tabanlı Hâli', 'StockClientWithDiscovery', 6
FROM topic WHERE slug = 'service-discovery-eureka';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'StockCheckResponse (Değişmedi)', 'StockCheckResponse', 7
FROM topic WHERE slug = 'service-discovery-eureka';
