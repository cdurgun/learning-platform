-- İngilizce çeviri tamamlandı (content/en/working-with-commits.md) -- TR ile
-- aynı yapı (7/7 başlık, 1/1 embed). Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'working-with-commits');
