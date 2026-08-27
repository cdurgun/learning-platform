-- İngilizce çeviri tamamlandı (content/en/practical-git-github-workflow.md) --
-- TR ile aynı yapı (10/10 başlık, 1/1 embed). Yayına alınıyor. Bu, "Advanced
-- Git" kategorisinin VE Git & GitHub kursunun TAMAMININ son topic'i -- kurs
-- artık 11/11 topic tamam (2 kategori: Git Fundamentals 6/6, Advanced Git 5/5).
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'practical-git-github-workflow');
