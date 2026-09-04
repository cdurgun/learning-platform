-- Promotion batch
-- Topic: component-testing (language: en x7, tr x7)
-- Generated: 2026-09-04 (this migration file's authoring date)
--
-- Like question-promotion/V823-V846 (React Routing / API & Data Fetching /
-- State Management) and V767-V822 (earlier React batches), these 14
-- questions were NOT produced by the n8n generation pipeline, NOT judged by
-- the AI Judge, and NOT ingested via /api/internal/questions/ingest -- per
-- explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/component-testing.md and content/tr/component-testing.md.
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
           $$What is the division of labor between Vitest and React Testing Library, according to this lesson?$$,
           NULL, NULL,
           $$Vitest is the tool that RUNS tests (describe, it, expect); React Testing Library lets you MOUNT a component into a fake DOM and QUERY that DOM.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Vitest runs tests; React Testing Library mounts a component into a fake DOM and queries it$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$They are two competing, interchangeable test runners -- only one is ever installed$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$React Testing Library runs tests; Vitest mounts components into the DOM$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Vitest only works with class components; React Testing Library only with function components$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, Vitest ile React Testing Library arasındaki iş bölümü nedir?$$,
           NULL, NULL,
           $$Vitest, testleri ÇALIŞTIRAN araçtır (describe, it, expect); React Testing Library, bir component'i sahte bir DOM'a MOUNT etmeni ve o DOM'u SORGULAMANI sağlar.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Vitest yalnızca class component'lerle, React Testing Library yalnızca function component'lerle çalışır$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Vitest testleri çalıştırır; React Testing Library bir component'i sahte bir DOM'a mount edip sorgular$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$İki rakip, birbirinin yerine geçebilen test runner'ıdır -- yalnızca biri kurulur$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$React Testing Library testleri çalıştırır; Vitest component'leri DOM'a mount eder$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What does environment: "jsdom" in the Vitest config do?$$,
           NULL, NULL,
           $$It makes tests run against a fake DOM inside Node instead of a real browser.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Converts every test file into a .jsx file automatically$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Makes tests run against a fake DOM inside Node instead of a real browser$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Opens a real Chrome browser window for every test that runs$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Disables all DOM-related assertions entirely$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Vitest yapılandırmasındaki environment: "jsdom" ne yapar?$$,
           NULL, NULL,
           $$Testlerin, gerçek bir tarayıcı yerine Node içinde sahte bir DOM'a karşı çalışmasını sağlar.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$DOM ile ilgili tüm assertion'ları tamamen devre dışı bırakır$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Her test dosyasını otomatik olarak bir .jsx dosyasına dönüştürür$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Testlerin, gerçek bir tarayıcı yerine Node içinde sahte bir DOM'a karşı çalışmasını sağlar$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Çalışan her test için gerçek bir Chrome tarayıcı penceresi açar$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Counter renders the text "Count: 0" when first mounted. What happens when this test runs?$$,
           $$it("shows the initial count", () => {
    render(<Counter />);
    expect(screen.getByText("Count: 0")).toBeInTheDocument();
});$$, $$jsx$$,
           $$render(<Counter />) mounts the component into jsdom; screen.getByText finds the element containing that text, and toBeInTheDocument() confirms it exists -- the test passes.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Nothing happens -- getByText never actually searches the mounted DOM$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$The test throws a syntax error, since it() cannot contain a render call$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$The test passes -- Counter is mounted, and getByText finds the matching text$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$The test fails immediately, since render() requires a second argument$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Sayac, ilk mount edildiğinde "Sayi: 0" metnini render ediyor. Bu test çalıştığında ne olur?$$,
           $$it("baslangic sayisini gosterir", () => {
    render(<Sayac />);
    expect(screen.getByText("Sayi: 0")).toBeInTheDocument();
});$$, $$jsx$$,
           $$render(<Sayac />), component'i jsdom'a mount eder; screen.getByText o metni içeren elementi bulur, ve toBeInTheDocument() var olduğunu doğrular -- test geçer.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$render() ikinci bir argüman gerektirdiği için test hemen başarısız olur$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Hiçbir şey olmaz -- getByText mount edilen DOM'u gerçekte hiç aramaz$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$it() bir render çağrısı içeremediği için test bir sözdizimi hatası fırlatır$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Test geçer -- Sayac mount edilir, ve getByText eşleşen metni bulur$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which query does RTL's official docs recommend as the PREFERRED query whenever possible?$$,
           NULL, NULL,
           $$RTL's official docs recommend getByRole as the preferred query whenever possible, since it's closer to how a real user (or screen reader) perceives the page.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$getByText, in every single case with no exceptions$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$A direct document.querySelector call$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$There is no recommended preference -- every query is considered equally suitable$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$getByRole$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$RTL'nin resmi dokümanları, mümkün olduğunda TERCİH EDİLEN sorgu olarak hangisini önerir?$$,
           NULL, NULL,
           $$RTL'nin resmi dokümanları, gerçek bir kullanıcının (ya da ekran okuyucunun) sayfayı algılama şekline daha yakın olduğu için, mümkün olduğunda getByRole'u tercih edilen sorgu olarak önerir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$getByRole$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Hiçbir istisna olmadan, her durumda getByText$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Doğrudan bir document.querySelector çağrısı$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Önerilen bir tercih yoktur -- her sorgu eşit derecede uygun kabul edilir$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this JSX, what does screen.getByLabelText("Name") find?$$,
           $$<label htmlFor="name">Name</label>
<input id="name" type="text" />$$, $$jsx$$,
           $$getByLabelText("Name") finds the input connected to <label htmlFor="name">, with no need to add an id or a test-id specifically for the query.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The <label> element itself, not the input$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$The <input> element connected to the label via htmlFor/id$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Nothing -- getByLabelText requires a separate data-testid attribute to work$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Both the label and the input together, returned as a single combined element$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu JSX'e göre, screen.getByLabelText("Ad") neyi bulur?$$,
           $$<label htmlFor="ad">Ad</label>
<input id="ad" type="text" />$$, $$jsx$$,
           $$getByLabelText("Ad"), sorgu için özel olarak bir id ya da test-id eklemeye gerek kalmadan, <label htmlFor="ad">'a bağlı input'u bulur.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hem label hem input'u birlikte, tek bir birleşik element olarak$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$htmlFor/id aracılığıyla label'a bağlı olan <input> elementini$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Input değil, <label> elementinin kendisini$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Hiçbir şey -- getByLabelText'in çalışması için ayrı bir data-testid attribute'u gerekir$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe jest-dom matchers, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$toBeDisabled()/toBeEnabled() check an element's disabled attribute; toBeInTheDocument() verifies whether an element exists in the DOM; none of these exist in plain Vitest -- they're added by the jest-dom package.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$jest-dom matchers are built into Vitest by default, with no extra import needed$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$toBeInTheDocument() verifies whether an element exists in the DOM at all$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$None of these matchers exist in plain Vitest -- they're added specifically by the jest-dom package$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$toBeDisabled() checks the text content of an element, not its disabled attribute$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, jest-dom matcher'larını aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$toBeDisabled()/toBeEnabled(), bir elementin disabled attribute'unu kontrol eder; toBeInTheDocument(), bir elementin DOM'da var olup olmadığını doğrular; bunların hiçbiri sade Vitest'te yoktur -- jest-dom paketi tarafından eklenir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bu matcher'ların hiçbiri sade Vitest'te yoktur -- özellikle jest-dom paketi tarafından eklenir$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$toBeDisabled(), bir elementin disabled attribute'unu değil, metin içeriğini kontrol eder$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$jest-dom matcher'ları, ekstra bir import gerekmeden varsayılan olarak Vitest'e dahildir$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$toBeInTheDocument(), bir elementin DOM'da hiç var olup olmadığını doğrular$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe the difference between getByText and queryByText, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$getByText throws if it can't find the element; queryByText does NOT throw -- it returns null, which is why queryBy* is used to assert something is ABSENT from the screen.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$getByText and queryByText behave identically in every situation, with no real difference$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$queryByText is only usable for querying by ARIA role, never by text content$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$getByText throws an error if it can't find the matching element$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$queryByText returns null instead of throwing, which is why it's used to assert something is absent$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, getByText ile queryByText arasındaki farkı aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$getByText, eşleşen elementi bulamazsa hata fırlatır; queryByText fırlatMAZ -- null döndürür, bu yüzden bir şeyin ekranda YOK olduğunu iddia etmek için queryBy* kullanılır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$getByText, eşleşen elementi bulamazsa bir hata fırlatır$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$queryByText, hata fırlatmak yerine null döndürür, bu yüzden bir şeyin yok olduğunu iddia etmek için kullanılır$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$getByText ve queryByText, hiçbir gerçek fark olmadan her durumda birebir aynı şekilde davranır$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$queryByText yalnızca ARIA role'e göre sorgulamak için kullanılabilir, metin içeriğine göre asla kullanılamaz$$, FALSE, 3 FROM new_question_tr7;
