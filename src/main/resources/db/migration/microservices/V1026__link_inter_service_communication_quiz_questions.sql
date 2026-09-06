-- Promotion-style migration linking EN inter-service-communication quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.

-- Question 1/7 (EN pair 1, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$inter-service-communication$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Why does order-service need to ask inventory-service for stock information instead of reading it from its own database?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Why does order-service need to ask inventory-service for stock information instead of reading it from its own database?$$,
           NULL, NULL,
           $$The lesson explains stock data belongs to inventory-service's own bounded context, under the Database per Service principle.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$inter-service-communication$$
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
    ($$Because order-service doesn't have a database of its own at all$$, FALSE, 0),
    ($$Because stock data belongs to inventory-service's own bounded context, under the "Database per Service" principle$$, TRUE, 1),
    ($$Because inventory-service always has faster read performance$$, FALSE, 2),
    ($$Because Spring Boot forbids two services from having the word "service" in their name$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$inter-service-communication$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (EN pair 2, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$inter-service-communication$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$What Spring Framework API does this lesson use for order-service's synchronous call to inventory-service?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What Spring Framework API does this lesson use for order-service's synchronous call to inventory-service?$$,
           NULL, NULL,
           $$The History section explains RestClient is the modern client already included in spring-boot-starter-web, replacing the older RestTemplate.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$inter-service-communication$$
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
    ($$RestTemplate, since it is the only client Spring has ever provided$$, FALSE, 0),
    ($$WebClient, requiring an extra spring-webflux dependency$$, FALSE, 1),
    ($$RestClient, the modern client already included in spring-boot-starter-web$$, TRUE, 2),
    ($$A raw java.net.Socket connection, configured manually$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$inter-service-communication$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (EN pair 3, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$inter-service-communication$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Why does StockClient deserialize inventory-service's JSON response into StockCheckResponse, instead of directly into InventoryItem?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Why does StockClient deserialize inventory-service's JSON response into StockCheckResponse, instead of directly into InventoryItem?$$,
           NULL, NULL,
           $$The lesson explains InventoryItem is inventory-service's internal model that can change independently; StockCheckResponse is order-service's own, decoupled contract.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$inter-service-communication$$
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
    ($$Because JSON deserialization technically cannot target a class named InventoryItem$$, FALSE, 0),
    ($$Because InventoryItem is inventory-service's internal model, which could change independently -- StockCheckResponse is order-service's own, decoupled contract$$, TRUE, 1),
    ($$Because InventoryItem doesn't implement Serializable$$, FALSE, 2),
    ($$Because StockCheckResponse and InventoryItem must always share the exact same package$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$inter-service-communication$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (EN pair 4, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$inter-service-communication$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Given StockClient.checkStock(...) below, what does order-service receive if inventory-service is UP but has never heard of the requested product (HTTP 404)?$$
      AND code_snippet = $$try {
    return restClient.get()
            .uri("/inventory/{productName}", productName)
            .retrieve()
            .body(StockCheckResponse.class);
} catch (HttpClientErrorException.NotFound e) {
    return new StockCheckResponse(productName, 0);
} catch (ResourceAccessException e) {
    throw new InventoryServiceUnavailableException("unreachable", e);
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given StockClient.checkStock(...) below, what does order-service receive if inventory-service is UP but has never heard of the requested product (HTTP 404)?$$,
           $$try {
    return restClient.get()
            .uri("/inventory/{productName}", productName)
            .retrieve()
            .body(StockCheckResponse.class);
} catch (HttpClientErrorException.NotFound e) {
    return new StockCheckResponse(productName, 0);
} catch (ResourceAccessException e) {
    throw new InventoryServiceUnavailableException("unreachable", e);
}$$, $$java$$,
           $$The lesson explains a 404 is a well-formed "no," not a failure -- a StockCheckResponse with quantityInStock = 0 is returned instead of throwing.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$inter-service-communication$$
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
    ($$An InventoryServiceUnavailableException is thrown$$, FALSE, 0),
    ($$A StockCheckResponse with quantityInStock = 0 is returned, no exception propagates$$, TRUE, 1),
    ($$The method blocks until inventory-service is restarted$$, FALSE, 2),
    ($$A raw HttpClientErrorException.NotFound propagates to OrderController$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$inter-service-communication$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (EN pair 5, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$inter-service-communication$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Same StockClient.checkStock(...) as below -- this time, inventory-service's process has crashed entirely and the connection times out. What is thrown to OrderService's caller?$$
      AND code_snippet = $$try {
    return restClient.get()
            .uri("/inventory/{productName}", productName)
            .retrieve()
            .body(StockCheckResponse.class);
} catch (HttpClientErrorException.NotFound e) {
    return new StockCheckResponse(productName, 0);
} catch (ResourceAccessException e) {
    throw new InventoryServiceUnavailableException("unreachable", e);
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Same StockClient.checkStock(...) as below -- this time, inventory-service's process has crashed entirely and the connection times out. What is thrown to OrderService's caller?$$,
           $$try {
    return restClient.get()
            .uri("/inventory/{productName}", productName)
            .retrieve()
            .body(StockCheckResponse.class);
} catch (HttpClientErrorException.NotFound e) {
    return new StockCheckResponse(productName, 0);
} catch (ResourceAccessException e) {
    throw new InventoryServiceUnavailableException("unreachable", e);
}$$, $$java$$,
           $$The lesson explains a connection failure raises ResourceAccessException, which StockClient translates into its own InventoryServiceUnavailableException, wrapping the original.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$inter-service-communication$$
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
    ($$HttpClientErrorException.NotFound$$, FALSE, 0),
    ($$A StockCheckResponse with quantityInStock = 0, silently$$, FALSE, 1),
    ($$InventoryServiceUnavailableException, wrapping the original ResourceAccessException$$, TRUE, 2),
    ($$Nothing -- the method returns null$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$inter-service-communication$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (EN pair 6, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$inter-service-communication$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Per "Synchronous vs. Asynchronous: What Does This Lesson Cover?", which side of the CAP theorem does this lesson's design choose by making the stock check synchronous and blocking?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Per "Synchronous vs. Asynchronous: What Does This Lesson Cover?", which side of the CAP theorem does this lesson's design choose by making the stock check synchronous and blocking?$$,
           NULL, NULL,
           $$The lesson states order-service never creates an order without being sure about stock, choosing Consistency over Availability.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$inter-service-communication$$
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
    ($$Partition Tolerance, by refusing to run when the network is down$$, FALSE, 0),
    ($$Consistency -- order-service never creates an order without being sure about stock, even if that means waiting or failing$$, TRUE, 1),
    ($$Availability, since the order is always created regardless of the stock check's outcome$$, FALSE, 2),
    ($$Neither -- CAP theorem only applies to databases, not service calls$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$inter-service-communication$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (EN pair 7, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$inter-service-communication$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are presented in this lesson as genuine mistakes when calling another service synchronously? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are presented in this lesson as genuine mistakes when calling another service synchronously? (Select all that apply)$$,
           NULL, NULL,
           $$The lesson's Common Mistakes list hardcoding the address and skipping try/catch as mistakes; hiding the call behind a client class and reading the URL via @Value are the recommended best practices instead.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$inter-service-communication$$
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
    ($$Hardcoding inventory-service's address directly inside order-service's code$$, TRUE, 0),
    ($$Hiding the call behind a dedicated client class like StockClient$$, FALSE, 1),
    ($$Leaving a synchronous service call with no try/catch at all$$, TRUE, 2),
    ($$Reading the target service's base URL from application.yml via @Value$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$inter-service-communication$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
