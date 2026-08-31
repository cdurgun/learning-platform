-- java/spring-boot/react/ai/postgresql/git-github'den sonra YEDİNCİ Course --
-- "Docker" (course.slug = 'docker'). Kullanıcı plan mode'da 9 topic'lik bir
-- roadmap onayladı (2 kategori: "Docker Fundamentals" 4 topic, "Docker in
-- Practice" 5 topic), postgresql/git-github'ın BİREBİR aynı deseni: course +
-- ilk kategori + ilk topic tek migration'da, sort_order=7 ile kursun sonuna
-- ekleniyor. Kurs, Java/Spring Boot'u zaten bilen ama Docker'ı bilmeyen bir
-- geliştirici için tasarlandı -- yalnızca komut listesi değil, Docker'ın
-- gerçek Java/Spring Boot geliştirme akışına nasıl oturduğu.
--
-- Kategori: "Docker Fundamentals" (category.sort_order=1) -- kursun ilk
-- kategorisi, container/image temel kavramlarından bir Spring Boot
-- uygulamasını containerize etmeye kadar taşıyan 4 topic'i barındıracak
-- (yalnızca bu fazda 1. topic ekleniyor). "Docker in Practice" (sort_order=2,
-- 5 topic: networking/volumes/compose/production/practical-project) henüz
-- eklenmedi.
--
-- 1. topic: "what-is-docker" -- postgresql-and-the-relational-model'in
-- (V400) BİREBİR aynı deseni: 0 kod embed'li, saf bir kavramsal oryantasyon
-- dersi (container vs VM, image vs container, Docker Engine, Docker Hub) --
-- git-fundamentals'ın (V432) aksine, bu ilk ders bilinçli olarak henüz
-- gerçek komut YOK, yalnızca sonraki her dersin dayanacağı zihinsel model.
-- BEGINNER, 15 dk (postgresql-and-the-relational-model ile aynı derinlik).

INSERT INTO course (name, slug, sort_order)
VALUES ('Docker', 'docker', 7);

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'Docker Fundamentals', 'docker-fundamentals', 1
FROM course
WHERE slug = 'docker';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'what-is-docker', 'BEGINNER', 15, 1
FROM category
WHERE slug = 'docker-fundamentals';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Docker Nedir?',
       'Docker''ın ne olduğu, container''ların sanal makinelerden nasıl farklı olduğu, image ile container arasındaki fark, Docker Engine, ve Docker Hub -- Docker kursunun ve Docker Fundamentals kategorisinin 1.''si.',
       'Docker Nedir? Container, Image ve Docker Engine',
       'Docker''ın ne olduğu, container''ların sanal makinelerden nasıl farklı olduğu, ve image/container/Docker Engine/Docker Hub kavramları -- Java/Spring Boot geliştiricileri için gerçek örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'what-is-docker';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'What Is Docker?',
       'What Docker is, how containers differ from virtual machines, the difference between an image and a container, the Docker Engine, and Docker Hub. The 1st lesson in both the Docker course and its Docker Fundamentals category.',
       'What Is Docker? Containers, Images, and the Docker Engine',
       'What Docker is, how containers differ from virtual machines, and the image/container/Docker Engine/Docker Hub concepts -- explained with real examples for Java/Spring Boot developers.',
       false
FROM topic
WHERE slug = 'what-is-docker';
