-- Promotion-style migration linking EN jpa-hibernate-and-spring-data-jpa quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is JPA (Jakarta Persistence API), precisely?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What is JPA (Jakarta Persistence API), precisely?$$,
           NULL, NULL,
           $$JPA is a specification -- a set of interfaces and annotations describing how object-relational mapping should work, with no runtime behavior of its own.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'jpa-hibernate-and-spring-data-jpa'
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
    ($$A specification -- a set of interfaces and annotations with no runtime behavior of its own$$, TRUE, 0),
    ($$A library you install and run directly, like Hibernate$$, FALSE, 1),
    ($$Another name for Hibernate itself$$, FALSE, 2),
    ($$A Spring-specific tool for generating repository implementations$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jpa-hibernate-and-spring-data-jpa'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is Hibernate's relationship to JPA?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What is Hibernate's relationship to JPA?$$,
           NULL, NULL,
           $$Hibernate is a concrete implementation of the JPA specification -- it's what actually generates the SQL underneath.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'jpa-hibernate-and-spring-data-jpa'
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
    ($$JPA is built on top of Hibernate, not the other way around$$, FALSE, 0),
    ($$Hibernate is a concrete implementation of the JPA specification$$, TRUE, 1),
    ($$Hibernate and JPA are two interchangeable names for the same thing$$, FALSE, 2),
    ($$Hibernate is a newer specification that replaced JPA$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jpa-hibernate-and-spring-data-jpa'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$When a Spring Data JPA repository method runs, what actually happens underneath?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$When a Spring Data JPA repository method runs, what actually happens underneath?$$,
           NULL, NULL,
           $$It still goes through JPA's EntityManager and still gets turned into SQL by Hibernate -- Spring Data JPA only removes the repetitive boilerplate, it doesn't bypass either layer.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'jpa-hibernate-and-spring-data-jpa'
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
    ($$Spring Data JPA replaces Hibernate with its own, separate SQL generation engine$$, FALSE, 0),
    ($$It depends on whether the method is a derived query or a custom @Query$$, FALSE, 1),
    ($$Spring Data JPA bypasses JPA and Hibernate entirely, talking to the database directly$$, FALSE, 2),
    ($$It still goes through JPA's EntityManager and still gets turned into SQL by Hibernate underneath$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jpa-hibernate-and-spring-data-jpa'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which sequence correctly reflects how a repository call flows through this project's four layers?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which sequence correctly reflects how a repository call flows through this project's four layers?$$,
           NULL, NULL,
           $$Repository (interface) -> Spring Data JPA (generates implementation) -> JPA (specification: EntityManager) -> Hibernate (implementation: generates SQL).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'jpa-hibernate-and-spring-data-jpa'
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
    ($$Hibernate -> JPA -> Spring Data JPA -> Repository$$, FALSE, 0),
    ($$Repository -> Hibernate -> JPA -> Spring Data JPA$$, FALSE, 1),
    ($$JPA -> Repository -> Hibernate -> Spring Data JPA$$, FALSE, 2),
    ($$Repository -> Spring Data JPA -> JPA -> Hibernate$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jpa-hibernate-and-spring-data-jpa'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why can't a Java record be used as a JPA entity?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Why can't a Java record be used as a JPA entity?$$,
           NULL, NULL,
           $$Hibernate builds entity instances via reflection before populating their fields, which requires a no-args constructor and mutable fields -- a record has neither.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'jpa-hibernate-and-spring-data-jpa'
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
    ($$Because records are a preview feature not yet supported by any JPA provider$$, FALSE, 0),
    ($$Because it has no no-args constructor and no mutable fields for Hibernate to populate via reflection$$, TRUE, 1),
    ($$Because JPA only works with classes annotated @Service$$, FALSE, 2),
    ($$Because records cannot have a field named id$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jpa-hibernate-and-spring-data-jpa'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following correctly describe Spring Boot's role in this four-layer picture? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe Spring Boot's role in this four-layer picture? (Select all that apply)$$,
           NULL, NULL,
           $$Spring Boot doesn't add a new layer -- it auto-configures a DataSource, EntityManagerFactory, Hibernate as the JPA provider, and repository infrastructure, all without manual configuration.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'jpa-hibernate-and-spring-data-jpa'
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
    ($$It requires manual configuration of the EntityManagerFactory before any repository can work$$, FALSE, 0),
    ($$It auto-configures a DataSource, EntityManagerFactory, and Hibernate as the JPA provider$$, TRUE, 1),
    ($$It wires the existing JPA/Hibernate/Spring Data JPA layers together automatically, without adding a new layer of its own$$, TRUE, 2),
    ($$It replaces Hibernate with its own, Spring-specific ORM implementation$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jpa-hibernate-and-spring-data-jpa'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following correctly assign a responsibility to the right layer? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly assign a responsibility to the right layer? (Select all that apply)$$,
           NULL, NULL,
           $$JPA defines WHAT mapping should look like; Hibernate actually executes it as SQL; Spring Data JPA removes the boilerplate of writing an EntityManager-based class by hand for every entity.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'jpa-hibernate-and-spring-data-jpa'
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
    ($$Spring Data JPA is what actually generates the SQL sent to PostgreSQL$$, FALSE, 0),
    ($$Hibernate is a repository abstraction that generates interface implementations$$, FALSE, 1),
    ($$JPA defines WHAT object-relational mapping should look like, via annotations and interfaces$$, TRUE, 2),
    ($$Hibernate is what actually turns @Entity-annotated classes and JPA calls into real SQL$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jpa-hibernate-and-spring-data-jpa'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
