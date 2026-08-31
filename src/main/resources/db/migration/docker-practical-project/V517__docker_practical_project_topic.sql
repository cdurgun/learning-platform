-- Docker in Practice kategorisinin 5. (ve son) topic'i:
-- "docker-practical-project". Kategori V505'te zaten oluşturuldu, burada
-- yalnızca yeni bir topic + çevirileri -- working-with-commits'in (V435)
-- BİREBİR aynı deseni. Bu, TÜM Docker kursunun kapanış dersi -- kullanıcının
-- roadmap'indeki 9. ve son topic. React kategorilerinin (Faz 30) ayrı-repo/
-- tag konvansiyonunun BİLİNÇLİ OLARAK DIŞINDA: bu proje config + küçük bir
-- uygulama olduğu için (ayrı bir build/tag yaşam döngüsü gerektiren bir
-- client-side proje değil), gömülü Dockerfile/Compose/.java örnek
-- dosyaları olarak konunun İÇİNDE kalıyor (bkz. plan). Küçük, bağımsız bir
-- "task tracker" Spring Boot + PostgreSQL uygulaması -- bu kursun daha önce
-- hiç işlemediği hiçbir şeyi kullanmıyor, yalnızca hepsini bir araya
-- getiriyor. ADVANCED, 45dk (kategorinin kapanış sentezi), sort_order=5.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'docker-practical-project', 'ADVANCED', 45, 5
FROM category
WHERE slug = 'docker-in-practice';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Pratik Proje: Docker ile Spring Boot + PostgreSQL',
       'Bu kursun her dersinin işlediği her parçayı -- multi-stage Dockerfile, non-root kullanıcı, HEALTHCHECK, Docker Compose, named volume, otomatik networking -- küçük, tam bir Spring Boot + PostgreSQL task tracker uygulamasında bir araya getiren, kursun kapanış dersi.',
       'Pratik Proje: Docker ile Spring Boot + PostgreSQL',
       'Bu kursta öğrenilen her şeyi bir araya getiren, baştan sona doğrulanmış bir Docker Compose projesi -- multi-stage build, non-root kullanıcı, health check, named volume, ve otomatik networking.',
       true
FROM topic
WHERE slug = 'docker-practical-project';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'The Practical Project: Spring Boot + PostgreSQL with Docker',
       'Every piece this course covered -- multi-stage Dockerfile, non-root user, HEALTHCHECK, Docker Compose, named volume, automatic networking -- brought together in one small, complete Spring Boot + PostgreSQL task tracker application. The closing lesson of the course.',
       'Practical Project: Spring Boot + PostgreSQL with Docker',
       'A complete, end-to-end verified Docker Compose project that brings together everything taught in this course -- multi-stage build, non-root user, health check, named volume, and automatic networking.',
       false
FROM topic
WHERE slug = 'docker-practical-project';
