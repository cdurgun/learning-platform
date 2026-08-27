-- İngilizce çeviri tamamlandı (content/en/pull-requests.md) -- TR ile aynı yapı
-- (10/10 başlık, 0 embed). Yayına alınıyor. Bu, "Git Fundamentals" kategorisinin
-- SON topic'i -- kategori artık 6/6 tamam.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'pull-requests');
