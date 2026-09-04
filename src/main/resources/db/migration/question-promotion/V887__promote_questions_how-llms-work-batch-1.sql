-- Promotion batch
-- Topic: how-llms-work (language: en x7, tr x7)
-- Generated: 2026-09-04 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project (React/Java/
-- Spring/Postgres/Git categories), these 14 questions were hand-authored
-- and independently self-reviewed directly inside a Claude Code session,
-- grounded strictly in content/en/how-llms-work.md and content/tr/how-llms-work.md --
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
           $$What is a Large Language Model (LLM), mechanically?$$,
           NULL, NULL,
           $$This matches the lesson's definition directly: a transformer-based neural network trained at massive scale to predict the next token; the other options describe unrelated, non-learning-based systems (hand-written rules, lookup databases, search engines).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'how-llms-work'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A transformer-based neural network trained at massive scale to predict the next token given preceding text$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$A rule-based system with thousands of hand-written if/else statements for language$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$A database that looks up pre-written answers to common questions$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$A search engine that retrieves and ranks existing web pages$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir Large Language Model (LLM), mekanik olarak nedir?$$,
           NULL, NULL,
           $$Bu, dersin tanımıyla birebir örtüşür: önceki metin göz önüne alındığında bir sonraki token'ı tahmin etmek için devasa ölçekte eğitilmiş, transformer tabanlı bir sinir ağı; diğer seçenekler ilgisiz, öğrenmeye dayanmayan sistemleri tarif eder (elle yazılmış kurallar, arama veritabanı, arama motoru).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'how-llms-work'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yaygın sorulara önceden yazılmış cevapları arayan bir veritabanı$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Var olan web sayfalarını getirip sıralayan bir arama motoru$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Önceki metin göz önüne alındığında bir sonraki token'ı tahmin etmek için devasa ölçekte eğitilmiş, transformer tabanlı bir sinir ağı$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Dil için binlerce elle yazılmış if/else ifadesine sahip, kurala dayalı bir sistem$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Before LLMs, why did NLP systems typically require a separate model for each task (translation, sentiment analysis, summarization)?$$,
           NULL, NULL,
           $$This matches the lesson: under the narrow-AI approach, each task needed its own labeled dataset and training run; LLMs changed this via one pretrained general model that can handle many tasks -- the other options are false or fabricated.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'how-llms-work'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Because a single general model has always been technically impossible to build$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Because each task needed its own labeled dataset and training run under the narrow-AI approach$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Because computers were physically incapable of running more than one model type$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Because language itself changes completely between tasks$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$LLM'lerden önce, NLP sistemleri neden genellikle her görev (çeviri, duygu analizi, özetleme) için ayrı bir model gerektiriyordu?$$,
           NULL, NULL,
           $$Bu derse uyar: dar (narrow) yapay zeka yaklaşımında her görevin kendi etiketlenmiş veri kümesine ve eğitim sürecine ihtiyacı vardı; LLM'ler bunu birçok görevi ele alabilen tek bir önceden eğitilmiş genel modelle değiştirdi -- diğer seçenekler yanlış ya da uydurmadır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'how-llms-work'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çünkü bilgisayarlar fiziksel olarak birden fazla model türü çalıştıramıyordu$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Çünkü dilin kendisi görevler arasında tamamen değişir$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Çünkü tek bir genel model inşa etmek teknik olarak her zaman imkansız olmuştur$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Çünkü dar (narrow) yapay zeka yaklaşımında her görevin kendi etiketlenmiş veri kümesine ve eğitim sürecine ihtiyacı vardı$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$During pretraining, a model is shown a huge amount of text and, for each piece, asked to predict the next token; when wrong, its weights are adjusted. What does this process teach the model, according to the lesson?$$,
           NULL, NULL,
           $$The lesson explicitly lists grammar, facts (up to the knowledge cutoff), reasoning patterns, and even programming languages as side effects of getting better at next-token prediction; conversational ability specifically comes from a later phase (instruction tuning), not pretraining, so it isn't "only spelling/punctuation" and isn't "nothing useful."$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'how-llms-work'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Only how to have a back-and-forth conversation, since that's the explicit training goal$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Nothing useful, since pretraining is described as an unrelated preliminary step$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Grammar, facts about the world (up to its knowledge cutoff), common reasoning patterns, and even programming languages -- all as a side effect of getting better at next-token prediction$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Only spelling and punctuation rules, nothing else$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Pretraining sırasında bir modele devasa miktarda metin gösterilir ve her bir parça için bir sonraki token'ı tahmin etmesi istenir; yanlış tahmin edince ağırlıkları ayarlanır. Bu derse göre bu süreç modele neyi öğretir?$$,
           NULL, NULL,
           $$Ders, dilbilgisini, gerçekleri (knowledge cutoff'una kadar), akıl yürütme kalıplarını ve hatta programlama dillerini, bir sonraki token'ı tahmin etmede daha iyi olmanın yan etkisi olarak açıkça listeler; sohbet yeteneği ise özellikle sonraki bir aşamadan (instruction tuning) gelir, pretraining'den değil -- bu yüzden yalnızca 'yazım/noktalama' ya da 'hiçbir yararlı şey' değildir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'how-llms-work'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Dilbilgisini, dünya hakkındaki gerçekleri (knowledge cutoff'una kadar), yaygın akıl yürütme kalıplarını ve hatta programlama dillerini -- hepsi bir sonraki token'ı tahmin etmede daha iyi olmanın yan etkisi olarak$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Yalnızca yazım ve noktalama kurallarını, başka hiçbir şeyi$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Yalnızca karşılıklı bir sohbet yürütmeyi, çünkü bu açık eğitim hedefidir$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Hiçbir yararlı şeyi, çünkü pretraining ilgisiz bir hazırlık adımı olarak tanımlanır$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given the instruction "Summarize this email," a raw base model (no further training after pretraining) might continue with a list of other unrelated instructions instead of actually summarizing. Why does this happen, and what typically fixes it?$$,
           NULL, NULL,
           $$This matches the lesson's base-model vs. instruction-tuned distinction directly: a base model only continues text plausibly, and instruction tuning (an additional training phase) teaches reliable instruction-following; it isn't a "broken model" needing retraining from scratch, instruction-following isn't universal by default, and context window size is unrelated.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'how-llms-work'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The model is broken and needs to be retrained from scratch on different data$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$This never actually happens to base models -- all models follow instructions equally well by default$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$The fix is to give the model a bigger context window$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$A base model only continues text plausibly; instruction tuning (an additional training phase) is what teaches a model to reliably follow instructions instead$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$'Bu e-postayı özetle' talimatı verildiğinde, ham bir temel (base) model (pretraining sonrası başka bir eğitim almamış) gerçekten özetlemek yerine başka ilgisiz talimatlardan oluşan bir liste ile devam edebilir. Bu neden olur ve genellikle bunu ne düzeltir?$$,
           NULL, NULL,
           $$Bu, dersin base model ile instruction-tuned model ayrımına doğrudan uyar: bir base model yalnızca metni akıcı biçimde sürdürür, instruction tuning (ek bir eğitim aşaması) ise bunun yerine talimatları güvenilir şekilde takip etmeyi öğretir; bu 'bozuk bir model' değildir, talimat takibi varsayılan olarak evrensel değildir ve context window boyutuyla ilgisi yoktur.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'how-llms-work'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çözüm, modele daha büyük bir context window vermektir$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Bir base model yalnızca metni akıcı biçimde sürdürür; instruction tuning (ek bir eğitim aşaması), bir modele bunun yerine talimatları güvenilir şekilde takip etmeyi öğretir$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Model bozuktur ve farklı bir veriyle sıfırdan yeniden eğitilmesi gerekir$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Bu aslında base modellerin başına hiç gelmez -- tüm modeller varsayılan olarak talimatları eşit derecede iyi takip eder$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A user teaches an LLM a made-up word within a conversation, and the model correctly uses that word later in the same conversation -- without any retraining happening. What explains this behavior?$$,
           NULL, NULL,
           $$The lesson explicitly defines in-context learning as adapting behavior within a conversation with zero weight changes, via re-feeding the full conversation as input on every response; the other options describe mechanisms the lesson explicitly rules out (permanent weight updates, silent retraining, a persistent memory database).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'how-llms-work'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$In-context learning: the model's weights don't change at all; instead, the entire conversation so far is re-fed as input on every response, and the frozen pretrained model recognizes the pattern$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$The model's weights are permanently updated in real time during the conversation$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$The company running the model silently retrains it after every message$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$The model has a separate, persistent memory database it writes to during conversations$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir kullanıcı bir konuşma içinde bir LLM'e uydurma bir kelime öğretiyor ve model, hiçbir yeniden eğitim gerçekleşmeden, aynı konuşmanın ilerleyen kısmında bu kelimeyi doğru şekilde kullanıyor. Bu davranışı ne açıklar?$$,
           NULL, NULL,
           $$Ders, in-context learning'i, sıfır ağırlık değişikliğiyle bir konuşma içinde davranışı uyarlamak olarak açıkça tanımlar; bu, o ana kadarki tüm konuşmanın her yanıtta girdi olarak yeniden beslenmesiyle olur -- diğer seçenekler dersin açıkça dışladığı mekanizmaları tarif eder (kalıcı ağırlık güncellemeleri, sessiz yeniden eğitim, kalıcı bir bellek veritabanı).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'how-llms-work'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Modeli çalıştıran şirket, her mesajdan sonra onu sessizce yeniden eğitir$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Modelin, konuşmalar sırasında yazdığı ayrı, kalıcı bir bellek veritabanı vardır$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$In-context learning: modelin ağırlıkları hiç değişmez; bunun yerine, o ana kadarki tüm konuşma her yanıtta girdi olarak yeniden beslenir ve dondurulmuş, önceden eğitilmiş model örüntüyü tanır$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Modelin ağırlıkları konuşma sırasında gerçek zamanlı olarak kalıcı şekilde güncellenir$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$According to this lesson, what is "context," and why does it matter?$$,
           NULL, NULL,
           $$The lesson defines context broadly (instructions, background info, conversation history, and generated-so-far text) and states it is the ONLY channel shaping inference-time behavior, since no learning happens during inference; the other options narrow or misplace this definition.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'how-llms-work'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Context only matters for image-generation models, not text-based LLMs$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Context is all the text the model actually sees before producing its next token, and it's the only channel through which an LLM's behavior can be shaped at inference time$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Context is just the system prompt alone, nothing else the model sees$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Context is a separate database the model queries during pretraining only$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, 'context' (bağlam) nedir ve neden önemlidir?$$,
           NULL, NULL,
           $$Ders, context'i geniş şekilde tanımlar (talimatlar, arka plan bilgisi, konuşma geçmişi ve o ana kadar üretilmiş metin) ve inference sırasında hiçbir öğrenme gerçekleşmediği için, inference zamanında bir LLM'nin davranışının şekillendirilebileceği TEK kanal olduğunu belirtir -- diğer seçenekler bu tanımı daraltır ya da yanlış yerleştirir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'how-llms-work'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Context yalnızca system prompt'tur, modelin gördüğü başka hiçbir şey değildir$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Context, modelin yalnızca pretraining sırasında sorguladığı ayrı bir veritabanıdır$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Context yalnızca görüntü üretim modelleri için önemlidir, metin tabanlı LLM'ler için değil$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Context, modelin bir sonraki token'ı üretmeden önce gerçekten gördüğü tüm metindir ve inference zamanında bir LLM'nin davranışının şekillendirilebileceği tek kanaldır$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about how LLMs work, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (knowledge cutoff as a direct consequence of pretraining data collection timing; scaling laws describing predictable performance improvement with size/data/compute); instruction tuning is a training-time phase completed before deployment, not something happening live during conversations (that's in-context learning instead), and base vs. instruction-tuned models are explicitly described as behaving differently.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'how-llms-work'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Instruction tuning happens continuously, in real time, during every user conversation$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$A base model and an instruction-tuned model are always identical in behavior, since instruction tuning doesn't change anything observable$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$A model's knowledge cutoff is a direct consequence of when its pretraining data was collected, not an arbitrary restriction$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Scaling laws describe the observed pattern that performance tends to improve as model size, data, and compute all increase together$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, LLM'lerin nasıl çalıştığıyla ilgili aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (knowledge cutoff'un pretraining verisinin toplandığı zamanın doğrudan bir sonucu olması; scaling law'ların boyut/veri/compute birlikte arttıkça performansın öngörülebilir şekilde iyileşmesini tanımlaması); instruction tuning, devreye almadan önce tamamlanan bir eğitim-zamanı aşamasıdır, her konuşma sırasında canlı gerçekleşen bir şey değildir (bu, in-context learning'dir), ve base ile instruction-tuned modellerin farklı davrandığı açıkça belirtilir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'how-llms-work'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir modelin knowledge cutoff'u, keyfi bir kısıtlama değil, pretraining verisinin ne zaman toplandığının doğrudan bir sonucudur$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Scaling law'lar, model boyutu, veri ve compute birlikte arttıkça performansın genellikle iyileştiği gözlemlenen örüntüyü tanımlar$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Instruction tuning, her kullanıcı konuşması sırasında gerçek zamanlı ve sürekli olarak gerçekleşir$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir base model ile instruction-tuned bir model, instruction tuning gözle görülür hiçbir şeyi değiştirmediği için davranış açısından her zaman aynıdır$$, FALSE, 3 FROM new_question_tr7;
