-- Microservices kategorisine, kalan aday konulardan (bkz. Faz 62/89-94 notu:
-- Security, Deployment) YEDİNCİSİ ekleniyor: "security" (topic.sort_order=11,
-- observability'den hemen sonra). Orijinal ChatGPT sıralaması korunuyor.
--
-- TR+EN aynı fazda yazıldı (topic 2'den beri geçerli ritim).
--
-- Kapsam: bu kategorideki her dersin şimdiye kadar order-service/inventory-service'in
-- kendilerini çağıran her şeye koşulsuz güvendiğini varsaymasının boşluğunu kapatmak --
-- projeye Spring Security'yi İLK KEZ tanıtmak (proje boyunca hiçbir yerde kullanılmadı,
-- quiz özelliğinin AI ingestion endpoint'i bilinçli olarak elle yazılmış bir X-Api-Key
-- kontrolü kullandı), authentication vs authorization ayrımı, JWT'nin kendi kendine
-- yeterli/bağımsız doğrulanabilir doğası, api-gateway'de (WebFlux/reactive stil) ve
-- order-service'te (Servlet/MVC stil) AYRI AYRI JWT doğrulaması (zero trust -- gateway'in
-- kontrolüne güvenmemek), role-bazlı authorization (.hasRole), ve kimliğin
-- Observability'nin correlation id'sine paralel şekilde servisler arası yayılması.
--
-- SANDBOX KISITI (kategori boyunca geçerli, Faz 40'ta belirlendi): Maven Central bu
-- sandbox'tan engelli, bu yüzden 5 örnek gerçek `mvn`/Spring Security ile derlenip
-- çalıştırılamadı -- kod, önceki topic'lerin (özellikle ResilientStockClient'ın
-- @LoadBalanced RestClient.Builder deseni, Observability'nin RestClientCorrelationIdInterceptor'ı)
-- zaten dikkatle yazılmış ve kullanıcı tarafından kendi ortamında doğrulanmış
-- desenlerine sadık kalınarak elle yazıldı; kullanıcının onayladığı "her topic bitince
-- test" ritmi gereği kendi ortamında doğrulaması istenecek (bu topic ayrıca gerçek bir
-- identity provider'ın -- issuer-uri'nin işaret ettiği -- var olduğunu varsayıyor,
-- bunu inşa etmek kapsam dışı, tıpkı event-driven-kafka'nın bir Kafka broker'ının zaten
-- çalıştığını varsayması gibi).
--
-- `## Ek: Mini Proje` / `## Pratik Proje` YOK -- kategori kuralı gereği (pratik proje
-- yalnızca bir wave'in SON topic'inde geliyor, kalan konular için wave/son topic henüz
-- belirlenmedi).
--
-- INTERMEDIATE zorlukta (önceki on topic'le aynı).

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'security', 'INTERMEDIATE', 26, 11
FROM category
WHERE slug = 'microservices';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Security',
       'Bu kategorideki her dersin şimdiye kadar varsaydığı koşulsuz güveni kapatmak: Spring Security''yi projeye ilk kez tanıtmak, authentication vs authorization ayrımı, JWT''nin kendi kendine yeterli doğası, api-gateway ve order-service''te AYRI AYRI JWT doğrulaması (zero trust), role-bazlı authorization, ve kimliğin correlation id''ye paralel şekilde servisler arası yayılması.',
       'Spring Security ve JWT ile Mikroservis Güvenliği Nasıl Kurulur?',
       'Spring Security ve JWT ile mikroservis güvenliği -- authentication vs authorization, gateway ve servis seviyesinde zero trust doğrulama, role-bazlı authorization, ve kimlik yayma gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'security';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Security',
       'Closing the unconditional trust every lesson in this category has assumed so far: introducing Spring Security into the course for the first time, the authentication vs. authorization distinction, JWT''s self-contained nature, validating JWTs INDEPENDENTLY at both api-gateway and order-service (zero trust), role-based authorization, and propagating identity across services the same way the correlation id already is.',
       'How to Set Up Microservices Security with Spring Security and JWT',
       'Microservices security with Spring Security and JWT -- authentication vs. authorization, zero-trust validation at both the gateway and service level, role-based authorization, and propagating identity, explained with real examples.',
       false
FROM topic
WHERE slug = 'security';
