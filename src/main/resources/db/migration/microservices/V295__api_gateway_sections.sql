-- `api-gateway` konusu, 5 örneğin tamamı -- Maven Central bu sandbox'tan engelli
-- olduğu için gerçek mvn/Spring Cloud Gateway ile derlenip çalıştırılamadı (bkz.
-- V294'teki not) -- kategorinin bilinen sandbox kısıtı, önceki topic'lerle aynı.
-- Kod yorumları ve açıklama metinleri İNGİLİZCE yazıldı (bkz. Faz 53 -- örnek
-- dosyalar dile göre ayrılmadığı için tek kaynak her iki dilde de doğru görünmeli).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Gateway Uygulaması', 'ApiGatewayApplication', 1
FROM topic WHERE slug = 'api-gateway';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'api-gateway''in Kendi Yapılandırması', 'ApiGatewayConfig', 2
FROM topic WHERE slug = 'api-gateway';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Rota Yapılandırması (Predicate + URI + Filtre)', 'GatewayRoutesConfig', 3
FROM topic WHERE slug = 'api-gateway';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'İstek Loglayan Global Filtre', 'RequestLoggingGlobalFilter', 4
FROM topic WHERE slug = 'api-gateway';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Correlation Id Atayan Global Filtre', 'CorrelationIdGatewayFilter', 5
FROM topic WHERE slug = 'api-gateway';
