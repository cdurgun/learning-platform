-- Polymorphism konusunun İngilizce çevirisi tamamlandı (content/en/polymorphism.md).
-- Inheritance'taki V38'e paralel şekilde EN çeviriyi yayına alıyoruz.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'polymorphism');
