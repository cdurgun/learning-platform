-- İngilizce çeviri tamamlandı (content/en/rebase-and-squash.md) -- TR ile aynı
-- yapı (12/12 başlık, 1/1 embed). Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'rebase-and-squash');
