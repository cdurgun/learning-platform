-- Inheritance konusunun İngilizce çevirisi tamamlandı (content/en/inheritance.md).
-- Abstract Class'taki V32'ye paralel şekilde EN çeviriyi yayına alıyoruz.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'inheritance');
