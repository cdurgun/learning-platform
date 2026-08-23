-- Microservices kategorisine, kalan aday konulardan (bkz. Faz 62/87/89 notu:
-- Configuration Management, Event-Driven/Kafka, Distributed Transactions,
-- Observability, Security, Deployment) ÜÇÜNCÜSÜ ekleniyor: "configuration-management"
-- (topic.sort_order=7, resilience4j'den hemen sonra). Orijinal ChatGPT sıralaması
-- korunuyor.
--
-- TR+EN aynı fazda yazıldı (topic 2'den beri geçerli ritim).
--
-- Kapsam: her servisin şimdiye kadar kendi application.yml'inde tuttuğu yapılandırmanın
-- (bkz. spring-boot-microservice-basics) neden çok sayıda serviste ölçeklenmediği --
-- Spring Cloud Config Server (@EnableConfigServer, native/dosya-sistemi backend'i),
-- Config Repository'nin servis başına bir YAML dosyasıyla neyi merkezileştirmeye
-- değdiğine karar vermesi (server.port/spring.application.name YEREL kalır), tek bir
-- spring.config.import özelliğiyle Config Client olmak, profillerin bu projenin kendi
-- application-dev.yml/application-prod.yml deseniyle AYNI mekanizma olması, @RefreshScope
-- ile yeniden başlatmadan yapılandırma yenileme, ve sırların (secrets) neden bir Config
-- Repository dosyasına düz metin olarak KONULMAMASI gerektiği (ORDERS_DB_PASSWORD'ün
-- hâlâ bir ortam değişkeni olarak kalması).
--
-- SANDBOX KISITI (kategori boyunca geçerli, Faz 40'ta belirlendi): Maven Central bu
-- sandbox'tan engelli, bu yüzden 5 örnek gerçek `mvn`/Spring Cloud Config ile derlenip
-- çalıştırılamadı -- kod, önceki topic'lerin (eureka-server/api-gateway'in kendi başına
-- ayrı Spring Boot uygulaması deseni) zaten dikkatle yazılmış ve kullanıcı tarafından
-- kendi ortamında doğrulanmış desenlerine sadık kalınarak elle yazıldı; kullanıcının
-- onayladığı "her topic bitince test" ritmi gereği kendi ortamında doğrulaması istenecek.
--
-- `## Ek: Mini Proje` / `## Pratik Proje` YOK -- kategori kuralı gereği (pratik proje
-- yalnızca bir wave'in SON topic'inde geliyor, kalan konular için wave/son topic henüz
-- belirlenmedi).
--
-- INTERMEDIATE zorlukta (önceki altı topic'le aynı).

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'configuration-management', 'INTERMEDIATE', 24, 7
FROM category
WHERE slug = 'microservices';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Configuration Management',
       'Her servisin şimdiye kadar kendi application.yml''inde tuttuğu yapılandırmayı Spring Cloud Config ile merkezileştirmek: @EnableConfigServer ile ayrı bir config-server uygulaması kurmak, bir Config Repository''nin neyi merkezileştirmeye değdiğine karar vermesi, spring.config.import ile Config Client olmak, profillerle ortam bazlı override, @RefreshScope ile yeniden başlatmadan yapılandırma yenileme, ve sırların neden düz metin olarak saklanmaması gerektiği.',
       'Spring Cloud Config ile Merkezi Yapılandırma Yönetimi Nasıl Kurulur?',
       'Spring Cloud Config Server ile mikroservislerde merkezi yapılandırma yönetimi -- Config Repository, Config Client olmak için spring.config.import, profillerle ortam bazlı override, @RefreshScope ile canlı yapılandırma yenileme, ve sırların neden merkezi dosyalarda düz metin olarak durmaması gerektiği gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'configuration-management';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Configuration Management',
       'Centralizing configuration every service has kept in its own application.yml so far, using Spring Cloud Config: setting up a separate config-server application with @EnableConfigServer, a Config Repository deciding what''s genuinely worth centralizing, becoming a Config Client with spring.config.import, environment-specific overrides through profiles, refreshing configuration without a restart via @RefreshScope, and why secrets should never be stored in plain text.',
       'How to Set Up Centralized Configuration Management with Spring Cloud Config',
       'Centralized configuration management for microservices with Spring Cloud Config Server -- the Config Repository, becoming a Config Client with spring.config.import, environment-specific overrides through profiles, live configuration refresh with @RefreshScope, and why secrets should never live as plain text in centralized files, explained with real examples.',
       false
FROM topic
WHERE slug = 'configuration-management';
