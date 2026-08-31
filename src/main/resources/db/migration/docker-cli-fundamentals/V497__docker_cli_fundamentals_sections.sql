-- `docker-cli-fundamentals` konusu, 1 örnek (pull/run/ps/logs/exec/stop/
-- start/rm'in hepsini zincirleyen tam PostgreSQL container yaşam döngüsü) +
-- sabit quiz shell'i (TR+EN, SORU İÇERMİYOR -- bkz. V433/V494).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Running PostgreSQL in a Container', 'PostgresContainerLifecycleDemo', 1
FROM topic WHERE slug = 'docker-cli-fundamentals';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'tr', 'default', 'Bilgini Test Et', 0.80, true FROM topic WHERE slug = 'docker-cli-fundamentals';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'en', 'default', 'Test Your Knowledge', 0.80, true FROM topic WHERE slug = 'docker-cli-fundamentals';
