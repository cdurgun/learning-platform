-- İngilizce içerik tamamlandı (content/en/docker-compose.md) -- TR ile aynı
-- yapı (12/12 başlık, 2/2 embed). Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'docker-compose');
