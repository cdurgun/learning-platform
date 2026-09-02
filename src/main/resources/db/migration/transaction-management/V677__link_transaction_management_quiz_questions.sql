-- Promotion-style migration linking EN transaction-management quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'transaction-management')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which ACID property guarantees that a transaction's effects, once committed, survive even if the server crashes immediately afterward?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Which ACID property guarantees that a transaction's effects, once committed, survive even if the server crashes immediately afterward?$$,
           NULL, NULL,
           $$Durability: a committed transaction is permanent, even if the server crashes right afterward.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'transaction-management'
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
    ($$Durability$$, TRUE, 0),
    ($$Atomicity$$, FALSE, 1),
    ($$Consistency$$, FALSE, 2),
    ($$Isolation$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'transaction-management'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'transaction-management')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens when this method is called and runs to completion?$$
      AND code_snippet = $$class LedgerService {
    @Transactional
    void writeThenThrowChecked() throws IOException {
        ledger.add("entry-1");
        throw new IOException("simulated failure");
    }
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What happens when this method is called and runs to completion?$$,
           $$class LedgerService {
    @Transactional
    void writeThenThrowChecked() throws IOException {
        ledger.add("entry-1");
        throw new IOException("simulated failure");
    }
}$$, $$java$$,
           $$Spring's default rollback rule treats unchecked exceptions as rollback triggers; checked exceptions (like IOException) do NOT trigger a rollback by default -- the transaction commits despite the exception.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'transaction-management'
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
    ($$The application fails to start, since @Transactional methods can't declare checked exceptions.$$, FALSE, 0),
    ($$The transaction stays open indefinitely, waiting for a manual commit.$$, FALSE, 1),
    ($$The transaction commits -- "entry-1" becomes permanent, even though IOException was thrown.$$, TRUE, 2),
    ($$The transaction rolls back -- "entry-1" is never written, because any exception triggers a rollback by default.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'transaction-management'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'transaction-management')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why does `@Transactional` silently have no effect when a method is called via `this` from inside the same class (self-invocation)?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Why does `@Transactional` silently have no effect when a method is called via `this` from inside the same class (self-invocation)?$$,
           NULL, NULL,
           $$A proxy can only intercept calls that come through the bean from outside; a call via this goes directly to the real object, bypassing the proxy entirely.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'transaction-management'
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
    ($$A proxy can only intercept calls that come through the bean from outside; a call via this goes directly to the real object, bypassing the proxy entirely.$$, TRUE, 0),
    ($$Self-invocation always throws a compile error in Spring.$$, FALSE, 1),
    ($$@Transactional is disabled automatically whenever two methods are in the same class.$$, FALSE, 2),
    ($$The proxy intercepts the call correctly, but silently ignores @Transactional specifically for self-calls.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'transaction-management'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: MULTIPLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'transaction-management')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following correctly describe the difference between `PROPAGATION_REQUIRED` and `PROPAGATION_REQUIRES_NEW`? (Select all that apply)$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe the difference between `PROPAGATION_REQUIRED` and `PROPAGATION_REQUIRES_NEW`? (Select all that apply)$$,
           NULL, NULL,
           $$REQUIRED joins an already-active transaction if one exists. REQUIRES_NEW suspends any active transaction and starts a completely independent new one that commits or rolls back entirely on its own.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'transaction-management'
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
    ($$REQUIRED always starts a brand-new transaction, ignoring any active one.$$, FALSE, 0),
    ($$If the outer transaction rolls back, work done in a REQUIRES_NEW inner transaction is always rolled back with it.$$, FALSE, 1),
    ($$REQUIRED joins an already-active transaction if one exists, rather than starting a second one.$$, TRUE, 2),
    ($$REQUIRES_NEW suspends any active transaction and starts a completely independent new one that commits or rolls back entirely on its own.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'transaction-management'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'transaction-management')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does `@Transactional(readOnly = true)` actually guarantee?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does `@Transactional(readOnly = true)` actually guarantee?$$,
           NULL, NULL,
           $$Nothing enforced -- it's a hint to Spring/JPA for performance optimization, not an actual restriction that prevents writes.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'transaction-management'
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
    ($$Nothing enforced -- it's a hint to Spring/JPA for performance optimization, not an actual restriction that prevents writes.$$, TRUE, 0),
    ($$It guarantees the method can never write to the database, throwing an exception on any write attempt.$$, FALSE, 1),
    ($$It automatically makes the transaction run on a read replica database.$$, FALSE, 2),
    ($$It disables the method's own @Transactional annotation entirely.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'transaction-management'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'transaction-management')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to this lesson, why is the service layer, not the controller, the widely accepted place to put `@Transactional`?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$According to this lesson, why is the service layer, not the controller, the widely accepted place to put `@Transactional`?$$,
           NULL, NULL,
           $$A single service method usually makes several repository calls that should be one unit, and putting it on the controller would unnecessarily widen the transaction to cover unrelated work like rendering a view.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'transaction-management'
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
    ($$The repository layer already handles all transaction boundaries, so the service layer's annotation is purely decorative.$$, FALSE, 0),
    ($$Putting @Transactional on the controller makes the transaction faster, not slower.$$, FALSE, 1),
    ($$A single service method usually makes several repository calls that should be one unit, and putting it on the controller would unnecessarily widen the transaction to cover unrelated work like rendering a view.$$, TRUE, 2),
    ($$Controllers can never be marked @Transactional at all -- it's a compile error.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'transaction-management'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: CODE_OUTPUT)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'transaction-management')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens when `createOrder(true)` is called?$$
      AND code_snippet = $$class OrderCreatedEvent { }

@Component
class ShippingNotifier {
    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    void onOrderCreated(OrderCreatedEvent event) {
        System.out.println("Shipping notification sent");
    }
}

class OrderService {
    @Transactional
    void createOrder(boolean simulateFailureAfterPublish) {
        eventPublisher.publishEvent(new OrderCreatedEvent());
        if (simulateFailureAfterPublish) {
            throw new RuntimeException("failure after publish");
        }
    }
}$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$What happens when `createOrder(true)` is called?$$,
           $$class OrderCreatedEvent { }

@Component
class ShippingNotifier {
    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    void onOrderCreated(OrderCreatedEvent event) {
        System.out.println("Shipping notification sent");
    }
}

class OrderService {
    @Transactional
    void createOrder(boolean simulateFailureAfterPublish) {
        eventPublisher.publishEvent(new OrderCreatedEvent());
        if (simulateFailureAfterPublish) {
            throw new RuntimeException("failure after publish");
        }
    }
}$$, $$java$$,
           $$createOrder(true) throws a RuntimeException, so the transaction rolls back. AFTER_COMMIT listeners only run if the transaction that published the event actually commits -- since it never commits here, the listener never runs, even though the event was published.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'transaction-management'
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
    ($$"Shipping notification sent" is never printed, because the transaction rolled back before committing.$$, TRUE, 0),
    ($$"Shipping notification sent" is printed, since the event was already published before the exception was thrown.$$, FALSE, 1),
    ($$The application fails to start, since @TransactionalEventListener requires @EnableTransactionManagement explicitly.$$, FALSE, 2),
    ($$"Shipping notification sent" is printed twice, once for the event and once for the rollback.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'transaction-management'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
