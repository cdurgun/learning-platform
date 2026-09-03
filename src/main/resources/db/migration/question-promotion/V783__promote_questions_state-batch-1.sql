-- Promotion batch
-- Topic: state (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V731-V766 (Spring Data JPA) and V715-V730
-- (Advanced Spring), these 14 questions were NOT produced by the n8n
-- generation pipeline, NOT judged by the AI Judge, and NOT ingested via
-- /api/internal/questions/ingest -- per explicit user request, they were
-- hand-authored and independently self-reviewed directly inside a Claude Code
-- session, grounded strictly in content/en/state.md and
-- content/tr/state.md.
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
           $$What is state?$$,
           NULL, NULL,
           $$State is data a component "remembers" that can change over time; when state changes, React automatically re-renders that component.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'state'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Data a component "remembers" that can change over time, triggering a re-render when it changes$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Data sent into a component from its parent, that never changes$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$A CSS class describing a component's current visual style$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$The HTML markup a component was originally written with$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$State nedir?$$,
           NULL, NULL,
           $$State, bir component'in zamanla değişebilen, "hatırladığı" verisidir; state değiştiğinde React o component'i otomatik olarak yeniden render eder.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'state'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir component'in orijinal olarak yazıldığı HTML işaretlemesi$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir component'in zamanla değişebilen, "hatırladığı" verisi, değiştiğinde bir yeniden render tetikler$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir component'in parent'ından aldığı, asla değişmeyen veri$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir component'in mevcut görsel stilini tanımlayan bir CSS class'ı$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (CODE_OUTPUT, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What do count and setCount represent in this code?$$,
           $$const [count, setCount] = useState(0);$$, $$jsx$$,
           $$useState(0) sets up state with an initial value of 0 and returns two things: the current value (count) and a function to update it (setCount).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'state'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$count is the component's name; setCount is its props object$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$count is the current state value; setCount is the function used to update it$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$count is a function; setCount is the current value$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Both count and setCount are read-only copies of the same initial value$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu koddaki sayi ve sayiAyarla neyi temsil eder?$$,
           $$const [sayi, sayiAyarla] = useState(0);$$, $$jsx$$,
           $$useState(0), başlangıç değeri 0 olan bir state kurar ve iki şey döndürür: mevcut değer (sayi) ve onu güncellemek için bir fonksiyon (sayiAyarla).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'state'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$sayi ve sayiAyarla'nın ikisi de aynı başlangıç değerinin salt okunur kopyalarıdır$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$sayi component'in adıdır; sayiAyarla onun props nesnesidir$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$sayi mevcut state değeridir; sayiAyarla onu güncellemek için kullanılan fonksiyondur$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$sayi bir fonksiyondur; sayiAyarla mevcut değerdir$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What happens when this button is clicked?$$,
           $$function Counter() {
    const [count, setCount] = useState(0);

    function handleClick() {
        count = count + 1; // direct assignment, not setCount
    }

    return <button onClick={handleClick}>{count}</button>;
}$$, $$jsx$$,
           $$Directly assigning to count doesn't tell React "something changed," so it doesn't re-render -- the displayed number never updates (and this line would actually throw, since count declared via useState can't be reassigned this way).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'state'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$React automatically converts the direct assignment into a setCount call behind the scenes$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$The component immediately unmounts when handleClick runs$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$The displayed number increases by 1 every time the button is clicked$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Direct assignment doesn't notify React of a change, so the screen never updates to show a new value$$, TRUE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu düğmeye tıklandığında ne olur?$$,
           $$function Sayac() {
    const [sayi, sayiAyarla] = useState(0);

    function handleClick() {
        sayi = sayi + 1; // dogrudan atama, sayiAyarla degil
    }

    return <button onClick={handleClick}>{sayi}</button>;
}$$, $$jsx$$,
           $$sayi'ya doğrudan atama yapmak React'e "bir şey değişti" demez, bu yüzden yeniden render olmaz -- gösterilen sayı asla güncellenmez (ve bu satır aslında hata fırlatır, çünkü useState ile tanımlanan sayi bu şekilde yeniden atanamaz).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'state'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Düğmeye her tıklandığında gösterilen sayı 1 artar$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$React, doğrudan atamayı perde arkasında otomatik olarak bir sayiAyarla çağrısına dönüştürür$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$handleClick çalıştığında component hemen unmount olur$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Doğrudan atama React'e bir değişiklik olduğunu bildirmez, bu yüzden ekran yeni bir değeri göstermek için asla güncellenmez$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Inside a single click handler, setCount(count + 1) is called twice in a row. What is the result compared to calling setCount((prevCount) => prevCount + 1) twice?$$,
           $$function handleClick() {
    setCount(count + 1);
    setCount(count + 1);
    // vs:
    // setCount((prevCount) => prevCount + 1);
    // setCount((prevCount) => prevCount + 1);
}$$, $$jsx$$,
           $$setCount(count + 1) isn't reliable if called more than once within the same render, because count stays fixed for that entire render -- both calls use the same starting value. The functional form calculates based on the most recent value each time.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'state'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$setCount(count + 1) twice may not increase the count by 2, since count stays fixed for that render; the functional form reliably does$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$The functional form is invalid syntax and throws an error$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$setCount(count + 1) is always more reliable than the functional form$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Both forms always increase the count by exactly 2, with no difference between them$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Tek bir click handler içinde, sayiAyarla(sayi + 1) art arda iki kez çağrılıyor. Bunu sayiAyarla((oncekiSayi) => oncekiSayi + 1)'i iki kez çağırmakla karşılaştırınca sonuç nedir?$$,
           $$function handleClick() {
    sayiAyarla(sayi + 1);
    sayiAyarla(sayi + 1);
    // buna karsi:
    // sayiAyarla((oncekiSayi) => oncekiSayi + 1);
    // sayiAyarla((oncekiSayi) => oncekiSayi + 1);
}$$, $$jsx$$,
           $$sayiAyarla(sayi + 1), aynı render içinde birden fazla çağrılırsa güvenilir değildir, çünkü sayi o render boyunca sabit kalır -- her iki çağrı da aynı başlangıç değerini kullanır. Fonksiyonel biçim her seferinde en güncel değere göre hesaplar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'state'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$sayiAyarla(sayi + 1), fonksiyonel biçimden her zaman daha güvenilirdir$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$İki biçim de her zaman sayıyı tam olarak 2 artırır, aralarında hiçbir fark yoktur$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$sayiAyarla(sayi + 1)'i iki kez çağırmak sayıyı 2 artırmayabilir, çünkü sayi o render boyunca sabit kalır; fonksiyonel biçim güvenilir şekilde artırır$$, TRUE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Fonksiyonel biçim geçersiz bir sözdizimidir ve hata fırlatır$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why doesn't changing a regular variable declared with let update the screen, the way changing state does?$$,
           NULL, NULL,
           $$Since React doesn't know about a regular variable's change, it doesn't re-render the component -- useState is special because it tells React "let me know when this value changes."$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'state'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Because let variables are always read-only in JavaScript$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Because React doesn't know about the change, so it has no reason to re-render the component$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Because let variables can only hold numbers, never other data types$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$There's no real difference -- both update the screen identically$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$let ile tanımlanan sıradan bir değişkeni değiştirmek, state değiştirmenin yaptığı gibi ekranı neden güncellemez?$$,
           NULL, NULL,
           $$React, sıradan bir değişkenin değişikliğinden haberdar olmadığı için, component'i yeniden render etmesi için bir nedeni yoktur -- useState özeldir çünkü React'e "bu değer değiştiğinde bana haber ver" der.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'state'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Gerçek bir fark yoktur -- ikisi de ekranı aynı şekilde günceller$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Çünkü React değişiklikten haberdar olmadığı için, component'i yeniden render etmesi için bir nedeni yoktur$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Çünkü let değişkenleri JavaScript'te her zaman salt okunurdur$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Çünkü let değişkenleri yalnızca sayı tutabilir, başka veri tipleri tutamaz$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe state immutability for object/array state? (Select all that apply)$$,
           NULL, NULL,
           $$You should always create a NEW object/array instead of mutating the existing one; the spread operator copies all fields into a new object, changing only the specified field; directly mutating and passing back the same object doesn't guarantee React notices the change.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'state'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$State immutability only applies to arrays, never to plain objects$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$You should always create a new object/array and pass that to the setter, instead of mutating the existing one$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$The spread operator ({ ...user, age: ... }) copies all fields of the old object into a new one, changing only the specified field$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Directly mutating an object and passing back that same object always guarantees React re-renders correctly$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Nesne/dizi state'i için state immutability'sini aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Mevcut olanı mutate etmek yerine her zaman YENİ bir nesne/dizi oluşturmalısın; spread operatörü, yalnızca belirtilen alanı değiştirerek eski nesnenin tüm alanlarını yeni birine kopyalar; bir nesneyi doğrudan mutate edip aynı nesneyi geri vermek React'in değişikliği fark edeceğini garanti etmez.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'state'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Spread operatörü ({ ...user, age: ... }), yalnızca belirtilen alanı değiştirerek eski nesnenin tüm alanlarını yeni birine kopyalar$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir nesneyi doğrudan mutate edip aynı nesneyi geri vermek, React'in her zaman doğru şekilde yeniden render edeceğini garanti eder$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$State immutability yalnızca dizilere uygulanır, sıradan nesnelere asla uygulanmaz$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Mevcut olanı mutate etmek yerine her zaman yeni bir nesne/dizi oluşturup onu setter'a geçirmelisin$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe what happens when setCount(...) is called? (Select all that apply)$$,
           NULL, NULL,
           $$React saves the new value of the state, and it re-renders the component with that new value -- both happen together as a result of calling the setter.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'state'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Calling setCount(...) immediately mutates the count variable in place, without a re-render$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$setCount(...) can only be called from inside a JSX expression, never from a regular function$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$React saves the new value of the state$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$React re-renders the component with the new value$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$sayiAyarla(...) çağrıldığında ne olduğunu aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$React, state'in yeni değerini kaydeder ve component'i o yeni değerle yeniden render eder -- ikisi de setter'ı çağırmanın bir sonucu olarak birlikte gerçekleşir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'state'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$React, state'in yeni değerini kaydeder$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$React, component'i yeni değerle yeniden render eder$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$sayiAyarla(...)'yı çağırmak, bir yeniden render olmadan sayi değişkenini yerinde hemen mutate eder$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$sayiAyarla(...), yalnızca bir JSX ifadesinin içinden çağrılabilir, sıradan bir fonksiyondan asla çağrılamaz$$, FALSE, 3 FROM new_question_tr7;
