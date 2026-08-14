-- Faz 32: "react" course'unun dördüncü kategorisi -- "Hooks" (category.sort_order=4,
-- state-events'ten sonra). ChatGPT'nin kendi planında "bunu ayrı bir kategori
-- yapardım" dediği kısım -- beş topic: What Are Hooks?, useEffect, useRef,
-- useMemo & useCallback, Custom Hooks -- ChatGPT planındaki orijinal
-- Topic 11-12-13-14-15'e karşılık geliyor.
--
-- Kullanıcı onayıyla, bu kategoriden itibaren zorluk seviyesi INTERMEDIATE'e
-- çekildi -- React Fundamentals/Components & Props/State & Events hep BEGINNER'dı,
-- ama hooks (dependency array, cleanup, memoization) bir seviye daha karmaşık.
-- Sade dil kuralı yine geçerli, yalnızca zorluk rozeti değişti.
--
-- Kavram sırası kasıtlı: what-are-hooks.md, State & Events'te zaten kullandığımız
-- useState'i "hook" olarak yeniden çerçeveliyor; use-effect.md ilk kez side effect
-- kavramını işliyor; use-ref.md useEffect ile birlikte kullanılan bir örnek de
-- içeriyor; use-memo-use-callback.md performans hook'larını VE ne zaman
-- kullanılmaması gerektiğini anlatıyor; custom-hooks.md, ChatGPT'nin önerdiği
-- useFetch örneğini basitleştirilmiş haliyle kullanıyor (gerçek hata yönetimi
-- ileride "API & Data Fetching" kategorisinde).
--
-- Sade dil kararı hâlâ geçerli, hiçbir topic'te "## Ek: Mini Proje" yok --
-- kategori sonunda (custom-hooks'a) react-course-projects'teki dördüncü
-- Pratik Proje eklenecek.
--
-- TR+EN aynı fazda yazıldı; tarihsel tutarlılık için TR published=true,
-- EN published=false olarak ekleniyor.

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'Hooks', 'hooks', 4
FROM course
WHERE slug = 'react';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'what-are-hooks', 'INTERMEDIATE', 5, 1
FROM category
WHERE slug = 'hooks';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'use-effect', 'INTERMEDIATE', 5, 2
FROM category
WHERE slug = 'hooks';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'use-ref', 'INTERMEDIATE', 5, 3
FROM category
WHERE slug = 'hooks';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'use-memo-use-callback', 'INTERMEDIATE', 5, 4
FROM category
WHERE slug = 'hooks';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'custom-hooks', 'INTERMEDIATE', 5, 5
FROM category
WHERE slug = 'hooks';

-- Topic 1: What Are Hooks?

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'What Are Hooks?',
       'Hook nedir, neden var, Hooks kuralları (Rules of Hooks) ve function component''lerle ilişkisi -- basit örneklerle.',
       'React''te Hooks Nedir? | Basit Örneklerle Anlatım',
       'React''te bir hook''un ne olduğu, hook''ların neden var olduğu, Hooks kurallarının (Rules of Hooks) neyi yasakladığı ve neden, ve hook''ların yalnızca function component''lerde neden çalıştığı -- basit örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'what-are-hooks';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'What Are Hooks?',
       'What a hook is, why hooks exist, the Rules of Hooks, and their relationship to function components -- with simple examples.',
       'What Are Hooks in React? | Explained with Simple Examples',
       'What a hook is in React, why hooks exist, what the Rules of Hooks forbid and why, and why hooks only work in function components -- explained with simple examples.',
       false
FROM topic
WHERE slug = 'what-are-hooks';

-- Topic 2: useEffect

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'useEffect',
       'Side effect nedir, useEffect ile nasıl çalıştırılır, dependency array''in üç kullanımı, cleanup fonksiyonu ve yaygın infinite loop hatası -- basit örneklerle.',
       'React''te useEffect Nedir? | Basit Örneklerle Anlatım',
       'React''te useEffect ile side effect çalıştırmak, dependency array''i boş dizi ya da belirli değerlerle kullanmak, cleanup fonksiyonu ile temizlik yapmak, ve dependency array''i unutmanın yol açtığı infinite loop hatası -- basit örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'use-effect';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'useEffect',
       'What a side effect is, how to run one with useEffect, the three uses of the dependency array, the cleanup function, and the common infinite loop mistake -- with simple examples.',
       'What Is useEffect in React? | Explained with Simple Examples',
       'Running a side effect with useEffect in React, using the dependency array as an empty array or with specific values, cleaning up with the cleanup function, and the infinite loop mistake caused by forgetting the dependency array -- explained with simple examples.',
       false
FROM topic
WHERE slug = 'use-effect';

-- Topic 3: useRef

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'useRef',
       'DOM referansları, render''lar arası kalıcı değerler, useRef vs useState, ve useRef''i useEffect ile birlikte kullanmak -- basit örneklerle.',
       'React''te useRef Nedir? | Basit Örneklerle Anlatım',
       'React''te useRef ile bir DOM elementine doğrudan erişmek, bir değeri render''lar arasında ekranı tetiklemeden hatırlamak, useRef ile useState arasındaki fark, ve useRef''i useEffect ile birlikte kullanmak -- basit örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'use-ref';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'useRef',
       'DOM references, persistent values across renders, useRef vs useState, and using useRef together with useEffect -- with simple examples.',
       'What Is useRef in React? | Explained with Simple Examples',
       'Accessing a DOM element directly with useRef in React, remembering a value across renders without triggering the screen to update, the difference between useRef and useState, and using useRef together with useEffect -- explained with simple examples.',
       false
FROM topic
WHERE slug = 'use-ref';

-- Topic 4: useMemo & useCallback

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'useMemo & useCallback',
       'Memoization nedir, useMemo ile hesaplama sonucunu ve nesne referansını, useCallback ile fonksiyon referansını önbelleğe almak, ve ne zaman kullanılmaması gerektiği -- basit örneklerle.',
       'React''te useMemo ve useCallback Nedir? | Basit Örneklerle Anlatım',
       'React''te useMemo ile bir hesaplama sonucunu ya da nesne referansını, useCallback ile bir fonksiyon referansını önbelleğe almak (memoize etmek), ve bu hook''ların ne zaman KULLANILMAMASI gerektiği (erken optimizasyon) -- basit örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'use-memo-use-callback';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'useMemo & useCallback',
       'What memoization is, caching a calculation''s result and an object reference with useMemo, caching a function reference with useCallback, and when NOT to use them -- with simple examples.',
       'What Are useMemo and useCallback in React? | Explained with Simple Examples',
       'Memoizing a calculation''s result or an object reference with useMemo in React, memoizing a function reference with useCallback, and when NOT to use these hooks (premature optimization) -- explained with simple examples.',
       false
FROM topic
WHERE slug = 'use-memo-use-callback';

-- Topic 5: Custom Hooks

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Custom Hooks',
       'Custom hook nedir, use öneki ve isimlendirme kuralı, aynı hook''u birden fazla kez kullanmak, ve bir useFetch örneği -- basit örneklerle.',
       'React''te Custom Hooks Nedir? | Basit Örneklerle Anlatım',
       'React''te kendi hook''unu (custom hook) nasıl yazacağın, use öneki ve isimlendirme kuralı, aynı custom hook''u aynı component içinde bağımsız state''lerle birden fazla kez kullanmak, ve veri çekme mantığını sarmalayan bir useFetch örneği -- basit örneklerle anlatılıyor.',
       true
FROM topic
WHERE slug = 'custom-hooks';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Custom Hooks',
       'What a custom hook is, the use prefix and naming rule, using the same hook more than once, and a useFetch example -- with simple examples.',
       'What Are Custom Hooks in React? | Explained with Simple Examples',
       'How to write your own hook (a custom hook) in React, the use prefix and naming rule, using the same custom hook more than once within a component with independent state, and a useFetch example that wraps data-fetching logic -- explained with simple examples.',
       false
FROM topic
WHERE slug = 'custom-hooks';
