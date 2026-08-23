-- İngilizce çeviri tamamlandı (content/en/throw-and-throws.md) -- TR ile
-- aynı yapı (10/10 başlık, 4/4 embed). Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'throw-and-throws');
