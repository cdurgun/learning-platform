-- İngilizce çeviri tamamlandı (content/en/spring-mvc-fundamentals.md) -- TR ile
-- birebir aynı 21 başlık, aynı 11 embed sırası. Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-fundamentals');
