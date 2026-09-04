-- Promotion-style migration linking EN prompting-and-prompt-engineering quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.


-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'prompting-and-prompt-engineering')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is a "prompt," precisely?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What is a "prompt," precisely?$$,
           NULL, NULL,
           $$This matches the lesson's definition -- a prompt is the part of context a person or system directly composes and controls; it isn't a separate filtering program, isn't fixed at pretraining, and isn't hidden internal reasoning the user never sees.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'prompting-and-prompt-engineering'
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
    ($$The text a person or system composes and provides to an LLM to produce a response -- the part of context that is directly controlled$$, TRUE, 0),
    ($$A separate program that runs alongside the LLM to filter its output$$, FALSE, 1),
    ($$A fixed, unchangeable string built into the model during pretraining$$, FALSE, 2),
    ($$The model's own internal reasoning that the user never sees$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'prompting-and-prompt-engineering'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'prompting-and-prompt-engineering')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$In a structured LLM conversation, what is the system prompt's role, compared to the user prompt?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$In a structured LLM conversation, what is the system prompt's role, compared to the user prompt?$$,
           NULL, NULL,
           $$This matches the lesson's role definitions directly -- the system prompt sets overall behavior for the whole conversation (typically set once by the application), while the user prompt is the specific request in a given turn; the roles aren't identical, aren't reversed, and both are part of the same context the model reads.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'prompting-and-prompt-engineering'
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
    ($$Only the system prompt is ever included in the model's context; the user prompt is processed separately$$, FALSE, 0),
    ($$The system prompt sets the model's overall behavior/persona for the whole conversation, typically set once by the application; the user prompt is the specific request in a given turn$$, TRUE, 1),
    ($$The system prompt and user prompt are identical in purpose, just different labels$$, FALSE, 2),
    ($$The user prompt sets behavior for the whole conversation, while the system prompt is the specific per-turn request$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'prompting-and-prompt-engineering'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'prompting-and-prompt-engineering')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A developer wants an LLM to return output in a very specific JSON structure that's hard to fully describe in words. According to this lesson, which approach tends to be more reliable, and why?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A developer wants an LLM to return output in a very specific JSON structure that's hard to fully describe in words. According to this lesson, which approach tends to be more reliable, and why?$$,
           NULL, NULL,
           $$This matches the lesson's explicit tip that showing examples (few-shot) tends to be more reliable than describing a format in words -- the other options contradict this guidance or overgeneralize which approach always wins.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'prompting-and-prompt-engineering'
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
    ($$Neither approach works reliably for structured output -- this is a fundamental limitation$$, FALSE, 0),
    ($$A zero-shot prompt is always more reliable than few-shot, regardless of the task$$, FALSE, 1),
    ($$A few-shot prompt showing two or three worked examples of the exact JSON structure, since demonstrating a format is often more reliable than describing it$$, TRUE, 2),
    ($$A zero-shot prompt with an extremely long paragraph of formatting instructions$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'prompting-and-prompt-engineering'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'prompting-and-prompt-engineering')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A prompt says only "Summarize this" and produces inconsistent results across runs. According to this lesson's guidance on writing effective prompts, what is the most likely fix?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A prompt says only "Summarize this" and produces inconsistent results across runs. According to this lesson's guidance on writing effective prompts, what is the most likely fix?$$,
           NULL, NULL,
           $$This matches the lesson's explicit example comparing a vague prompt to a specific one -- the fix is specificity (task, output format, focus), not switching models, removing instructions, or repeating the same vague wording.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'prompting-and-prompt-engineering'
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
    ($$Switch to a completely different, larger model, since the prompt itself is fine$$, FALSE, 0),
    ($$Remove all instructions entirely, since instructions tend to confuse the model$$, FALSE, 1),
    ($$Repeat the same vague instruction multiple times in the same prompt$$, FALSE, 2),
    ($$Be specific about the task and desired output -- for example, specifying an exact format and focus, like "Summarize this in exactly three bullet points, focused on financial figures"$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'prompting-and-prompt-engineering'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'prompting-and-prompt-engineering')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to this lesson, how should prompt engineering be approached, and what is it most similar to?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$According to this lesson, how should prompt engineering be approached, and what is it most similar to?$$,
           NULL, NULL,
           $$This matches the lesson's explicit iterative "write, test, observe, revise, repeat" framing, compared to debugging/iterative software development -- it isn't a one-time task, isn't purely random trial and error, and testing is an integral part of the process, not something to avoid.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'prompting-and-prompt-engineering'
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
    ($$As an iterative process similar to debugging or iterative software development -- write, test against realistic inputs, observe failures, and revise, then repeat$$, TRUE, 0),
    ($$As a one-time task -- write the prompt once, and it should work perfectly forever without revision$$, FALSE, 1),
    ($$As a purely random trial-and-error process with no useful pattern to track$$, FALSE, 2),
    ($$As a task that should be done only once, before any testing, since testing can bias the prompt$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'prompting-and-prompt-engineering'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'prompting-and-prompt-engineering')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A developer adds "think through this step by step, then give your final answer" to a prompt for a multi-step math word problem, and accuracy improves. What is the mechanism behind this technique?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A developer adds "think through this step by step, then give your final answer" to a prompt for a multi-step math word problem, and accuracy improves. What is the mechanism behind this technique?$$,
           NULL, NULL,
           $$This matches the lesson's explanation of chain-of-thought prompting as feeding the model's own step-by-step reasoning back as additional context via in-context learning -- no external tool is invoked, no retraining occurs, and the technique doesn't work by shortening responses.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'prompting-and-prompt-engineering'
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
    ($$It works by making the model's response shorter, which always improves accuracy$$, FALSE, 0),
    ($$It's called chain-of-thought prompting -- it gives the model more of its own reasoning as additional context to condition its final answer on, via in-context learning$$, TRUE, 1),
    ($$It gives the model access to an external calculator tool$$, FALSE, 2),
    ($$It permanently retrains the model to be better at math$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'prompting-and-prompt-engineering'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'prompting-and-prompt-engineering')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about prompting, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about prompting, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and C are directly stated in the lesson (role/persona prompting shifting style/focus without granting new knowledge; explicit constraints being more reliable than implicit ones); length alone doesn't determine quality (precision/relevance matter more, and extra tokens cost money/time), and breaking a task into explicit steps is recommended as MORE reliable, not less.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'prompting-and-prompt-engineering'
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
    ($$A longer, more elaborate prompt is always objectively better than a shorter, precise one$$, FALSE, 0),
    ($$Breaking a complex task into smaller, explicit steps inside a prompt tends to produce less reliable results than asking for everything at once$$, FALSE, 1),
    ($$Role/persona prompting (e.g., "as an experienced security engineer, review this code") shifts the style and focus of a response, but does not grant the model any new knowledge it didn't already have$$, TRUE, 2),
    ($$Stating constraints explicitly in a prompt (length limits, things to avoid) tends to be more reliable than leaving them implicit and hoping the model infers them$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'prompting-and-prompt-engineering'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
