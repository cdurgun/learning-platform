-- İngilizce çeviri tamamlandı (content/en/validation-exception-handling.md) -- TR ile
-- birebir aynı 18 başlık, aynı 14 embed sırası. Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'validation-exception-handling');
