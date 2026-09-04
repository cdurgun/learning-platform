-- Promotion batch
-- Topic: lazy-loading-code-splitting (language: en x7, tr x7)
-- Generated: 2026-09-04 (this migration file's authoring date)
--
-- Like question-promotion/V823-V846 (React Routing / API & Data Fetching /
-- State Management) and V767-V822 (earlier React batches), these 14
-- questions were NOT produced by the n8n generation pipeline, NOT judged by
-- the AI Judge, and NOT ingested via /api/internal/questions/ingest -- per
-- explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/lazy-loading-code-splitting.md and content/tr/lazy-loading-code-splitting.md.
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
           $$What does lazy(() => import("./CourseDetails.jsx")) do to CourseDetails's code?$$,
           NULL, NULL,
           $$It removes CourseDetails's code from the app's initial bundle -- it's only downloaded once it's actually needed.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lazy-loading-code-splitting'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It removes CourseDetails's code from the initial bundle, downloading it only when needed$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$It deletes CourseDetails's code from the project entirely$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It duplicates CourseDetails's code into every other bundle for redundancy$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$It has no effect on bundling at all -- lazy() is purely a naming convention$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$lazy(() => import("./KursDetaylari.jsx")), KursDetaylari'nın koduna ne yapar?$$,
           NULL, NULL,
           $$KursDetaylari'nın kodunu uygulamanın ilk bundle'ından çıkarır -- yalnızca gerçekten ihtiyaç duyulduğunda indirilir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lazy-loading-code-splitting'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bundling üzerinde hiçbir etkisi yoktur -- lazy() yalnızca bir isimlendirme kuralıdır$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$KursDetaylari'nın kodunu ilk bundle'dan çıkarır, yalnızca ihtiyaç duyulduğunda indirir$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$KursDetaylari'nın kodunu projeden tamamen siler$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$KursDetaylari'nın kodunu yedeklilik için her diğer bundle'a kopyalar$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What is Suspense required for when using lazy()?$$,
           NULL, NULL,
           $$Suspense is required to show a fallback during the download of the lazily-loaded component's code.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lazy-loading-code-splitting'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It's entirely optional and has no real purpose when paired with lazy()$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$To show a fallback while the lazily-loaded component's code is downloading$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$To automatically retry the download if it fails, with no other configuration$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$To convert a named export into a default export$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$lazy() kullanırken Suspense ne için gereklidir?$$,
           NULL, NULL,
           $$Suspense, lazy yüklenen component'in kodu indirilirken bir fallback göstermek için gereklidir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lazy-loading-code-splitting'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir named export'u bir default export'a dönüştürmek için$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Tamamen isteğe bağlıdır ve lazy() ile birlikte kullanıldığında gerçek bir amacı yoktur$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Lazy yüklenen component'in kodu indirilirken bir fallback göstermek için$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$İndirme başarısız olursa, başka hiçbir yapılandırma olmadan otomatik olarak yeniden denemek için$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A user visits only the home page and never navigates to /about. Given this setup, is AboutPage's code ever downloaded?$$,
           $$const AboutPage = lazy(() => import("./AboutPage.jsx"));

<Routes>
    <Route path="/" element={<Home />} />
    <Route path="/about" element={
        <Suspense fallback={<p>Loading...</p>}>
            <AboutPage />
        </Suspense>
    } />
</Routes>$$, $$jsx$$,
           $$If a user never visits /about, that page's code is never downloaded -- this is route-based code splitting.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lazy-loading-code-splitting'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yes, but only after a 5-second delay regardless of navigation$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$It depends on whether Home also imports AboutPage internally$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$No -- since the user never visits /about, AboutPage's code is never downloaded$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Yes -- lazy() always downloads every route's code immediately at app startup$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir kullanıcı yalnızca ana sayfayı ziyaret ediyor ve hiç /hakkinda'ya gitmiyor. Bu kuruluma göre, HakkindaSayfasi'nın kodu hiç indirilir mi?$$,
           $$const HakkindaSayfasi = lazy(() => import("./HakkindaSayfasi.jsx"));

<Routes>
    <Route path="/" element={<AnaSayfa />} />
    <Route path="/hakkinda" element={
        <Suspense fallback={<p>Yukleniyor...</p>}>
            <HakkindaSayfasi />
        </Suspense>
    } />
</Routes>$$, $$jsx$$,
           $$Bir kullanıcı hiç /hakkinda'yı ziyaret etmezse, o sayfanın kodu hiç indirilmez -- bu, route tabanlı code splitting'dir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lazy-loading-code-splitting'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Evet -- lazy(), her route'un kodunu uygulama başlangıcında hemen indirir$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Evet, ama yalnızca gezinmeden bağımsız olarak 5 saniyelik bir gecikmeden sonra$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$AnaSayfa'nın da dahili olarak HakkindaSayfasi'nı import edip etmediğine bağlıdır$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Hayır -- kullanıcı hiç /hakkinda'yı ziyaret etmediği için, HakkindaSayfasi'nın kodu hiç indirilmez$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$CourseChart is a NAMED export, not a default export. Why is .then((module) => ({ default: module.CourseChart })) needed here?$$,
           $$const CourseChart = lazy(() =>
    import("./CourseChart.jsx").then((module) => ({ default: module.CourseChart }))
);$$, $$jsx$$,
           $$lazy() expects import() to resolve to a DEFAULT export -- .then(...) converts the named export CourseChart into the { default: ... } shape that lazy expects.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lazy-loading-code-splitting'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Because named exports cannot be used with the import() syntax at all$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Because it makes CourseChart's code load faster than a default export would$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$It's unnecessary boilerplate with no actual functional purpose$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Because lazy() expects import() to resolve to a default export, and this converts the named export into that shape$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$KursGrafigi bir NAMED export'tur, default export değildir. Burada .then((module) => ({ default: module.KursGrafigi })) neden gereklidir?$$,
           $$const KursGrafigi = lazy(() =>
    import("./KursGrafigi.jsx").then((module) => ({ default: module.KursGrafigi }))
);$$, $$jsx$$,
           $$lazy(), import()'ın bir default export'a çözülmesini bekler -- .then(...), named export olan KursGrafigi'ni lazy'nin beklediği { default: ... } şekline dönüştürür.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lazy-loading-code-splitting'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çünkü lazy(), import()'ın bir default export'a çözülmesini bekler, ve bu named export'u o şekle dönüştürür$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Çünkü named export'lar import() sözdizimiyle hiç kullanılamaz$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Çünkü KursGrafigi'nin kodunun bir default export'tan daha hızlı yüklenmesini sağlar$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Gerçek bir işlevsel amacı olmayan gereksiz bir boilerplate'tir$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Is lazy() only useful for splitting pages/routes, according to this lesson?$$,
           NULL, NULL,
           $$lazy() is useful not just for pages, but for ANY rarely-used component, like EmojiPicker -- its code is never downloaded until showPicker becomes true for the first time.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lazy-loading-code-splitting'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$No -- it's also useful for any rarely-used component, like an emoji picker$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Yes -- lazy() only works when combined with a Route component$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Yes, and it can never be triggered by a state change like showPicker$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$No -- but rarely-used components must be split with a completely different API$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, lazy() yalnızca sayfaları/route'ları bölmek için mi kullanışlıdır?$$,
           NULL, NULL,
           $$lazy(), yalnızca sayfalar için değil, emoji seçici gibi NADIREN kullanılan HERHANGİ bir component için de kullanışlıdır -- kodu, showPicker ilk kez true olana kadar hiç indirilmez.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lazy-loading-code-splitting'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hayır -- ama nadiren kullanılan component'ler tamamen farklı bir API ile bölünmelidir$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Hayır -- bir emoji seçici gibi nadiren kullanılan herhangi bir component için de kullanışlıdır$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Evet -- lazy() yalnızca bir Route component'iyle birleştirildiğinde çalışır$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Evet, ve showPicker gibi bir state değişikliğiyle asla tetiklenemez$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe code splitting, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$Code splitting is breaking an application into multiple small pieces instead of one giant bundle; a bundle is an application's JavaScript files combined together; a chunk is a small, separately downloadable file produced by code splitting.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lazy-loading-code-splitting'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A bundle and a chunk are two interchangeable names for exactly the same thing$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$It's the technique of breaking an application into multiple small pieces instead of one giant bundle$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$A chunk is a small, separately downloadable JavaScript file produced by code splitting$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Code splitting always requires rewriting an application entirely in a different language$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, code splitting'i aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Code splitting, bir uygulamayı tek bir dev bundle yerine birden fazla küçük parçaya bölme tekniğidir; bir bundle, bir uygulamanın birleştirilmiş JavaScript dosyalarıdır; bir chunk, code splitting'in ürettiği küçük, ayrı ayrı indirilebilir bir dosyadır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lazy-loading-code-splitting'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir chunk, code splitting'in ürettiği küçük, ayrı ayrı indirilebilir bir JavaScript dosyasıdır$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Code splitting her zaman uygulamayı tamamen farklı bir dilde yeniden yazmayı gerektirir$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir bundle ve bir chunk, tam olarak aynı şeyin birbirinin yerine geçebilen iki adıdır$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir uygulamayı tek bir dev bundle yerine birden fazla küçük parçaya bölme tekniğidir$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly summarize lazy()'s overall effect, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$lazy() splits a component's code into a separate chunk, downloading it only when actually needed -- this reduces the amount of JavaScript loaded initially; lazy() is always used together with Suspense.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lazy-loading-code-splitting'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$lazy() increases the total amount of JavaScript the browser ever downloads, in every case$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$lazy() eliminates the need for a bundler entirely$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$It reduces the amount of JavaScript loaded initially, by downloading code only when needed$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$lazy() is always used together with Suspense, since a fallback is needed while code downloads$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, lazy()'nin genel etkisini aşağıdakilerden hangileri doğru şekilde özetler? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$lazy(), bir component'in kodunu ayrı bir chunk'a böler, yalnızca gerçekten ihtiyaç duyulduğunda indirir -- bu, başlangıçta yüklenen JavaScript miktarını azaltır; lazy() her zaman Suspense ile birlikte kullanılır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'lazy-loading-code-splitting'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Kodu yalnızca ihtiyaç duyulduğunda indirerek, başlangıçta yüklenen JavaScript miktarını azaltır$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$İndirme sırasında bir fallback gerektiği için, lazy() her zaman Suspense ile birlikte kullanılır$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$lazy(), tarayıcının indirdiği toplam JavaScript miktarını her durumda artırır$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$lazy(), bir bundler'a ihtiyacı tamamen ortadan kaldırır$$, FALSE, 3 FROM new_question_tr7;
