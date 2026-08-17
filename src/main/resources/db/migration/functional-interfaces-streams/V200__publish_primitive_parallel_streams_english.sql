-- İngilizce çeviri tamamlandı (content/en/primitive-parallel-streams.md) -- TR ile
-- birebir aynı yapı (15/15 başlık, 6/6 embed). Yayına alınıyor.
--
-- Bu migration'ın uygulanmasıyla `functional-interfaces-streams` kategorisinin
-- planlanan 7 topic'i TR+EN tamamen tamamlanmış oluyor (bkz. V179'daki orijinal plan,
-- V198'deki "KATEGORİ TAMAMLANDI" notu).
UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id = (SELECT id FROM topic WHERE slug = 'primitive-parallel-streams');
