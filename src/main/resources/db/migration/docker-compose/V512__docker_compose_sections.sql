-- `docker-compose` konusu, 2 örnek (bu projenin tam docker-compose.yml'i +
-- docker compose up/down'ın tam bir çalıştırma döngüsü) + sabit quiz
-- shell'i (TR+EN, SORU İÇERMİYOR -- bkz. V433/V494).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'This Project''s docker-compose.yml', 'SpringBootPostgresCompose', 1
FROM topic WHERE slug = 'docker-compose';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Bringing It Up and Down', 'ComposeUpAndDownDemo', 2
FROM topic WHERE slug = 'docker-compose';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'tr', 'default', 'Bilgini Test Et', 0.80, true FROM topic WHERE slug = 'docker-compose';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'en', 'default', 'Test Your Knowledge', 0.80, true FROM topic WHERE slug = 'docker-compose';
