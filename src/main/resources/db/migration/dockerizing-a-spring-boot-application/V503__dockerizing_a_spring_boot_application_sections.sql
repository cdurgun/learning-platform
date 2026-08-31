-- `dockerizing-a-spring-boot-application` konusu, 4 örnek (tek-aşamalı bir
-- Spring Boot JAR Dockerfile'ı, örnek bir .dockerignore, multi-stage build
-- versiyonu, ve tam build+run+doğrulama akışı) + sabit quiz shell'i (TR+EN,
-- SORU İÇERMİYOR -- bkz. V433/V494).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'A Single-Stage Spring Boot Dockerfile', 'SpringBootJarDockerfile', 1
FROM topic WHERE slug = 'dockerizing-a-spring-boot-application';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'An Example .dockerignore', 'DockerignoreExample', 2
FROM topic WHERE slug = 'dockerizing-a-spring-boot-application';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'A Multi-Stage Spring Boot Dockerfile', 'MultiStageSpringBootDockerfile', 3
FROM topic WHERE slug = 'dockerizing-a-spring-boot-application';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Building and Running This Project in Docker', 'BuildAndRunSpringBootDemo', 4
FROM topic WHERE slug = 'dockerizing-a-spring-boot-application';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'tr', 'default', 'Bilgini Test Et', 0.80, true FROM topic WHERE slug = 'dockerizing-a-spring-boot-application';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'en', 'default', 'Test Your Knowledge', 0.80, true FROM topic WHERE slug = 'dockerizing-a-spring-boot-application';
