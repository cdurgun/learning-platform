-- Promotion batch
-- Topic: fetching-data (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V795-V822 (React Hooks / Forms) and V767-V794
-- (React Components & Props / State & Events), these 14 questions were NOT
-- produced by the n8n generation pipeline, NOT judged by the AI Judge, and
-- NOT ingested via /api/internal/questions/ingest -- per explicit user
-- request, they were hand-authored and independently self-reviewed directly
-- inside a Claude Code session, grounded strictly in content/en/fetching-data.md
-- and content/tr/fetching-data.md.
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
           $$What does calling fetch(url) return?$$,
           NULL, NULL,
           $$fetch is a built-in browser function -- it sends an HTTP request to a URL and returns a Promise.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'fetching-data'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A Promise$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$The response data directly, already parsed as a JavaScript object$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$A boolean indicating whether the request succeeded$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Nothing -- fetch has no return value at all$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$fetch(url) çağırmak ne döndürür?$$,
           NULL, NULL,
           $$fetch, tarayıcının yerleşik bir fonksiyonudur -- bir URL'ye HTTP isteği gönderir ve bir Promise döndürür.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'fetching-data'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hiçbir şey -- fetch'in hiç dönüş değeri yoktur$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir Promise$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Zaten bir JavaScript nesnesi olarak ayrıştırılmış, doğrudan response verisini$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$İsteğin başarılı olup olmadığını belirten bir boolean$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Why does this lesson call fetch inside a useEffect with an empty dependency array []?$$,
           NULL, NULL,
           $$Since useEffect's second argument is an empty array, this request fires only ONCE, when the component first renders.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'fetching-data'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It has no real effect -- an empty array behaves identically to no useEffect at all$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$So the request fires only once, when the component first renders$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$So the request fires on every single re-render, to keep data always fresh$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Because fetch can only be called from inside a dependency array, nowhere else$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu ders, fetch'i neden boş bir dependency array [] ile bir useEffect içinde çağırır?$$,
           NULL, NULL,
           $$useEffect'in ikinci argümanı boş bir dizi olduğu için, bu istek yalnızca BİR KEZ, component ilk render edildiğinde çalışır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'fetching-data'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$fetch yalnızca bir dependency array'in içinden çağrılabildiği için, başka hiçbir yerden değil$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Gerçek bir etkisi yoktur -- boş bir dizi, hiç useEffect olmamasıyla birebir aynı davranır$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$İsteğin yalnızca bir kez, component ilk render edildiğinde çalışması için$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Veriyi her zaman taze tutmak için isteğin her tek yeniden render'da çalışması için$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$loading is currently true. What does this component render?$$,
           $$function CourseList() {
    const [loading, setLoading] = useState(true);
    const [courses, setCourses] = useState([]);

    if (loading) {
        return <p>Loading...</p>;
    }

    return <ul>{courses.map((c) => <li key={c.id}>{c.title}</li>)}</ul>;
}$$, $$jsx$$,
           $$While loading is true, the component renders <p>Loading...</p> and returns EARLY -- the rest of the JSX (the course list) never renders.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'fetching-data'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Only the empty <ul>, since courses starts as an empty array$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Nothing renders, since loading being true is treated as an error$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Only "Loading..." -- the function returns early, so the list JSX never runs$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Both "Loading..." and the (empty) course list are rendered together$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$yukleniyor şu anda true. Bu component ne render eder?$$,
           $$function KursListesi() {
    const [yukleniyor, yukleniyorAyarla] = useState(true);
    const [kurslar, kurslarAyarla] = useState([]);

    if (yukleniyor) {
        return <p>Yukleniyor...</p>;
    }

    return <ul>{kurslar.map((k) => <li key={k.id}>{k.baslik}</li>)}</ul>;
}$$, $$jsx$$,
           $$yukleniyor true olduğu sürece, component <p>Yukleniyor...</p>'yi render eder ve ERKEN döner -- JSX'in geri kalanı (kurs listesi) asla çalışmaz.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'fetching-data'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hem "Yukleniyor..." hem de (boş) kurs listesi birlikte render edilir$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Yalnızca boş <ul>, çünkü kurslar boş bir dizi olarak başlar$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$yukleniyor true olması bir hata olarak ele alındığı için hiçbir şey render edilmez$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Yalnızca "Yukleniyor..." -- fonksiyon erken döner, bu yüzden liste JSX'i asla çalışmaz$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Does fetch automatically reject its Promise when the server responds with a 404 or 500 status code?$$,
           NULL, NULL,
           $$fetch does NOT automatically reject on statuses like 404 or 500, so we have to check response.ok ourselves and throw.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'fetching-data'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yes -- any status outside 200 automatically triggers .catch()$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Only for 500-level errors, never for 404$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Only if the response body is empty$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$No -- fetch does not automatically reject on statuses like 404 or 500; response.ok must be checked manually$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Sunucu 404 ya da 500 durum koduyla yanıt verdiğinde, fetch Promise'ini otomatik olarak reddeder mi?$$,
           NULL, NULL,
           $$fetch, 404 ya da 500 gibi durum kodlarında otomatik olarak reddetmez, bu yüzden response.ok'u kendimiz kontrol edip throw etmemiz gerekir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'fetching-data'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hayır -- fetch, 404 ya da 500 gibi durum kodlarında otomatik olarak reddetmez; response.ok elle kontrol edilmelidir$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Evet -- 200 dışındaki herhangi bir durum otomatik olarak .catch()'i tetikler$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Yalnızca 500 seviyesi hatalar için, 404 için asla değil$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Yalnızca response body'si boşsa$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What three things does this options object provide to fetch?$$,
           $$fetch("/courses", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ title: "React" }),
});$$, $$jsx$$,
           $$In a POST request, fetch's second argument is an options object: method ('POST'), headers (telling the server the data is JSON), and body (the data being sent, converted to a string with JSON.stringify).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'fetching-data'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The HTTP method, headers describing the content type, and the body being sent as a JSON string$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$The URL, the response format, and a timeout duration$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Only the body -- method and headers are inferred automatically from the URL$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$A callback function, an error handler, and a retry count$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu options nesnesi fetch'e hangi üç şeyi sağlar?$$,
           $$fetch("/kurslar", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ baslik: "React" }),
});$$, $$jsx$$,
           $$Bir POST isteğinde, fetch'in ikinci argümanı bir options nesnesidir: method ('POST'), headers (sunucuya verinin JSON olduğunu söyler) ve body (JSON.stringify ile string'e dönüştürülmüş, gönderilen veri).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'fetching-data'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir callback fonksiyonu, bir hata işleyici ve bir yeniden deneme sayısı$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$HTTP metodu, içerik tipini belirten header'lar, ve JSON string'i olarak gönderilen body$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$URL, response formatı ve bir zaman aşımı süresi$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Yalnızca body -- method ve headers URL'den otomatik olarak çıkarılır$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$How does DELETE typically differ from PUT in terms of what's sent?$$,
           NULL, NULL,
           $$Like POST, PUT sends a body -- but the URL specifies which record to update; DELETE usually sends no body at all, specifying only via the URL's id which record to remove.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'fetching-data'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$PUT never specifies which record to affect; only DELETE does, via the URL$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$PUT sends a body with the updated data; DELETE usually sends no body at all$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$DELETE always sends a body, while PUT never does$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Both PUT and DELETE are functionally identical in every respect$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Neyin gönderildiği açısından DELETE, PUT'tan tipik olarak nasıl farklıdır?$$,
           NULL, NULL,
           $$POST gibi, PUT de bir body gönderir -- ama URL, hangi kaydın güncelleneceğini belirtir; DELETE genellikle hiç body göndermez, yalnızca URL'nin id'si üzerinden hangi kaydın kaldırılacağını belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'fetching-data'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$PUT ve DELETE her açıdan işlevsel olarak birebir aynıdır$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$PUT, hangi kaydı etkileyeceğini asla belirtmez; yalnızca DELETE, URL üzerinden belirtir$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$PUT, güncellenen veriyle bir body gönderir; DELETE genellikle hiç body göndermez$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$DELETE her zaman bir body gönderir, PUT ise asla göndermez$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe error/loading handling around a fetch request, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$.catch() catches the thrown error and writes it to error state; .finally() turns off loading regardless of success or failure.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'fetching-data'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$.finally() only runs when the request succeeds, never when it fails$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$response.ok is checked automatically by fetch itself, with no code needed$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$.catch() catches a thrown error and can write it to error state$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$.finally() turns off loading regardless of whether the request succeeded or failed$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir fetch isteği etrafındaki hata/yükleme yönetimini aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$.catch(), fırlatılan hatayı yakalar ve error state'ine yazabilir; .finally(), başarı ya da başarısızlıktan bağımsız olarak loading'i kapatır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'fetching-data'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$.catch(), fırlatılan bir hatayı yakalar ve error state'ine yazabilir$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$.finally(), isteğin başarılı ya da başarısız olmasından bağımsız olarak loading'i kapatır$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$.finally() yalnızca istek başarılı olduğunda çalışır, başarısız olduğunda asla çalışmaz$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$response.ok, hiçbir kod gerekmeden fetch'in kendisi tarafından otomatik olarak kontrol edilir$$, FALSE, 3 FROM new_question_tr7;
