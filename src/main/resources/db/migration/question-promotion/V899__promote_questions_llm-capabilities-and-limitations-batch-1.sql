-- Promotion batch
-- Topic: llm-capabilities-and-limitations (language: en x7, tr x7)
-- Generated: 2026-09-04 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project (React/Java/
-- Spring/Postgres/Git categories), these 14 questions were hand-authored
-- and independently self-reviewed directly inside a Claude Code session,
-- grounded strictly in content/en/llm-capabilities-and-limitations.md and content/tr/llm-capabilities-and-limitations.md --
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
           $$According to this lesson, which of the following is a genuine strength of modern LLMs?$$,
           NULL, NULL,
           $$This matches the lesson's explicit list of genuine strengths (text transformation, drafting/explaining code, general-knowledge Q&A, instruction-following, few-shot pattern-matching); guaranteed factual correctness, live real-time event access, and guaranteed-correct arithmetic are explicitly named as things LLMs do NOT reliably do.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'llm-capabilities-and-limitations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Transforming text -- summarizing, translating, and rewriting in a different tone -- among other things$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Guaranteeing factually correct answers on every question asked$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Having live, real-time access to events happening right now$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Performing precise, guaranteed-correct multi-step arithmetic every time$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, aşağıdakilerden hangisi modern LLM'lerin gerçek bir gücüdür?$$,
           NULL, NULL,
           $$Bu, dersin açık güçlü yön listesine uyar (metin dönüştürme, kod taslağı hazırlama/açıklama, genel bilgi soru-cevabı, talimat takibi, few-shot örüntü eşleştirme); garantili gerçek doğruluk, canlı gerçek zamanlı olay erişimi ve garantili doğru aritmetik, LLM'lerin güvenilir şekilde YAPAMADIĞI şeyler olarak açıkça belirtilir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'llm-capabilities-and-limitations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Şu anda gerçekleşen olaylara canlı, gerçek zamanlı erişime sahip olmak$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Her seferinde kesin, garantili doğru çok adımlı aritmetik işlemler yapmak$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Metni dönüştürmek -- özetlemek, çevirmek ve farklı bir tonda yeniden yazmak -- diğer şeylerin yanı sıra$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Sorulan her soruda gerçeğe uygun doğru cevapları garanti etmek$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Why does hallucination happen in LLMs, according to this lesson?$$,
           NULL, NULL,
           $$This matches the lesson's direct causal explanation: pretraining optimizes for a plausible next token, not a verified one, and there is no built-in fact-checker; the lesson explicitly states hallucination is structural and present in every LLM to some degree, not a rare bug, not adversarial-only, and not intentional deception (the model has no intent).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'llm-capabilities-and-limitations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It happens because the model intentionally lies to the user$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Pretraining optimizes for predicting a plausible next token, not a verified one -- there is no built-in mechanism checking generated text against ground truth$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$It's a rare software bug that only affects a small number of poorly-built models$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$It only happens when a user deliberately tries to trick the model with adversarial prompts$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, LLM'lerde hallucination neden gerçekleşir?$$,
           NULL, NULL,
           $$Bu, dersin doğrudan nedensel açıklamasına uyar: pretraining, doğrulanmış değil, olası (plausible) bir sonraki token'ı tahmin etmeyi optimize eder ve yerleşik bir gerçek-kontrolcüsü yoktur; ders, hallucination'ın yapısal olduğunu ve her LLM'de bir dereceye kadar bulunduğunu açıkça belirtir, nadir bir hata değildir, yalnızca adversarial durumlarda olmaz ve kasıtlı bir aldatma değildir (modelin niyeti yoktur).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'llm-capabilities-and-limitations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bu, yalnızca az sayıda kötü inşa edilmiş modeli etkileyen, nadir görülen bir yazılım hatasıdır$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Yalnızca bir kullanıcı modeli kasıtlı olarak adversarial prompt'larla kandırmaya çalıştığında olur$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Model kullanıcıya kasıtlı olarak yalan söylediği için olur$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Pretraining, doğrulanmış değil, olası (plausible) bir sonraki token'ı tahmin etmeyi optimize eder -- üretilen metni gerçek bilgiyle karşılaştıran yerleşik bir mekanizma yoktur$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$An LLM with a knowledge cutoff of March 2024 is asked about an event that happened in June 2024. What is the most accurate description of what can happen?$$,
           NULL, NULL,
           $$This matches the lesson exactly: knowledge cutoff and hallucination often show up together, and a model has no guaranteed reliable self-awareness of its own knowledge gap; the lesson doesn't describe a built-in real-time internet search or a self-updating cutoff.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'llm-capabilities-and-limitations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The model automatically searches the internet in real time to find the answer$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$The model's knowledge cutoff updates itself automatically the moment the event happens$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$The model may either say it doesn't know, or -- worse -- hallucinate a plausible-sounding but fabricated answer, since it has no reliable built-in way to recognize the gap$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$The model will always correctly say it has no information about the event$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Knowledge cutoff'u Mart 2024 olan bir LLM'e, Haziran 2024'te gerçekleşen bir olay hakkında soru soruluyor. Ne olabileceğinin en doğru tanımı nedir?$$,
           NULL, NULL,
           $$Bu derse birebir uyar: knowledge cutoff ve hallucination genellikle birlikte ortaya çıkar, ve bir modelin kendi bilgi boşluğuna dair güvenilir bir öz-farkındalığı garanti edilmez; ders, yerleşik bir gerçek zamanlı internet araması ya da kendini güncelleyen bir cutoff tarif etmez.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'llm-capabilities-and-limitations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Model ya bilmediğini söyleyebilir ya da -- daha kötüsü -- kendi bilgi boşluğunu güvenilir şekilde tanıyacak yerleşik bir yolu olmadığı için, olası görünen ama uydurma bir cevabı hallucinate edebilir$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Model her zaman doğru şekilde bu olay hakkında bilgisi olmadığını söyleyecektir$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Model, cevabı bulmak için gerçek zamanlı olarak otomatik olarak interneti arar$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Modelin knowledge cutoff'u, olay gerçekleştiği anda kendini otomatik olarak günceller$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$An LLM produces a confident, coherent-sounding step-by-step explanation for a multi-step logic puzzle, but the final answer is wrong. What does this lesson say about why this can happen?$$,
           NULL, NULL,
           $$This matches the lesson: reasoning-like output is generated text based on learned patterns, not a formally verified process like a calculator or compiler, so errors can occur even with confident, coherent explanations; the lesson explicitly says chain-of-thought techniques measurably help despite this (so they aren't useless), and no step-count threshold is mentioned.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'llm-capabilities-and-limitations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$This can never actually happen -- chain-of-thought reasoning is formally verified and guaranteed correct$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$It only happens when the puzzle involves more than 100 steps$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$It means chain-of-thought prompting is useless and should never be used$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$The model generates text that resembles step-by-step reasoning, one token at a time, based on learned patterns -- not a formally verified logical process like a calculator or compiler runs$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir LLM, çok adımlı bir mantık bulmacası için kendinden emin, tutarlı görünen adım adım bir açıklama üretiyor, ama nihai cevap yanlış. Bu ders, bunun neden olabileceği konusunda ne söylüyor?$$,
           NULL, NULL,
           $$Bu derse uyar: akıl yürütmeye benzeyen çıktı, öğrenilmiş kalıplara dayanan üretilmiş metindir, bir hesap makinesi ya da derleyicinin çalıştırdığı gibi resmi olarak doğrulanmış bir süreç değildir, bu yüzden kendinden emin, tutarlı açıklamalarla bile hatalar oluşabilir; ders, chain-of-thought tekniklerinin buna rağmen ölçülebilir şekilde yardımcı olduğunu açıkça belirtir (yani işe yaramaz değildir) ve herhangi bir adım-sayısı eşiğinden bahsetmez.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'llm-capabilities-and-limitations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bu, chain-of-thought prompting'in işe yaramaz olduğu ve asla kullanılmaması gerektiği anlamına gelir$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Model, öğrenilmiş kalıplara dayanarak, tek seferde bir token olacak şekilde adım adım akıl yürütmeye benzeyen metin üretir -- bir hesap makinesi veya derleyicinin çalıştırdığı gibi resmi olarak doğrulanmış bir mantıksal süreç değildir$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Bu aslında hiç gerçekleşemez -- chain-of-thought akıl yürütme resmi olarak doğrulanmıştır ve doğruluğu garantilidir$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Bu yalnızca bulmaca 100'den fazla adım içerdiğinde olur$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why can an LLM reproduce biases or stereotypes in its output, even without anyone intending it to?$$,
           NULL, NULL,
           $$This matches the lesson directly: bias is a consequence of learning statistical patterns from an enormous sample of real human-written text, which itself reflects real biases; it isn't deliberate intent, isn't limited to small-dataset models (larger models still reflect their training data), and isn't a separate architectural bug.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'llm-capabilities-and-limitations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The model learns statistical patterns from an enormous sample of real human-written text, which itself reflects real biases and imbalances present in its sources$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$The model deliberately chooses to be biased to seem more humanlike$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Bias only appears in LLMs that were trained on a single, small dataset, never in large-scale models$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Bias is unrelated to training data and comes from a separate, unrelated bug in the model architecture$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Kimse bunu amaçlamamış olsa bile, bir LLM çıktısında neden önyargıları veya stereotipleri yeniden üretebilir?$$,
           NULL, NULL,
           $$Bu derse doğrudan uyar: önyargı, kendisi de kaynaklarındaki gerçek önyargıları yansıtan, devasa bir gerçek insan yazımı metin örnekleminden istatistiksel örüntüler öğrenmenin bir sonucudur; bu bilinçli bir niyet değildir, yalnızca küçük veri kümeleriyle sınırlı değildir (büyük modeller de eğitim verisini yansıtmaya devam eder) ve ayrı bir mimari hata değildir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'llm-capabilities-and-limitations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Önyargı yalnızca tek, küçük bir veri kümesiyle eğitilmiş LLM'lerde görülür, büyük ölçekli modellerde asla görülmez$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Önyargı, eğitim verisiyle ilgisizdir ve model mimarisindeki ayrı, ilgisiz bir hatadan kaynaklanır$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Model, kendisi de kaynaklarındaki gerçek önyargıları ve dengesizlikleri yansıtan, devasa bir gerçek insan yazımı metin örnekleminden istatistiksel örüntüler öğrenir$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Model, daha insansı görünmek için bilerek önyargılı olmayı seçer$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$This lesson connects hallucination, knowledge cutoff, reasoning errors, and bias to one shared root cause rather than treating them as separate, unrelated bugs. What is that shared root cause?$$,
           NULL, NULL,
           $$This matches the lesson's explicit "Why These Limitations Exist" reframing; the lesson separately warns that scale doesn't fix every limitation, prompt quality alone doesn't explain structural issues like hallucination, and none of these limitations are described as fully solved.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'llm-capabilities-and-limitations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$All four only occur in older models and have been fully solved in every modern LLM$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$An LLM predicts plausible text based on statistical patterns learned during pretraining, with no built-in fact-checker, formal logic engine, live data connection, or bias-correction process$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$All four are caused by insufficient model size, and would disappear if the model were simply made larger$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$All four are caused by users writing poorly-structured prompts$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu ders, hallucination, knowledge cutoff, akıl yürütme hataları ve önyargıyı, bunları ayrı ve ilgisiz hatalar olarak ele almak yerine ortak tek bir kök nedene bağlıyor. Bu ortak kök neden nedir?$$,
           NULL, NULL,
           $$Bu, dersin açık 'Bu Kısıtlamalar Neden Var' yeniden çerçevelemesine uyar; ders ayrıca ölçeğin her kısıtlamayı düzeltmediğini, tek başına prompt kalitesinin hallucination gibi yapısal sorunları açıklamadığını belirtir ve bu kısıtlamaların hiçbiri tamamen çözülmüş olarak tarif edilmez.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'llm-capabilities-and-limitations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Dördü de yetersiz model boyutundan kaynaklanır ve model basitçe büyütülürse ortadan kalkar$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Dördü de kullanıcıların kötü yapılandırılmış prompt'lar yazmasından kaynaklanır$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Dördü de yalnızca eski modellerde görülür ve her modern LLM'de tamamen çözülmüştür$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir LLM, pretraining sırasında öğrenilen istatistiksel örüntülere dayanarak olası (plausible) metni tahmin eder; yerleşik bir gerçek-kontrolcüsü, resmi mantık motoru, canlı veri bağlantısı veya önyargı düzeltme süreci yoktur$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about LLM limitations and verifying their output, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (never trust fluent output automatically; later categories work around limitations rather than fully fixing the model); the lesson explicitly warns that a model is MORE likely to produce a plausible guess than to reliably flag its own gap, so unverified trust is not safe, and it explicitly reframes these limitations as sharing one common root cause, not unrelated separate bugs.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'llm-capabilities-and-limitations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A model is very likely to reliably say "I don't know" whenever it lacks information, so unverified answers are generally safe to trust$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Hallucination, reasoning errors, and bias are three completely unrelated failure modes that must each be understood and fixed separately$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$A fluent, confident-sounding answer should never be treated as automatically correct -- specific facts, dates, citations, and numbers should be verified$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Later categories in this course, like Tools & MCP and AI Agents, are designed to work around these limitations by supplying current information and verifying outputs, rather than trying to fully "fix" the underlying model$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, LLM kısıtlamaları ve çıktılarının doğrulanmasıyla ilgili aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (akıcı çıktıya asla otomatik olarak güvenilmemesi; sonraki kategorilerin modeli tamamen 'düzeltmek' yerine kısıtlamaların etrafından dolaşacak şekilde tasarlanması); ders, bir modelin kendi bilgi boşluğunu güvenilir şekilde bildirmekten çok olası bir tahmin üretmeye daha yatkın olduğunu açıkça belirtir, bu yüzden doğrulanmamış güven güvenli değildir, ve bu kısıtlamaları ilgisiz ayrı hatalar değil, ortak tek bir kök nedeni paylaşan şeyler olarak yeniden çerçeveler.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'llm-capabilities-and-limitations'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Akıcı, kendinden emin görünen bir cevap asla otomatik olarak doğru kabul edilmemelidir -- spesifik gerçekler, tarihler, alıntılar ve sayılar doğrulanmalıdır$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Bu kursun Tools & MCP ve AI Agents gibi sonraki kategorileri, altta yatan modeli tamamen 'düzeltmeye' çalışmak yerine, güncel bilgi sağlayıp çıktıları doğrulayarak bu kısıtlamaların etrafından dolaşacak şekilde tasarlanmıştır$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir model, bilgisi olmadığında güvenilir şekilde 'bilmiyorum' deme olasılığı çok yüksektir, bu yüzden doğrulanmamış cevaplara genellikle güvenilebilir$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Hallucination, akıl yürütme hataları ve önyargı, her biri ayrı ayrı anlaşılıp düzeltilmesi gereken tamamen ilgisiz üç başarısızlık modudur$$, FALSE, 3 FROM new_question_tr7;
