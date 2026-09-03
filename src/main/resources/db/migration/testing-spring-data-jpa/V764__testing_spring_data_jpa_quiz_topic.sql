-- `testing-spring-data-jpa` topic's fixed quiz shell (TR+EN) -- SORU İÇERMİYOR, aynı desen
-- spring-batch/V728, transaction-management/V676 ve önceki tüm konu
-- quiz shell'leriyle aynı: slug='default', pass_threshold=0.80, active=true.
-- Soru içeriği bu migration'ı izleyen link migration'larında ayrı ayrı ekleniyor.
--
-- Aynı kök neden (bkz. arrays/V522): bir soruyu PUBLISHED yapmak onu hiçbir
-- Quiz'e OTOMATİK EKLEMEZ -- `testing-spring-data-jpa` için hiç bir quiz satırı yoktu, bu
-- yüzden question-promotion'daki 14 PUBLISHED soru var olsa da konu
-- sayfasının sonunda hiçbir şey görünmüyordu. Bu migration + sonraki link
-- migration'ları, bu eksik bağlantıyı kurar.

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'tr', 'default', 'Bilgini Test Et', 0.80, true FROM topic WHERE slug = 'testing-spring-data-jpa';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'en', 'default', 'Test Your Knowledge', 0.80, true FROM topic WHERE slug = 'testing-spring-data-jpa';
