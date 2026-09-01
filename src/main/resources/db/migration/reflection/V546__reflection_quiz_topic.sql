-- `reflection` topic's fixed quiz shell (TR+EN) -- SORU İÇERMİYOR, aynı
-- desen enum/V291, string/V490, arrays/V522, scanner/V526, wrapper-classes/
-- V530, file-reading/V534, file-writing/V538, ve records/V542'deki:
-- slug='default', pass_threshold=0.80, active=true. Soru içeriği V547/
-- V548'de, promotion-link migration deseniyle ayrı ayrı ekleniyor.
--
-- Aynı kök neden (bkz. arrays/V522): bir soruyu PUBLISHED yapmak onu hiçbir
-- Quiz'e OTOMATİK EKLEMEZ -- `reflection` için hiç bir `quiz` satırı yoktu,
-- bu yüzden question-promotion/V545'teki 14 PUBLISHED soru var olsa da konu
-- sayfasının sonunda hiçbir şey görünmüyordu. Bu migration + V547/V548, bu
-- eksik bağlantıyı kurar.

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'tr', 'default', 'Bilgini Test Et', 0.80, true FROM topic WHERE slug = 'reflection';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'en', 'default', 'Test Your Knowledge', 0.80, true FROM topic WHERE slug = 'reflection';
