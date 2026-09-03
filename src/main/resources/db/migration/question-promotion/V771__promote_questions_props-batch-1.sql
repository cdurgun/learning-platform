-- Promotion batch
-- Topic: props (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V731-V766 (Spring Data JPA) and V715-V730
-- (Advanced Spring), these 14 questions were NOT produced by the n8n
-- generation pipeline, NOT judged by the AI Judge, and NOT ingested via
-- /api/internal/questions/ingest -- per explicit user request, they were
-- hand-authored and independently self-reviewed directly inside a Claude Code
-- session, grounded strictly in content/en/props.md and
-- content/tr/props.md.
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
           $$What are props?$$,
           NULL, NULL,
           $$Props are how you send data into a component from outside -- much like giving an HTML tag an attribute, except the value reaches the component function as a parameter.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'props'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A way to send data into a component from outside, like giving it an attribute$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$A component's internal data that changes over time$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$A special CSS styling mechanism for components$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$A function that runs automatically when a component unmounts$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Props nedir?$$,
           NULL, NULL,
           $$Props, bir component'e dışarıdan veri göndermenin yoludur -- bir HTML tag'ine attribute vermeye çok benzer, ama değer component fonksiyonuna bir parametre olarak ulaşır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'props'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir component unmount olduğunda otomatik çalışan bir fonksiyon$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir component'e dışarıdan, ona attribute verir gibi veri gönderme yolu$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir component'in zamanla değişen dahili verisi$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Component'ler için özel bir CSS stillendirme mekanizması$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$If App renders <Greeting name="Ayşe" />, what relationship does this establish?$$,
           NULL, NULL,
           $$App is the parent component using Greeting (the child), and this sends Greeting a prop named name with the value "Ayşe".$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'props'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$This is invalid syntax -- props can only be passed as a separate function call$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$App is the parent, Greeting is the child, and Greeting receives a prop named name$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Greeting is the parent, App is the child$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$This creates a new state variable named name inside App$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$App, <Greeting name="Ayşe" />'yi render ediyorsa, bu hangi ilişkiyi kurar?$$,
           NULL, NULL,
           $$App, Greeting'i (child) kullanan parent'tır ve bu, Greeting'e "Ayşe" değerine sahip name adında bir prop gönderir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'props'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bu, App içinde name adında yeni bir state değişkeni oluşturur$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Bu geçersiz bir sözdizimidir -- props yalnızca ayrı bir fonksiyon çağrısı olarak geçirilebilir$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$App parent'tır, Greeting child'tır ve Greeting name adında bir prop alır$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Greeting parent'tır, App child'tır$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this rendering, how does UserCard access the city value?$$,
           $$<UserCard name="Ali" age={30} city="Ankara" />

function UserCard(props) {
    return <p>{props.city}</p>;
}$$, $$jsx$$,
           $$Each prop reaches the component as its own field on the props object -- so city is read as props.city, printing "Ankara".$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'props'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$props.name.city, since props are nested$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$It cannot access city at all without destructuring first$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$props.city, which prints "Ankara"$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$props[2], since city is the third attribute written$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu render'a göre, KullaniciKarti sehir değerine nasıl erişir?$$,
           $$<KullaniciKarti ad="Ali" yas={30} sehir="Ankara" />

function KullaniciKarti(props) {
    return <p>{props.sehir}</p>;
}$$, $$jsx$$,
           $$Her prop, props nesnesinde kendi alanı olarak component'e ulaşır -- bu yüzden sehir, props.sehir olarak okunur ve "Ankara" yazdırılır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'props'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$props[2], çünkü sehir yazılan üçüncü attribute'tur$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$props.ad.sehir, çünkü props'lar iç içedir$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Önce destructuring yapmadan sehir'e hiç erişemez$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$props.sehir, bu da "Ankara" yazdırır$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$function Greeting({ name }) { return <p>{name}</p>; } compared to function Greeting(props) { return <p>{props.name}</p>; } -- what is the relationship between these two?$$,
           NULL, NULL,
           $$Both versions do exactly the same thing -- destructuring just removes the repeated props. and makes the code a bit shorter.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'props'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The destructured version is faster at runtime because it skips creating a props object$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$The destructured version can only read one prop total, never more$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$They behave differently -- destructuring makes the prop mutable$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$They do exactly the same thing -- destructuring is just a shorter way to write the same access$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$function Selamla({ ad }) { return <p>{ad}</p>; } ile function Selamla(props) { return <p>{props.ad}</p>; } karşılaştırıldığında, bu ikisi arasındaki ilişki nedir?$$,
           NULL, NULL,
           $$İki versiyon da tam olarak aynı şeyi yapar -- destructuring yalnızca tekrarlanan props.'u kaldırır ve kodu biraz kısaltır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'props'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Tam olarak aynı şeyi yaparlar -- destructuring yalnızca aynı erişimi yazmanın daha kısa bir yoludur$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Destructured versiyon, bir props nesnesi oluşturmayı atladığı için çalışma zamanında daha hızlıdır$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Destructured versiyon toplamda yalnızca bir prop okuyabilir, asla daha fazlasını okuyamaz$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Farklı davranırlar -- destructuring prop'u mutable yapar$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does this render?$$,
           $$function Greeting({ name = "Guest" }) {
    return <p>Hello, {name}!</p>;
}

<Greeting />$$, $$jsx$$,
           $$Since name isn't sent at all, the default value "Guest" defined in the destructuring is used.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'props'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hello, undefined!$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Hello, Guest!$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Nothing renders, since name is required$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$It throws a runtime error, since no value was provided for name$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu ne render eder?$$,
           $$function Selamla({ ad = "Misafir" }) {
    return <p>Merhaba, {ad}!</p>;
}

<Selamla />$$, $$jsx$$,
           $$ad hiç gönderilmediği için, destructuring içinde tanımlanan varsayılan değer "Misafir" kullanılır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'props'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$ad için hiçbir değer sağlanmadığından çalışma zamanı hatası fırlatır$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Merhaba, Misafir!$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Merhaba, undefined!$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Hiçbir şey render edilmez, çünkü ad zorunludur$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$According to this lesson, should a component ever directly change a prop it received?$$,
           NULL, NULL,
           $$No -- props are read-only; a component should never change a prop it receives. If data needs to change over time, that's what state is for.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'props'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Only inside an event handler function$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Yes -- reassigning a prop's value is the normal way to update it$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$No -- props are read-only; a component should never change a prop it receives$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Only if the prop is a number, not a string$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir component aldığı bir prop'u doğrudan hiç değiştirmeli midir?$$,
           NULL, NULL,
           $$Hayır -- props salt okunurdur (read-only); bir component aldığı bir prop'u asla değiştirmemelidir. Veri zaman içinde değişmesi gerekiyorsa, bunun için state vardır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'props'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca prop bir sayıysa, string değilse$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Yalnızca bir event handler fonksiyonu içinde$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Hayır -- props salt okunurdur; bir component aldığı bir prop'u asla değiştirmemelidir$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Evet -- bir prop'un değerini yeniden atamak onu güncellemenin normal yoludur$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe the relationship between props and a regular function parameter? (Select all that apply)$$,
           NULL, NULL,
           $$Props are nothing more than a regular function parameter -- there's no special mechanism from React here; the difference is only in how you "call" the function (JSX tag syntax vs a normal function call).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'props'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Props require a completely separate mechanism unrelated to how JavaScript functions normally receive arguments$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Calling a component function directly, like Greeting({name: "Ayşe"}), is invalid JavaScript and always throws$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Props are nothing more than a regular function parameter -- no special React mechanism is involved$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$You'd call a normal function as Greeting({ name: "Ayşe" }), while you "call" a component in JSX as <Greeting name="Ayşe" />$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri props ile sıradan bir fonksiyon parametresi arasındaki ilişkiyi doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Props, sıradan bir fonksiyon parametresinden başka bir şey değildir -- burada React'e özgü bir mekanizma yoktur; fark yalnızca fonksiyonu nasıl "çağırdığındadır" (JSX tag sözdizimi ile normal fonksiyon çağrısı).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'props'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Props, sıradan bir fonksiyon parametresinden başka bir şey değildir -- özel bir React mekanizması söz konusu değildir$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Normal bir fonksiyonu Selamla({ ad: "Ayşe" }) olarak çağırırsın, JSX içinde bir component'i ise <Selamla ad="Ayşe" /> olarak "çağırırsın"$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Props, JavaScript fonksiyonlarının normalde argüman almasıyla hiç ilgisi olmayan, tamamen ayrı bir mekanizma gerektirir$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir component fonksiyonunu Selamla({ad: "Ayşe"}) gibi doğrudan çağırmak geçersiz JavaScript'tir ve her zaman hata fırlatır$$, FALSE, 3 FROM new_question_tr7;
