-- Promotion-style migration linking EN llm-capabilities-and-limitations quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.


-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'llm-capabilities-and-limitations')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to this lesson, which of the following is a genuine strength of modern LLMs?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$According to this lesson, which of the following is a genuine strength of modern LLMs?$$,
           NULL, NULL,
           $$This matches the lesson's explicit list of genuine strengths (text transformation, drafting/explaining code, general-knowledge Q&A, instruction-following, few-shot pattern-matching); guaranteed factual correctness, live real-time event access, and guaranteed-correct arithmetic are explicitly named as things LLMs do NOT reliably do.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'llm-capabilities-and-limitations'
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
    ($$Transforming text -- summarizing, translating, and rewriting in a different tone -- among other things$$, TRUE, 0),
    ($$Guaranteeing factually correct answers on every question asked$$, FALSE, 1),
    ($$Having live, real-time access to events happening right now$$, FALSE, 2),
    ($$Performing precise, guaranteed-correct multi-step arithmetic every time$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'llm-capabilities-and-limitations'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'llm-capabilities-and-limitations')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why does hallucination happen in LLMs, according to this lesson?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Why does hallucination happen in LLMs, according to this lesson?$$,
           NULL, NULL,
           $$This matches the lesson's direct causal explanation: pretraining optimizes for a plausible next token, not a verified one, and there is no built-in fact-checker; the lesson explicitly states hallucination is structural and present in every LLM to some degree, not a rare bug, not adversarial-only, and not intentional deception (the model has no intent).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'llm-capabilities-and-limitations'
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
    ($$It happens because the model intentionally lies to the user$$, FALSE, 0),
    ($$Pretraining optimizes for predicting a plausible next token, not a verified one -- there is no built-in mechanism checking generated text against ground truth$$, TRUE, 1),
    ($$It's a rare software bug that only affects a small number of poorly-built models$$, FALSE, 2),
    ($$It only happens when a user deliberately tries to trick the model with adversarial prompts$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'llm-capabilities-and-limitations'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'llm-capabilities-and-limitations')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$An LLM with a knowledge cutoff of March 2024 is asked about an event that happened in June 2024. What is the most accurate description of what can happen?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$An LLM with a knowledge cutoff of March 2024 is asked about an event that happened in June 2024. What is the most accurate description of what can happen?$$,
           NULL, NULL,
           $$This matches the lesson exactly: knowledge cutoff and hallucination often show up together, and a model has no guaranteed reliable self-awareness of its own knowledge gap; the lesson doesn't describe a built-in real-time internet search or a self-updating cutoff.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'llm-capabilities-and-limitations'
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
    ($$The model automatically searches the internet in real time to find the answer$$, FALSE, 0),
    ($$The model's knowledge cutoff updates itself automatically the moment the event happens$$, FALSE, 1),
    ($$The model may either say it doesn't know, or -- worse -- hallucinate a plausible-sounding but fabricated answer, since it has no reliable built-in way to recognize the gap$$, TRUE, 2),
    ($$The model will always correctly say it has no information about the event$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'llm-capabilities-and-limitations'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'llm-capabilities-and-limitations')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$An LLM produces a confident, coherent-sounding step-by-step explanation for a multi-step logic puzzle, but the final answer is wrong. What does this lesson say about why this can happen?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$An LLM produces a confident, coherent-sounding step-by-step explanation for a multi-step logic puzzle, but the final answer is wrong. What does this lesson say about why this can happen?$$,
           NULL, NULL,
           $$This matches the lesson: reasoning-like output is generated text based on learned patterns, not a formally verified process like a calculator or compiler, so errors can occur even with confident, coherent explanations; the lesson explicitly says chain-of-thought techniques measurably help despite this (so they aren't useless), and no step-count threshold is mentioned.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'llm-capabilities-and-limitations'
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
    ($$This can never actually happen -- chain-of-thought reasoning is formally verified and guaranteed correct$$, FALSE, 0),
    ($$It only happens when the puzzle involves more than 100 steps$$, FALSE, 1),
    ($$It means chain-of-thought prompting is useless and should never be used$$, FALSE, 2),
    ($$The model generates text that resembles step-by-step reasoning, one token at a time, based on learned patterns -- not a formally verified logical process like a calculator or compiler runs$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'llm-capabilities-and-limitations'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'llm-capabilities-and-limitations')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why can an LLM reproduce biases or stereotypes in its output, even without anyone intending it to?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Why can an LLM reproduce biases or stereotypes in its output, even without anyone intending it to?$$,
           NULL, NULL,
           $$This matches the lesson directly: bias is a consequence of learning statistical patterns from an enormous sample of real human-written text, which itself reflects real biases; it isn't deliberate intent, isn't limited to small-dataset models (larger models still reflect their training data), and isn't a separate architectural bug.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'llm-capabilities-and-limitations'
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
    ($$The model learns statistical patterns from an enormous sample of real human-written text, which itself reflects real biases and imbalances present in its sources$$, TRUE, 0),
    ($$The model deliberately chooses to be biased to seem more humanlike$$, FALSE, 1),
    ($$Bias only appears in LLMs that were trained on a single, small dataset, never in large-scale models$$, FALSE, 2),
    ($$Bias is unrelated to training data and comes from a separate, unrelated bug in the model architecture$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'llm-capabilities-and-limitations'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'llm-capabilities-and-limitations')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$This lesson connects hallucination, knowledge cutoff, reasoning errors, and bias to one shared root cause rather than treating them as separate, unrelated bugs. What is that shared root cause?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$This lesson connects hallucination, knowledge cutoff, reasoning errors, and bias to one shared root cause rather than treating them as separate, unrelated bugs. What is that shared root cause?$$,
           NULL, NULL,
           $$This matches the lesson's explicit "Why These Limitations Exist" reframing; the lesson separately warns that scale doesn't fix every limitation, prompt quality alone doesn't explain structural issues like hallucination, and none of these limitations are described as fully solved.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'llm-capabilities-and-limitations'
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
    ($$All four only occur in older models and have been fully solved in every modern LLM$$, FALSE, 0),
    ($$An LLM predicts plausible text based on statistical patterns learned during pretraining, with no built-in fact-checker, formal logic engine, live data connection, or bias-correction process$$, TRUE, 1),
    ($$All four are caused by insufficient model size, and would disappear if the model were simply made larger$$, FALSE, 2),
    ($$All four are caused by users writing poorly-structured prompts$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'llm-capabilities-and-limitations'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'llm-capabilities-and-limitations')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about LLM limitations and verifying their output, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about LLM limitations and verifying their output, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (never trust fluent output automatically; later categories work around limitations rather than fully fixing the model); the lesson explicitly warns that a model is MORE likely to produce a plausible guess than to reliably flag its own gap, so unverified trust is not safe, and it explicitly reframes these limitations as sharing one common root cause, not unrelated separate bugs.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'llm-capabilities-and-limitations'
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
    ($$A model is very likely to reliably say "I don't know" whenever it lacks information, so unverified answers are generally safe to trust$$, FALSE, 0),
    ($$Hallucination, reasoning errors, and bias are three completely unrelated failure modes that must each be understood and fixed separately$$, FALSE, 1),
    ($$A fluent, confident-sounding answer should never be treated as automatically correct -- specific facts, dates, citations, and numbers should be verified$$, TRUE, 2),
    ($$Later categories in this course, like Tools & MCP and AI Agents, are designed to work around these limitations by supplying current information and verifying outputs, rather than trying to fully "fix" the underlying model$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'llm-capabilities-and-limitations'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
