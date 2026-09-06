-- Promotion-style migration linking EN postgresql-and-the-relational-model quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 5 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.


-- Question 1/5 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-and-the-relational-model')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to this lesson, what specifically makes a database "relational"?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$According to this lesson, what specifically makes a database "relational"?$$,
           NULL, NULL,
           $$The lesson defines "relational" as data organized as separate tables that refer to one another through shared values (like topic.category_id pointing at a row in category), instead of duplicating data or nesting it inside one giant structure -- not "related" in a loose, everyday sense.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-and-the-relational-model'
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
    ($$Tables refer to one another through shared column values, instead of duplicating or nesting data inside one structure$$, TRUE, 0),
    ($$Data is related in the loose, everyday sense that any two pieces of information can be considered connected$$, FALSE, 1),
    ($$Every table must physically live on the same disk as every other table on the server$$, FALSE, 2),
    ($$Rows within a single table are related to each other by their insertion order$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-and-the-relational-model'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/5 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-and-the-relational-model')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is the relationship between SQL and PostgreSQL, according to this lesson?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What is the relationship between SQL and PostgreSQL, according to this lesson?$$,
           NULL, NULL,
           $$The lesson describes this as the same specification-vs-implementation relationship already covered for JPA and Hibernate, one layer down: SQL is a broadly standardized language, and PostgreSQL is one real, running piece of software that implements it (alongside others like MySQL, Oracle Database, SQL Server).$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-and-the-relational-model'
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
    ($$SQL only works with PostgreSQL and cannot be used with any other database system$$, FALSE, 0),
    ($$SQL is a standardized language; PostgreSQL is one specific, real implementation of a relational database built around it -- the same spec-vs-implementation relationship as JPA and Hibernate$$, TRUE, 1),
    ($$SQL and PostgreSQL are two names for the exact same thing, with no meaningful distinction$$, FALSE, 2),
    ($$PostgreSQL is a standardized language, and SQL is one specific implementation of it$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-and-the-relational-model'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/5 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-and-the-relational-model')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to "Tables, Rows, and Columns: The Core Mental Model," what does a column guarantee for every row in its table?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$According to "Tables, Rows, and Columns: The Core Mental Model," what does a column guarantee for every row in its table?$$,
           NULL, NULL,
           $$The lesson defines a column as one named, typed slot every row in that table has a value for -- or explicitly has no value for, when the column allows it (i.e., allows NULL); it isn't an optional field some rows have and others simply lack entirely.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-and-the-relational-model'
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
    ($$A value that is always identical across every row in the table$$, FALSE, 0),
    ($$A reference that always points to a row in a different table$$, FALSE, 1),
    ($$A named, typed slot that every row has a value for, or explicitly has no value for when the column allows NULL$$, TRUE, 2),
    ($$A slot that only some rows in the table are required to have, depending on when they were inserted$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-and-the-relational-model'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/5 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-and-the-relational-model')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Put this lesson's five-layer stack, from a Java method call down to the actual stored row, in the correct order.$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Put this lesson's five-layer stack, from a Java method call down to the actual stored row, in the correct order.$$,
           NULL, NULL,
           $$The lesson lays out the stack as: Spring Boot -> Spring Data JPA -> Hibernate -> SQL -> PostgreSQL -> tables/indexes/constraints/transactions -- each layer hands off to a specific, nameable next one.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-and-the-relational-model'
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
    ($$Spring Boot -> Hibernate -> Spring Data JPA -> PostgreSQL -> SQL$$, FALSE, 0),
    ($$SQL -> Spring Boot -> Hibernate -> Spring Data JPA -> PostgreSQL$$, FALSE, 1),
    ($$PostgreSQL -> SQL -> Hibernate -> Spring Data JPA -> Spring Boot$$, FALSE, 2),
    ($$Spring Boot -> Spring Data JPA -> Hibernate -> SQL -> PostgreSQL$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-and-the-relational-model'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/5 (Pair 5 EN, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-and-the-relational-model')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about ACID, as introduced in this lesson's "ACID: A First Look," are correct? (Select all that apply)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about ACID, as introduced in this lesson's "ACID: A First Look," are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (Atomicity means a group of changes either all happen or none do; Isolation means one transaction doesn't see another transaction's unfinished, uncommitted work); the lesson states PostgreSQL provides all four ACID guarantees (not just some), and it explicitly says the full mechanics are deliberately left for "Transactions and Concurrency in PostgreSQL" later in the course, not taught in depth in this lesson.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-and-the-relational-model'
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
    ($$Atomicity means a group of changes either all happen, or none of them do$$, TRUE, 0),
    ($$Isolation means one transaction doesn't see another transaction's unfinished, uncommitted work$$, TRUE, 1),
    ($$PostgreSQL is described in this lesson as providing only some, not all, of the four ACID guarantees$$, FALSE, 2),
    ($$This lesson teaches the full mechanics of ACID, transactions, and locking in depth, with nothing left for a later lesson$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-and-the-relational-model'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
