-- Promotion batch
-- Topic: portals (language: en x7, tr x7)
-- Generated: 2026-09-04 (this migration file's authoring date)
--
-- Like question-promotion/V823-V846 (React Routing / API & Data Fetching /
-- State Management) and V767-V822 (earlier React batches), these 14
-- questions were NOT produced by the n8n generation pipeline, NOT judged by
-- the AI Judge, and NOT ingested via /api/internal/questions/ingest -- per
-- explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/portals.md and content/tr/portals.md.
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
           $$What does createPortal(child, container) do?$$,
           NULL, NULL,
           $$It renders child into the container DOM node, instead of its normal position in the React tree.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'portals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Renders child into the container DOM node, instead of its normal position in the tree$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Creates a brand new, completely separate React application$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Converts a function component into a class component$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Deletes child from the DOM entirely after rendering it once$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$createPortal(child, container) ne yapar?$$,
           NULL, NULL,
           $$child'ı, normal ağaç konumu yerine container DOM node'una render eder.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'portals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$child'ı bir kez render ettikten sonra DOM'dan tamamen siler$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$child'ı, normal ağaç konumu yerine container DOM node'una render eder$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Yepyeni, tamamen ayrı bir React uygulaması oluşturur$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir function component'i bir class component'e dönüştürür$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$After using createPortal, where does the component appear in React DevTools, versus its actual DOM position?$$,
           NULL, NULL,
           $$It still appears in its expected place in the component tree (in React DevTools), but its actual DOM position is completely different.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'portals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$React DevTools shows it twice -- once in each location$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$It still appears in its expected place in the component tree; only its actual DOM position differs$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$It disappears from React DevTools entirely once a portal is used$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Both its DevTools position and DOM position change identically together$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$createPortal kullandıktan sonra, component React DevTools'ta nerede görünür, gerçek DOM konumuna kıyasla?$$,
           NULL, NULL,
           $$Component ağacında beklenen yerinde görünmeye devam eder (React DevTools'ta), ama gerçek DOM konumu tamamen farklıdır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'portals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hem DevTools konumu hem DOM konumu birlikte, aynı şekilde değişir$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$React DevTools onu iki kez gösterir -- her konumda bir kez$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Component ağacında beklenen yerinde görünmeye devam eder; yalnızca gerçek DOM konumu farklıdır$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Bir portal kullanıldığında React DevTools'tan tamamen kaybolur$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why can a modal's CSS (position: fixed, high z-index) sometimes fail to make it appear above the rest of the page?$$,
           NULL, NULL,
           $$The modal's actual DOM position (say, inside a card with overflow: hidden) can sometimes prevent that; a Portal eliminates this problem by rendering the modal directly into document.body.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'portals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Modals are structurally forbidden from using position: fixed at all$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$It never fails -- this is not a real problem Portals were designed to solve$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Its actual DOM position, like being nested inside an ancestor with overflow: hidden, can prevent it$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$CSS z-index has no real effect on any element in a React application$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir modal'ın CSS'i (position: fixed, yüksek z-index), neden bazen onu sayfanın geri kalanının ÜSTÜNDE göstermeyi başaramaz?$$,
           NULL, NULL,
           $$Modal'ın gerçek DOM konumu (örneğin overflow: hidden olan bir kartın içinde olması) bunu bazen engelleyebilir; bir Portal, modal'ı doğrudan document.body'ye render ederek bu sorunu ORTADAN KALDIRIR.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'portals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$CSS z-index'in bir React uygulamasındaki hiçbir element üzerinde gerçek bir etkisi yoktur$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Modal'lar yapısal olarak position: fixed kullanmaktan tamamen men edilmiştir$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Hiçbir zaman başarısız olmaz -- bu, Portal'ların çözmek için tasarlandığı gerçek bir sorun değildir$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$overflow: hidden olan bir atanın içine yerleştirilmiş olmak gibi gerçek DOM konumu bunu engelleyebilir$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Popup is rendered via a Portal into document.body, physically outside the outer div in the DOM. When the button inside Popup is clicked, does onClick on the outer div fire?$$,
           $$function Popup() {
    return createPortal(<button>Click</button>, document.body);
}

<div onClick={() => console.log("Outer div clicked")}>
    <Popup />
</div>$$, $$jsx$$,
           $$React propagates events according to its OWN component tree, not the actual DOM tree -- clicking the button still causes onClick to bubble up to the outer div, even though Popup renders outside it in the DOM.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'portals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yes -- React propagates events according to its own component tree, so the click still bubbles to the outer div$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$It throws a runtime error, since Portals cannot be clicked at all$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Only if document.body is manually given an onClick handler too$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$No -- since Popup is physically outside the div in the DOM, the click never reaches it$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$AcilirPencere, bir Portal aracılığıyla document.body'ye, DOM'da fiziksel olarak dış div'in dışına render ediliyor. AcilirPencere içindeki düğmeye tıklandığında, dış div'deki onClick tetiklenir mi?$$,
           $$function AcilirPencere() {
    return createPortal(<button>Tikla</button>, document.body);
}

<div onClick={() => console.log("Dis div tiklandi")}>
    <AcilirPencere />
</div>$$, $$jsx$$,
           $$React, olayları gerçek DOM ağacına göre değil KENDİ component ağacına göre yayar -- AcilirPencere DOM'da onun dışına render edilse bile, düğmeye tıklamak yine de onClick'in dış div'e kadar yükselmesine (bubble) neden olur.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'portals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Evet -- React, olayları kendi component ağacına göre yayar, bu yüzden tıklama yine de dış div'e kadar yükselir$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Hayır -- AcilirPencere DOM'da fiziksel olarak div'in dışında olduğu için, tıklama ona hiç ulaşmaz$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Bir çalışma zamanı hatası fırlatır, çünkü Portal'lara hiç tıklanamaz$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Yalnızca document.body'ye de elle bir onClick handler'ı verilirse$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What is the purpose of adding <div id="tooltip-root"></div> as a sibling to #root in index.html?$$,
           $$<body>
    <div id="root"></div>
    <div id="tooltip-root"></div>
</body>$$, $$jsx$$,
           $$Instead of document.body, a dedicated target is usually used; this makes it easier for the portal's content to manage its own styles and positioning.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'portals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It provides a dedicated portal target, making it easier to manage the portal content's own styles/positioning$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$It's required syntax -- createPortal cannot function without a second root div$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$It automatically duplicates the entire React application into a second instance$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$It disables React DevTools for anything rendered inside #root$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$index.html'de #root'a sibling olarak <div id="tooltip-root"></div> eklemenin amacı nedir?$$,
           $$<body>
    <div id="root"></div>
    <div id="tooltip-root"></div>
</body>$$, $$jsx$$,
           $$document.body yerine genellikle özel (dedicated) bir hedef kullanılır; bu, portal içeriğinin kendi stillerini ve konumlandırmasını yönetmesini kolaylaştırır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'portals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$#root içinde render edilen her şey için React DevTools'u devre dışı bırakır$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Özel bir portal hedefi sağlar, portal içeriğinin kendi stillerini/konumlandırmasını yönetmesini kolaylaştırır$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Zorunlu bir sözdizimidir -- createPortal ikinci bir root div olmadan çalışamaz$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Tüm React uygulamasını otomatik olarak ikinci bir instance'a kopyalar$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are named as common uses for Portals, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$The most common uses are modals, tooltips, and dropdowns -- to avoid CSS properties like overflow: hidden on ancestor elements.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'portals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Fetching data from a REST API$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Modals$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Tooltips and dropdowns$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Replacing all useState calls in an application$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, aşağıdakilerden hangileri Portal'ların yaygın kullanımları olarak belirtilir? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$En yaygın kullanımlar, ata elementlerdeki overflow: hidden gibi CSS özelliklerinden kaçınmak için modal'lar, tooltip'ler ve dropdown'lardır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'portals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Tooltip'ler ve dropdown'lar$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir uygulamadaki tüm useState çağrılarını değiştirmek$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir REST API'den veri getirmek$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Modal'lar$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly summarize a Portal's key properties, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$createPortal renders a component to a different DOM node while keeping its position in the React tree; events bubble according to React's component tree, not the actual DOM position -- this lets Portals keep working like normal components.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'portals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A Portal completely stops all events from bubbling to any ancestor at all$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$A Portal must be re-created manually on every single render for events to work$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$createPortal renders to a different DOM node while keeping the component's position in the React tree$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Events bubble according to React's component tree, not the actual DOM position$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, aşağıdakilerden hangileri bir Portal'ın temel özelliklerini doğru şekilde özetler? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$createPortal, component'in React ağacındaki konumunu korurken onu farklı bir DOM node'una render eder; olaylar gerçek DOM konumuna göre değil React'in component ağacına göre yükselir (bubble) -- bu, Portal'ların sıradan component'ler gibi çalışmaya devam etmesini sağlar.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'portals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$createPortal, component'in React ağacındaki konumunu korurken onu farklı bir DOM node'una render eder$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Olaylar, gerçek DOM konumuna göre değil, React'in component ağacına göre yükselir (bubble)$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir Portal, herhangi bir atadaki tüm olayların yükselmesini tamamen durdurur$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Olayların çalışması için bir Portal'ın her tek render'da elle yeniden oluşturulması gerekir$$, FALSE, 3 FROM new_question_tr7;
