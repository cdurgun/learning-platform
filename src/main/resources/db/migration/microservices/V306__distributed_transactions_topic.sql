-- Microservices kategorisine, kalan aday konulardan (bkz. Faz 62/89-92 notu:
-- Distributed Transactions, Observability, Security, Deployment) BEŞİNCİSİ ekleniyor:
-- "distributed-transactions" (topic.sort_order=9, event-driven-kafka'dan hemen sonra).
-- Orijinal ChatGPT sıralaması korunuyor.
--
-- TR+EN aynı fazda yazıldı (topic 2'den beri geçerli ritim).
--
-- Kapsam: Event-Driven Architecture ve Kafka dersinin bilerek açık bıraktığı boşluk --
-- inventory-service stok rezerve EDEMEZSE order-service'in zaten commit ettiği siparişe
-- ne olur -- Two-Phase Commit'in neden mikroservislerde nadir olduğu (kilitleme +
-- erişilebilirlik maliyeti, Eureka'nın AP tercihine paralel), Saga deseni (yerel işlemler
-- dizisi + kompansasyon eylemleri), choreography (bu derste kullanılan, orchestration'a
-- kısa referansla), StockReservationFailedEvent ile order-service/inventory-service
-- arasında iki yönlü bir saga akışı kurmak, kompansasyonun bir rollback OLMADIĞI (ayrı,
-- açık bir yerel işlem), ve Outbox deseninin OrderEventPublisher'ın kendi başına
-- bıraktığı "olay hiç yayınlanmayabilir" boşluğunu kapatması.
--
-- SANDBOX KISITI (kategori boyunca geçerli, Faz 40'ta belirlendi): Maven Central bu
-- sandbox'tan engelli, bu yüzden 5 örnek gerçek `mvn`/spring-kafka ile derlenip
-- çalıştırılamadı -- kod, event-driven-kafka'nın zaten dikkatle yazılmış ve kullanıcı
-- tarafından kendi ortamında doğrulanacak desenlerine (OrderPlacedEvent, KafkaTemplate,
-- @KafkaListener, idempotency koruması) doğrudan bina edilerek elle yazıldı; bu topic de
-- event-driven-kafka gibi gerçek bir Kafka broker'ının çalışıyor olmasını GEREKTİRİYOR.
--
-- `## Ek: Mini Proje` / `## Pratik Proje` YOK -- kategori kuralı gereği (pratik proje
-- yalnızca bir wave'in SON topic'inde geliyor, kalan konular için wave/son topic henüz
-- belirlenmedi).
--
-- INTERMEDIATE zorlukta (önceki sekiz topic'le aynı).

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'distributed-transactions', 'INTERMEDIATE', 26, 9
FROM category
WHERE slug = 'microservices';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Distributed Transactions',
       'Event-Driven Architecture ve Kafka dersinin açık bıraktığı boşluğu kapatmak -- inventory-service stok rezerve edemezse order-service''in zaten commit ettiği siparişe ne olur: Two-Phase Commit''in mikroservislerde neden nadir olduğu, Saga deseni (yerel işlemler + kompansasyon eylemleri), choreography ile StockReservationFailedEvent üzerinden iki yönlü bir saga akışı kurmak, kompansasyonun bir rollback olmadığı, ve Outbox deseninin bir olayın hiç yayınlanmama riskini kapatması.',
       'Mikroservislerde Distributed Transaction ve Saga Deseni Nasıl Yönetilir?',
       'Mikroservislerde distributed transaction''ları Saga deseniyle yönetmek -- Two-Phase Commit''in neden kaçınıldığı, choreography ile kompansasyon eylemleri, ve Outbox deseniyle olay kaybını önlemek gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'distributed-transactions';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Distributed Transactions',
       'Closing the gap the Event-Driven Architecture & Kafka lesson deliberately left open -- what happens to an order order-service already committed if inventory-service can''t reserve stock: why Two-Phase Commit is rare in microservices, the Saga pattern (local transactions plus compensating actions), building a two-way saga flow with choreography and StockReservationFailedEvent, why compensation isn''t a rollback, and how the Outbox pattern closes the risk of an event never being published.',
       'How to Handle Distributed Transactions and the Saga Pattern in Microservices',
       'Handling distributed transactions in microservices with the Saga pattern -- why Two-Phase Commit is usually avoided, compensating actions with choreography, and preventing lost events with the Outbox pattern, explained with real examples.',
       false
FROM topic
WHERE slug = 'distributed-transactions';
