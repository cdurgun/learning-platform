-- İngilizce çeviri tamamlandı (content/en/try-catch-finally.md) -- TR ile
-- birebir aynı yapı (11/11 başlık, 5/5 embed). Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'try-catch-finally');
