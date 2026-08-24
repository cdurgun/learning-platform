-- İngilizce çeviri tamamlandı
-- (content/en/persistence-context-and-locking.md) -- TR ile aynı yapı
-- (14/14 başlık, 6/6 embed). Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'persistence-context-and-locking');
