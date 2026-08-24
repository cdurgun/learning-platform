-- İngilizce çeviri tamamlandı (content/en/java-bean-validation.md) -- TR ile
-- aynı yapı (11/11 başlık, 7/7 embed). Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'java-bean-validation');
