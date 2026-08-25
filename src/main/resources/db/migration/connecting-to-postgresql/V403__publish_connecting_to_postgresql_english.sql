-- İngilizce çeviri tamamlandı
-- (content/en/connecting-to-postgresql.md) -- TR ile aynı yapı (10/10
-- başlık, 0/0 embed -- creating-a-react-application.md'deki CLI/terminal
-- dersi deseniyle AYNI, bu yüzden bir "sections" migration'ı YOK). Yayına
-- alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'connecting-to-postgresql');
