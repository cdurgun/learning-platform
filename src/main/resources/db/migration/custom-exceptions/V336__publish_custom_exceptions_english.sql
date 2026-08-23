-- İngilizce çeviri tamamlandı (content/en/custom-exceptions.md) -- TR ile
-- aynı yapı (9/9 başlık, 4/4 embed). Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'custom-exceptions');
