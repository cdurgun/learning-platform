-- `scanner` topic's fixed quiz shell (TR+EN) -- SORU İÇERMİYOR, aynı desen
-- enum/V291, git-fundamentals/V433, string/V490, ve arrays/V522'deki:
-- slug='default', pass_threshold=0.80, active=true. Soru içeriği V527/V528'de,
-- promotion-link migration deseniyle (arrays/V523/V524) ayrı ayrı ekleniyor.
--
-- Aynı kök neden (bkz. arrays/V522): bir soruyu PUBLISHED yapmak onu hiçbir
-- Quiz'e OTOMATİK EKLEMEZ -- `scanner` için hiç bir `quiz` satırı yoktu, bu
-- yüzden question-promotion/V525'teki 11 PUBLISHED soru var olsa da konu
-- sayfasının sonunda hiçbir şey görünmüyordu. Bu migration + V527/V528, bu
-- eksik bağlantıyı kurar.

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'tr', 'default', 'Bilgini Test Et', 0.80, true FROM topic WHERE slug = 'scanner';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'en', 'default', 'Test Your Knowledge', 0.80, true FROM topic WHERE slug = 'scanner';
