-- Abstract Class konusunun İngilizce çevirisi tamamlandı (content/en/abstract-class.md).
-- Interface'teki V26'ya paralel şekilde EN çeviriyi yayına alıyoruz.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'abstract-class');
