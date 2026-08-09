-- İngilizce Record çevirisi artık tamamlandı (content/en/records.md) — yayına alıyoruz.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'records');
