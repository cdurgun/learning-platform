-- Promotion batch
-- Topic: context-api (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V795-V822 (React Hooks / Forms) and V767-V794
-- (React Components & Props / State & Events), these 14 questions were NOT
-- produced by the n8n generation pipeline, NOT judged by the AI Judge, and
-- NOT ingested via /api/internal/questions/ingest -- per explicit user
-- request, they were hand-authored and independently self-reviewed directly
-- inside a Claude Code session, grounded strictly in content/en/context-api.md
-- and content/tr/context-api.md.
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
           $$What does the value passed to createContext("light") represent?$$,
           NULL, NULL,
           $$The value in the parentheses is the DEFAULT value used when there's no Provider.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'context-api'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The default value used when there's no Provider$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$A CSS theme name applied automatically to every component$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$The name of the Context, used for debugging purposes only$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$A required prop every component using this Context must supply$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$createContext("acik")'a geçirilen değer neyi temsil eder?$$,
           NULL, NULL,
           $$Parantez içindeki değer, hiç Provider olmadığında kullanılan VARSAYILAN değerdir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'context-api'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bu Context'i kullanan her component'in sağlaması gereken zorunlu bir prop$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Hiç Provider olmadığında kullanılan varsayılan değer$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Her component'e otomatik olarak uygulanan bir CSS tema adı$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Yalnızca hata ayıklama amaçlı kullanılan, Context'in adı$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What does <ThemeContext.Provider value="dark"> do?$$,
           NULL, NULL,
           $$It OVERRIDES the context's value to "dark" for the entire tree inside it.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'context-api'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Requires every child component to explicitly opt in with a special prop$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Overrides the context's value to "dark" for the entire tree inside the Provider$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Deletes the context's default value permanently, for the whole application$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Only affects the Provider's direct parent component, not its children$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$<ThemeContext.Provider value="koyu"> ne yapar?$$,
           NULL, NULL,
           $$Provider'ın içindeki tüm ağaç için context'in değerini "koyu"ya GEÇERSİZ KILAR (override eder).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'context-api'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca Provider'ın doğrudan parent component'ini etkiler, çocuklarını değil$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Her child component'in özel bir prop ile açıkça katılım göstermesini gerektirir$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Provider'ın içindeki tüm ağaç için context'in değerini "koyu"ya geçersiz kılar$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Context'in varsayılan değerini tüm uygulama için kalıcı olarak siler$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$ThemedButton calls useContext(ThemeContext). What value does it read?$$,
           $$const ThemeContext = createContext("light");

function App() {
    return (
        <ThemeContext.Provider value="dark">
            <ThemedButton />
        </ThemeContext.Provider>
    );
}

function ThemedButton() {
    const theme = useContext(ThemeContext);
    return <button className={theme}>Click</button>;
}$$, $$jsx$$,
           $$useContext(ThemeContext) reads the value from the nearest Provider -- since ThemedButton is inside a Provider with value="dark", it reads "dark", not the createContext default.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'context-api'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$undefined, since ThemedButton is a child, not the Provider itself$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Both "light" and "dark" are returned together as an array$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$"light", the default value from createContext$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$"dark", the value from the nearest Provider$$, TRUE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$TemaliButon, useContext(TemaContext)'i çağırıyor. Hangi değeri okur?$$,
           $$const TemaContext = createContext("acik");

function App() {
    return (
        <TemaContext.Provider value="koyu">
            <TemaliButon />
        </TemaContext.Provider>
    );
}

function TemaliButon() {
    const tema = useContext(TemaContext);
    return <button className={tema}>Tikla</button>;
}$$, $$jsx$$,
           $$useContext(TemaContext), en yakın Provider'dan değeri okur -- TemaliButon, value="koyu" olan bir Provider'ın içinde olduğu için, createContext varsayılanını değil "koyu"yu okur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'context-api'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$createContext'ten gelen varsayılan değer olan "acik"$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$TemaliButon Provider'ın kendisi değil bir çocuğu olduğu için undefined$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Hem "acik" hem "koyu" birlikte bir dizi olarak döndürülür$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$En yakın Provider'dan gelen değer olan "koyu"$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$There is no Provider anywhere in this tree at all. What value does useContext(ThemeContext) return inside ThemedButton?$$,
           $$const ThemeContext = createContext("light");

function App() {
    return <ThemedButton />; // no Provider anywhere
}

function ThemedButton() {
    const theme = useContext(ThemeContext);
    return <button className={theme}>Click</button>;
}$$, $$jsx$$,
           $$A Provider isn't always required -- without one, useContext returns the default value given to createContext, which is "light" here.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'context-api'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$"light" -- the default value given to createContext is used when there's no Provider$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$It throws a runtime error immediately, since a Provider is always mandatory$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$null, since Context requires an explicit Provider to function at all$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$undefined, since there's no Provider to read from$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu ağaçta hiçbir yerde hiç Provider yok. TemaliButon içinde useContext(TemaContext) hangi değeri döndürür?$$,
           $$const TemaContext = createContext("acik");

function App() {
    return <TemaliButon />; // hicbir yerde Provider yok
}

function TemaliButon() {
    const tema = useContext(TemaContext);
    return <button className={tema}>Tikla</button>;
}$$, $$jsx$$,
           $$Bir Provider her zaman gerekli değildir -- olmadan, useContext, createContext'e verilen varsayılan değeri döndürür, bu da burada "acik"tır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'context-api'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$"acik" -- Provider olmadığında createContext'e verilen varsayılan değer kullanılır$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Okuyacağı bir Provider olmadığı için undefined$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Bir Provider her zaman zorunlu olduğu için hemen bir çalışma zamanı hatası fırlatır$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Context'in çalışması için her zaman açık bir Provider gerektirdiği için null$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does value={{ items, addItem }} give the Provider?$$,
           NULL, NULL,
           $$value={{ items, addItem }} gives the Provider an OBJECT -- both the current items list and the addItem function that updates it. This is the most common way Context is used in real applications.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'context-api'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$An object carrying both the current items list and the addItem function that updates it$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Only the items list -- functions can never be passed through Context$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$A string combining items and addItem into one piece of text$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Two separate, unrelated Contexts created at once$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$value={{ items, addItem }}, Provider'a ne verir?$$,
           NULL, NULL,
           $$value={{ items, addItem }}, Provider'a bir NESNE verir -- hem mevcut items listesini hem de onu güncelleyen addItem fonksiyonunu. Bu, Context'in gerçek uygulamalarda kullanılmasının en yaygın yoludur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'context-api'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Aynı anda oluşturulan iki ayrı, ilgisiz Context$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Hem mevcut items listesini hem de onu güncelleyen addItem fonksiyonunu taşıyan bir nesne$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Yalnızca items listesini -- fonksiyonlar Context aracılığıyla asla geçirilemez$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$items ve addItem'ı tek bir metin parçasında birleştiren bir string$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe wrapping Context in a custom hook like useTheme(), according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$useTheme() wraps useContext(ThemeContext) to expose a cleaner API -- the consuming component calls useTheme() without dealing with the concept of "context"; throwing an error when used outside a Provider catches misuse early.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'context-api'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Wrapping Context in a custom hook is required syntax and won't work without it$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$useTheme() wraps useContext(ThemeContext) to expose a cleaner API to the consuming component$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Throwing an error when the hook is used outside a Provider catches misuse early$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$A custom hook wrapping Context can never itself call useContext$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, Context'i useTheme() gibi bir custom hook içine sarmalamayı aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$useTheme(), tüketen component'e daha temiz bir API sunmak için useContext(ThemeContext)'i sarmalar; bir Provider dışında kullanıldığında hata fırlatmak, yanlış kullanımı erken yakalar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'context-api'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hook bir Provider dışında kullanıldığında hata fırlatmak, yanlış kullanımı erken yakalar$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Context'i sarmalayan bir custom hook'un kendisi asla useContext çağıramaz$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Context'i bir custom hook'a sarmalamak zorunlu bir sözdizimidir ve onsuz çalışmaz$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$useTheme(), tüketen component'e daha temiz bir API sunmak için useContext(ThemeContext)'i sarmalar$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about how Context solves the props-drilling problem from Sharing State, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$None of Level1, Level2, Level3 even know about the user prop anymore -- only Level4, at the very bottom, reads it directly from UserContext; nothing needs to be passed through the intermediate layers.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'context-api'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Context still requires every intermediate component to explicitly forward the value as a prop$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Context replaces the need for a Provider anywhere in the tree$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Intermediate levels no longer need to know about the value at all$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Only the component that actually needs the value reads it directly from Context$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, Context'in Sharing State'teki props drilling sorununu nasıl çözdüğünü aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Level1, Level2, Level3'ün hiçbiri artık user prop'undan haberdar değildir -- yalnızca en altta olan Level4 onu doğrudan UserContext'ten okur; ara katmanlar aracılığıyla hiçbir şeyin geçirilmesine gerek yoktur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'context-api'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Ara seviyelerin artık değerden hiç haberdar olmasına gerek yoktur$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Yalnızca değere gerçekten ihtiyaç duyan component onu doğrudan Context'ten okur$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Context, hâlâ her ara component'in değeri açıkça bir prop olarak iletmesini gerektirir$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Context, ağaçtaki herhangi bir yerde bir Provider ihtiyacını ortadan kaldırır$$, FALSE, 3 FROM new_question_tr7;
