-- `file-writing` topic's fixed quiz shell (TR+EN) -- SORU İÇERMİYOR, aynı
-- desen enum/V291, string/V490, arrays/V522, scanner/V526, wrapper-classes/
-- V530, ve file-reading/V534'teki: slug='default', pass_threshold=0.80,
-- active=true. Soru içeriği V539/V540'ta, promotion-link migration
-- deseniyle (arrays/V523/V524, scanner/V527/V528, wrapper-classes/V531/
-- V532, file-reading/V535/V536) ayrı ayrı ekleniyor.
--
-- Aynı kök neden (bkz. arrays/V522): bir soruyu PUBLISHED yapmak onu hiçbir
-- Quiz'e OTOMATİK EKLEMEZ -- `file-writing` için hiç bir `quiz` satırı
-- yoktu, bu yüzden question-promotion/V537'deki 12 PUBLISHED soru var olsa
-- da konu sayfasının sonunda hiçbir şey görünmüyordu. Bu migration + V539/
-- V540, bu eksik bağlantıyı kurar.

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'tr', 'default', 'Bilgini Test Et', 0.80, true FROM topic WHERE slug = 'file-writing';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'en', 'default', 'Test Your Knowledge', 0.80, true FROM topic WHERE slug = 'file-writing';
