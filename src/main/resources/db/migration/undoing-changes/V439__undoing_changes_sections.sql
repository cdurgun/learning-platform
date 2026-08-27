-- `undoing-changes` konusu, 1 örnek (git reset --soft ile "çok erken commit
-- attım" senaryosu) + sabit quiz shell'i (TR+EN, SORU İÇERMİYOR -- bkz. V433).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Undoing a Commit With reset --soft', 'ResetSoftDemo', 1
FROM topic WHERE slug = 'undoing-changes';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'tr', 'default', 'Bilgini Test Et', 0.80, true FROM topic WHERE slug = 'undoing-changes';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'en', 'default', 'Test Your Knowledge', 0.80, true FROM topic WHERE slug = 'undoing-changes';
