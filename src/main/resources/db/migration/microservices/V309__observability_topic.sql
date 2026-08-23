-- Microservices kategorisine, kalan aday konulardan (bkz. Faz 62/89-93 notu:
-- Observability, Security, Deployment) ALTINCISI ekleniyor: "observability"
-- (topic.sort_order=10, distributed-transactions'tan hemen sonra). Orijinal ChatGPT
-- sıralaması korunuyor.
--
-- TR+EN aynı fazda yazıldı (topic 2'den beri geçerli ritim).
--
-- Kapsam: API Gateway dersinin CorrelationIdGatewayFilter'ının ve Resilience4j
-- dersinin CircuitBreakerEventListener'ının kasıtlı olarak bu derse bıraktığı iki
-- açık ipliği kapatmak -- correlation id'yi order-service'in kendi loglarına (MDC) ve
-- inventory-service'e giden çağrılara (RestClient interceptor) GERÇEKTEN yaymak,
-- structured (JSON) loglama, Micrometer/Actuator ile metrikler (OrderMetrics),
-- distributed tracing'in aynı correlation id kavramı üzerine nasıl inşa edildiği
-- (gerçek bir tracing backend'i kurmadan, dürüstlük notuyla), ve Resilience4j'nin
-- zaten Micrometer'la entegre olup CircuitBreakerEventListener'ın elle yaptığını
-- otomatik olarak sağladığı.
--
-- SANDBOX KISITI (kategori boyunca geçerli, Faz 40'ta belirlendi): Maven Central bu
-- sandbox'tan engelli, bu yüzden 5 örnek gerçek `mvn`/Micrometer ile derlenip
-- çalıştırılamadı -- kod, önceki topic'lerin (özellikle LoadBalancedRestClientConfig'in
-- @LoadBalanced RestClient.Builder'ı, CorrelationIdGatewayFilter'ın header deseni)
-- zaten dikkatle yazılmış ve kullanıcı tarafından kendi ortamında doğrulanmış
-- desenlerine sadık kalınarak elle yazıldı; kullanıcının onayladığı "her topic
-- bitince test" ritmi gereği kendi ortamında doğrulaması istenecek.
--
-- `## Ek: Mini Proje` / `## Pratik Proje` YOK -- kategori kuralı gereği (pratik proje
-- yalnızca bir wave'in SON topic'inde geliyor, kalan konular için wave/son topic henüz
-- belirlenmedi).
--
-- INTERMEDIATE zorlukta (önceki dokuz topic'le aynı).

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'observability', 'INTERMEDIATE', 26, 10
FROM category
WHERE slug = 'microservices';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Observability',
       'API Gateway ve Resilience4j derslerinin kasıtlı olarak açık bıraktığı iki ipliği kapatmak: correlation id''yi order-service''in kendi loglarına (MDC) ve inventory-service''e giden çağrılara GERÇEKTEN yaymak, structured (JSON) loglama, Micrometer/Actuator ile metrikler, distributed tracing''in aynı correlation id kavramı üzerine inşa edilmesi, ve Resilience4j''nin Micrometer''la zaten otomatik entegre olması.',
       'Spring Boot Mikroservislerinde Observability Nasıl Kurulur?',
       'Spring Boot mikroservislerinde observability -- correlation id yayma, structured loglama, Micrometer/Actuator ile metrikler, ve distributed tracing''in temelleri gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'observability';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Observability',
       'Closing two threads the API Gateway and Resilience4j lessons deliberately left open: actually propagating the correlation id into order-service''s own logs (MDC) and its outgoing calls to inventory-service, structured (JSON) logging, metrics with Micrometer/Actuator, how distributed tracing builds on the same correlation id concept, and how Resilience4j already integrates with Micrometer automatically.',
       'How to Set Up Observability in Spring Boot Microservices',
       'Observability in Spring Boot microservices -- propagating a correlation id, structured logging, metrics with Micrometer/Actuator, and the basics of distributed tracing, explained with real examples.',
       false
FROM topic
WHERE slug = 'observability';
