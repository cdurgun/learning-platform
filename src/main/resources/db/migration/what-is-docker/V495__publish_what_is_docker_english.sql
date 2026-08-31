-- İngilizce içerik tamamlandı (content/en/what-is-docker.md) -- TR ile aynı
-- yapı (11/11 başlık, 0/0 embed). Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'what-is-docker');
