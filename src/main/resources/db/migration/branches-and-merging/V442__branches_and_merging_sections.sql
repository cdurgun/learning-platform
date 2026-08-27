-- `branches-and-merging` konusu, 1 örnek (tam feature branch workflow'u: branch,
-- commit, merge, sil) + sabit quiz shell'i (TR+EN, SORU İÇERMİYOR -- bkz. V433).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'A Complete Feature Branch Workflow', 'BranchWorkflowDemo', 1
FROM topic WHERE slug = 'branches-and-merging';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'tr', 'default', 'Bilgini Test Et', 0.80, true FROM topic WHERE slug = 'branches-and-merging';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'en', 'default', 'Test Your Knowledge', 0.80, true FROM topic WHERE slug = 'branches-and-merging';
