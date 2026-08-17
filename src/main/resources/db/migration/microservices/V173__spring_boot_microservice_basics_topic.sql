-- Wave 1'in ikinci topic'i: "spring-boot-microservice-basics" (topic.sort_order=2,
-- microservices-fundamentals'tan sonra). Kullanıcı onayıyla hem TR hem EN aynı fazda
-- yazıldı (topic 1'deki temkinli "önce yalnızca TR" ritmi burada tekrarlanmadı --
-- kullanıcı "geçebilirsin, türkçe ve ingilizcesini tamamlayabilirsin" dedi).
--
-- Bu, kategorideki İLK KOD içeren topic -- microservices-fundamentals bilinçli olarak
-- kod içermiyordu (bkz. o topic'in migration'ı). examples/spring-boot-microservice-basics/
-- altında 5 dosya var (4 .java + 1 .yml -- embed sistemi Faz 27'den beri uzantıdan
-- bağımsız, .yml burada .java/.jsx'ten sonra üçüncü farklı uzantı): OrderServiceApplication
-- (giriş noktası), OrderServiceConfig.yml (application.yml örneği -- server.port,
-- spring.application.name, datasource, actuator health), OrderController + OrderService +
-- Order (controller/service/domain model üçlüsü, dependency-injection'daki
-- NotificationDispatcher/NotificationDispatcherDemo çiftiyle aynı desende -- birbirine
-- bağımlı, birlikte okunacak/derlenecek bir grup, CLAUDE.md'nin "her .java dosyası
-- bağımsız bir derleme birimi" kuralının istisnası olan "aynı topic içinde birbirine
-- bağımlı sınıflar" durumu).
--
-- Kod, kursun zaten doğrulanmış Spring MVC/Spring Core örneklerine (ResponseEntity/
-- HttpStatus kullanımı request-response-handling ve rest-api-design'daki gerçek
-- kullanımla birebir aynı desende yazıldı) dikkatle dayanarak yazıldı -- bu sandbox'ta
-- Maven Central engelli olduğu için gerçek bir mvn/spring-boot:run doğrulaması
-- yapılamadı (bkz. "Bilinen Kısıtlar"), kullanıcıdan kendi ortamında doğrulaması
-- istenecek (Faz 39/Production ritmi, kullanıcının onayladığı "her topic bitince test"
-- kararıyla tutarlı). highlight.js'in "yml"i ayrı bir dil olarak tanıdığı npm ile ayrıca
-- doğrulandı (Faz 27'deki jsx doğrulamasıyla aynı yöntem).
--
-- INTERMEDIATE zorlukta (microservices-fundamentals'tan devam).

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'spring-boot-microservice-basics', 'INTERMEDIATE', 18, 2
FROM category
WHERE slug = 'microservices';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Mikroservis Yapılandırma',
       'Tek bir Spring Boot mikroservisini (order-service) baştan sona yapılandırmak: kendi giriş noktası, kendi application.yml''i (port, uygulama adı, veritabanı), REST controller ile API sözleşmesi, service katmanı, domain modeli ve health check.',
       'Spring Boot ile Mikroservis Nasıl Yapılandırılır? | Örneklerle Anlatım',
       'Tek bir Spring Boot mikroservisinin (order-service) nasıl yapılandırıldığı -- @SpringBootApplication ile giriş noktası, kendi application.yml''i (server.port, spring.application.name, spring.datasource), REST controller ile dış API sözleşmesi, iş mantığını service katmanına ayırmak, servise özgü domain modeli, ve spring-boot-starter-actuator ile health check endpoint''i -- gerçek Spring Boot örnekleriyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'spring-boot-microservice-basics';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Microservice Configuration',
       'Configuring a single Spring Boot microservice (order-service) from the ground up: its own entry point, its own application.yml (port, application name, database), a REST controller as the API contract, the service layer, the domain model, and a health check.',
       'How to Configure a Microservice with Spring Boot | Explained with Examples',
       'How a single Spring Boot microservice (order-service) is configured -- an entry point with @SpringBootApplication, its own application.yml (server.port, spring.application.name, spring.datasource), a REST controller as the external API contract, separating business logic into a service layer, a domain model scoped to the service, and a health check endpoint via spring-boot-starter-actuator -- explained with real Spring Boot examples.',
       false
FROM topic
WHERE slug = 'spring-boot-microservice-basics';
