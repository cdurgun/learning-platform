-- Promotion batch
-- Topic: what-are-hooks (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V767-V794 (React Components & Props / State &
-- Events) and V731-V766 (Spring Data JPA), these 14 questions were NOT
-- produced by the n8n generation pipeline, NOT judged by the AI Judge, and
-- NOT ingested via /api/internal/questions/ingest -- per explicit user
-- request, they were hand-authored and independently self-reviewed directly
-- inside a Claude Code session, grounded strictly in content/en/what-are-hooks.md
-- and content/tr/what-are-hooks.md.
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
           $$What is a hook, according to this lesson?$$,
           NULL, NULL,
           $$A hook is a function whose name starts with use that lets you add React features (state, side effects, DOM references, and more) to function components.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-are-hooks'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A function whose name starts with use that lets you add React features to function components$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$A CSS class that hooks a component into a specific style$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$A special JSX tag used only inside class components$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$A configuration file that lists every component in the app$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir hook nedir?$$,
           NULL, NULL,
           $$Bir hook, adı use ile başlayan ve function component'lere React özellikleri (state, side effect, DOM referansları ve daha fazlası) eklemeni sağlayan bir fonksiyondur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-are-hooks'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Uygulamadaki her component'i listeleyen bir yapılandırma dosyası$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Adı use ile başlayan ve function component'lere React özellikleri eklemeni sağlayan bir fonksiyon$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir component'i belirli bir stile bağlayan bir CSS class'ı$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Yalnızca class component'ler içinde kullanılan özel bir JSX tag'i$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Before Hooks existed, where could state and other React features be used?$$,
           NULL, NULL,
           $$Before Hooks, state and other React features could only be used in "class components," written with a different syntax.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-are-hooks'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$State never existed in React before Hooks were introduced$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Only inside class components, written with a different syntax$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$They could already be used identically in function components$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Only inside CSS files$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Hook'lar var olmadan önce, state ve diğer React özellikleri nerede kullanılabiliyordu?$$,
           NULL, NULL,
           $$Hook'lardan önce, state ve diğer React özellikleri yalnızca farklı bir sözdizimiyle yazılan "class component"lerde kullanılabiliyordu.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-are-hooks'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca CSS dosyalarının içinde$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Hook'lar tanıtılmadan önce React'te state hiç var olmadı$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Yalnızca farklı bir sözdizimiyle yazılan class component'lerin içinde$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Zaten function component'lerde birebir aynı şekilde kullanılabiliyordu$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$According to the Rules of Hooks, where can a hook be called from within a component?$$,
           NULL, NULL,
           $$Hooks are always called at the top level of a component -- they are never placed inside an if, a for loop, or another function.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-are-hooks'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Only inside an if statement checking whether props changed$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Only inside a for loop iterating over a list of items$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Always at the top level -- never inside an if, a for loop, or another function$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Anywhere, as long as it's inside a return statement$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Rules of Hooks'a göre, bir hook bir component içinde nereden çağrılabilir?$$,
           NULL, NULL,
           $$Hook'lar her zaman bir component'in en üst seviyesinde çağrılır -- asla bir if içine, bir for döngüsüne ya da başka bir fonksiyonun içine yerleştirilmez.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-are-hooks'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir return ifadesinin içinde olduğu sürece herhangi bir yerde$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Yalnızca props'un değişip değişmediğini kontrol eden bir if ifadesinin içinde$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Yalnızca bir öğe listesi üzerinde yineleme yapan bir for döngüsünün içinde$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Her zaman en üst seviyede -- asla bir if içine, bir for döngüsüne ya da başka bir fonksiyonun içine değil$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What happens when this code runs?$$,
           $$function calculateTotal() {
    const [total, setTotal] = useState(0); // calculateTotal is a regular function, not a component
    return total;
}$$, $$jsx$$,
           $$Hooks only work inside function components -- calling useState inside a regular JavaScript function (that isn't a component) causes an error.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-are-hooks'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It causes an error, since calculateTotal is a regular function, not a component or another hook$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$total is always undefined, but no error is thrown$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$React silently converts calculateTotal into a component automatically$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$It works fine, since useState can be called from any JavaScript function$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod çalıştığında ne olur?$$,
           $$function toplamHesapla() {
    const [toplam, toplamAyarla] = useState(0); // toplamHesapla sıradan bir fonksiyon, component değil
    return toplam;
}$$, $$jsx$$,
           $$Hook'lar yalnızca function component'lerin içinde çalışır -- useState'i sıradan bir JavaScript fonksiyonunun (component olmayan) içinde çağırmak bir hataya yol açar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-are-hooks'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$React, toplamHesapla'yı otomatik olarak sessizce bir component'e dönüştürür$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Sorunsuz çalışır, çünkü useState herhangi bir JavaScript fonksiyonundan çağrılabilir$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$toplamHesapla sıradan bir fonksiyon olduğu, bir component ya da başka bir hook olmadığı için bir hataya yol açar$$, TRUE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$toplam her zaman undefined'dır, ama hiçbir hata fırlatılmaz$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why does breaking the Rules of Hooks (like calling a hook conditionally) confuse React?$$,
           NULL, NULL,
           $$React matches state to the right component by assuming hooks are called in the same order on every render -- breaking that assumption confuses which state belongs to which hook call.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-are-hooks'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$React matches state to the right hook call by assuming hooks are called in the same order every render$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$It doesn't actually cause any real problem -- it's just a stylistic best practice$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$React re-compiles the entire component tree from scratch whenever a hook is skipped$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$It only matters for performance, never for correctness$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Rules of Hooks'u ihlal etmek (bir hook'u koşullu olarak çağırmak gibi) React'i neden karıştırır?$$,
           NULL, NULL,
           $$React, hook'ların her render'da aynı sırada çağrıldığını varsayarak state'i doğru hook çağrısıyla eşleştirir -- bu varsayımı bozmak hangi state'in hangi hook çağrısına ait olduğunu karıştırır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-are-hooks'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca performansı ilgilendirir, doğruluğu asla ilgilendirmez$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$React, her render'da hook'ların aynı sırada çağrıldığını varsayarak state'i doğru hook çağrısıyla eşleştirir$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Gerçekte hiçbir sorun yaratmaz -- yalnızca stilistik bir en iyi uygulamadır$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Bir hook atlandığında React tüm component ağacını sıfırdan yeniden derler$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Card is a proper function component. What happens when it calls useState?$$,
           $$function Card() {
    const [expanded, setExpanded] = useState(false);
    return <div>{expanded ? "Open" : "Closed"}</div>;
}$$, $$jsx$$,
           $$Since Card is a genuine function component, calling useState inside it works exactly as intended -- every component in this course, being a function component, is eligible to use hooks.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-are-hooks'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$useState silently does nothing unless Card also has props$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$It works correctly, since Card is a genuine function component$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$It throws an error, since only class components can call hooks$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$It works, but only if Card is also wrapped in useEffect$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Kart gerçek bir function component. useState çağırdığında ne olur?$$,
           $$function Kart() {
    const [acik, acikAyarla] = useState(false);
    return <div>{acik ? "Acik" : "Kapali"}</div>;
}$$, $$jsx$$,
           $$Kart gerçek bir function component olduğu için, içinde useState çağırmak tam olarak amaçlandığı gibi çalışır -- bu kurstaki her component bir function component olduğu için hook kullanmaya uygundur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-are-hooks'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çalışır, ama yalnızca Kart aynı zamanda useEffect ile de sarmalanmışsa$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Kart aynı zamanda props'a sahip olmadıkça useState sessizce hiçbir şey yapmaz$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Kart gerçek bir function component olduğu için doğru şekilde çalışır$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Yalnızca class component'ler hook çağırabildiği için bir hata fırlatır$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about hooks and the use... naming pattern, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$useState is a hook React provides out of the box; useEffect, useRef, useMemo, and useCallback all follow the same use... naming pattern; all of these are hooks.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-are-hooks'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Only useState counts as a real hook; the others are a different kind of React feature$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$A function only needs to do something useful to count as a hook -- the use prefix is not actually required$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$useState is a hook React gives you out of the box$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$useEffect, useRef, useMemo, and useCallback all follow the same use... naming pattern as useState$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, hook'lar ve use... isimlendirme kalıbı ile ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$useState, React'in sana hazır verdiği bir hook'tur; useEffect, useRef, useMemo ve useCallback hepsi useState ile aynı use... isimlendirme kalıbını izler; bunların hepsi hook'tur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-are-hooks'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$useState, React'in sana hazır verdiği bir hook'tur$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$useEffect, useRef, useMemo ve useCallback hepsi useState ile aynı use... isimlendirme kalıbını izler$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Yalnızca useState gerçek bir hook sayılır; diğerleri farklı bir React özelliği türüdür$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir fonksiyonun hook sayılması için yalnızca yararlı bir şey yapması yeterlidir -- use öneki aslında gerekli değildir$$, FALSE, 3 FROM new_question_tr7;
