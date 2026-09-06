-- Promotion-style migration linking EN distributed-transactions quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 6 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.

-- Question 1/6 (EN pair 1, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$distributed-transactions$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Why can't order-service and inventory-service simply share one database transaction when placing an order?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Why can't order-service and inventory-service simply share one database transaction when placing an order?$$,
           NULL, NULL,
           $$The lesson explains database per service means each has its own, separate database, with no single transaction spanning both.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$distributed-transactions$$
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
    ($$Because Spring Boot technically forbids more than one transaction per application$$, FALSE, 0),
    ($$Because "database per service" means each has its own, separate database, with no single transaction spanning both$$, TRUE, 1),
    ($$Because transactions are only supported on Mondays through Fridays in production$$, FALSE, 2),
    ($$Because order-service doesn't use a relational database at all$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$distributed-transactions$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (EN pair 2, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$distributed-transactions$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Per "Two-Phase Commit: Why Microservices Usually Avoid It," what is the real cost that makes 2PC unpopular in microservices, even though it's historically "correct"?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Per "Two-Phase Commit: Why Microservices Usually Avoid It," what is the real cost that makes 2PC unpopular in microservices, even though it's historically "correct"?$$,
           NULL, NULL,
           $$The lesson explains every participant stays locked from the prepare phase until final commit, and can be left blocked indefinitely if the coordinator crashes.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$distributed-transactions$$
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
    ($$2PC cannot technically be implemented in any programming language released after 2010$$, FALSE, 0),
    ($$Every participant stays locked from the prepare phase until final commit, and can be left blocked indefinitely if the coordinator crashes$$, TRUE, 1),
    ($$2PC requires every service to be written in the exact same programming language$$, FALSE, 2),
    ($$2PC is incompatible with the HTTP protocol entirely$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$distributed-transactions$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (EN pair 3, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$distributed-transactions$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Per "Compensating Actions: Undoing What Already Happened," why is a compensating action NOT the same as a database rollback?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Per "Compensating Actions: Undoing What Already Happened," why is a compensating action NOT the same as a database rollback?$$,
           NULL, NULL,
           $$The lesson explains order-service's original transaction already committed successfully -- compensation is a new, separate local transaction that moves to a corrected state.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$distributed-transactions$$
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
    ($$Because compensating actions are always slower than a rollback$$, FALSE, 0),
    ($$Because order-service's original transaction already committed successfully -- compensation is a new, separate local transaction that moves to a corrected state$$, TRUE, 1),
    ($$Because rollbacks are only possible in NoSQL databases$$, FALSE, 2),
    ($$Because compensating actions require restarting the entire service$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$distributed-transactions$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (EN pair 4, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$distributed-transactions$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Given InventoryReservationListener's actual code below (with the real database call commented out), will StockReservationFailedEvent ever actually be published when this exact code runs?$$
      AND code_snippet = $$private boolean tryReserveStock(String productName, int quantity) {
    // return stockRepository.tryReserve(productName, quantity);
    return true;
}

void onOrderPlaced(OrderPlacedEvent event) {
    if (!processedOrderIds.add(event.orderId())) return;
    boolean reserved = tryReserveStock(event.productName(), event.quantity());
    if (!reserved) {
        kafkaTemplate.send(STOCK_RESERVATION_FAILED_TOPIC, event.orderId(), ...);
    }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Given InventoryReservationListener's actual code below (with the real database call commented out), will StockReservationFailedEvent ever actually be published when this exact code runs?$$,
           $$private boolean tryReserveStock(String productName, int quantity) {
    // return stockRepository.tryReserve(productName, quantity);
    return true;
}

void onOrderPlaced(OrderPlacedEvent event) {
    if (!processedOrderIds.add(event.orderId())) return;
    boolean reserved = tryReserveStock(event.productName(), event.quantity());
    if (!reserved) {
        kafkaTemplate.send(STOCK_RESERVATION_FAILED_TOPIC, event.orderId(), ...);
    }
}$$, $$java$$,
           $$The real InventoryReservationListener.java shows tryReserveStock is a stub hardcoded to return true, so reserved is always true and the if (!reserved) branch never executes.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$distributed-transactions$$
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
    ($$Yes, roughly half the time, at random$$, FALSE, 0),
    ($$No -- tryReserveStock is hardcoded to always return true, so reserved is always true and the if (!reserved) branch never executes$$, TRUE, 1),
    ($$Yes, but only on the very first call for each orderId$$, FALSE, 2),
    ($$Yes, every single time, since the real database call is commented out$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$distributed-transactions$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (EN pair 5, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$distributed-transactions$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Per "The Outbox Pattern: Not Losing an Event to a Crash," what real gap does the Outbox pattern close?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Per "The Outbox Pattern: Not Losing an Event to a Crash," what real gap does the Outbox pattern close?$$,
           NULL, NULL,
           $$The lesson explains the gap where order-service crashes between saving an order and publishing the event announcing it, so the event is lost even though the order exists.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$distributed-transactions$$
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
    ($$The gap between two services using different serialization formats$$, FALSE, 0),
    ($$The gap where order-service crashes between saving an order and publishing the event announcing it, so the event is lost even though the order exists$$, TRUE, 1),
    ($$The gap between Kafka and a relational database's SQL syntax$$, FALSE, 2),
    ($$The gap caused by Eureka's self-preservation mode delaying eviction$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$distributed-transactions$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (EN pair 6, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$distributed-transactions$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are presented in this lesson as genuine best practices for sagas? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are presented in this lesson as genuine best practices for sagas? (Select all that apply)$$,
           NULL, NULL,
           $$The lesson recommends choreography for short sagas and checking current state before compensating; reaching for 2PC by default and treating a saga as atomic from the caller's view are explicitly listed mistakes.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$distributed-transactions$$
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
    ($$Prefer choreography for short sagas (two or three steps), orchestration once a saga grows past that$$, TRUE, 0),
    ($$Reach for Two-Phase Commit as the default solution for any distributed transaction$$, FALSE, 1),
    ($$Check an entity's current state before applying a compensating action to it$$, TRUE, 2),
    ($$Treat a saga as a single atomic operation from the caller's perspective$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$distributed-transactions$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
