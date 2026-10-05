-- `developing-with-claude-code` konusunun sabit quiz shell'i (TR+EN) -- soru içermez; sorular bu dosyayı
-- izleyen link migration'larında bağlanır. slug='default', pass_threshold=0.80.

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'tr', 'default', 'Bilgini Test Et', 0.80, true FROM topic WHERE slug = 'developing-with-claude-code';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'en', 'default', 'Test Your Knowledge', 0.80, true FROM topic WHERE slug = 'developing-with-claude-code';
