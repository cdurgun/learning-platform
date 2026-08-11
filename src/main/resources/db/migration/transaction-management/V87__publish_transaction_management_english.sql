-- EN çevirisi (content/en/transaction-management.md) tamamlandı -- önceki
-- konulardaki gibi (V63, V69, V75, V81) İngilizce çeviriyi yayına alıyoruz.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'transaction-management');
