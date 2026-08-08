-- İngilizce Enum çevirisi artık tamamlandı (content/en/enum.md) — yayına alıyoruz.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'enum');
