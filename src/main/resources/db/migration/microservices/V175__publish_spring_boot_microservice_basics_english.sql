-- İngilizce çeviri tamamlandı (content/en/spring-boot-microservice-basics.md) -- TR ile
-- birebir aynı yapı (13/13 başlık, 5/5 embed). Yayına alınıyor.
--
-- Wave 1'in ikinci topic'i (spring-boot-microservice-basics) TR+EN tamamlandı. Sıradaki
-- ve wave'in son topic'i: "inter-service-communication" -- order-service'in yanına
-- inventory-service eklenip ikisi sade bir REST çağrısıyla konuşturulacak, kategori
-- sonu Pratik Proje de burada (microservices-course-projects reposunda) teslim
-- edilecek.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'spring-boot-microservice-basics');
