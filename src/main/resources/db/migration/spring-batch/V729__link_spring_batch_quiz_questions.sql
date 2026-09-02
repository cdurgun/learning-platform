-- Promotion-style migration linking EN spring-batch quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-batch')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$In the Job/Step mental model, what role does an ItemProcessor play in a chunk-oriented Step?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$In the Job/Step mental model, what role does an ItemProcessor play in a chunk-oriented Step?$$,
           NULL, NULL,
           $$It optionally transforms or validates each item.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-batch'
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
    ($$It reads items one at a time from the data source$$, FALSE, 0),
    ($$It optionally transforms or validates each item$$, TRUE, 1),
    ($$It writes a whole group of items at once$$, FALSE, 2),
    ($$It manages the transaction boundary for the entire chunk$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-batch'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-batch')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A chunk-oriented step is configured with .chunk(100, transactionManager). Items 201-300 (the third chunk) fail during the write phase, after chunks 1-100 and 101-200 already committed successfully. What is the state of the database?$$
      AND code_snippet = $$.chunk(100, transactionManager)
.reader(orderItemReader())
.processor(orderItemProcessor())
.writer(orderItemWriter())$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A chunk-oriented step is configured with .chunk(100, transactionManager). Items 201-300 (the third chunk) fail during the write phase, after chunks 1-100 and 101-200 already committed successfully. What is the state of the database?$$,
           $$.chunk(100, transactionManager)
.reader(orderItemReader())
.processor(orderItemProcessor())
.writer(orderItemWriter())$$, $$java$$,
           $$Items 1-200 remain committed; only items 201-300's writes are rolled back, since each chunk is its own transaction boundary.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-batch'
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
    ($$Only the single item that caused the failure is rolled back, the rest of chunk 3 is written$$, FALSE, 0),
    ($$The entire job silently continues to the next chunk with no record of the failure$$, FALSE, 1),
    ($$All 300 items so far are rolled back, since the whole step is one transaction$$, FALSE, 2),
    ($$Items 1-200 remain committed; only items 201-300's writes are rolled back, since each chunk is its own transaction boundary$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-batch'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-batch')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$For an order with a negative amount, what happens to it?$$
      AND code_snippet = $$ItemProcessor<Order, Order> processor() {
    return order -> order.amount().signum() < 0 ? null : order;
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$For an order with a negative amount, what happens to it?$$,
           $$ItemProcessor<Order, Order> processor() {
    return order -> order.amount().signum() < 0 ? null : order;
}$$, $$java$$,
           $$It is silently filtered out -- never reaches the writer, and the step continues normally.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-batch'
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
    ($$It throws a ValidationException, failing the entire chunk$$, FALSE, 0),
    ($$It is written to the database with a negative amount unchanged$$, FALSE, 1),
    ($$It is silently filtered out -- never reaches the writer, and the step continues normally$$, TRUE, 2),
    ($$It is retried up to the configured retry limit before being skipped$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-batch'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: MULTIPLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-batch')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following correctly describe the relationship between JobParameters, JobInstance, and JobExecution? (Select all that apply)$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe the relationship between JobParameters, JobInstance, and JobExecution? (Select all that apply)$$,
           NULL, NULL,
           $$A Job + JobParameters identifies a JobInstance; a JobInstance can have multiple JobExecutions on retry; different parameter values mean different instances, not the same one.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-batch'
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
    ($$JobExecution and JobInstance are simply two different names for the exact same concept$$, FALSE, 0),
    ($$Two runs with different businessDate parameter values represent the same JobInstance$$, FALSE, 1),
    ($$A Job combined with a specific set of JobParameters identifies a JobInstance$$, TRUE, 2),
    ($$A single JobInstance can have multiple JobExecutions if it fails and is restarted$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-batch'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-batch')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is the JobRepository responsible for, and why does it matter for restartability?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$What is the JobRepository responsible for, and why does it matter for restartability?$$,
           NULL, NULL,
           $$It persists job/step execution status and metadata, which is what lets a restart avoid reprocessing already-succeeded work.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-batch'
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
    ($$It stores the CSV files a Job reads from, nothing more$$, FALSE, 0),
    ($$It persists job/step execution status and metadata, which is what lets a restart avoid reprocessing already-succeeded work$$, TRUE, 1),
    ($$It is simply an alias for the application's main database connection pool$$, FALSE, 2),
    ($$It only matters for jobs configured with @Scheduled, not manually triggered ones$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-batch'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-batch')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following correctly describe the difference between skip and retry in Spring Batch fault tolerance? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe the difference between skip and retry in Spring Batch fault tolerance? (Select all that apply)$$,
           NULL, NULL,
           $$skip tolerates a genuinely bad item up to a limit; retry retries a possibly-temporary failure up to a limit. Neither is on by default, and retry is not for permanently-bad items.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-batch'
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
    ($$skip and retry are enabled by default on every chunk-oriented step, with no configuration needed$$, FALSE, 0),
    ($$retry is meant for a genuinely bad item that will never succeed, no matter how many attempts$$, FALSE, 1),
    ($$skip tolerates a genuinely bad item, excluding it and continuing, up to a configured limit$$, TRUE, 2),
    ($$retry tolerates a possibly-temporary failure by retrying the SAME operation up to a limit before giving up$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-batch'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-batch')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to the lesson's "What Spring Batch Is NOT" section, what is the actual relationship between @Scheduled and Spring Batch?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$According to the lesson's "What Spring Batch Is NOT" section, what is the actual relationship between @Scheduled and Spring Batch?$$,
           NULL, NULL,
           $$@Scheduled decides WHEN to launch a job; Spring Batch decides HOW that job is structured, executed, and tracked -- they solve different problems.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-batch'
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
    ($$Spring Batch is simply another, more powerful scheduler that replaces @Scheduled$$, FALSE, 0),
    ($$@Scheduled decides WHEN to launch a job; Spring Batch decides HOW that job is structured, executed, and tracked -- they solve different problems$$, TRUE, 1),
    ($$They are mutually exclusive and can never be used in the same application$$, FALSE, 2),
    ($$Spring Batch automatically calls @Scheduled internally to trigger every Job$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-batch'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
