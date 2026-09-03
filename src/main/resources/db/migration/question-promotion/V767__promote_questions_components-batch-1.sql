-- Promotion batch
-- Topic: components (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V731-V766 (Spring Data JPA) and V715-V730
-- (Advanced Spring), these 14 questions were NOT produced by the n8n
-- generation pipeline, NOT judged by the AI Judge, and NOT ingested via
-- /api/internal/questions/ingest -- per explicit user request, they were
-- hand-authored and independently self-reviewed directly inside a Claude Code
-- session, grounded strictly in content/en/components.md and
-- content/tr/components.md.
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
           $$At its simplest, what is a React component?$$,
           NULL, NULL,
           $$A component is a regular JavaScript function that returns JSX -- no new syntax or special keyword is needed.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'components'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A regular JavaScript function that returns JSX$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$A special class that must extend a React base class$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$A JSON configuration file describing a piece of UI$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$An HTML file with embedded JavaScript$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$En basit haliyle, bir React component'i nedir?$$,
           NULL, NULL,
           $$Bir component, JSX döndüren sıradan bir JavaScript fonksiyonudur -- yeni bir sözdizimi ya da özel bir anahtar kelime gerekmez.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'components'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İçine JavaScript gömülmüş bir HTML dosyası$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$JSX döndüren sıradan bir JavaScript fonksiyonu$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir React temel sınıfını extend etmesi gereken özel bir sınıf$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir UI parçasını tanımlayan bir JSON yapılandırma dosyası$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$How do you "use" (render) a component you've written, inside JSX?$$,
           NULL, NULL,
           $$You write it as a tag, like <Welcome />, exactly the same way you'd write <h1> or <div>.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'components'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$By adding it to a special components.json file$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$By calling it as a plain function: Welcome()$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$By writing it as a tag inside JSX, like <Welcome />$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$By importing it into an HTML <script> tag directly$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Yazdığın bir component'i JSX içinde nasıl "kullanırsın" (render edersin)?$$,
           NULL, NULL,
           $$Onu, tıpkı <h1> ya da <div> yazar gibi, bir tag olarak yazarsın, örneğin <Welcome />.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'components'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Doğrudan bir HTML <script> tag'ine import ederek$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Özel bir components.json dosyasına ekleyerek$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$JSX içinde onu bir tag olarak yazarak, örneğin <Welcome />$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Sade bir fonksiyon olarak çağırarak: Welcome()$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$How does React tell a component apart from a regular HTML tag?$$,
           NULL, NULL,
           $$By whether the name starts with an uppercase or lowercase letter -- uppercase means component, lowercase means a regular HTML tag.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'components'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$By checking whether the function is declared with the word "function" or as an arrow function$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$By checking whether the file name ends in .jsx$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$By whether the name starts with an uppercase or lowercase letter$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$By checking whether the function has any parameters$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$React, bir component'i sıradan bir HTML tag'inden nasıl ayırt eder?$$,
           NULL, NULL,
           $$Adın büyük harfle mi yoksa küçük harfle mi başladığına bakarak -- büyük harf component, küçük harf sıradan bir HTML tag'i demektir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'components'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Fonksiyonun herhangi bir parametresi olup olmadığını kontrol ederek$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Fonksiyonun "function" kelimesiyle mi yoksa arrow function olarak mı tanımlandığını kontrol ederek$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Dosya adının .jsx ile bitip bitmediğini kontrol ederek$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Adın büyük harfle mi yoksa küçük harfle mi başladığına bakarak$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does React do when this JSX is rendered?$$,
           $$function welcome() {
    return <h1>Hello!</h1>;
}

function App() {
    return <welcome />;
}$$, $$jsx$$,
           $$Since the name starts with a lowercase letter, React treats <welcome /> as a regular HTML tag (like a custom, unrecognized element), not as the welcome function component.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'components'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$React treats <welcome /> as a regular (unrecognized) HTML tag, not as the welcome function component$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$React throws a compile error because component names must be capitalized$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$React automatically capitalizes the name and renders it correctly$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$React renders the h1 "Hello!" text as expected$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu JSX render edildiğinde React ne yapar?$$,
           $$function selamla() {
    return <h1>Merhaba!</h1>;
}

function App() {
    return <selamla />;
}$$, $$jsx$$,
           $$Ad küçük harfle başladığı için, React <selamla />'yı selamla fonksiyon component'i olarak değil, sıradan (tanınmayan) bir HTML tag'i olarak ele alır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'components'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$React <selamla />'yı selamla fonksiyon component'i olarak değil, sıradan (tanınmayan) bir HTML tag'i olarak ele alır$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$React beklendiği gibi h1 "Merhaba!" metnini render eder$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$React derleme hatası fırlatır, çünkü component adları büyük harfle başlamalıdır$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$React adı otomatik olarak büyük harfe çevirir ve doğru render eder$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What is the biggest benefit of writing something as a component, according to this lesson?$$,
           NULL, NULL,
           $$Write it once, use it as many times as you want -- the same component can be rendered multiple times without rewriting the same HTML each time.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'components'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Components always run faster than plain HTML$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Write it once, use it as many times as you want$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Components automatically fetch their own data from a server$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Components eliminate the need to write any JavaScript at all$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir şeyi component olarak yazmanın en büyük faydası nedir?$$,
           NULL, NULL,
           $$Bir kez yaz, istediğin kadar kullan -- aynı component, her seferinde aynı HTML'i yeniden yazmadan birden fazla kez render edilebilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'components'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Component'ler hiç JavaScript yazma ihtiyacını ortadan kaldırır$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Bir kez yaz, istediğin kadar kullan$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Component'ler her zaman düz HTML'den daha hızlı çalışır$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Component'ler otomatik olarak kendi verilerini bir sunucudan getirir$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about using components inside other components, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$A component can be used inside another component (like App using Welcome), and this is done with the same tag syntax as any other component usage.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'components'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Using a component inside another requires a special nested keyword$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$A component can be used inside another component, like App using Welcome$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$A component used inside another one still follows the same uppercase naming rule$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$A component can only be used once across the entire application$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, component'leri başka component'lerin içinde kullanmakla ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Bir component başka bir component'in içinde kullanılabilir (App'in Welcome kullanması gibi), ve bu, başka herhangi bir component kullanımıyla aynı tag sözdizimiyle yapılır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'components'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Başka bir component'in içinde kullanılan bir component yine de aynı büyük harf kuralına uyar$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir component, tüm uygulama boyunca yalnızca bir kez kullanılabilir$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir component'i başka birinin içinde kullanmak özel bir nested anahtar kelimesi gerektirir$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir component, App'in Welcome kullanması gibi, başka bir component'in içinde kullanılabilir$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Given this code, what actually appears on screen?$$,
           $$function Welcome() {
    return <h1>Hello!</h1>;
}

function App() {
    return <div>App content</div>;
}$$, $$jsx$$,
           $$Nothing from Welcome appears -- defining a component function doesn't render it; a component only shows up on screen once it's actually used (rendered) as a tag somewhere, and Welcome is never used here.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'components'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Only "Hello!" appears, since it's defined first$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Neither appears, since App doesn't explicitly call Welcome()$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Both "Hello!" and "App content" appear, since Welcome is defined$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Only "App content" appears -- Welcome is defined but never rendered anywhere$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu koda göre, ekranda gerçekte ne görünür?$$,
           $$function Selam() {
    return <h1>Merhaba!</h1>;
}

function App() {
    return <div>App icerigi</div>;
}$$, $$jsx$$,
           $$Selam'dan hiçbir şey görünmez -- bir component fonksiyonunu tanımlamak onu render etmez; bir component ancak bir yerde gerçekten bir tag olarak kullanıldığında (render edildiğinde) ekranda görünür, ve Selam burada hiç kullanılmıyor.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'components'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Selam tanımlandığı için hem "Merhaba!" hem "App icerigi" görünür$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Yalnızca "App icerigi" görünür -- Selam tanımlanmış ama hiçbir yerde render edilmemiş$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Yalnızca "Merhaba!" görünür, çünkü önce tanımlanmış$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$App, Selam()'ı açıkça çağırmadığı için ikisi de görünmez$$, FALSE, 3 FROM new_question_tr7;
