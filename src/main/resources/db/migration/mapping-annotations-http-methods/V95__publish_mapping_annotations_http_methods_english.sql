-- İngilizce çeviri tamamlandı (content/en/mapping-annotations-http-methods.md) -- TR
-- ile birebir aynı 19 başlık, aynı 12 embed sırası. Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'mapping-annotations-http-methods');
