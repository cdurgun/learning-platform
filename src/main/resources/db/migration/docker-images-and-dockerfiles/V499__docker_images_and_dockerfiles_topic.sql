-- Docker Fundamentals kategorisinin 3. topic'i: "docker-images-and-dockerfiles".
-- Kategori V493'te zaten oluşturuldu, burada yalnızca yeni bir topic +
-- çevirileri -- working-with-commits'in (V435) BİREBİR aynı deseni.
-- Odak: Dockerfile, FROM, WORKDIR, COPY, RUN, EXPOSE, CMD vs ENTRYPOINT,
-- docker build -- bilinçli olarak henüz Java'ya özgü değil, jenerik bir
-- minimal web sunucusu örneği üzerinden (bir sonraki topic, "Dockerizing a
-- Spring Boot Application", aynı talimat setini gerçek bir JAR'a uygular).
-- BEGINNER/30dk, sort_order=3.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'docker-images-and-dockerfiles', 'BEGINNER', 30, 3
FROM category
WHERE slug = 'docker-fundamentals';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Docker İmajları ve Dockerfile',
       'Bir Dockerfile nedir, FROM, WORKDIR, COPY, RUN, EXPOSE talimatları, CMD ile ENTRYPOINT arasındaki fark, ve docker build ile bir image inşa etmek -- jenerik, minimal bir web sunucusu örneği üzerinden.',
       'Docker İmajları ve Dockerfile: FROM, COPY, RUN, CMD, ENTRYPOINT',
       'Bir Dockerfile nasıl yazılır -- FROM, WORKDIR, COPY, RUN, EXPOSE talimatları, CMD vs ENTRYPOINT farkı, ve docker build ile bir image nasıl inşa edilir -- gerçek, minimal bir örnekle anlatılıyor.',
       true
FROM topic
WHERE slug = 'docker-images-and-dockerfiles';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Docker Images and Dockerfiles',
       'What a Dockerfile is, the FROM, WORKDIR, COPY, RUN, EXPOSE instructions, the difference between CMD and ENTRYPOINT, and building an image with docker build -- via a generic, minimal web server example.',
       'Docker Images and Dockerfiles: FROM, COPY, RUN, CMD, ENTRYPOINT',
       'How to write a Dockerfile -- the FROM, WORKDIR, COPY, RUN, EXPOSE instructions, the CMD vs ENTRYPOINT difference, and how to build an image with docker build -- explained with a real, minimal example.',
       false
FROM topic
WHERE slug = 'docker-images-and-dockerfiles';
