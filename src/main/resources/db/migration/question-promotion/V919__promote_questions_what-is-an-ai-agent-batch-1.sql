-- Promotion batch
-- Topic: what-is-an-ai-agent (language: en x7, tr x7)
-- Generated: 2026-09-04 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these 14
-- questions were hand-authored and independently self-reviewed directly
-- inside a Claude Code session, grounded strictly in content/en/what-is-an-ai-agent.md
-- and content/tr/what-is-an-ai-agent.md -- NOT produced by n8n, NOT judged by any
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
           $$According to this lesson, what is an AI agent?$$,
           NULL, NULL,
           $$The lesson defines an AI agent as a system, built around one or more model calls plus tool use, that pursues a goal by repeatedly deciding what to do next, taking an action, observing the result, and deciding again, continuing until the goal is met or it decides to stop.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-an-ai-agent'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A system that pursues a goal by repeatedly deciding what to do next, taking an action, observing the result, and deciding again$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Any chatbot that can answer questions using a large language model$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$A single tool call that returns a result to answer one question$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$A dataset used to train a model on reinforcement learning tasks$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir AI agent nedir?$$,
           NULL, NULL,
           $$Ders, bir AI agent'ı, bir veya daha fazla model çağrısı artı tool use etrafında kurulu, bir hedefi, sırayla ne yapacağına tekrar tekrar karar vererek, bir eylem gerçekleştirerek, sonucu gözlemleyerek ve tekrar karar vererek, hedef karşılanana ya da durmaya karar verene kadar sürdüren bir sistem olarak tanımlar.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-an-ai-agent'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir soruyu yanıtlamak için bir sonuç döndüren tek bir tool call$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir modeli reinforcement learning görevlerinde eğitmek için kullanılan bir veri kümesi$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir hedefi, sırayla ne yapacağına tekrar tekrar karar vererek, bir eylem gerçekleştirerek, sonucu gözlemleyerek ve tekrar karar vererek sürdüren bir sistem$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Büyük bir dil modeli kullanarak soruları yanıtlayabilen herhangi bir chatbot$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Why do AI agents exist, according to this lesson's "Why Does It Exist?" section?$$,
           NULL, NULL,
           $$The lesson states agents exist to handle problems where the right sequence of steps, and how many are needed, can only be determined along the way -- these don't fit the ordinary tool-calling loop where one request goes out, one result comes back, and a human is still driving each next step.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-an-ai-agent'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$To guarantee that every goal is completed in exactly one step$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$To handle problems where the necessary steps, and how many of them, can only be determined along the way as earlier steps run$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$To make a single tool call run faster than it otherwise would$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$To eliminate the need for tools to have a name, description, or parameter schema$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu dersin 'Why Does It Exist?' bölümüne göre, AI agent'lar neden var?$$,
           NULL, NULL,
           $$Ders, agent'ların, gerekli adımların ve kaç tanesine ihtiyaç olduğunun ancak önceki adımlar çalıştıkça belirlenebildiği problemleri ele almak için var olduğunu belirtir -- bunlar, bir isteğin gittiği, bir sonucun geldiği ve her bir sonraki adımı hâlâ bir insanın yönlendirdiği sıradan tool-calling loop'una uymaz.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-an-ai-agent'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Tek bir tool call'ın olması gerekenden daha hızlı çalışmasını sağlamak için$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Araçların bir ad, açıklama ya da parametre şemasına sahip olma ihtiyacını ortadan kaldırmak için$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Her hedefin tam olarak tek bir adımda tamamlanmasını garanti etmek için$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Gerekli adımların ve kaç tanesine ihtiyaç olduğunun ancak önceki adımlar çalıştıkça belirlenebildiği problemleri ele almak için$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Put the three steps of the agent loop described in this lesson in the correct order.$$,
           NULL, NULL,
           $$The lesson names the loop Observe (look at the goal and everything that's happened so far), Decide (choose exactly one next step), Act (execute the chosen action, if any) -- in that order, repeating.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-an-ai-agent'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Act, then Observe, then Decide$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Decide, then Observe, then Act$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Observe, then Decide, then Act$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Decide, then Act, then Observe$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu dersin tarif ettiği agent loop'unun üç adımını doğru sıraya koyun.$$,
           NULL, NULL,
           $$Ders, loop'u Observe (hedefe ve o ana kadar olan her şeye bakmak), Decide (tam olarak bir sonraki adıma karar vermek), Act (varsa seçilen eylemi gerçekleştirmek) olarak adlandırır -- bu sırayla, tekrar ederek.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-an-ai-agent'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Önce Observe, sonra Decide, sonra Act$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Önce Decide, sonra Act, sonra Observe$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Önce Act, sonra Observe, sonra Decide$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Önce Decide, sonra Observe, sonra Act$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$An ordinary chatbot looks up today's weather when a user asks for it, then the conversation continues normally. According to this lesson, does this single lookup make the chatbot an agent?$$,
           NULL, NULL,
           $$The lesson states using a tool once, inside a single request/response exchange, is not what makes something an agent -- an ordinary chatbot that looks up today's weather when asked does not become an agent by doing so; what makes a system an agent is the loop running under the system's own control across multiple steps.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-an-ai-agent'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yes -- any tool call automatically qualifies a system as an agent, regardless of context$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Yes, but only because weather data is considered a live, current-information tool$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$No, but only because weather lookups specifically are excluded from the agent definition$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$No -- using a tool once inside a single request/response exchange doesn't make a system an agent$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Sıradan bir chatbot, kullanıcı sorduğunda bugünün havasını sorguluyor, sonra konuşma normal şekilde devam ediyor. Bu derse göre, bu tek seferlik sorgulama chatbot'u bir agent yapar mı?$$,
           NULL, NULL,
           $$Ders, bir aracı tek bir istek/yanıt alışverişi içinde tek seferlik kullanmanın bir şeyi agent yapan şey olmadığını belirtir -- sorulduğunda bugünün havasını sorgulayan sıradan bir chatbot, bunu yaparak bir agent haline gelmez; bir sistemi agent yapan şey, loop'un sistemin kendi kontrolü altında birden çok adım boyunca çalışmasıdır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-an-ai-agent'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hayır, ama yalnızca hava durumu sorguları özellikle agent tanımından hariç tutulduğu için$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Hayır -- bir aracı tek bir istek/yanıt alışverişi içinde tek seferlik kullanmak bir sistemi agent yapmaz$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Evet -- bağlamdan bağımsız olarak herhangi bir tool call, bir sistemi otomatik olarak agent olarak nitelendirir$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Evet, ama yalnızca hava durumu verisi canlı, güncel bir bilgi aracı sayıldığı için$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$According to "The Autonomy Spectrum," is "agent" a single, fixed amount of independence, or something else?$$,
           NULL, NULL,
           $$The lesson explicitly says "agent" doesn't describe one fixed amount of independence -- it names a spectrum, from a system whose every decision is effectively scripted by a human in advance, to one running many decide-act cycles entirely on its own; most practical agents sit somewhere between these extremes.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-an-ai-agent'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It names a spectrum -- from fully human-scripted behavior to fully autonomous, multi-step behavior, with most practical agents in between$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$It describes exactly one fixed, universal amount of independence that every agent must have$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$It only applies to systems that never require any human involvement whatsoever$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$It only applies to systems where a human approves literally every single decision$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$'The Autonomy Spectrum'a göre, 'agent' tek, sabit bir bağımsızlık miktarını mı ifade eder, yoksa başka bir şeyi mi?$$,
           NULL, NULL,
           $$Ders açıkça, 'agent'ın tek, sabit bir bağımsızlık miktarını ifade etmediğini belirtir -- bir spektrumu adlandırır, bir insanın önceden etkili biçimde senaryolaştırdığı her kararı olan bir sistemden, tamamen kendi başına birçok karar-eylem döngüsü çalıştıran bir sisteme kadar; çoğu pratik agent bu uçlar arasında bir yerde durur.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-an-ai-agent'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca hiçbir şekilde insan katılımı gerektirmeyen sistemlere uygulanır$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Yalnızca bir insanın gerçekten her tek kararı onayladığı sistemlere uygulanır$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Bir spektrumu adlandırır -- tamamen insan tarafından senaryolaştırılmış davranıştan tamamen özerk, çok adımlı davranışa kadar, çoğu pratik agent arada bir yerde$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Her agent'ın sahip olması gereken tek, sabit, evrensel bir bağımsızlık miktarını tanımlar$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$How does this lesson describe the relationship between the agent loop and "The Tool-Calling Loop" from "Tools and Function Calling"?$$,
           NULL, NULL,
           $$The lesson explicitly calls the agent loop "a direct generalization of 'The Tool-Calling Loop'" -- instead of running once and stopping, the same observe-decide-act cycle repeats, under the system's own control, until the goal is met or a safety limit is reached.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-an-ai-agent'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The tool-calling loop is a more advanced, later addition built on top of the agent loop$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$The agent loop is a direct generalization of the tool-calling loop -- the same cycle repeats under the system's own control instead of running once$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$The two loops are completely unrelated mechanisms that happen to share some vocabulary$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$The agent loop replaces the tool-calling loop entirely, making tool calls unnecessary for agents$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu ders, agent loop'u ile 'Tools and Function Calling'deki 'The Tool-Calling Loop' arasındaki ilişkiyi nasıl tanımlar?$$,
           NULL, NULL,
           $$Ders, agent loop'unu açıkça 'The Tool-Calling Loop'un doğrudan bir genellemesi' olarak adlandırır -- bir kez çalışıp durmak yerine, aynı observe-decide-act döngüsü, hedef karşılanana ya da bir güvenlik sınırına ulaşılana kadar, sistemin kendi kontrolü altında tekrar eder.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-an-ai-agent'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İki loop, tesadüfen bazı kelime dağarcığını paylaşan, tamamen ilgisiz mekanizmalardır$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Agent loop, tool-calling loop'un yerini tamamen alır ve agent'lar için tool call'ları gereksiz kılar$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Tool-calling loop, agent loop'unun üzerine inşa edilmiş, daha sonra eklenmiş daha gelişmiş bir eklentidir$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Agent loop, tool-calling loop'un doğrudan bir genellemesidir -- bir kez çalışmak yerine aynı döngü sistemin kendi kontrolü altında tekrar eder$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about AI agents, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (three things distinguish the agent loop from ordinary tool use: the sequence isn't fixed in advance, the number of steps isn't known ahead of time, and each decision is informed by the previous step; and an agent's model-driven decision-making is still the same kind of model with the same reasoning limits covered in "LLM Capabilities and Limitations"); an agent's own decision step is still made by a model call, not literally hardcoded by a human in advance, and more autonomy is explicitly not framed as automatically better in this lesson.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-an-ai-agent'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Every step an agent takes is decided by a human in advance, in exactly the same way a single tool call is$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$More autonomy is always better for an agent, since it means fewer steps are ever routed back to a human$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Compared to a single tool call, an agent's sequence of decisions isn't fixed in advance, its number of steps isn't known ahead of time, and each decision is informed by what happened in the previous step$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$An agent's decision-making is still made by the same kind of model covered in "Reasoning Limits" -- planning a sequence of tool calls doesn't remove those underlying limits$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, AI agent'lar hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (agent loop'unu sıradan tool use'tan ayıran üç şey: sıranın önceden sabitlenmemiş olması, adım sayısının önceden bilinmemesi, ve her kararın bir önceki adımda olanlardan bilgi alması; ve bir agent'ın model tarafından yönlendirilen karar vermesinin hâlâ 'LLM Capabilities and Limitations'daki aynı akıl yürütme kısıtlarına sahip aynı türden bir model olması); bir agent'ın kendi karar adımı hâlâ bir model çağrısıyla yapılır, bir insan tarafından önceden birebir sabit kodlanmaz, ve bu derste daha fazla özerkliğin otomatik olarak daha iyi olduğu hiç belirtilmez.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-an-ai-agent'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Tek bir tool call'a kıyasla, bir agent'ın karar sırası önceden sabitlenmemiştir, adım sayısı önceden bilinmez, ve her karar bir önceki adımda olanlardan bilgi alır$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir agent'ın karar vermesi hâlâ 'Reasoning Limits'te ele alınan aynı türden bir model tarafından yapılır -- bir dizi tool call'ı planlamak bu altta yatan kısıtları ortadan kaldırmaz$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir agent'ın attığı her adım, tıpkı tek bir tool call'da olduğu gibi, önceden bir insan tarafından karar verilir$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Daha fazla özerklik bir agent için her zaman daha iyidir, çünkü bu, hiçbir adımın bir insana geri yönlendirilmediği anlamına gelir$$, FALSE, 3 FROM new_question_tr7;
