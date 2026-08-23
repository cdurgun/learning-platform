-- İngilizce çeviri tamamlandı (content/en/generics-with-collections.md) --
-- TR ile aynı yapı (8/8 başlık, 5/5 embed). Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'generics-with-collections');
