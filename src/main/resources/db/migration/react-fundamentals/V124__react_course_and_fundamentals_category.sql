-- Faz 28: java ve spring-boot'tan sonra üçüncü Course -- "React" (course.slug = 'react').
-- Course tablosunda sort_order yok (bkz. CLAUDE.md "Bilinen Kısıtlar"); NavigationService
-- kursları courseRepository.findAll()'ın döndürdüğü (pratikte insert/id) sırayla listeliyor
-- -- bu yüzden React otomatik olarak üçüncü sırada görünecek, ek bir kod değişikliği
-- gerekmiyor.
--
-- İlk kategori "React Fundamentals" (category.sort_order=1): React nedir, bir React
-- projesi nasıl kurulur, JSX nedir -- üç saf giriş konusu. Kullanıcı kararıyla bu kurs
-- BAŞTAN İTİBAREN sade bir dille, mümkün olduğunca kolay örneklerle anlatılıyor --
-- Java/Spring derslerindeki yoğun, çok referanslı üslup burada BİLİNÇLİ OLARAK
-- kullanılmıyor. Aynı sebeple bu üç konu "## Ek: Mini Proje" eklerini içermiyor --
-- henüz kod yazmaya başlamadığımız (Topic 1-2) ya da yeni başladığımız (Topic 3, JSX)
-- bu aşamada zorlama bir mini proje eklemek yerine, gerçek mini projeleri kod yazmaya
-- asıl başladığımız "Components & Props" kategorisine bıraktık.
--
-- Üç topic de BEGINNER işaretlendi -- kursun ilk kategorisi, henüz zorluk atlayacak bir
-- şey yok. Üçü de aynı fazda TR+EN olarak yazıldı (kullanıcı kararıyla, Faz 21'den beri
-- süregelen ritim); yine de tarihsel tutarlılık için TR published=true, EN
-- published=false olarak ekleniyor, ayrı bir "publish_..._english" migration'ıyla hemen
-- ardından yayına alınıyor.
--
-- examples/jsx/*.jsx dosyaları, Faz 27'de genelleştirilen {{Ad.ext}} embed sistemini
-- kullanan İLK .java-olmayan örnekler -- Node + @babel/preset-react ile syntax
-- doğrulandı (bu ortamda mvn/javac olmadığı gibi gerçek bir JSX derleyicisi de yok,
-- ama Babel'le en azından syntax-check mümkün, Java'da hiç sahip olmadığımız bir imkan).

INSERT INTO course (name, slug)
VALUES ('React', 'react');

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'React Fundamentals', 'react-fundamentals', 1
FROM course
WHERE slug = 'react';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'what-is-react', 'BEGINNER', 5, 1
FROM category
WHERE slug = 'react-fundamentals';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'creating-a-react-application', 'BEGINNER', 5, 2
FROM category
WHERE slug = 'react-fundamentals';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'jsx', 'BEGINNER', 5, 3
FROM category
WHERE slug = 'react-fundamentals';

-- Topic 1: What Is React?

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'React Nedir?',
       'React''in ne olduğu, neden ortaya çıktığı, library ile framework arasındaki fark, SPA kavramı ve React''in nerede kullanıldığı -- sade bir dille, hiç kod yazmadan.',
       'React Nedir? | Başlangıç Seviyesi Giriş',
       'React nedir, neden kullanılır, bir library mi framework mü, SPA (Single Page Application) ne demek ve React nerelerde kullanılır -- yeni başlayanlar için sade bir dille anlatılıyor.',
       true
FROM topic
WHERE slug = 'what-is-react';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'What Is React?',
       'What React is, why it exists, the difference between a library and a framework, what an SPA is, and where React is used -- in plain language, with no code yet.',
       'What Is React? | A Beginner-Friendly Introduction',
       'What React is, why it exists, whether it''s a library or a framework, what an SPA (Single Page Application) means, and where React is used -- explained in plain language for beginners.',
       false
FROM topic
WHERE slug = 'what-is-react';

-- Topic 2: Creating a React Application

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Bir React Projesi Oluşturmak',
       'Node.js ve npm, Vite ile yeni bir proje oluşturma, proje yapısı, package.json, npm run dev ve development ile production farkı.',
       'React Projesi Nasıl Oluşturulur? | Vite ile Adım Adım',
       'Node.js ve npm nedir, Vite ile yeni bir React projesi nasıl oluşturulur, proje yapısı ve package.json nasıl okunur, npm run dev ile uygulama nasıl çalıştırılır, development ile production arasındaki fark nedir -- adım adım anlatılıyor.',
       true
FROM topic
WHERE slug = 'creating-a-react-application';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Creating a React Application',
       'Node.js and npm, creating a new project with Vite, project structure, package.json, npm run dev, and the difference between development and production.',
       'How to Create a React Application | A Step-by-Step Guide with Vite',
       'What Node.js and npm are, how to create a new React project with Vite, how to read the project structure and package.json, how to run the app with npm run dev, and the difference between development and production -- explained step by step.',
       false
FROM topic
WHERE slug = 'creating-a-react-application';

-- Topic 3: JSX

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'JSX',
       'JSX nedir, HTML ile farkları, süslü parantez { } ile JavaScript gömme, attribute''lar ve className, JSX kuralları ve conditional rendering''e kısa bir bakış.',
       'JSX Nedir? | Basit Örneklerle React Söz Dizimi',
       'JSX nedir, HTML''den farkları, süslü parantez { } ile JSX içine JavaScript gömme, className ve attribute''lar, tek kök element kuralı, Fragment ve conditional rendering''e kısa bir giriş -- kolay, basit örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'jsx';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'JSX',
       'What JSX is, how it differs from HTML, embedding JavaScript with curly braces { }, attributes and className, JSX rules, and a quick look at conditional rendering.',
       'What Is JSX? | React Syntax Explained with Simple Examples',
       'What JSX is, how it differs from HTML, embedding JavaScript inside JSX with curly braces { }, className and attributes, the single root element rule, Fragments, and a quick introduction to conditional rendering -- explained with easy, simple examples.',
       false
FROM topic
WHERE slug = 'jsx';
