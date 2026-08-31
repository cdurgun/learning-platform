-- `production-docker-for-java-applications` konusu, 2 örnek (production'a
-- hazır tam Dockerfile: layer caching + non-root + HEALTHCHECK, ve
-- depends_on: condition: service_healthy içeren Compose dosyası) + sabit
-- quiz shell'i (TR+EN, SORU İÇERMİYOR -- bkz. V433/V494).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'A Production Dockerfile', 'ProductionSpringBootDockerfile', 1
FROM topic WHERE slug = 'production-docker-for-java-applications';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Compose With a Real Health Condition', 'ProductionCompose', 2
FROM topic WHERE slug = 'production-docker-for-java-applications';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'tr', 'default', 'Bilgini Test Et', 0.80, true FROM topic WHERE slug = 'production-docker-for-java-applications';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'en', 'default', 'Test Your Knowledge', 0.80, true FROM topic WHERE slug = 'production-docker-for-java-applications';
