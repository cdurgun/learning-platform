-- İngilizce çeviri tamamlandı (content/en/bounded-type-parameters.md) -- TR
-- ile aynı yapı (9/9 başlık, 5/5 embed). Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'bounded-type-parameters');
