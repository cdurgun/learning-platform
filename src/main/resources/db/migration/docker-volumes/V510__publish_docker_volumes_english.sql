-- İngilizce içerik tamamlandı (content/en/docker-volumes.md) -- TR ile aynı
-- yapı (11/11 başlık, 1/1 embed). Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'docker-volumes');
