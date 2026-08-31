-- Docker kursunun 2. kategorisi: "Docker in Practice" (category.sort_order=2).
-- Docker Fundamentals'ın (V493, sort_order=1) BİREBİR aynı deseni --
-- kategori + ilk topic tek migration'da, advanced-git'in (V450) ve
-- advanced-postgresql'in (V420) aynı Foundations/Practice ayrımı.
--
-- 1. topic: "docker-networking" -- Docker Fundamentals'ın "Dockerizing a
-- Spring Boot Application"da (V502) geçici bir çözüm olarak kullandığı
-- host.docker.internal'in ötesine geçen ilk gerçek ders: default bridge
-- network'ün container'lar arasında isim çözümlemesini DESTEKLEMEDİĞİ,
-- user-defined network'lerin bunu sağladığı, -p (host-to-container) ile
-- --network'ün (container-to-container) tamamen farklı problemler
-- çözdüğü, ve localhost'un bir container içinde neden farklı bir şey
-- ifade ettiği. INTERMEDIATE (kategorinin ilk topic'i, ama tek başına
-- kavramsal olarak yoğun -- default bridge sınırı gerçek, belgelenmiş
-- bir Docker davranışı, basitleştirilmiş bir BEGINNER anlatımı değil),
-- 30dk, sort_order=1.

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'Docker in Practice', 'docker-in-practice', 2
FROM course
WHERE slug = 'docker';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'docker-networking', 'INTERMEDIATE', 30, 1
FROM category
WHERE slug = 'docker-in-practice';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Docker Networking',
       'Varsayılan bridge network''ün container''lar arasında isim çözümlemesini neden desteklemediği, user-defined network''lerle docker network create, container''dan container''a isimle iletişim, ve localhost''un bir container içinde neden farklı bir şey ifade ettiği.',
       'Docker Networking: User-Defined Network''ler ve Container İletişimi',
       'Docker''ın container ağını nasıl kurar -- varsayılan bridge network, user-defined network''ler, container''dan container''a isimle iletişim, ve -p ile --network arasındaki fark -- bu projenin kendi örneği üzerinden anlatılıyor.',
       true
FROM topic
WHERE slug = 'docker-networking';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Docker Networking',
       'Why the default bridge network doesn''t support name resolution between containers, creating user-defined networks with docker network create, container-to-container communication by name, and why localhost means something different inside a container.',
       'Docker Networking: User-Defined Networks and Container Communication',
       'How Docker sets up container networking -- the default bridge network, user-defined networks, container-to-container communication by name, and the difference between -p and --network -- explained via this project''s own example.',
       false
FROM topic
WHERE slug = 'docker-networking';
