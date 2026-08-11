-- İngilizce çeviri tamamlandı (content/en/request-response-handling.md) -- TR ile
-- birebir aynı 21 başlık, aynı 14 embed sırası. Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'request-response-handling');
