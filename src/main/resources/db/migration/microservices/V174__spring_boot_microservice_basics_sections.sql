-- spring-boot-microservice-basics konusu, 5 örneğin tamamı (4 .java + 1 .yml).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Bir Mikroservisin Giriş Noktası', 'OrderServiceApplication', 1
FROM topic WHERE slug = 'spring-boot-microservice-basics';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'order-service''in Kendi application.yml''i', 'OrderServiceConfig', 2
FROM topic WHERE slug = 'spring-boot-microservice-basics';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Dış Yüzey: REST Controller', 'OrderController', 3
FROM topic WHERE slug = 'spring-boot-microservice-basics';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'İş Mantığı: Service Katmanı', 'OrderService', 4
FROM topic WHERE slug = 'spring-boot-microservice-basics';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Domain Modeli: Order', 'Order', 5
FROM topic WHERE slug = 'spring-boot-microservice-basics';
