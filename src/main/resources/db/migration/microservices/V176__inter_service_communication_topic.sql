-- Wave 1'in üçüncü ve son topic'i: "inter-service-communication" (topic.sort_order=3,
-- spring-boot-microservice-basics'ten sonra). TR+EN aynı fazda yazıldı (kullanıcının
-- topic 2'de onayladığı ritim burada da devam ediyor).
--
-- Bu konu, order-service'in yanına ikinci bir mikroservis (inventory-service) ekleyip
-- ikisini sade, senkron bir REST çağrısıyla (Spring 6.1'in RestClient'ı) konuşturuyor --
-- kategori boyunca gördüğümüz "Database per Service" ve "bounded context" kavramlarının
-- ilk kez servisler arası bir çağrıyla somutlaştığı yer. `## Ek: Mini Proje` yok
-- (kategori kuralı gereği); bunun yerine dersin sonunda, ayrı ve izole bir repoda
-- (`microservices-course-projects`) gerçek, çalıştırılabilir bir Pratik Proje'ye link
-- veren bir `## Pratik Proje` bölümü var -- react-course-projects deseninin birebir
-- aynısı, tag YOK (Testing kategorisinden sonra terk edilen git tag kullanımıyla
-- tutarlı), doğrudan `.../tree/main/projects/inter-service-communication` linki.
--
-- Bu, wave 1'in (3 topic) SON konusu -- ilk dalga bu migration'la tamamlanıyor. Kalan 9
-- aday konu (Eureka, Gateway, Resilience4j, Config Mgmt, Kafka, Distributed Tx,
-- Observability, Security, Deployment) hâlâ DB'ye seed edilmedi; devam kararı
-- kullanıcıyla birlikte verilecek (bkz. CLAUDE.md "Sıradaki Adım").
--
-- INTERMEDIATE zorlukta (önceki iki topic'le aynı).

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'inter-service-communication', 'INTERMEDIATE', 22, 3
FROM category
WHERE slug = 'microservices';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Servisler Arası İletişim',
       'order-service''in yanına ikinci bir mikroservis (inventory-service) eklemek ve ikisini Spring''in RestClient''ıyla senkron bir REST çağrısıyla konuşturmak: stok kontrolü, hata yönetimi (servis ayakta değilse ne olur), ve servisler arası DTO ayrımı. Kategorinin gerçek, çalıştırılabilir Pratik Proje''sine buradan ulaşılıyor.',
       'Spring Boot Mikroservisleri Arası REST İletişimi Nasıl Kurulur?',
       'İki bağımsız Spring Boot mikroservisinin (order-service, inventory-service) Spring 6.1''in RestClient''ıyla nasıl senkron REST üzerinden konuştuğu -- @Value ile yapılandırılan base URL, 404 ile bağlantı hatasının ayrıştırılması, InventoryServiceUnavailableException ile anlamlı hata yönetimi, ve servisler arası DTO (StockCheckResponse) ayrımı -- gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'inter-service-communication';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Inter-Service Communication',
       'Adding a second microservice (inventory-service) next to order-service and connecting the two with a synchronous REST call via Spring''s RestClient: stock checking, error handling (what happens when a service is down), and separating DTOs between services. Links to the category''s real, runnable Practical Project.',
       'How to Set Up REST Communication Between Spring Boot Microservices',
       'How two independent Spring Boot microservices (order-service, inventory-service) talk over synchronous REST using Spring 6.1''s RestClient -- a base URL configured via @Value, telling a 404 apart from a connection failure, meaningful error handling with InventoryServiceUnavailableException, and separating DTOs (StockCheckResponse) between services -- explained with real examples.',
       false
FROM topic
WHERE slug = 'inter-service-communication';
