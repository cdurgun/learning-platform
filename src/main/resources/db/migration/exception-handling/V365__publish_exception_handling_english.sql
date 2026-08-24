-- İngilizce çeviri tamamlandı (content/en/exception-handling.md) -- TR ile
-- aynı yapı (11/11 başlık, 7/7 embed). Yayına alınıyor. Bu, Advanced
-- Spring serisinin (Faz 110-111) 2 topic'lik son yayına alma migration'ı.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'exception-handling');
