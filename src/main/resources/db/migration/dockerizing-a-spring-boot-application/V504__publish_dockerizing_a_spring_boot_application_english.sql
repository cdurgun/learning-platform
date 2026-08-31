-- İngilizce içerik tamamlandı
-- (content/en/dockerizing-a-spring-boot-application.md) -- TR ile aynı
-- yapı (10/10 başlık, 4/4 embed). Yayına alınıyor. Bu, Docker Fundamentals
-- kategorisinin 4/4 topic'ini de yayına alarak kategoriyi tamamlıyor --
-- "Docker in Practice" (sort_order=2, 5 topic) henüz eklenmedi.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'dockerizing-a-spring-boot-application');
