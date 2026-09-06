-- Promotion-style migration linking EN service-discovery-eureka quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 6 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.

-- Question 1/6 (EN pair 1, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$service-discovery-eureka$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$What core problem does Service Discovery solve, per this lesson?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What core problem does Service Discovery solve, per this lesson?$$,
           NULL, NULL,
           $$The lesson defines Service Discovery as letting services find each other by name through a central registry, instead of a fixed, hardcoded address.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$service-discovery-eureka$$
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
    ($$It replaces REST with a faster binary protocol$$, FALSE, 0),
    ($$It lets services find each other by name through a central registry, instead of a fixed, hardcoded address$$, TRUE, 1),
    ($$It automatically writes unit tests for every microservice$$, FALSE, 2),
    ($$It merges multiple databases into a single shared one$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$service-discovery-eureka$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (EN pair 2, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$service-discovery-eureka$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Once order-service becomes a Eureka client, what new role does its spring.application.name value take on?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Once order-service becomes a Eureka client, what new role does its spring.application.name value take on?$$,
           NULL, NULL,
           $$The lesson states spring.application.name is no longer just a log label -- it's now the actual key other services use to find it.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$service-discovery-eureka$$
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
    ($$None -- it remains purely a cosmetic log label$$, FALSE, 0),
    ($$It becomes the actual key other services use to find it in the registry$$, TRUE, 1),
    ($$It is used only to name the service's database schema$$, FALSE, 2),
    ($$It determines the service's HTTP port automatically$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$service-discovery-eureka$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (EN pair 3, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$service-discovery-eureka$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Per "Discovering Services with DiscoveryClient," what is DiscoveryClient's actual recommended use case?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Per "Discovering Services with DiscoveryClient," what is DiscoveryClient's actual recommended use case?$$,
           NULL, NULL,
           $$The tip callout states DiscoveryClient is not the right tool for everyday inter-service calls -- its real use case is diagnostics and understanding what the registry currently sees.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$service-discovery-eureka$$
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
    ($$Making every routine inter-service business call$$, FALSE, 0),
    ($$Diagnostics and understanding what the registry currently sees, not everyday calls$$, TRUE, 1),
    ($$Replacing @LoadBalanced RestClient entirely$$, FALSE, 2),
    ($$Registering a new service with the Eureka Server$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$service-discovery-eureka$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (EN pair 4, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$service-discovery-eureka$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Given this call from order-service, with a @LoadBalanced RestClient.Builder bean already configured, what does inventory-service get resolved to at runtime?$$
      AND code_snippet = $$restClient.get().uri("http://inventory-service/inventory/{name}", name)$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given this call from order-service, with a @LoadBalanced RestClient.Builder bean already configured, what does inventory-service get resolved to at runtime?$$,
           $$restClient.get().uri("http://inventory-service/inventory/{name}", name)$$, $$java$$,
           $$The lesson explains @LoadBalanced makes an address like this interpreted as a service name, resolved by Spring Cloud LoadBalancer to a real host:port among registered instances.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$service-discovery-eureka$$
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
    ($$A literal DNS hostname called inventory-service, resolved by the OS$$, FALSE, 0),
    ($$A real host:port picked from the currently registered instances in the Eureka registry$$, TRUE, 1),
    ($$Nothing -- this URI format is invalid and throws immediately$$, FALSE, 2),
    ($$localhost:8080, the default fallback for unresolved names$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$service-discovery-eureka$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (EN pair 5, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$service-discovery-eureka$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$A developer shuts down inventory-service locally, but a few minutes later the Eureka dashboard still shows it as "registered." Per "Heartbeats, Eviction, and Self-Preservation Mode," what's the most likely explanation?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$A developer shuts down inventory-service locally, but a few minutes later the Eureka dashboard still shows it as "registered." Per "Heartbeats, Eviction, and Self-Preservation Mode," what's the most likely explanation?$$,
           NULL, NULL,
           $$The warning callout explains this is not a bug -- the Eureka Server has likely entered self-preservation mode, deliberately delaying eviction.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$service-discovery-eureka$$
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
    ($$This is always a bug in the Eureka client library$$, FALSE, 0),
    ($$The Eureka Server has likely entered self-preservation mode, deliberately delaying eviction$$, TRUE, 1),
    ($$The dashboard is cached and requires a full server restart to refresh$$, FALSE, 2),
    ($$Eureka evicts instances instantly, so this can never actually happen$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$service-discovery-eureka$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (EN pair 6, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$service-discovery-eureka$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about Eureka's position in the CAP theorem, per this lesson, are correct? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about Eureka's position in the CAP theorem, per this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$The lesson states Eureka deliberately picks the AP side, and self-preservation mode is a direct consequence of that philosophy.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$service-discovery-eureka$$
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
    ($$Eureka deliberately picks the AP side -- it prefers always answering, even from a partially stale registry$$, TRUE, 0),
    ($$Eureka guarantees the registry is always perfectly up to date, with zero staleness$$, FALSE, 1),
    ($$Self-preservation mode is a direct consequence of Eureka's AP-leaning philosophy$$, TRUE, 2),
    ($$Eureka refuses to answer any query during a network partition$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$service-discovery-eureka$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
