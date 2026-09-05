-- Promotion-style migration linking EN controlling-agent-behavior quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.


-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'controlling-agent-behavior')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to "Why Agents Need Guardrails," why is an unconstrained agent loop riskier than a single tool call?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$According to "Why Agents Need Guardrails," why is an unconstrained agent loop riskier than a single tool call?$$,
           NULL, NULL,
           $$The lesson states an agent loop can take many actions in sequence, chosen by the model rather than a human, and each of those actions might be a real tool call with a real side effect -- a wrong decision or a tool call aimed at the wrong argument doesn't get caught by a human before it runs, unlike a single tool call a human decided to send.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'controlling-agent-behavior'
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
    ($$Because the model, not a human, chooses a sequence of real actions with real side effects, so a wrong decision doesn't get caught by a human before it runs$$, TRUE, 0),
    ($$Because an agent loop is technically incapable of ever calling a real tool with a real side effect$$, FALSE, 1),
    ($$Because a single tool call is always slower to execute than a full agent loop$$, FALSE, 2),
    ($$Because guardrails are only needed once an agent has caused actual, confirmed financial damage$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'controlling-agent-behavior'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'controlling-agent-behavior')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is a step limit (iteration limit), according to this lesson?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What is a step limit (iteration limit), according to this lesson?$$,
           NULL, NULL,
           $$A step limit is a hard backstop: a maximum number of decide-act cycles the loop is allowed to run, enforced in code rather than left up to the model's own judgment -- once hit, the loop stops unconditionally, whatever it was doing, deliberately a blunt mechanism rather than a clever one.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'controlling-agent-behavior'
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
    ($$A limit on the total number of tokens a single tool result may contain$$, FALSE, 0),
    ($$A hard, code-enforced maximum number of decide-act cycles a loop is allowed to run, stopping it unconditionally once hit$$, TRUE, 1),
    ($$A soft suggestion the model can choose to ignore if it believes the goal isn't quite finished yet$$, FALSE, 2),
    ($$A limit on how many tools an MCP server is allowed to expose to any one client$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'controlling-agent-behavior'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'controlling-agent-behavior')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to "Human-in-the-Loop: Approval Before Risky Actions," does every action an agent might take need to go through human approval?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$According to "Human-in-the-Loop: Approval Before Risky Actions," does every action an agent might take need to go through human approval?$$,
           NULL, NULL,
           $$The lesson is explicit that this doesn't mean every action needs approval, which would defeat the point of having an agent at all -- it means deliberately marking the subset of actions where a wrong decision is expensive enough (costly, irreversible, or hard to verify) that a brief pause for approval is worth the lost speed.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'controlling-agent-behavior'
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
    ($$No -- human-in-the-loop means no action should ever require approval, under any circumstances$$, FALSE, 0),
    ($$Yes, but only for actions that involve calling get_capital_city or calculate_sum specifically$$, FALSE, 1),
    ($$No -- requiring approval for every action would defeat the point of having an agent; only costly, irreversible, or hard-to-verify actions should be routed through approval$$, TRUE, 2),
    ($$Yes -- every single action an agent takes must always be approved by a human before it runs, without exception$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'controlling-agent-behavior'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'controlling-agent-behavior')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$An agent is given a tool that can delete any record, even though its actual job only ever requires reading records. According to "Scoping Tool Access: The Principle of Least Privilege," what risk does this create?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$An agent is given a tool that can delete any record, even though its actual job only ever requires reading records. According to "Scoping Tool Access: The Principle of Least Privilege," what risk does this create?$$,
           NULL, NULL,
           $$The lesson states this creates a risk that has nothing to do with how good the agent's decision-making is -- it exists purely because the capability was available to misuse; narrower tool access doesn't make the agent's reasoning any better, but it shrinks the space of damage a bad decision can cause.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'controlling-agent-behavior'
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
    ($$No real risk, since giving broader tool access always makes an agent's underlying reasoning more reliable$$, FALSE, 0),
    ($$A risk that only ever materializes if the agent is also given human-in-the-loop approval for every action$$, FALSE, 1),
    ($$A risk that is entirely eliminated as soon as observability/logging is added to the loop$$, FALSE, 2),
    ($$A risk that has nothing to do with how good the agent's decision-making is -- it exists purely because the unnecessary delete capability was available to misuse$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'controlling-agent-behavior'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'controlling-agent-behavior')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$An agent produces a wrong final answer, and there is no record of what tools it called, with what arguments, or what results it got back. According to "Observability: Logging and Tracing an Agent's Decisions," what does this lesson say about diagnosing this situation?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$An agent produces a wrong final answer, and there is no record of what tools it called, with what arguments, or what results it got back. According to "Observability: Logging and Tracing an Agent's Decisions," what does this lesson say about diagnosing this situation?$$,
           NULL, NULL,
           $$The lesson states that without this logging, a wrong final answer is nearly impossible to debug -- there's no way to tell whether the model reasoned incorrectly, called the right tool with the wrong arguments, or got a correct result and misused it.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'controlling-agent-behavior'
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
    ($$It's nearly impossible to debug -- without a log of each step, there's no way to tell where the actual mistake happened$$, TRUE, 0),
    ($$It's trivial to debug, since a wrong final answer alone always makes the root cause obvious$$, FALSE, 1),
    ($$This can only be diagnosed by re-running the exact same goal with a completely different set of tools$$, FALSE, 2),
    ($$A step limit alone is always sufficient to explain why any wrong answer occurred$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'controlling-agent-behavior'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'controlling-agent-behavior')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$An agent is granted only read access to a customer database (least privilege), has a step limit of 10, and logs every decision -- but no action it takes ever requires human approval, including sending refund emails. According to this lesson, is this guardrail combination adequate for sending refund emails specifically?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$An agent is granted only read access to a customer database (least privilege), has a step limit of 10, and logs every decision -- but no action it takes ever requires human approval, including sending refund emails. According to this lesson, is this guardrail combination adequate for sending refund emails specifically?$$,
           NULL, NULL,
           $$The lesson treats these as distinct, complementary mechanisms addressing different risks -- least privilege, a step limit, and logging don't substitute for human-in-the-loop approval on a costly, hard-to-reverse action like sending a refund email; "Human-in-the-Loop" specifically calls out actions that are costly, irreversible, or hard to verify automatically as needing an approval step, regardless of the other guardrails already in place.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'controlling-agent-behavior'
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
    ($$No -- but only because read-only database access already makes sending an email impossible in the first place$$, FALSE, 0),
    ($$No -- least privilege, a step limit, and logging address different risks; a costly, hard-to-reverse action like sending a refund email still needs its own human-in-the-loop approval step$$, TRUE, 1),
    ($$Yes -- a step limit alone is always sufficient to make any action, including sending refund emails, safe to run without approval$$, FALSE, 2),
    ($$Yes -- logging every decision automatically prevents any costly action from having a real-world side effect$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'controlling-agent-behavior'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'controlling-agent-behavior')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about controlling agent behavior, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about controlling agent behavior, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (a step limit is deliberately blunt -- it doesn't try to be clever about whether the agent is "almost done," it just stops the loop unconditionally once hit; and the principle of least privilege bounds tool access to what a task genuinely needs, not broader access "just in case"); relying only on the model's own judgment to stop the loop is explicitly called a common mistake (a hard step limit is needed as a backstop), and observability specifically means logging every step of the loop, not merely the final answer.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'controlling-agent-behavior'
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
    ($$Relying only on the model's own judgment to stop the loop, with no hard step limit, is recommended as sufficient in this lesson$$, FALSE, 0),
    ($$Observability, in this lesson, means recording only the agent's final answer, not the individual steps that led to it$$, FALSE, 1),
    ($$A step limit is deliberately a blunt mechanism -- it doesn't try to judge whether the agent is "almost done," it just stops the loop unconditionally once the limit is hit$$, TRUE, 2),
    ($$The principle of least privilege means granting an agent's tools exactly what its task needs, not broader access "just in case it's needed"$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'controlling-agent-behavior'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
