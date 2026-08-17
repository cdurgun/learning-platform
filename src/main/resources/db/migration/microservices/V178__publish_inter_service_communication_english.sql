-- İngilizce çeviri tamamlandı (content/en/inter-service-communication.md) -- TR ile
-- birebir aynı yapı (13/13 başlık, 8/8 embed). Yayına alınıyor.
--
-- Bu migration'la wave 1 (microservices-fundamentals, spring-boot-microservice-basics,
-- inter-service-communication -- 3 topic, üçü de TR+EN) tamamlanıyor. Kalan 9 aday konu
-- için devam kararı kullanıcıyla birlikte verilecek.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'inter-service-communication');
