-- Docker in Practice kategorisinin 3. topic'i: "docker-compose". Kategori
-- V505'te zaten oluşturuldu, burada yalnızca yeni bir topic + çevirileri --
-- working-with-commits'in (V435) BİREBİR aynı deseni. Bu, kategorinin ana
-- sentez konusu: "Docker Networking" (V505) ve "Docker Volumes"un (V508)
-- elle yaptığı her şeyi (docker network create, docker volume create, iki
-- ayrı docker run) tek bir docker-compose.yml'e ve docker compose up'a
-- indiriyor -- services, depends_on, Compose'un otomatik servis-adı-ile-DNS
-- ağı, ve volumes. INTERMEDIATE, 35dk (kategorinin en yoğun sentez konusu),
-- sort_order=3.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'docker-compose', 'INTERMEDIATE', 35, 3
FROM category
WHERE slug = 'docker-in-practice';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Docker Compose',
       'docker-compose.yml, service''ler, depends_on, Compose''ın otomatik servis-adı-ile-networking''i, ve volumes -- "Docker Networking" ile "Docker Volumes"un elle yaptığı her şeyi tek bir dosyaya ve docker compose up''a indirerek.',
       'Docker Compose: Servisler, Networking, ve Volumes',
       'Bir docker-compose.yml nasıl yazılır -- service''ler, depends_on, otomatik servis-adı-ile-networking, ve volumes -- bu projenin kendi Spring Boot + PostgreSQL kurulumu üzerinden anlatılıyor.',
       true
FROM topic
WHERE slug = 'docker-compose';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Docker Compose',
       'docker-compose.yml, services, depends_on, Compose''s automatic service-name networking, and volumes -- reducing everything "Docker Networking" and "Docker Volumes" did by hand to one file and docker compose up.',
       'Docker Compose: Services, Networking, and Volumes',
       'How to write a docker-compose.yml -- services, depends_on, automatic service-name networking, and volumes -- explained via this project''s own Spring Boot + PostgreSQL setup.',
       false
FROM topic
WHERE slug = 'docker-compose';
