-- İngilizce çeviri tamamlandı
-- (content/en/databases-schemas-tables-and-basic-sql.md) -- TR ile aynı yapı
-- (10/10 başlık, 0/0 embed -- inline ```sql/```text fence'ler, bu yüzden
-- bir "sections" migration'ı YOK). Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'databases-schemas-tables-and-basic-sql');
