-- Promotion batch
-- Topic: tools-and-function-calling (language: en x7, tr x7)
-- Generated: 2026-09-04 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these 14
-- questions were hand-authored and independently self-reviewed directly
-- inside a Claude Code session, grounded strictly in content/en/tools-and-function-calling.md
-- and content/tr/tools-and-function-calling.md -- NOT produced by n8n, NOT judged by any
-- external AI API, and NOT ingested via /api/internal/questions/ingest.
--
-- Strict 50/50 EN/TR split (7+7) organized as 7 CONCEPT PAIRS -- each EN
-- question has a TR counterpart testing the exact same concept, but
-- independently authored (different framing/options/examples), not a
-- translation. Every question whose answer depends on shown code is typed
-- CODE_OUTPUT (never SINGLE_CHOICE/MULTIPLE_CHOICE with a code_snippet
-- attached) -- fragments/quiz.html only renders code_snippet for
-- CODE_OUTPUT questions, per the bug found and fixed in
-- try-catch-finally/V573.
--
-- Each question's 4 options are written with the correct answer at a
-- deterministic, varied position, computed via
-- (pair_num + version + lang_shift) % 4 -- per the bug found and fixed at
-- question-promotion/V598 (always-A bias) and refined again in the Spring
-- Data JPA batch (parity-locked EN/TR offsets).
--
-- source = 'CLAUDE' / reviewed_by = 'claude-code@anthropic.com' / status =
-- 'PUBLISHED' directly. topic_id resolved by Topic.slug; question_option
-- rows reference the newly generated id via a WITH ... RETURNING id CTE.
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
           $$What is tool use (function calling), precisely?$$,
           NULL, NULL,
           $$Tool use is a pattern where the model generates a structured request naming a function and its arguments, and a program OUTSIDE the model executes it and returns the result; the model itself never runs code or touches a network/database directly.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'tools-and-function-calling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A pattern where the model generates a structured request to call a specific function, which an outside program actually executes and returns the result of$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$A pattern where the model directly connects to a database or network to fetch data itself$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$A feature that lets the model rewrite its own training weights based on a function's result$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$A vendor-specific chat feature unrelated to how the model produces its output$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Tool use (function calling) tam olarak nedir?$$,
           NULL, NULL,
           $$Tool use, modelin bir fonksiyon adı ve argümanları belirten yapılandırılmış bir istek üretmesi, ve modelin DIŞINDAKİ bir programın bunu gerçekten çalıştırıp sonucu döndürmesi kalıbıdır; modelin kendisi asla kod çalıştırmaz ya da doğrudan bir ağa/veritabanına dokunmaz.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'tools-and-function-calling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Modelin bir fonksiyonun sonucuna dayanarak kendi eğitim ağırlıklarını yeniden yazmasını sağlayan bir özellik$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Modelin çıktısını nasıl ürettiğiyle ilgisi olmayan, satıcıya özgü bir sohbet özelliği$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Modelin belirli bir fonksiyonu çağırmak için yapılandırılmış bir istek ürettiği, ve bunu dışarıdaki bir programın gerçekten çalıştırıp sonucunu döndürdüğü bir kalıp$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Modelin veri almak için doğrudan bir veritabanına veya ağa bağlandığı bir kalıp$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Why does tool use exist, according to this lesson?$$,
           NULL, NULL,
           $$Tool use exists to route around structural LLM limits (knowledge cutoff, inability to verify facts or run calculations reliably) rather than trying to fix them by making the model bigger or training it differently -- for anything needing to be current, exact, or a real action, the model requests a tool instead of guessing.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'tools-and-function-calling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$To replace the need for a context window entirely$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$To route around structural LLM limitations (knowledge cutoff, unreliable calculation, no access outside context) for anything needing to be current, exact, or a real action$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$To make the model's training process faster by offloading computation to external servers$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$To let the model permanently update its own knowledge cutoff over time$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, tool use neden var?$$,
           NULL, NULL,
           $$Tool use, modeli büyüterek ya da farklı eğiterek düzeltmeye çalışmak yerine, yapısal LLM kısıtlarının (knowledge cutoff, gerçekleri doğrulayamama, güvenilir hesap yapamama) etrafından dolaşmak için vardır -- güncel, kesin ya da gerçek bir eylem gerektiren her şey için model tahmin etmek yerine bir aracın çalıştırılmasını ister.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'tools-and-function-calling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hesaplamayı harici sunuculara aktararak modelin eğitim sürecini hızlandırmak için$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Modelin kendi knowledge cutoff'unu zaman içinde kalıcı olarak güncelleyebilmesini sağlamak için$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Bir context window'a olan ihtiyacı tamamen ortadan kaldırmak için$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Güncel, kesin ya da gerçek bir eylem gerektiren her şey için, yapısal LLM kısıtlarının (knowledge cutoff, güvenilmez hesaplama, context dışına erişememe) etrafından dolaşmak için$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$In the tool-calling loop, who actually executes the real function -- calling an API, querying a database, running code?$$,
           NULL, NULL,
           $$The lesson is explicit: step 4 of the loop is always carried out by the application hosting the model, in ordinary application code the model has no direct access to -- the model never executes anything itself, in any step of the loop.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'tools-and-function-calling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The model's training infrastructure, triggered automatically by the tool call$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Whichever party -- model or application -- is faster to respond in that round$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$The application hosting the model -- the model itself never executes anything in the loop$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$The model itself, once it has decided a tool call is needed$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Tool-calling loop'ta, gerçek fonksiyonu (bir API çağırmak, bir veritabanını sorgulamak, kod çalıştırmak) gerçekte kim çalıştırır?$$,
           NULL, NULL,
           $$Ders açıktır: loop'un 4. adımı her zaman modeli barındıran uygulama tarafından, modelin doğrudan erişimi olmayan sıradan uygulama koduyla gerçekleştirilir -- model, loop'un hiçbir adımında hiçbir şeyi kendisi çalıştırmaz.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'tools-and-function-calling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Modeli barındıran uygulama -- modelin kendisi loop içinde hiçbir şeyi hiç çalıştırmaz$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Bir tool call gerektiğine karar verdikten sonra modelin kendisi$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Tool call ile otomatik olarak tetiklenen modelin eğitim altyapısı$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$O turda hangisi daha hızlı yanıt veriyorsa, model ya da uygulama$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A developer names a tool "getData" with the description "gets data." According to this lesson, what is the most likely practical consequence?$$,
           NULL, NULL,
           $$The lesson states description quality is one of the most important signals in whether a model picks the right tool -- a vague description leads to a model guessing wrong far more often than a specific one; it does not claim the model will always fail, always pick correctly, or that names/schema don't matter at all.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'tools-and-function-calling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The model will always fail to call this tool under any circumstance$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$The model will still always select this tool correctly, since tool names alone fully determine selection$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$This has no practical effect, since the parameter schema alone determines correct tool selection$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$The model is more likely to guess wrong about when or how to use this tool, since a vague description gives it little to go on$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir geliştirici bir aracı "getData" adıyla ve "veri alır" açıklamasıyla adlandırıyor. Bu derse göre, en olası pratik sonuç nedir?$$,
           NULL, NULL,
           $$Ders, açıklama kalitesinin modelin doğru aracı seçip seçmemesindeki en önemli sinyallerden biri olduğunu belirtir -- belirsiz bir açıklama, modelin spesifik bir açıklamaya göre çok daha sık yanlış tahmin etmesine yol açar; modelin her zaman başarısız olacağını, her zaman doğru seçeceğini ya da isimlerin/şemanın hiç önemli olmadığını iddia etmez.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'tools-and-function-calling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Doğru araç seçimini yalnızca parametre şeması belirlediği için bunun pratik bir etkisi yoktur$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Belirsiz bir açıklama modele fazla bir şey vermediği için, modelin bu aracı ne zaman ya da nasıl kullanacağı konusunda yanlış tahmin etme olasılığı artar$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Model her koşulda bu aracı çağırmakta her zaman başarısız olur$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Yalnızca araç adları seçimi tamamen belirlediği için, model bu aracı yine de her zaman doğru seçer$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A model calls a tool, receives a result, and then decides it needs to call a second tool using information from the first result, before finally answering. What does this reveal about the tool-calling loop?$$,
           NULL, NULL,
           $$The lesson explicitly says the loop can run more than once before a final answer, and every round trip consumes more of the model's context -- it isn't limited to exactly one call, doesn't run for free, and this doesn't automatically make the system an agent (a single conversation using tool calls, still driven by the ongoing exchange, is distinct from the self-directed agent loop covered later in this course).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'tools-and-function-calling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The loop can run multiple rounds before a final answer, and each round trip consumes more of the model's context$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$This is a bug -- the tool-calling loop is only ever supposed to run exactly once per conversation$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Additional tool calls in the same loop don't consume any extra context, since the model already saw the first result$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$This alone means the system has become an agent, since it made more than one tool call$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir model bir aracı çağırıyor, bir sonuç alıyor ve ardından, sonunda cevap vermeden önce ilk sonuçtaki bilgiyi kullanarak ikinci bir aracı çağırması gerektiğine karar veriyor. Bu, tool-calling loop hakkında neyi ortaya koyar?$$,
           NULL, NULL,
           $$Ders açıkça, loop'un nihai bir cevaptan önce birden fazla tur çalışabileceğini ve her gidiş-dönüşün modelin context'inden daha fazlasını tükettiğini belirtir -- tam olarak bir çağrıyla sınırlı değildir, bedavaya çalışmaz, ve bu tek başına sistemin bir agent haline geldiği anlamına gelmez (devam eden bir alışverişle yürütülen, tool call kullanan tek bir konuşma, bu kursta daha sonra ele alınan kendi kendini yönlendiren agent loop'undan farklıdır).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'tools-and-function-calling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Model ilk sonucu zaten gördüğü için, aynı loop içindeki ek tool call'lar hiç ekstra context tüketmez$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Birden fazla tool call yapması tek başına sistemin bir agent haline geldiği anlamına gelir$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Loop, nihai bir cevaptan önce birden fazla tur çalışabilir ve her gidiş-dönüş modelin context'inden daha fazlasını tüketir$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Bu bir hatadır -- tool-calling loop bir konuşma başına yalnızca tam olarak bir kez çalışmalıdır$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A chatbot looks up today's weather when a user asks for it, using a single tool call within an otherwise ordinary conversation. According to this lesson's "Tool Use vs. Agents" section, is this an agent?$$,
           NULL, NULL,
           $$The lesson explicitly says every agent relies on tool use, but the reverse isn't true -- using one tool once, inside an otherwise ordinary conversation, is not by itself an agent; an agent is a broader system that plans multiple steps and sustains the loop with some autonomy, which the "AI Agents" category covers separately.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'tools-and-function-calling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$No -- tool use and agents are entirely unrelated mechanisms with nothing in common$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$No -- a single tool call inside an otherwise ordinary conversation is not by itself an agent$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Yes -- any use of a tool, even once, automatically qualifies a system as an agent$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Yes, but only because the tool call involves live, current data like weather$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir chatbot, kullanıcı sorduğunda, aksi takdirde sıradan olan bir konuşma içinde tek bir tool call kullanarak bugünün havasını sorguluyor. Bu dersin 'Tool Use vs. Agents' bölümüne göre, bu bir agent midir?$$,
           NULL, NULL,
           $$Ders açıkça, her agent'ın tool use'a dayandığını ama tersinin doğru olmadığını belirtir -- aksi takdirde sıradan olan bir konuşma içinde bir aracı tek seferlik kullanmak tek başına bir agent değildir; bir agent, birden çok adımı planlayan ve loop'u bir miktar özerklikle sürdüren daha geniş bir sistemdir, bu da 'AI Agents' kategorisinde ayrıca ele alınır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'tools-and-function-calling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Evet -- bir aracın herhangi bir kullanımı, tek seferlik bile olsa, bir sistemi otomatik olarak agent yapar$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Evet, ama yalnızca tool call hava durumu gibi canlı, güncel veri içerdiği için$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Hayır -- tool use ve agent'lar birbiriyle hiçbir ortak yanı olmayan, tamamen ilgisiz mekanizmalardır$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Hayır -- aksi takdirde sıradan olan bir konuşma içindeki tek bir tool call tek başına bir agent değildir$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about tool use / function calling, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (the model never executes anything itself, only requests it; a tool is defined by name, description, and parameter schema); the model does not decide to use a tool by directly inspecting the application's source code -- it decides based on the conversation text and tool descriptions it's given, and tool use is not, by itself, the same thing as an agent.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'tools-and-function-calling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The model decides whether a tool is needed by directly reading the hosting application's source code$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Using a tool, by itself, is exactly the same thing as being an agent, with no further distinction$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$The model never executes a tool itself -- it produces a structured request, and the hosting application executes the real function$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$A tool is described to the model with three parts: a name, a description, and a parameter schema$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, tool use / function calling hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (modelin hiçbir şeyi kendisi hiç çalıştırmaması, yalnızca istemesi; bir aracın ad, açıklama ve parametre şemasıyla tanımlanması); model, bir aracın gerekip gerekmediğine, uygulamanın kaynak kodunu doğrudan okuyarak değil, kendisine verilen konuşma metnine ve araç açıklamalarına dayanarak karar verir, ve tool use tek başına bir agent olmakla aynı şey değildir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'tools-and-function-calling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Model bir aracı asla kendisi çalıştırmaz -- yapılandırılmış bir istek üretir, ve modeli barındıran uygulama gerçek fonksiyonu çalıştırır$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir araç, modele üç parçayla tanımlanır: bir ad, bir açıklama ve bir parametre şeması$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Model, bir aracın gerekip gerekmediğine, modeli barındıran uygulamanın kaynak kodunu doğrudan okuyarak karar verir$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir aracı kullanmak, tek başına, başka hiçbir ayrım olmadan bir agent olmakla tamamen aynı şeydir$$, FALSE, 3 FROM new_question_tr7;
