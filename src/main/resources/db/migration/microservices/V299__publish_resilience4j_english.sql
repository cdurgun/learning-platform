-- İngilizce çeviri tamamlandı (content/en/resilience4j.md) -- TR ile birebir aynı
-- yapı (12/12 başlık, 5/5 embed). Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'resilience4j');
