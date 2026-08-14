-- Faz 31: "react" course'unun üçüncü kategorisi -- "State & Events"
-- (category.sort_order=3, components-props'tan sonra). Kullanıcının kendi
-- sözleriyle "React'in en önemli bölümü" -- dört topic: Events, State,
-- Conditional Rendering, Lists & Keys -- ChatGPT planındaki orijinal
-- Topic 7-8-9-10'a karşılık geliyor.
--
-- Kavram sırası kasıtlı: Events, State'ten ÖNCE geliyor -- events.md'deki
-- örnekler yalnızca console.log kullanıyor, useState yok. state.md ilk kez
-- gerçek useState örneği içeriyor. conditional-rendering.md, jsx.md'deki kısa
-- ternary önizlemesini derinleştiriyor. lists-and-keys.md, React Fundamentals'ta
-- bilinçli olarak kullanılmayan map()/liste render'ını ilk kez işliyor.
--
-- Sade dil kararı (Faz 28) hâlâ geçerli, hiçbir topic'te "## Ek: Mini Proje"
-- yok -- kategori sonunda (lists-and-keys'e) react-course-projects'teki üçüncü
-- Pratik Proje eklenecek (bkz. Faz 30'daki kalıcı kural).
--
-- Dört topic de BEGINNER işaretlendi. TR+EN aynı fazda yazıldı; tarihsel
-- tutarlılık için TR published=true, EN published=false olarak ekleniyor.

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'State & Events', 'state-events', 3
FROM course
WHERE slug = 'react';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'events', 'BEGINNER', 5, 1
FROM category
WHERE slug = 'state-events';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'state', 'BEGINNER', 5, 2
FROM category
WHERE slug = 'state-events';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'conditional-rendering', 'BEGINNER', 5, 3
FROM category
WHERE slug = 'state-events';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'lists-and-keys', 'BEGINNER', 5, 4
FROM category
WHERE slug = 'state-events';

-- Topic 1: Events

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Events',
       'React''te olay (event) sistemi -- onClick, event handler tanımlamak, onChange, onSubmit ve event object -- basit örneklerle.',
       'React''te Events (Olaylar) Nedir? | Basit Örneklerle Anlatım',
       'React''te onClick ile tıklama olaylarını yakalamak, event handler fonksiyonu tanımlamak, onChange ile input değişikliklerini izlemek, onSubmit ile form gönderimini yakalamak ve event object -- yeni başlayanlar için sade bir dille anlatılıyor.',
       true
FROM topic
WHERE slug = 'events';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Events',
       'React''s event system -- onClick, defining event handlers, onChange, onSubmit, and the event object -- with simple examples.',
       'What Are Events in React? | Explained with Simple Examples',
       'Catching clicks with onClick, defining an event handler function, tracking input changes with onChange, catching form submission with onSubmit, and the event object in React -- explained in plain language for beginners.',
       false
FROM topic
WHERE slug = 'events';

-- Topic 2: State

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'State',
       'State nedir, useState ile nasıl tanımlanır, nasıl güncellenir, bir önceki state''e göre güncelleme ve state immutability -- basit örneklerle.',
       'React''te State Nedir? | useState ile Basit Örnekler',
       'React''te state nedir, useState ile bir state nasıl tanımlanır, nasıl güncellenir, bir önceki state''e göre güncelleme neden fonksiyon formuyla yapılır, state ile normal bir değişken arasındaki fark ve state immutability -- basit örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'state';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'State',
       'What state is, how to define it with useState, how to update it, updating based on the previous state, and state immutability -- with simple examples.',
       'What Is State in React? | Simple Examples with useState',
       'What state is in React, how to define state with useState, how to update it, why updating based on the previous state uses the function form, the difference between state and a regular variable, and state immutability -- explained with simple examples.',
       false
FROM topic
WHERE slug = 'state';

-- Topic 3: Conditional Rendering

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Conditional Rendering',
       'if, ternary (? :) ve && operatörü ile koşula göre farklı arayüz göstermek, ve koşula göre farklı component''ler döndürmek -- basit örneklerle.',
       'React''te Conditional Rendering Nedir? | Basit Örneklerle Anlatım',
       'React''te if ile, ternary (? :) ile ve && operatörü ile koşula göre farklı içerik göstermek, aralarındaki fark, yaygın && hatası, ve koşula göre tamamen farklı component''ler döndürmek -- basit örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'conditional-rendering';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Conditional Rendering',
       'Showing different UI based on a condition with if, a ternary (? :), and the && operator, and returning different components based on a condition -- with simple examples.',
       'What Is Conditional Rendering in React? | Explained with Simple Examples',
       'Showing different content based on a condition with if, with a ternary (? :), and with the && operator in React, the difference between them, a common && mistake, and returning entirely different components based on a condition -- explained with simple examples.',
       false
FROM topic
WHERE slug = 'conditional-rendering';

-- Topic 4: Lists & Keys

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Lists & Keys',
       'map() ile liste render etmek, key prop''u nedir, neden önemlidir, ve en yaygın hata olan index''i key olarak kullanmak -- basit örneklerle.',
       'React''te Lists & Keys Nedir? | Basit Örneklerle Anlatım',
       'React''te map() ile bir diziyi ekrana render etmek, key prop''unun ne olduğu, React''in liste elemanlarını takip etmesi için neden önemli olduğu, ve index''i key olarak kullanmanın neden yaygın bir hata olduğu -- basit örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'lists-and-keys';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Lists & Keys',
       'Rendering a list with map(), what the key prop is, why it matters, and the most common mistake -- using the index as the key -- with simple examples.',
       'What Are Lists & Keys in React? | Explained with Simple Examples',
       'Rendering an array on screen with map() in React, what the key prop is, why it matters for React to track list items, and why using the index as the key is a common mistake -- explained with simple examples.',
       false
FROM topic
WHERE slug = 'lists-and-keys';
