-- İngilizce çeviri tamamlandı (content/en/lambda-expressions.md) -- TR ile birebir
-- aynı yapı (11/11 başlık, 4/4 embed). Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'lambda-expressions');
