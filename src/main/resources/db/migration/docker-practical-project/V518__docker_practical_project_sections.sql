-- `docker-practical-project` konusu, 4 örnek (tam task tracker Spring Boot
-- uygulaması, production-seviyesi Dockerfile'ı, healthcheck koşullu
-- Compose dosyası, ve baştan sona doğrulama akışı) + sabit quiz shell'i
-- (TR+EN, SORU İÇERMİYOR -- bkz. V433/V494).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'The Task Tracker Application', 'TaskTrackerApplication', 1
FROM topic WHERE slug = 'docker-practical-project';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Its Dockerfile', 'TaskTrackerDockerfile', 2
FROM topic WHERE slug = 'docker-practical-project';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Its docker-compose.yml', 'TaskTrackerCompose', 3
FROM topic WHERE slug = 'docker-practical-project';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Verifying It End to End', 'VerifyTaskTrackerDemo', 4
FROM topic WHERE slug = 'docker-practical-project';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'tr', 'default', 'Bilgini Test Et', 0.80, true FROM topic WHERE slug = 'docker-practical-project';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'en', 'default', 'Test Your Knowledge', 0.80, true FROM topic WHERE slug = 'docker-practical-project';
