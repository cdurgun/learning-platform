-- Promotion-style migration linking EN event-driven-kafka quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 6 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.

-- Question 1/6 (EN pair 1, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$event-driven-kafka$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$What is the core difference between event-driven communication and the synchronous calls covered earlier in this course?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What is the core difference between event-driven communication and the synchronous calls covered earlier in this course?$$,
           NULL, NULL,
           $$The lesson explains the publisher never blocks waiting for a reaction, and often doesn't even know which services are listening.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$event-driven-kafka$$
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
    ($$Events always require more code to write than a synchronous REST call$$, FALSE, 0),
    ($$The publisher never blocks waiting for a reaction, and often doesn't even know which services are listening$$, TRUE, 1),
    ($$Events can only be used between services written in the same programming language$$, FALSE, 2),
    ($$Events guarantee an immediate response, exactly like a synchronous call$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$event-driven-kafka$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (EN pair 2, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$event-driven-kafka$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Per "Setting Up Kafka (Broker) and Topics," within what scope does Kafka actually guarantee message ordering?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Per "Setting Up Kafka (Broker) and Topics," within what scope does Kafka actually guarantee message ordering?$$,
           NULL, NULL,
           $$The lesson states Kafka guarantees ordering only within a single partition, not across the whole topic.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$event-driven-kafka$$
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
    ($$Across the entire topic, regardless of how many partitions it has$$, FALSE, 0),
    ($$Only within a single partition, not across the whole topic$$, TRUE, 1),
    ($$Only for messages published in the same calendar day$$, FALSE, 2),
    ($$Kafka never guarantees ordering under any circumstances$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$event-driven-kafka$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (EN pair 3, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$event-driven-kafka$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Given this listener, if Kafka redelivers the exact same OrderPlacedEvent (same orderId) a second time after a restart, what happens on the second delivery?$$
      AND code_snippet = $$private final Set<String> processedOrderIds = ConcurrentHashMap.newKeySet();

@KafkaListener(topics = "order-events", groupId = "inventory-service")
void onOrderPlaced(OrderPlacedEvent event) {
    if (!processedOrderIds.add(event.orderId())) {
        return;
    }
    // stockRepository.decrease(event.productName(), event.quantity());
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given this listener, if Kafka redelivers the exact same OrderPlacedEvent (same orderId) a second time after a restart, what happens on the second delivery?$$,
           $$private final Set<String> processedOrderIds = ConcurrentHashMap.newKeySet();

@KafkaListener(topics = "order-events", groupId = "inventory-service")
void onOrderPlaced(OrderPlacedEvent event) {
    if (!processedOrderIds.add(event.orderId())) {
        return;
    }
    // stockRepository.decrease(event.productName(), event.quantity());
}$$, $$java$$,
           $$The real InventoryEventListener.java shows processedOrderIds.add(...) returns false on a duplicate id, so the method returns early and stock is not decreased again.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$event-driven-kafka$$
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
    ($$Stock is decreased a second time, since processedOrderIds is cleared on every new message$$, FALSE, 0),
    ($$processedOrderIds.add(...) returns false, the method returns early, and stock is not decreased again$$, TRUE, 1),
    ($$The application throws a DuplicateEventException and stops consuming$$, FALSE, 2),
    ($$The event is silently dropped by Kafka itself before reaching this method$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$event-driven-kafka$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (EN pair 4, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$event-driven-kafka$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Per "Synchronous vs. Asynchronous: When to Use Which," which of these two questions genuinely needs a synchronous call rather than an event?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Per "Synchronous vs. Asynchronous: When to Use Which," which of these two questions genuinely needs a synchronous call rather than an event?$$,
           NULL, NULL,
           $$The lesson states a question needing an immediate answer -- like current stock level to show a customer -- needs a synchronous call, unlike a fact that doesn't need an immediate reaction.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$event-driven-kafka$$
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
    ($$"An order was placed, eventually update inventory records"$$, FALSE, 0),
    ($$"Is this product in stock right now, so I can show the customer an answer immediately?"$$, TRUE, 1),
    ($$"Notify whoever cares that something happened, eventually"$$, FALSE, 2),
    ($$Neither -- this lesson claims events should always replace synchronous calls entirely$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$event-driven-kafka$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (EN pair 5, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$event-driven-kafka$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Per "Serialization: Why JSON Over the Wire," why does this lesson choose JSON for OrderPlacedEvent, rather than a binary format like Avro?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Per "Serialization: Why JSON Over the Wire," why does this lesson choose JSON for OrderPlacedEvent, rather than a binary format like Avro?$$,
           NULL, NULL,
           $$The lesson explains JSON is human-readable, works across any language a future consumer might use, and needs no extra tooling to inspect.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$event-driven-kafka$$
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
    ($$Because Kafka technically cannot transmit binary data of any kind$$, FALSE, 0),
    ($$Because it's human-readable, works across any language a future consumer might use, and needs no extra tooling to inspect$$, TRUE, 1),
    ($$Because JSON messages are always smaller than Avro messages$$, FALSE, 2),
    ($$Because @KafkaListener only supports JSON and no other format whatsoever$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$event-driven-kafka$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (EN pair 6, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$event-driven-kafka$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are presented in this lesson as genuine mistakes in event-driven design? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are presented in this lesson as genuine mistakes in event-driven design? (Select all that apply)$$,
           NULL, NULL,
           $$The lesson's Common Mistakes list a non-idempotent consumer and assuming unlimited partition scaling as mistakes; keying by a meaningful id and treating event shape as a contract are the recommended best practices.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$event-driven-kafka$$
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
    ($$Writing a Kafka consumer that isn't idempotent$$, TRUE, 0),
    ($$Keying events by an id that determines what ordering actually matters for$$, FALSE, 1),
    ($$Assuming a single Kafka topic and partition scales indefinitely$$, TRUE, 2),
    ($$Treating an event's shape as a public contract other consumers depend on$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$event-driven-kafka$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
