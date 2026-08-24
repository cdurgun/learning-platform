-- İngilizce çeviri tamamlandı (content/en/task-execution-and-scheduling.md)
-- -- TR ile aynı yapı (12/12 başlık, 7/7 embed). Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'task-execution-and-scheduling');
