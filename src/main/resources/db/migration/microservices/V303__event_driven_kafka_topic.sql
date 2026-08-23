-- Microservices kategorisine, kalan aday konulardan (bkz. Faz 62/87/89/90 notu:
-- Event-Driven/Kafka, Distributed Transactions, Observability, Security, Deployment)
-- DÖRDÜNCÜSÜ ekleniyor: "event-driven-kafka" (topic.sort_order=8, configuration-
-- management'tan hemen sonra). Orijinal ChatGPT sıralaması korunuyor.
--
-- TR+EN aynı fazda yazıldı (topic 2'den beri geçerli ritim).
--
-- Kapsam: bu kategorideki HER servisler arası çağrının şimdiye kadar senkron olmasının
-- (Servisler Arası İletişim, Servis Keşfi ve Eureka, Resilience4j) yarattığı zaman-
-- bağlantısını ve doğrudan-bilgi-bağlantısını Kafka ile kaldırmak -- topic/partition
-- kavramları, order-service'in OrderPlacedEvent yayınlaması (KafkaTemplate),
-- inventory-service'in @KafkaListener ile tepki vermesi, senkron vs asenkron arasında
-- NE ZAMAN hangisinin seçileceği (biri diğerinin yerini almıyor, bir arada var
-- oluyorlar), Kafka'nın en az bir kez teslimat garantisi ve bunun her tüketicinin
-- idempotent olması gerektirdiği (processedOrderIds koruması), ve JSON serialization
-- tercihi.
--
-- SANDBOX KISITI (kategori boyunca geçerli, Faz 40'ta belirlendi): Maven Central bu
-- sandbox'tan engelli, bu yüzden 5 örnek gerçek `mvn`/spring-kafka ile derlenip
-- çalıştırılamadı -- kod, önceki topic'lerin (özellikle StockCheckResponse'un "kendi
-- sözleşmen" deseni, OrderService'in in-memory Map deseni) zaten dikkatle yazılmış ve
-- kullanıcı tarafından kendi ortamında doğrulanmış desenlerine sadık kalınarak elle
-- yazıldı; kullanıcının onayladığı "her topic bitince test" ritmi gereği kendi
-- ortamında doğrulaması istenecek (bu topic ayrıca gerçek bir Kafka broker'ının
-- çalışıyor olmasını GEREKTİRİYOR, önceki topic'lerdeki gibi yalnızca bir Spring Boot
-- uygulaması DEĞİL).
--
-- `## Ek: Mini Proje` / `## Pratik Proje` YOK -- kategori kuralı gereği (pratik proje
-- yalnızca bir wave'in SON topic'inde geliyor, kalan konular için wave/son topic henüz
-- belirlenmedi).
--
-- INTERMEDIATE zorlukta (önceki yedi topic'le aynı).

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'event-driven-kafka', 'INTERMEDIATE', 26, 8
FROM category
WHERE slug = 'microservices';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Event-Driven Architecture ve Kafka',
       'Bu kategorideki her servisler arası çağrının şimdiye kadar senkron olmasının yarattığı zaman ve doğrudan-bilgi bağlantısını Kafka ile kaldırmak: topic/partition kavramları, order-service''in KafkaTemplate ile OrderPlacedEvent yayınlaması, inventory-service''in @KafkaListener ile tepki vermesi, senkron vs asenkron arasında ne zaman hangisinin seçileceği, en az bir kez teslimat garantisinin her tüketiciyi idempotent yapmayı gerektirmesi, ve JSON serialization tercihi.',
       'Spring Boot ve Kafka ile Event-Driven Mikroservisler Nasıl Kurulur?',
       'Spring for Apache Kafka ile mikroservislerde event-driven mimari kurmak -- KafkaTemplate ile olay yayınlamak, @KafkaListener ile tüketmek, senkron ile asenkron çağrı arasında seçim, en az bir kez teslimat ve idempotency, gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'event-driven-kafka';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Event-Driven Architecture & Kafka',
       'Removing the time-coupling and direct-knowledge-coupling created by every inter-service call in this category being synchronous so far, using Kafka: topic/partition concepts, order-service publishing OrderPlacedEvent with KafkaTemplate, inventory-service reacting with @KafkaListener, when to choose synchronous vs. asynchronous, why at-least-once delivery requires every consumer to be idempotent, and the JSON serialization choice.',
       'How to Build Event-Driven Microservices with Spring Boot and Kafka',
       'Building event-driven microservices with Spring for Apache Kafka -- publishing events with KafkaTemplate, consuming with @KafkaListener, choosing between synchronous and asynchronous calls, at-least-once delivery and idempotency, explained with real examples.',
       false
FROM topic
WHERE slug = 'event-driven-kafka';
