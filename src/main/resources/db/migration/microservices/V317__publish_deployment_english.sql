-- İngilizce çeviri tamamlandı (content/en/deployment.md) -- TR ile birebir aynı
-- yapı (12/12 başlık, 4/4 embed). Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'deployment');
