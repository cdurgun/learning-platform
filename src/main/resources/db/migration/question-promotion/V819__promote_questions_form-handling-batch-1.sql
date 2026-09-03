-- Promotion batch
-- Topic: form-handling (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V767-V794 (React Components & Props / State &
-- Events) and V731-V766 (Spring Data JPA), these 14 questions were NOT
-- produced by the n8n generation pipeline, NOT judged by the AI Judge, and
-- NOT ingested via /api/internal/questions/ingest -- per explicit user
-- request, they were hand-authored and independently self-reviewed directly
-- inside a Claude Code session, grounded strictly in content/en/form-handling.md
-- and content/tr/form-handling.md.
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
           $$Since a form's input is controlled, where does its value come from at the moment the form is submitted?$$,
           NULL, NULL,
           $$Since the input is controlled, the state is already up to date by the time the form is submitted -- there's no need to read the value from the DOM, you just use state directly.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'form-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$From state directly -- it's already up to date, with no need to read it from the DOM$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$From a fresh document.querySelector(...) call inside the submit handler$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$From the event object's event.formValue field$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Form values are never available at submit time in a controlled form$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir formun input'u kontrollü olduğu için, form gönderildiği anda değeri nereden gelir?$$,
           NULL, NULL,
           $$Input kontrollü olduğu için, form gönderildiği anda state zaten günceldir -- değeri DOM'dan okumaya gerek yoktur, doğrudan state kullanılır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'form-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Kontrollü bir formda, form değerleri submit anında hiçbir zaman erişilebilir değildir$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Doğrudan state'ten -- zaten günceldir, DOM'dan okumaya gerek yoktur$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Submit handler içinde taze bir document.querySelector(...) çağrısından$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Event nesnesinin event.formValue alanından$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$When a form has more than one input, what does this lesson recommend instead of a separate useState per field?$$,
           NULL, NULL,
           $$It's more manageable to keep them all in ONE state object.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'form-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Reading every field's value fresh from the DOM at submit time instead of using state at all$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Keeping them all in one state object$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Storing every field's value directly on the window object$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Using a separate component for each individual field's state$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir formda birden fazla input olduğunda, bu ders her alan için ayrı bir useState yerine neyi önerir?$$,
           NULL, NULL,
           $$Hepsini TEK bir state nesnesinde tutmak daha yönetilebilirdir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'form-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Her tek alanın state'i için ayrı bir component kullanmayı$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$State hiç kullanmadan, submit anında her alanın değerini DOM'dan taze okumayı$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Hepsini tek bir state nesnesinde tutmayı$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Her alanın değerini doğrudan window nesnesinde saklamayı$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$The user types into the input named "email". What does handleChange actually update?$$,
           $$const [formData, setFormData] = useState({ name: "", email: "" });

function handleChange(event) {
    const { name, value } = event.target;
    setFormData({ ...formData, [name]: value });
}

// <input name="email" value={formData.email} onChange={handleChange} />$$, $$jsx$$,
           $$event.target.name gives the name attribute of whichever input changed ("email" here) -- with [name]: value (a computed property name), this single handleChange updates only the email field, leaving name untouched.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'form-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A new field literally named "name" is added to formData, holding the typed text$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Nothing updates, since handleChange doesn't know which input triggered it$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Only formData.email is updated; formData.name stays untouched$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Both formData.name and formData.email are reset to empty strings$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Kullanıcı "eposta" adlı input'a yazıyor. handleChange gerçekte neyi günceller?$$,
           $$const [formVerisi, formVerisiAyarla] = useState({ ad: "", eposta: "" });

function handleChange(event) {
    const { name, value } = event.target;
    formVerisiAyarla({ ...formVerisi, [name]: value });
}

// <input name="eposta" value={formVerisi.eposta} onChange={handleChange} />$$, $$jsx$$,
           $$event.target.name, hangi input değiştiyse onun name attribute'unu verir ("eposta") -- [name]: value (bir computed property name) ile, bu tek handleChange yalnızca eposta alanını günceller, ad'a dokunmaz.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'form-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca formVerisi.eposta güncellenir; formVerisi.ad dokunulmadan kalır$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Hem formVerisi.ad hem formVerisi.eposta boş string'lere sıfırlanır$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$formVerisi'ne, yazılan metni tutan, gerçekten "name" adında yeni bir alan eklenir$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$handleChange hangi input'un onu tetiklediğini bilmediği için hiçbir şey güncellenmez$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why does handleChange write { ...formData, [name]: value } instead of directly mutating formData?$$,
           NULL, NULL,
           $$This follows the immutability rule from State: { ...formData, [name]: value } copies the old object and creates a NEW object with just one field changed.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'form-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Direct mutation is a JavaScript syntax error and would fail to compile$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$The spread syntax is required only because formData has exactly two fields$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$It has no real reason -- direct mutation would work exactly the same way$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$It follows the immutability rule from State -- it copies the old object into a new one with only that field changed$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$handleChange neden formVerisi'ni doğrudan mutate etmek yerine { ...formVerisi, [name]: value } yazar?$$,
           NULL, NULL,
           $$Bu, State'ten gelen immutability kuralını izler: { ...formVerisi, [name]: value }, eski nesneyi kopyalar ve yalnızca o alan değişmiş yeni bir nesne oluşturur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'form-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$State'ten gelen immutability kuralını izler -- eski nesneyi, yalnızca o alan değişmiş yeni bir nesneye kopyalar$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Doğrudan mutasyon bir JavaScript sözdizimi hatasıdır ve derlenmez$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Spread sözdizimi yalnızca formVerisi'nin tam olarak iki alanı olduğu için gereklidir$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Gerçek bir nedeni yoktur -- doğrudan mutasyon tam olarak aynı şekilde çalışırdı$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Where does this lesson's simple validation example check whether a field is empty?$$,
           NULL, NULL,
           $$The value is checked at submit time, inside handleSubmit -- if it's empty, a message is written into the error state and the function exits early (return), without actually "submitting" the form.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'form-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$At submit time, inside handleSubmit -- if empty, an error message is set and the function returns early$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Inside handleChange, on every single keystroke$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Inside a separate useEffect that runs once when the component mounts$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$It's checked automatically by the browser before onSubmit ever runs$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu dersin basit doğrulama örneği, bir alanın boş olup olmadığını nerede kontrol eder?$$,
           NULL, NULL,
           $$Değer, submit anında, handleSubmit içinde kontrol edilir -- boşsa, error state'ine bir mesaj yazılır ve fonksiyon, formu gerçekten "göndermeden", erken çıkar (return).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'form-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$onSubmit hiç çalışmadan önce tarayıcı tarafından otomatik olarak kontrol edilir$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Submit anında, handleSubmit içinde -- boşsa, bir hata mesajı ayarlanır ve fonksiyon erken döner$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$handleChange içinde, her tek tuş vuruşunda$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Component mount olduğunda bir kez çalışan ayrı bir useEffect içinde$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$error is an empty string (""). What does {error && <p>{error}</p>} render?$$,
           $$const [error, setError] = useState("");
// ...
return <div>{error && <p>{error}</p>}</div>;$$, $$jsx$$,
           $$If error is non-empty, the expression renders the error message; if error is empty (as it is here), an empty string is falsy, so nothing renders.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'form-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$React throws an error, since error is an empty string rather than a boolean$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Nothing renders -- an empty string is falsy, so the right side of && never renders$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$An empty <p></p> tag renders on screen$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$The literal text "error" is rendered$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$hata boş bir string (""). {hata && <p>{hata}</p>} ne render eder?$$,
           $$const [hata, hataAyarla] = useState("");
// ...
return <div>{hata && <p>{hata}</p>}</div>;$$, $$jsx$$,
           $$hata boş değilse, ifade hata mesajını render eder; hata boşsa (burada olduğu gibi), boş bir string falsy'dir, bu yüzden hiçbir şey render edilmez.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'form-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Literal "hata" metni render edilir$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$hata bir boolean değil boş bir string olduğu için React bir hata fırlatır$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Hiçbir şey render edilmez -- boş bir string falsy'dir, bu yüzden &&'in sağ tarafı asla render edilmez$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Ekranda boş bir <p></p> tag'i render edilir$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe validating a whole form with multiple fields, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$A validate() function produces a separate error message per field, collected into ONE newErrors object; if that object has no keys, the form is valid; each input shows only its own error.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'form-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Each input shows every field's error at once, not just its own$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Whole-form validation requires a completely different rendering technique than the && pattern used for a single field$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$A validate() function produces a separate error message for each field, collected into one newErrors object$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$If newErrors has no keys (Object.keys(newErrors).length === 0), the form is considered valid$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, birden fazla alanlı tüm bir formu doğrulamayı aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Bir validate() fonksiyonu, her alan için ayrı bir hata mesajı üretir, bunlar TEK bir yeniHatalar nesnesinde toplanır; bu nesnenin hiç key'i yoksa form geçerlidir; her input yalnızca kendi hatasını gösterir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'form-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir validate() fonksiyonu, her alan için ayrı bir hata mesajı üretir, tek bir yeniHatalar nesnesinde toplanır$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$yeniHatalar'ın hiç key'i yoksa (Object.keys(yeniHatalar).length === 0), form geçerli sayılır$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Her input, yalnızca kendi hatasını değil, her alanın hatasını aynı anda gösterir$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Tüm form doğrulaması, tek bir alan için kullanılan && kalıbından tamamen farklı bir render tekniği gerektirir$$, FALSE, 3 FROM new_question_tr7;
