-- Promotion batch
-- Topic: suspense (language: en x7, tr x7)
-- Generated: 2026-09-04 (this migration file's authoring date)
--
-- Like question-promotion/V823-V846 (React Routing / API & Data Fetching /
-- State Management) and V767-V822 (earlier React batches), these 14
-- questions were NOT produced by the n8n generation pipeline, NOT judged by
-- the AI Judge, and NOT ingested via /api/internal/questions/ingest -- per
-- explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/suspense.md and content/tr/suspense.md.
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
           $$When does Suspense show its fallback?$$,
           NULL, NULL,
           $$Suspense shows a fallback while something INSIDE it isn't ready yet.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'suspense'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$While something inside the Suspense boundary isn't ready yet$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Permanently, for as long as the component using Suspense exists$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Only when the browser window is resized$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Only during the very first render of the entire application$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Suspense, fallback'ini ne zaman gösterir?$$,
           NULL, NULL,
           $$Suspense, içindeki bir şey henüz hazır olmadığı sürece bir fallback gösterir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'suspense'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca tüm uygulamanın ilk render'ı sırasında$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Suspense sınırının içindeki bir şey henüz hazır olmadığı sürece$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Suspense'i kullanan component var olduğu sürece, kalıcı olarak$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Yalnızca tarayıcı penceresi yeniden boyutlandırıldığında$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What can the fallback prop be, and what happens to it once the content is ready?$$,
           NULL, NULL,
           $$fallback can be ANY JSX, not just text -- a spinner, a skeleton screen, or another component; once the component inside is ready, fallback is automatically REPLACED with the real content.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'suspense'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It must be manually removed with a separate function call once loading finishes$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Any JSX at all, like a spinner or skeleton screen; it's automatically replaced once the content is ready$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Only a plain text string -- JSX elements are not allowed as fallback$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$It stays visible forever, alongside the real content, once it's ready$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$fallback prop'u ne olabilir ve içerik hazır olduğunda ona ne olur?$$,
           NULL, NULL,
           $$fallback, yalnızca metin değil, bir spinner, bir skeleton ekran ya da başka bir component gibi HERHANGİ BİR JSX olabilir; içindeki component hazır olduğunda, fallback otomatik olarak gerçek içerikle DEĞİŞTİRİLİR.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'suspense'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İçerik hazır olduğunda, gerçek içeriğin yanında sonsuza kadar görünür kalır$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Yükleme bittiğinde ayrı bir fonksiyon çağrısıyla elle kaldırılmalıdır$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Spinner ya da skeleton ekran gibi herhangi bir JSX olabilir; içerik hazır olduğunda otomatik olarak değiştirilir$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Yalnızca düz bir metin string'i -- JSX elementlerine fallback olarak izin verilmez$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$CourseHeader has already loaded, but CourseReviews inside the inner Suspense hasn't. What does the user see for the rest of the page?$$,
           $$<Suspense fallback={<p>Loading page...</p>}>
    <CourseHeader />
    <Suspense fallback={<p>Loading reviews...</p>}>
        <CourseReviews />
    </Suspense>
</Suspense>$$, $$jsx$$,
           $$Once CourseHeader appears, the inner Suspense only covers CourseReviews -- the rest of the page does NOT go back to a loading state; only the still-waiting part shows loading.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'suspense'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Nothing renders at all until both CourseHeader and CourseReviews are ready together$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Both fallback messages show at the same time, stacked on top of each other$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$The entire page reverts to "Loading page...", including CourseHeader$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$CourseHeader stays visible, and only "Loading reviews..." shows in place of CourseReviews$$, TRUE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$KursBaslik zaten yüklendi, ama iç Suspense içindeki KursYorumlari henüz yüklenmedi. Kullanıcı sayfanın geri kalanında ne görür?$$,
           $$<Suspense fallback={<p>Sayfa yukleniyor...</p>}>
    <KursBaslik />
    <Suspense fallback={<p>Yorumlar yukleniyor...</p>}>
        <KursYorumlari />
    </Suspense>
</Suspense>$$, $$jsx$$,
           $$KursBaslik göründükten sonra, iç Suspense yalnızca KursYorumlari'nı kapsar -- sayfanın geri kalanı bir yükleme durumuna GERİ DÖNMEZ; yalnızca hâlâ bekleyen kısım yükleniyor gösterir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'suspense'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Tüm sayfa, KursBaslik dahil, "Sayfa yukleniyor..."ya geri döner$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Hem KursBaslik hem KursYorumlari birlikte hazır olana kadar hiçbir şey render edilmez$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Her iki fallback mesajı da aynı anda, üst üste görünür$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$KursBaslik görünür kalır, ve KursYorumlari'nın yerinde yalnızca "Yorumlar yukleniyor..." gösterilir$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does the use() hook (React 19) let you do with a Promise?$$,
           NULL, NULL,
           $$The use() hook can integrate a Promise DIRECTLY with Suspense -- given a Promise, if it hasn't resolved yet, it tells React to wait, showing the nearest Suspense's fallback.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'suspense'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Convert any Promise into a synchronous value with zero delay$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Cancel a pending Promise automatically after a fixed timeout$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Replace useState entirely for every kind of component state$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Integrate it directly with Suspense -- if unresolved, it tells React to wait and show the nearest fallback$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$use() hook'u (React 19), bir Promise ile ne yapmanı sağlar?$$,
           NULL, NULL,
           $$use() hook'u, bir Promise'i DOĞRUDAN Suspense ile entegre edebilir -- bir Promise verildiğinde, henüz çözülmediyse, React'e beklemesini söyler ve en yakın Suspense'in fallback'ini gösterir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'suspense'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Onu doğrudan Suspense ile entegre etmek -- çözülmediyse, React'e beklemesini ve en yakın fallback'i göstermesini söyler$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Herhangi bir Promise'i sıfır gecikmeyle senkron bir değere dönüştürmek$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Bekleyen bir Promise'i sabit bir zaman aşımından sonra otomatik olarak iptal etmek$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Her tür component state'i için useState'in tamamen yerini almak$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Unlike other hooks, can use() be called conditionally, according to this lesson?$$,
           NULL, NULL,
           $$Unlike other hooks, use() can also be called CONDITIONALLY.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'suspense'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yes -- unlike other hooks, use() can be called conditionally$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$No -- use() follows the exact same top-level-only rule as every other hook, no exceptions$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Only inside a class component's render method$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Only when wrapped in a custom hook first$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, diğer hook'ların aksine, use() koşullu olarak çağrılabilir mi?$$,
           NULL, NULL,
           $$Diğer hook'ların aksine, use() KOŞULLU olarak da çağrılabilir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'suspense'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca önce bir custom hook'a sarmalanırsa$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Evet -- diğer hook'ların aksine, use() koşullu olarak da çağrılabilir$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Hayır -- use(), istisnasız, diğer her hook ile tam olarak aynı yalnızca-en-üst-seviye kuralını izler$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Yalnızca bir class component'in render metodu içinde$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$This component uses the classic useEffect + fetch pattern inside a Suspense boundary. Does Suspense automatically show its fallback while the fetch is pending?$$,
           $$function CourseList() {
    const [courses, setCourses] = useState(null);
    useEffect(() => {
        fetch("/courses").then((r) => r.json()).then(setCourses);
    }, []);
    return <ul>{courses?.map((c) => <li key={c.id}>{c.title}</li>)}</ul>;
}

<Suspense fallback={<p>Loading...</p>}>
    <CourseList />
</Suspense>$$, $$jsx$$,
           $$The useEffect + fetch pattern does NOT automatically trigger Suspense -- Suspense only works with a Promise source that React DIRECTLY recognizes, like use(); this component still needs to manage its own loading state.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'suspense'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Only if setCourses is called with null explicitly first$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Yes -- any component inside a Suspense boundary automatically shows the fallback while fetching$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$No -- useEffect + fetch does not automatically trigger Suspense; the component must manage its own loading state$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Only if the fetch call takes longer than 1000ms$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu component, bir Suspense sınırının içinde klasik useEffect + fetch kalıbını kullanıyor. fetch beklerken Suspense otomatik olarak fallback'ini gösterir mi?$$,
           $$function KursListesi() {
    const [kurslar, kurslarAyarla] = useState(null);
    useEffect(() => {
        fetch("/kurslar").then((r) => r.json()).then(kurslarAyarla);
    }, []);
    return <ul>{kurslar?.map((k) => <li key={k.id}>{k.baslik}</li>)}</ul>;
}

<Suspense fallback={<p>Yukleniyor...</p>}>
    <KursListesi />
</Suspense>$$, $$jsx$$,
           $$useEffect + fetch kalıbı Suspense'i otomatik olarak tetiklemez -- Suspense yalnızca use() gibi React'in DOĞRUDAN tanıdığı bir Promise kaynağıyla çalışır; bu component kendi yükleme state'ini kendisi yönetmelidir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'suspense'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca fetch çağrısı 1000ms'den uzun sürerse$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Yalnızca kurslarAyarla önce açıkça null ile çağrılırsa$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Hayır -- useEffect + fetch, Suspense'i otomatik olarak tetiklemez; component kendi yükleme state'ini kendisi yönetmelidir$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Evet -- bir Suspense sınırının içindeki herhangi bir component, fetch sırasında otomatik olarak fallback'i gösterir$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe what Suspense does and doesn't do automatically, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$Suspense only works with a Promise source that React directly recognizes, like use(); "classic" data-fetching patterns like useEffect + fetch do NOT automatically trigger it.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'suspense'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Every asynchronous operation in a React app automatically triggers the nearest Suspense$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Suspense requires manually calling a triggerSuspense() function for every async operation$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Suspense only works automatically with a Promise source that React directly recognizes, like use()$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$"Classic" patterns like useEffect + fetch do not automatically trigger Suspense$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, Suspense'in otomatik olarak yapıp yapmadığını aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Suspense yalnızca use() gibi React'in doğrudan tanıdığı bir Promise kaynağıyla otomatik olarak çalışır; useEffect + fetch gibi "klasik" veri getirme kalıpları onu otomatik olarak tetiklemez.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'suspense'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Suspense yalnızca use() gibi React'in doğrudan tanıdığı bir Promise kaynağıyla otomatik olarak çalışır$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$useEffect + fetch gibi "klasik" kalıplar Suspense'i otomatik olarak tetiklemez$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir React uygulamasındaki her asenkron işlem, en yakın Suspense'i otomatik olarak tetikler$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Suspense, her asenkron işlem için elle bir triggerSuspense() fonksiyonu çağrılmasını gerektirir$$, FALSE, 3 FROM new_question_tr7;
