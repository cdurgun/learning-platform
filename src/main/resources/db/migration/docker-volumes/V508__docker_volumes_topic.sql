-- Docker in Practice kategorisinin 2. topic'i: "docker-volumes". Kategori
-- V505'te zaten oluşturuldu, burada yalnızca yeni bir topic + çevirileri --
-- working-with-commits'in (V435) BİREBİR aynı deseni. Odak: container'ların
-- neden ephemeral olduğu (yazılabilir katman docker rm ile silinir -- bkz.
-- V497'deki docker rm), named volume'lar, -v ile mount etmek, PostgreSQL'in
-- verisini /var/lib/postgresql/data'da sakladığı, named volume vs bind
-- mount, ve kalıcılığın bilinçli, yıkıcı bir testle doğrulanması.
-- INTERMEDIATE, 30dk, sort_order=2.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'docker-volumes', 'INTERMEDIATE', 30, 2
FROM category
WHERE slug = 'docker-in-practice';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Docker Volumes',
       'Container''ların neden ephemeral (geçici) olduğu, named volume''lar, docker run -v ile bir volume mount etmek, PostgreSQL''in verisini nerede sakladığı, named volume vs bind mount, ve kalıcılığın bilinçli bir testle doğrulanması.',
       'Docker Volumes: Named Volume''lar ile Veri Kalıcılığı',
       'Docker container''larının verisi neden kaybolur, named volume''lar bunu nasıl önler, bir volume nasıl mount edilir, ve PostgreSQL verisi nasıl kalıcı hale getirilir -- gerçek, doğrulanmış bir örnekle anlatılıyor.',
       true
FROM topic
WHERE slug = 'docker-volumes';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Docker Volumes',
       'Why containers are ephemeral, named volumes, mounting a volume with docker run -v, where PostgreSQL stores its data, named volumes vs. bind mounts, and verifying persistence with a deliberate test.',
       'Docker Volumes: Persisting Data with Named Volumes',
       'Why a Docker container''s data disappears, how named volumes prevent that, how to mount a volume, and how to make PostgreSQL data persistent -- explained with a real, verified example.',
       false
FROM topic
WHERE slug = 'docker-volumes';
