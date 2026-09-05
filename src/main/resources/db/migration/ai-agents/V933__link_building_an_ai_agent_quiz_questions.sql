-- Promotion-style migration linking EN building-an-ai-agent quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.


-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'building-an-ai-agent')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to "What's Real and What's Simulated in This Lesson," which part of this lesson's agent is simulated rather than genuinely real?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$According to "What's Real and What's Simulated in This Lesson," which part of this lesson's agent is simulated rather than genuinely real?$$,
           NULL, NULL,
           $$The lesson is explicit: the agent loop itself, every tool call, and the step limit are all real -- only the decision step, decideNextAction(), is simulated: a small, fully deterministic, hand-written function recognizing two fixed patterns of text, explicitly labeled (simulated) in its own output.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'building-an-ai-agent'
      AND NOT EXISTS (SELECT 1 FROM existing_q1)
    RETURNING id
),
target_q1 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q1
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q1
),
option_ins_q1 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q1.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q1
             CROSS JOIN (VALUES
    ($$The decision step, decideNextAction() -- a deterministic, hand-written stand-in labeled (simulated) in its own output$$, TRUE, 0),
    ($$The tool calls to get_capital_city and calculate_sum -- these are faked and never actually reach the server$$, FALSE, 1),
    ($$The step limit -- it is not genuinely enforced anywhere in this lesson's code$$, FALSE, 2),
    ($$The entire agent loop, including the observe-decide-act cycle itself$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'building-an-ai-agent'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'building-an-ai-agent')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does runAgentLoop()'s maxSteps parameter guarantee, according to this lesson?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does runAgentLoop()'s maxSteps parameter guarantee, according to this lesson?$$,
           NULL, NULL,
           $$runAgentLoop() runs an ordinary bounded for loop up to maxSteps iterations; if maxSteps is reached without a final answer, stoppedByStepLimit comes back true instead of the loop continuing forever -- this is the step-limit guardrail from "Controlling Agent Behavior", implemented as a bounded loop.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'building-an-ai-agent'
      AND NOT EXISTS (SELECT 1 FROM existing_q2)
    RETURNING id
),
target_q2 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q2
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q2
),
option_ins_q2 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q2.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q2
             CROSS JOIN (VALUES
    ($$It determines how many separate MCP servers the agent is allowed to connect to at once$$, FALSE, 0),
    ($$It bounds how many decide-act iterations the loop may run, forcing a stop (stoppedByStepLimit: true) instead of looping forever if no final answer is reached$$, TRUE, 1),
    ($$It guarantees the decision step will always produce a correct final answer within that many steps$$, FALSE, 2),
    ($$It sets the maximum number of tools GeoFactsServer.ts is allowed to expose$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'building-an-ai-agent'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'building-an-ai-agent')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given decideNextAction()'s logic below and the goal string "What is the capital of Turkey?" (with an empty history so far), what does it decide to do?$$
      AND code_snippet = $$const countryMatch = goal.match(/capital of (\w+)/i);
if (countryMatch && !alreadyCalled("get_capital_city")) {
  const country = countryMatch[1];
  return {
    thought: `(simulated) Goal asks for the capital of "${country}". Plan: call get_capital_city.`,
    toolCall: { name: "get_capital_city", arguments: { country } },
  };
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
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
    FROM topic
    WHERE slug = 'building-an-ai-agent'
      AND NOT EXISTS (SELECT 1 FROM existing_q3)
    RETURNING id
),
target_q3 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q3
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q3
),
option_ins_q3 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q3.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q3
             CROSS JOIN (VALUES
    ($$It returns a toolCall for calculate_sum, since no country-specific tool exists in this file$$, FALSE, 0),
    ($$It throws an error, since "Turkey" doesn't match the regex pattern used to detect a capital-city goal$$, FALSE, 1),
    ($$It returns a toolCall for get_capital_city with arguments { country: "Turkey" }, and a thought starting with "(simulated)"$$, TRUE, 2),
    ($$It returns a finalAnswer immediately, since the goal only asks about one country$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'building-an-ai-agent'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'building-an-ai-agent')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given this lesson's real, observed run against the goal "What is the capital of Japan, and what is the sum of 12, 30, and 8?" with maxSteps=5, what does the trace's final two lines show?$$
      AND code_snippet = $$const result = await runAgentLoop(client, goal, 5);
// ...
console.log(`Final answer: ${result.finalAnswer}`);
console.log(`Stopped by step limit: ${result.stoppedByStepLimit}`);$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given this lesson's real, observed run against the goal "What is the capital of Japan, and what is the sum of 12, 30, and 8?" with maxSteps=5, what does the trace's final two lines show?$$,
           $$const result = await runAgentLoop(client, goal, 5);
// ...
console.log(`Final answer: ${result.finalAnswer}`);
console.log(`Stopped by step limit: ${result.stoppedByStepLimit}`);$$, $$typescript$$,
           $$The lesson's actual, verified output ends with: Final answer: The capital of Japan is Tokyo. Sum: 50 / Stopped by step limit: false -- both sub-goals were resolved by real tool calls within 2 of the 5 allowed steps, so the loop concluded on its own rather than being forced to stop by the step limit.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'building-an-ai-agent'
      AND NOT EXISTS (SELECT 1 FROM existing_q4)
    RETURNING id
),
target_q4 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q4
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q4
),
option_ins_q4 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q4.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q4
             CROSS JOIN (VALUES
    ($$Final answer: (step limit reached before a final answer was produced) / Stopped by step limit: true$$, FALSE, 0),
    ($$Final answer: The capital of Japan is Tokyo. Sum: 50 / Stopped by step limit: true$$, FALSE, 1),
    ($$Final answer: No capital known for "Japan". / Stopped by step limit: false$$, FALSE, 2),
    ($$Final answer: The capital of Japan is Tokyo. Sum: 50 / Stopped by step limit: false$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'building-an-ai-agent'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'building-an-ai-agent')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$The goal is changed to "What is the capital of Wakanda?" and rerun. According to "Trying the Error Path," what happens to the isError: true result from GeoFactsServer.ts?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$The goal is changed to "What is the capital of Wakanda?" and rerun. According to "Trying the Error Path," what happens to the isError: true result from GeoFactsServer.ts?$$,
           NULL, NULL,
           $$The lesson confirms runAgentLoop() doesn't crash or treat the error specially -- the real error result becomes part of history like any other tool result, and decideNextAction()'s (simulated) final-answer step reports it as-is, producing "Final answer: No capital known for 'Wakanda'."$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'building-an-ai-agent'
      AND NOT EXISTS (SELECT 1 FROM existing_q5)
    RETURNING id
),
target_q5 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q5
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q5
),
option_ins_q5 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q5.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q5
             CROSS JOIN (VALUES
    ($$It becomes part of history like any other tool result, and the loop reports it as-is in the final answer, without crashing$$, TRUE, 0),
    ($$runAgentLoop() crashes immediately, since it has no way to handle a tool result with isError: true$$, FALSE, 1),
    ($$The error is silently discarded, and the loop reports a made-up capital city instead$$, FALSE, 2),
    ($$The step limit is reached immediately without any tool call being attempted at all$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'building-an-ai-agent'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'building-an-ai-agent')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to "What Would Change With a Real Model," what is the only change needed to move from this lesson's demo to a production agent?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$According to "What Would Change With a Real Model," what is the only change needed to move from this lesson's demo to a production agent?$$,
           NULL, NULL,
           $$The lesson states replacing decideNextAction() with a real LLM call is the only change needed -- runAgentLoop(), GeoFactsServer.ts, and the MCP wiring in RunAgentDemo.ts would stay exactly the same, because none of them depend on how the decision is made.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'building-an-ai-agent'
      AND NOT EXISTS (SELECT 1 FROM existing_q6)
    RETURNING id
),
target_q6 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q6
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q6
),
option_ins_q6 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q6.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q6
             CROSS JOIN (VALUES
    ($$Switching from MCP's tools/call mechanism to a completely different, non-MCP tool invocation protocol$$, FALSE, 0),
    ($$Replacing decideNextAction() with a real LLM call -- runAgentLoop(), GeoFactsServer.ts, and the MCP wiring stay exactly the same$$, TRUE, 1),
    ($$Rewriting runAgentLoop() entirely, since a bounded for loop cannot work with a real language model$$, FALSE, 2),
    ($$Replacing GeoFactsServer.ts's tools with entirely different ones, since real deployments cannot reuse demo tools$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'building-an-ai-agent'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'building-an-ai-agent')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about this lesson's agent implementation are correct? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about this lesson's agent implementation are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (GeoFactsServer.ts is reused completely unchanged from "Building an MCP Server", proving an MCP server has no idea whether its caller is a single tool call or a full agent loop; and every thought string decideNextAction() produces starts with the literal text "(simulated)", specifically so nothing printed can be mistaken for genuine model reasoning); decideNextAction() is explicitly a small, deterministic, regex-based function -- not a simplified language model -- and it recognizes exactly two fixed patterns, not an open-ended/general-purpose set of goals.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'building-an-ai-agent'
      AND NOT EXISTS (SELECT 1 FROM existing_q7)
    RETURNING id
),
target_q7 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q7
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q7
),
option_ins_q7 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q7.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q7
             CROSS JOIN (VALUES
    ($$decideNextAction() is a simplified, general-purpose language model capable of understanding goals beyond its two hardcoded text patterns$$, FALSE, 0),
    ($$decideNextAction() can recognize an open-ended, unlimited variety of goal phrasings, not just the two specific patterns this lesson describes$$, FALSE, 1),
    ($$GeoFactsServer.ts is reused completely unchanged from "Building an MCP Server" -- an MCP server has no idea whether its caller is a single tool call or a full agent loop$$, TRUE, 2),
    ($$Every thought string decideNextAction() produces starts with the literal text "(simulated)", so nothing printed can be mistaken for genuine model reasoning$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'building-an-ai-agent'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
