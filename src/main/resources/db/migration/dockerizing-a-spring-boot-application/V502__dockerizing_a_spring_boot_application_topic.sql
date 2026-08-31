-- Docker Fundamentals kategorisinin 4. (ve son) topic'i:
-- "dockerizing-a-spring-boot-application". Kategori V493'te zaten
-- oluşturuldu, burada yalnızca yeni bir topic + çevirileri --
-- working-with-commits'in (V435) BİREBİR aynı deseni. Odak: "Docker
-- İmajları ve Dockerfile"in (V499) jenerik talimat setini bu projenin
-- kendi gerçek `learning-platform` Spring Boot JAR'ına (pom.xml'deki
-- gerçek coordinate'ler) uygulamak -- JRE vs JDK base image, .dockerignore,
-- multi-stage build'ler, ve container-farkında JVM heap boyutlandırması.
-- BEGINNER değil INTERMEDIATE (kategorideki ilk gerçek çok-kavramlı sentez
-- konusu), 35 dk, sort_order=4.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'dockerizing-a-spring-boot-application', 'INTERMEDIATE', 35, 4
FROM category
WHERE slug = 'docker-fundamentals';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Bir Spring Boot Uygulamasını Docker''a Taşımak',
       'Bir Spring Boot JAR''ı için JRE vs JDK base image seçimi, .dockerignore, multi-stage build''ler, ve container-farkında JVM bellek boyutlandırması -- bu projenin kendi gerçek learning-platform uygulaması üzerinden.',
       'Spring Boot Uygulamasını Docker''a Taşımak: JRE, Multi-Stage, JVM',
       'Bir Spring Boot JAR''ını nasıl containerize edersin -- JRE vs JDK base image, .dockerignore, multi-stage build''ler, ve container-farkında JVM bellek ayarları -- gerçek bir Spring Boot uygulaması üzerinden anlatılıyor.',
       true
FROM topic
WHERE slug = 'dockerizing-a-spring-boot-application';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Dockerizing a Spring Boot Application',
       'Choosing a JRE vs JDK base image for a Spring Boot JAR, .dockerignore, multi-stage builds, and container-aware JVM memory sizing -- via this project''s own real learning-platform application.',
       'Dockerizing a Spring Boot Application: JRE, Multi-Stage, JVM',
       'How to containerize a Spring Boot JAR -- JRE vs JDK base images, .dockerignore, multi-stage builds, and container-aware JVM memory settings -- explained via a real Spring Boot application.',
       false
FROM topic
WHERE slug = 'dockerizing-a-spring-boot-application';
