-- Promotion-style migration linking EN spring-boot-microservice-basics quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.

-- Question 1/7 (EN pair 1, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$spring-boot-microservice-basics$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Why does order-service need its own application.yml, separate from learning-platform's?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Why does order-service need its own application.yml, separate from learning-platform's?$$,
           NULL, NULL,
           $$The lesson explains each independent service needs its own port, application name, and database connection to run alongside others on the same machine.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$spring-boot-microservice-basics$$
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
    ($$Because Spring Boot requires exactly one application.yml per Maven repository$$, FALSE, 0),
    ($$Because each independent service needs its own port, application name, and database connection to run alongside others on the same machine$$, TRUE, 1),
    ($$Because application.yml files cannot be reused across any two Java projects$$, FALSE, 2),
    ($$Because Thymeleaf templates require a dedicated configuration file per service$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$spring-boot-microservice-basics$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (EN pair 2, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$spring-boot-microservice-basics$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Per the "Config" principle from the Twelve-Factor App, how should order-service's database password be handled in application.yml?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Per the "Config" principle from the Twelve-Factor App, how should order-service's database password be handled in application.yml?$$,
           NULL, NULL,
           $$The lesson's warning callout states the password is deliberately read from an environment variable, never written as plain text.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$spring-boot-microservice-basics$$
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
    ($$Written as plain text since application.yml is not committed to git$$, FALSE, 0),
    ($$Read from an environment variable (${ORDERS_DB_PASSWORD}), never hardcoded$$, TRUE, 1),
    ($$Stored as a Base64-encoded string directly in the file$$, FALSE, 2),
    ($$Left blank, since Spring Boot generates one automatically$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$spring-boot-microservice-basics$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (EN pair 3, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$spring-boot-microservice-basics$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Given OrderService.create(...) below, what happens when it's called as orderService.create("Keyboard", 0)?$$
      AND code_snippet = $$Order create(String productName, int quantity) {
    if (quantity <= 0) {
        throw new IllegalArgumentException("quantity must be positive");
    }
    String id = UUID.randomUUID().toString();
    Order order = new Order(id, productName, quantity);
    orders.put(id, order);
    return order;
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given OrderService.create(...) below, what happens when it's called as orderService.create("Keyboard", 0)?$$,
           $$Order create(String productName, int quantity) {
    if (quantity <= 0) {
        throw new IllegalArgumentException("quantity must be positive");
    }
    String id = UUID.randomUUID().toString();
    Order order = new Order(id, productName, quantity);
    orders.put(id, order);
    return order;
}$$, $$java$$,
           $$The real OrderService.java code throws IllegalArgumentException when quantity <= 0, before any Order is constructed or stored.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$spring-boot-microservice-basics$$
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
    ($$The order is created with quantity = 0 and stored successfully$$, FALSE, 0),
    ($$OrderController silently ignores the call and returns null$$, FALSE, 1),
    ($$An IllegalArgumentException is thrown, and no order is stored$$, TRUE, 2),
    ($$The method blocks indefinitely waiting for a positive quantity$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$spring-boot-microservice-basics$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (EN pair 4, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$spring-boot-microservice-basics$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$order-service and inventory-service both use this exact server.port block, unmodified. What is the direct, practical consequence if inventory-service is deployed with this same value instead of 8082?$$
      AND code_snippet = $$server:
  port: 8081$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$order-service and inventory-service both use this exact server.port block, unmodified. What is the direct, practical consequence if inventory-service is deployed with this same value instead of 8082?$$,
           $$server:
  port: 8081$$, $$yaml$$,
           $$The lesson explains each service needs its own distinct port; using the same port for both means they cannot both bind it and run together on the same machine.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$spring-boot-microservice-basics$$
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
    ($$Spring Boot automatically reassigns one service to a free port$$, FALSE, 0),
    ($$Both services fail to start together on the same machine, since they'd both try to bind port 8081$$, TRUE, 1),
    ($$Requests are automatically load-balanced between the two services$$, FALSE, 2),
    ($$Nothing changes, since server.port only affects HTTPS traffic$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$spring-boot-microservice-basics$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (EN pair 5, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$spring-boot-microservice-basics$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Why does OrderController hand off the quantity <= 0 check to OrderService instead of validating it itself?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Why does OrderController hand off the quantity <= 0 check to OrderService instead of validating it itself?$$,
           NULL, NULL,
           $$The lesson states the decision of what counts as a valid order is a business rule only the service layer should own, following the Controller -> Service split.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$spring-boot-microservice-basics$$
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
    ($$Because @RestController classes are technically unable to run if statements$$, FALSE, 0),
    ($$Because the decision of "what counts as a valid order" is a business rule that only the service layer should own$$, TRUE, 1),
    ($$Because Spring Boot forbids validation logic in any class annotated with @RestController$$, FALSE, 2),
    ($$Because OrderController doesn't have access to the Order class$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$spring-boot-microservice-basics$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (EN pair 6, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$spring-boot-microservice-basics$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$What does GET /actuator/health returning {"status":"UP"} actually verify, per this lesson?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does GET /actuator/health returning {"status":"UP"} actually verify, per this lesson?$$,
           NULL, NULL,
           $$The lesson states Actuator's default health indicators also check the database connection, so UP confirms both that the service runs and that it can reach its database.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$spring-boot-microservice-basics$$
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
    ($$Only that the JVM process is still running, nothing about its dependencies$$, FALSE, 0),
    ($$That order-service is running and, since Actuator's default indicators also check it, that it can reach its database$$, TRUE, 1),
    ($$That every REST endpoint in order-service has been called at least once$$, FALSE, 2),
    ($$That order-service is registered with a service discovery tool$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$spring-boot-microservice-basics$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (EN pair 7, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$spring-boot-microservice-basics$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are presented in this lesson as genuine mistakes to avoid when configuring a microservice? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are presented in this lesson as genuine mistakes to avoid when configuring a microservice? (Select all that apply)$$,
           NULL, NULL,
           $$The lesson's "Common Mistakes" list plaintext secrets and forgetting spring.application.name as mistakes; giving each service its own application.yml and enabling health checks from day one are the recommended best practices instead.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$spring-boot-microservice-basics$$
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
    ($$Writing a database password as plain text directly in application.yml$$, TRUE, 0),
    ($$Giving every service its own, separate application.yml$$, FALSE, 1),
    ($$Naming spring.application.name randomly or inconsistently across services$$, TRUE, 2),
    ($$Turning on the /actuator/health endpoint from day one$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$spring-boot-microservice-basics$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
