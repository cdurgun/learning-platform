-- İngilizce çeviri tamamlandı (content/en/path-variables-request-parameters.md) --
-- TR ile birebir aynı 19 başlık, aynı 14 embed sırası. Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'path-variables-request-parameters');
