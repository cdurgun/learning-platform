-- Microservices kategorisine, kalan 8 aday konudan (bkz. Faz 62 notu: API Gateway,
-- Resilience4j, Configuration Management, Event-Driven/Kafka, Distributed Transactions,
-- Observability, Security, Deployment) İLKİ ekleniyor: "api-gateway" (topic.sort_order=5,
-- service-discovery-eureka'dan hemen sonra). Orijinal ChatGPT sıralaması korunuyor --
-- kullanıcı kararı gereği (bkz. CLAUDE.md "Faz Geçmişi") yeni bir müfredat İCAT EDİLMEDİ,
-- yalnızca zaten planlanmış konu sırasıyla devam edildi.
--
-- TR+EN aynı fazda yazıldı (topic 2'den beri geçerli ritim).
--
-- Kapsam: dış istemcilerin (tarayıcı/mobil) tek tek mikroservislerin adresini bilmesi
-- gerekmemesi için tek bir giriş noktası -- Spring Cloud Gateway ile ayrı, bağımsız bir
-- api-gateway uygulaması, rota (route) = predicate + URI + filtre üçlüsü, lb:// ile
-- Eureka üzerinden keşif tabanlı yönlendirme (service-discovery-eureka'daki
-- @LoadBalanced RestClient ile AYNI fikrin gateway karşılığı), özel bir GlobalFilter
-- yazmak (kursun İLK reaktif/Spring WebFlux kodu), correlation id gibi sistem geneli
-- konuların gateway'e ait olması ama iş mantığının KESİNLİKLE serviste kalması gerektiği.
--
-- SANDBOX KISITI (kategori boyunca geçerli, Faz 40'ta belirlendi): Maven Central bu
-- sandbox'tan engelli, bu yüzden 5 örnek gerçek `mvn`/Spring Cloud Gateway ile derlenip
-- çalıştırılamadı -- kod, önceki topic'lerin (özellikle service-discovery-eureka'nın
-- lb:// / @LoadBalanced deseni) zaten dikkatle yazılmış ve kullanıcı tarafından kendi
-- ortamında doğrulanmış desenlerine sadık kalınarak elle yazıldı; kullanıcının onayladığı
-- "her topic bitince test" ritmi gereği kendi ortamında doğrulaması istenecek.
--
-- `## Ek: Mini Proje` / `## Pratik Proje` YOK -- kategori kuralı gereği (pratik proje
-- yalnızca bir wave'in SON topic'inde geliyor, kalan 8 konu için wave/son topic henüz
-- belirlenmedi).
--
-- INTERMEDIATE zorlukta (önceki dört topic'le aynı).

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'api-gateway', 'INTERMEDIATE', 24, 5
FROM category
WHERE slug = 'microservices';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'API Gateway',
       'order-service ve inventory-service''in artık dış istemciler için tek bir giriş noktası üzerinden erişilebilir olması: Spring Cloud Gateway ile ayrı bir api-gateway uygulaması kurmak, rota (route) predicate/URI/filtre üçlüsü, lb:// ile Eureka üzerinden keşif tabanlı yönlendirme, özel bir GlobalFilter yazmak (kursun ilk reaktif kodu), ve correlation id gibi sistem geneli konuların neden gateway''de kalıp iş mantığının serviste kalması gerektiği.',
       'Spring Cloud Gateway ile API Gateway Nasıl Kurulur?',
       'Spring Cloud Gateway ile mikroservisler için tek bir giriş noktası (API Gateway) kurmak -- route predicate/URI/filtre yapılandırması, lb:// ile Eureka tabanlı keşif, özel GlobalFilter yazma, ve gateway''in ne zaman iş mantığından uzak durması gerektiği gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'api-gateway';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'API Gateway',
       'order-service and inventory-service becoming reachable to external clients through a single entry point: setting up a separate api-gateway application with Spring Cloud Gateway, the route predicate/URI/filter trio, discovery-based routing through Eureka with lb://, writing a custom GlobalFilter (the course''s first reactive code), and why system-wide concerns like correlation ids belong at the gateway while business logic stays in the service.',
       'How to Set Up an API Gateway with Spring Cloud Gateway',
       'Setting up a single entry point (API Gateway) for microservices with Spring Cloud Gateway -- route predicate/URI/filter configuration, Eureka-based discovery routing with lb://, writing a custom GlobalFilter, and why a gateway should stay out of business logic, explained with real examples.',
       false
FROM topic
WHERE slug = 'api-gateway';
