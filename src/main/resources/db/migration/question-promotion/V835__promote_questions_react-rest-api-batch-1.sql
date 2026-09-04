-- Promotion batch
-- Topic: react-rest-api (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V795-V822 (React Hooks / Forms) and V767-V794
-- (React Components & Props / State & Events), these 14 questions were NOT
-- produced by the n8n generation pipeline, NOT judged by the AI Judge, and
-- NOT ingested via /api/internal/questions/ingest -- per explicit user
-- request, they were hand-authored and independently self-reviewed directly
-- inside a Claude Code session, grounded strictly in content/en/react-rest-api.md
-- and content/tr/react-rest-api.md.
--
-- Strict 50/50 EN/TR split (7+7) organized as 7 CONCEPT PAIRS -- each EN
-- question has a TR counterpart testing the exact same concept, but
-- independently authored (different code/variable/component names, different
-- question framing) rather than a translation. Every question whose answer
-- depends on shown code is typed CODE_OUTPUT (never SINGLE_CHOICE/
-- MULTIPLE_CHOICE with a code_snippet attached) -- fragments/quiz.html only
-- renders code_snippet for CODE_OUTPUT questions, per the bug found and fixed
-- in try-catch-finally/V573.
--
-- Each question's 4 options are written with the correct answer at a VARIED
-- position (not always first), applied directly during authoring via a
-- deterministic per-question rotation incorporating the migration version --
-- per the bug found and fixed in question-promotion/V598 (always-A bias) and
-- refined again in the Spring Data JPA batch (parity-locked EN/TR offsets).
--
-- source = 'CLAUDE' / reviewed_by = 'claude-code@anthropic.com' / status =
-- 'PUBLISHED' directly -- same documentation convention as prior manual
-- batches. topic_id resolved by Topic.slug; question_option rows reference
-- the newly generated id via a WITH ... RETURNING id CTE.
--
-- Duplicate-promotion safety: N/A -- this batch was never ingested into
-- development, so no dev ids exist for these 14 questions at all.

-- Pair 1 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Where does a React application usually store its own data, according to this lesson?$$,
           NULL, NULL,
           $$A React application usually doesn't store its own data -- it sends an HTTP request to a backend, which reads from a database and returns the result as JSON.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'react-rest-api'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It usually doesn't store its own data at all -- it sends requests to a backend$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$It always keeps its own permanent SQL database running inside the browser$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It stores everything permanently in the URL's query string$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$React components generate their own data at random on every render$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir React uygulaması genellikle kendi verisini nerede saklar?$$,
           NULL, NULL,
           $$Bir React uygulaması genellikle kendi verisini saklamaz -- bir backend'e HTTP isteği gönderir, backend veritabanından okur ve sonucu JSON olarak döndürür.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'react-rest-api'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$React component'leri her render'da rastgele kendi verisini üretir$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Genellikle kendi verisini hiç saklamaz -- bir backend'e istek gönderir$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Her zaman tarayıcı içinde çalışan kendi kalıcı SQL veritabanını tutar$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Her şeyi kalıcı olarak URL'nin query string'inde saklar$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What is the main purpose of gathering fetch calls into a separate api.js module?$$,
           NULL, NULL,
           $$Functions like getCourses(), createCourse(), deleteCourse() HIDE the details of fetch (the URL, method, headers) -- components just call these functions, never dealing with fetch itself.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'react-rest-api'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$To replace useEffect entirely with a different mechanism$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$To hide fetch's details (URL, method, headers) behind named functions components call directly$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$To make fetch calls run twice as fast automatically$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$It's required by React -- fetch cannot be called inside a component at all$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$fetch çağrılarını ayrı bir api.js modülünde toplamanın temel amacı nedir?$$,
           NULL, NULL,
           $$getCourses(), createCourse(), deleteCourse() gibi fonksiyonlar, fetch'in ayrıntılarını (URL, method, headers) GİZLER -- component'ler yalnızca bu fonksiyonları çağırır, fetch'in kendisiyle hiç uğraşmaz.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'react-rest-api'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$React tarafından zorunlu kılınır -- fetch bir component içinde hiç çağrılamaz$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$useEffect'in yerini tamamen farklı bir mekanizmayla değiştirmek$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$fetch'in ayrıntılarını (URL, method, headers) component'lerin doğrudan çağırdığı adlandırılmış fonksiyonların arkasına gizlemek$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$fetch çağrılarının otomatik olarak iki kat daha hızlı çalışmasını sağlamak$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Can useEffect's callback function itself be declared async, as shown here?$$,
           $$useEffect(async () => {
    const response = await fetch("/courses");
    const data = await response.json();
    setCourses(data);
}, []);$$, $$jsx$$,
           $$useEffect's callback CANNOT be async directly -- React doesn't support that; a separate async function must be defined inside it and called immediately instead.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'react-rest-api'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It works, but only on the very first render, never afterward$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$It works, but only if the dependency array is removed entirely$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Yes -- this is exactly the pattern this lesson recommends$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$No -- React doesn't support this; a separate async function must be defined inside and called immediately$$, TRUE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$useEffect'in callback fonksiyonunun kendisi, burada gösterildiği gibi doğrudan async olarak tanımlanabilir mi?$$,
           $$useEffect(async () => {
    const response = await fetch("/kurslar");
    const data = await response.json();
    kurslarAyarla(data);
}, []);$$, $$jsx$$,
           $$useEffect'in callback'i doğrudan async OLAMAZ -- React bunu desteklemez; bunun yerine içinde ayrı bir async fonksiyon tanımlanıp hemen çağrılmalıdır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'react-rest-api'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Evet -- bu, tam olarak bu dersin önerdiği kalıptır$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Çalışır, ama yalnızca ilk render'da, sonrasında asla çalışmaz$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Çalışır, ama yalnızca dependency array'i tamamen kaldırılırsa$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Hayır -- React bunu desteklemez; içinde ayrı bir async fonksiyon tanımlanıp hemen çağrılmalıdır$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What is onCreated(newCourse) used for in the course-creation example?$$,
           NULL, NULL,
           $$onCreated(newCourse) is a callback prop used to notify the PARENT component of this new record -- the "lifting data up" pattern from Props.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'react-rest-api'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A built-in React hook that automatically refreshes the entire page$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$A function that deletes the course immediately after creating it$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$A CSS animation triggered when a course is added$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$A callback prop that notifies the parent component of the newly created record$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Kurs oluşturma örneğinde onCreated(newCourse) ne için kullanılır?$$,
           NULL, NULL,
           $$onCreated(newCourse), parent component'i bu yeni kayıt hakkında bilgilendirmek için kullanılan bir callback prop'udur -- Props'tan gelen "veriyi yukarı taşıma" kalıbı.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'react-rest-api'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Parent component'i yeni oluşturulan kayıt hakkında bilgilendiren bir callback prop$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Tüm sayfayı otomatik olarak yenileyen yerleşik bir React hook'u$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Kursu oluşturulduktan hemen sonra silen bir fonksiyon$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Bir kurs eklendiğinde tetiklenen bir CSS animasyonu$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$After the DELETE request succeeds for course id 3, what does this code do to update the screen?$$,
           $$async function handleDelete(id) {
    await fetch(`/courses/${id}`, { method: "DELETE" });
    setCourses(courses.filter((c) => c.id !== id));
}$$, $$jsx$$,
           $$Following the immutability rule from State, filter() removes the deleted record and creates a NEW array -- the array is never mutated directly (like with splice).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'react-rest-api'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It mutates the existing courses array in place with splice(), then re-renders$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$It creates a brand new array via filter(), excluding the deleted course, and sets that as the new state$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$It does nothing -- the screen only updates on the next page reload$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$It sends a second GET request to re-fetch the entire list from scratch$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$3 numaralı kurs için DELETE isteği başarılı olduktan sonra, bu kod ekranı güncellemek için ne yapar?$$,
           $$async function handleDelete(id) {
    await fetch(`/kurslar/${id}`, { method: "DELETE" });
    kurslarAyarla(kurslar.filter((k) => k.id !== id));
}$$, $$jsx$$,
           $$State'ten gelen immutability kuralını izleyerek, filter() silinen kaydı çıkarır ve YENİ bir dizi oluşturur -- dizi asla (splice ile olduğu gibi) doğrudan mutate edilmez.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'react-rest-api'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Tüm listeyi sıfırdan yeniden getirmek için ikinci bir GET isteği gönderir$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$filter() aracılığıyla, silinen kursu hariç tutan yepyeni bir dizi oluşturur ve bunu yeni state olarak ayarlar$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Mevcut kurslar dizisini splice() ile yerinde mutate eder, sonra yeniden render eder$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Hiçbir şey yapmaz -- ekran yalnızca bir sonraki sayfa yenilemesinde güncellenir$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe setCourses([...courses, newCourse]) after creating a new record? (Select all that apply)$$,
           NULL, NULL,
           $$This uses the spread pattern from State to copy the old list and append the new record -- the screen updates IMMEDIATELY, without a second request to the server.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'react-rest-api'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It mutates the existing courses array directly by pushing onto it$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$It uses the spread pattern to copy the old list and append the new record$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$The screen updates immediately, without sending a second request to re-fetch the whole list$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$It's the only valid way to update the screen -- re-fetching is never acceptable$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Yeni bir kayıt oluşturduktan sonra kurslarAyarla([...kurslar, yeniKurs])'u aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Bu, eski listeyi kopyalayıp yeni kaydı ekleyen spread kalıbını kullanır -- ekran, sunucuya ikinci bir istek göndermeden HEMEN güncellenir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'react-rest-api'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Ekran, tüm listeyi yeniden getirmek için ikinci bir istek göndermeden hemen güncellenir$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Ekranı güncellemenin tek geçerli yoludur -- yeniden getirmek asla kabul edilemez$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Mevcut kurslar dizisini üzerine push yaparak doğrudan mutate eder$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Eski listeyi kopyalayıp yeni kaydı ekleyen spread kalıbını kullanır$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe json-server's role in this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$This lesson doesn't set up a real Spring Boot backend -- instead it uses json-server, a fake server following the same REST rules (GET/POST/DELETE, JSON, HTTP status codes); the React-side code would be exactly the same when connecting to a real backend.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'react-rest-api'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$json-server follows a completely different, incompatible set of rules than a real REST backend$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$json-server is a database engine that replaces PostgreSQL entirely$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$It's a fake server used instead of setting up a real Spring Boot backend$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$The React-side code would be exactly the same when connecting to a real backend instead$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste json-server'ın rolünü aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Bu ders gerçek bir Spring Boot backend kurmaz -- bunun yerine aynı REST kurallarını (GET/POST/DELETE, JSON, HTTP durum kodları) izleyen sahte bir sunucu olan json-server'ı kullanır; gerçek bir backend'e bağlanırken React tarafındaki kod tamamen aynı olurdu.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'react-rest-api'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Gerçek bir Spring Boot backend kurmak yerine kullanılan sahte bir sunucudur$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Gerçek bir backend'e bağlanırken React tarafındaki kod tamamen aynı olurdu$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$json-server, gerçek bir REST backend'inden tamamen farklı, uyumsuz bir kurallar kümesi izler$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$json-server, PostgreSQL'in yerini tamamen alan bir veritabanı motorudur$$, FALSE, 3 FROM new_question_tr7;
