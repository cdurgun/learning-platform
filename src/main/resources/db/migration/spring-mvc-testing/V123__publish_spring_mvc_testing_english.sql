-- İngilizce çeviri tamamlandı (content/en/spring-mvc-testing.md) -- TR ile birebir
-- aynı 17 ana + 2 ek başlık, aynı 14 embed sırası. Yayına alınıyor.
--
-- Bu, Spring MVC kategorisinin planlanan son (9/9) konusuydu -- bu migration'la
-- kategori tamamlanıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-testing');
