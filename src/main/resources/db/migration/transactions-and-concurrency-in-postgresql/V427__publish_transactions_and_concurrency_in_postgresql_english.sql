-- İngilizce çeviri tamamlandı
-- (content/en/transactions-and-concurrency-in-postgresql.md) -- TR ile
-- aynı yapı (10/10 başlık, 0/0 embed -- inline ```sql fence'ler, bu
-- yüzden bir "sections" migration'ı YOK). Yayına alınıyor. Bu migration'la
-- Advanced PostgreSQL kategorisi (4 topic) VE PostgreSQL kursunun tamamı
-- (14 topic, 2 kategori, TR+EN) TAMAMLANDI.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'transactions-and-concurrency-in-postgresql');
