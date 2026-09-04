-- Promotion batch
-- Topic: error-boundaries (language: en x7, tr x7)
-- Generated: 2026-09-04 (this migration file's authoring date)
--
-- Like question-promotion/V823-V846 (React Routing / API & Data Fetching /
-- State Management) and V767-V822 (earlier React batches), these 14
-- questions were NOT produced by the n8n generation pipeline, NOT judged by
-- the AI Judge, and NOT ingested via /api/internal/questions/ingest -- per
-- explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/error-boundaries.md and content/tr/error-boundaries.md.
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
           $$Can an error boundary be written as a function component using hooks?$$,
           NULL, NULL,
           $$There's no way to write error boundaries with hooks -- they can only be written using class components.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'error-boundaries'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$No -- error boundaries can only be written using class components$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Yes -- any function component automatically becomes an error boundary$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Yes, using useState combined with useEffect$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Yes, but only when combined with a custom hook$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir error boundary, hook'lar kullanan bir function component olarak yazılabilir mi?$$,
           NULL, NULL,
           $$Error boundary'leri hook'larla yazmanın bir yolu yoktur -- yalnızca class component'ler kullanılarak yazılabilirler.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'error-boundaries'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Evet, ama yalnızca özel bir custom hook ile birleştirildiğinde$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Hayır -- error boundary'ler yalnızca class component'ler kullanılarak yazılabilir$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Evet -- herhangi bir function component otomatik olarak bir error boundary olur$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Evet, useState'i useEffect ile birleştirerek$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What is static getDerivedStateFromError() used for?$$,
           NULL, NULL,
           $$It is called by React when a child throws an error -- whatever it returns becomes the new state, used to show the fallback UI.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'error-boundaries'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It runs once when the application first starts, regardless of errors$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$It's called when a child throws; whatever it returns becomes the new state, driving the fallback UI$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$It sends the error automatically to an external logging service$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$It prevents any error from ever being thrown in the first place$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$static getDerivedStateFromError() ne için kullanılır?$$,
           NULL, NULL,
           $$Bir child hata fırlattığında React tarafından çağrılır -- döndürdüğü değer yeni state olur ve fallback UI'yi tetikler.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'error-boundaries'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Herhangi bir hatanın baştan hiç fırlatılmasını engeller$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Hatalardan bağımsız olarak, uygulama ilk başladığında bir kez çalışır$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Bir child hata fırlattığında çağrılır; döndürdüğü değer yeni state olur ve fallback UI'yi tetikler$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Hatayı otomatik olarak harici bir loglama servisine gönderir$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why is componentDidCatch needed, given that getDerivedStateFromError already exists?$$,
           NULL, NULL,
           $$getDerivedStateFromError is ONLY for showing the fallback UI -- sending the error somewhere (logging it) requires the separate componentDidCatch(error, errorInfo) method.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'error-boundaries'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$componentDidCatch is required to prevent the app from crashing at all$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$componentDidCatch runs before getDerivedStateFromError, not after$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$getDerivedStateFromError only shows the fallback UI; componentDidCatch is the separate method for logging the error$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$componentDidCatch replaces getDerivedStateFromError entirely -- only one is ever needed$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$getDerivedStateFromError zaten varken, componentDidCatch neden gereklidir?$$,
           NULL, NULL,
           $$getDerivedStateFromError YALNIZCA fallback UI'yi göstermek içindir -- hatayı bir yere göndermek (loglamak) ayrı componentDidCatch(error, errorInfo) metodunu gerektirir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'error-boundaries'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$componentDidCatch, getDerivedStateFromError'ın yerini tamamen alır -- yalnızca biri gerekir$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$componentDidCatch, uygulamanın hiç çökmemesini sağlamak için gereklidir$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$componentDidCatch, getDerivedStateFromError'dan sonra değil önce çalışır$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$getDerivedStateFromError yalnızca fallback UI'yi gösterir; componentDidCatch, hatayı loglamak için ayrı metottur$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$BuggyCounter throws when count reaches 3, and it's wrapped in an ErrorBoundary. What does the user see after the count reaches 3?$$,
           $$function BuggyCounter({ count }) {
    if (count === 3) {
        throw new Error("Counter crashed!");
    }
    return <p>{count}</p>;
}

<ErrorBoundary>
    <BuggyCounter count={3} />
</ErrorBoundary>$$, $$jsx$$,
           $$ErrorBoundary catches the thrown error and replaces the normal render with a fallback UI -- BuggyCounter itself doesn't need to handle the error, that's the error boundary's job.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'error-boundaries'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A blank white screen, since React unmounts the entire application$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$ErrorBoundary's fallback UI, since it caught the error thrown during rendering$$, TRUE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$The browser's default JavaScript error console dialog$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$The number 3 is displayed normally, as if nothing happened$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$HatalıSayac, sayi 3'e ulaştığında hata fırlatıyor ve bir HataSiniri ile sarmalanmış. sayi 3'e ulaştıktan sonra kullanıcı ne görür?$$,
           $$function HataliSayac({ sayi }) {
    if (sayi === 3) {
        throw new Error("Sayac coktu!");
    }
    return <p>{sayi}</p>;
}

<HataSiniri>
    <HataliSayac sayi={3} />
</HataSiniri>$$, $$jsx$$,
           $$HataSiniri, fırlatılan hatayı yakalar ve normal render'ın yerine bir fallback UI koyar -- HataliSayac'ın kendisinin hatayı ele alması gerekmez, bu error boundary'nin işidir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'error-boundaries'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Tarayıcının varsayılan JavaScript hata konsolu diyaloğu$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Sanki hiçbir şey olmamış gibi 3 sayısı normal şekilde gösterilir$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$React tüm uygulamayı unmount ettiği için boş, beyaz bir ekran$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Render sırasında fırlatılan hatayı yakaladığı için HataSiniri'nin fallback UI'si$$, TRUE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why does this lesson recommend using multiple, small error boundaries instead of one big one?$$,
           NULL, NULL,
           $$If one section crashes inside its own boundary, the other sections (wrapped in separate boundaries) are NOT affected; with a single large boundary, any error could turn the ENTIRE page into a fallback message.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'error-boundaries'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$So a crash in one section doesn't turn the entire page into a fallback message$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Because a single error boundary can only catch exactly one error total, ever$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Because React requires at least two error boundaries per application$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Small boundaries make the application's JavaScript bundle smaller$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu ders, tek bir büyük error boundary yerine birden fazla küçük error boundary kullanmayı neden önerir?$$,
           NULL, NULL,
           $$Bir bölüm kendi boundary'si içinde çökerse, diğer bölümler (ayrı boundary'lerle sarmalanmış) ETKİLENMEZ; tek bir büyük boundary ile, herhangi bir hata TÜM sayfayı bir fallback mesajına dönüştürebilir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'error-boundaries'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir bölümdeki çökmenin tüm sayfayı bir fallback mesajına dönüştürmesini önlemek için$$, TRUE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Çünkü tek bir error boundary toplamda yalnızca tam olarak bir hatayı yakalayabilir, hiçbir zaman daha fazlasını yakalayamaz$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$React her uygulama için en az iki error boundary gerektirdiği için$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Küçük boundary'ler, uygulamanın JavaScript bundle'ını küçültür$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about what error boundaries do NOT catch, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$Error boundaries only catch errors thrown during RENDERING -- they do NOT catch errors in event handlers, asynchronous code, server-side rendering, or errors thrown in the boundary itself.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'error-boundaries'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Every kind of error in the entire application, with no exceptions at all$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Errors thrown inside an event handler, like onClick$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Errors thrown in asynchronous code, like setTimeout or fetch callbacks$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Errors thrown during rendering by a component the boundary wraps$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, error boundary'lerin YAKALAMADIĞI şeylerle ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Error boundary'ler yalnızca RENDER sırasında fırlatılan hataları yakalar -- event handler'lardaki, asenkron koddaki, server-side rendering'deki ya da boundary'nin kendisindeki hataları YAKALAMAZ.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'error-boundaries'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$setTimeout ya da fetch callback'leri gibi asenkron kodda fırlatılan hatalar$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Boundary'nin sarmaladığı bir component tarafından render sırasında fırlatılan hatalar$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Hiçbir istisna olmadan, tüm uygulamadaki her tür hata$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$onClick gibi bir event handler içinde fırlatılan hatalar$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$An error is thrown inside this onClick handler, and the button is wrapped in an ErrorBoundary. Does the ErrorBoundary catch it?$$,
           $$function handleClick() {
    throw new Error("Click failed!");
}

<ErrorBoundary>
    <button onClick={handleClick}>Click me</button>
</ErrorBoundary>$$, $$jsx$$,
           $$Error boundaries do NOT catch errors in event handlers -- only errors thrown during rendering. Regular try/catch is needed for errors inside handleClick.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'error-boundaries'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Only if getDerivedStateFromError is combined with componentDidCatch$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$It depends on whether the button also has an onError prop defined$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Yes -- ErrorBoundary catches any error thrown by a component it wraps, including event handlers$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$No -- error boundaries only catch errors thrown during rendering, not inside event handlers$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu onClick handler'ının içinde bir hata fırlatılıyor, ve düğme bir HataSiniri ile sarmalanmış. HataSiniri bunu yakalar mı?$$,
           $$function handleClick() {
    throw new Error("Tiklama basarisiz!");
}

<HataSiniri>
    <button onClick={handleClick}>Tikla</button>
</HataSiniri>$$, $$jsx$$,
           $$Error boundary'ler event handler'lardaki hataları YAKALAMAZ -- yalnızca render sırasında fırlatılan hataları yakalar. handleClick içindeki hatalar için sıradan try/catch gereklidir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'error-boundaries'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Evet -- HataSiniri, sarmaladığı bir component tarafından fırlatılan her hatayı, event handler'lar dahil yakalar$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Yalnızca getDerivedStateFromError, componentDidCatch ile birleştirilmişse$$, FALSE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Düğmenin ayrıca bir onError prop'una sahip olup olmadığına bağlıdır$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Hayır -- error boundary'ler yalnızca render sırasında fırlatılan hataları yakalar, event handler'ların içindekileri değil$$, TRUE, 3 FROM new_question_tr7;
