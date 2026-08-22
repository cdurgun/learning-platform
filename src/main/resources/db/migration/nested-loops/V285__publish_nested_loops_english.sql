-- İngilizce çeviri tamamlandı (content/en/nested-loops.md) -- TR ile birebir aynı
-- yapı (12/12 başlık, 6/6 embed). Onay turu olmadan TR ile aynı anda yayına alınıyor
-- (bkz. Faz 83/84 devamı). Bu migration ile `control-flow` kategorisindeki 6
-- topic'in TAMAMI (if / else, switch, for Loop, Enhanced for Loop, while &
-- do-while Loops, Nested Loops) TR+EN yayında.
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'nested-loops');
