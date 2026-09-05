-- Promotion batch
-- Topic: building-an-ai-agent (language: en x7, tr x7)
-- Generated: 2026-09-04 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these 14
-- questions were hand-authored and independently self-reviewed directly
-- inside a Claude Code session, grounded strictly in content/en/building-an-ai-agent.md
-- and content/tr/building-an-ai-agent.md -- NOT produced by n8n, NOT judged by any
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
           $$According to "What's Real and What's Simulated in This Lesson," which part of this lesson's agent is simulated rather than genuinely real?$$,
           NULL, NULL,
           $$The lesson is explicit: the agent loop itself, every tool call, and the step limit are all real -- only the decision step, decideNextAction(), is simulated: a small, fully deterministic, hand-written function recognizing two fixed patterns of text, explicitly labeled (simulated) in its own output.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'building-an-ai-agent'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The decision step, decideNextAction() -- a deterministic, hand-written stand-in labeled (simulated) in its own output$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$The tool calls to get_capital_city and calculate_sum -- these are faked and never actually reach the server$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$The step limit -- it is not genuinely enforced anywhere in this lesson's code$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$The entire agent loop, including the observe-decide-act cycle itself$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$'What's Real and What's Simulated in This Lesson'a göre, bu dersin agent'ının hangi kısmı gerçekten değil, simüle edilmiş olarak çalışır?$$,
           NULL, NULL,
           $$Ders açıktır: agent loop'unun kendisi, her tool call ve step limit hepsi gerçektir -- yalnızca karar adımı, decideNextAction(), simüle edilmiştir: iki sabit metin kalıbını tanıyan, kendi çıktısında açıkça (simulated) olarak etiketlenen küçük, tamamen deterministik, elle yazılmış bir fonksiyon.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'building-an-ai-agent'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Step limit -- bu dersin kodunda hiçbir yerde gerçekten zorunlu kılınmaz$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Observe-decide-act döngüsünün kendisi dahil tüm agent loop'u$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Karar adımı, decideNextAction() -- kendi çıktısında (simulated) olarak etiketlenen deterministik, elle yazılmış bir yerine geçen$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$get_capital_city ve calculate_sum'a yapılan tool call'lar -- bunlar sahtedir ve asla gerçekten server'a ulaşmaz$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What does runAgentLoop()'s maxSteps parameter guarantee, according to this lesson?$$,
           NULL, NULL,
           $$runAgentLoop() runs an ordinary bounded for loop up to maxSteps iterations; if maxSteps is reached without a final answer, stoppedByStepLimit comes back true instead of the loop continuing forever -- this is the step-limit guardrail from "Controlling Agent Behavior", implemented as a bounded loop.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'building-an-ai-agent'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It determines how many separate MCP servers the agent is allowed to connect to at once$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$It bounds how many decide-act iterations the loop may run, forcing a stop (stoppedByStepLimit: true) instead of looping forever if no final answer is reached$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$It guarantees the decision step will always produce a correct final answer within that many steps$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$It sets the maximum number of tools GeoFactsServer.ts is allowed to expose$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, runAgentLoop()'un maxSteps parametresi neyi garanti eder?$$,
           NULL, NULL,
           $$runAgentLoop(), maxSteps yinelemesine kadar sıradan, sınırlı bir for loop çalıştırır; maxSteps'e bir nihai cevap olmadan ulaşılırsa, loop sonsuza kadar devam etmek yerine stoppedByStepLimit true olarak geri döner -- bu, sınırlı bir loop olarak uygulanan, 'Controlling Agent Behavior'daki step-limit güvencesidir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'building-an-ai-agent'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Karar adımının o kadar adım içinde her zaman doğru bir nihai cevap üreteceğini garanti eder$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$GeoFactsServer.ts'nin sunmasına izin verilen maksimum araç sayısını belirler$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Agent'ın aynı anda bağlanmasına izin verilen ayrı MCP server sayısını belirler$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Loop'un çalıştırabileceği decide-act yinelemesi sayısını sınırlar, bir nihai cevaba ulaşılmazsa sonsuza kadar dönmek yerine durmasını (stoppedByStepLimit: true) zorunlu kılar$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given decideNextAction()'s logic below and the goal string "What is the capital of Turkey?" (with an empty history so far), what does it decide to do?$$,
           $$const countryMatch = goal.match(/capital of (\w+)/i);
if (countryMatch && !alreadyCalled("get_capital_city")) {
  const country = countryMatch[1];
  return {
    thought: `(simulated) Goal asks for the capital of "${country}". Plan: call get_capital_city.`,
    toolCall: { name: "get_capital_city", arguments: { country } },
  };
}$$, $$typescript$$,
           $$The regex /capital of (\w+)/i matches "capital of Turkey" in the goal, capturing "Turkey"; since get_capital_city hasn't been called yet (empty history), decideNextAction() returns a toolCall for get_capital_city with arguments { country: "Turkey" }, and a thought starting with the literal text "(simulated)".$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'building-an-ai-agent'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It returns a toolCall for calculate_sum, since no country-specific tool exists in this file$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$It throws an error, since "Turkey" doesn't match the regex pattern used to detect a capital-city goal$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$It returns a toolCall for get_capital_city with arguments { country: "Turkey" }, and a thought starting with "(simulated)"$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$It returns a finalAnswer immediately, since the goal only asks about one country$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdaki decideNextAction() mantığı ve "Fransa'nın başkenti nedir?" hedef metni (şimdilik boş bir history ile) göz önüne alındığında, ne yapmaya karar verir?$$,
           $$const countryMatch = goal.match(/capital of (\w+)/i);
if (countryMatch && !alreadyCalled("get_capital_city")) {
  const country = countryMatch[1];
  return {
    thought: `(simulated) Goal asks for the capital of "${country}". Plan: call get_capital_city.`,
    toolCall: { name: "get_capital_city", arguments: { country } },
  };
}$$, $$typescript$$,
           $$Not: bu regex İngilizce 'capital of X' kalıbını arar; Türkçe 'Fransa'nın başkenti nedir?' bu kalıpla eşleşmez, bu yüzden countryMatch null olur ve bu if bloğu hiç çalışmaz -- fonksiyon sum kontrolüne geçer, o da eşleşmez, ve sonunda (simulated) bir finalAnswer üretir (henüz hiçbir tool sonucu toplanmadığı için 'no tool results were gathered').$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'building-an-ai-agent'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$countryMatch null olur (regex yalnızca İngilizce 'capital of X' kalıbını arar), if bloğu atlanır ve fonksiyon sonunda (simulated) bir finalAnswer üretir$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Regex Türkçe metinleri de otomatik olarak tanıyacak şekilde tasarlandığı için get_capital_city için bir toolCall döndürür$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$"Fransa" argümanıyla get_capital_city için bir toolCall döndürür, çünkü regex dile duyarsızdır$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Bir exception fırlatır, çünkü fonksiyon yalnızca İngilizce girdiyle çağrılabilir$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this lesson's real, observed run against the goal "What is the capital of Japan, and what is the sum of 12, 30, and 8?" with maxSteps=5, what does the trace's final two lines show?$$,
           $$const result = await runAgentLoop(client, goal, 5);
// ...
console.log(`Final answer: ${result.finalAnswer}`);
console.log(`Stopped by step limit: ${result.stoppedByStepLimit}`);$$, $$typescript$$,
           $$The lesson's actual, verified output ends with: Final answer: The capital of Japan is Tokyo. Sum: 50 / Stopped by step limit: false -- both sub-goals were resolved by real tool calls within 2 of the 5 allowed steps, so the loop concluded on its own rather than being forced to stop by the step limit.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'building-an-ai-agent'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Final answer: (step limit reached before a final answer was produced) / Stopped by step limit: true$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Final answer: The capital of Japan is Tokyo. Sum: 50 / Stopped by step limit: true$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Final answer: No capital known for "Japan". / Stopped by step limit: false$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Final answer: The capital of Japan is Tokyo. Sum: 50 / Stopped by step limit: false$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu dersin "Japonya'nın başkenti nedir ve 12, 30 ve 8'in toplamı nedir?" hedefine karşı maxSteps=5 ile yaptığı gerçek, gözlemlenmiş çalıştırmada, izin sonundaki son iki satır ne gösterir?$$,
           $$const result = await runAgentLoop(client, goal, 5);
// ...
console.log(`Final answer: ${result.finalAnswer}`);
console.log(`Stopped by step limit: ${result.stoppedByStepLimit}`);$$, $$typescript$$,
           $$Dersin gerçek, doğrulanmış çıktısı şununla biter: Final answer: The capital of Japan is Tokyo. Sum: 50 / Stopped by step limit: false -- her iki alt-hedef de izin verilen 5 adımın 2'si içinde gerçek tool call'larla çözüldü, bu yüzden loop step limit tarafından durdurulmaya zorlanmak yerine kendi kararıyla sonuçlandı.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'building-an-ai-agent'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Final answer: No capital known for "Japan". / Stopped by step limit: false$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Final answer: The capital of Japan is Tokyo. Sum: 50 / Stopped by step limit: false$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Final answer: (step limit reached before a final answer was produced) / Stopped by step limit: true$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Final answer: The capital of Japan is Tokyo. Sum: 50 / Stopped by step limit: true$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$The goal is changed to "What is the capital of Wakanda?" and rerun. According to "Trying the Error Path," what happens to the isError: true result from GeoFactsServer.ts?$$,
           NULL, NULL,
           $$The lesson confirms runAgentLoop() doesn't crash or treat the error specially -- the real error result becomes part of history like any other tool result, and decideNextAction()'s (simulated) final-answer step reports it as-is, producing "Final answer: No capital known for 'Wakanda'."$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'building-an-ai-agent'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It becomes part of history like any other tool result, and the loop reports it as-is in the final answer, without crashing$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$runAgentLoop() crashes immediately, since it has no way to handle a tool result with isError: true$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$The error is silently discarded, and the loop reports a made-up capital city instead$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$The step limit is reached immediately without any tool call being attempted at all$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Hedef "Wakanda'nın başkenti nedir?" olarak değiştirilip yeniden çalıştırılıyor. 'Trying the Error Path'e göre, GeoFactsServer.ts'nin isError: true sonucuna ne olur?$$,
           NULL, NULL,
           $$Ders, runAgentLoop()'un çökmediğini ya da hatayı özel olarak ele almadığını doğrular -- gerçek hata sonucu, diğer herhangi bir tool sonucu gibi history'nin bir parçası olur, ve decideNextAction()'ın (simulated) nihai-cevap adımı bunu olduğu gibi bildirir, "Final answer: No capital known for 'Wakanda'." üretir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'building-an-ai-agent'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hata sessizce atılır, ve loop bunun yerine uydurma bir başkent bildirir$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Hiçbir tool call denenmeden step limit'e hemen ulaşılır$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Diğer herhangi bir tool sonucu gibi history'nin bir parçası olur, ve loop çökmeden bunu nihai cevapta olduğu gibi bildirir$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$runAgentLoop(), isError: true olan bir tool sonucunu ele almanın bir yolu olmadığı için hemen çöker$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$According to "What Would Change With a Real Model," what is the only change needed to move from this lesson's demo to a production agent?$$,
           NULL, NULL,
           $$The lesson states replacing decideNextAction() with a real LLM call is the only change needed -- runAgentLoop(), GeoFactsServer.ts, and the MCP wiring in RunAgentDemo.ts would stay exactly the same, because none of them depend on how the decision is made.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'building-an-ai-agent'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Switching from MCP's tools/call mechanism to a completely different, non-MCP tool invocation protocol$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Replacing decideNextAction() with a real LLM call -- runAgentLoop(), GeoFactsServer.ts, and the MCP wiring stay exactly the same$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Rewriting runAgentLoop() entirely, since a bounded for loop cannot work with a real language model$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Replacing GeoFactsServer.ts's tools with entirely different ones, since real deployments cannot reuse demo tools$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$'What Would Change With a Real Model'a göre, bu dersin demosundan bir production agent'a geçmek için gereken tek değişiklik nedir?$$,
           NULL, NULL,
           $$Ders, decideNextAction()'ı gerçek bir LLM çağrısıyla değiştirmenin gereken tek değişiklik olduğunu belirtir -- runAgentLoop(), GeoFactsServer.ts ve RunAgentDemo.ts'deki MCP bağlantısı, hiçbiri kararın nasıl verildiğine bağlı olmadığı için birebir aynı kalır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'building-an-ai-agent'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$runAgentLoop()'u tamamen yeniden yazmak, çünkü sınırlı bir for loop gerçek bir dil modeliyle çalışamaz$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$GeoFactsServer.ts'nin araçlarını tamamen farklı olanlarla değiştirmek, çünkü gerçek dağıtımlar demo araçlarını yeniden kullanamaz$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$MCP'nin tools/call mekanizmasından tamamen farklı, MCP olmayan bir tool çağırma protokolüne geçmek$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$decideNextAction()'ı gerçek bir LLM çağrısıyla değiştirmek -- runAgentLoop(), GeoFactsServer.ts ve MCP bağlantısı birebir aynı kalır$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about this lesson's agent implementation are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (GeoFactsServer.ts is reused completely unchanged from "Building an MCP Server", proving an MCP server has no idea whether its caller is a single tool call or a full agent loop; and every thought string decideNextAction() produces starts with the literal text "(simulated)", specifically so nothing printed can be mistaken for genuine model reasoning); decideNextAction() is explicitly a small, deterministic, regex-based function -- not a simplified language model -- and it recognizes exactly two fixed patterns, not an open-ended/general-purpose set of goals.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'building-an-ai-agent'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$decideNextAction() is a simplified, general-purpose language model capable of understanding goals beyond its two hardcoded text patterns$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$decideNextAction() can recognize an open-ended, unlimited variety of goal phrasings, not just the two specific patterns this lesson describes$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$GeoFactsServer.ts is reused completely unchanged from "Building an MCP Server" -- an MCP server has no idea whether its caller is a single tool call or a full agent loop$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Every thought string decideNextAction() produces starts with the literal text "(simulated)", so nothing printed can be mistaken for genuine model reasoning$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu dersin agent implementasyonu hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (GeoFactsServer.ts'nin 'Building an MCP Server'dan tamamen değişmeden yeniden kullanılması, bir MCP server'ın çağıranının tek bir tool call mı yoksa tam bir agent loop mu olduğu hakkında hiçbir fikri olmadığını kanıtlar; ve decideNextAction()'ın ürettiği her thought metninin, yazdırılan hiçbir şeyin gerçek model akıl yürütmesiyle karıştırılmaması için özellikle harfi harfine '(simulated)' metniyle başlaması); decideNextAction() açıkça küçük, deterministik, regex tabanlı bir fonksiyondur -- basitleştirilmiş bir dil modeli değildir -- ve tam olarak iki sabit kalıbı tanır, açık uçlu/genel amaçlı bir hedef kümesini değil.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'building-an-ai-agent'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$GeoFactsServer.ts, 'Building an MCP Server'dan tamamen değişmeden yeniden kullanılır -- bir MCP server, çağıranının tek bir tool call mı yoksa tam bir agent loop mu olduğu hakkında hiçbir fikre sahip değildir$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$decideNextAction()'ın ürettiği her thought metni, yazdırılan hiçbir şeyin gerçek model akıl yürütmesiyle karıştırılmaması için harfi harfine '(simulated)' metniyle başlar$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$decideNextAction(), iki sabit kodlanmış metin kalıbının ötesinde hedefleri anlayabilen, basitleştirilmiş, genel amaçlı bir dil modelidir$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$decideNextAction(), bu dersin tarif ettiği iki spesifik kalıpla sınırlı kalmadan, açık uçlu, sınırsız çeşitlilikte hedef ifadesini tanıyabilir$$, FALSE, 3 FROM new_question_tr7;
