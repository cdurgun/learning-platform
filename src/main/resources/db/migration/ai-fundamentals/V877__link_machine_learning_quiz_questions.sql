-- Promotion-style migration linking EN machine-learning quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.


-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'machine-learning')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is the correct relationship between a "learning algorithm" and the resulting "model"?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What is the correct relationship between a "learning algorithm" and the resulting "model"?$$,
           NULL, NULL,
           $$The model (architecture + learned parameters) is produced BY a learning algorithm processing training data -- algorithm and model are not the same thing, the relationship isn't reversed, and a learning algorithm exists before/during training, not only after deployment.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'machine-learning'
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
    ($$The learning algorithm processes training data and produces the model (architecture + learned parameters) as its output$$, TRUE, 0),
    ($$They are exactly the same thing, just different names$$, FALSE, 1),
    ($$The model is used to create the learning algorithm$$, FALSE, 2),
    ($$A learning algorithm only exists after the model is deployed$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'machine-learning'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'machine-learning')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A team trains a model on historical data over several hours, then later uses the finished model to make predictions on new, live data in milliseconds. What are these two phases called?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$A team trains a model on historical data over several hours, then later uses the finished model to make predictions on new, live data in milliseconds. What are these two phases called?$$,
           NULL, NULL,
           $$Training is learning from data; inference is using a trained, frozen model to produce predictions on new input -- the other pairs name unrelated or different concepts entirely.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'machine-learning'
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
    ($$Supervised and unsupervised learning$$, FALSE, 0),
    ($$Training and inference$$, TRUE, 1),
    ($$Compilation and execution$$, FALSE, 2),
    ($$Validation and testing$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'machine-learning'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'machine-learning')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A dataset contains thousands of houses, each with features (square footage, location, number of rooms) AND a known sale price. A model is trained to predict price from these features. This is an example of:$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A dataset contains thousands of houses, each with features (square footage, location, number of rooms) AND a known sale price. A model is trained to predict price from these features. This is an example of:$$,
           NULL, NULL,
           $$Labeled data (features plus a known correct label, the sale price) is the defining trait of supervised learning; it isn't unsupervised (no labels are needed there), isn't reinforcement learning (no reward/trial-and-error signal is described), and isn't "inference" (that's a separate phase, not a learning type).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'machine-learning'
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
    ($$Reinforcement learning, since the model is rewarded for correct predictions$$, FALSE, 0),
    ($$Inference, since the model is being used to make predictions$$, FALSE, 1),
    ($$Supervised learning, since the training data includes labeled correct answers (the known sale prices)$$, TRUE, 2),
    ($$Unsupervised learning, since the model discovers price patterns on its own$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'machine-learning'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'machine-learning')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A retailer wants to group its customers into segments based on purchasing behavior, without having any predefined labels for what each segment should be. Which type of learning fits this task, and why?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A retailer wants to group its customers into segments based on purchasing behavior, without having any predefined labels for what each segment should be. Which type of learning fits this task, and why?$$,
           NULL, NULL,
           $$No labels are present, so the model must find structure in unlabeled data on its own -- the defining trait of unsupervised learning; it isn't supervised (there are no labels), isn't reinforcement learning (no reward/action loop is described), and isn't "inference" (a different concept, a phase not a learning type).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'machine-learning'
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
    ($$Supervised learning, because customers already have known correct segment labels$$, FALSE, 0),
    ($$Reinforcement learning, because the model receives a reward for each correct grouping$$, FALSE, 1),
    ($$Inference, because grouping happens after training$$, FALSE, 2),
    ($$Unsupervised learning, because the model finds structure/patterns in unlabeled data on its own$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'machine-learning'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'machine-learning')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A model achieves 99% accuracy on its training data but only 60% accuracy on new, unseen data. This is a classic sign of:$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A model achieves 99% accuracy on its training data but only 60% accuracy on new, unseen data. This is a classic sign of:$$,
           NULL, NULL,
           $$A large gap between training and unseen performance is the classic sign of overfitting (memorizing the training data's specifics instead of learning generalizable patterns); underfitting would instead show poor performance on both sets, this isn't "perfect training," and it isn't specific to reinforcement learning.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'machine-learning'
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
    ($$Overfitting -- the model memorized the training data's specifics instead of learning generalizable patterns$$, TRUE, 0),
    ($$Underfitting -- the model is too simple to capture the underlying pattern$$, FALSE, 1),
    ($$Perfect training -- the model has fully learned the task$$, FALSE, 2),
    ($$Reinforcement learning failure$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'machine-learning'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'machine-learning')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why do teams typically split data into three sets (training, validation, and test) instead of just two (training and test)?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Why do teams typically split data into three sets (training, validation, and test) instead of just two (training and test)?$$,
           NULL, NULL,
           $$The validation set supports iterative tuning/model selection during development, while the test set stays untouched until the final evaluation, giving an unbiased estimate of real-world performance; the other options are fabricated and don't match how the three sets are actually used.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'machine-learning'
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
    ($$The test set is only used during training, and validation is only used after deployment$$, FALSE, 0),
    ($$The validation set is used to tune the model during development without contaminating the final, untouched test set used for the true final evaluation$$, TRUE, 1),
    ($$Three sets are required by law in machine learning projects$$, FALSE, 2),
    ($$Having three sets makes training run faster$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'machine-learning'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'machine-learning')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are true about evaluating a machine learning model, according to this lesson? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about evaluating a machine learning model, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$A and C are correct per the lesson (training-set score isn't trustworthy evidence of real performance; underfitting hurts both training and unseen performance); reinforcement learning uses reward signals rather than a labeled dataset of correct answers like supervised learning does, and the three learning types suit different problem shapes rather than being universally interchangeable.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'machine-learning'
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
    ($$Reinforcement learning always requires a labeled dataset of correct answers, just like supervised learning$$, FALSE, 0),
    ($$The three types of learning (supervised, unsupervised, reinforcement) are always interchangeable for any given task$$, FALSE, 1),
    ($$A model's score on its own training set is not trustworthy evidence of how well it will perform on new data$$, TRUE, 2),
    ($$A model that underfits performs poorly on both training and unseen data because it's too simple to capture the pattern$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'machine-learning'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
