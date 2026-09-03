-- Promotion batch
-- Topic: use-ref (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V767-V794 (React Components & Props / State &
-- Events) and V731-V766 (Spring Data JPA), these 14 questions were NOT
-- produced by the n8n generation pipeline, NOT judged by the AI Judge, and
-- NOT ingested via /api/internal/questions/ingest -- per explicit user
-- request, they were hand-authored and independently self-reviewed directly
-- inside a Claude Code session, grounded strictly in content/en/use-ref.md
-- and content/tr/use-ref.md.
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
           $$What does writing ref={inputRef} on a JSX element actually do?$$,
           NULL, NULL,
           $$It tells React "put this element's real DOM node into inputRef.current" -- inputRef.current becomes a real DOM element you can call browser methods on, like focus().$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-ref'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It tells React to put that element's real DOM node into inputRef.current$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$It creates a new state variable that re-renders whenever the input changes$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It attaches a CSS style directly to the element$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$It passes the element as a prop to a child component automatically$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir JSX elementine ref={inputRef} yazmak gerçekte ne yapar?$$,
           NULL, NULL,
           $$React'e "bu elementin gerçek DOM node'unu inputRef.current'a koy" der -- inputRef.current, focus() gibi tarayıcı metotlarını çağırabileceğin gerçek bir DOM elementi olur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-ref'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Elementi otomatik olarak bir child component'e prop olarak geçirir$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$React'e o elementin gerçek DOM node'unu inputRef.current'a koymasını söyler$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Input değiştiğinde her zaman yeniden render olan yeni bir state değişkeni oluşturur$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Elemente doğrudan bir CSS stili ekler$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Does incrementing renderCount.current on every render, by itself, trigger a re-render?$$,
           NULL, NULL,
           $$No -- renderCount.current increases and its value persists across renders, but that increase doesn't trigger a re-render on its own; you only see the updated value on the next render, triggered for some other reason.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-ref'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It depends on whether useEffect is also used in the same component$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$No -- the increase doesn't trigger a re-render on its own$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Yes -- any change to a ref's .current value always triggers a re-render$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Yes, but only on every third render$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Her render'da renderSayaci.current'ı artırmak, tek başına, bir yeniden render tetikler mi?$$,
           NULL, NULL,
           $$Hayır -- renderSayaci.current artar ve değeri render'lar arasında kalıcıdır, ama bu artış tek başına bir yeniden render tetiklemez; güncellenen değeri yalnızca başka bir nedenle tetiklenen bir sonraki render'da görürsün.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-ref'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Evet, ama yalnızca her üçüncü render'da$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Aynı component'te useEffect'in de kullanılıp kullanılmadığına bağlıdır$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Hayır -- artış tek başına bir yeniden render tetiklemez$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Evet -- bir ref'in .current değerindeki herhangi bir değişiklik her zaman bir yeniden render tetikler$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What is the key difference between useRef and useState, according to this lesson?$$,
           NULL, NULL,
           $$Changing state with useState TRIGGERS a re-render; changing a ref does NOT.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-ref'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$useState is always slower than useRef in every circumstance$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$useRef requires a dependency array, while useState never does$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Changing state with useState triggers a re-render; changing a ref does not$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$useRef can only store numbers, while useState can store any type$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, useRef ile useState arasındaki temel fark nedir?$$,
           NULL, NULL,
           $$useState ile state değiştirmek bir yeniden render TETİKLER; bir ref'i değiştirmek TETİKLEMEZ.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-ref'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$useRef yalnızca sayı saklayabilirken, useState herhangi bir tip saklayabilir$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$useState her koşulda useRef'ten her zaman daha yavaştır$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$useRef bir dependency array gerektirir, useState hiçbir zaman gerektirmez$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$useState ile state değiştirmek bir yeniden render tetikler; bir ref'i değiştirmek tetiklemez$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What happens on screen when the "Increment Ref" button is clicked?$$,
           $$function Counter() {
    const refValue = useRef(0);

    function handleClick() {
        refValue.current = refValue.current + 1;
        console.log(refValue.current);
    }

    return <button onClick={handleClick}>Increment Ref: {refValue.current}</button>;
}$$, $$jsx$$,
           $$The ref's value really does change (visible in the console), but nothing changes on screen -- a ref change doesn't tell React "re-render," so the displayed number stays the same until some other state change causes a re-render.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-ref'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The console logs the new value, but the number shown on the button does not visually update$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Nothing happens at all -- refValue.current never actually changes$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$React throws an error, since refs cannot be mutated inside an event handler$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$The displayed number on the button increases by 1 immediately, as expected$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$"Ref Artir" düğmesine tıklandığında ekranda ne olur?$$,
           $$function Sayac() {
    const refDegeri = useRef(0);

    function handleClick() {
        refDegeri.current = refDegeri.current + 1;
        console.log(refDegeri.current);
    }

    return <button onClick={handleClick}>Ref Artir: {refDegeri.current}</button>;
}$$, $$jsx$$,
           $$Ref'in değeri gerçekten değişir (console'da görülebilir), ama ekranda hiçbir şey değişmez -- bir ref değişikliği React'e "yeniden render et" demez, bu yüzden gösterilen sayı başka bir state değişikliği bir yeniden render'a neden olana kadar aynı kalır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-ref'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Console yeni değeri loglar, ama düğmede gösterilen sayı görsel olarak güncellenmez$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Düğmedeki gösterilen sayı beklendiği gibi hemen 1 artar$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Hiçbir şey olmaz -- refDegeri.current gerçekte hiç değişmez$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Ref'ler bir event handler içinde mutate edilemediği için React bir hata fırlatır$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$According to this lesson's guidance, when should you reach for state versus a ref?$$,
           NULL, NULL,
           $$A value that needs to be VISIBLE on screen should be state; a value that just needs to be "remembered," without appearing on screen, can be a ref.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-ref'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A value that needs to be visible on screen should be state; a "background" value that doesn't need to appear can be a ref$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Refs should always be preferred over state, since they never trigger unnecessary re-renders$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$State and refs are fully interchangeable and the choice never matters$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Refs are only for numbers; state must be used for strings and objects$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu dersin rehberliğine göre, ne zaman state'e, ne zaman bir ref'e başvurmalısın?$$,
           NULL, NULL,
           $$Ekranda GÖRÜNÜR olması gereken bir değer state olmalıdır; ekranda görünmesi gerekmeyen, yalnızca "hatırlanması" gereken bir değer ref olabilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-ref'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Ref'ler yalnızca sayılar içindir; string ve nesneler için state kullanılmalıdır$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Ekranda görünür olması gereken bir değer state olmalıdır; görünmesi gerekmeyen bir "arka plan" değeri ref olabilir$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Ref'ler, gereksiz yeniden render'ları hiç tetiklemediği için her zaman state'e tercih edilmelidir$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$State ve ref'ler tamamen birbirinin yerine geçebilir ve seçim hiçbir zaman önemli değildir$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$count starts at 5, then the component re-renders after count changes to 8. What does previousCountRef.current hold DURING that render, before the effect runs again?$$,
           $$function Tracker({ count }) {
    const previousCountRef = useRef();

    useEffect(() => {
        previousCountRef.current = count;
    });

    return <p>Now: {count}, Before: {previousCountRef.current}</p>;
}
// count changes from 5 to 8, triggering a re-render$$, $$jsx$$,
           $$Since updating a ref doesn't trigger a new render on its own, previousCountRef.current still holds the value from the PREVIOUS render (5) during this render, before the effect (which runs after render) updates it to 8.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-ref'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It's always equal to whatever count currently is, on every render$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$8, because the ref updates immediately when count changes$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$5, the value saved from the previous render, since the effect hasn't run for this render yet$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$undefined, since the ref was never initialized with a starting value$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$sayi 5'ten başlıyor, sonra sayi 8'e değiştikten sonra component yeniden render ediliyor. Effect tekrar çalışmadan önce, O render SIRASINDA oncekiSayiRef.current ne tutar?$$,
           $$function Takipci({ sayi }) {
    const oncekiSayiRef = useRef();

    useEffect(() => {
        oncekiSayiRef.current = sayi;
    });

    return <p>Simdi: {sayi}, Once: {oncekiSayiRef.current}</p>;
}
// sayi 5'ten 8'e degisiyor, bir yeniden render tetikliyor$$, $$jsx$$,
           $$Bir ref'i güncellemek tek başına yeni bir render tetiklemediği için, oncekiSayiRef.current bu render sırasında, effect (render'dan sonra çalışan) onu 8'e güncellemeden önce, hâlâ ÖNCEKİ render'ın değerini (5) tutar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-ref'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$undefined, çünkü ref hiçbir zaman bir başlangıç değeriyle başlatılmadı$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Her render'da sayi'nin o anki değerine her zaman eşittir$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$5, önceki render'dan kaydedilen değer, çünkü effect bu render için henüz çalışmadı$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$8, çünkü ref sayi değiştiğinde hemen güncellenir$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about useRef's .current field, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$.current holds the currently stored value, whether that's a real DOM node (via the ref attribute) or a plain persisted value; changing .current doesn't trigger a re-render.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-ref'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Changing .current always causes the component to re-render, just like calling a state setter$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$.current can only ever hold a DOM element, never a plain number or other value$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$.current is the field on the object useRef returns that holds the currently stored value$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$When used with the ref attribute, .current becomes a real DOM element you can call browser methods on$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, useRef'in .current alanı hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$.current, şu anda saklanan değeri tutar; bu, ref attribute'u aracılığıyla gerçek bir DOM node'u ya da sade, kalıcı bir değer olabilir; .current'ı değiştirmek bir yeniden render tetiklemez.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-ref'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$.current, useRef'in döndürdüğü nesnede şu anda saklanan değeri tutan alandır$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$ref attribute'uyla kullanıldığında, .current tarayıcı metotlarını çağırabileceğin gerçek bir DOM elementi olur$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$.current'ı değiştirmek, tıpkı bir state setter çağırmak gibi her zaman component'in yeniden render olmasına neden olur$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$.current yalnızca bir DOM elementi tutabilir, asla sade bir sayı ya da başka bir değer tutamaz$$, FALSE, 3 FROM new_question_tr7;
