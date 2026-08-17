-- İngilizce çeviri tamamlandı (content/en/optional.md) -- TR ile birebir aynı yapı
-- (13/13 başlık, 6/6 embed). Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'optional');
