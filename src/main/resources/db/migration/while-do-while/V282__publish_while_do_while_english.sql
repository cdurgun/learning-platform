-- İngilizce çeviri tamamlandı (content/en/while-do-while.md) -- TR ile birebir aynı
-- yapı (12/12 başlık, 6/6 embed). Onay turu olmadan TR ile aynı anda yayına alınıyor
-- (bkz. Faz 83 devamı).
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'while-do-while');
