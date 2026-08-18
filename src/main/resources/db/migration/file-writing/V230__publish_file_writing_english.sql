-- İngilizce çeviri tamamlandı (content/en/file-writing.md) -- TR ile birebir
-- aynı yapı (12/12 başlık, 6/6 embed). Yayına alınıyor.
--
-- Bu migration'la birlikte File I/O konusu (file-reading + file-writing, iki
-- topic'e bölünmüş hâliyle) TAMAMLANIYOR -- bkz. CLAUDE.md Faz 60/61.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'file-writing');
