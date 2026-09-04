-- Promotion batch
-- Topic: generative-ai (language: en x7, tr x7)
-- Generated: 2026-09-04 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project (React/Java/
-- Spring/Postgres/Git categories), these 14 questions were hand-authored
-- and independently self-reviewed directly inside a Claude Code session,
-- grounded strictly in content/en/generative-ai.md and content/tr/generative-ai.md --
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
           $$Is Generative AI a separate technique from deep learning, or an application of it?$$,
           NULL, NULL,
           $$The lesson explicitly states Generative AI is an application of existing techniques (like deep learning), specifically trained to create new content -- not a separate technique; it builds on deep learning/neural networks, isn't defined purely by unsupervised learning, and isn't older than machine learning.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generative-ai'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$An application of existing techniques (like deep learning), specifically trained to create new content$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$A completely separate technique with its own unrelated architecture$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$A subset of unsupervised learning that has nothing to do with neural networks$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$An older technique that predates machine learning entirely$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Generative AI, deep learning'den ayrı bir teknik midir yoksa onun bir uygulaması mıdır?$$,
           NULL, NULL,
           $$Ders, Generative AI'ın (deep learning gibi) var olan tekniklerin bir uygulaması olduğunu, ayrı bir teknik olmadığını açıkça belirtir -- yeni içerik üretmek için özellikle eğitilmiştir; deep learning/sinir ağları üzerine inşa edilir, salt unsupervised learning ile tanımlanmaz ve machine learning'den daha eski değildir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generative-ai'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Sinir ağlarıyla hiçbir ilgisi olmayan, unsupervised learning'in bir alt kümesidir$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Machine learning'den bile önce var olan, daha eski bir tekniktir$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Var olan tekniklerin (deep learning gibi) bir uygulamasıdır, özellikle yeni içerik üretmek için eğitilmiştir$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Kendi ilgisiz mimarisine sahip, tamamen ayrı bir tekniktir$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Model A takes an email and outputs a label: "spam" or "not spam." Model B takes a topic and outputs a brand-new paragraph of text about it. Which is generative, and why?$$,
           NULL, NULL,
           $$Generative models create new content (Model B); discriminative models classify/predict a category for existing input (Model A) -- merely "producing output" doesn't make something generative, and classification and text generation are explicitly distinct tasks.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generative-ai'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Neither, since classification and text generation are the same task$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Model B, because it creates new content rather than classifying/predicting a category for existing input$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Model A, because it makes a decision$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Both, since both models process input and produce output$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Model A bir e-postayı alıp 'spam' veya 'spam değil' etiketini çıktı olarak veriyor. Model B ise bir konuyu alıp o konu hakkında yepyeni bir paragraf metin üretiyor. Hangisi generative'dir ve neden?$$,
           NULL, NULL,
           $$Generative modeller yeni içerik yaratır (Model B); discriminative modeller ise var olan bir girdi için kategori sınıflandırır/tahmin eder (Model A) -- yalnızca 'çıktı üretmek' bir şeyi generative yapmaz, ve sınıflandırma ile metin üretimi açıkça farklı görevlerdir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generative-ai'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Model A, çünkü bir karar veriyor$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$İkisi de, çünkü ikisi de girdi işleyip çıktı üretiyor$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Hiçbiri, çünkü sınıflandırma ve metin üretimi aynı görevdir$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Model B, çünkü var olan girdiyi sınıflandırmak/kategori tahmin etmek yerine yeni içerik yaratıyor$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$At a mechanical level, how does a generative text model produce a multi-sentence response?$$,
           NULL, NULL,
           $$Text generation works by repeatedly predicting the single most plausible next token given everything generated so far, one token at a time -- it is not lookup/retrieval from a database, not simultaneous whole-response generation, and not a fixed summarize-then-expand procedure.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generative-ai'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It generates the entire response simultaneously in one indivisible step, with no notion of order$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$It generates a summary first, then expands it into a paragraph, always in that fixed order$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$It repeatedly predicts the single most plausible next token given everything generated so far, one token at a time$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$It retrieves a pre-written matching response from a large lookup database$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Mekanik düzeyde, bir generative metin modeli çok cümlelik bir yanıtı nasıl üretir?$$,
           NULL, NULL,
           $$Metin üretimi, o ana kadar üretilenlere dayanarak, tek seferde bir token olacak şekilde, tekrar tekrar en olası bir sonraki token'ı tahmin ederek çalışır -- bir veritabanından arama/getirme değildir, tüm yanıtı aynı anda üretme değildir ve sabit özetle-sonra-genişlet prosedürü değildir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generative-ai'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$O ana kadar üretilenlere dayanarak, tek seferde bir token olacak şekilde, tekrar tekrar en olası bir sonraki token'ı tahmin eder$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Büyük bir arama veritabanından önceden yazılmış, eşleşen bir yanıtı getirir$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Tüm yanıtı, sıra kavramı olmadan tek, bölünemez bir adımda aynı anda üretir$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Önce bir özet üretir, sonra bunu her zaman bu sabit sırayla bir paragrafa genişletir$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$How do diffusion models, a common approach for image generation, typically work?$$,
           NULL, NULL,
           $$Diffusion models start from random noise and progressively refine it, step by step, into a coherent image -- they don't copy existing training images, don't use a fixed left-to-right pixel scan, and don't require a human sketch first.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generative-ai'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$They copy an existing image from training data and apply a filter to it$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$They generate images by predicting the next pixel in a fixed left-to-right scan order, one pixel at a time forever$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$They require a human to manually sketch the outline first$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$They start from random noise and progressively refine it, step by step, into a coherent image$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Görüntü üretimi için yaygın bir yaklaşım olan diffusion modelleri genellikle nasıl çalışır?$$,
           NULL, NULL,
           $$Diffusion modelleri rastgele gürültüden başlar ve bunu adım adım tutarlı bir görüntüye dönüştürecek şekilde kademeli olarak iyileştirir -- var olan eğitim görüntülerini kopyalamazlar, sabit soldan-sağa piksel taraması kullanmazlar ve önce bir insan taslağı gerektirmezler.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generative-ai'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Önce bir insanın elle taslak çizmesini gerektirirler$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Rastgele gürültüden başlayıp bunu adım adım tutarlı bir görüntüye dönüştürecek şekilde kademeli olarak iyileştirirler$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Eğitim verisinden var olan bir görüntüyü kopyalayıp üzerine bir filtre uygularlar$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Görüntüleri, sonsuza kadar tek seferde bir piksel olacak şekilde, sabit soldan-sağa bir tarama sırasıyla bir sonraki pikseli tahmin ederek üretirler$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A traditional AI system predicts whether a loan applicant will default (yes/no). A generative AI system, given the same applicant's data, writes a full paragraph explaining the credit decision. What is the key difference between what each system is trained to do?$$,
           NULL, NULL,
           $$The core distinction is discriminative/predictive training (classify a fixed outcome from existing patterns) versus generative/creative training (create new, original content); accuracy comparisons and "which uses neural networks" claims are unsupported generalizations the lesson does not make.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generative-ai'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The traditional system is trained to predict/classify a fixed outcome from existing patterns; the generative system is trained to create new, original content$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$There is no real difference -- both are just "AI" doing the same kind of job$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$The generative system is strictly more accurate at every task than the traditional system$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Traditional AI systems always use neural networks, while generative AI systems never do$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Geleneksel bir yapay zeka sistemi, bir kredi başvurusunda bulunanın temerrüde düşüp düşmeyeceğini (evet/hayır) tahmin ediyor. Aynı başvuru sahibinin verileri verildiğinde, bir generative AI sistemi ise kredi kararını açıklayan tam bir paragraf yazıyor. Her sistemin ne yapmak için eğitildiği arasındaki temel fark nedir?$$,
           NULL, NULL,
           $$Temel ayrım, discriminative/tahmin edici eğitim (var olan örüntülerden sabit bir sonucu sınıflandırmak) ile generative/yaratıcı eğitim (yeni, özgün içerik yaratmak) arasındadır; doğruluk karşılaştırmaları ve 'hangisi sinir ağı kullanır' iddiaları dersin yapmadığı desteksiz genellemelerdir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generative-ai'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Generative sistem her görevde geleneksel sistemden kesinlikle daha doğrudur$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Geleneksel yapay zeka sistemleri her zaman sinir ağı kullanır, generative yapay zeka sistemleri ise asla kullanmaz$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Geleneksel sistem, var olan örüntülerden sabit bir sonucu tahmin etmek/sınıflandırmak için eğitilir; generative sistem ise yeni, özgün içerik yaratmak için eğitilir$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Gerçek bir fark yoktur -- ikisi de aynı işi yapan 'yapay zeka'dır$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following is explicitly true about Generative AI, according to this lesson's "What Generative AI Is Not" section?$$,
           NULL, NULL,
           $$The lesson explicitly separates "generative" from "agentic" and from "AGI," and states fluent output is not automatically correct (this is where hallucination is introduced) -- the other options directly contradict what the lesson states.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generative-ai'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Generative AI systems are incapable of producing incorrect information$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Generative AI is not automatically agentic -- being able to generate content doesn't mean a system can independently take actions in the world$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Generative AI is a form of AGI, since it can produce humanlike text$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Fluent output from a generative model always guarantees factual correctness$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu dersin 'Generative AI Ne Değildir' bölümüne göre, aşağıdakilerden hangisi Generative AI hakkında açıkça doğrudur?$$,
           NULL, NULL,
           $$Ders, 'generative' olmayı açıkça 'agentic' olmaktan ve 'AGI'dan ayırır ve akıcı çıktının otomatik olarak doğru olmadığını belirtir (hallucination burada tanıtılır) -- diğer seçenekler dersin söylediğiyle doğrudan çelişir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generative-ai'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Generative AI, insansı metin üretebildiği için bir AGI türüdür$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir generative modelin akıcı çıktısı her zaman gerçek doğruluğu garanti eder$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Generative AI sistemleri yanlış bilgi üretmekten aciz sistemlerdir$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Generative AI otomatik olarak agentic değildir -- içerik üretebilmek, bir sistemin dünyada bağımsız olarak eylemler gerçekleştirebileceği anlamına gelmez$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about Generative AI, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (fluency vs. correctness as separate properties; the branching across text/image/audio/video/code); LLMs are only one branch (text) of generative AI, not the whole category, and discriminative and generative models have explicitly different training objectives (classify/predict vs. create).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generative-ai'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Every generative AI model is, by definition, also an LLM$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$A discriminative model and a generative model are trained toward the exact same objective$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Fluency and factual correctness are separate properties -- a fluent response is not automatically a correct one$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Generative AI branches across multiple content types, including text, image, audio, video, and code$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, Generative AI hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (akıcılık ve doğruluğun ayrı özellikler olması; metin/görüntü/ses/video/kod arasında dallanma); LLM'ler generative AI'ın yalnızca bir dalıdır (metin), tüm kategori değildir, ve discriminative ile generative modellerin açıkça farklı eğitim hedefleri vardır (sınıflandırma/tahmin vs. yaratma).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'generative-ai'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Akıcılık ve gerçek doğruluk ayrı özelliklerdir -- akıcı bir yanıt otomatik olarak doğru bir yanıt değildir$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Generative AI, metin, görüntü, ses, video ve kod dahil olmak üzere birden çok içerik türüne dallanır$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Her generative AI modeli, tanım gereği aynı zamanda bir LLM'dir$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Discriminative bir model ile generative bir model tam olarak aynı hedefe yönelik eğitilir$$, FALSE, 3 FROM new_question_tr7;
