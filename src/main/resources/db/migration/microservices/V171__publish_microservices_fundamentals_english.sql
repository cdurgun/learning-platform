-- İngilizce çeviri tamamlandı (content/en/microservices-fundamentals.md) -- TR ile
-- birebir aynı başlık sayısı (17/17) ve embed sayısı (0/0). Yayına alınıyor.
--
-- Bu, "Microservices" kategorisinin ilk topic'inin (Wave 1'in birinci parçası)
-- TR+EN olarak tamamlanışı. Sıradaki: "Spring Boot ile Tek Bir Mikroservisi
-- Yapılandırmak" (spring-boot-microservice-basics) -- ilk kod örnekleri.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'microservices-fundamentals');
