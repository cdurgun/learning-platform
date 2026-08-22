-- İngilizce çeviri tamamlandı (content/en/for-loop.md) -- TR ile birebir aynı yapı
-- (12/12 başlık, 6/6 embed). Kullanıcı onay turlarını kaldırdığı için (bkz. Faz 83
-- devamı) TR ile aynı anda yayına alınıyor.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'for-loop');
