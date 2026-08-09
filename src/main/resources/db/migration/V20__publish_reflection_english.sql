-- Reflection konusunun İngilizce çevirisi tamamlandı (content/en/reflection.md).
-- Enum'daki V6 ve Record'daki V14'e paralel şekilde EN çeviriyi yayına alıyoruz.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'reflection');
