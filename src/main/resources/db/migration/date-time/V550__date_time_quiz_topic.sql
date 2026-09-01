-- `date-time` topic's fixed quiz shell (TR+EN) -- SORU İÇERMİYOR, aynı desen
-- enum/V291, string/V490, arrays/V522, scanner/V526, wrapper-classes/V530,
-- file-reading/V534, file-writing/V538, records/V542, ve reflection/V546'daki:
-- slug='default', pass_threshold=0.80, active=true. Soru içeriği V551/V552'de,
-- promotion-link migration deseniyle ayrı ayrı ekleniyor.
--
-- Aynı kök neden (bkz. arrays/V522): bir soruyu PUBLISHED yapmak onu hiçbir
-- Quiz'e OTOMATİK EKLEMEZ -- `date-time` için hiç bir `quiz` satırı yoktu,
-- bu yüzden question-promotion/V549'daki 14 PUBLISHED soru var olsa da konu
-- sayfasının sonunda hiçbir şey görünmüyordu. Bu migration + V551/V552, bu
-- eksik bağlantıyı kurar.

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'tr', 'default', 'Bilgini Test Et', 0.80, true FROM topic WHERE slug = 'date-time';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'en', 'default', 'Test Your Knowledge', 0.80, true FROM topic WHERE slug = 'date-time';
