-- inter-service-communication konusu, 8 örneğin tamamı (7 .java + 1 .yml).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'inventory-service''in Giriş Noktası', 'InventoryServiceApplication', 1
FROM topic WHERE slug = 'inter-service-communication';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'inventory-service''in Kendi application.yml''i', 'InventoryServiceConfig', 2
FROM topic WHERE slug = 'inter-service-communication';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Stok Sorgulama: REST Controller', 'InventoryController', 3
FROM topic WHERE slug = 'inter-service-communication';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Stok Sorgulama: Service Katmanı', 'InventoryService', 4
FROM topic WHERE slug = 'inter-service-communication';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'inventory-service''in Domain Modeli', 'InventoryItem', 5
FROM topic WHERE slug = 'inter-service-communication';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'order-service''ten Senkron Çağrı: RestClient', 'StockClient', 6
FROM topic WHERE slug = 'inter-service-communication';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Servisler Arası DTO', 'StockCheckResponse', 7
FROM topic WHERE slug = 'inter-service-communication';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Parçaları Birleştirmek: Güncellenmiş OrderService', 'OrderService', 8
FROM topic WHERE slug = 'inter-service-communication';
