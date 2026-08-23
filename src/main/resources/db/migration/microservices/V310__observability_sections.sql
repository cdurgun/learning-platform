-- `observability` konusu, 5 örneğin tamamı -- Maven Central bu sandbox'tan
-- engelli olduğu için gerçek mvn/Micrometer ile derlenip çalıştırılamadı (bkz.
-- V309'daki not) -- kategorinin bilinen sandbox kısıtı, önceki topic'lerle
-- aynı. Kod yorumları ve açıklama metinleri İNGİLİZCE yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Correlation Id''yi MDC''ye Taşımak', 'CorrelationIdMdcFilter', 1
FROM topic WHERE slug = 'observability';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Structured (JSON) Log Yapılandırması', 'LogbackJsonConfig', 2
FROM topic WHERE slug = 'observability';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Correlation Id''yi Giden Çağrılara Taşımak', 'RestClientCorrelationIdInterceptor', 3
FROM topic WHERE slug = 'observability';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Actuator Metrik Yapılandırması', 'ActuatorMetricsConfig', 4
FROM topic WHERE slug = 'observability';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Micrometer ile Özel Bir Metrik', 'OrderMetrics', 5
FROM topic WHERE slug = 'observability';
