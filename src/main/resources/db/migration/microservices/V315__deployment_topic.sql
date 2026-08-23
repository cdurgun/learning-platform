-- Microservices kategorisine, orijinal ChatGPT planındaki 12 topic'in SONUNCUSU
-- ekleniyor: "deployment" (topic.sort_order=12, security'den hemen sonra). Bu topic
-- ile Faz 40'ta wave'lere bölünen tüm curriculum (wave 1'in 3 topic'i + Faz 62'de
-- listelenen 9 aday konu) TAMAMLANIYOR -- bkz. CLAUDE.md/docs/phase-log.md.
--
-- TR+EN aynı fazda yazıldı (topic 2'den beri geçerli ritim).
--
-- Kapsam: bu kategorinin şimdiye kadar her dersinin localhost varsayımının
-- (eureka-server, config-server, api-gateway, order-service, inventory-service,
-- Kafka) gerçek dünyada nasıl deploy edildiği -- multi-stage Dockerfile ile küçük
-- image'lar, tüm sistemi tek bir docker-compose dosyasında orkestre etmek (bu
-- kategorinin dokuz mikroservis dersinin ilk kez birlikte tarif edildiği yer),
-- container'larda ortam değişkeni ile yapılandırma (Configuration Management'ın
-- secrets deseninin servis adreslerine uygulanması), depends_on'un health check
-- olmadan neden yetmediği, ve Kubernetes'e kısa/dürüst bir bakış (bu dersin
-- kapsamının GERÇEKTEN dışında olduğu açıkça belirtilerek).
--
-- SANDBOX KISITI (kategori boyunca geçerli, Faz 40'ta belirlendi): Maven Central bu
-- sandbox'tan engelli, bu yüzden 4 örnek gerçek Docker/Docker Compose ile derlenip
-- çalıştırılamadı -- kod, önceki topic'lerin (özellikle her servisin kendi
-- application.yml deseni, Configuration Management'ın ortam değişkeni override
-- deseni) zaten dikkatle yazılmış ve kullanıcı tarafından kendi ortamında
-- doğrulanmış desenlerine sadık kalınarak elle yazıldı; kullanıcının onayladığı
-- "her topic bitince test" ritmi gereği kendi ortamında doğrulaması istenecek.
--
-- `## Ek: Mini Proje` / `## Pratik Proje` YOK bu migration'da -- kategori kuralı
-- ("pratik proje yalnızca bir wave'in SON topic'inde geliyor") burada GERÇEKTEN
-- devreye giriyor çünkü bu, curriculum'un son topic'i, ama pratik proje ayrı bir
-- karar/adım olarak kullanıcıya bırakıldı (bkz. Faz 96 notu, docs/phase-log.md).
--
-- INTERMEDIATE zorlukta (önceki on bir topic'le aynı).

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'deployment', 'INTERMEDIATE', 26, 12
FROM category
WHERE slug = 'microservices';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Deployment',
       'Bu kategorinin şimdiye kadar her dersinin localhost varsayımının gerçek dünyada nasıl deploy edildiği: multi-stage Dockerfile ile küçük image''lar, tüm sistemi (eureka-server, config-server, api-gateway, order-service, inventory-service, Kafka) tek bir docker-compose dosyasında orkestre etmek, container''larda ortam değişkeni ile yapılandırma, depends_on''un health check olmadan neden yetmediği, ve Kubernetes''e kısa/dürüst bir bakış.',
       'Spring Boot Mikroservislerini Docker ve Docker Compose ile Deploy Etmek',
       'Spring Boot mikroservislerini Docker ile deploy etmek -- multi-stage Dockerfile''lar, docker-compose ile tüm sistemi orkestre etmek, container yapılandırması, ve Kubernetes''e kısa bir bakış gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'deployment';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Deployment',
       'How this category''s localhost assumption, present in every lesson so far, actually gets deployed in the real world: small images with multi-stage Dockerfiles, orchestrating the whole system (eureka-server, config-server, api-gateway, order-service, inventory-service, Kafka) in one docker-compose file, environment-variable configuration in containers, why depends_on isn''t enough without a health check, and a brief, honest look at Kubernetes.',
       'How to Deploy Spring Boot Microservices with Docker and Docker Compose',
       'Deploying Spring Boot microservices with Docker -- multi-stage Dockerfiles, orchestrating the whole system with docker-compose, container configuration, and a brief look at Kubernetes, explained with real examples.',
       false
FROM topic
WHERE slug = 'deployment';
