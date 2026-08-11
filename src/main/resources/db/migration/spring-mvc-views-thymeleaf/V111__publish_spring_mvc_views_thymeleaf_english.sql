-- İngilizce çeviri tamamlandı (content/en/spring-mvc-views-thymeleaf.md) -- TR ile
-- birebir aynı 19 ana + 2 ek başlık, aynı 15 embed sırası. Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-views-thymeleaf');
