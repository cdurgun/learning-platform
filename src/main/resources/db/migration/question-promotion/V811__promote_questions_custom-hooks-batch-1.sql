-- Promotion batch
-- Topic: custom-hooks (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V767-V794 (React Components & Props / State &
-- Events) and V731-V766 (Spring Data JPA), these 14 questions were NOT
-- produced by the n8n generation pipeline, NOT judged by the AI Judge, and
-- NOT ingested via /api/internal/questions/ingest -- per explicit user
-- request, they were hand-authored and independently self-reviewed directly
-- inside a Claude Code session, grounded strictly in content/en/custom-hooks.md
-- and content/tr/custom-hooks.md.
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
           $$What is a custom hook?$$,
           NULL, NULL,
           $$A custom hook is a regular function you write, that uses React's own hooks (useState, useEffect, etc.) inside it -- used to extract repeated state+effect logic.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'custom-hooks'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A regular function you write that uses React's own hooks inside it$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$A built-in React hook that can only be used once per application$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$A special CSS class applied automatically to every hook-using component$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$A JSX component that renders nothing but wraps children$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir custom hook nedir?$$,
           NULL, NULL,
           $$Bir custom hook, içinde React'in kendi hook'larını (useState, useEffect vb.) kullanan, yazdığın sıradan bir fonksiyondur -- tekrarlanan state+effect mantığını çıkarmak için kullanılır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'custom-hooks'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hiçbir şey render etmeyen ama children'ı sarmalayan bir JSX component'i$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$İçinde React'in kendi hook'larını kullanan, yazdığın sıradan bir fonksiyon$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Uygulama başına yalnızca bir kez kullanılabilen, yerleşik bir React hook'u$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Hook kullanan her component'e otomatik olarak uygulanan özel bir CSS class'ı$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What is the only requirement for a function to count as a custom hook?$$,
           NULL, NULL,
           $$The only requirement is that its name starts with use.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'custom-hooks'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It must accept exactly one parameter, no more and no fewer$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Its name must start with use$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$It must be declared in its own separate file$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$It must return a JSX element$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir fonksiyonun custom hook sayılması için tek gereklilik nedir?$$,
           NULL, NULL,
           $$Tek gereklilik, adının use ile başlamasıdır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'custom-hooks'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir JSX elementi döndürmelidir$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Tam olarak bir parametre almalıdır, ne daha fazla ne daha az$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Adı use ile başlamalıdır$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Kendi ayrı dosyasında tanımlanmalıdır$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why does the use prefix on a custom hook's name matter?$$,
           NULL, NULL,
           $$It signals to both React (for its Rules of Hooks checks) and to other developers reading your code: "this is a hook, and it can call other hooks inside it."$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'custom-hooks'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It makes the function run faster than a regularly-named function$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$It's required only for hooks that use useEffect, not for any other hook$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$It signals to React and other developers that this is a hook that can call other hooks inside it$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$It has no real effect at all -- it's purely a cosmetic naming preference$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir custom hook'un adındaki use öneki neden önemlidir?$$,
           NULL, NULL,
           $$Hem React'e (Rules of Hooks kontrolleri için) hem de kodunu okuyan diğer geliştiricilere "bu bir hook'tur ve içinde başka hook'lar çağırabilir" sinyalini verir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'custom-hooks'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Gerçekte hiçbir etkisi yoktur -- tamamen kozmetik bir isimlendirme tercihidir$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Fonksiyonun sıradan adlandırılmış bir fonksiyondan daha hızlı çalışmasını sağlar$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Yalnızca useEffect kullanan hook'lar için gereklidir, başka hiçbir hook için değil$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$React'e ve diğer geliştiricilere, bunun içinde başka hook'lar çağırabilen bir hook olduğu sinyalini verir$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$apples and oranges both call useCounter(). Do they share the same count value?$$,
           $$function useCounter() {
    const [count, setCount] = useState(0);
    return [count, setCount];
}

function FruitBasket() {
    const [apples, setApples] = useCounter();
    const [oranges, setOranges] = useCounter();
    // setApples is called three times, setOranges is never called
}$$, $$jsx$$,
           $$Each call to a custom hook gets its own INDEPENDENT state -- apples and oranges are two completely independent pieces of state, even though they use the same useCounter hook.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'custom-hooks'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$No -- each call gets its own independent state, so apples and oranges are unrelated$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$They start independent but become linked after the first setApples call$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Only one of the two calls actually works; the second one throws an error$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Yes -- both calls to useCounter share and update the exact same underlying state$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$elmalar ve portakallar ikisi de useSayac() çağırıyor. Aynı sayi değerini paylaşırlar mı?$$,
           $$function useSayac() {
    const [sayi, sayiAyarla] = useState(0);
    return [sayi, sayiAyarla];
}

function MeyveSepeti() {
    const [elmalar, elmalarAyarla] = useSayac();
    const [portakallar, portakallarAyarla] = useSayac();
    // elmalarAyarla uc kez cagriliyor, portakallarAyarla hic cagrilmiyor
}$$, $$jsx$$,
           $$Bir custom hook'a yapılan her çağrı kendi BAĞIMSIZ state'ini alır -- elmalar ve portakallar, aynı useSayac hook'unu kullansalar bile tamamen bağımsız iki state parçasıdır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'custom-hooks'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hayır -- her çağrı kendi bağımsız state'ini alır, bu yüzden elmalar ve portakallar birbiriyle ilgisizdir$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Evet -- useSayac'a yapılan her iki çağrı da tam olarak aynı temel state'i paylaşır ve günceller$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Bağımsız başlarlar ama ilk elmalarAyarla çağrısından sonra birbirine bağlanırlar$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$İki çağrıdan yalnızca biri gerçekten çalışır; ikincisi bir hata fırlatır$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$When you reuse a custom hook across components, what exactly is being reused?$$,
           NULL, NULL,
           $$This is the power of custom hooks: you're reusing the LOGIC for managing state, not the state itself -- each usage gets its own independent state.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'custom-hooks'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The logic for managing state -- not the state itself$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$The exact same state value, shared and synchronized across every component that uses it$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$The component's own JSX markup$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$The specific DOM node the hook was first attached to$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir custom hook'u component'ler arasında yeniden kullandığında, gerçekte yeniden kullanılan nedir?$$,
           NULL, NULL,
           $$Custom hook'ların gücü budur: state'in kendisini değil, state'i YÖNETME MANTIĞINI yeniden kullanıyorsun -- her kullanım kendi bağımsız state'ini alır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'custom-hooks'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hook'un ilk bağlandığı belirli DOM node'u$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$State'i yönetme mantığı -- state'in kendisi değil$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Onu kullanan her component arasında paylaşılan ve senkronize edilen, tam olarak aynı state değeri$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Component'in kendi JSX işaretlemesi$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What two built-in hooks does useFetch combine, according to this lesson's example?$$,
           $$function useFetch(url) {
    const [data, setData] = useState(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        // fetch logic that eventually calls setData and setLoading
    }, [url]);

    return { data, loading };
}$$, $$jsx$$,
           $$useFetch combines useState (for the data and the loading status) with useEffect (to fetch the data), gathering them in one place instead of rewriting them in every component.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'custom-hooks'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Only useEffect -- useState is not actually involved$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$useState and useEffect$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$useRef and useMemo$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$useCallback and useContext$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu dersin örneğine göre, useFetch hangi iki yerleşik hook'u birleştirir?$$,
           $$function useFetch(url) {
    const [veri, veriAyarla] = useState(null);
    const [yukleniyor, yukleniyorAyarla] = useState(true);

    useEffect(() => {
        // sonunda veriAyarla ve yukleniyorAyarla'yi cagiran fetch mantigi
    }, [url]);

    return { veri, yukleniyor };
}$$, $$jsx$$,
           $$useFetch, useState'i (veri ve yükleme durumu için) useEffect ile (veriyi getirmek için) birleştirir, bunları her component'te yeniden yazmak yerine tek bir yerde toplar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'custom-hooks'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$useCallback ve useContext$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Yalnızca useEffect -- useState aslında dahil değildir$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$useState ve useEffect$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$useRef ve useMemo$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly distinguish a custom hook from an ordinary JavaScript utility function? (Select all that apply)$$,
           NULL, NULL,
           $$A custom hook can use React's own hooks inside it; useCounter is a function you wrote that calls useState inside, which is not something an ordinary utility function does (or is allowed to do without being a hook itself).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'custom-hooks'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$An ordinary utility function and a custom hook are functionally identical in every respect$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$A custom hook must always be defined inside the component that uses it, never in a separate file$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$A custom hook can use React's own hooks (like useState) inside it$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$A custom hook's name follows the use naming pattern, signaling it can call other hooks$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri bir custom hook'u sıradan bir JavaScript yardımcı fonksiyonundan doğru şekilde ayırt eder? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Bir custom hook, içinde React'in kendi hook'larını (useState gibi) kullanabilir; useSayac, içinde useState çağıran, yazdığın bir fonksiyondur, bu sıradan bir yardımcı fonksiyonun yapabildiği (ya da kendisi bir hook olmadan yapmasına izin verilen) bir şey değildir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'custom-hooks'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir custom hook, içinde React'in kendi hook'larını (useState gibi) kullanabilir$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir custom hook'un adı, başka hook'lar çağırabileceğini belirten use isimlendirme kalıbını izler$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Sıradan bir yardımcı fonksiyon ile bir custom hook her açıdan işlevsel olarak birebir aynıdır$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir custom hook her zaman onu kullanan component'in içinde tanımlanmalıdır, asla ayrı bir dosyada değil$$, FALSE, 3 FROM new_question_tr7;
