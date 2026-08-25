-- İngilizce çeviri tamamlandı
-- (content/en/indexes-and-query-performance-with-explain.md) -- TR ile
-- aynı yapı (11/11 başlık, 0/0 embed -- inline ```sql/```text fence'ler,
-- bu yüzden bir "sections" migration'ı YOK). Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'indexes-and-query-performance-with-explain');
