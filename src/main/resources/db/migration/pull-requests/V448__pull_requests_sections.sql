-- `pull-requests` konusu -- kod örneği yok (GitHub web UI süreci). Sabit quiz
-- shell'i (TR+EN, SORU İÇERMİYOR -- bkz. V433).

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'tr', 'default', 'Bilgini Test Et', 0.80, true FROM topic WHERE slug = 'pull-requests';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'en', 'default', 'Test Your Knowledge', 0.80, true FROM topic WHERE slug = 'pull-requests';
