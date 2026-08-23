-- İngilizce çeviri tamamlandı (content/en/wildcards.md) -- TR ile aynı yapı
-- (10/10 başlık, 6/6 embed). Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'wildcards');
