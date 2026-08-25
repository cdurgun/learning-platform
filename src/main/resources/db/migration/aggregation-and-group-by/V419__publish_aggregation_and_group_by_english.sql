-- İngilizce çeviri tamamlandı
-- (content/en/aggregation-and-group-by.md) -- TR ile aynı yapı (11/11
-- başlık, 0/0 embed -- inline ```sql fence'ler, bu yüzden bir "sections"
-- migration'ı YOK). Yayına alınıyor. Bu migration'la PostgreSQL
-- Foundations kategorisi (10 topic, TR+EN) TAMAMLANDI.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'aggregation-and-group-by');
