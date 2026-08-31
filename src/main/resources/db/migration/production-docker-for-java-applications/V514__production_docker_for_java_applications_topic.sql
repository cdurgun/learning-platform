-- Docker in Practice kategorisinin 4. topic'i:
-- "production-docker-for-java-applications". Kategori V505'te zaten
-- oluşturuldu, burada yalnızca yeni bir topic + çevirileri --
-- working-with-commits'in (V435) BİREBİR aynı deseni. Odak: layer caching
-- (bağımlılık indirmelerini kaynak koddan ayrı önbelleğe almak), root
-- olmayan kullanıcı, Dockerfile HEALTHCHECK, Compose'un
-- depends_on: condition: service_healthy'siyle "Docker Compose"un (V511)
-- bilinçli açık bıraktığı depends_on boşluğunu kapatmak, ve bu projenin
-- kendi application-prod.yml'ine dayanan production konfigürasyonu.
-- ADVANCED (kategorinin en yoğun sentez konusu, önceki 3 topic'in üzerine
-- inşa ediyor), 40dk, sort_order=4.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'production-docker-for-java-applications', 'ADVANCED', 40, 4
FROM category
WHERE slug = 'docker-in-practice';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Production İçin Docker (Java Uygulamaları)',
       'Layer caching ile daha hızlı rebuild''ler, root olmayan bir kullanıcı, Dockerfile HEALTHCHECK, Compose''un depends_on: condition: service_healthy''siyle gerçek bağımlılık hazırlığını beklemek, ve production konfigürasyonu/sırlar.',
       'Production İçin Docker: Layer Caching, Non-Root, Health Check',
       'Bir Docker image''ını production''a hazır hale getirmek -- layer caching, root olmayan kullanıcı, HEALTHCHECK, Compose sağlık koşulları, ve sır yönetimi -- bu projenin kendi kurulumu üzerinden anlatılıyor.',
       true
FROM topic
WHERE slug = 'production-docker-for-java-applications';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Production Docker for Java Applications',
       'Faster rebuilds with layer caching, a non-root user, a Dockerfile HEALTHCHECK, waiting for real dependency readiness with Compose''s depends_on: condition: service_healthy, and production configuration/secrets.',
       'Production Docker for Java Applications: Layer Caching, Non-Root, Health Checks',
       'How to make a Docker image production-ready -- layer caching, a non-root user, HEALTHCHECK, Compose health conditions, and secrets management -- explained via this project''s own setup.',
       false
FROM topic
WHERE slug = 'production-docker-for-java-applications';
