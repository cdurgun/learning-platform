-- İngilizce çeviri tamamlandı (content/en/generic-methods.md) -- TR ile aynı
-- yapı (10/10 başlık, 5/5 embed). Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'generic-methods');
