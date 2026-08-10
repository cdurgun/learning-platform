-- Date & Time konusunun İngilizce çevirisi tamamlandı (content/en/date-time.md).
-- Threads'teki V50'ye paralel şekilde EN çeviriyi yayına alıyoruz.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'date-time');
