-- Faz 36: "react" course'unun sekizinci kategorisi -- "State Management"
-- (category.sort_order=8, api-data-fetching'ten sonra). ChatGPT planındaki
-- bölüm 8'e karşılık geliyor: Topic 23 — Sharing State, Topic 24 — Context
-- API, Topic 25 — State Management Libraries.
--
-- Topic 25 (İleri seviye: Redux Toolkit, Zustand) BİLİNÇLİ OLARAK ATLANDI --
-- planın kendisi bile bu konuyu "Bunları ayrı ayrı daha sonra ekleyebiliriz"
-- notuyla işaretlemişti; Forms'taki Form Libraries (Faz 33) ve API & Data
-- Fetching'teki TanStack Query (Faz 35) kararlarıyla birebir aynı desen --
-- kullanıcının bu tür "ileri seviye/opsiyonel kütüphane" topic'lerini
-- erteleme tercihi üç kategoridir tutarlı olduğu için bu kez ayrıca
-- AskUserQuestion sorulmadı, doğrudan kararla ilerlendi. Kategori yalnızca
-- iki topic'le: sharing-state, context-api.
--
-- Zorluk seviyesi API & Data Fetching'ten (Faz 35) devam ederek
-- INTERMEDIATE. Sade dil kararı hâlâ geçerli, hiçbir topic'te "## Ek: Mini
-- Proje" yok -- kategori sonunda (context-api'a) react-course-projects'teki
-- sekizinci Pratik Proje eklenecek.
--
-- TR+EN aynı fazda yazıldı; tarihsel tutarlılık için TR published=true,
-- EN published=false olarak ekleniyor.

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'State Management', 'state-management', 8
FROM course
WHERE slug = 'react';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'sharing-state', 'INTERMEDIATE', 5, 1
FROM category
WHERE slug = 'state-management';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'context-api', 'INTERMEDIATE', 5, 2
FROM category
WHERE slug = 'state-management';

-- Topic 1: Sharing State

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Sharing State',
       'Birden fazla component''in aynı state''e ihtiyaç duyduğu durumlar -- state''i yukarı taşımak (lifting state up) ve props drilling sorunu, basit örneklerle.',
       'React''te State Paylaşımı: Lifting State Up ve Props Drilling | Basit Örneklerle Anlatım',
       'React''te birden fazla component''in aynı state''e ihtiyaç duyduğu durumlar, state''i ortak bir ataya taşımak (lifting state up), ve derin bir component ağacında bir prop''u kullanmayan ara katmanlardan geçirmek zorunda kalmanın yarattığı props drilling sorunu -- basit örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'sharing-state';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Sharing State',
       'Situations where more than one component needs the same state -- lifting state up and the props drilling problem, with simple examples.',
       'Sharing State in React: Lifting State Up and Props Drilling | Explained with Simple Examples',
       'Situations in React where more than one component needs the same state, moving state to a common ancestor (lifting state up), and the props drilling problem created by being forced to pass a prop through intermediate layers that don''t use it in a deep component tree -- explained with simple examples.',
       false
FROM topic
WHERE slug = 'sharing-state';

-- Topic 2: Context API

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Context API',
       'React''in props drilling''e yerleşik çözümü Context API -- createContext, useContext, Provider, ve context''i bir custom hook''a sarmalamak, basit örneklerle.',
       'React Context API: createContext, useContext, Provider | Basit Örneklerle Anlatım',
       'React''in Context API''si ile props drilling sorununu çözmek: createContext ile bir context oluşturmak, Provider ile değerini belirlemek, useContext ile okumak, context içinde state taşımak, ve context''i bir custom hook''a sarmalamak -- basit örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'context-api';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Context API',
       'React''s built-in solution to props drilling -- createContext, useContext, Provider, and wrapping context in a custom hook, with simple examples.',
       'React Context API: createContext, useContext, Provider | Explained with Simple Examples',
       'Solving the props drilling problem with React''s Context API: creating a context with createContext, setting its value with a Provider, reading it with useContext, carrying state inside context, and wrapping context in a custom hook -- explained with simple examples.',
       false
FROM topic
WHERE slug = 'context-api';
