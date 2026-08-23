-- İngilizce çeviri tamamlandı (content/en/exception-handling-best-practices.md)
-- -- TR ile aynı yapı (9/9 başlık, 4/4 embed). Yayına alınıyor. Bu, Exception
-- Handling serisinin (Faz 97-104) 7 topic'lik son yayına alma migration'ı.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'exception-handling-best-practices');
