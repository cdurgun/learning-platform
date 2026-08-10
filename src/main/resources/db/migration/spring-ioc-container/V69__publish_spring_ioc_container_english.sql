-- EN çevirisi (content/en/spring-ioc-container.md) tamamlandı -- Dependency
-- Injection'daki V63'e paralel şekilde İngilizce çeviriyi yayına alıyoruz.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'spring-ioc-container');
