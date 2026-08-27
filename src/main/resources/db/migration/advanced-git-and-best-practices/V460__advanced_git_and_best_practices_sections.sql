-- `advanced-git-and-best-practices` konusu, 1 örnek (reset --hard ile kaybedilen
-- bir commit'in reflog ile kurtarılması) + sabit quiz shell'i (TR+EN, SORU
-- İÇERMİYOR).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Recovering a Lost Commit With reflog', 'ReflogRecoveryDemo', 1
FROM topic WHERE slug = 'advanced-git-and-best-practices';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'tr', 'default', 'Bilgini Test Et', 0.80, true FROM topic WHERE slug = 'advanced-git-and-best-practices';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'en', 'default', 'Test Your Knowledge', 0.80, true FROM topic WHERE slug = 'advanced-git-and-best-practices';
