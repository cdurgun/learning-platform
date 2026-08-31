-- İngilizce içerik tamamlandı (content/en/docker-practical-project.md) --
-- TR ile aynı yapı (10/10 başlık, 4/4 embed). Yayına alınıyor. Bu, Docker
-- in Practice kategorisinin (5/5 topic) ve dolayısıyla TÜM Docker kursunun
-- (9/9 topic, 2 kategori) TR+EN yayınını tamamlıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'docker-practical-project');
