-- `rebase-and-squash` konusu, 1 örnek (main üzerine rebase + conflict çözümü +
-- force-with-lease tam akışı) + sabit quiz shell'i (TR+EN, SORU İÇERMİYOR).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Rebasing a Feature Branch onto main', 'RebaseOntoMainDemo', 1
FROM topic WHERE slug = 'rebase-and-squash';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'tr', 'default', 'Bilgini Test Et', 0.80, true FROM topic WHERE slug = 'rebase-and-squash';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'en', 'default', 'Test Your Knowledge', 0.80, true FROM topic WHERE slug = 'rebase-and-squash';
