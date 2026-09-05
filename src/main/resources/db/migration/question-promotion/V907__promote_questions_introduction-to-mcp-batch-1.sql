-- Promotion batch
-- Topic: introduction-to-mcp (language: en x7, tr x7)
-- Generated: 2026-09-04 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these 14
-- questions were hand-authored and independently self-reviewed directly
-- inside a Claude Code session, grounded strictly in content/en/introduction-to-mcp.md
-- and content/tr/introduction-to-mcp.md -- NOT produced by n8n, NOT judged by any
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
           $$What is the Model Context Protocol (MCP), according to this lesson?$$,
           NULL, NULL,
           $$MCP is an open protocol that standardizes how an AI application connects to external tools, data sources, and prompt templates -- it doesn't replace the tool-calling loop, it standardizes the server side of it, so the same tool implementation can be reused by any MCP-compatible application.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'introduction-to-mcp'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$An open protocol that standardizes how an AI application connects to external tools, data sources, and prompt templates$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$A specific large language model optimized for tool calling$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$A replacement for the tool-calling loop described in the previous lesson$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$A programming language used exclusively for writing AI agents$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, Model Context Protocol (MCP) nedir?$$,
           NULL, NULL,
           $$MCP, bir AI uygulamasının harici araçlara, veri kaynaklarına ve prompt şablonlarına nasıl bağlandığını standartlaştıran açık bir protokoldür -- tool-calling loop'unu değiştirmez, onun sunucu tarafını standartlaştırır, böylece aynı araç uygulaması herhangi bir MCP uyumlu uygulama tarafından yeniden kullanılabilir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'introduction-to-mcp'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Önceki derste anlatılan tool-calling loop'unun yerini alan bir değişiklik$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Yalnızca AI agent'lar yazmak için kullanılan bir programlama dili$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir AI uygulamasının harici araçlara, veri kaynaklarına ve prompt şablonlarına nasıl bağlandığını standartlaştıran açık bir protokol$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Tool calling için optimize edilmiş belirli bir büyük dil modeli$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Why does MCP exist? What problem does it solve, according to this lesson?$$,
           NULL, NULL,
           $$Without a shared standard, connecting M applications to N tools/data sources requires many separate custom integrations; MCP standardizes that architecture so a tool or data source is implemented once as a server and any MCP-compatible application can connect to it unmodified -- often summarized as "M x N -> M + N" (a simplified mental model, not a precise formula).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'introduction-to-mcp'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It guarantees that a model's answers are always factually correct$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$It reduces the need for a separate, custom integration between every AI application and every tool or data source, often summarized as "M x N -> M + N"$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$It makes LLM inference run faster by compressing the model's weights$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$It eliminates the need for tools to have a name, description, or parameter schema$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, MCP neden var? Hangi problemi çözer?$$,
           NULL, NULL,
           $$Ortak bir standart olmadan, M uygulamayı N araca/veri kaynağına bağlamak birçok ayrı, özel entegrasyon gerektirir; MCP bu mimariyi standartlaştırır, böylece bir araç ya da veri kaynağı bir sunucu olarak bir kez uygulanır ve herhangi bir MCP uyumlu uygulama ona değiştirilmeden bağlanabilir -- genellikle 'M x N -> M + N' olarak özetlenir (basitleştirilmiş bir zihinsel model, kesin bir formül değil).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'introduction-to-mcp'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Modelin ağırlıklarını sıkıştırarak LLM inference'ını hızlandırır$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Araçların bir ad, açıklama veya parametre şemasına sahip olma ihtiyacını ortadan kaldırır$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Bir modelin cevaplarının her zaman gerçeğe uygun olduğunu garanti eder$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Her AI uygulaması ile her araç veya veri kaynağı arasında ayrı, özel bir entegrasyon ihtiyacını azaltır, genellikle 'M x N -> M + N' olarak özetlenir$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What is the "host" in MCP's host/client/server model?$$,
           NULL, NULL,
           $$The host is the AI application the person actually interacts with (a chat app, an IDE, a custom agent) -- responsible for talking to the LLM and deciding when to use MCP; it is not the separate program exposing tools (that's the server) and not the internal connection component (that's the client).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'introduction-to-mcp'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The internal component that maintains a one-to-one connection to exactly one server$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$The physical machine or cloud instance where the LLM's weights are stored$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$The AI application the person actually interacts with, responsible for talking to the LLM and deciding when to use MCP$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$The separate program that exposes tools, data, or prompt templates to any connecting client$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$MCP'nin host/client/server modelinde 'host' nedir?$$,
           NULL, NULL,
           $$Host, kişinin gerçekten etkileşime girdiği AI uygulamasıdır (bir sohbet uygulaması, bir IDE, özel bir agent) -- LLM ile konuşmaktan ve MCP'nin ne zaman kullanılacağına karar vermekten sorumludur; araçları sunan ayrı program (bu server'dır) ya da içteki bağlantı bileşeni (bu client'tır) değildir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'introduction-to-mcp'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Kişinin gerçekten etkileşime girdiği, LLM ile konuşmaktan ve MCP'nin ne zaman kullanılacağına karar vermekten sorumlu AI uygulaması$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Bağlanan herhangi bir client'a araç, veri veya prompt şablonu sunan ayrı program$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Tam olarak bir server'a birebir bağlantı sürdüren iç bileşen$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$LLM'nin ağırlıklarının depolandığı fiziksel makine veya bulut örneği$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A host application needs to reach three different MCP servers at once. According to this lesson, how does this work internally?$$,
           NULL, NULL,
           $$The lesson states a client maintains a single, one-to-one connection to exactly one server -- a host that needs to reach three different servers runs three clients internally, one per connection; it isn't one client juggling three connections, and it doesn't mean three separate hosts are required.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'introduction-to-mcp'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The host runs a single client that juggles all three server connections simultaneously$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$This requires three completely separate host applications, one per server$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$This is not possible -- a host can only ever connect to one MCP server at a time$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$The host runs three clients internally, one per server connection, since each client maintains a one-to-one connection to exactly one server$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir host uygulaması aynı anda üç farklı MCP server'a ulaşması gerekiyor. Bu derse göre, bu iç yapıda nasıl çalışır?$$,
           NULL, NULL,
           $$Ders, bir client'ın tam olarak bir server'a birebir bağlantı sürdürdüğünü belirtir -- üç farklı server'a ulaşması gereken bir host, her bağlantı için bir tane olmak üzere iç yapısında üç client çalıştırır; bu tek bir client'ın üç bağlantıyı jonglörlük yapması değildir, ve üç ayrı host gerektirdiği anlamına da gelmez.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'introduction-to-mcp'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bu mümkün değildir -- bir host aynı anda yalnızca bir MCP server'a bağlanabilir$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Host, her client tam olarak bir server'a birebir bağlantı sürdürdüğü için, her server bağlantısı için bir tane olmak üzere iç yapısında üç client çalıştırır$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Host, üç server bağlantısını aynı anda jonglörlük yapan tek bir client çalıştırır$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Bu, server başına bir tane olmak üzere tamamen ayrı üç host uygulaması gerektirir$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$According to this lesson, does an MCP server need to know which host application or which underlying LLM will eventually call it?$$,
           NULL, NULL,
           $$The lesson explicitly states a server doesn't know or care which host it's talking to, or which underlying LLM the host uses -- it only speaks the protocol; this separation is what makes the "write once, use anywhere" property work.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'introduction-to-mcp'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$No -- a server doesn't know or care which host or LLM is calling it, it only speaks the protocol$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Yes -- a server must be custom-built for one specific host application and LLM combination$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Yes, but only for the LLM, not the host application$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Yes, but only for the host application, not the underlying LLM$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir MCP server, kendisini sonunda hangi host uygulamasının veya hangi altta yatan LLM'nin çağıracağını bilmesi gerekir mi?$$,
           NULL, NULL,
           $$Ders açıkça, bir server'ın kendisiyle hangi host'un konuştuğunu ya da host'un hangi altta yatan LLM'yi kullandığını bilmediğini ya da umursamadığını, yalnızca protokolü konuştuğunu belirtir -- bu ayrım, 'bir kere yaz, her yerde kullan' özelliğinin çalışmasını sağlar.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'introduction-to-mcp'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Evet, ama yalnızca LLM için, host uygulaması için değil$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Evet, ama yalnızca host uygulaması için, altta yatan LLM için değil$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Hayır -- bir server, kendisini kimin çağırdığını (host ya da LLM) bilmez ya da umursamaz, yalnızca protokolü konuşur$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Evet -- bir server, belirli bir host uygulaması ve LLM kombinasyonu için özel olarak inşa edilmelidir$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$An MCP server offers a specific file's contents to the host application, which the model can read but which involves no computation and performs no action. According to this lesson, which primitive is this?$$,
           NULL, NULL,
           $$The lesson defines a resource as readable data the host can pull in, identified by a URI, that is read (not executed) and supplies information rather than performing an action -- distinct from a tool (an executable function that performs an action or computation) and a prompt (a reusable prompt template).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'introduction-to-mcp'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$None of MCP's primitives cover this case -- it would require a custom, non-standard extension$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$A resource -- readable data that is read, not executed, and supplies information rather than performing an action$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$A tool -- since anything a server exposes to a client counts as a tool$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$A prompt -- since it's information the model will use in generating a response$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir MCP server, host uygulamasına belirli bir dosyanın içeriğini sunuyor; model bunu okuyabilir ama bu hiçbir hesaplama içermez ve hiçbir eylem gerçekleştirmez. Bu derse göre, bu hangi primitive'tir?$$,
           NULL, NULL,
           $$Ders, bir resource'u, bir URI ile tanımlanan, host'un içine çekebileceği okunabilir veri olarak tanımlar; bu okunur (çalıştırılmaz) ve bir eylem gerçekleştirmek yerine bilgi sağlar -- bir araçtan (bir eylem ya da hesaplama gerçekleştiren çalıştırılabilir fonksiyon) ve bir prompt'tan (yeniden kullanılabilir bir prompt şablonu) farklıdır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'introduction-to-mcp'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir tool -- çünkü bir server'ın client'a sunduğu her şey tool sayılır$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir prompt -- çünkü modelin bir yanıt üretirken kullanacağı bir bilgidir$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$MCP'nin hiçbir primitive'i bu durumu kapsamaz -- özel, standart olmayan bir genişletme gerektirir$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir resource -- okunur (çalıştırılmaz) ve bir eylem gerçekleştirmek yerine bilgi sağlar$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about MCP, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (MCP standardizes discovery/invocation without changing how a model decides to use a tool; a server can expose tools, resources, and prompts, but isn't required to offer all three); MCP does not require every AI application to use exactly the same underlying LLM (servers are LLM-agnostic, not LLM-restrictive), and it does not replace or compete with the underlying idea of tool use from the previous lesson.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'introduction-to-mcp'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$MCP requires every AI application connecting to a server to use the exact same underlying LLM$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$MCP replaces the tool-calling loop and the underlying idea of tool use described in the previous lesson$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$MCP standardizes how tools are discovered and invoked, without changing how a model itself decides whether and how to use a tool$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$A given MCP server is free to expose just one of the three primitives (tools, resources, prompts) rather than being required to offer all of them$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, MCP hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (MCP, bir modelin bir aracı ne zaman ve nasıl kullanacağına nasıl karar verdiğini değiştirmeden, araçların keşfini ve çağrılmasını standartlaştırır; bir server, üç primitive'in (tool, resource, prompt) hepsini sunmak zorunda olmadan yalnızca birini sunmakta serbesttir); MCP, bir server'a bağlanan her AI uygulamasının birebir aynı altta yatan LLM'yi kullanmasını gerektirmez (server'lar LLM'den bağımsızdır, LLM'yi kısıtlamaz), ve önceki derste anlatılan tool-calling loop'unun ve tool use fikrinin yerini almaz.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'introduction-to-mcp'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$MCP, bir modelin bir aracı ne zaman ve nasıl kullanacağına kendi kendine nasıl karar verdiğini değiştirmeden, araçların nasıl keşfedildiğini ve çağrıldığını standartlaştırır$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Belirli bir MCP server, üç primitive'in (tool, resource, prompt) hepsini sunmak zorunda kalmadan yalnızca birini sunmakta serbesttir$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$MCP, bir server'a bağlanan her AI uygulamasının birebir aynı altta yatan LLM'yi kullanmasını gerektirir$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$MCP, önceki derste anlatılan tool-calling loop'unun ve tool use fikrinin yerini alır$$, FALSE, 3 FROM new_question_tr7;
