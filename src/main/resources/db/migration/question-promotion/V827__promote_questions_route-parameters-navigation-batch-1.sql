-- Promotion batch
-- Topic: route-parameters-navigation (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V795-V822 (React Hooks / Forms) and V767-V794
-- (React Components & Props / State & Events), these 14 questions were NOT
-- produced by the n8n generation pipeline, NOT judged by the AI Judge, and
-- NOT ingested via /api/internal/questions/ingest -- per explicit user
-- request, they were hand-authored and independently self-reviewed directly
-- inside a Claude Code session, grounded strictly in content/en/route-parameters-navigation.md
-- and content/tr/route-parameters-navigation.md.
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
           $$Given path="/courses/:courseSlug" and a visit to /courses/java, how do you read courseSlug's value inside the component?$$,
           NULL, NULL,
           $$Inside the component, we read this value with the useParams() hook; the key on the returned object matches the name used in the Route (courseSlug).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'route-parameters-navigation'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$With the useParams() hook, whose returned object has a courseSlug field$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$It's automatically injected as a global variable named courseSlug$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$By reading window.location.pathname and manually splitting the string$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$It can't be read at all -- route parameters are write-only$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$path="/kurslar/:kursSlug" verildiğinde ve /kurslar/java ziyaret edildiğinde, component içinde kursSlug'ın değeri nasıl okunur?$$,
           NULL, NULL,
           $$Component içinde bu değer useParams() hook'u ile okunur; döndürülen nesnedeki key, Route'ta kullanılan adla (kursSlug) eşleşir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'route-parameters-navigation'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hiç okunamaz -- route parametreleri yalnızca yazma amaçlıdır$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Döndürülen nesnesinde bir kursSlug alanı olan useParams() hook'u ile$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Otomatik olarak kursSlug adında global bir değişken olarak enjekte edilir$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$window.location.pathname okunup string elle bölünerek$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What does writing one Route INSIDE another create?$$,
           NULL, NULL,
           $$Writing one Route inside another creates a nested structure -- a nested route.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'route-parameters-navigation'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$An infinite redirect loop$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$A nested route structure$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$A syntax error, since Routes can never be nested inside each other$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Two completely independent, unrelated pages$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir Route'u başka birinin İÇİNE yazmak neyi oluşturur?$$,
           NULL, NULL,
           $$Bir Route'u başka birinin içine yazmak, nested (iç içe) bir yapı -- bir nested route -- oluşturur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'route-parameters-navigation'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Tamamen bağımsız, ilgisiz iki sayfa$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Sonsuz bir yönlendirme döngüsü$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Nested (iç içe) bir route yapısı$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Route'lar asla birbirinin içine yerleştirilemeyeceği için bir sözdizimi hatası$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$CourseLayout is the parent route's element, but it does NOT include an <Outlet />. What happens to the matching nested child route?$$,
           $$function CourseLayout() {
    return (
        <div>
            <h1>Course Page</h1>
            {/* No <Outlet /> here at all */}
        </div>
    );
}

<Route path="/courses/:courseSlug" element={<CourseLayout />}>
    <Route path=":topicSlug" element={<TopicContent />} />
</Route>$$, $$jsx$$,
           $$The Outlet placed inside the parent component marks exactly where the matching child route should render -- without Outlet, the child route wouldn't appear anywhere, even though its path still matches.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'route-parameters-navigation'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$React throws a compile-time error, since Outlet is mandatory syntax$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$CourseLayout itself fails to render at all$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$TopicContent renders automatically at the bottom of CourseLayout regardless$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$TopicContent never appears anywhere on screen, even though its path matches$$, TRUE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$KursDuzeni, parent route'un element'idir, ama içinde HİÇ <Outlet /> yoktur. Eşleşen nested child route'a ne olur?$$,
           $$function KursDuzeni() {
    return (
        <div>
            <h1>Kurs Sayfasi</h1>
            {/* Burada hic <Outlet /> yok */}
        </div>
    );
}

<Route path="/kurslar/:kursSlug" element={<KursDuzeni />}>
    <Route path=":konuSlug" element={<KonuIcerigi />} />
</Route>$$, $$jsx$$,
           $$Parent component'in içine yerleştirilen Outlet, eşleşen child route'un tam olarak nerede render edileceğini işaretler -- Outlet olmadan, path'i eşleşse bile child route hiçbir yerde görünmez.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'route-parameters-navigation'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$KonuIcerigi, ne olursa olsun KursDuzeni'nin altında otomatik olarak render edilir$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$React, Outlet zorunlu bir sözdizimi olduğu için bir derleme zamanı hatası fırlatır$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$KursDuzeni'nin kendisi hiç render edilemez$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Path'i eşleşse bile, KonuIcerigi ekranda hiçbir yerde görünmez$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does the useNavigate() hook give you?$$,
           NULL, NULL,
           $$The useNavigate() hook gives us a navigate function; calling it from inside an event handler changes the URL.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'route-parameters-navigation'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A list of every route currently defined in the app$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$A boolean indicating whether the current page has fully loaded$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$A reference to the browser's address bar DOM element$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$A navigate function that changes the URL when called$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$useNavigate() hook'u sana ne verir?$$,
           NULL, NULL,
           $$useNavigate() hook'u bize, çağrıldığında URL'yi değiştiren bir navigate fonksiyonu verir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'route-parameters-navigation'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çağrıldığında URL'yi değiştiren bir navigate fonksiyonu$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Uygulamada şu anda tanımlı olan her route'un bir listesini$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Mevcut sayfanın tamamen yüklenip yüklenmediğini belirten bir boolean$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Tarayıcının adres çubuğu DOM elementine bir referans$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What happens after this form is submitted?$$,
           $$function AddCourseForm() {
    const navigate = useNavigate();

    function handleSubmit(event) {
        event.preventDefault();
        // ... save logic here ...
        navigate("/courses");
    }

    return <form onSubmit={handleSubmit}>...</form>;
}$$, $$jsx$$,
           $$After the form is "submitted," the user is redirected to the course list with navigate("/courses") -- a common use of useNavigate for redirecting after an action.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'route-parameters-navigation'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Nothing happens to the URL -- navigate only logs a message to the console$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$The user is redirected to /courses after the form's save logic runs$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$The browser reloads the entire page and shows /courses$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$navigate("/courses") only works if it's called from inside a Link component$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu form gönderildikten sonra ne olur?$$,
           $$function KursEkleFormu() {
    const navigate = useNavigate();

    function handleSubmit(event) {
        event.preventDefault();
        // ... kaydetme mantigi burada ...
        navigate("/kurslar");
    }

    return <form onSubmit={handleSubmit}>...</form>;
}$$, $$jsx$$,
           $$Form "gönderildikten" sonra, kullanıcı navigate("/kurslar") ile kurs listesine yönlendirilir -- bir eylemden sonra yönlendirme için useNavigate'in yaygın bir kullanımı.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'route-parameters-navigation'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$navigate("/kurslar") yalnızca bir Link component'inin içinden çağrılırsa çalışır$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Formun kaydetme mantığı çalıştıktan sonra kullanıcı /kurslar'a yönlendirilir$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$URL'ye hiçbir şey olmaz -- navigate yalnızca console'a bir mesaj loglar$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Tarayıcı tüm sayfayı yeniden yükler ve /kurslar'ı gösterir$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe navigate(-1), according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$navigate can be given a number instead of a URL, used to move in browser history; navigate(-1) does the same thing as the browser's back button, and is usually preferred for Back buttons since it returns to wherever the user came from.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'route-parameters-navigation'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$navigate(-1) is only usable inside a Link component, never inside an event handler$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$navigate can be given a number instead of a URL, to move forward or backward in browser history$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$navigate(-1) does the same thing as the browser's "back" button$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$navigate(-1) always sends the user to a fixed page like /courses, regardless of history$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, navigate(-1)'i aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$navigate'e bir URL yerine tarayıcı geçmişinde ileri ya da geri gitmek için bir sayı verilebilir; navigate(-1), tarayıcının geri düğmesiyle aynı şeyi yapar ve genellikle Geri düğmeleri için tercih edilir, çünkü kullanıcıyı geldiği yere geri götürür.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'route-parameters-navigation'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$navigate(-1), tarayıcının "geri" düğmesiyle aynı şeyi yapar$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$navigate(-1), geçmişten bağımsız olarak kullanıcıyı her zaman /kurslar gibi sabit bir sayfaya gönderir$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$navigate(-1) yalnızca bir Link component'inin içinde kullanılabilir, asla bir event handler içinde değil$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$navigate'e, tarayıcı geçmişinde ileri ya da geri gitmek için bir URL yerine bir sayı verilebilir$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly distinguish Link from useNavigate, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$Link always requires the user to CLICK something; useNavigate lets you change pages from code as a result of something -- a condition, an action -- not tied to a click.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'route-parameters-navigation'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$useNavigate can only be called from inside a Link component's onClick prop$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Link and useNavigate are two interchangeable names for exactly the same mechanism$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Link always requires the user to click something to trigger navigation$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$useNavigate lets you change pages from code, as a result of a condition rather than a click$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, Link'i useNavigate'ten aşağıdakilerden hangileri doğru şekilde ayırt eder? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Link her zaman kullanıcının bir şeye TIKLAMASINI gerektirir; useNavigate, bir tıklamaya değil bir koşula bağlı olarak, koddan sayfa değiştirmeni sağlar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'route-parameters-navigation'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Link, gezinmeyi tetiklemek için her zaman kullanıcının bir şeye tıklamasını gerektirir$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$useNavigate, bir tıklamaya değil bir koşula bağlı olarak, koddan sayfa değiştirmeni sağlar$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$useNavigate yalnızca bir Link component'inin onClick prop'unun içinden çağrılabilir$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Link ve useNavigate, tam olarak aynı mekanizmanın birbirinin yerine geçebilen iki adıdır$$, FALSE, 3 FROM new_question_tr7;
