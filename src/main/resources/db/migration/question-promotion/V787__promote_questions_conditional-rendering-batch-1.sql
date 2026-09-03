-- Promotion batch
-- Topic: conditional-rendering (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V731-V766 (Spring Data JPA) and V715-V730
-- (Advanced Spring), these 14 questions were NOT produced by the n8n
-- generation pipeline, NOT judged by the AI Judge, and NOT ingested via
-- /api/internal/questions/ingest -- per explicit user request, they were
-- hand-authored and independently self-reviewed directly inside a Claude Code
-- session, grounded strictly in content/en/conditional-rendering.md and
-- content/tr/conditional-rendering.md.
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
           $$Can an if statement be written directly inside JSX's curly braces { }?$$,
           NULL, NULL,
           $$No -- if can't be written directly inside JSX's { }, but you can use it BEFORE return, to decide the value of a regular JavaScript variable.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'conditional-rendering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yes -- if works exactly like any other expression inside { }$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$No -- if can't go inside { }, but it can be used before return to decide a variable's value$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Only inside a ternary expression, never on its own$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Only when the component is a class component, not a function component$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir if ifadesi JSX'in süslü parantezlerinin { } içine doğrudan yazılabilir mi?$$,
           NULL, NULL,
           $$Hayır -- if, JSX'in { }'inin içine doğrudan yazılamaz, ama return'DEN ÖNCE, sıradan bir JavaScript değişkeninin değerine karar vermek için kullanılabilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'conditional-rendering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca component bir class component ise, function component ise değil$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Hayır -- if, { }'in içine giremez, ama bir değişkenin değerine karar vermek için return'den önce kullanılabilir$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Evet -- if, { } içindeki başka herhangi bir ifade gibi tam olarak çalışır$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Yalnızca bir ternary ifadesinin içinde, tek başına asla$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Why can a ternary (? :) be written directly inside JSX's { }, unlike if?$$,
           NULL, NULL,
           $$A ternary produces a value, so it can be written directly inside { } -- unlike if, which is a statement, not an expression that produces a value.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'conditional-rendering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$There's no real difference -- both work identically inside { }$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Because a ternary produces a value, which is exactly what { } needs$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Because ternaries are a special JSX-only feature unrelated to JavaScript$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Because if is deprecated in modern JavaScript, but ternaries are not$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir ternary (? :), if'in aksine, JSX'in { }'inin içine neden doğrudan yazılabilir?$$,
           NULL, NULL,
           $$Bir ternary bir değer üretir, bu da tam olarak { }'in ihtiyaç duyduğu şeydir -- bir ifade (statement) olan, değer üretmeyen if'in aksine.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'conditional-rendering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çünkü if modern JavaScript'te kullanımdan kaldırılmıştır, ama ternary'ler kaldırılmamıştır$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Gerçek bir fark yoktur -- ikisi de { } içinde birebir aynı şekilde çalışır$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Çünkü bir ternary bir değer üretir, bu da tam olarak { }'in ihtiyaç duyduğu şeydir$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Çünkü ternary'ler JavaScript ile ilgisi olmayan, yalnızca JSX'e özgü özel bir özelliktir$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What is the && operator used for in conditional rendering, as opposed to a ternary?$$,
           NULL, NULL,
           $$A ternary is for choosing between two options (this OR that); && is for choosing between "show something" and "show nothing at all."$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'conditional-rendering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Running two independent event handlers at the same time$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Combining two separate state variables into a single one$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Choosing between "show something" and "show nothing at all"$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Choosing between two entirely different components, never a single element$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir ternary'nin aksine, && operatörü conditional rendering'de ne için kullanılır?$$,
           NULL, NULL,
           $$Bir ternary iki seçenek arasında seçim yapmak içindir (bu YA DA şu); && ise "bir şey göster" ile "hiçbir şey gösterme" arasında seçim yapmak içindir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'conditional-rendering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Tamamen farklı iki component arasında seçim yapmak, asla tek bir element için değil$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Aynı anda iki bağımsız event handler'ı çalıştırmak$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$İki ayrı state değişkenini tek birinde birleştirmek$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$"Bir şey göster" ile "hiçbir şey gösterme" arasında seçim yapmak$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$hasNewMessage is the number 0. What does this render?$$,
           $$function Notification({ hasNewMessage }) {
    return <div>{hasNewMessage && <p>You have a new message!</p>}</div>;
}

<Notification hasNewMessage={0} />$$, $$jsx$$,
           $$Since 0 is falsy but still a renderable value inside JSX, 0 && <p>...</p> actually renders the literal text "0" on screen, not nothing.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'conditional-rendering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The literal text "0" is rendered on screen$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$The <p>You have a new message!</p> text renders anyway$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$React throws an error, since hasNewMessage must be a boolean$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Nothing renders at all, since 0 is falsy$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$yeniMesajVar, 0 sayısıdır. Bu ne render eder?$$,
           $$function Bildirim({ yeniMesajVar }) {
    return <div>{yeniMesajVar && <p>Yeni bir mesajin var!</p>}</div>;
}

<Bildirim yeniMesajVar={0} />$$, $$jsx$$,
           $$0 falsy olsa da JSX içinde hâlâ render edilebilir bir değer olduğu için, yeniMesajVar && <p>...</p> ekranda hiçbir şey değil, gerçekten literal "0" metnini render eder.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'conditional-rendering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Ekranda literal "0" metni render edilir$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$0 falsy olduğu için hiçbir şey render edilmez$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$<p>Yeni bir mesajin var!</p> metni yine de render edilir$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$yeniMesajVar boolean olması gerektiği için React bir hata fırlatır$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$isLoading is false. What does this component render?$$,
           $$function LoadingMessage() { return <p>Loading...</p>; }
function WelcomeMessage() { return <p>Welcome!</p>; }

function Status({ isLoading }) {
    return isLoading ? <LoadingMessage /> : <WelcomeMessage />;
}

<Status isLoading={false} />$$, $$jsx$$,
           $$Since isLoading is false, the ternary picks the second branch, WelcomeMessage -- an entirely different component, not just different text.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'conditional-rendering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$LoadingMessage's "Loading..." text$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$WelcomeMessage's "Welcome!" text$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Both LoadingMessage and WelcomeMessage render together$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Neither renders, since isLoading is falsy$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$yukleniyor false. Bu component ne render eder?$$,
           $$function YuklemeMesaji() { return <p>Yukleniyor...</p>; }
function HosgeldinMesaji() { return <p>Hosgeldin!</p>; }

function Durum({ yukleniyor }) {
    return yukleniyor ? <YuklemeMesaji /> : <HosgeldinMesaji />;
}

<Durum yukleniyor={false} />$$, $$jsx$$,
           $$yukleniyor false olduğu için, ternary ikinci dalı seçer, HosgeldinMesaji -- yalnızca farklı bir metin değil, tamamen farklı bir component.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'conditional-rendering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$yukleniyor falsy olduğu için hiçbiri render edilmez$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$HosgeldinMesaji'nın "Hosgeldin!" metni$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$YuklemeMesaji'nın "Yukleniyor..." metni$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$YuklemeMesaji ve HosgeldinMesaji birlikte render edilir$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following values are falsy, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$false, 0, "", null, and undefined are falsy -- everything else is truthy.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'conditional-rendering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$"0" (the string containing a zero character)$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$0$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$"" (an empty string)$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$null$$, TRUE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, aşağıdaki değerlerden hangileri falsy'dir? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$false, 0, "", null ve undefined falsy'dir -- geri kalan her şey truthy'dir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'conditional-rendering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$"" (boş bir string)$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$"0" (sıfır karakteri içeren string)$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$null$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$0$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly match a conditional rendering technique to its use case, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$if is used outside JSX (before return) to decide a variable's value; a ternary is used inside JSX between two options; && is for "show it or show nothing"; you can also return entirely different components based on a condition.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'conditional-rendering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$You can return entirely different components based on a condition, not just different text$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$&& is used specifically for choosing between two different components, the same role as a ternary$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$if is used outside JSX, before return, to decide a variable's value$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$A ternary is used inside JSX to choose between two options$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, aşağıdakilerden hangileri bir conditional rendering tekniğini kullanım amacıyla doğru şekilde eşleştirir? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$if, JSX dışında, return'den önce, bir değişkenin değerine karar vermek için kullanılır; bir ternary, JSX içinde iki seçenek arasında seçim yapmak için kullanılır; && "göster ya da hiçbir şey gösterme" içindir; koşula bağlı olarak tamamen farklı component'ler de döndürebilirsin.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'conditional-rendering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$if, JSX dışında, return'den önce, bir değişkenin değerine karar vermek için kullanılır$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir ternary, JSX içinde iki seçenek arasında seçim yapmak için kullanılır$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$&&, tıpkı bir ternary gibi, özellikle iki farklı component arasında seçim yapmak için kullanılır$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Yalnızca farklı metin değil, koşula bağlı olarak tamamen farklı component'ler de döndürebilirsin$$, TRUE, 3 FROM new_question_tr7;
