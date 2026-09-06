-- `postgresql-data-types` topic's fixed quiz shell (TR+EN) -- SORU İÇERMİYOR, aynı desen
-- daha önceki tüm konu quiz shell'leriyle aynı: slug='default',
-- pass_threshold=0.80, active=true. Soru içeriği bu migration'ı izleyen
-- link migration'larında ayrı ayrı ekleniyor.
--
-- Aynı kök neden (bkz. arrays/V522): bir soruyu PUBLISHED yapmak onu hiçbir
-- Quiz'e OTOMATİK EKLEMEZ -- `postgresql-data-types` için hiç bir quiz satırı yoktu (Docker
-- kursunun aksine, bu kursun topic-oluşturma migration'ları hiçbir quiz
-- shell'i önceden eklemedi -- disposable-DB doğrulamasından önce grep ile
-- doğrulandı), bu yüzden question-promotion'daki PUBLISHED sorular var olsa
-- da konu sayfasının sonunda hiçbir şey görünmüyordu. Bu migration + sonraki
-- link migration'ları, bu eksik bağlantıyı kurar.

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'tr', 'default', 'Bilgini Test Et', 0.80, true FROM topic WHERE slug = 'postgresql-data-types';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'en', 'default', 'Test Your Knowledge', 0.80, true FROM topic WHERE slug = 'postgresql-data-types';
