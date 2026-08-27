-- `github-and-remotes` konusu, 1 örnek (fetch/pull + yeni branch push -u tam
-- akışı) + sabit quiz shell'i (TR+EN, SORU İÇERMİYOR -- bkz. V433).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'A Day of Working With a Remote', 'RemoteWorkflowDemo', 1
FROM topic WHERE slug = 'github-and-remotes';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'tr', 'default', 'Bilgini Test Et', 0.80, true FROM topic WHERE slug = 'github-and-remotes';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'en', 'default', 'Test Your Knowledge', 0.80, true FROM topic WHERE slug = 'github-and-remotes';
