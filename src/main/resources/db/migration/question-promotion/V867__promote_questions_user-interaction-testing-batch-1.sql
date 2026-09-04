-- Promotion batch
-- Topic: user-interaction-testing (language: en x7, tr x7)
-- Generated: 2026-09-04 (this migration file's authoring date)
--
-- Like question-promotion/V823-V846 (React Routing / API & Data Fetching /
-- State Management) and V767-V822 (earlier React batches), these 14
-- questions were NOT produced by the n8n generation pipeline, NOT judged by
-- the AI Judge, and NOT ingested via /api/internal/questions/ingest -- per
-- explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/user-interaction-testing.md and content/tr/user-interaction-testing.md.
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
           $$Why do RTL's official docs now recommend user-event over fireEvent?$$,
           NULL, NULL,
           $$fireEvent dispatches a single DOM event directly; user-event simulates the IN-BETWEEN steps a real user triggers while clicking/typing too (hover, focus, pointer events).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'user-interaction-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$user-event simulates the in-between steps a real user triggers (hover, focus, pointer events), not just a single event$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$fireEvent has been completely removed from React Testing Library and no longer exists$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$user-event runs tests significantly faster than fireEvent in every case$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$There's no real difference -- the recommendation is purely stylistic$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$RTL'nin resmi dokümanları artık fireEvent yerine user-event'i neden öneriyor?$$,
           NULL, NULL,
           $$fireEvent, doğrudan tek bir DOM olayı gönderir; user-event, gerçek bir kullanıcının tıklarken/yazarken tetiklediği ARA adımları da (hover, focus, pointer olayları) simüle eder.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'user-interaction-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Gerçek bir fark yoktur -- öneri tamamen stilistiktir$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$user-event, yalnızca tek bir olayı değil, gerçek bir kullanıcının tetiklediği ara adımları da (hover, focus, pointer olayları) simüle eder$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$fireEvent, React Testing Library'den tamamen kaldırıldı ve artık mevcut değil$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$user-event, her durumda fireEvent'ten önemli ölçüde daha hızlı test çalıştırır$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What must you always do with methods like click and type on the object returned by userEvent.setup()?$$,
           NULL, NULL,
           $$This object's methods are ALWAYS asynchronous and must be awaited -- forget to, and the test moves to the next line before the click finishes, checking a stale DOM state.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'user-interaction-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Nothing special -- they behave as ordinary synchronous function calls$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Always await them, since they are always asynchronous$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Wrap them in a try/catch block every single time$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Call them only inside a beforeEach block, never inside it()$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$userEvent.setup()'ın döndürdüğü nesnedeki click ve type gibi metotlarla her zaman ne yapmalısın?$$,
           NULL, NULL,
           $$Bu nesnenin metotları HER ZAMAN asenkrondur ve await edilmelidir -- unutursan, test tıklama bitmeden bir sonraki satıra geçer ve eski (stale) bir DOM durumunu kontrol eder.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'user-interaction-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca bir beforeEach bloğunun içinde çağırmalısın, it() içinde asla değil$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Özel bir şey yapmana gerek yok -- sıradan senkron fonksiyon çağrıları gibi davranırlar$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Her zaman await etmelisin, çünkü her zaman asenkrondurlar$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Her seferinde bir try/catch bloğuna sarmalamalısın$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does user.type(input, "Ada") actually simulate?$$,
           $$const user = userEvent.setup();
const input = screen.getByLabelText("Name");
await user.type(input, "Ada");$$, $$jsx$$,
           $$user.type types the given text CHARACTER BY CHARACTER -- each keystroke triggers the controlled component's onChange, much like typing on a real keyboard would.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'user-interaction-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It only triggers onChange once, after all three characters are already typed$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$It requires the input to already contain the text "Ada" beforehand$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$It sets the input's value to "Ada" all at once, in a single operation$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$It types "Ada" character by character, triggering onChange on each keystroke$$, TRUE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$user.type(input, "Ada") gerçekte neyi simüle eder?$$,
           $$const user = userEvent.setup();
const input = screen.getByLabelText("Ad");
await user.type(input, "Ada");$$, $$jsx$$,
           $$user.type, verilen metni KARAKTER KARAKTER yazar -- her tuş vuruşu, tıpkı gerçek bir klavyede yazmak gibi, kontrollü component'in onChange'ini tetikler.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'user-interaction-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Input'un değerini tek bir işlemde, hepsini birden "Ada" olarak ayarlar$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Yalnızca üç karakter de yazıldıktan sonra, onChange'i bir kez tetikler$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Input'un önceden zaten "Ada" metnini içermesini gerektirir$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$"Ada"yı karakter karakter yazar, her tuş vuruşunda onChange'i tetikler$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What is vi.fn() used for?$$,
           NULL, NULL,
           $$vi.fn() creates a FAKE function that stands in for a real prop -- without any real request leaving the component, we can verify what arguments this function was called with and how many times.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'user-interaction-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Creating a real network request to a test server$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Rendering a component into the fake DOM$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Simulating a user clicking a specific button on screen$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Creating a fake function standing in for a real prop, to verify how and how often it was called$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$vi.fn() ne için kullanılır?$$,
           NULL, NULL,
           $$vi.fn(), gerçek bir prop'un yerini alan SAHTE bir fonksiyon oluşturur -- component'ten hiçbir gerçek istek çıkmadan, bu fonksiyonun hangi argümanlarla ve kaç kez çağrıldığını doğrulayabiliriz.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'user-interaction-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Gerçek bir prop'un yerini alan sahte bir fonksiyon oluşturmak, nasıl ve kaç kez çağrıldığını doğrulamak için$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Bir test sunucusuna gerçek bir ağ isteği oluşturmak$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Bir component'i sahte DOM'a render etmek$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Kullanıcının ekranda belirli bir düğmeye tıklamasını simüle etmek$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What do toHaveBeenCalledWith(...) and toHaveBeenCalledTimes(...) verify?$$,
           NULL, NULL,
           $$These are matchers specific to mock functions (like those created with vi.fn()) -- they verify what arguments a function was called with and how many times.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'user-interaction-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$What arguments a mock function was called with, and how many times it was called$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Whether an element is currently visible in the DOM$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Whether a form's input has a specific placeholder text$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$How long a component took to render, in milliseconds$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$toHaveBeenCalledWith(...) ve toHaveBeenCalledTimes(...) neyi doğrular?$$,
           NULL, NULL,
           $$Bunlar, vi.fn() ile oluşturulanlar gibi mock fonksiyonlara özgü matcher'lardır -- bir fonksiyonun hangi argümanlarla ve kaç kez çağrıldığını doğrularlar.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'user-interaction-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir component'in render edilmesinin milisaniye cinsinden ne kadar sürdüğünü$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Bir mock fonksiyonun hangi argümanlarla çağrıldığını ve kaç kez çağrıldığını$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Bir elementin DOM'da şu anda görünür olup olmadığını$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Bir formun input'unun belirli bir placeholder metnine sahip olup olmadığını$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$CourseList fetches data on mount and eventually renders a course title, but not immediately. Which query correctly waits for it to appear?$$,
           $$render(<CourseList />);
// Immediately after render, the data hasn't arrived yet
const title = await screen.findByText("Introduction to React");$$, $$jsx$$,
           $$findByText is ASYNCHRONOUS: it doesn't throw if the element isn't there immediately, it retries for a set amount of time (1000ms by default) and continues once the element appears -- unlike getByText, which checks the DOM only at that moment.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'user-interaction-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$None of RTL's queries can wait for content that isn't there yet$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$findByText -- it retries for a set amount of time instead of failing immediately$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$getByText, since it behaves identically to findByText in every situation$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$queryByText, since it's specifically designed to wait for asynchronous content$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$KursListesi, mount olduğunda veri getirir ve sonunda bir kurs başlığı render eder, ama hemen değil. Hangi sorgu, onun görünmesini doğru şekilde bekler?$$,
           $$render(<KursListesi />);
// Render'dan hemen sonra, veri henuz gelmedi
const baslik = await screen.findByText("React'e Giris");$$, $$jsx$$,
           $$findByText ASENKRONDUR: element hemen orada değilse hata fırlatmaz, belirli bir süre (varsayılan 1000ms) yeniden dener ve element göründüğünde devam eder -- element sadece o anda DOM'u kontrol eden getByText'in aksine.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'user-interaction-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$queryByText, çünkü özellikle asenkron içeriği beklemek için tasarlanmıştır$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$RTL'nin hiçbir sorgusu henüz orada olmayan içeriği bekleyemez$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$findByText -- hemen başarısız olmak yerine belirli bir süre yeniden dener$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$getByText, çünkü her durumda findByText ile birebir aynı şekilde davranır$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe testing asynchronous UI updates, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$This is the correct way to test anything that changes the DOM over time (fetch, timers, post-animation state); waitFor(...) can be used for the same purpose as findByText.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'user-interaction-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$getByText and queryByText are both fully async and retry automatically, just like findByText$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Asynchronous DOM updates can never be reliably tested at all$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$findByText is the correct way to test anything that changes the DOM over time, like a fetch result$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$waitFor(...) can be used for the same purpose as findByText$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, asenkron UI güncellemelerini test etmeyi aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Bu, bir fetch sonucu gibi zamanla DOM'u değiştiren her şeyi test etmenin doğru yoludur; waitFor(...) findByText ile aynı amaç için kullanılabilir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'user-interaction-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$findByText, bir fetch sonucu gibi zamanla DOM'u değiştiren her şeyi test etmenin doğru yoludur$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$waitFor(...), findByText ile aynı amaç için kullanılabilir$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$getByText ve queryByText, tıpkı findByText gibi, tamamen asenkrondur ve otomatik olarak yeniden dener$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Asenkron DOM güncellemeleri hiçbir zaman güvenilir şekilde test edilemez$$, FALSE, 3 FROM new_question_tr7;
