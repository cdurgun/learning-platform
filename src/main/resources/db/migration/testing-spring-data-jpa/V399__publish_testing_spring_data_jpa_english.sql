-- İngilizce çeviri tamamlandı (content/en/testing-spring-data-jpa.md) --
-- TR ile aynı yapı (12/12 başlık, 5/5 embed). Yayına alınıyor. Bu,
-- Spring Data JPA kategorisinin (Faz 115-123) 9 topic'lik son yayına
-- alma migration'ı.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'testing-spring-data-jpa');
