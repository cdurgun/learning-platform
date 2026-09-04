-- Promotion-style migration linking EN generative-ai quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.


-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generative-ai')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Is Generative AI a separate technique from deep learning, or an application of it?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Is Generative AI a separate technique from deep learning, or an application of it?$$,
           NULL, NULL,
           $$The lesson explicitly states Generative AI is an application of existing techniques (like deep learning), specifically trained to create new content -- not a separate technique; it builds on deep learning/neural networks, isn't defined purely by unsupervised learning, and isn't older than machine learning.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generative-ai'
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
    ($$An application of existing techniques (like deep learning), specifically trained to create new content$$, TRUE, 0),
    ($$A completely separate technique with its own unrelated architecture$$, FALSE, 1),
    ($$A subset of unsupervised learning that has nothing to do with neural networks$$, FALSE, 2),
    ($$An older technique that predates machine learning entirely$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generative-ai'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generative-ai')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Model A takes an email and outputs a label: "spam" or "not spam." Model B takes a topic and outputs a brand-new paragraph of text about it. Which is generative, and why?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Model A takes an email and outputs a label: "spam" or "not spam." Model B takes a topic and outputs a brand-new paragraph of text about it. Which is generative, and why?$$,
           NULL, NULL,
           $$Generative models create new content (Model B); discriminative models classify/predict a category for existing input (Model A) -- merely "producing output" doesn't make something generative, and classification and text generation are explicitly distinct tasks.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generative-ai'
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
    ($$Neither, since classification and text generation are the same task$$, FALSE, 0),
    ($$Model B, because it creates new content rather than classifying/predicting a category for existing input$$, TRUE, 1),
    ($$Model A, because it makes a decision$$, FALSE, 2),
    ($$Both, since both models process input and produce output$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generative-ai'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generative-ai')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$At a mechanical level, how does a generative text model produce a multi-sentence response?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$At a mechanical level, how does a generative text model produce a multi-sentence response?$$,
           NULL, NULL,
           $$Text generation works by repeatedly predicting the single most plausible next token given everything generated so far, one token at a time -- it is not lookup/retrieval from a database, not simultaneous whole-response generation, and not a fixed summarize-then-expand procedure.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generative-ai'
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
    ($$It generates the entire response simultaneously in one indivisible step, with no notion of order$$, FALSE, 0),
    ($$It generates a summary first, then expands it into a paragraph, always in that fixed order$$, FALSE, 1),
    ($$It repeatedly predicts the single most plausible next token given everything generated so far, one token at a time$$, TRUE, 2),
    ($$It retrieves a pre-written matching response from a large lookup database$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generative-ai'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generative-ai')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$How do diffusion models, a common approach for image generation, typically work?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$How do diffusion models, a common approach for image generation, typically work?$$,
           NULL, NULL,
           $$Diffusion models start from random noise and progressively refine it, step by step, into a coherent image -- they don't copy existing training images, don't use a fixed left-to-right pixel scan, and don't require a human sketch first.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generative-ai'
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
    ($$They copy an existing image from training data and apply a filter to it$$, FALSE, 0),
    ($$They generate images by predicting the next pixel in a fixed left-to-right scan order, one pixel at a time forever$$, FALSE, 1),
    ($$They require a human to manually sketch the outline first$$, FALSE, 2),
    ($$They start from random noise and progressively refine it, step by step, into a coherent image$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generative-ai'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generative-ai')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A traditional AI system predicts whether a loan applicant will default (yes/no). A generative AI system, given the same applicant's data, writes a full paragraph explaining the credit decision. What is the key difference between what each system is trained to do?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A traditional AI system predicts whether a loan applicant will default (yes/no). A generative AI system, given the same applicant's data, writes a full paragraph explaining the credit decision. What is the key difference between what each system is trained to do?$$,
           NULL, NULL,
           $$The core distinction is discriminative/predictive training (classify a fixed outcome from existing patterns) versus generative/creative training (create new, original content); accuracy comparisons and "which uses neural networks" claims are unsupported generalizations the lesson does not make.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generative-ai'
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
    ($$The traditional system is trained to predict/classify a fixed outcome from existing patterns; the generative system is trained to create new, original content$$, TRUE, 0),
    ($$There is no real difference -- both are just "AI" doing the same kind of job$$, FALSE, 1),
    ($$The generative system is strictly more accurate at every task than the traditional system$$, FALSE, 2),
    ($$Traditional AI systems always use neural networks, while generative AI systems never do$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generative-ai'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generative-ai')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following is explicitly true about Generative AI, according to this lesson's "What Generative AI Is Not" section?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following is explicitly true about Generative AI, according to this lesson's "What Generative AI Is Not" section?$$,
           NULL, NULL,
           $$The lesson explicitly separates "generative" from "agentic" and from "AGI," and states fluent output is not automatically correct (this is where hallucination is introduced) -- the other options directly contradict what the lesson states.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generative-ai'
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
    ($$Generative AI systems are incapable of producing incorrect information$$, FALSE, 0),
    ($$Generative AI is not automatically agentic -- being able to generate content doesn't mean a system can independently take actions in the world$$, TRUE, 1),
    ($$Generative AI is a form of AGI, since it can produce humanlike text$$, FALSE, 2),
    ($$Fluent output from a generative model always guarantees factual correctness$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generative-ai'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generative-ai')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about Generative AI, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about Generative AI, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (fluency vs. correctness as separate properties; the branching across text/image/audio/video/code); LLMs are only one branch (text) of generative AI, not the whole category, and discriminative and generative models have explicitly different training objectives (classify/predict vs. create).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generative-ai'
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
    ($$Every generative AI model is, by definition, also an LLM$$, FALSE, 0),
    ($$A discriminative model and a generative model are trained toward the exact same objective$$, FALSE, 1),
    ($$Fluency and factual correctness are separate properties -- a fluent response is not automatically a correct one$$, TRUE, 2),
    ($$Generative AI branches across multiple content types, including text, image, audio, video, and code$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generative-ai'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
