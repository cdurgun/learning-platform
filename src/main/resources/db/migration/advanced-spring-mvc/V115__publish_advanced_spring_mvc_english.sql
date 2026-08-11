-- İngilizce çeviri tamamlandı (content/en/advanced-spring-mvc.md) -- TR ile
-- birebir aynı 18 ana + 2 ek başlık, aynı 16 embed sırası. Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'advanced-spring-mvc');
