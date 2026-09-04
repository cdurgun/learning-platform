-- Promotion batch
-- Topic: sharing-state (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V795-V822 (React Hooks / Forms) and V767-V794
-- (React Components & Props / State & Events), these 14 questions were NOT
-- produced by the n8n generation pipeline, NOT judged by the AI Judge, and
-- NOT ingested via /api/internal/questions/ingest -- per explicit user
-- request, they were hand-authored and independently self-reviewed directly
-- inside a Claude Code session, grounded strictly in content/en/sharing-state.md
-- and content/tr/sharing-state.md.
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
           $$If query state lives inside SearchBox, can ResultsList (a sibling component) access it directly?$$,
           NULL, NULL,
           $$ResultsList has no way to access SearchBox's state -- each component's own state is trapped inside it; sibling components can't see each other's state directly.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sharing-state'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$No -- each component's own state is trapped inside it; siblings can't see it directly$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Yes -- all state in a React app is automatically shared between every component$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Yes, but only if both components are declared in the same file$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Only if ResultsList is rendered before SearchBox in the JSX$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$query state'i AramaKutusu'nun içinde yaşıyorsa, SonucListesi (bir sibling component) ona doğrudan erişebilir mi?$$,
           NULL, NULL,
           $$SonucListesi'nin AramaKutusu'nun state'ine erişmesinin bir yolu yoktur -- her component'in kendi state'i onun içine hapsolmuştur; sibling component'ler birbirinin state'ini doğrudan göremez.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sharing-state'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca SonucListesi, JSX'te AramaKutusu'ndan önce render edilirse$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Hayır -- her component'in kendi state'i onun içine hapsolmuştur; sibling'ler birbirinin state'ini doğrudan göremez$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Evet -- bir React uygulamasındaki tüm state, her component arasında otomatik olarak paylaşılır$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Evet, ama yalnızca iki component de aynı dosyada tanımlanmışsa$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What is "lifting state up"?$$,
           NULL, NULL,
           $$The fix is to move the state to a place that's the common ancestor of both components -- this pattern is called lifting state up.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sharing-state'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Copying the same state independently into every component that needs it$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Moving state shared by multiple components to their common ancestor$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Moving a component's state into a global browser-level variable$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Deleting state entirely and replacing it with hardcoded values$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$"Lifting state up" (state'i yukarı taşıma) nedir?$$,
           NULL, NULL,
           $$Çözüm, state'i her iki component'in de ortak atası olan bir yere taşımaktır -- bu kalıba lifting state up denir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sharing-state'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$State'i tamamen silip sabit-kodlanmış değerlerle değiştirmek$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Aynı state'i, ona ihtiyaç duyan her component'e bağımsız olarak kopyalamak$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Birden fazla component tarafından paylaşılan state'i onların ortak atasına taşımak$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Bir component'in state'ini global, tarayıcı seviyesinde bir değişkene taşımak$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$After lifting state up, what does SearchBox receive as props, and what does ResultsList receive?$$,
           $$function SearchPage() {
    const [query, setQuery] = useState("");
    return (
        <div>
            <SearchBox query={query} onQueryChange={setQuery} />
            <ResultsList query={query} />
        </div>
    );
}$$, $$jsx$$,
           $$SearchBox gets query and onQueryChange (setQuery); ResultsList gets just query.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sharing-state'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$SearchBox gets nothing at all; only ResultsList receives query$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$ResultsList receives onQueryChange, and SearchBox receives query only$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$SearchBox gets query and onQueryChange; ResultsList gets just query$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Both components receive the exact same set of props, including onQueryChange$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$State yukarı taşındıktan sonra, AramaKutusu prop olarak neyi alır, SonucListesi neyi alır?$$,
           $$function AramaSayfasi() {
    const [sorgu, sorguAyarla] = useState("");
    return (
        <div>
            <AramaKutusu sorgu={sorgu} sorguDegisti={sorguAyarla} />
            <SonucListesi sorgu={sorgu} />
        </div>
    );
}$$, $$jsx$$,
           $$AramaKutusu, sorgu ve sorguDegisti'yi (sorguAyarla) alır; SonucListesi yalnızca sorgu'yu alır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sharing-state'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Her iki component de sorguDegisti dahil tam olarak aynı prop kümesini alır$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$AramaKutusu hiçbir şey almaz; yalnızca SonucListesi sorgu'yu alır$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$SonucListesi sorguDegisti'yi alır, AramaKutusu ise yalnızca sorgu'yu alır$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$AramaKutusu, sorgu ve sorguDegisti'yi alır; SonucListesi yalnızca sorgu'yu alır$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Is lifting state up limited to filtering a list, according to this lesson?$$,
           NULL, NULL,
           $$Lifting state up isn't limited to filtering a list -- it also applies to components that show the SAME value in TWO DIFFERENT ways, like a slider and a text display sharing the same rating value.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sharing-state'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yes -- it can only ever be used for search/filter scenarios$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Yes, and it also requires the two components to be visually identical$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$No -- it only applies when there are at least three sibling components involved$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$No -- it also applies to components showing the same value in two different ways, like a slider and a text display$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, lifting state up yalnızca bir listeyi filtrelemekle mi sınırlıdır?$$,
           NULL, NULL,
           $$Lifting state up, bir listeyi filtrelemekle sınırlı değildir -- aynı zamanda, bir slider ve bir metin gösterimi aynı rating değerini paylaşması gibi, AYNI değeri İKİ FARKLI şekilde gösteren component'lere de uygulanır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sharing-state'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hayır -- aynı zamanda, bir slider ve bir metin gösterimi gibi, aynı değeri iki farklı şekilde gösteren component'lere de uygulanır$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Evet -- yalnızca arama/filtreleme senaryoları için kullanılabilir$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Evet, ve ayrıca iki component'in görsel olarak özdeş olmasını gerektirir$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Hayır -- yalnızca en az üç sibling component söz konusu olduğunda geçerlidir$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What is "props drilling"?$$,
           NULL, NULL,
           $$Props drilling is being forced to pass a prop through intermediate layers that don't use it.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sharing-state'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Being forced to pass a prop through intermediate components that don't use it themselves$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Automatically generating props from a component's state without writing any code$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$A React error thrown when a required prop is missing$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Using the same prop name in two unrelated components by accident$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$"Props drilling" nedir?$$,
           NULL, NULL,
           $$Props drilling, bir prop'u, onu kendisi kullanmayan ara katman component'ler aracılığıyla geçirmeye zorlanmaktır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sharing-state'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Aynı prop adını, kazara, iki ilgisiz component'te kullanmak$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Bir prop'u, onu kendisi kullanmayan ara katman component'ler aracılığıyla geçirmeye zorlanmak$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Bir component'in state'inden, hiç kod yazmadan otomatik olarak prop üretmek$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Gerekli bir prop eksik olduğunda React'in fırlattığı bir hata$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Does ResultsPanel actually use the query prop itself, or only pass it along?$$,
           $$function ResultsPanel({ query }) {
    return <ResultsList query={query} />;
}
// ResultsPanel's own JSX never reads query directly$$, $$jsx$$,
           $$ResultsPanel never uses query ITSELF -- it only accepts it to pass along to ResultsList; this is the props drilling problem.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sharing-state'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$ResultsPanel converts query into state before passing it further down$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$ResultsPanel uses query directly to filter its own rendered content$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$ResultsPanel only accepts query to pass it along to ResultsList, without using it itself$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$ResultsPanel ignores query entirely and it's silently discarded$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$SonucPaneli, sorgu prop'unu gerçekten kendisi mi kullanıyor, yoksa yalnızca aktarıyor mu?$$,
           $$function SonucPaneli({ sorgu }) {
    return <SonucListesi sorgu={sorgu} />;
}
// SonucPaneli'nin kendi JSX'i sorgu'yu hicbir zaman dogrudan okumaz$$, $$jsx$$,
           $$SonucPaneli, sorgu'yu KENDİSİ hiç kullanmaz -- onu yalnızca SonucListesi'ne aktarmak için kabul eder; bu, props drilling sorunudur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sharing-state'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$SonucPaneli, sorgu'yu tamamen yok sayar ve sessizce atılır$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$SonucPaneli, sorgu'yu daha aşağıya geçirmeden önce state'e dönüştürür$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$SonucPaneli, sorgu'yu kendisi kullanmadan, yalnızca SonucListesi'ne aktarmak için kabul eder$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$SonucPaneli, kendi render edilen içeriğini filtrelemek için sorgu'yu doğrudan kullanır$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about how props drilling grows as a tree gets deeper, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$None of Level1, Level2, Level3 use user -- they just pass it along; only Level4, at the very bottom, actually uses it. Every new level, or every new shared value, stretches this chain further, making the code tedious to write and fragile to change.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sharing-state'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$This problem gets smaller, not bigger, the deeper the component tree becomes$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Only the very first component in the chain is allowed to actually use the value$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Intermediate levels in a deep chain may pass a prop along without using it themselves at all$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Every new level, or every new shared value, stretches the passing chain further$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, ağaç derinleştikçe props drilling'in nasıl büyüdüğünü aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Level1, Level2, Level3'ün hiçbiri user'ı kullanmaz -- yalnızca aktarırlar; yalnızca en altta olan Level4 gerçekten kullanır. Her yeni seviye ya da her yeni paylaşılan değer, bu zinciri daha da uzatır, kodu yazması sıkıcı ve değiştirmesi kırılgan hale getirir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'sharing-state'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derin bir zincirdeki ara seviyeler, bir prop'u kendileri hiç kullanmadan aktarabilir$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Her yeni seviye ya da her yeni paylaşılan değer, aktarma zincirini daha da uzatır$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Component ağacı derinleştikçe bu sorun büyümez, küçülür$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Zincirdeki yalnızca ilk component'in değeri gerçekten kullanmasına izin verilir$$, FALSE, 3 FROM new_question_tr7;
