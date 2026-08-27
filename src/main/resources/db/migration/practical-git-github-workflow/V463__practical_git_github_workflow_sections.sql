-- `practical-git-github-workflow` konusu, 1 örnek (rebase sırasında oluşan
-- conflict'in çözümü, senaryonun ortasındaki kritik adım) + sabit quiz shell'i
-- (TR+EN, SORU İÇERMİYOR).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Resolving a Conflict Mid-Rebase', 'FullWorkflowDemo', 1
FROM topic WHERE slug = 'practical-git-github-workflow';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'tr', 'default', 'Bilgini Test Et', 0.80, true FROM topic WHERE slug = 'practical-git-github-workflow';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'en', 'default', 'Test Your Knowledge', 0.80, true FROM topic WHERE slug = 'practical-git-github-workflow';
