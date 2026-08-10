-- EN çevirisi (content/en/dependency-injection.md) tamamlandı -- Threads'teki V50'ye
-- paralel şekilde İngilizce çeviriyi yayına alıyoruz.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'dependency-injection');
