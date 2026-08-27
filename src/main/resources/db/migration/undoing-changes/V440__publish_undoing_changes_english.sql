-- İngilizce çeviri tamamlandı (content/en/undoing-changes.md) -- TR ile aynı
-- yapı (10/10 başlık, 1/1 embed). Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'undoing-changes');
