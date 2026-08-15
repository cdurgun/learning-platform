-- Faz 39: "react" course'unun on birinci ve SON kategorisi -- "Production"
-- (category.sort_order=11, testing'ten sonra). ChatGPT planındaki son
-- kategoriye karşılık geliyor: Topic 32 — Build & Deployment, Topic 33 —
-- React + Spring Boot Deployment.
--
-- ÖNEMLİ başlangıç kararı: kullanıcı "Vercel'e nasıl deploy edebileceğimizi
-- gösteren bir adım koyabilir miyiz?" diye sordu. Araştırma yapıldı (Vercel'in
-- resmi "Backends on Vercel" dokümantasyonu WebFetch ile çekildi): Vercel'in
-- zero-config backend listesinde (Express, FastAPI, Flask, NestJS, Hono vb.)
-- Java/Spring Boot YOK -- bir Spring Boot uygulaması doğrudan Vercel'de
-- barındırılamıyor. Bu bulgu kullanıcıya sunuldu, birlikte karar verildi:
-- İKİ ayrı topic/pratik proje -- (1) tamamen statik, backend'siz bir React
-- uygulaması → Vercel, (2) React (Vercel) + gerçek bir Spring Boot REST API
-- (Render, Docker) birlikte.
--
-- ÖNEMLİ operasyonel karar: gerçek Vercel/Render deploy'larını yapabilmek
-- için bu hesaplara erişimim yok -- AskUserQuestion ile soruldu, kullanıcı
-- "sen kendi hesabınla deploy et, bana adımları söyle" seçeneğini seçti --
-- yani ben config dosyalarını (render.yaml, Dockerfile, .env.example) ve tam
-- deploy adımlarını hazırladım, kullanıcı kendi Vercel/Render hesabıyla
-- GERÇEKTEN deploy etti, canlı URL'leri paylaştı, ben de WebFetch ile bu
-- URL'leri doğruladım (/api/health → {"status":"ok"}, /api/courses → gerçek
-- JSON, Vercel sayfasının HTML başlığı doğru projeyle eşleşiyor) ve kullanıcı
-- ekran görüntüsüyle CORS'un uçtan uca çalıştığını (React → Render'daki
-- backend'e başarılı fetch) doğruladı.
--
-- ÖNEMLİ sandbox notu: bu fazda sandbox'ta yalnızca Java 11 vardı, JDK 21/
-- Maven kurmak için gereken domainler (download.java.net, api.adoptium.net,
-- release-assets.githubusercontent.com, ports.ubuntu.com) proxy allowlist'i
-- tarafından engellendi -- Spring Boot mini-backend'i (backend/fullstack-
-- deployment) burada GERÇEKTEN derleyemedim. Kod, kursun zaten doğrulanmış
-- CORS/@RestController örneklerine (Advanced Spring MVC'deki
-- GlobalCorsConfigExample) birebir dayanarak dikkatle yazıldı; kullanıcıya
-- deploy öncesi yerel `mvn spring-boot:run` ile denemesi söylendi, ve nihai
-- doğrulama kullanıcının GERÇEK Render deploy'unun başarılı olmasıyla geldi.
--
-- ÖNEMLİ ikinci karar (bu fazın ortasında): react-course-projects'teki git
-- tag kullanımı TERK EDİLDİ -- bkz. CLAUDE.md "Bilinen Kısıtlar" (tag'lerin
-- yalnızca yerel sandbox'ta var olması, kullanıcının push ederken ekstra
-- `--tags` adımına ihtiyaç duyması kafa karıştırıcıydı). Testing'e kadarki
-- (dahil) `## Pratik Proje` linkleri main branch'e çevrildi; Production'dan
-- itibaren zaten hiç tag atılmadı, direkt main branch linkleniyor.
--
-- Zorluk seviyesi INTERMEDIATE (Testing'ten devam). TR+EN aynı fazda
-- yazıldı; TR published=true, EN published=false olarak ekleniyor.

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'Production', 'production', 11
FROM course
WHERE slug = 'react';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'build-deployment', 'INTERMEDIATE', 5, 1
FROM category
WHERE slug = 'production';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'react-spring-boot-deployment', 'INTERMEDIATE', 5, 2
FROM category
WHERE slug = 'production';

-- Topic 1: Build & Deployment

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Build & Deployment',
       'npm run build ile production build almak, Vite''ta ortam değişkenleri (VITE_ öneki, .env), ve tamamen statik bir React uygulamasını Vercel''e deploy etmek -- basit örneklerle.',
       'React''te Build & Deployment: npm run build, Vercel | Basit Örneklerle Anlatım',
       'npm run build ile bir React uygulamasını statik dosyalara (dist/) dönüştürmek, Vite''ta VITE_ önekli ortam değişkenlerini (import.meta.env, .env dosyaları) kullanmak, ortam değişkenleriyle feature flag yazmak, ve bir React/Vite projesini Vercel''e deploy etmek -- basit örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'build-deployment';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Build & Deployment',
       'Making a production build with npm run build, environment variables in Vite (VITE_ prefix, .env), and deploying a fully static React app to Vercel -- with simple examples.',
       'Build & Deployment in React: npm run build, Vercel | Explained with Simple Examples',
       'Turning a React app into static files (dist/) with npm run build, using VITE_-prefixed environment variables in Vite (import.meta.env, .env files), writing feature flags with environment variables, and deploying a React/Vite project to Vercel -- explained with simple examples.',
       false
FROM topic
WHERE slug = 'build-deployment';

-- Topic 2: React + Spring Boot Deployment

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'React + Spring Boot Deployment',
       'React''i Vercel''e, gerçek bir Spring Boot REST API''sini Render''a (Docker) deploy etmek, ortam değişkenleriyle backend adresini yönetmek, ve production CORS yapılandırması -- basit örneklerle.',
       'React + Spring Boot Deployment: Vercel, Render, CORS | Basit Örneklerle Anlatım',
       'React''i Vercel''e, gerçek bir Spring Boot REST API''sini Render''a Docker ile deploy etmek, VITE_API_BASE_URL ile backend adresini ortam değişkeninden okumak, deploy edilmiş bir backend''den fetch ile veri çekmek, addCorsMappings''i bir CORS_ALLOWED_ORIGIN ortam değişkeniyle production''a uyarlamak, ve iki platform arasındaki deploy sırasını (tavuk-yumurta problemi) yönetmek -- basit örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'react-spring-boot-deployment';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'React + Spring Boot Deployment',
       'Deploying React to Vercel, a real Spring Boot REST API to Render (Docker), managing the backend address with environment variables, and production CORS configuration -- with simple examples.',
       'React + Spring Boot Deployment: Vercel, Render, CORS | Explained with Simple Examples',
       'Deploying React to Vercel and a real Spring Boot REST API to Render with Docker, reading the backend address from an environment variable with VITE_API_BASE_URL, fetching data from a deployed backend, adapting addCorsMappings to production with a CORS_ALLOWED_ORIGIN environment variable, and managing the deploy order between two platforms (the chicken-and-egg problem) -- explained with simple examples.',
       false
FROM topic
WHERE slug = 'react-spring-boot-deployment';
