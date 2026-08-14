-- Faz 37: "react" course'unun dokuzuncu kategorisi -- "Advanced React"
-- (category.sort_order=9, state-management'ten sonra). ChatGPT planındaki
-- bölüm 9'a karşılık geliyor: Topic 26 — React Performance, Topic 27 —
-- Error Boundaries, Topic 28 — Lazy Loading & Code Splitting, Topic 29 —
-- Suspense, Topic 30 — Portals. Önceki üç kategorinin (Forms, API & Data
-- Fetching, State Management) aksine, plan bu beş topic'ten HİÇBİRİNİ
-- "sonraya bırakılabilir" notuyla işaretlememişti -- hepsi olduğu gibi
-- alındı (Hooks kategorisiyle aynı büyüklükte: 5 topic).
--
-- ÖNEMLİ zorluk kararı: kategori adının kendisi "Advanced React" olduğu ve
-- içerik gerçekten daha karmaşık olduğu için (kursun İLK class component'i
-- -- error boundary'ler hook'larla yazılamıyor --, React.lazy + dynamic
-- import(), Suspense, Portal'lar), zorluk seviyesi INTERMEDIATE'den
-- ADVANCED'a yükseltildi. Bu, Java kursunda "Advanced Spring MVC"
-- kategorisinin de aynı isim-bazlı gerekçeyle ADVANCED olmasıyla tutarlı.
-- AskUserQuestion sorulmadı -- kategori isminin kendisi ve içeriğin
-- karmaşıklığı yeterince açık bir sinyaldi.
--
-- ÖNEMLİ araştırma notu: Error Boundaries dersini yazmadan önce, "React
-- 19'da useErrorBoundary diye bir hook eklendi mi?" sorusu WebSearch'te
-- karşımıza çıktı (bir GitHub demo reposunun başlığından kaynaklanan
-- YANLIŞ bir iddia) -- gerçek react@19.2.8 paketi npm'den indirilip
-- react.development.js'teki TÜM `exports.use*` satırları grep'lenerek
-- doğrulandı: böyle bir hook YOK, error boundary'ler hâlâ yalnızca class
-- component + `static getDerivedStateFromError` ile yazılabiliyor. Aynı
-- doğrulamada `use`, `Profiler`, `Suspense`, `lazy`, `Component` (react'te)
-- ve `createPortal` (react-dom'da) gerçek export'lar olarak teyit edildi.
--
-- Zorluk seviyesi ADVANCED. Sade dil kararı hâlâ geçerli, hiçbir topic'te
-- "## Ek: Mini Proje" yok -- kategori sonunda (portals'a)
-- react-course-projects'teki dokuzuncu Pratik Proje eklenecek.
--
-- TR+EN aynı fazda yazıldı; tarihsel tutarlılık için TR published=true,
-- EN published=false olarak ekleniyor.

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'Advanced React', 'advanced-react', 9
FROM course
WHERE slug = 'react';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'react-performance', 'ADVANCED', 5, 1
FROM category
WHERE slug = 'advanced-react';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'error-boundaries', 'ADVANCED', 5, 2
FROM category
WHERE slug = 'advanced-react';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'lazy-loading-code-splitting', 'ADVANCED', 5, 3
FROM category
WHERE slug = 'advanced-react';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'suspense', 'ADVANCED', 5, 4
FROM category
WHERE slug = 'advanced-react';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'portals', 'ADVANCED', 5, 5
FROM category
WHERE slug = 'advanced-react';

-- Topic 1: React Performance

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'React Performance',
       'React.memo, useMemo ve useCallback ile gereksiz yeniden render''ları önlemek, ve React''in Profiler component''i ile render sürelerini ölçmek -- basit örneklerle.',
       'React Performance: React.memo, useMemo, useCallback | Basit Örneklerle Anlatım',
       'React''te gereksiz yeniden render''ların nasıl oluştuğu, React.memo ile bunları önlemek, memo''yu fonksiyon prop''larıyla useCallback ile birlikte kullanmak, useMemo ile pahalı hesaplamaları önbelleklemek, ve React''in Profiler component''i ile render sürelerini ölçmek -- basit örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'react-performance';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'React Performance',
       'Preventing unnecessary re-renders with React.memo, useMemo, and useCallback, and measuring render times with React''s Profiler component -- with simple examples.',
       'React Performance: React.memo, useMemo, useCallback | Explained with Simple Examples',
       'How unnecessary re-renders happen in React, preventing them with React.memo, using memo together with useCallback for function props, caching expensive calculations with useMemo, and measuring render times with React''s Profiler component -- explained with simple examples.',
       false
FROM topic
WHERE slug = 'react-performance';

-- Topic 2: Error Boundaries

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Error Boundaries',
       'React''te render sırasındaki hataları yakalayan class component''ler: getDerivedStateFromError, componentDidCatch, error boundary''lerin kapsamı ve yakalamadıkları, basit örneklerle.',
       'React''te Error Boundaries: getDerivedStateFromError, componentDidCatch | Basit Örneklerle Anlatım',
       'React''te render sırasında fırlatılan hataları yakalayan class component''ler olan error boundary''ler: getDerivedStateFromError ile fallback UI göstermek, componentDidCatch ile hatayı loglamak, birden fazla küçük boundary kullanmanın faydası, ve error boundary''lerin yakalamadığı hata türleri -- basit örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'error-boundaries';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Error Boundaries',
       'Class components that catch errors during rendering in React: getDerivedStateFromError, componentDidCatch, the scope of error boundaries, and what they don''t catch, with simple examples.',
       'Error Boundaries in React: getDerivedStateFromError, componentDidCatch | Explained with Simple Examples',
       'Error boundaries -- class components that catch errors thrown during rendering in React: showing a fallback UI with getDerivedStateFromError, logging the error with componentDidCatch, the benefit of using multiple small boundaries, and the kinds of errors error boundaries don''t catch -- explained with simple examples.',
       false
FROM topic
WHERE slug = 'error-boundaries';

-- Topic 3: Lazy Loading & Code Splitting

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Lazy Loading & Code Splitting',
       'React.lazy ile component''leri sonradan yüklemek, route bazlı code splitting, named export''larla lazy kullanmak, ve koşullu lazy loading -- basit örneklerle.',
       'React Lazy Loading & Code Splitting: React.lazy, Suspense | Basit Örneklerle Anlatım',
       'React.lazy ile bir component''in kodunu ayrı bir dosyaya bölüp yalnızca gerektiğinde yüklemek, Routing dersindeki sayfaları route bazlı code splitting ile bölmek, named export''lu component''lerle lazy kullanmak, ve nadiren kullanılan component''leri koşullu olarak lazy yüklemek -- basit örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'lazy-loading-code-splitting';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Lazy Loading & Code Splitting',
       'Loading components later with React.lazy, route-based code splitting, using lazy with named exports, and conditional lazy loading -- with simple examples.',
       'React Lazy Loading & Code Splitting: React.lazy, Suspense | Explained with Simple Examples',
       'Splitting a component''s code into a separate file and loading it only when needed with React.lazy, splitting the pages from the Routing lesson with route-based code splitting, using lazy with named-export components, and conditionally lazy-loading rarely-used components -- explained with simple examples.',
       false
FROM topic
WHERE slug = 'lazy-loading-code-splitting';

-- Topic 4: Suspense

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Suspense',
       'Suspense''in fallback prop''u, iç içe Suspense sınırları, React 19''un use() hook''u ile Suspense entegrasyonu, ve Suspense''in otomatik yapmadıkları -- basit örneklerle.',
       'React Suspense: fallback, İç İçe Suspense, use() Hook''u | Basit Örneklerle Anlatım',
       'React''in Suspense component''i: fallback prop''uyla yükleme durumu göstermek, iç içe Suspense sınırlarıyla granüler yükleme durumları, React 19''un use() hook''uyla bir Promise''i Suspense''e entegre etmek, ve useEffect+fetch gibi desenlerin Suspense''i neden otomatik tetiklemediği -- basit örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'suspense';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Suspense',
       'Suspense''s fallback prop, nested Suspense boundaries, integrating Suspense with React 19''s use() hook, and what Suspense doesn''t do automatically -- with simple examples.',
       'React Suspense: fallback, Nested Suspense, the use() Hook | Explained with Simple Examples',
       'React''s Suspense component: showing a loading state with the fallback prop, granular loading states with nested Suspense boundaries, integrating a Promise with Suspense using React 19''s use() hook, and why patterns like useEffect+fetch don''t trigger Suspense automatically -- explained with simple examples.',
       false
FROM topic
WHERE slug = 'suspense';

-- Topic 5: Portals

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Portals',
       'react-dom''un createPortal fonksiyonu ile component''leri farklı bir DOM düğümüne render etmek -- modal''lar, event bubbling davranışı, ve portal hedefi ayarlamak, basit örneklerle.',
       'React Portals: createPortal, Modal''lar, Event Bubbling | Basit Örneklerle Anlatım',
       'react-dom''un createPortal fonksiyonuyla bir component''i React ağacındaki konumundan farklı bir DOM düğümüne render etmek, modal''lar için portal kullanmak, portal''larda event''lerin gerçek DOM''a değil React''in component ağacına göre bubble etmesi, ve bir portal hedefi ayarlamak -- basit örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'portals';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Portals',
       'Rendering components to a different DOM node with react-dom''s createPortal -- modals, event bubbling behavior, and setting up a portal target, with simple examples.',
       'React Portals: createPortal, Modals, Event Bubbling | Explained with Simple Examples',
       'Rendering a component to a different DOM node than its position in the React tree with react-dom''s createPortal function, using portals for modals, how events bubble according to React''s component tree rather than the real DOM in portals, and setting up a portal target -- explained with simple examples.',
       false
FROM topic
WHERE slug = 'portals';
