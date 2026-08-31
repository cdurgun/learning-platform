-- Docker Fundamentals kategorisinin 2. topic'i: "docker-cli-fundamentals".
-- Kategori V493'te zaten oluşturuldu, burada yalnızca yeni bir topic +
-- çevirileri -- working-with-commits'in (V435) BİREBİR aynı deseni.
-- Odak: docker pull/images/run/ps/logs/exec/stop/start/rm -- "Docker Nedir?"in
-- (V493) kurduğu image/container/Docker Engine kelime dağarcığını komut
-- satırında işe koşan ilk pratik ders. BEGINNER/25dk, sort_order=2.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'docker-cli-fundamentals', 'BEGINNER', 25, 2
FROM category
WHERE slug = 'docker-fundamentals';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Docker CLI Temelleri',
       'docker pull, docker images, docker run, docker ps, docker logs, docker exec, docker stop/start, ve docker rm -- bir PostgreSQL container''ının tam yaşam döngüsü üzerinden, gerçek örneklerle anlatılıyor.',
       'Docker CLI Temelleri: pull, run, ps, logs, exec, rm',
       'Docker''ın temel komut satırı komutları -- pull, images, run, ps, logs, exec, stop, start, rm -- bir PostgreSQL container''ının tam yaşam döngüsü üzerinden gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'docker-cli-fundamentals';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Docker CLI Fundamentals',
       'docker pull, docker images, docker run, docker ps, docker logs, docker exec, docker stop/start, and docker rm -- walked through via the full lifecycle of a PostgreSQL container, with real examples.',
       'Docker CLI Fundamentals: pull, run, ps, logs, exec, rm',
       'Docker''s core command-line commands -- pull, images, run, ps, logs, exec, stop, start, rm -- explained through the full lifecycle of a PostgreSQL container, with real examples.',
       false
FROM topic
WHERE slug = 'docker-cli-fundamentals';
