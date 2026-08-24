-- İngilizce çeviri tamamlandı (content/en/jpa-hibernate-and-spring-data-jpa.md)
-- -- TR ile aynı yapı (13/13 başlık, 3/3 embed). Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa');
