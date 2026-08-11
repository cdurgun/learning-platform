-- İngilizce çeviri tamamlandı (content/en/rest-api-design.md) -- TR ile birebir
-- aynı 17 ana + 2 ek başlık, aynı 15 embed sırası. Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'rest-api-design');
