-- Promotion batch
-- Topic: events (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V731-V766 (Spring Data JPA) and V715-V730
-- (Advanced Spring), these 14 questions were NOT produced by the n8n
-- generation pipeline, NOT judged by the AI Judge, and NOT ingested via
-- /api/internal/questions/ingest -- per explicit user request, they were
-- hand-authored and independently self-reviewed directly inside a Claude Code
-- session, grounded strictly in content/en/events.md and
-- content/tr/events.md.
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
           $$What does React give you to catch a user's actions like clicks and typing?$$,
           NULL, NULL,
           $$Ready-made attributes like onClick, onChange, onSubmit, and more.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'events'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A single, universal onUserAction attribute for every kind of action$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Ready-made attributes like onClick, onChange, and onSubmit$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$A separate EventListener class you must instantiate manually$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Nothing built-in -- you must write raw browser DOM event code yourself$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$React, tıklama ve yazma gibi kullanıcı eylemlerini yakalamak için sana ne verir?$$,
           NULL, NULL,
           $$onClick, onChange, onSubmit gibi hazır attribute'lar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'events'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yerleşik hiçbir şey -- ham tarayıcı DOM event kodunu kendin yazmalısın$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$onClick, onChange ve onSubmit gibi hazır attribute'lar$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Her tür eylem için tek, evrensel bir onUserAction attribute'u$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Elle örneklemen gereken ayrı bir EventListener sınıfı$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What happens when this component renders?$$,
           $$function sayHello() {
    console.log("Hello!");
}

function Greeter() {
    return <button onClick={sayHello()}>Say Hello</button>;
}$$, $$jsx$$,
           $$Writing sayHello() calls the function immediately, as soon as the component renders, and hands its result (undefined) to onClick -- so "Hello!" logs right away, before any click, and clicking the button does nothing.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'events'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$React throws an error, since onClick must always be a named function reference$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$"Hello!" is logged every time the button is clicked, as expected$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$"Hello!" is logged immediately when the component renders, and clicking the button does nothing$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Nothing is ever logged, since sayHello() returns undefined$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu component render edildiğinde ne olur?$$,
           $$function selamVer() {
    console.log("Merhaba!");
}

function Selamlayici() {
    return <button onClick={selamVer()}>Selam Ver</button>;
}$$, $$jsx$$,
           $$selamVer() yazmak, component render edilir edilmez fonksiyonu hemen çağırır ve sonucunu (undefined) onClick'e verir -- bu yüzden "Merhaba!" hiçbir tıklama olmadan hemen loglanır, ve düğmeye tıklamak hiçbir şey yapmaz.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'events'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$selamVer() undefined döndürdüğü için hiçbir şey loglanmaz$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$React bir hata fırlatır, çünkü onClick her zaman adlandırılmış bir fonksiyon referansı olmalıdır$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Component render edildiğinde "Merhaba!" hemen loglanır, ve düğmeye tıklamak hiçbir şey yapmaz$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Beklendiği gibi, düğmeye her tıklandığında "Merhaba!" loglanır$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$According to this lesson, can an event handler be written directly inline, instead of as a separately named function?$$,
           NULL, NULL,
           $$Yes -- you can write an event handler as a named function, or directly inline.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'events'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Only onSubmit supports inline handlers; onClick does not$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Only class components can use inline event handlers$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$No -- React only accepts a pre-declared, named function reference$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Yes -- an event handler can be written as a named function, or directly inline$$, TRUE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir event handler, ayrı adlandırılmış bir fonksiyon yerine doğrudan inline olarak yazılabilir mi?$$,
           NULL, NULL,
           $$Evet -- bir event handler, adlandırılmış bir fonksiyon olarak ya da doğrudan inline olarak yazılabilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'events'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hayır -- React yalnızca önceden tanımlanmış, adlandırılmış bir fonksiyon referansı kabul eder$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Yalnızca onSubmit inline handler'ları destekler; onClick desteklemez$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Yalnızca class component'ler inline event handler kullanabilir$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Evet -- bir event handler, adlandırılmış bir fonksiyon olarak ya da doğrudan inline olarak yazılabilir$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$How does an onChange event handler read what the user just typed into an input?$$,
           NULL, NULL,
           $$The event handler automatically receives an event object, and you read what was just typed with event.target.value.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'events'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$By calling a separate getInputValue() function React provides globally$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$The typed value is passed directly as the handler's first plain string argument$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$onChange cannot read the typed value -- only onSubmit can$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$With event.target.value, using the event object automatically passed to the handler$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir onChange event handler'ı, kullanıcının bir input'a az önce ne yazdığını nasıl okur?$$,
           NULL, NULL,
           $$Event handler otomatik olarak bir event nesnesi alır, ve az önce yazılan şey event.target.value ile okunur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'events'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Handler'a otomatik olarak geçirilen event nesnesini kullanarak, event.target.value ile$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$React'in global olarak sağladığı ayrı bir getInputValue() fonksiyonunu çağırarak$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Yazılan değer, handler'ın ilk düz string argümanı olarak doğrudan geçirilir$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$onChange yazılan değeri okuyamaz -- yalnızca onSubmit okuyabilir$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A form's onSubmit handler does NOT call event.preventDefault(). What happens when the user submits the form?$$,
           $$function LoginForm() {
    function handleSubmit(event) {
        console.log("Submitted!");
        // event.preventDefault() is missing
    }

    return <form onSubmit={handleSubmit}>...</form>;
}$$, $$jsx$$,
           $$Without preventDefault(), the browser falls back to its default behavior and reloads the page -- something React apps almost never want.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'events'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Only "Submitted!" is logged, and nothing else happens$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$"Submitted!" is logged, and the browser also falls back to its default behavior and reloads the page$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$The form submission is silently cancelled, and nothing is logged at all$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$React automatically calls preventDefault() on every form regardless$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir formun onSubmit handler'ı event.preventDefault()'u ÇAĞIRMIYOR. Kullanıcı formu gönderdiğinde ne olur?$$,
           $$function GirisFormu() {
    function handleSubmit(event) {
        console.log("Gonderildi!");
        // event.preventDefault() eksik
    }

    return <form onSubmit={handleSubmit}>...</form>;
}$$, $$jsx$$,
           $$preventDefault() olmadan, tarayıcı kendi varsayılan davranışına döner ve sayfayı yeniden yükler -- React uygulamalarının neredeyse hiç istemediği bir şey.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'events'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$React her formda otomatik olarak preventDefault()'u çağırır$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$"Gonderildi!" loglanır, ve tarayıcı da kendi varsayılan davranışına döner ve sayfayı yeniden yükler$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Yalnızca "Gonderildi!" loglanır ve başka hiçbir şey olmaz$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Form gönderimi sessizce iptal edilir ve hiçbir şey loglanmaz$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does event.type give you inside an event handler?$$,
           NULL, NULL,
           $$event.type gives you the kind of event -- "click", "change", "submit", and so on.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'events'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The name of the component that rendered the element$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$The kind of event that occurred, like "click", "change", or "submit"$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$The current value of the input the event happened on$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$A count of how many times this handler has run so far$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir event handler içinde event.type sana ne verir?$$,
           NULL, NULL,
           $$event.type sana "click", "change", "submit" gibi olayın türünü verir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'events'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bu handler'ın şu ana kadar kaç kez çalıştığının bir sayımı$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Elementi render eden component'in adı$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$"click", "change" ya da "submit" gibi gerçekleşen olayın türü$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Olayın gerçekleştiği input'un mevcut değeri$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about React's event handling, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$Every event handler automatically receives an event object; onClick={f} passes the function itself (React calls it later); event.target gives you the DOM element the event happened on.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'events'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$event.target gives you the DOM element the event happened on$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$preventDefault() is required on every single event handler, including onClick$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Every event handler automatically receives an event object from React$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$onClick={f} hands over the function itself, and React calls it for you at the right time$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, React'in event handling'i ile ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Her event handler otomatik olarak React'ten bir event nesnesi alır; onClick={f}, fonksiyonun kendisini verir (React onu daha sonra çağırır); event.target, olayın gerçekleştiği DOM elementini verir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'events'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Her event handler otomatik olarak React'ten bir event nesnesi alır$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$onClick={f}, fonksiyonun kendisini verir, ve React onu doğru zamanda senin için çağırır$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$event.target, olayın gerçekleştiği DOM elementini verir$$, TRUE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$preventDefault(), onClick dahil her tek event handler'da zorunludur$$, FALSE, 3 FROM new_question_tr7;
