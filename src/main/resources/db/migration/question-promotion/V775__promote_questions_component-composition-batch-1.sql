-- Promotion batch
-- Topic: component-composition (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V731-V766 (Spring Data JPA) and V715-V730
-- (Advanced Spring), these 14 questions were NOT produced by the n8n
-- generation pipeline, NOT judged by the AI Judge, and NOT ingested via
-- /api/internal/questions/ingest -- per explicit user request, they were
-- hand-authored and independently self-reviewed directly inside a Claude Code
-- session, grounded strictly in content/en/component-composition.md and
-- content/tr/component-composition.md.
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
           $$What is the children prop?$$,
           NULL, NULL,
           $$children is a special prop every component gets automatically, carrying whatever is written between that component's opening and closing tags.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-composition'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A special prop every component gets automatically, carrying what's written between its opening and closing tags$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$An array of every prop a component has ever received$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$A CSS class automatically applied to nested elements$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$A required prop you must always pass manually like any other attribute$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$children prop'u nedir?$$,
           NULL, NULL,
           $$children, her component'in otomatik olarak aldığı, o component'in açılış ve kapanış tag'leri arasına yazılan her şeyi taşıyan özel bir prop'tur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-composition'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Her zaman diğer herhangi bir attribute gibi elle geçirmen gereken zorunlu bir prop$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Her component'in otomatik olarak aldığı, açılış ve kapanış tag'leri arasına yazılanı taşıyan özel bir prop$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir component'in şimdiye kadar aldığı her prop'un bir dizisi$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$İç içe elementlere otomatik olarak uygulanan bir CSS class'ı$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does Box's children equal in this code?$$,
           $$function Box({ children }) {
    return <div className="box">{children}</div>;
}

<Box>
    <p>Hello there</p>
</Box>$$, $$jsx$$,
           $$Whatever is written between Box's opening and closing tags becomes its children -- here, that's the <p>Hello there</p> element.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-composition'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$An empty array, since Box has no attributes$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$The string "Box"$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$undefined, since children was never passed as an attribute$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$The <p>Hello there</p> element written between Box's opening and closing tags$$, TRUE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kodda Kutu'nun children'ı neye eşittir?$$,
           $$function Kutu({ children }) {
    return <div className="kutu">{children}</div>;
}

<Kutu>
    <p>Merhaba</p>
</Kutu>$$, $$jsx$$,
           $$Kutu'nun açılış ve kapanış tag'leri arasına yazılan her şey onun children'ı olur -- burada bu, <p>Merhaba</p> elementidir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-composition'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$children hiç bir attribute olarak geçirilmediği için undefined$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Kutu'nun hiç attribute'u olmadığı için boş bir dizi$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Kutu'nun açılış ve kapanış tag'leri arasına yazılan <p>Merhaba</p> elementi$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$"Kutu" string'i$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe how children differs from a regular prop like name or age? (Select all that apply)$$,
           NULL, NULL,
           $$children is written INSIDE the tag, not as an attribute; regular props are written as attributes on the opening tag itself.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-composition'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$children requires a completely different component function signature that can never use destructuring$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Regular props can never be combined with children on the same component$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$children is written inside a component's opening and closing tags, not as an attribute$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$A regular prop like name is written as an attribute, e.g. name="Ayşe"$$, TRUE, 3 FROM new_question_en3;

-- Pair 3 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri children'ın ad ya da yas gibi sıradan bir prop'tan farkını doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$children, bir attribute olarak değil, component'in açılış ve kapanış tag'lerinin İÇİNE yazılır; ad gibi sıradan bir prop ise açılış tag'inin kendisinde bir attribute olarak yazılır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-composition'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$children, bir attribute olarak değil, component'in açılış ve kapanış tag'lerinin içine yazılır$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$ad gibi sıradan bir prop, ad="Ayşe" gibi bir attribute olarak yazılır$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$children, asla destructuring kullanamayan tamamen farklı bir component fonksiyon imzası gerektirir$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Sıradan prop'lar aynı component'te children ile asla birleştirilemez$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What does it mean that "components can be nested"?$$,
           NULL, NULL,
           $$A component can contain other components, which can themselves contain other components -- this is how a large UI is built out of small, focused components.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-composition'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Every component file must be saved inside a folder named after its parent$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Component functions can be called recursively an unlimited number of times automatically$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Nested components share the exact same name as their parent$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$A component can contain other components, building a large UI from small pieces$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$"Component'ler nested (iç içe) olabilir" ne anlama gelir?$$,
           NULL, NULL,
           $$Bir component, kendileri de başka component'ler içerebilen başka component'ler içerebilir -- büyük bir UI, küçük, odaklanmış component'lerden bu şekilde inşa edilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-composition'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir component başka component'ler içerebilir, büyük bir UI'ı küçük parçalardan inşa eder$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Her component dosyası, parent'ının adını taşıyan bir klasörün içine kaydedilmelidir$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Component fonksiyonları otomatik olarak sınırsız sayıda özyinelemeli (recursive) çağrılabilir$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Nested component'ler parent'larıyla tam olarak aynı adı taşır$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this structure, which components does App ultimately render, directly or indirectly?$$,
           $$function Avatar() { return <img alt="avatar" />; }
function UserName() { return <span>Ayşe</span>; }
function UserProfile() {
    return (
        <div>
            <Avatar />
            <UserName />
        </div>
    );
}
function App() {
    return <UserProfile />;
}$$, $$jsx$$,
           $$App renders UserProfile directly, and UserProfile renders Avatar and UserName -- so all three end up rendered as part of App's tree.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-composition'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Only UserProfile -- Avatar and UserName are unrelated to App$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$UserProfile, Avatar, and UserName all end up rendered as part of App's tree$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Only Avatar and UserName -- UserProfile is skipped since it has no content of its own$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$None of them, since App only returns a single tag$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu yapıya göre, App nihayetinde hangi component'leri, doğrudan ya da dolaylı olarak, render eder?$$,
           $$function Avatar() { return <img alt="avatar" />; }
function KullaniciAdi() { return <span>Ayse</span>; }
function KullaniciProfili() {
    return (
        <div>
            <Avatar />
            <KullaniciAdi />
        </div>
    );
}
function App() {
    return <KullaniciProfili />;
}$$, $$jsx$$,
           $$App doğrudan KullaniciProfili'ni render eder, ve KullaniciProfili de Avatar ile KullaniciAdi'nı render eder -- bu yüzden üçü de App'in ağacının parçası olarak render edilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-composition'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hiçbiri, çünkü App yalnızca tek bir tag döndürür$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$KullaniciProfili, Avatar ve KullaniciAdi'nın üçü de App'in ağacının parçası olarak render edilir$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Yalnızca KullaniciProfili -- Avatar ve KullaniciAdi, App ile ilgisizdir$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Yalnızca Avatar ve KullaniciAdi -- KullaniciProfili kendi içeriği olmadığı için atlanır$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Does React use class inheritance (one component extending another) to combine components?$$,
           NULL, NULL,
           $$No -- React components have no such inheritance; components are combined through composition (nesting components inside each other via children), not inheritance.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-composition'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It depends on whether the components share the same file$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Yes -- every component must extend a shared base component class$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$No -- React components are combined through composition, not inheritance$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Only class components use inheritance; function components can't be combined at all$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$React, component'leri birleştirmek için class inheritance (bir component'in başka birini extend etmesi) kullanır mı?$$,
           NULL, NULL,
           $$Hayır -- React component'lerinde böyle bir inheritance yoktur; component'ler inheritance ile değil, composition ile (children aracılığıyla birbirinin içine yerleştirilerek) birleştirilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-composition'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca class component'ler inheritance kullanır; function component'ler hiç birleştirilemez$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Aynı dosyayı paylaşıp paylaşmadıklarına bağlıdır$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Hayır -- React component'leri inheritance ile değil, composition ile birleştirilir$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Evet -- her component paylaşılan bir temel component sınıfını extend etmelidir$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true, according to this lesson's coverage of composition vs. inheritance? (Select all that apply)$$,
           NULL, NULL,
           $$The React team has said composition is enough for nearly every scenario, which is why you won't see a pattern like extending a component with extends in React.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-composition'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Inheritance between components is the officially recommended default pattern in React$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Composition and inheritance produce identical component trees and are interchangeable$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$The React team has said composition is enough for nearly every scenario$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$You won't see a pattern like extending a component with extends between React components$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu dersin composition ile inheritance karşılaştırmasına göre, aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$React ekibi, composition'ın neredeyse her senaryo için yeterli olduğunu belirtmiştir, bu yüzden React'te bir component'i extends ile extend etmek gibi bir kalıp görmezsin.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'component-composition'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$React ekibi, composition'ın neredeyse her senaryo için yeterli olduğunu belirtmiştir$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Component'ler arasında bir component'i extends ile extend etmek gibi bir kalıp görmezsin$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Component'ler arasında inheritance, React'in resmi olarak önerdiği varsayılan kalıptır$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Composition ve inheritance birebir aynı component ağaçlarını üretir ve birbirinin yerine kullanılabilir$$, FALSE, 3 FROM new_question_tr7;
