-- `wrapper-classes` topic's fixed quiz shell (TR+EN) -- SORU İÇERMİYOR, aynı
-- desen enum/V291, string/V490, arrays/V522, ve scanner/V526'daki:
-- slug='default', pass_threshold=0.80, active=true. Soru içeriği V531/V532'de,
-- promotion-link migration deseniyle (arrays/V523/V524, scanner/V527/V528)
-- ayrı ayrı ekleniyor.
--
-- Aynı kök neden (bkz. arrays/V522): bir soruyu PUBLISHED yapmak onu hiçbir
-- Quiz'e OTOMATİK EKLEMEZ -- `wrapper-classes` için hiç bir `quiz` satırı
-- yoktu, bu yüzden question-promotion/V529'daki 10 PUBLISHED soru var olsa
-- da konu sayfasının sonunda hiçbir şey görünmüyordu. Bu migration + V531/
-- V532, bu eksik bağlantıyı kurar.

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'tr', 'default', 'Bilgini Test Et', 0.80, true FROM topic WHERE slug = 'wrapper-classes';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'en', 'default', 'Test Your Knowledge', 0.80, true FROM topic WHERE slug = 'wrapper-classes';
