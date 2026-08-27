-- `git-fundamentals` konusu, 2 örneğin tamamı (kod yorumları İngilizce, Faz 53'teki
-- aynı kuralla). Ayrıca bu konunun sabit quiz shell'i (TR+EN) -- SORU İÇERMİYOR,
-- bkz. CLAUDE.md "Mimari" Faz 87 maddesi: soru içeriği yalnızca ingestion API'den
-- gelir, hiçbir zaman bir migration'a yazılmaz. `enum` topic'inin (V291) BİREBİR
-- aynı deseni: slug='default', pass_threshold=0.80, active=true.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Creating a Repository', 'GitInitDemo', 1
FROM topic WHERE slug = 'git-fundamentals';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Staging and Committing a File', 'StagingAndCommitDemo', 2
FROM topic WHERE slug = 'git-fundamentals';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'tr', 'default', 'Bilgini Test Et', 0.80, true FROM topic WHERE slug = 'git-fundamentals';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'en', 'default', 'Test Your Knowledge', 0.80, true FROM topic WHERE slug = 'git-fundamentals';
