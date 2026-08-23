-- `event-driven-kafka` konusu, 5 örneğin tamamı -- Maven Central bu sandbox'tan
-- engelli olduğu için gerçek mvn/spring-kafka ile derlenip çalıştırılamadı (bkz.
-- V303'teki not) -- kategorinin bilinen sandbox kısıtı, önceki topic'lerle aynı.
-- Kod yorumları ve açıklama metinleri İNGİLİZCE yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Olay Sözleşmesi: OrderPlacedEvent', 'OrderPlacedEvent', 1
FROM topic WHERE slug = 'event-driven-kafka';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'order-service''in Kafka Producer Yapılandırması', 'KafkaProducerConfig', 2
FROM topic WHERE slug = 'event-driven-kafka';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'OrderPlacedEvent''i Yayınlamak', 'OrderEventPublisher', 3
FROM topic WHERE slug = 'event-driven-kafka';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'inventory-service''in Kafka Consumer Yapılandırması', 'KafkaConsumerConfig', 4
FROM topic WHERE slug = 'event-driven-kafka';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Idempotent Bir Olay Dinleyicisi', 'InventoryEventListener', 5
FROM topic WHERE slug = 'event-driven-kafka';
