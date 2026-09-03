-- Promotion batch
-- Topic: use-memo-use-callback (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V767-V794 (React Components & Props / State &
-- Events) and V731-V766 (Spring Data JPA), these 14 questions were NOT
-- produced by the n8n generation pipeline, NOT judged by the AI Judge, and
-- NOT ingested via /api/internal/questions/ingest -- per explicit user
-- request, they were hand-authored and independently self-reviewed directly
-- inside a Claude Code session, grounded strictly in content/en/use-memo-use-callback.md
-- and content/tr/use-memo-use-callback.md.
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
           $$What is memoization?$$,
           NULL, NULL,
           $$Memoization is a technique for storing the result of a calculation so that, if it's requested again with the same inputs, you get that result back without repeating the calculation.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-memo-use-callback'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A technique for storing a calculation's result so it can be returned again without repeating the calculation$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$A way to permanently delete unused state variables from memory$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$A technique for compressing JSX before it's sent to the browser$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$A naming convention for functions that start with use$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Memoization nedir?$$,
           NULL, NULL,
           $$Memoization, bir hesaplamanın sonucunu saklama tekniğidir, böylece aynı girdilerle tekrar istendiğinde, hesaplamayı tekrarlamadan o sonuç geri verilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-memo-use-callback'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$use ile başlayan fonksiyonlar için bir isimlendirme kuralı$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir hesaplamanın sonucunu, hesaplamayı tekrarlamadan tekrar döndürülebilecek şekilde saklama tekniği$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Kullanılmayan state değişkenlerini bellekten kalıcı olarak silmenin bir yolu$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$JSX'i tarayıcıya gönderilmeden önce sıkıştırma tekniği$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What does useMemo cache?$$,
           NULL, NULL,
           $$useMemo caches the RESULT of a calculation -- it does not re-run the calculation as long as the dependency array's values haven't changed.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-memo-use-callback'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Every prop the component has ever received across all renders$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$The result of a calculation$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$The entire component's render output as HTML$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$The browser's DOM tree for the whole page$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$useMemo neyi önbelleğe alır (cache eder)?$$,
           NULL, NULL,
           $$useMemo bir hesaplamanın SONUCUNU cache eder -- dependency array'in değerleri değişmediği sürece hesaplamayı tekrar çalıştırmaz.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-memo-use-callback'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Tüm sayfanın tarayıcı DOM ağacını$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Component'in tüm render'lar boyunca şimdiye kadar aldığı her prop'u$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Bir hesaplamanın sonucunu$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Tüm component'in render çıktısını HTML olarak$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$settings is created with useMemo(() => ({ theme: "dark", fontSize: 16 }), []). Across two consecutive renders, is settings the same object reference?$$,
           $$const settings = useMemo(() => ({ theme: "dark", fontSize: 16 }), []);
// component re-renders for an unrelated reason$$, $$jsx$$,
           $$Since the dependency array is empty (never changes), useMemo returns the SAME object reference on every render, instead of creating a new object each time.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-memo-use-callback'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It depends on whether theme or fontSize changed, not on the dependency array$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Only the first render produces an object; later renders return undefined$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$No -- a brand new object is created on every render, even with useMemo$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Yes -- useMemo returns the same object reference as long as the dependency array hasn't changed$$, TRUE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$ayarlar, useMemo(() => ({ tema: "koyu", yaziBoyutu: 16 }), []) ile oluşturuluyor. Ardışık iki render boyunca, ayarlar aynı nesne referansı mıdır?$$,
           $$const ayarlar = useMemo(() => ({ tema: "koyu", yaziBoyutu: 16 }), []);
// component ilgisiz bir nedenle yeniden render ediliyor$$, $$jsx$$,
           $$Dependency array'i boş olduğu için (asla değişmediği için), useMemo her render'da yeni bir nesne oluşturmak yerine AYNI nesne referansını döndürür.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-memo-use-callback'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hayır -- useMemo ile bile her render'da yepyeni bir nesne oluşturulur$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$tema ya da yaziBoyutu değişip değişmediğine bağlıdır, dependency array'e değil$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Yalnızca ilk render bir nesne üretir; sonraki render'lar undefined döndürür$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Evet -- useMemo, dependency array değişmediği sürece aynı nesne referansını döndürür$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$How does useCallback differ from useMemo in what it memoizes?$$,
           NULL, NULL,
           $$useCallback is very similar to useMemo, but it memoizes a FUNCTION instead of a value -- useMemo memoizes the result of a calculation (a value), useCallback memoizes a function reference.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-memo-use-callback'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$useCallback and useMemo memoize exactly the same thing, just with different names$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$useCallback memoizes a value, while useMemo memoizes a function$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$useCallback is used only for class components, useMemo only for function components$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$useCallback memoizes a function, while useMemo memoizes a value (a calculation's result)$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$useCallback, neyi memoize ettiği bakımından useMemo'dan nasıl farklıdır?$$,
           NULL, NULL,
           $$useCallback, useMemo'ya çok benzer, ama bir değer yerine bir FONKSİYONU memoize eder -- useMemo bir hesaplamanın sonucunu (bir değeri) memoize eder, useCallback bir fonksiyon referansını memoize eder.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-memo-use-callback'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$useCallback bir fonksiyonu memoize eder, useMemo ise bir değeri (bir hesaplamanın sonucunu) memoize eder$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$useCallback ve useMemo tam olarak aynı şeyi memoize eder, yalnızca farklı adları vardır$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$useCallback bir değeri memoize eder, useMemo bir fonksiyonu memoize eder$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$useCallback yalnızca class component'ler için, useMemo yalnızca function component'ler içindir$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$count doesn't change between two renders. Is handleClick the same function reference on both renders?$$,
           $$function Button({ count }) {
    function handleClick() {
        console.log(count);
    }
    // No useCallback used here at all
    return <button onClick={handleClick}>Click</button>;
}$$, $$jsx$$,
           $$Without useCallback, handleClick would be a NEW function on every render -- even though count didn't change, a plain function declaration creates a brand new function object each render.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-memo-use-callback'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yes -- since count didn't change, React automatically reuses the same function$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$No -- without useCallback, a new function is created on every render, regardless of whether count changed$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$It's the same reference only on the very first two renders, never after$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$It depends on whether the button was actually clicked between renders$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$İki render arasında sayi değişmiyor. handleClick, her iki render'da da aynı fonksiyon referansı mıdır?$$,
           $$function Buton({ sayi }) {
    function handleClick() {
        console.log(sayi);
    }
    // Burada hic useCallback kullanilmiyor
    return <button onClick={handleClick}>Tikla</button>;
}$$, $$jsx$$,
           $$useCallback olmadan, handleClick her render'da YENİ bir fonksiyon olurdu -- sayi değişmese bile, düz bir fonksiyon tanımı her render'da yepyeni bir fonksiyon nesnesi oluşturur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-memo-use-callback'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Render'lar arasında düğmeye gerçekten tıklanıp tıklanmadığına bağlıdır$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Hayır -- useCallback olmadan, sayi değişse de değişmese de her render'da yeni bir fonksiyon oluşturulur$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Evet -- sayi değişmediği için React otomatik olarak aynı fonksiyonu yeniden kullanır$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Yalnızca ilk iki render'da aynı referanstır, sonrasında asla değildir$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe when NOT to use useMemo/useCallback, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$For simple, fast operations, wrapping them in useMemo has no real benefit; using these hooks unnecessarily results in code that's more complex but not actually faster -- "premature optimization."$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-memo-use-callback'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$There is never a valid reason to skip useMemo or useCallback once a component uses any hooks at all$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Wrapping a simple, already-fast operation like count * 2 in useMemo has no real benefit$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Using these hooks unnecessarily can result in code that's more complex but not actually faster$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$useMemo and useCallback should be applied to every single calculation and function by default$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, useMemo/useCallback'in NE ZAMAN kullanılmaması gerektiğini aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Basit, hızlı işlemler için, onları useMemo'ya sarmalamanın gerçek bir faydası yoktur; bu hook'ları gereksiz yere kullanmak, daha karmaşık ama gerçekte daha hızlı olmayan koda yol açar -- "erken optimizasyon".$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-memo-use-callback'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bu hook'ları gereksiz yere kullanmak, daha karmaşık ama gerçekte daha hızlı olmayan koda yol açabilir$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$useMemo ve useCallback varsayılan olarak her tek hesaplamaya ve fonksiyona uygulanmalıdır$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir component herhangi bir hook kullandığı andan itibaren useMemo ya da useCallback'i atlamanın hiçbir geçerli nedeni yoktur$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$sayi * 2 gibi basit, zaten hızlı bir işlemi useMemo'ya sarmalamanın gerçek bir faydası yoktur$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about the cost of useMemo/useCallback themselves, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$useMemo and useCallback have their own cost -- comparing the dependency array and holding onto the result; for simple, fast operations, that cost can be more expensive than what it saves.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-memo-use-callback'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Their cost is always exactly zero, regardless of what they're wrapping$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Their cost only applies the very first time a component renders, never afterward$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$They have their own cost: comparing the dependency array and holding onto the previous result$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$For simple, fast operations, that cost can be more expensive than what it actually saves$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, useMemo/useCallback'in kendi maliyetiyle ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$useMemo ve useCallback'in kendi maliyeti vardır -- dependency array'i karşılaştırmak ve sonucu elde tutmak; basit, hızlı işlemler için, bu maliyet kazandırdığından daha pahalı olabilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-memo-use-callback'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Kendi maliyetleri vardır: dependency array'i karşılaştırmak ve önceki sonucu elde tutmak$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Basit, hızlı işlemler için, bu maliyet gerçekte kazandırdığından daha pahalı olabilir$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Neyi sarmaladıklarından bağımsız olarak maliyetleri her zaman tam olarak sıfırdır$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Maliyetleri yalnızca bir component'in ilk render'ında geçerlidir, sonrasında asla değil$$, FALSE, 3 FROM new_question_tr7;
