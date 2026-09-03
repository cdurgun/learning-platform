-- Promotion batch
-- Topic: use-effect (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V767-V794 (React Components & Props / State &
-- Events) and V731-V766 (Spring Data JPA), these 14 questions were NOT
-- produced by the n8n generation pipeline, NOT judged by the AI Judge, and
-- NOT ingested via /api/internal/questions/ingest -- per explicit user
-- request, they were hand-authored and independently self-reviewed directly
-- inside a Claude Code session, grounded strictly in content/en/use-effect.md
-- and content/tr/use-effect.md.
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
           $$What is a side effect, according to this lesson?$$,
           NULL, NULL,
           $$A side effect is something a component does OUTSIDE of its own render output (the JSX it returns): changing the tab title, setting up a timer, fetching data, writing to localStorage, and so on.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-effect'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Something a component does outside of its own render output, like changing the tab title or fetching data$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Any JSX expression that uses a conditional operator$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$A bug caused by forgetting to close a JSX tag$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$The default value returned by a component before props arrive$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir side effect (yan etki) nedir?$$,
           NULL, NULL,
           $$Bir side effect, bir component'in kendi render çıktısının (döndürdüğü JSX'in) DIŞINDA yaptığı bir şeydir: tab başlığını değiştirmek, bir zamanlayıcı kurmak, veri getirmek, localStorage'a yazmak vb.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-effect'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Props gelmeden önce bir component'in döndürdüğü varsayılan değer$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir component'in kendi render çıktısının dışında yaptığı bir şey, tab başlığını değiştirmek ya da veri getirmek gibi$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Koşullu bir operatör kullanan herhangi bir JSX ifadesi$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir JSX tag'ini kapatmayı unutmaktan kaynaklanan bir hata$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$When does the function passed to useEffect actually run, relative to the render?$$,
           NULL, NULL,
           $$You give useEffect a function; React runs that function AFTER the render finishes.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-effect'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Only once, the very first time the app is ever opened, regardless of component$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Before the render starts, so it can decide what to render$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$After the render finishes$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$At the exact same time as the render, on a separate thread$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$useEffect'e verilen fonksiyon, render'a göre gerçekte ne zaman çalışır?$$,
           NULL, NULL,
           $$useEffect'e bir fonksiyon verirsin; React o fonksiyonu render bittikten SONRA çalıştırır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-effect'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Render ile tam olarak aynı anda, ayrı bir thread üzerinde$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Yalnızca bir kez, uygulama ilk kez açıldığında, component'ten bağımsız olarak$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Render bittikten sonra$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Render başlamadan önce, böylece ne render edileceğine karar verebilir$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$How many times does this effect run if the component re-renders 5 times total (the initial render plus 4 state-triggered re-renders)?$$,
           $$useEffect(() => {
    console.log("Effect ran");
}, []);$$, $$jsx$$,
           $$With an empty dependency array [], the effect runs only once, the first time the component appears on screen (mounts) -- it does not run again on later renders.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-effect'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$4 times, once per re-render, but not the initial render$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$0 times, since an empty array means the effect never runs$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$5 times, once per render$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$1 time, only on the first render (mount)$$, TRUE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Component toplam 5 kez render edilirse (ilk render artı state kaynaklı 4 yeniden render) bu effect kaç kez çalışır?$$,
           $$useEffect(() => {
    console.log("Effect calisti");
}, []);$$, $$jsx$$,
           $$Boş bir dependency array [] ile, effect yalnızca bir kez, component ekranda ilk göründüğünde (mount olduğunda) çalışır -- sonraki render'larda tekrar çalışmaz.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-effect'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$5 kez, her render'da bir kez$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$4 kez, her yeniden render'da bir kez, ama ilk render'da değil$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$0 kez, çünkü boş bir dizi effect'in asla çalışmadığı anlamına gelir$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$1 kez, yalnızca ilk render'da (mount)$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$name changes, but count stays the same. Does this effect run?$$,
           $$useEffect(() => {
    console.log("count changed");
}, [count]);
// On this render, only "name" changed, not "count".$$, $$jsx$$,
           $$With [count] as the dependency array, the effect only runs when count changes -- it doesn't fire even if name changes.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-effect'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$No -- the effect only runs when count changes, and count didn't change here$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Yes, but only because name is alphabetically related to count$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$It depends on which one was declared first with useState$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Yes -- any state change in the component triggers every effect$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$ad değişiyor, ama sayi aynı kalıyor. Bu effect çalışır mı?$$,
           $$useEffect(() => {
    console.log("sayi degisti");
}, [sayi]);
// Bu render'da yalnizca "ad" degisti, "sayi" degil.$$, $$jsx$$,
           $$[sayi] dependency array'i ile, effect yalnızca sayi değiştiğinde çalışır -- ad değişse bile tetiklenmez.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-effect'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hayır -- effect yalnızca sayi değiştiğinde çalışır, ve burada sayi değişmedi$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Evet -- component'teki herhangi bir state değişikliği her effect'i tetikler$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Evet, ama yalnızca ad, sayi ile alfabetik olarak ilişkili olduğu için$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Hangisinin useState ile önce tanımlandığına bağlıdır$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$When does React call the cleanup function returned from an effect?$$,
           NULL, NULL,
           $$React automatically calls the cleanup function when the component is removed from the screen (unmounts), or right before the effect runs again.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-effect'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$When the component unmounts, or right before the effect runs again$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Immediately, before the effect's own function body runs at all$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Only when the browser tab is closed entirely$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Never automatically -- it must be called manually somewhere else in the code$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$React, bir effect'ten döndürülen cleanup fonksiyonunu ne zaman çağırır?$$,
           NULL, NULL,
           $$React, cleanup fonksiyonunu component ekrandan kaldırıldığında (unmount olduğunda) ya da effect tekrar çalışmadan hemen önce otomatik olarak çağırır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-effect'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hiçbir zaman otomatik olarak -- kodun başka bir yerinde elle çağrılmalıdır$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Component unmount olduğunda, ya da effect tekrar çalışmadan hemen önce$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Hemen, effect'in kendi fonksiyon gövdesi hiç çalışmadan önce$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Yalnızca tarayıcı sekmesi tamamen kapatıldığında$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe what happens when useEffect is given no dependency array at all? (Select all that apply)$$,
           NULL, NULL,
           $$A useEffect without a dependency array runs after EVERY render -- this is different from both [] (once) and [value] (only when value changes).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-effect'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The effect never runs at all unless a dependency array is explicitly provided$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$The effect runs after every single render$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$This behavior is different from passing an empty array []$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$It behaves identically to passing an empty dependency array []$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$useEffect'e hiç dependency array verilmediğinde ne olduğunu aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Dependency array'i olmayan bir useEffect, her render'dan SONRA çalışır -- bu, hem []'ten (bir kez) hem de [value]'dan (yalnızca value değiştiğinde) farklıdır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-effect'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bu davranış, boş bir dizi [] geçirmekten farklıdır$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Boş bir dependency array [] geçirmekle birebir aynı şekilde davranır$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir dependency array açıkça sağlanmadıkça effect hiç çalışmaz$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Effect, her tek render'dan sonra çalışır$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe the infinite loop mistake covered in this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$The mistake is forgetting the dependency array and updating state inside the effect; the effect runs after every render, and if it updates state, that triggers a new render, which runs the effect again, causing an infinite loop. The fix is setting up the dependency array correctly.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-effect'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The fix is to remove the useEffect entirely and never use it for that logic again$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$This mistake only happens when the dependency array contains more than one value$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$It happens when a useEffect with no dependency array updates state inside itself$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Each state update inside the effect triggers a new render, which runs the effect again$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste ele alınan sonsuz döngü hatasını aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Hata, dependency array'i unutup effect içinde state güncellemektir; effect her render'dan sonra çalışır, ve state güncellerse bu yeni bir render tetikler, bu da effect'i tekrar çalıştırır, sonsuz bir döngü oluşur. Çözüm, dependency array'i doğru şekilde kurmaktır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'use-effect'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Dependency array'i olmayan bir useEffect kendi içinde state güncellediğinde gerçekleşir$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Effect içindeki her state güncellemesi yeni bir render tetikler, bu da effect'i tekrar çalıştırır$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Çözüm, useEffect'i tamamen kaldırıp bu mantık için bir daha asla kullanmamaktır$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Bu hata yalnızca dependency array'i birden fazla değer içerdiğinde gerçekleşir$$, FALSE, 3 FROM new_question_tr7;
