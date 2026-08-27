-- `stash` konusu, 1 örnek (yarım kalmış işi stash'le, acil bir bug'ı düzelt,
-- işe geri dön tam akışı) + sabit quiz shell'i (TR+EN, SORU İÇERMİYOR).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'A Real-World Stash Workflow', 'StashWorkflowDemo', 1
FROM topic WHERE slug = 'stash';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'tr', 'default', 'Bilgini Test Et', 0.80, true FROM topic WHERE slug = 'stash';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'en', 'default', 'Test Your Knowledge', 0.80, true FROM topic WHERE slug = 'stash';
