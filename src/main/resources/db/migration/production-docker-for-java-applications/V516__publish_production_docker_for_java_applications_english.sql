-- İngilizce içerik tamamlandı
-- (content/en/production-docker-for-java-applications.md) -- TR ile aynı
-- yapı (11/11 başlık, 2/2 embed). Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'production-docker-for-java-applications');
