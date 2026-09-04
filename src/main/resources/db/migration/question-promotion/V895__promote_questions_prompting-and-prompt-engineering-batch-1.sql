-- Promotion batch
-- Topic: prompting-and-prompt-engineering (language: en x7, tr x7)
-- Generated: 2026-09-04 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project (React/Java/
-- Spring/Postgres/Git categories), these 14 questions were hand-authored
-- and independently self-reviewed directly inside a Claude Code session,
-- grounded strictly in content/en/prompting-and-prompt-engineering.md and content/tr/prompting-and-prompt-engineering.md --
-- NOT produced by the n8n generation pipeline, NOT judged by the AI Judge,
-- and NOT ingested via /api/internal/questions/ingest.
--
-- Strict 50/50 EN/TR split (7+7) organized as 7 CONCEPT PAIRS -- each EN
-- question has a TR counterpart testing the exact same concept, but
-- independently authored (different framing/options), not a translation.
-- Every question whose answer depends on shown code is typed CODE_OUTPUT
-- (never SINGLE_CHOICE/MULTIPLE_CHOICE with a code_snippet attached) --
-- fragments/quiz.html only renders code_snippet for CODE_OUTPUT questions,
-- per the bug found and fixed in try-catch-finally/V573.
--
-- Each question's 4 options are written with the correct answer at a
-- deterministic, varied position, computed via
-- (pair_num + version + lang_shift) % 4 -- per the bug found and fixed at
-- question-promotion/V598 (always-A bias) and refined again in the Spring
-- Data JPA batch (parity-locked EN/TR offsets).
--
-- source = 'CLAUDE' / reviewed_by = 'claude-code@anthropic.com' / status =
-- 'PUBLISHED' directly -- same documentation convention as every prior
-- manual batch. topic_id resolved by Topic.slug; question_option rows
-- reference the newly generated id via a WITH ... RETURNING id CTE.
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
           $$What is a "prompt," precisely?$$,
           NULL, NULL,
           $$This matches the lesson's definition -- a prompt is the part of context a person or system directly composes and controls; it isn't a separate filtering program, isn't fixed at pretraining, and isn't hidden internal reasoning the user never sees.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'prompting-and-prompt-engineering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The text a person or system composes and provides to an LLM to produce a response -- the part of context that is directly controlled$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$A separate program that runs alongside the LLM to filter its output$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$A fixed, unchangeable string built into the model during pretraining$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$The model's own internal reasoning that the user never sees$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir 'prompt' tam olarak nedir?$$,
           NULL, NULL,
           $$Bu, dersin tanımıyla örtüşür -- bir prompt, context'in bir kişi ya da sistem tarafından doğrudan oluşturulan ve kontrol edilen kısmıdır; ayrı bir filtreleme programı değildir, pretraining sırasında sabitlenmez ve kullanıcının hiç görmediği gizli bir iç akıl yürütme değildir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'prompting-and-prompt-engineering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Pretraining sırasında modele gömülen, sabit ve değiştirilemez bir dizge$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Modelin kullanıcının asla görmediği kendi iç akıl yürütmesi$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir kişinin veya sistemin bir yanıt üretmek için oluşturup LLM'e verdiği metin -- context'in doğrudan kontrol edilen kısmı$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$LLM'nin yanında çalışıp çıktısını filtreleyen ayrı bir program$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$In a structured LLM conversation, what is the system prompt's role, compared to the user prompt?$$,
           NULL, NULL,
           $$This matches the lesson's role definitions directly -- the system prompt sets overall behavior for the whole conversation (typically set once by the application), while the user prompt is the specific request in a given turn; the roles aren't identical, aren't reversed, and both are part of the same context the model reads.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'prompting-and-prompt-engineering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Only the system prompt is ever included in the model's context; the user prompt is processed separately$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$The system prompt sets the model's overall behavior/persona for the whole conversation, typically set once by the application; the user prompt is the specific request in a given turn$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$The system prompt and user prompt are identical in purpose, just different labels$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$The user prompt sets behavior for the whole conversation, while the system prompt is the specific per-turn request$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Yapılandırılmış bir LLM konuşmasında, system prompt'un rolü user prompt'a kıyasla nedir?$$,
           NULL, NULL,
           $$Bu, dersin rol tanımlarına doğrudan uyar -- system prompt, genellikle uygulama tarafından bir kez ayarlanan, tüm konuşma için genel davranışı belirler, user prompt ise belirli bir turdaki spesifik istektir; roller ne aynıdır ne tersine çevrilebilir ve ikisi de modelin okuduğu aynı context'in parçasıdır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'prompting-and-prompt-engineering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$System prompt ve user prompt amaç bakımından aynıdır, yalnızca farklı etiketlerdir$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$User prompt tüm konuşma için davranışı belirler, system prompt ise tur başına spesifik istektir$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Modelin context'ine yalnızca system prompt dahil edilir; user prompt ayrı işlenir$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$System prompt, genellikle uygulama tarafından bir kez ayarlanan, tüm konuşma için modelin genel davranışını/persona'sını belirler; user prompt ise belirli bir turdaki spesifik istektir$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A developer wants an LLM to return output in a very specific JSON structure that's hard to fully describe in words. According to this lesson, which approach tends to be more reliable, and why?$$,
           NULL, NULL,
           $$This matches the lesson's explicit tip that showing examples (few-shot) tends to be more reliable than describing a format in words -- the other options contradict this guidance or overgeneralize which approach always wins.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'prompting-and-prompt-engineering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Neither approach works reliably for structured output -- this is a fundamental limitation$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$A zero-shot prompt is always more reliable than few-shot, regardless of the task$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$A few-shot prompt showing two or three worked examples of the exact JSON structure, since demonstrating a format is often more reliable than describing it$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$A zero-shot prompt with an extremely long paragraph of formatting instructions$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir geliştirici, LLM'nin sözcüklerle tam olarak tarif edilmesi zor, çok özel bir JSON yapısında çıktı döndürmesini istiyor. Bu derse göre, hangi yaklaşım daha güvenilir olma eğilimindedir ve neden?$$,
           NULL, NULL,
           $$Bu, dersin bir formatı göstermenin genellikle onu tarif etmekten daha güvenilir olduğuna dair açık ipucuna uyar -- diğer seçenekler bu rehberlikle çelişir ya da hangi yaklaşımın her zaman kazandığını aşırı genellemektedir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'prompting-and-prompt-engineering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Tam olarak istenen JSON yapısının iki veya üç çözümlenmiş örneğini gösteren bir few-shot prompt, çünkü bir formatı göstermek genellikle onu tarif etmekten daha güvenilirdir$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Son derece uzun bir biçimlendirme talimatları paragrafı içeren bir zero-shot prompt$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Hiçbir yaklaşım yapılandırılmış çıktı için güvenilir şekilde çalışmaz -- bu temel bir kısıtlamadır$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Görevden bağımsız olarak zero-shot prompt her zaman few-shot'tan daha güvenilirdir$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A prompt says only "Summarize this" and produces inconsistent results across runs. According to this lesson's guidance on writing effective prompts, what is the most likely fix?$$,
           NULL, NULL,
           $$This matches the lesson's explicit example comparing a vague prompt to a specific one -- the fix is specificity (task, output format, focus), not switching models, removing instructions, or repeating the same vague wording.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'prompting-and-prompt-engineering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Switch to a completely different, larger model, since the prompt itself is fine$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Remove all instructions entirely, since instructions tend to confuse the model$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Repeat the same vague instruction multiple times in the same prompt$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Be specific about the task and desired output -- for example, specifying an exact format and focus, like "Summarize this in exactly three bullet points, focused on financial figures"$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir prompt yalnızca 'Bunu özetle' diyor ve çalıştırmalar arasında tutarsız sonuçlar üretiyor. Bu dersin etkili prompt yazma rehberliğine göre, en olası çözüm nedir?$$,
           NULL, NULL,
           $$Bu, dersin belirsiz bir prompt ile spesifik olanı karşılaştıran açık örneğine uyar -- çözüm spesifiklik (görev, çıktı formatı, odak) sağlamaktır, model değiştirmek, talimatları kaldırmak ya da aynı belirsiz ifadeyi tekrarlamak değil.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'prompting-and-prompt-engineering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Aynı belirsiz talimatı aynı prompt içinde birden çok kez tekrarlamak$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Görev ve istenen çıktı hakkında spesifik olmak -- örneğin, 'Bunu, finansal rakamlara odaklanarak tam olarak üç madde işaretiyle özetle' gibi tam bir format ve odak belirtmek$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Tamamen farklı, daha büyük bir modele geçmek, çünkü prompt'un kendisinde bir sorun yoktur$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Tüm talimatları tamamen kaldırmak, çünkü talimatlar genellikle modeli karıştırır$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$According to this lesson, how should prompt engineering be approached, and what is it most similar to?$$,
           NULL, NULL,
           $$This matches the lesson's explicit iterative "write, test, observe, revise, repeat" framing, compared to debugging/iterative software development -- it isn't a one-time task, isn't purely random trial and error, and testing is an integral part of the process, not something to avoid.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'prompting-and-prompt-engineering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$As an iterative process similar to debugging or iterative software development -- write, test against realistic inputs, observe failures, and revise, then repeat$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$As a one-time task -- write the prompt once, and it should work perfectly forever without revision$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$As a purely random trial-and-error process with no useful pattern to track$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$As a task that should be done only once, before any testing, since testing can bias the prompt$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, prompt engineering'e nasıl yaklaşılmalıdır ve en çok neye benzer?$$,
           NULL, NULL,
           $$Bu, dersin debugging veya yinelemeli (iterative) yazılım geliştirmeyle karşılaştırılan, açık 'yaz, test et, gözlemle, revize et, tekrarla' çerçevesine uyar -- tek seferlik bir görev değildir, tamamen rastgele bir deneme-yanılma değildir ve test etme sürecin kaçınılması gereken değil ayrılmaz bir parçasıdır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'prompting-and-prompt-engineering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İzlenecek yararlı bir kalıp olmayan, tamamen rastgele bir deneme-yanılma süreci olarak$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Test etme prompt'u yanlı hale getirebileceği için, herhangi bir testten önce yalnızca bir kez yapılması gereken bir görev olarak$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Debugging veya yinelemeli (iterative) yazılım geliştirmeye benzer, yinelemeli bir süreç olarak -- yaz, gerçekçi girdilere karşı test et, başarısızlıkları gözlemle ve revize et, sonra tekrarla$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Tek seferlik bir görev olarak -- prompt'u bir kez yaz, hiçbir revizyon olmadan sonsuza kadar mükemmel çalışmalıdır$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A developer adds "think through this step by step, then give your final answer" to a prompt for a multi-step math word problem, and accuracy improves. What is the mechanism behind this technique?$$,
           NULL, NULL,
           $$This matches the lesson's explanation of chain-of-thought prompting as feeding the model's own step-by-step reasoning back as additional context via in-context learning -- no external tool is invoked, no retraining occurs, and the technique doesn't work by shortening responses.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'prompting-and-prompt-engineering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It works by making the model's response shorter, which always improves accuracy$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$It's called chain-of-thought prompting -- it gives the model more of its own reasoning as additional context to condition its final answer on, via in-context learning$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$It gives the model access to an external calculator tool$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$It permanently retrains the model to be better at math$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir geliştirici, çok adımlı bir matematik problemi için bir prompt'a 'bunu adım adım düşün, sonra nihai cevabını ver' ekliyor ve doğruluk artıyor. Bu tekniğin arkasındaki mekanizma nedir?$$,
           NULL, NULL,
           $$Bu, dersin chain-of-thought prompting'i, in-context learning yoluyla modelin kendi adım adım akıl yürütmesini nihai cevabını dayandıracağı ek bağlam olarak geri beslemek şeklinde açıklamasına uyar -- harici bir araç çağrılmaz, yeniden eğitim gerçekleşmez ve teknik yanıtı kısaltarak çalışmaz.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'prompting-and-prompt-engineering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Modele harici bir hesap makinesi aracına erişim sağlar$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Modeli matematikte daha iyi olacak şekilde kalıcı olarak yeniden eğitir$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Modelin yanıtını kısaltarak çalışır, bu da her zaman doğruluğu artırır$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Buna chain-of-thought prompting denir -- in-context learning yoluyla, modelin kendi akıl yürütmesinin daha fazlasını, nihai cevabını dayandıracağı ek bağlam olarak verir$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about prompting, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and C are directly stated in the lesson (role/persona prompting shifting style/focus without granting new knowledge; explicit constraints being more reliable than implicit ones); length alone doesn't determine quality (precision/relevance matter more, and extra tokens cost money/time), and breaking a task into explicit steps is recommended as MORE reliable, not less.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'prompting-and-prompt-engineering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A longer, more elaborate prompt is always objectively better than a shorter, precise one$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Breaking a complex task into smaller, explicit steps inside a prompt tends to produce less reliable results than asking for everything at once$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Role/persona prompting (e.g., "as an experienced security engineer, review this code") shifts the style and focus of a response, but does not grant the model any new knowledge it didn't already have$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Stating constraints explicitly in a prompt (length limits, things to avoid) tends to be more reliable than leaving them implicit and hoping the model infers them$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, prompting hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve C derste doğrudan belirtilir (role/persona prompting'in tarzı/odağı değiştirip yeni bilgi vermemesi; açık kısıtlamaların örtük olanlardan daha güvenilir olması); uzunluğun tek başına kaliteyi belirlemediği (kesinlik/ilgi daha önemlidir ve ekstra token'lar para/zaman kaybettirir), ve karmaşık bir görevi açık adımlara bölmenin daha az değil, daha güvenilir sonuçlar için önerildiği belirtilir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'prompting-and-prompt-engineering'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Role/persona prompting (örneğin, 'deneyimli bir güvenlik mühendisi olarak bu kodu incele') bir yanıtın tarzını ve odağını değiştirir, ama modele daha önce sahip olmadığı hiçbir yeni bilgi vermez$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir prompt içinde kısıtlamaları (uzunluk sınırları, kaçınılması gerekenler) açıkça belirtmek, bunları örtük bırakıp modelin çıkarım yapmasını ummaktan daha güvenilir olma eğilimindedir$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Daha uzun, daha ayrıntılı bir prompt, her zaman daha kısa ve kesin bir prompt'tan nesnel olarak daha iyidir$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Karmaşık bir görevi prompt içinde daha küçük, açık adımlara bölmek, her şeyi bir kerede istemekten daha az güvenilir sonuçlar üretme eğilimindedir$$, FALSE, 3 FROM new_question_tr7;
