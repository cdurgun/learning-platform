-- İngilizce çeviri tamamlandı
-- (content/en/constraints-and-keys.md) -- TR ile aynı yapı (11/11 başlık,
-- 0/0 embed -- inline ```sql fence'ler, bu yüzden bir "sections"
-- migration'ı YOK). Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'constraints-and-keys');
