-- Threads konusunun İngilizce çevirisi tamamlandı (content/en/threads.md).
-- Polymorphism'deki V44'e paralel şekilde EN çeviriyi yayına alıyoruz.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'threads');
