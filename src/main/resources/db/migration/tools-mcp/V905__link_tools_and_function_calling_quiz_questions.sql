-- Promotion-style migration linking EN tools-and-function-calling quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.


-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'tools-and-function-calling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is tool use (function calling), precisely?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What is tool use (function calling), precisely?$$,
           NULL, NULL,
           $$Tool use is a pattern where the model generates a structured request naming a function and its arguments, and a program OUTSIDE the model executes it and returns the result; the model itself never runs code or touches a network/database directly.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'tools-and-function-calling'
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
    ($$A pattern where the model generates a structured request to call a specific function, which an outside program actually executes and returns the result of$$, TRUE, 0),
    ($$A pattern where the model directly connects to a database or network to fetch data itself$$, FALSE, 1),
    ($$A feature that lets the model rewrite its own training weights based on a function's result$$, FALSE, 2),
    ($$A vendor-specific chat feature unrelated to how the model produces its output$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'tools-and-function-calling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'tools-and-function-calling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why does tool use exist, according to this lesson?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Why does tool use exist, according to this lesson?$$,
           NULL, NULL,
           $$Tool use exists to route around structural LLM limits (knowledge cutoff, inability to verify facts or run calculations reliably) rather than trying to fix them by making the model bigger or training it differently -- for anything needing to be current, exact, or a real action, the model requests a tool instead of guessing.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'tools-and-function-calling'
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
    ($$To replace the need for a context window entirely$$, FALSE, 0),
    ($$To route around structural LLM limitations (knowledge cutoff, unreliable calculation, no access outside context) for anything needing to be current, exact, or a real action$$, TRUE, 1),
    ($$To make the model's training process faster by offloading computation to external servers$$, FALSE, 2),
    ($$To let the model permanently update its own knowledge cutoff over time$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'tools-and-function-calling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'tools-and-function-calling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$In the tool-calling loop, who actually executes the real function -- calling an API, querying a database, running code?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$In the tool-calling loop, who actually executes the real function -- calling an API, querying a database, running code?$$,
           NULL, NULL,
           $$The lesson is explicit: step 4 of the loop is always carried out by the application hosting the model, in ordinary application code the model has no direct access to -- the model never executes anything itself, in any step of the loop.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'tools-and-function-calling'
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
    ($$The model's training infrastructure, triggered automatically by the tool call$$, FALSE, 0),
    ($$Whichever party -- model or application -- is faster to respond in that round$$, FALSE, 1),
    ($$The application hosting the model -- the model itself never executes anything in the loop$$, TRUE, 2),
    ($$The model itself, once it has decided a tool call is needed$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'tools-and-function-calling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'tools-and-function-calling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A developer names a tool "getData" with the description "gets data." According to this lesson, what is the most likely practical consequence?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A developer names a tool "getData" with the description "gets data." According to this lesson, what is the most likely practical consequence?$$,
           NULL, NULL,
           $$The lesson states description quality is one of the most important signals in whether a model picks the right tool -- a vague description leads to a model guessing wrong far more often than a specific one; it does not claim the model will always fail, always pick correctly, or that names/schema don't matter at all.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'tools-and-function-calling'
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
    ($$The model will always fail to call this tool under any circumstance$$, FALSE, 0),
    ($$The model will still always select this tool correctly, since tool names alone fully determine selection$$, FALSE, 1),
    ($$This has no practical effect, since the parameter schema alone determines correct tool selection$$, FALSE, 2),
    ($$The model is more likely to guess wrong about when or how to use this tool, since a vague description gives it little to go on$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'tools-and-function-calling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'tools-and-function-calling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A model calls a tool, receives a result, and then decides it needs to call a second tool using information from the first result, before finally answering. What does this reveal about the tool-calling loop?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A model calls a tool, receives a result, and then decides it needs to call a second tool using information from the first result, before finally answering. What does this reveal about the tool-calling loop?$$,
           NULL, NULL,
           $$The lesson explicitly says the loop can run more than once before a final answer, and every round trip consumes more of the model's context -- it isn't limited to exactly one call, doesn't run for free, and this doesn't automatically make the system an agent (a single conversation using tool calls, still driven by the ongoing exchange, is distinct from the self-directed agent loop covered later in this course).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'tools-and-function-calling'
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
    ($$The loop can run multiple rounds before a final answer, and each round trip consumes more of the model's context$$, TRUE, 0),
    ($$This is a bug -- the tool-calling loop is only ever supposed to run exactly once per conversation$$, FALSE, 1),
    ($$Additional tool calls in the same loop don't consume any extra context, since the model already saw the first result$$, FALSE, 2),
    ($$This alone means the system has become an agent, since it made more than one tool call$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'tools-and-function-calling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'tools-and-function-calling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A chatbot looks up today's weather when a user asks for it, using a single tool call within an otherwise ordinary conversation. According to this lesson's "Tool Use vs. Agents" section, is this an agent?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A chatbot looks up today's weather when a user asks for it, using a single tool call within an otherwise ordinary conversation. According to this lesson's "Tool Use vs. Agents" section, is this an agent?$$,
           NULL, NULL,
           $$The lesson explicitly says every agent relies on tool use, but the reverse isn't true -- using one tool once, inside an otherwise ordinary conversation, is not by itself an agent; an agent is a broader system that plans multiple steps and sustains the loop with some autonomy, which the "AI Agents" category covers separately.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'tools-and-function-calling'
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
    ($$No -- tool use and agents are entirely unrelated mechanisms with nothing in common$$, FALSE, 0),
    ($$No -- a single tool call inside an otherwise ordinary conversation is not by itself an agent$$, TRUE, 1),
    ($$Yes -- any use of a tool, even once, automatically qualifies a system as an agent$$, FALSE, 2),
    ($$Yes, but only because the tool call involves live, current data like weather$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'tools-and-function-calling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'tools-and-function-calling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about tool use / function calling, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about tool use / function calling, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (the model never executes anything itself, only requests it; a tool is defined by name, description, and parameter schema); the model does not decide to use a tool by directly inspecting the application's source code -- it decides based on the conversation text and tool descriptions it's given, and tool use is not, by itself, the same thing as an agent.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'tools-and-function-calling'
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
    ($$The model decides whether a tool is needed by directly reading the hosting application's source code$$, FALSE, 0),
    ($$Using a tool, by itself, is exactly the same thing as being an agent, with no further distinction$$, FALSE, 1),
    ($$The model never executes a tool itself -- it produces a structured request, and the hosting application executes the real function$$, TRUE, 2),
    ($$A tool is described to the model with three parts: a name, a description, and a parameter schema$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'tools-and-function-calling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
