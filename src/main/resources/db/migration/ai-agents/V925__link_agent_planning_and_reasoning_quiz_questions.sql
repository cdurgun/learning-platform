-- Promotion-style migration linking EN agent-planning-and-reasoning quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.


-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'agent-planning-and-reasoning')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does the ReAct pattern do at each step, according to this lesson?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does the ReAct pattern do at each step, according to this lesson?$$,
           NULL, NULL,
           $$ReAct interleaves a visible reasoning step with each action -- before choosing a tool call, the model first produces a short piece of text explaining its reasoning, and only then emits the action; the next observation is fed back in, and the cycle repeats.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'agent-planning-and-reasoning'
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
    ($$It interleaves a visible reasoning step with each action -- the model explains its reasoning in text before emitting the action itself$$, TRUE, 0),
    ($$It produces a complete, multi-step plan before taking any action at all$$, FALSE, 1),
    ($$It critiques a completed output after the fact, before treating it as final$$, FALSE, 2),
    ($$It skips reasoning entirely and jumps straight to the final answer every time$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'agent-planning-and-reasoning'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'agent-planning-and-reasoning')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does plan-and-execute do differently from ReAct, according to this lesson?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does plan-and-execute do differently from ReAct, according to this lesson?$$,
           NULL, NULL,
           $$Plan-and-execute splits the loop into two distinct phases instead of interleaving them: first, given the goal, the model produces a multi-step plan up front, before taking any action; then an execution step works through that plan one step at a time.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'agent-planning-and-reasoning'
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
    ($$It never revises a plan under any circumstances, even if a step's result invalidates it$$, FALSE, 0),
    ($$It produces a full multi-step plan up front, before taking any action, then executes that plan step by step$$, TRUE, 1),
    ($$It interleaves a visible reasoning step with every single action, exactly the way ReAct does$$, FALSE, 2),
    ($$It critiques the agent's own output after it's already been produced$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'agent-planning-and-reasoning'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'agent-planning-and-reasoning')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does the reflection pattern add to an agent's loop, according to this lesson?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does the reflection pattern add to an agent's loop, according to this lesson?$$,
           NULL, NULL,
           $$Reflection adds a distinct step after an action (or a whole attempt) completes: the model is asked to critique its own output before treating it as final, and if the critique finds a problem, to revise and try again rather than stopping.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'agent-planning-and-reasoning'
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
    ($$A step that interleaves reasoning text with each individual action as it happens$$, FALSE, 0),
    ($$A step that guarantees the model's final answer is completely free of factual errors$$, FALSE, 1),
    ($$A distinct self-critique step after an action completes, revising the output if the critique finds a problem, rather than immediately treating it as final$$, TRUE, 2),
    ($$A step that produces the entire multi-step plan before any action is taken$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'agent-planning-and-reasoning'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'agent-planning-and-reasoning')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A goal decomposes cleanly into a known set of sub-tasks, and it matters that a human can review the full intended sequence before anything runs. According to "Choosing Among These Patterns," which pattern best suits this goal, and why?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A goal decomposes cleanly into a known set of sub-tasks, and it matters that a human can review the full intended sequence before anything runs. According to "Choosing Among These Patterns," which pattern best suits this goal, and why?$$,
           NULL, NULL,
           $$The lesson states plan-and-execute suits goals that decompose cleanly into a known set of sub-tasks, especially when showing the plan before running it adds value (for instance, for a human review step) -- ReAct instead suits goals where the right next step genuinely depends on what the previous step returned and can't be known up front.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'agent-planning-and-reasoning'
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
    ($$ReAct -- it suits goals that decompose cleanly into a known set of sub-tasks ahead of time$$, FALSE, 0),
    ($$Reflection -- it is the pattern specifically designed for producing a full plan before execution begins$$, FALSE, 1),
    ($$None of these patterns can be used when a human needs to review a plan before it runs$$, FALSE, 2),
    ($$Plan-and-execute -- it suits goals that decompose cleanly into known sub-tasks, especially when showing the plan before execution adds value$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'agent-planning-and-reasoning'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'agent-planning-and-reasoning')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to "Termination: Knowing When to Stop," which of the following is one of the three conditions that typically ends an agent's loop?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$According to "Termination: Knowing When to Stop," which of the following is one of the three conditions that typically ends an agent's loop?$$,
           NULL, NULL,
           $$The lesson names three conditions: the model itself decides the goal has been satisfied (normal case), an external limit (such as a maximum number of steps) is reached before that, or an unrecoverable error occurs that no further looping can fix.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'agent-planning-and-reasoning'
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
    ($$An external limit, such as a maximum number of steps, is reached before the model concludes the goal is satisfied$$, TRUE, 0),
    ($$The agent's tool list is programmatically reduced to zero tools mid-run$$, FALSE, 1),
    ($$The human operator manually restarts the entire application from scratch$$, FALSE, 2),
    ($$The model's context window is deliberately cleared after every single step$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'agent-planning-and-reasoning'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'agent-planning-and-reasoning')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Reflection is aimed at the same failure mode "Hallucination: Confident, Fluent, Wrong" described. According to this lesson, does adding a reflection step eliminate that risk entirely?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Reflection is aimed at the same failure mode "Hallucination: Confident, Fluent, Wrong" described. According to this lesson, does adding a reflection step eliminate that risk entirely?$$,
           NULL, NULL,
           $$The lesson explicitly says reflection doesn't eliminate that risk -- the same model doing the checking has the same limitations as the model that produced the answer, though a dedicated critique step still catches some classes of mistake that would otherwise go straight through unchecked.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'agent-planning-and-reasoning'
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
    ($$No -- reflection has no effect on hallucination risk at all, in any case$$, FALSE, 0),
    ($$No -- the same model doing the checking has the same limitations as the model that produced the answer, though it still catches some mistakes$$, TRUE, 1),
    ($$Yes -- reflection guarantees a completely hallucination-free final answer in every case$$, FALSE, 2),
    ($$Yes, but only for CODE_OUTPUT-style tasks, and never for text-based answers$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'agent-planning-and-reasoning'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'agent-planning-and-reasoning')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about agent planning and reasoning patterns, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about agent planning and reasoning patterns, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (these patterns aren't mutually exclusive and most real agents combine pieces of more than one, with reflection in particular usually being an addition rather than an alternative; and a decision function with no termination condition beyond the model's own judgment would loop forever, which is why a step-limit guardrail matters as a backstop); ReAct is explicitly described as replanning at every single step, which the lesson calls potentially less efficient than committing to a broader plan up front (not more efficient), and reflection is not framed as a replacement for ReAct or plan-and-execute.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'agent-planning-and-reasoning'
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
    ($$ReAct's step-by-step replanning at every step is described in this lesson as strictly more efficient than committing to a broader plan up front$$, FALSE, 0),
    ($$Reflection is meant to fully replace ReAct or plan-and-execute rather than being added on top of either$$, FALSE, 1),
    ($$ReAct, plan-and-execute, and reflection are not mutually exclusive -- most real agents combine pieces of more than one, with reflection usually being an addition$$, TRUE, 2),
    ($$A decision function with no termination condition beyond the model's own judgment would otherwise loop forever, which is why a step-limit guardrail matters as a backstop$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'agent-planning-and-reasoning'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
