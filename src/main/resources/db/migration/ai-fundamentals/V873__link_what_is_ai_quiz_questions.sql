-- Promotion-style migration linking EN what-is-ai quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.


-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-ai')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What fundamentally distinguishes AI software from traditional, explicitly-programmed software?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What fundamentally distinguishes AI software from traditional, explicitly-programmed software?$$,
           NULL, NULL,
           $$AI systems learn patterns from data (training) rather than executing only rules a programmer explicitly wrote for every case; speed, hardware, and "no code" claims are unrelated to the actual distinction.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-ai'
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
    ($$AI systems learn patterns from data rather than following only explicitly written rules$$, TRUE, 0),
    ($$AI software runs faster than traditional software in every case$$, FALSE, 1),
    ($$AI software never requires any code to be written$$, FALSE, 2),
    ($$Traditional software can only run on specialized hardware$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-ai'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-ai')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Nearly all AI systems in production today, including LLMs, fall into which category?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Nearly all AI systems in production today, including LLMs, fall into which category?$$,
           NULL, NULL,
           $$Narrow AI performs well at specific tasks; AGI (human-level general intelligence across any domain) does not exist in deployed systems today; passing the Turing Test in every conversation and general cross-domain reasoning are not what current systems achieve.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-ai'
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
    ($$Systems with human-level reasoning across every domain$$, FALSE, 0),
    ($$Narrow AI -- systems designed to perform a specific task or set of tasks well$$, TRUE, 1),
    ($$Artificial General Intelligence (AGI)$$, FALSE, 2),
    ($$Systems that pass the Turing Test in every conversation$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-ai'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-ai')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A team says "our product uses AI" and separately "our product uses machine learning." Based on how these terms relate, which statement is most accurate?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A team says "our product uses AI" and separately "our product uses machine learning." Based on how these terms relate, which statement is most accurate?$$,
           NULL, NULL,
           $$Machine Learning is one approach within the broader field of AI (AI contains ML, which contains Deep Learning, which contains Generative AI) -- the two terms are not unrelated, not reversed, and not simply identical.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-ai'
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
    ($$AI is a subset of Machine Learning$$, FALSE, 0),
    ($$The two terms always mean exactly the same technology with no distinction$$, FALSE, 1),
    ($$Machine Learning is a subset of AI -- one common approach to building AI, not a separate field$$, TRUE, 2),
    ($$AI and ML are unrelated, competing approaches$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-ai'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-ai')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What historically caused an "AI winter"?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What historically caused an "AI winter"?$$,
           NULL, NULL,
           $$AI winters were periods of declining funding/interest following unmet, inflated expectations; the other options are fabricated, or describe the opposite period -- the years after 2012 were an acceleration driven by deep learning, not a winter.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-ai'
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
    ($$A season during which AI conferences are traditionally held$$, FALSE, 0),
    ($$A government ban on all AI research$$, FALSE, 1),
    ($$The period after 2012 when deep learning breakthroughs accelerated AI progress$$, FALSE, 2),
    ($$A period when AI research funding and interest sharply declined after inflated expectations failed to materialize$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-ai'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-ai')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A spam filter that flags an email as spam based on patterns learned from millions of previously labeled emails, rather than a fixed list of banned words, is best described as:$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A spam filter that flags an email as spam based on patterns learned from millions of previously labeled emails, rather than a fixed list of banned words, is best described as:$$,
           NULL, NULL,
           $$Learning patterns from labeled data is AI; classification is a discriminative task (predicting a label for existing input), not a generative one, so producing a label for each email doesn't make it "generative AI," and learning from data clearly isn't "no AI at all."$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-ai'
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
    ($$An AI system, since it learned to recognize spam patterns from data rather than only following fixed rules$$, TRUE, 0),
    ($$A rule-based system with no learning involved$$, FALSE, 1),
    ($$Not AI, because it doesn't generate any new content$$, FALSE, 2),
    ($$Generative AI, because it produces an output for each email$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-ai'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-ai')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given the nested relationship AI contains ML, ML contains Deep Learning, and Deep Learning contains Generative AI, which statement correctly places a spam classifier trained with a neural network but NOT trained to generate new content?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given the nested relationship AI contains ML, ML contains Deep Learning, and Deep Learning contains Generative AI, which statement correctly places a spam classifier trained with a neural network but NOT trained to generate new content?$$,
           NULL, NULL,
           $$A neural-network-based classifier sits in the Deep Learning layer (which is inside ML, inside AI) but doesn't belong to Generative AI since it classifies rather than creates new content; the other options misplace the nesting relationship.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-ai'
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
    ($$It is ML but not AI$$, FALSE, 0),
    ($$It is Deep Learning (and therefore ML and AI), but not Generative AI, since it classifies rather than creates new content$$, TRUE, 1),
    ($$It is Generative AI but not Deep Learning$$, FALSE, 2),
    ($$It is AI but not ML, since neural networks aren't a machine learning technique$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-ai'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-ai')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about AI, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about AI, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are correct per the lesson (narrow AI dominance today, and the nested AI/ML/DL/GenAI relationship); the Turing Test is a thought experiment/informal benchmark, not a mathematical proof; AI as a field dates back to 1956 (the Dartmouth workshop), long before LLMs existed.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-ai'
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
    ($$The Turing Test is a formal, universally accepted mathematical proof that a system is intelligent$$, FALSE, 0),
    ($$AI has existed as a field only since the 2020s, starting with LLMs$$, FALSE, 1),
    ($$All production AI today is narrow AI; AGI does not currently exist in deployed systems$$, TRUE, 2),
    ($$Machine Learning, Deep Learning, and Generative AI are nested inside the broader field of AI, not separate unrelated fields$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-ai'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
