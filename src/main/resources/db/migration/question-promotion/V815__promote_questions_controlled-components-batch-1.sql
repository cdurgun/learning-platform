-- Promotion batch
-- Topic: controlled-components (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V767-V794 (React Components & Props / State &
-- Events) and V731-V766 (Spring Data JPA), these 14 questions were NOT
-- produced by the n8n generation pipeline, NOT judged by the AI Judge, and
-- NOT ingested via /api/internal/questions/ingest -- per explicit user
-- request, they were hand-authored and independently self-reviewed directly
-- inside a Claude Code session, grounded strictly in content/en/controlled-components.md
-- and content/tr/controlled-components.md.
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
           $$What is a controlled component?$$,
           NULL, NULL,
           $$In a controlled component, the input's value is DETERMINED by React's state instead of the input holding its own value inside itself in the DOM.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'controlled-components'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A form element whose value is determined by React's state, instead of being held by the DOM itself$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$A component that can never be re-rendered once it's mounted$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$A component that only accepts props, never uses state$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$A component that automatically validates its own inputs without any code$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir controlled component (kontrollü component) nedir?$$,
           NULL, NULL,
           $$Kontrollü bir component'te, input'un değeri, DOM'un kendi içinde bir değer tutması yerine React'in state'i tarafından BELİRLENİR.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'controlled-components'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hiçbir kod olmadan kendi input'larını otomatik olarak doğrulayan bir component$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Değeri, DOM'un kendisi tarafından tutulmak yerine, React'in state'i tarafından belirlenen bir form elementi$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Mount edildikten sonra asla yeniden render edilemeyen bir component$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Yalnızca props kabul eden, hiç state kullanmayan bir component$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What does writing value={text} on an <input> guarantee?$$,
           NULL, NULL,
           $$Since value={text} is written, the value shown in the input is ALWAYS whatever text currently holds in state.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'controlled-components'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$text is automatically reset to an empty string on every render$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$The value shown in the input is always whatever text currently holds in state$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$The input automatically saves its value to localStorage$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$The input becomes read-only and can never be controlled again$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir <input>'a value={metin} yazmak neyi garanti eder?$$,
           NULL, NULL,
           $$value={metin} yazıldığı için, input'ta gösterilen değer HER ZAMAN metin'in o anda state'te tuttuğu değerdir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'controlled-components'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Input salt okunur hale gelir ve bir daha asla kontrollü olamaz$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$metin her render'da otomatik olarak boş bir string'e sıfırlanır$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Input'ta gösterilen değer her zaman metin'in o anda state'te tuttuğu değerdir$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Input otomatik olarak değerini localStorage'a kaydeder$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$This input has value but no onChange. What happens when the user tries to type into it?$$,
           $$function NameInput() {
    const [text, setText] = useState("");
    return <input value={text} />; // no onChange
}$$, $$jsx$$,
           $$value alone makes the input read-only -- the user can't type anything, since nothing updates state to reflect the keystroke.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'controlled-components'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$React throws a runtime error immediately when this component renders$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$The input works, but only accepts numbers, not letters$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$The user can type normally, and text updates automatically without onChange$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$The input effectively becomes read-only -- the user can't type anything$$, TRUE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu input'ta value var ama onChange yok. Kullanıcı bu input'a yazmaya çalıştığında ne olur?$$,
           $$function AdInput() {
    const [metin, metinAyarla] = useState("");
    return <input value={metin} />; // onChange yok
}$$, $$jsx$$,
           $$Tek başına value, input'u salt okunur yapar -- kullanıcı hiçbir şey yazamaz, çünkü tuş vuruşunu yansıtmak için hiçbir şey state'i güncellemiyor.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'controlled-components'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Kullanıcı normal şekilde yazabilir, ve metin onChange olmadan otomatik olarak güncellenir$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Bu component render edildiğinde React hemen bir çalışma zamanı hatası fırlatır$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Input çalışır, ama yalnızca sayıları kabul eder, harfleri değil$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Input etkin bir şekilde salt okunur hale gelir -- kullanıcı hiçbir şey yazamaz$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which attribute does a controlled checkbox use instead of value?$$,
           NULL, NULL,
           $$Checkboxes use checked instead of value, but the logic is the same -- React's state decides whether it's checked.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'controlled-components'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$selected$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$toggled$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$active$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$checked$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Kontrollü bir checkbox, value yerine hangi attribute'u kullanır?$$,
           NULL, NULL,
           $$Checkbox'lar value yerine checked kullanır, ama mantık aynıdır -- React'in state'i işaretli olup olmadığına karar verir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'controlled-components'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$checked$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$selected$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$toggled$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$active$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe how a controlled <select> works, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$A <select> is controlled with value and onChange, just like a text input -- the same pattern applies across different form elements.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'controlled-components'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A <select> is controlled with value and onChange, just like a text input$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$The same controlled pattern (state decides the value) applies across different kinds of form elements$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$A <select> can only ever be controlled with checked, never with value$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Controlled selects require a completely separate hook not used by text inputs$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, kontrollü bir <select>'in nasıl çalıştığını aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Bir <select>, tıpkı bir metin input'u gibi, value ve onChange ile kontrol edilir -- aynı kalıp farklı form elementleri arasında da geçerlidir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'controlled-components'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir <select> yalnızca checked ile kontrol edilebilir, value ile asla kontrol edilemez$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Kontrollü select'ler, metin input'larının kullanmadığı tamamen ayrı bir hook gerektirir$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Bir <select>, tıpkı bir metin input'u gibi, value ve onChange ile kontrol edilir$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Aynı kontrollü kalıp (state değere karar verir) farklı form elementi türlerinde de geçerlidir$$, TRUE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$text lives in state via useState. What does calling setText("") do to a controlled input bound to text?$$,
           $$const [text, setText] = useState("Hello");
// ... later, in a click handler:
setText("");$$, $$jsx$$,
           $$Since the value lives in state, clearing the input is as simple as setText("") -- the input, bound to text with value={text}, immediately re-renders empty.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'controlled-components'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It requires also calling a separate DOM reset() method to actually clear the input$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Nothing visible happens, since setText only affects the internal variable, not the rendered input$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$The controlled input immediately shows as empty, since it's always bound to the current state value$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$It throws an error, since state can't be set to an empty string$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$metin, useState aracılığıyla state'te tutuluyor. metin'e bağlı kontrollü bir input üzerinde metinAyarla("") çağırmak ne yapar?$$,
           $$const [metin, metinAyarla] = useState("Merhaba");
// ... daha sonra, bir click handler icinde:
metinAyarla("");$$, $$jsx$$,
           $$Değer state'te yaşadığı için, input'u temizlemek metinAyarla("") kadar basittir -- value={metin} ile metin'e bağlı input hemen boş olarak yeniden render edilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'controlled-components'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Input'u gerçekten temizlemek için ayrıca ayrı bir DOM reset() metodunu da çağırmak gerekir$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$State boş bir string'e ayarlanamayacağı için bir hata fırlatır$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Kontrollü input, her zaman o anki state değerine bağlı olduğu için hemen boş olarak görünür$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Görünür hiçbir şey olmaz, çünkü metinAyarla yalnızca dahili değişkeni etkiler, render edilen input'u etkilemez$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe the controlled-component loop (type → update state → re-render → show in input), according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$Every keystroke runs onChange, setText updates state, React re-renders, and the input's value reflects that new state; since the value lives in state, it can also be used instantly somewhere else on screen at the same time.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'controlled-components'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The input's DOM value updates itself first, and state catches up afterward$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$This loop only works for text inputs, never for checkboxes or selects$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Every keystroke runs onChange, which updates state via the setter function$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Since the value lives in state, it can be used instantly elsewhere on screen at the same time (like a character count)$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, kontrollü component döngüsünü (yaz → state'i güncelle → yeniden render et → input'ta göster) aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Her tuş vuruşu onChange'i çalıştırır, metinAyarla state'i günceller, React yeniden render eder, ve input'un value'su o yeni state'i yansıtır; değer state'te yaşadığı için, aynı anda ekranda başka bir yerde de anında kullanılabilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'controlled-components'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Her tuş vuruşu, setter fonksiyonu aracılığıyla state'i güncelleyen onChange'i çalıştırır$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Değer state'te yaşadığı için, aynı anda ekranda başka bir yerde de anında kullanılabilir (bir karakter sayacı gibi)$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Input'un DOM değeri önce kendini günceller, state daha sonra yetişir$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Bu döngü yalnızca metin input'ları için çalışır, checkbox'lar ya da select'ler için asla çalışmaz$$, FALSE, 3 FROM new_question_tr7;
