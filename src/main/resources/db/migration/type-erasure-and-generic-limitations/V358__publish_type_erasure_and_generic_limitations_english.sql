-- İngilizce çeviri tamamlandı
-- (content/en/type-erasure-and-generic-limitations.md) -- TR ile aynı yapı
-- (10/10 başlık, 5/5 embed). Yayına alınıyor. Bu, Generics serisinin
-- (Faz 105-110) 6 topic'lik son yayına alma migration'ı.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'type-erasure-and-generic-limitations');
