-- EN çevirisi (content/en/component-scanning.md) tamamlandı -- Dependency Injection'daki
-- V63 ve Spring IoC Container'daki V69'a paralel şekilde İngilizce çeviriyi yayına alıyoruz.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'component-scanning');
