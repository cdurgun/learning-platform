-- `resilience4j` konusu, 5 örneğin tamamı -- Maven Central bu sandbox'tan engelli
-- olduğu için gerçek mvn/Resilience4j ile derlenip çalıştırılamadı (bkz. V297'deki
-- not) -- kategorinin bilinen sandbox kısıtı, önceki topic'lerle aynı. Kod yorumları
-- ve açıklama metinleri İNGİLİZCE yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Resilience4j Yapılandırması (Circuit Breaker + Retry)', 'Resilience4jConfig', 1
FROM topic WHERE slug = 'resilience4j';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Circuit Breaker + Retry ile StockClient', 'ResilientStockClient', 2
FROM topic WHERE slug = 'resilience4j';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'StockCheckResponse (Değişmedi)', 'StockCheckResponse', 3
FROM topic WHERE slug = 'resilience4j';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Rate Limiter ve Bulkhead Yapılandırması', 'RateLimiterAndBulkheadConfig', 4
FROM topic WHERE slug = 'resilience4j';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Circuit Breaker Durum Geçişlerini İzlemek', 'CircuitBreakerEventListener', 5
FROM topic WHERE slug = 'resilience4j';
