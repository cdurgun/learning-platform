-- Promotion-style migration linking EN deployment quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 5 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.

-- Question 1/5 (EN pair 1, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$deployment$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Why does every localhost:8761, localhost:8888 this category's earlier lessons hardcoded break once a service moves into its own container?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Why does every localhost:8761, localhost:8888 this category's earlier lessons hardcoded break once a service moves into its own container?$$,
           NULL, NULL,
           $$The lesson explains localhost inside a container refers to that container itself, not to another service's separate container.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$deployment$$
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
    ($$Because Docker technically forbids the word "localhost" in any configuration file$$, FALSE, 0),
    ($$Because "localhost" inside a container refers to that container itself, not to another service's separate container$$, TRUE, 1),
    ($$Because containers cannot use port numbers above 8000$$, FALSE, 2),
    ($$Because Docker automatically renames every service to "localhost" on startup$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$deployment$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/5 (EN pair 2, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$deployment$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Per "A Multi-Stage Build: Keeping the Image Small," what does order-service's final Docker image NOT include, thanks to the multi-stage build?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Per "A Multi-Stage Build: Keeping the Image Small," what does order-service's final Docker image NOT include, thanks to the multi-stage build?$$,
           NULL, NULL,
           $$The lesson explains the final image never includes Maven, the JDK's compiler, or order-service's own source code -- only the already-built jar and a JRE.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$deployment$$
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
    ($$The already-built .jar file itself$$, FALSE, 0),
    ($$A minimal JRE needed to run the application$$, FALSE, 1),
    ($$The full JDK, Maven, and order-service's own source code$$, TRUE, 2),
    ($$Any runtime configuration whatsoever$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$deployment$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/5 (EN pair 3, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$deployment$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Given this docker-compose.yml fragment, what does condition: service_started for kafka actually guarantee, according to this lesson?$$
      AND code_snippet = $$order-service:
  build: ./order-service
  depends_on:
    eureka-server:
      condition: service_healthy
    kafka:
      condition: service_started$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given this docker-compose.yml fragment, what does condition: service_started for kafka actually guarantee, according to this lesson?$$,
           $$order-service:
  build: ./order-service
  depends_on:
    eureka-server:
      condition: service_healthy
    kafka:
      condition: service_started$$, $$yaml$$,
           $$The lesson's warning explains service_started only confirms the container process began running, not that Kafka is actually ready to accept connections.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$deployment$$
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
    ($$That Kafka has passed its own /actuator/health check$$, FALSE, 0),
    ($$Only that the Kafka container's process has begun running -- not that Kafka is actually ready to accept connections$$, TRUE, 1),
    ($$That Kafka has finished creating every topic order-service will ever need$$, FALSE, 2),
    ($$Nothing -- service_started and service_healthy behave identically$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$deployment$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/5 (EN pair 4, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$deployment$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Per "Beyond Local: A Brief, Honest Look at Kubernetes," what does moving from Docker Compose to Kubernetes actually change about order-service's container image?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Per "Beyond Local: A Brief, Honest Look at Kubernetes," what does moving from Docker Compose to Kubernetes actually change about order-service's container image?$$,
           NULL, NULL,
           $$The lesson's tip explains Kubernetes runs the exact same image Docker Compose does -- it changes how many instances run and how they're orchestrated, not how the image is built.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$deployment$$
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
    ($$The image itself has to be completely rebuilt with Kubernetes-specific tooling$$, FALSE, 0),
    ($$Nothing -- Kubernetes runs the exact same image Docker Compose does; it changes how many instances run and how they're orchestrated, not how the image is built$$, TRUE, 1),
    ($$The image must be converted from a .jar-based format to a .war-based one$$, FALSE, 2),
    ($$Kubernetes requires removing the multi-stage build entirely$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$deployment$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/5 (EN pair 5, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$deployment$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are presented in this lesson as genuine mistakes when deploying a microservices system? (Select all that apply)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are presented in this lesson as genuine mistakes when deploying a microservices system? (Select all that apply)$$,
           NULL, NULL,
           $$The lesson's Common Mistakes list a single-stage build and assuming depends_on alone means ready as mistakes; environment-variable overrides and reaching for Kubernetes only when needed are the recommended approaches.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$deployment$$
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
    ($$Shipping a Dockerfile without a multi-stage build$$, TRUE, 0),
    ($$Using environment variables to override configuration that changes between environments$$, FALSE, 1),
    ($$Assuming depends_on (without a health check condition) means a dependency is actually ready to accept traffic$$, TRUE, 2),
    ($$Reaching for Kubernetes only once multi-machine orchestration is genuinely needed$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$deployment$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
