-- İngilizce çeviri tamamlandı (content/en/branches-and-merging.md) -- TR ile
-- aynı yapı (13/13 başlık, 1/1 embed). Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'branches-and-merging');
