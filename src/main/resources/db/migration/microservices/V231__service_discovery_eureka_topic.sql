-- Microservices kategorisine, kullanıcı isteğiyle ("Microservices de kalan konulardan
-- ilkine devam edebilirsin") kalan 9 aday konudan İLKİ ekleniyor: "service-discovery-eureka"
-- (topic.sort_order=4, inter-service-communication'dan sonra -- wave 1'in bittiği yerden
-- devam). Orijinal ChatGPT planındaki sıralamada bu konu ("Service Discovery/Eureka")
-- Inter-Service Communication'dan ÖNCE geliyordu (3. sıra), ama wave 1 bilinçli olarak
-- onu atlayıp Inter-Service Communication'ı (orijinalde 5.) erken aldı -- bkz. Faz 40
-- notu. Şimdi kalan 9 konunun orijinal göreli sırasındaki İLKİ (Service Discovery/Eureka)
-- ele alınıyor. Kalan 8 aday konu (API Gateway, Resilience4j, Configuration Management,
-- Event-Driven/Kafka, Distributed Transactions, Observability, Security, Deployment)
-- hâlâ DB'ye seed edilmedi.
--
-- TR+EN aynı fazda yazıldı (topic 2'den beri geçerli ritim, topic 1'deki temkinli
-- "önce yalnızca TR" ritmi tekrarlanmadı).
--
-- Kapsam: order-service'in inventory-service'i sabit kodlanmış bir @Value URL'iyle
-- bulmasının (bkz. inter-service-communication) neden ölçeklenmediği, Eureka Server
-- (@EnableEurekaServer, kendi bağımsız Spring Boot uygulaması, register-with-eureka/
-- fetch-registry=false tek düğümlü kurulumda), Eureka Client (spring.application.name
-- artık yalnızca log için değil, keşif anahtarı), DiscoveryClient ile düşük seviyeli
-- doğrudan sorgu, @LoadBalanced RestClient.Builder ile servisi İSİMLE çağırma (StockClient'ın
-- @Value URL'den servis ismine geçen doğrudan evrimi -- 404/bağlantı hatası ayrımı ve
-- InventoryServiceUnavailableException DEĞİŞMEDİ), heartbeat/eviction/self-preservation
-- modu (yerel geliştirmede kafa karıştırıcı davranış dahil), ve Eureka'nın CAP teoreminin
-- AP tarafını seçmesi (microservices-fundamentals'a geriye dönük çapraz referans).
--
-- Netflix'in kendi iç altyapısında Eureka 2.0'ı 2018 civarında bıraktığı ve Kubernetes'in
-- kendi servis keşfi olduğunda Eureka'nın genellikle gerekmediği bilinçli olarak
-- belirtildi -- Eureka'yı tek/güncel çözümmüş gibi sunmamak için dürüstlük notu.
--
-- SANDBOX KISITI (Microservices kategorisinin bilinen kısıtı burada da geçerli): Maven
-- Central bu sandbox'tan engelli, bu yüzden 7 örnek gerçek `mvn`/Spring Cloud ile derlenip
-- çalıştırılamadı -- kod, önceki iki topic'in (spring-boot-microservice-basics,
-- inter-service-communication) zaten dikkatle yazılmış ve kullanıcı tarafından kendi
-- ortamında doğrulanmış desenlerine (RestClient, @Value, controller/service ayrımı)
-- sadık kalınarak elle yazıldı; kullanıcının onayladığı "her topic bitince test" ritmi
-- gereği kendi ortamında doğrulaması istenecek.
--
-- `## Ek: Mini Proje` / `## Pratik Proje` YOK -- kategori kuralı gereği (bkz. Mimari),
-- pratik proje yalnızca bir wave'in SON topic'inde geliyor; bu, kalan 9 konunun henüz
-- wave'lere bölünmediği tek bir yeni topic, wave 2'nin planı/son topic'i henüz
-- belirlenmedi.
--
-- INTERMEDIATE zorlukta (önceki üç topic'le aynı).

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'service-discovery-eureka', 'INTERMEDIATE', 24, 4
FROM category
WHERE slug = 'microservices';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Servis Keşfi ve Eureka',
       'order-service''in inventory-service''i artık sabit kodlanmış bir URL yerine bir İSİMLE bulması: Eureka Server (merkezi kayıt defteri), Eureka Client (spring.application.name''in keşif anahtarına dönüşmesi), DiscoveryClient ile doğrudan sorgu, @LoadBalanced RestClient ile isimle çağrı yapma, heartbeat/eviction/self-preservation modu, ve Eureka''nın CAP teoreminin AP tarafını seçmesi.',
       'Spring Boot Eureka ile Service Discovery Nasıl Kurulur?',
       'Netflix Eureka ve Spring Cloud ile servis keşfi (service discovery) -- @EnableEurekaServer ile merkezi bir kayıt defteri kurmak, servisleri Eureka Client''a dönüştürmek, @LoadBalanced RestClient ile sabit kodlanmış URL''ler yerine servis ismiyle çağrı yapmak, ve self-preservation modunun neden var olduğu gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'service-discovery-eureka';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Service Discovery & Eureka',
       'order-service now finds inventory-service by NAME instead of a hardcoded URL: the Eureka Server (a central registry), the Eureka Client (spring.application.name becoming the discovery key), direct queries with DiscoveryClient, calling by name with a @LoadBalanced RestClient, heartbeats/eviction/self-preservation mode, and why Eureka picks the AP side of the CAP theorem.',
       'How to Set Up Service Discovery with Spring Boot and Eureka',
       'Service discovery with Netflix Eureka and Spring Cloud -- setting up a central registry with @EnableEurekaServer, turning services into Eureka Clients, calling by service name instead of a hardcoded URL with a @LoadBalanced RestClient, and why self-preservation mode exists, explained with real examples.',
       false
FROM topic
WHERE slug = 'service-discovery-eureka';
