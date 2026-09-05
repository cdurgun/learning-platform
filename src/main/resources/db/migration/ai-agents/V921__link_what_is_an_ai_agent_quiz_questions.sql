-- Promotion-style migration linking EN what-is-an-ai-agent quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.


-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-an-ai-agent')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to this lesson, what is an AI agent?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$According to this lesson, what is an AI agent?$$,
           NULL, NULL,
           $$The lesson defines an AI agent as a system, built around one or more model calls plus tool use, that pursues a goal by repeatedly deciding what to do next, taking an action, observing the result, and deciding again, continuing until the goal is met or it decides to stop.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-an-ai-agent'
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
    ($$A system that pursues a goal by repeatedly deciding what to do next, taking an action, observing the result, and deciding again$$, TRUE, 0),
    ($$Any chatbot that can answer questions using a large language model$$, FALSE, 1),
    ($$A single tool call that returns a result to answer one question$$, FALSE, 2),
    ($$A dataset used to train a model on reinforcement learning tasks$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-an-ai-agent'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-an-ai-agent')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why do AI agents exist, according to this lesson's "Why Does It Exist?" section?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Why do AI agents exist, according to this lesson's "Why Does It Exist?" section?$$,
           NULL, NULL,
           $$The lesson states agents exist to handle problems where the right sequence of steps, and how many are needed, can only be determined along the way -- these don't fit the ordinary tool-calling loop where one request goes out, one result comes back, and a human is still driving each next step.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-an-ai-agent'
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
    ($$To guarantee that every goal is completed in exactly one step$$, FALSE, 0),
    ($$To handle problems where the necessary steps, and how many of them, can only be determined along the way as earlier steps run$$, TRUE, 1),
    ($$To make a single tool call run faster than it otherwise would$$, FALSE, 2),
    ($$To eliminate the need for tools to have a name, description, or parameter schema$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-an-ai-agent'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-an-ai-agent')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Put the three steps of the agent loop described in this lesson in the correct order.$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Put the three steps of the agent loop described in this lesson in the correct order.$$,
           NULL, NULL,
           $$The lesson names the loop Observe (look at the goal and everything that's happened so far), Decide (choose exactly one next step), Act (execute the chosen action, if any) -- in that order, repeating.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-an-ai-agent'
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
    ($$Act, then Observe, then Decide$$, FALSE, 0),
    ($$Decide, then Observe, then Act$$, FALSE, 1),
    ($$Observe, then Decide, then Act$$, TRUE, 2),
    ($$Decide, then Act, then Observe$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-an-ai-agent'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-an-ai-agent')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$An ordinary chatbot looks up today's weather when a user asks for it, then the conversation continues normally. According to this lesson, does this single lookup make the chatbot an agent?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$An ordinary chatbot looks up today's weather when a user asks for it, then the conversation continues normally. According to this lesson, does this single lookup make the chatbot an agent?$$,
           NULL, NULL,
           $$The lesson states using a tool once, inside a single request/response exchange, is not what makes something an agent -- an ordinary chatbot that looks up today's weather when asked does not become an agent by doing so; what makes a system an agent is the loop running under the system's own control across multiple steps.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-an-ai-agent'
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
    ($$Yes -- any tool call automatically qualifies a system as an agent, regardless of context$$, FALSE, 0),
    ($$Yes, but only because weather data is considered a live, current-information tool$$, FALSE, 1),
    ($$No, but only because weather lookups specifically are excluded from the agent definition$$, FALSE, 2),
    ($$No -- using a tool once inside a single request/response exchange doesn't make a system an agent$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-an-ai-agent'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-an-ai-agent')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to "The Autonomy Spectrum," is "agent" a single, fixed amount of independence, or something else?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$According to "The Autonomy Spectrum," is "agent" a single, fixed amount of independence, or something else?$$,
           NULL, NULL,
           $$The lesson explicitly says "agent" doesn't describe one fixed amount of independence -- it names a spectrum, from a system whose every decision is effectively scripted by a human in advance, to one running many decide-act cycles entirely on its own; most practical agents sit somewhere between these extremes.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-an-ai-agent'
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
    ($$It names a spectrum -- from fully human-scripted behavior to fully autonomous, multi-step behavior, with most practical agents in between$$, TRUE, 0),
    ($$It describes exactly one fixed, universal amount of independence that every agent must have$$, FALSE, 1),
    ($$It only applies to systems that never require any human involvement whatsoever$$, FALSE, 2),
    ($$It only applies to systems where a human approves literally every single decision$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-an-ai-agent'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-an-ai-agent')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$How does this lesson describe the relationship between the agent loop and "The Tool-Calling Loop" from "Tools and Function Calling"?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$How does this lesson describe the relationship between the agent loop and "The Tool-Calling Loop" from "Tools and Function Calling"?$$,
           NULL, NULL,
           $$The lesson explicitly calls the agent loop "a direct generalization of 'The Tool-Calling Loop'" -- instead of running once and stopping, the same observe-decide-act cycle repeats, under the system's own control, until the goal is met or a safety limit is reached.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-an-ai-agent'
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
    ($$The tool-calling loop is a more advanced, later addition built on top of the agent loop$$, FALSE, 0),
    ($$The agent loop is a direct generalization of the tool-calling loop -- the same cycle repeats under the system's own control instead of running once$$, TRUE, 1),
    ($$The two loops are completely unrelated mechanisms that happen to share some vocabulary$$, FALSE, 2),
    ($$The agent loop replaces the tool-calling loop entirely, making tool calls unnecessary for agents$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-an-ai-agent'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-an-ai-agent')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about AI agents, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about AI agents, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (three things distinguish the agent loop from ordinary tool use: the sequence isn't fixed in advance, the number of steps isn't known ahead of time, and each decision is informed by the previous step; and an agent's model-driven decision-making is still the same kind of model with the same reasoning limits covered in "LLM Capabilities and Limitations"); an agent's own decision step is still made by a model call, not literally hardcoded by a human in advance, and more autonomy is explicitly not framed as automatically better in this lesson.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-an-ai-agent'
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
    ($$Every step an agent takes is decided by a human in advance, in exactly the same way a single tool call is$$, FALSE, 0),
    ($$More autonomy is always better for an agent, since it means fewer steps are ever routed back to a human$$, FALSE, 1),
    ($$Compared to a single tool call, an agent's sequence of decisions isn't fixed in advance, its number of steps isn't known ahead of time, and each decision is informed by what happened in the previous step$$, TRUE, 2),
    ($$An agent's decision-making is still made by the same kind of model covered in "Reasoning Limits" -- planning a sequence of tool calls doesn't remove those underlying limits$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-an-ai-agent'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
