-- İngilizce çeviri tamamlandı
-- (content/en/pagination-sorting-and-projections.md) -- TR ile aynı yapı
-- (13/13 başlık, 5/5 embed). Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'pagination-sorting-and-projections');
