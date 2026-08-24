-- İngilizce çeviri tamamlandı
-- (content/en/relationships-fetching-and-n-plus-1.md) -- TR ile aynı yapı
-- (14/14 başlık, 6/6 embed). Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1');
