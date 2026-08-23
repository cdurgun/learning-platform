-- `distributed-transactions` konusu, 5 örneğin tamamı -- Maven Central bu
-- sandbox'tan engelli olduğu için gerçek mvn/spring-kafka ile derlenip
-- çalıştırılamadı (bkz. V306'daki not) -- kategorinin bilinen sandbox kısıtı,
-- önceki topic'lerle aynı. Kod yorumları ve açıklama metinleri İNGİLİZCE
-- yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Kompansasyon Olayı: StockReservationFailedEvent', 'StockReservationFailedEvent', 1
FROM topic WHERE slug = 'distributed-transactions';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'inventory-service''in Saga Adımı: Rezervasyon Denemesi', 'InventoryReservationListener', 2
FROM topic WHERE slug = 'distributed-transactions';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Sipariş Durumu: OrderStatus', 'OrderStatus', 3
FROM topic WHERE slug = 'distributed-transactions';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Kompansasyon Adımı: Siparişi İptal Etmek', 'OrderCancellationListener', 4
FROM topic WHERE slug = 'distributed-transactions';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Outbox Deseni ile Güvenilir Olay Yayınlama', 'OutboxEventPublisher', 5
FROM topic WHERE slug = 'distributed-transactions';
