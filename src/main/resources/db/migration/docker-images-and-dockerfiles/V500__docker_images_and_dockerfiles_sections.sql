-- `docker-images-and-dockerfiles` konusu, 5 örnek (minimal web sunucusu
-- Dockerfile'ı + servis ettiği index.html, CMD vs ENTRYPOINT'i gösteren iki
-- karşılaştırmalı Dockerfile, ve tam build+run+doğrulama akışı) + sabit
-- quiz shell'i (TR+EN, SORU İÇERMİYOR -- bkz. V433/V494).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'A Minimal Web Server Dockerfile', 'MinimalWebServerDockerfile', 1
FROM topic WHERE slug = 'docker-images-and-dockerfiles';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'The Page It Serves', 'MinimalWebServerIndex', 2
FROM topic WHERE slug = 'docker-images-and-dockerfiles';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'CMD Only', 'CmdOnlyDockerfile', 3
FROM topic WHERE slug = 'docker-images-and-dockerfiles';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'ENTRYPOINT With a Default CMD', 'EntrypointDefaultCmdDockerfile', 4
FROM topic WHERE slug = 'docker-images-and-dockerfiles';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Building and Running the Minimal Web Server', 'BuildAndRunMinimalWebServerDemo', 5
FROM topic WHERE slug = 'docker-images-and-dockerfiles';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'tr', 'default', 'Bilgini Test Et', 0.80, true FROM topic WHERE slug = 'docker-images-and-dockerfiles';

INSERT INTO quiz (topic_id, language, slug, title, pass_threshold, active)
SELECT id, 'en', 'default', 'Test Your Knowledge', 0.80, true FROM topic WHERE slug = 'docker-images-and-dockerfiles';
