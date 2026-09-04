-- Promotion-style migration linking EN deep-learning quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.


-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'deep-learning')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does the word "deep" refer to in "Deep Learning"?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does the word "deep" refer to in "Deep Learning"?$$,
           NULL, NULL,
           $$"Deep" refers to the neural network architecture having many stacked hidden layers; it has nothing to do with the philosophical depth of output, training duration, or how much math knowledge a user needs.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'deep-learning'
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
    ($$The neural networks used have many stacked hidden layers$$, TRUE, 0),
    ($$The models produce deeply philosophical output$$, FALSE, 1),
    ($$The training process takes an extremely long time$$, FALSE, 2),
    ($$The models require deep knowledge of mathematics to use$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'deep-learning'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'deep-learning')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A node receives inputs x1=2 and x2=1, with weights w1=3 and w2=-1 (bias=0), and uses a ReLU activation function (ReLU(x) = max(0, x)). What is the node's output?$$
      AND code_snippet = $$weighted_sum = (x1 * w1) + (x2 * w2) + bias
             = (2 * 3) + (1 * -1) + 0
             = 6 - 1
             = 5
output = ReLU(weighted_sum)$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A node receives inputs x1=2 and x2=1, with weights w1=3 and w2=-1 (bias=0), and uses a ReLU activation function (ReLU(x) = max(0, x)). What is the node's output?$$,
           $$weighted_sum = (x1 * w1) + (x2 * w2) + bias
             = (2 * 3) + (1 * -1) + 0
             = 6 - 1
             = 5
output = ReLU(weighted_sum)$$, $$text$$,
           $$The weighted sum is (2*3)+(1*-1)+0 = 5; ReLU(5) = max(0, 5) = 5, since 5 is already positive it passes through unchanged -- the other options misapply ReLU or the arithmetic.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'deep-learning'
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
    ($$6, since ReLU rounds up to the nearest input value$$, FALSE, 0),
    ($$5, since ReLU passes through positive weighted sums unchanged$$, TRUE, 1),
    ($$0, because ReLU always outputs 0 for positive inputs$$, FALSE, 2),
    ($$-1, since the negative weight w2 dominates$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'deep-learning'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'deep-learning')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$During training, a neural network makes a prediction, compares it to the correct answer, and then adjusts its weights slightly to reduce future error. Which two mechanisms, working together, make this weight adjustment possible?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$During training, a neural network makes a prediction, compares it to the correct answer, and then adjusts its weights slightly to reduce future error. Which two mechanisms, working together, make this weight adjustment possible?$$,
           NULL, NULL,
           $$A loss function measures the error, backpropagation computes how each weight contributed to that error, and gradient descent uses that information to adjust weights and reduce error -- this is the mechanism pair; the other pairs name unrelated concepts (tokenization/attention belong to LLMs, overfitting/underfitting are ML evaluation issues, not training mechanisms).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'deep-learning'
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
    ($$Tokenization and attention$$, FALSE, 0),
    ($$Overfitting and underfitting$$, FALSE, 1),
    ($$Backpropagation and gradient descent$$, TRUE, 2),
    ($$Forward pass and inference$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'deep-learning'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'deep-learning')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which type of neural network is specifically well-suited to processing images, according to this lesson?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which type of neural network is specifically well-suited to processing images, according to this lesson?$$,
           NULL, NULL,
           $$The lesson specifically names CNN (Convolutional Neural Network) for images; RNN is described for sequential data instead, Transformer is discussed as the basis for text/LLMs via attention (not specifically for images), and "all types handle images equally well" contradicts the lesson's explicit type distinctions.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'deep-learning'
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
    ($$RNN (Recurrent Neural Network)$$, FALSE, 0),
    ($$Transformer only$$, FALSE, 1),
    ($$None -- all neural network types handle images equally well$$, FALSE, 2),
    ($$CNN (Convolutional Neural Network)$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'deep-learning'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'deep-learning')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$RNNs process sequences one step at a time, while Transformers can process an entire sequence in parallel using attention. What is the main practical consequence of this difference, according to this lesson?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$RNNs process sequences one step at a time, while Transformers can process an entire sequence in parallel using attention. What is the main practical consequence of this difference, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states Transformers are parallelizable (unlike step-by-step RNNs) and this is part of why they became the basis of virtually every modern LLM; RNN is described as superseded, not more accurate, and RNN's domain is sequential data, not images.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'deep-learning'
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
    ($$Transformers are more parallelizable, which is part of why they became the basis of virtually every modern LLM$$, TRUE, 0),
    ($$RNNs are always more accurate than Transformers regardless of task$$, FALSE, 1),
    ($$There is no meaningful practical difference between the two architectures$$, FALSE, 2),
    ($$RNNs are used exclusively for image processing$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'deep-learning'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'deep-learning')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to this lesson, what mainly explains why deep learning's major breakthroughs happened around 2012 rather than decades earlier, even though neural networks were already known?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$According to this lesson, what mainly explains why deep learning's major breakthroughs happened around 2012 rather than decades earlier, even though neural networks were already known?$$,
           NULL, NULL,
           $$The lesson attributes the ~2012 turning point to sufficiently large datasets and sufficiently powerful GPU compute both reaching necessary scale around the same time; neural networks predate 2012, no such research ban existed, and ReLU computability wasn't a historical barrier.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'deep-learning'
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
    ($$ReLU activation functions were mathematically impossible to compute before 2012$$, FALSE, 0),
    ($$Both sufficiently large datasets and sufficiently powerful GPU compute reached the scale needed at around the same time$$, TRUE, 1),
    ($$Neural networks were only invented in 2012$$, FALSE, 2),
    ($$Governments banned neural network research until 2012$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'deep-learning'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'deep-learning')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about deep learning and neural networks, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about deep learning and neural networks, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B match the lesson directly (node computation mechanics; Transformer/2017/attention as the basis of virtually every LLM); RNN is described as superseded, not as the current recommended state-of-the-art, and the progressive-abstraction idea (edge to concept across layers) is explicitly flagged in the lesson as intuitive, not a mathematically guaranteed property.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'deep-learning'
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
    ($$RNNs are the current state-of-the-art architecture recommended for all new sequential-data projects$$, FALSE, 0),
    ($$Deeper layers in a network are guaranteed, by mathematical proof, to always represent higher-level abstractions like "concept" versus "edge"$$, FALSE, 1),
    ($$A node's output is computed from a weighted sum of its inputs plus a bias, passed through an activation function$$, TRUE, 2),
    ($$The Transformer architecture, introduced in 2017 and based on attention, underlies virtually every modern LLM$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'deep-learning'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
