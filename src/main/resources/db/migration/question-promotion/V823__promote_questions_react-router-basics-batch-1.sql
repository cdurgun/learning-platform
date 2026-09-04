-- Promotion batch
-- Topic: react-router-basics (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V795-V822 (React Hooks / Forms) and V767-V794
-- (React Components & Props / State & Events), these 14 questions were NOT
-- produced by the n8n generation pipeline, NOT judged by the AI Judge, and
-- NOT ingested via /api/internal/questions/ingest -- per explicit user
-- request, they were hand-authored and independently self-reviewed directly
-- inside a Claude Code session, grounded strictly in content/en/react-router-basics.md
-- and content/tr/react-router-basics.md.
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
           $$In a React SPA, what does "changing pages" actually mean?$$,
           NULL, NULL,
           $$React applications run as a single HTML file; "changing pages" means rendering DIFFERENT components on that same page, based on the URL, instead of loading a new HTML file.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'react-router-basics'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The browser loads a completely new HTML file for each page$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Rendering different components on the same single HTML file, based on the URL$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$The server sends a pre-rendered image of the new page$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Nothing changes -- SPAs only ever show one fixed screen$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir React SPA'sında, "sayfa değiştirmek" gerçekte ne anlama gelir?$$,
           NULL, NULL,
           $$React uygulamaları tek bir HTML dosyası olarak çalışır; "sayfa değiştirmek", yeni bir HTML dosyası yüklemek yerine, URL'ye göre aynı sayfada FARKLI component'ler render etmek anlamına gelir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'react-router-basics'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hiçbir şey değişmez -- SPA'lar her zaman tek, sabit bir ekran gösterir$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$URL'ye göre, aynı tek HTML dosyasında farklı component'ler render etmek$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Tarayıcı her sayfa için tamamen yeni bir HTML dosyası yükler$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Sunucu yeni sayfanın önceden render edilmiş bir görüntüsünü gönderir$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What does each Route need to define, according to this lesson?$$,
           NULL, NULL,
           $$Each Route has a path (a URL pattern) and an element (the component to show for that URL).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'react-router-basics'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A database table name and a query string$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$A path (a URL pattern) and an element (the component to show)$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Only a component name, with the URL inferred automatically from it$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$A CSS class and an animation duration$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, her Route'un ne tanımlaması gerekir?$$,
           NULL, NULL,
           $$Her Route'un bir path'i (bir URL kalıbı) ve bir element'i (o URL için gösterilecek component) vardır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'react-router-basics'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir CSS class'ı ve bir animasyon süresi$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Bir veritabanı tablo adı ve bir query string$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Bir path (bir URL kalıbı) ve bir element (gösterilecek component)$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Yalnızca bir component adı, URL ondan otomatik olarak çıkarılır$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$The current URL is /about. Which component renders?$$,
           $$<Routes>
    <Route path="/" element={<Home />} />
    <Route path="/courses" element={<Courses />} />
    <Route path="/about" element={<About />} />
</Routes>$$, $$jsx$$,
           $$Routes looks at the URL to figure out which Route matches; only the matching Route is rendered at any given time -- here, /about matches the third Route, so About renders.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'react-router-basics'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$About, since its path matches the current URL$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Nothing renders, since /about isn't the root path$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Home, since it's declared first$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$All three components render together, stacked on the page$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Mevcut URL /hakkinda. Hangi component render edilir?$$,
           $$<Routes>
    <Route path="/" element={<AnaSayfa />} />
    <Route path="/kurslar" element={<Kurslar />} />
    <Route path="/hakkinda" element={<Hakkinda />} />
</Routes>$$, $$jsx$$,
           $$Routes, hangi Route'un eşleştiğini bulmak için URL'ye bakar; herhangi bir anda yalnızca eşleşen Route render edilir -- burada /hakkinda üçüncü Route ile eşleşir, bu yüzden Hakkinda render edilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'react-router-basics'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$AnaSayfa, çünkü önce tanımlanmıştır$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Üç component de birlikte, sayfada üst üste render edilir$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Hiçbir şey render edilmez, çünkü /hakkinda kök path değildir$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Hakkinda, çünkü path'i mevcut URL ile eşleşir$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why does this lesson recommend Link instead of <a href="..."> for moving between pages?$$,
           NULL, NULL,
           $$An <a href="..."> makes the browser reload the entire page; Link only changes the URL, and React renders the matching Route in response, without a full reload.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'react-router-basics'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$<a> tags are not valid inside JSX at all$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Link is required because <a> tags cannot have a href attribute in React$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$There's no real difference -- Link is purely a stylistic alternative to <a>$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$<a href="..."> makes the browser reload the entire page; Link changes the URL without reloading$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu ders, sayfalar arasında geçiş için neden <a href="..."> yerine Link öneriyor?$$,
           NULL, NULL,
           $$<a href="...">, tarayıcının tüm sayfayı yeniden yüklemesine neden olur; Link yalnızca URL'yi değiştirir ve React, yeniden yükleme olmadan eşleşen Route'u render eder.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'react-router-basics'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$<a href="...">, tarayıcının tüm sayfayı yeniden yüklemesine neden olur; Link, yeniden yüklemeden URL'yi değiştirir$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$<a> tag'leri JSX içinde hiç geçerli değildir$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$React'te <a> tag'leri href attribute'una sahip olamadığı için Link gereklidir$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Gerçek bir fark yoktur -- Link, <a>'ya yalnızca stilistik bir alternatiftir$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does NavLink give you that Link doesn't, according to this lesson?$$,
           NULL, NULL,
           $$NavLink lets you pass a FUNCTION to className (or style); that function receives an { isActive } object telling you whether that link's page is the current one.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'react-router-basics'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The ability to pass a function to className/style that receives whether the link's page is currently active$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$NavLink can navigate without changing the URL at all, unlike Link$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$NavLink automatically prefetches the linked page's data before it's clicked$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$NavLink is required for the very first Route in the app, Link for all the others$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, NavLink sana Link'in vermediği neyi verir?$$,
           NULL, NULL,
           $$NavLink, className'e (ya da style'a) bir FONKSİYON geçirmene izin verir; bu fonksiyon, o link'in sayfasının mevcut sayfa olup olmadığını belirten bir { isActive } nesnesi alır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'react-router-basics'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$NavLink, uygulamadaki ilk Route için gereklidir, diğerleri için Link gereklidir$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$className/style'a, link'in sayfasının şu anda aktif olup olmadığını alan bir fonksiyon geçirebilme yeteneği$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$NavLink, Link'in aksine, URL'yi hiç değiştirmeden gezinebilir$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$NavLink, tıklanmadan önce link'lenen sayfanın verisini otomatik olarak önceden getirir$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe combining multiple pages with a shared navigation menu, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$A real application usually has several Routes together with several Links pointing to them; this is the basic skeleton of a small multi-page application.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'react-router-basics'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Each additional page requires defining an entirely separate BrowserRouter$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$A real application usually has several Routes, each with its own path and element$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$A shared navigation menu typically contains several Links, one pointing to each page$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$A navigation menu can only ever contain exactly one Link, never more$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, paylaşılan bir navigasyon menüsüyle birden fazla sayfayı birleştirmeyi aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Gerçek bir uygulamada genellikle her birinin kendi path'i ve element'i olan birkaç Route, ve onlara işaret eden birkaç Link birlikte bulunur; bu, küçük bir çok sayfalı uygulamanın temel iskeletidir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'react-router-basics'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Paylaşılan bir navigasyon menüsü genellikle her sayfaya işaret eden birkaç Link içerir$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir navigasyon menüsü her zaman tam olarak bir Link içerebilir, asla daha fazlasını içeremez$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Her ek sayfa, tamamen ayrı bir BrowserRouter tanımlamayı gerektirir$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Gerçek bir uygulamada genellikle her birinin kendi path'i ve element'i olan birkaç Route bulunur$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$A user visits /does-not-exist. Which Route renders?$$,
           $$<Routes>
    <Route path="/" element={<Home />} />
    <Route path="/courses" element={<Courses />} />
    <Route path="*" element={<NotFound />} />
</Routes>$$, $$jsx$$,
           $$path="*" catches every URL that doesn't match any other Route; React looks for a match from top to bottom, and since /does-not-exist matches neither / nor /courses, it falls through to the catch-all, rendering NotFound.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'react-router-basics'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$NotFound, since path="*" catches every URL that doesn't match any other Route$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$The browser throws a network error, since the URL doesn't exist on a server$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Home, since it's the first Route declared$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Nothing renders at all, since no exact match exists$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bir kullanıcı /olmayan-sayfa'yı ziyaret ediyor. Hangi Route render edilir?$$,
           $$<Routes>
    <Route path="/" element={<AnaSayfa />} />
    <Route path="/kurslar" element={<Kurslar />} />
    <Route path="*" element={<BulunamadiSayfasi />} />
</Routes>$$, $$jsx$$,
           $$path="*", başka hiçbir Route ile eşleşmeyen her URL'yi yakalar; React yukarıdan aşağıya bir eşleşme arar, ve /olmayan-sayfa ne / ne de /kurslar ile eşleştiği için, catch-all'a düşer ve BulunamadiSayfasi render edilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'react-router-basics'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$AnaSayfa, çünkü ilk tanımlanan Route'tur$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Hiçbir tam eşleşme olmadığı için hiçbir şey render edilmez$$, FALSE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$URL bir sunucuda mevcut olmadığı için tarayıcı bir ağ hatası fırlatır$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$BulunamadiSayfasi, çünkü path="*" başka hiçbir Route ile eşleşmeyen her URL'yi yakalar$$, TRUE, 3 FROM new_question_tr7;
