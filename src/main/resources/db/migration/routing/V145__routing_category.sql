-- Faz 34: "react" course'unun altıncı kategorisi -- "Routing" (category.sort_order=6,
-- forms'tan sonra). ChatGPT planındaki Topic 19 — React Router'a karşılık geliyor:
-- Routes, Route parameters, Nested routes, Navigation, Link, NavLink, useNavigate,
-- useParams -- planın önerdiği örnek URL şeması (/courses, /courses/java,
-- /courses/java/enum) kullanıldı.
--
-- Planda tek bir topic olarak listelenen bu konu, 8 kavram içerdiği için (diğer
-- kategorilerdeki topic'lerin genelde 4-5 kavram içermesine kıyasla belirgin
-- şekilde büyüktü) AskUserQuestion ile kullanıcıya soruldu, "2 topic'e böl
-- (Önerilen)" seçildi. İki topic: "React Router Basics" (Routes, Link, NavLink) ve
-- "Route Parameters & Navigation" (route parametreleri, useParams, nested routes,
-- useNavigate).
--
-- ÖNEMLİ paket kararı: react-router-dom yerine react-router v8 kullanıldı.
-- Temmuz 2026'da yayınlanan react-router@8, react-router-dom'u ORTADAN
-- KALDIRDI -- BrowserRouter, Routes, Route, Link, NavLink, useParams,
-- useNavigate, Outlet gibi tüm web bileşenleri artık doğrudan "react-router"
-- paketinden export ediliyor (React >=19.2.7 peer dependency'si gerektiriyor).
-- Bu karar, npm registry'den doğrudan (npm install react-router@8.3.0) paket
-- indirilip installed package.json + .d.ts dosyaları incelenerek VE gerçek bir
-- Vite build'i (BrowserRouter/Routes/Route/Link/NavLink/useParams/useNavigate/
-- Outlet kullanan bir örnek app ile) çalıştırılarak doğrulandı -- eski
-- react-router-dom hâlâ npm'de mevcut (7.18.2) ama yeni içerik için artık
-- güncel olmayan bir yol.
--
-- Zorluk seviyesi Forms'tan (Faz 33) devam ederek INTERMEDIATE. Sade dil
-- kararı hâlâ geçerli, hiçbir topic'te "## Ek: Mini Proje" yok -- kategori
-- sonunda (route-parameters-navigation'a) react-course-projects'teki altıncı
-- Pratik Proje eklenecek.
--
-- TR+EN aynı fazda yazıldı; tarihsel tutarlılık için TR published=true,
-- EN published=false olarak ekleniyor.

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'Routing', 'routing', 6
FROM course
WHERE slug = 'react';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'react-router-basics', 'INTERMEDIATE', 5, 1
FROM category
WHERE slug = 'routing';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'route-parameters-navigation', 'INTERMEDIATE', 5, 2
FROM category
WHERE slug = 'routing';

-- Topic 1: React Router Basics

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'React Router Basics',
       'react-router ile bir React uygulamasına sayfa geçişi eklemek -- BrowserRouter, Routes, Route, Link, NavLink ve tanımsız URL''ler için Not Found sayfası, basit örneklerle.',
       'React Router Basics: BrowserRouter, Routes, Route, Link | Basit Örneklerle Anlatım',
       'React uygulamalarında sayfa geçişi (routing) nasıl yapılır: BrowserRouter ile uygulamayı sarmalamak, Routes ve Route ile URL''e göre component göstermek, Link ve NavLink ile sayfalar arası geçiş yapmak, ve tanımsız URL''ler için Not Found sayfası tanımlamak -- basit örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'react-router-basics';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'React Router Basics',
       'Adding page navigation to a React app with react-router -- BrowserRouter, Routes, Route, Link, NavLink, and a Not Found page for undefined URLs, with simple examples.',
       'React Router Basics: BrowserRouter, Routes, Route, Link | Explained with Simple Examples',
       'How to add page navigation (routing) to a React application: wrapping the app with BrowserRouter, showing components based on the URL with Routes and Route, moving between pages with Link and NavLink, and defining a Not Found page for undefined URLs -- explained with simple examples.',
       false
FROM topic
WHERE slug = 'react-router-basics';

-- Topic 2: Route Parameters & Navigation

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Route Parameters & Navigation',
       'URL''in içine değişken değerler koymak (route parametreleri), useParams ile okumak, Outlet ile iç içe route''lar kurmak, ve useNavigate ile programatik yönlendirme -- basit örneklerle.',
       'Route Parametreleri ve Navigation: useParams, useNavigate, Outlet | Basit Örneklerle Anlatım',
       'React Router''da route parametreleri ile URL''in içine değişken değer koymak, useParams ile bu değeri okumak, Outlet ile iç içe (nested) route''lar kurmak, ve useNavigate ile bir link''e tıklamadan programatik olarak sayfa değiştirmek -- basit örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'route-parameters-navigation';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Route Parameters & Navigation',
       'Putting variable values inside a URL (route parameters), reading them with useParams, building nested routes with Outlet, and programmatic navigation with useNavigate -- with simple examples.',
       'Route Parameters and Navigation: useParams, useNavigate, Outlet | Explained with Simple Examples',
       'In React Router, putting a variable value inside a URL with route parameters, reading that value with useParams, building nested routes with Outlet, and changing pages programmatically without a link click using useNavigate -- explained with simple examples.',
       false
FROM topic
WHERE slug = 'route-parameters-navigation';
