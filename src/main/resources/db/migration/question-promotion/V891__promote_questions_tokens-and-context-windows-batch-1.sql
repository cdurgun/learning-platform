-- Promotion batch
-- Topic: tokens-and-context-windows (language: en x7, tr x7)
-- Generated: 2026-09-04 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project (React/Java/
-- Spring/Postgres/Git categories), these 14 questions were hand-authored
-- and independently self-reviewed directly inside a Claude Code session,
-- grounded strictly in content/en/tokens-and-context-windows.md and content/tr/tokens-and-context-windows.md --
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
           $$What is a "token" in the context of an LLM?$$,
           NULL, NULL,
           $$This matches the lesson's precise definition; tokens are not a payment-only concept, are not always exactly one character, and are not authentication credentials.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'tokens-and-context-windows'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The actual unit of text an LLM reads and generates -- often close to a word, but not always$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$A unit of payment charged only for image-generation requests$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$A single character, always exactly one character long, never more or less$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$A unique password required to start a new conversation$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir LLM bağlamında 'token' nedir?$$,
           NULL, NULL,
           $$Bu, dersin kesin tanımıyla örtüşür; token'lar yalnızca ödeme için var olan bir kavram değildir, her zaman tam olarak bir karakter uzunluğunda değildir ve kimlik doğrulama bilgisi değildir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'tokens-and-context-windows'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Her zaman tam olarak bir karakter uzunluğunda olan, ne daha fazla ne daha az, tek bir karakter$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Yeni bir konuşma başlatmak için gereken benzersiz bir şifre$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir LLM'nin okuduğu ve ürettiği gerçek metin birimi -- genellikle bir kelimeye yakın, ama her zaman değil$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Yalnızca görüntü üretim istekleri için alınan bir ödeme birimi$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Why do LLMs use sub-word tokens instead of a vocabulary made only of whole words?$$,
           NULL, NULL,
           $$This matches the lesson's explicit reasoning: a whole-word-only vocabulary would either be enormous or constantly fail on unseen words (typos, names, made-up words); sub-word tokens let a modest vocabulary represent any text -- the other options are unsupported or contradict the lesson.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'tokens-and-context-windows'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It's purely a historical accident with no practical reasoning behind it$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$A whole-word-only vocabulary would either be enormous or constantly fail on unseen words (typos, names, made-up words); sub-word tokens let a modest vocabulary represent any text$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Sub-word tokens make the model run more slowly on purpose, to improve accuracy$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Whole words cannot be represented as numbers, only sub-word pieces can$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$LLM'ler, yalnızca tam kelimelerden oluşan bir kelime dağarcığı yerine neden alt-kelime (sub-word) token'ları kullanır?$$,
           NULL, NULL,
           $$Bu, dersin açık gerekçesine uyar: yalnızca tam kelimelerden oluşan bir kelime dağarcığı ya devasa büyüklükte olurdu ya da görülmemiş kelimelerde (yazım hataları, isimler, uydurma kelimeler) sürekli başarısız olurdu; alt-kelime token'ları mütevazı bir kelime dağarcığının herhangi bir metni temsil etmesini sağlar -- diğer seçenekler desteksizdir ya da dersle çelişir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'tokens-and-context-windows'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Alt-kelime token'ları, doğruluğu artırmak amacıyla modelin bilerek daha yavaş çalışmasını sağlar$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Tam kelimeler sayı olarak temsil edilemez, yalnızca alt-kelime parçaları edilebilir$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Bu tamamen tarihsel bir tesadüftür, arkasında hiçbir pratik gerekçe yoktur$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Yalnızca tam kelimelerden oluşan bir kelime dağarcığı ya devasa büyüklükte olurdu ya da görülmemiş kelimelerde (yazım hataları, isimler, uydurma kelimeler) sürekli başarısız olurdu; alt-kelime token'ları mütevazı bir kelime dağarcığının herhangi bir metni temsil etmesini sağlar$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A model has a context window of 8,000 tokens. A user's conversation, including instructions and history, reaches 8,500 tokens. What must happen?$$,
           NULL, NULL,
           $$This matches the lesson: the context window is a hard ceiling, so something has to give -- older content gets dropped, summarized, or the request is rejected outright, depending on the system; it isn't a "soft suggestion," the model doesn't auto-expand its own window, and it doesn't silently drop the newest content instead of the oldest.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'tokens-and-context-windows'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The model automatically increases its own context window to fit the request$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$The model silently ignores the newest 500 tokens instead of the oldest$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Something has to give: older content gets dropped, summarized, or the request is rejected outright, since the limit is a hard ceiling$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Nothing -- context windows are a soft suggestion, not an actual limit$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir modelin context window'u 8.000 token. Talimatlar ve geçmiş dahil bir kullanıcının konuşması 8.500 token'a ulaşıyor. Ne olmak zorundadır?$$,
           NULL, NULL,
           $$Bu derse uyar: context window sert bir tavandır, bu yüzden bir şeylerden vazgeçilmelidir -- sisteme bağlı olarak eski içerik düşürülür, özetlenir ya da istek doğrudan reddedilir; bu 'yumuşak bir öneri' değildir, model kendi window'unu otomatik büyütmez ve en eski yerine en yeni içeriği sessizce yok saymaz.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'tokens-and-context-windows'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir şeylerden vazgeçilmelidir: sınır sert bir tavan olduğu için eski içerik düşürülür, özetlenir veya istek doğrudan reddedilir$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Hiçbir şey -- context window'lar gerçek bir sınır değil, yumuşak bir öneridir$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Model, isteğe sığmak için kendi context window'unu otomatik olarak büyütür$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Model, en eski token'lar yerine sessizce en yeni 500 token'ı yok sayar$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A user says something important early in a very long conversation. Later, once the conversation exceeds the context window and the earliest messages are dropped, the model no longer references that information. Why?$$,
           NULL, NULL,
           $$This matches the lesson exactly: the model has no memory of its own beyond current context, re-reading only what's currently present on every response; dropped content is functionally identical to never having been said -- this is normal, expected, structural behavior, not a rare bug or a deliberate choice.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'tokens-and-context-windows'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The model has a deeper memory of the conversation but chooses not to use it$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$The model deliberately ignores information it disagrees with$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$This only happens due to a rare bug, not normal expected behavior$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Once content falls out of the context window, the model has no access to it at all -- it re-reads only what's currently in context on every response, with no memory beyond that$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir kullanıcı çok uzun bir konuşmanın başında önemli bir şey söylüyor. Daha sonra, konuşma context window'u aştığında ve en eski mesajlar düşürüldüğünde, model artık o bilgiye atıfta bulunmuyor. Neden?$$,
           NULL, NULL,
           $$Bu derse birebir uyar: modelin kendi başına, o anki context'in ötesinde bir belleği yoktur, her yanıtta yalnızca o an mevcut olanı yeniden okur; düşürülen içerik, hiç söylenmemiş olmakla işlevsel olarak aynıdır -- bu normal, beklenen, yapısal bir davranıştır, nadir bir hata ya da bilinçli bir seçim değildir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'tokens-and-context-windows'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bu yalnızca nadir bir hata yüzünden olur, normal beklenen bir davranış değildir$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$İçerik context window'dan düştüğünde, model ona hiç erişemez -- her yanıtta yalnızca o an context'te olanı yeniden okur, bunun ötesinde bir belleği yoktur$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Modelin konuşma hakkında daha derin bir belleği vardır ama onu kullanmamayı tercih eder$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Model, katılmadığı bilgileri bilerek yok sayar$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why does including a long, mostly irrelevant document in an LLM's context, "just in case," have a real downside even if the context window is large enough to fit it?$$,
           NULL, NULL,
           $$This matches the lesson: tokens are billed for input and output, and every response re-reads the full context, so cost and latency scale with context size regardless of window headroom -- the other options falsely claim there's no cost.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'tokens-and-context-windows'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Every included token adds real cost (billing) and latency, since the model re-reads the entire context on every response, regardless of whether the window has room$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$There is no downside as long as it fits within the context window$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Extra tokens are free as long as the response itself is short$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Large context windows eliminate any cost associated with token count$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Context window yeterince büyük olsa bile, 'ne olur ne olmaz' diye uzun, çoğunlukla ilgisiz bir belgeyi bir LLM'in context'ine eklemenin neden gerçek bir dezavantajı vardır?$$,
           NULL, NULL,
           $$Bu derse uyar: token'lar hem girdi hem çıktı için faturalandırılır ve model her yanıtta tüm context'i yeniden okur, bu yüzden window'da yer olup olmadığından bağımsız olarak maliyet ve gecikme context boyutuyla ölçeklenir -- diğer seçenekler hiçbir maliyet olmadığını yanlış şekilde iddia eder.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'tokens-and-context-windows'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yanıtın kendisi kısa olduğu sürece ekstra token'lar ücretsizdir$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Büyük context window'lar, token sayısıyla ilişkili her türlü maliyeti ortadan kaldırır$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Model her yanıtta tüm context'i yeniden okuduğu için, eklenen her token, window'da yer olup olmadığından bağımsız olarak gerçek bir maliyete (faturalandırma) ve gecikmeye yol açar$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Context window'a sığdığı sürece hiçbir dezavantajı yoktur$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A system needs to let a user reference something said much earlier in a long conversation, but can't afford to keep the entire raw history in context forever. Which strategy fetches only the specific, relevant pieces of information needed for the current request, rather than keeping everything or compressing everything?$$,
           NULL, NULL,
           $$Retrieval fetches only relevant pieces on demand, matching the lesson; truncation simply drops the oldest content, summarization compresses everything into a shorter gist (losing exact wording), and tokenization is an unrelated text-splitting process, not a context-management strategy.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'tokens-and-context-windows'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Tokenization$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Retrieval$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Truncation$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Summarization$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir sistemin, kullanıcının çok uzun bir konuşmanın çok öncesinde söylenen bir şeye atıfta bulunmasına izin vermesi gerekiyor, ama tüm ham geçmişi sonsuza kadar context'te tutmayı göze alamıyor. Her şeyi tutmak veya her şeyi sıkıştırmak yerine, mevcut istek için gereken yalnızca belirli, ilgili bilgi parçalarını getiren strateji hangisidir?$$,
           NULL, NULL,
           $$Retrieval, yalnızca ilgili parçaları talep üzerine getirir ve derse uyar; truncation yalnızca en eski içeriği düşürür, summarization her şeyi daha kısa bir özete sıkıştırır (tam ifadeyi kaybederek) ve tokenization, bir context yönetim stratejisi değil, ilgisiz bir metin bölme sürecidir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'tokens-and-context-windows'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Truncation$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Summarization$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Tokenization$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Retrieval$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about tokens and context windows, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and C are directly stated in the lesson (tokenization varying by language; token count differing from word count); a larger window still costs tokens for irrelevant content, so cost/latency don't disappear, and the three context-management strategies have explicitly different trade-offs, not identical ones.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'tokens-and-context-windows'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A larger context window removes the need to think about what information is actually included, since irrelevant content no longer has any cost$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Truncation, summarization, and retrieval are interchangeable strategies with identical trade-offs in every situation$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Tokenization can vary meaningfully by language, so the same sentence can cost noticeably different numbers of tokens in different languages$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Token count is not the same as word count -- estimating context usage by word count alone can be misleading$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, token'lar ve context window'lar hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve C derste doğrudan belirtilir (tokenization'ın dile göre değişmesi; token sayısının kelime sayısından farklı olması); daha büyük bir window bile ilgisiz içerik için token maliyeti taşımaya devam eder, bu yüzden maliyet/gecikme ortadan kalkmaz, ve üç context yönetim stratejisinin açıkça farklı ödünleşimleri vardır, aynı değil.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'tokens-and-context-windows'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Tokenization dile göre anlamlı şekilde değişebilir, bu yüzden aynı cümle farklı dillerde belirgin şekilde farklı sayıda token'a mal olabilir$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Token sayısı, kelime sayısıyla aynı değildir -- context kullanımını yalnızca kelime sayısına göre tahmin etmek yanıltıcı olabilir$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Daha büyük bir context window, ilgisiz içeriğin artık hiçbir maliyeti olmadığı için, hangi bilginin gerçekten dahil edildiğini düşünme ihtiyacını ortadan kaldırır$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Truncation, summarization ve retrieval, her durumda birbirinin yerine geçebilen, aynı ödünleşimlere sahip stratejilerdir$$, FALSE, 3 FROM new_question_tr7;
