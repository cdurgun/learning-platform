-- İngilizce çeviri tamamlandı
-- (content/en/postgresql-and-the-relational-model.md) -- TR ile aynı yapı
-- (11/11 başlık, 0/0 embed -- what-is-ai/what-is-react'la AYNI "kursun
-- ilk, kod içermeyen dersi" deseni, bu yüzden bir "sections" migration'ı
-- YOK). Yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-and-the-relational-model');
