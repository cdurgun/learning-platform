-- Microservices kategorisine, kalan aday konulardan (bkz. Faz 62/89 notu: Resilience4j,
-- Configuration Management, Event-Driven/Kafka, Distributed Transactions, Observability,
-- Security, Deployment) İKİNCİSİ ekleniyor: "resilience4j" (topic.sort_order=6,
-- api-gateway'den hemen sonra). Orijinal ChatGPT sıralaması korunuyor.
--
-- TR+EN aynı fazda yazıldı (topic 2'den beri geçerli ritim).
--
-- Kapsam: Servisler Arası İletişim/Servis Keşfi derslerindeki manuel try/catch tabanlı
-- hata yönetiminin (InventoryServiceUnavailableException) yeterli ama YETERSİZ kalan
-- yönü -- Resilience4j ile @CircuitBreaker (CLOSED/OPEN/HALF_OPEN durum makinesi) ve
-- @Retry annotation'larını StockClientWithDiscovery'nin doğrudan devamı olan
-- ResilientStockClient'a uygulamak, bir fallback metodunun (imza kuralı + Throwable
-- parametresi) devre açıldığında ne yaptığı, Spring proxy mekanizmasının (bkz.
-- @Transactional ile paralellik) self-invocation'da neden çalışmadığı, ve rate
-- limiter/bulkhead'in circuit breaker'dan FARKLI bir riske (aşırı yük, sürekli
-- başarısızlık değil) karşı koruduğu.
--
-- SANDBOX KISITI (kategori boyunca geçerli, Faz 40'ta belirlendi): Maven Central bu
-- sandbox'tan engelli, bu yüzden 5 örnek gerçek `mvn`/Resilience4j ile derlenip
-- çalıştırılamadı -- kod, önceki topic'lerin (özellikle service-discovery-eureka'nın
-- StockClientWithDiscovery deseni, doğrudan büyütülüyor) zaten dikkatle yazılmış ve
-- kullanıcı tarafından kendi ortamında doğrulanmış desenlerine sadık kalınarak elle
-- yazıldı; kullanıcının onayladığı "her topic bitince test" ritmi gereği kendi
-- ortamında doğrulaması istenecek.
--
-- `## Ek: Mini Proje` / `## Pratik Proje` YOK -- kategori kuralı gereği (pratik proje
-- yalnızca bir wave'in SON topic'inde geliyor, kalan konular için wave/son topic henüz
-- belirlenmedi).
--
-- INTERMEDIATE zorlukta (önceki beş topic'le aynı).

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'resilience4j', 'INTERMEDIATE', 24, 6
FROM category
WHERE slug = 'microservices';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Resilience4j',
       'order-service''in inventory-service çağrılarını manuel try/catch hata yönetiminin ötesine taşıması: Resilience4j ile @CircuitBreaker (CLOSED/OPEN/HALF_OPEN durum makinesi) ve @Retry annotation''larını ResilientStockClient''a uygulamak, fallback metotlarının devre açıldığında ne yaptığı, Spring proxy mekanizmasının self-invocation''da neden çalışmadığı, ve rate limiter/bulkhead''in circuit breaker''dan farklı bir riske karşı koruması.',
       'Spring Boot''ta Resilience4j ile Circuit Breaker ve Retry Nasıl Kullanılır?',
       'Resilience4j ile Spring Boot mikroservislerinde circuit breaker, retry, rate limiter ve bulkhead kullanmak -- @CircuitBreaker/@Retry annotation''ları, fallback metotları, durum geçişlerini izlemek, ve Spring proxy mekanizmasının sınırları gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'resilience4j';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Resilience4j',
       'Taking order-service''s inventory-service calls beyond manual try/catch error handling: applying Resilience4j''s @CircuitBreaker (a CLOSED/OPEN/HALF_OPEN state machine) and @Retry annotations to ResilientStockClient, what fallback methods do when the circuit opens, why Spring''s proxy mechanism doesn''t work through self-invocation, and how a rate limiter/bulkhead protects against a different risk than a circuit breaker.',
       'How to Use Circuit Breaker and Retry with Resilience4j in Spring Boot',
       'Using Resilience4j for circuit breakers, retry, rate limiting, and bulkheads in Spring Boot microservices -- @CircuitBreaker/@Retry annotations, fallback methods, observing state transitions, and the limits of Spring''s proxy mechanism, explained with real examples.',
       false
FROM topic
WHERE slug = 'resilience4j';
