-- Promotion-style migration linking EN configuration-management quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 5 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.

-- Question 1/5 (EN pair 1, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$configuration-management$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$What problem does centralizing configuration in a Config Server solve, per this lesson?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What problem does centralizing configuration in a Config Server solve, per this lesson?$$,
           NULL, NULL,
           $$The lesson explains centralizing avoids copy-pasting and manually updating the same shared configuration value across many services' own files.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$configuration-management$$
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
    ($$It eliminates the need for any application.yml file whatsoever$$, FALSE, 0),
    ($$It avoids copy-pasting and manually updating the same shared configuration value across many services' own files$$, TRUE, 1),
    ($$It automatically encrypts every HTTP request between services$$, FALSE, 2),
    ($$It removes the need for a database connection string entirely$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$configuration-management$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/5 (EN pair 2, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$configuration-management$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Per "The Config Repository: Where Configuration Actually Lives," why do server.port and spring.application.name stay in order-service's own local application.yml, instead of being centralized?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Per "The Config Repository: Where Configuration Actually Lives," why do server.port and spring.application.name stay in order-service's own local application.yml, instead of being centralized?$$,
           NULL, NULL,
           $$The lesson explains a service needs to know its own identity and port before it can even ask Config Server for anything else.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$configuration-management$$
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
    ($$Because Config Server technically cannot store integer values like ports$$, FALSE, 0),
    ($$Because a service needs to know its own identity and port before it can even ask Config Server for anything else$$, TRUE, 1),
    ($$Because server.port and spring.application.name are deprecated properties$$, FALSE, 2),
    ($$Because centralizing them would require a separate database$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$configuration-management$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/5 (EN pair 3, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$configuration-management$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$A @RefreshScope-annotated bean reads greeting.message via @Value. A developer edits that value in the Config Repository, but never calls /actuator/refresh. What does the running service see?$$
      AND code_snippet = $$@RestController
@RefreshScope
class RefreshableGreetingController {
    @Value("${greeting.message}")
    private String greetingMessage;
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A @RefreshScope-annotated bean reads greeting.message via @Value. A developer edits that value in the Config Repository, but never calls /actuator/refresh. What does the running service see?$$,
           $$@RestController
@RefreshScope
class RefreshableGreetingController {
    @Value("${greeting.message}")
    private String greetingMessage;
}$$, $$java$$,
           $$The lesson explains @RefreshScope only re-reads @Value-injected properties when a refresh is actually triggered -- without it, nothing changes until the next restart.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$configuration-management$$
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
    ($$The new value, automatically, on the very next request$$, FALSE, 0),
    ($$The old value -- @RefreshScope only re-reads @Value's when a refresh is actually triggered$$, TRUE, 1),
    ($$A NoSuchBeanDefinitionException, since the bean's configuration no longer matches$$, FALSE, 2),
    ($$null, since editing a Config Repository file always invalidates the property immediately$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$configuration-management$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/5 (EN pair 4, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$configuration-management$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Per "Secrets: What Config Server Should NOT Store in Plain Text," how does this lesson recommend handling order-service's database password, even with Config Server available?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Per "Secrets: What Config Server Should NOT Store in Plain Text," how does this lesson recommend handling order-service's database password, even with Config Server available?$$,
           NULL, NULL,
           $$The lesson explains the password stays an environment variable, and only configuration that isn't genuinely a secret gets centralized.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$configuration-management$$
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
    ($$Move it into the Config Repository as plain text, since the repository is private$$, FALSE, 0),
    ($$Keep it as an environment variable (${ORDERS_DB_PASSWORD}), and only centralize configuration that isn't genuinely a secret$$, TRUE, 1),
    ($$Store it inside order-service's own compiled .jar file$$, FALSE, 2),
    ($$Email it manually to every team member who needs it$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$configuration-management$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/5 (EN pair 5, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$configuration-management$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are presented in this lesson as genuine mistakes when using Spring Cloud Config? (Select all that apply)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are presented in this lesson as genuine mistakes when using Spring Cloud Config? (Select all that apply)$$,
           NULL, NULL,
           $$The lesson's Common Mistakes list centralizing identity/port and over-applying @RefreshScope as mistakes; using profiles and keeping secrets as environment variables are the recommended approaches.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$configuration-management$$
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
    ($$Centralizing server.port or spring.application.name in the Config Repository$$, TRUE, 0),
    ($$Using profiles for environment-specific configuration overrides$$, FALSE, 1),
    ($$Applying @RefreshScope to every single bean "just in case"$$, TRUE, 2),
    ($$Keeping a database password as an environment variable instead of a Config Repository file$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$configuration-management$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
