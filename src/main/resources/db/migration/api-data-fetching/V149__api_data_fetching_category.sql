-- Faz 35: "react" course'unun yedinci kategorisi -- "API & Data Fetching"
-- (category.sort_order=7, routing'den sonra). ChatGPT planındaki bölüm 7'ye
-- karşılık geliyor: Topic 20 — Fetching Data, Topic 21 — React + REST API,
-- Topic 22 — API Data Management (TanStack Query).
--
-- Topic 22 (TanStack Query: caching, refetching, mutations) AskUserQuestion
-- ile soruldu, kullanıcı "Şimdilik bırak (2 topic)" seçti -- Forms'taki Form
-- Libraries kararına benzer şekilde, yeni bir npm bağımlılığı gerektiren bu
-- konu şimdilik ertelendi. Kategori yalnızca iki topic'le: fetching-data,
-- react-rest-api.
--
-- ÖNEMLİ backend kararı: Topic 21'in "React → HTTP → Spring Boot →
-- PostgreSQL" şeması, kullanıcıya AskUserQuestion ile soruldu -- üç seçenek
-- sunuldu: (1) json-server ile sahte API, (2) learning-platform'un kendi
-- Spring Boot'una gerçek REST endpoint eklemek, (3) public bir test API
-- (JSONPlaceholder). Kullanıcı "json-server ile sahte API (Önerilen)" seçti
-- -- gerçek üretim Java koduna dokunulmadı, React tarafındaki kod (fetch,
-- api.js modülü) gerçek bir Spring Boot backend'ine bağlanırken de birebir
-- aynı olacak şekilde yazıldı. json-server@1.0.0-beta.15'in gerçek CLI
-- davranışı ve GET/POST/PUT/DELETE + CORS semantiği, bir sunucu başlatılıp
-- curl ile doğrulandı (bkz. "Bilinen Kısıtlar") -- v1 beta'nın CLI'ı eski
-- v0.17'den farklı (--watch flag'i yok, dosya değişikliklerini otomatik
-- izliyor).
--
-- Zorluk seviyesi Routing'ten (Faz 34) devam ederek INTERMEDIATE. Sade dil
-- kararı hâlâ geçerli, hiçbir topic'te "## Ek: Mini Proje" yok -- kategori
-- sonunda (react-rest-api'a) react-course-projects'teki yedinci Pratik
-- Proje eklenecek.
--
-- TR+EN aynı fazda yazıldı; tarihsel tutarlılık için TR published=true,
-- EN published=false olarak ekleniyor.

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'API & Data Fetching', 'api-data-fetching', 7
FROM course
WHERE slug = 'react';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'fetching-data', 'INTERMEDIATE', 5, 1
FROM category
WHERE slug = 'api-data-fetching';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'react-rest-api', 'INTERMEDIATE', 5, 2
FROM category
WHERE slug = 'api-data-fetching';

-- Topic 1: Fetching Data

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Fetching Data',
       'React''te fetch ile bir sunucudan veri çekmek ve göndermek -- GET, POST, PUT, DELETE, loading ve error handling, basit örneklerle.',
       'React''te fetch ile Veri Çekmek: GET, POST, PUT, DELETE | Basit Örneklerle Anlatım',
       'React''te fetch fonksiyonuyla bir sunucudan veri çekmek (GET) ve göndermek (POST, PUT, DELETE), useEffect ile isteği component ekrana geldiğinde tetiklemek, loading durumunu göstermek, ve hataları yönetmek -- basit örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'fetching-data';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Fetching Data',
       'Fetching and sending data to a server in React with fetch -- GET, POST, PUT, DELETE, loading and error handling, with simple examples.',
       'Fetching Data in React with fetch: GET, POST, PUT, DELETE | Explained with Simple Examples',
       'Fetching data from a server (GET) and sending data to it (POST, PUT, DELETE) with the fetch function in React, triggering the request with useEffect when the component appears on screen, showing a loading state, and handling errors -- explained with simple examples.',
       false
FROM topic
WHERE slug = 'fetching-data';

-- Topic 2: React + REST API

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'React + REST API',
       'React''in bir REST API''ye bağlanması -- API katmanını bir api.js modülünde ayırmak, listeleme, oluşturma ve silme işlemlerini birlikte yönetmek, basit örneklerle.',
       'React ile REST API Kullanımı: api.js Modülü, CRUD | Basit Örneklerle Anlatım',
       'React''in bir REST API''ye (Spring Boot gibi bir backend''e) nasıl bağlandığı, fetch çağrılarını bir api.js modülünde toplamak, bir kaynağı listeleme/oluşturma/silme işlemlerini birlikte yönetmek, ve her mutasyondan sonra ekranı immutability kurallarına uyarak güncellemek -- basit örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'react-rest-api';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'React + REST API',
       'Connecting React to a REST API -- separating the API layer into an api.js module, managing listing, creating, and deleting together, with simple examples.',
       'Using React with a REST API: api.js Module, CRUD | Explained with Simple Examples',
       'How React connects to a REST API (a backend like Spring Boot), gathering fetch calls in an api.js module, managing listing/creating/deleting a resource together, and updating the screen after every mutation following immutability rules -- explained with simple examples.',
       false
FROM topic
WHERE slug = 'react-rest-api';
