-- Promotion-style migration linking EN task-execution-and-scheduling quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'task-execution-and-scheduling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$In a ThreadPoolTaskExecutor configuration, what does corePoolSize control?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$In a ThreadPoolTaskExecutor configuration, what does corePoolSize control?$$,
           NULL, NULL,
           $$corePoolSize is how many threads stay alive even when idle.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'task-execution-and-scheduling'
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
    ($$The maximum number of tasks that can be queued$$, FALSE, 0),
    ($$How many threads stay alive even when idle$$, TRUE, 1),
    ($$The absolute ceiling the pool can grow to under load$$, FALSE, 2),
    ($$How often the pool checks for new work$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'task-execution-and-scheduling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'task-execution-and-scheduling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Without @EnableAsync on a @Configuration class, what happens to a method annotated @Async?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Without @EnableAsync on a @Configuration class, what happens to a method annotated @Async?$$,
           NULL, NULL,
           $$It is silently ignored -- the method just runs synchronously, as if the annotation weren't there.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'task-execution-and-scheduling'
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
    ($$It throws a RuntimeException the first time it's called$$, FALSE, 0),
    ($$It runs asynchronously anyway, using the default ForkJoinPool$$, FALSE, 1),
    ($$The application fails to start with a compile error$$, FALSE, 2),
    ($$It is silently ignored -- the method just runs synchronously, as if the annotation weren't there$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'task-execution-and-scheduling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'task-execution-and-scheduling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Does CompletableFuture.completedFuture(...) on the last line make anything asynchronous?$$
      AND code_snippet = $$@Async
public CompletableFuture<String> generateReport(String id) {
    // Slow work already happened synchronously on THIS thread before this line,
    // because @Async's proxy already dispatched the whole method body here.
    return CompletableFuture.completedFuture("Report " + id + " ready");
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Does CompletableFuture.completedFuture(...) on the last line make anything asynchronous?$$,
           $$@Async
public CompletableFuture<String> generateReport(String id) {
    // Slow work already happened synchronously on THIS thread before this line,
    // because @Async's proxy already dispatched the whole method body here.
    return CompletableFuture.completedFuture("Report " + id + " ready");
}$$, $$java$$,
           $$No -- it only wraps an already-known value; @Async already made the method body run on a separate thread before this line.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'task-execution-and-scheduling'
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
    ($$Yes -- it's what dispatches the work onto a separate thread$$, FALSE, 0),
    ($$No -- it only wraps an already-known value; @Async already made the method body run on a separate thread before this line$$, TRUE, 1),
    ($$Yes, but only for the first call to this method$$, FALSE, 2),
    ($$No, and this means @Async on this method has no effect at all$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'task-execution-and-scheduling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'task-execution-and-scheduling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$processOrder_broken(...) is called from another bean. What happens to sendPushNotification(...)?$$
      AND code_snippet = $$@Service
public class OrderService {
    public void processOrder_broken(Order order) {
        // ...
        this.sendPushNotification(order); // called via "this"
    }

    @Async
    public void sendPushNotification(Order order) {
        // slow notification work
    }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$processOrder_broken(...) is called from another bean. What happens to sendPushNotification(...)?$$,
           $$@Service
public class OrderService {
    public void processOrder_broken(Order order) {
        // ...
        this.sendPushNotification(order); // called via "this"
    }

    @Async
    public void sendPushNotification(Order order) {
        // slow notification work
    }
}$$, $$java$$,
           $$It runs synchronously -- calling through this bypasses the Spring proxy entirely, so @Async has no effect.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'task-execution-and-scheduling'
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
    ($$It throws an exception because self-invocation is forbidden by Spring$$, FALSE, 0),
    ($$It runs asynchronously, but only the first time the class is loaded$$, FALSE, 1),
    ($$It runs asynchronously as expected, since @Async is on the method itself$$, FALSE, 2),
    ($$It runs synchronously -- calling through this bypasses the Spring proxy entirely, so @Async has no effect$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'task-execution-and-scheduling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'task-execution-and-scheduling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following correctly describe the difference between fixedRate and fixedDelay? (Select all that apply)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe the difference between fixedRate and fixedDelay? (Select all that apply)$$,
           NULL, NULL,
           $$fixedRate measures from the previous run's start; fixedDelay measures from the previous run's finish, guaranteeing a real gap.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'task-execution-and-scheduling'
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
    ($$fixedRate measures the interval from the previous run's START$$, TRUE, 0),
    ($$fixedDelay measures the interval from the previous run's FINISH, guaranteeing a real gap$$, TRUE, 1),
    ($$fixedRate always guarantees a gap between runs, regardless of how long each run takes$$, FALSE, 2),
    ($$fixedDelay and fixedRate are simply two different names for the exact same behavior$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'task-execution-and-scheduling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'task-execution-and-scheduling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$By default, on how many threads does Spring run @Scheduled methods, and what's the consequence?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$By default, on how many threads does Spring run @Scheduled methods, and what's the consequence?$$,
           NULL, NULL,
           $$A single shared thread -- a slow scheduled task can delay every other scheduled task behind it.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'task-execution-and-scheduling'
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
    ($$A single shared thread -- a slow scheduled task can delay every other scheduled task behind it$$, TRUE, 0),
    ($$The same TaskExecutor configured for @Async, so both share load evenly$$, FALSE, 1),
    ($$One thread per @Scheduled method, so they never interfere with each other$$, FALSE, 2),
    ($$A thread pool sized automatically to the number of CPU cores$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'task-execution-and-scheduling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'task-execution-and-scheduling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following correctly distinguish @Async from @Scheduled? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly distinguish @Async from @Scheduled? (Select all that apply)$$,
           NULL, NULL,
           $$@Async runs in response to something, now; @Scheduled runs on its own on a timer. They use separate pools (TaskExecutor vs TaskScheduler) despite sharing conceptual thread-pool machinery.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'task-execution-and-scheduling'
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
    ($$@Async means "run this asynchronously, right now, in response to something"; @Scheduled means "run this at a specific time or interval, on its own"$$, TRUE, 0),
    ($$They share the same underlying thread-pool machinery conceptually, but use separate, independently configured pools (TaskExecutor vs TaskScheduler)$$, TRUE, 1),
    ($$@Async and @Scheduled are interchangeable and solve the exact same problem$$, FALSE, 2),
    ($$@Scheduled cannot return a CompletableFuture, while @Async always must$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'task-execution-and-scheduling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
