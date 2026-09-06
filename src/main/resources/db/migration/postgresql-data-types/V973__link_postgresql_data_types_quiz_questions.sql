-- Promotion-style migration linking EN postgresql-data-types quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.


-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-data-types')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is `BIGSERIAL`, according to this lesson?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What is `BIGSERIAL`, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states BIGSERIAL isn't a distinct storage type -- it's BIGINT plus an automatically created sequence that generates the next value, which is exactly what backs GenerationType.IDENTITY on this project's own primary keys.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-data-types'
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
    ($$BIGINT plus an automatically created sequence that generates the next value -- not a distinct storage type of its own$$, TRUE, 0),
    ($$A completely separate storage type from BIGINT, with its own distinct binary representation$$, FALSE, 1),
    ($$A string type specifically used for storing large serialized JSON objects$$, FALSE, 2),
    ($$A type that can only be used for foreign key columns, never for primary keys$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-data-types'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-data-types')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Is `TEXT` slower than a length-limited `VARCHAR(n)` in PostgreSQL, according to this lesson?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Is `TEXT` slower than a length-limited `VARCHAR(n)` in PostgreSQL, according to this lesson?$$,
           NULL, NULL,
           $$The lesson explicitly states PostgreSQL stores VARCHAR(n), unbounded VARCHAR, and TEXT all the same way internally, applying no performance penalty to TEXT over a length-limited VARCHAR -- unlike some other databases, where TEXT is a slower, separately stored type.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-data-types'
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
    ($$This lesson doesn't address performance differences between VARCHAR and TEXT at all$$, FALSE, 0),
    ($$No -- PostgreSQL stores all three the same way internally, with no performance penalty for TEXT$$, TRUE, 1),
    ($$Yes -- TEXT is always significantly slower than VARCHAR(n) in PostgreSQL specifically$$, FALSE, 2),
    ($$Yes, but only for columns longer than 255 characters$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-data-types'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-data-types')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What values can a `BOOLEAN` column store in PostgreSQL, according to this lesson?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What values can a `BOOLEAN` column store in PostgreSQL, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states BOOLEAN stores exactly true, false, or NULL -- no 0/1 integer substitute, unlike some databases; 0/1 are integers, a genuinely different type, even though some client libraries accept them as loose input.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-data-types'
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
    ($$`true`, `false`, `0`, `1`, and `NULL`, all treated as five equally valid values$$, FALSE, 0),
    ($$Only `true` or `false` -- a BOOLEAN column can never hold NULL under any circumstance$$, FALSE, 1),
    ($$Exactly `true`, `false`, or `NULL` -- no `0`/`1` integer substitute$$, TRUE, 2),
    ($$Only `0` or `1`, the same as an integer flag in many other database systems$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-data-types'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-data-types')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is the key difference between `TIMESTAMP` and `TIMESTAMPTZ`, according to this lesson?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What is the key difference between `TIMESTAMP` and `TIMESTAMPTZ`, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states plain TIMESTAMP stores a date and time with no time zone attached at all -- just a naive point in time, as written -- while TIMESTAMPTZ stores a point in time that PostgreSQL always normalizes to UTC internally, converting to and from whatever time zone the connecting client is in.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-data-types'
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
    ($$They are functionally identical in every respect, with TIMESTAMPTZ being purely a longer alias for TIMESTAMP$$, FALSE, 0),
    ($$TIMESTAMP includes time zone handling, while TIMESTAMPTZ explicitly does not$$, FALSE, 1),
    ($$TIMESTAMPTZ can only store dates, never times, unlike TIMESTAMP$$, FALSE, 2),
    ($$TIMESTAMP has no time zone attached at all; TIMESTAMPTZ normalizes to UTC internally and converts based on the client's time zone$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-data-types'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-data-types')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given this real `\d topic_translation` output, what SQL type was actually used to declare the `summary` column?$$
      AND code_snippet = $$learning=# \d topic_translation
                 Table "public.topic_translation"
      Column      |          Type          | Collation | Nullable | Default
-------------------+------------------------+-----------+----------+---------
 id                | bigint                 |           | not null |
 topic_id          | bigint                 |           | not null |
 language          | character varying(5)   |           | not null |
 title             | character varying(255) |           | not null |
 summary           | text                   |           |          |
 published         | boolean                |           | not null |$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given this real `\d topic_translation` output, what SQL type was actually used to declare the `summary` column?$$,
           $$learning=# \d topic_translation
                 Table "public.topic_translation"
      Column      |          Type          | Collation | Nullable | Default
-------------------+------------------------+-----------+----------+---------
 id                | bigint                 |           | not null |
 topic_id          | bigint                 |           | not null |
 language          | character varying(5)   |           | not null |
 title             | character varying(255) |           | not null |
 summary           | text                   |           |          |
 published         | boolean                |           | not null |$$, $$text$$,
           $$The lesson explains psql reports PostgreSQL's internal type names, which are lowercase and occasionally differ from the SQL keyword used to declare them -- `text` shown here directly is the SQL type TEXT (there's no separate "internal" spelling for TEXT the way there is for `character varying` vs `VARCHAR`), and TEXT is exactly what this project maps `topic_translation.summary` to via an explicit `columnDefinition`.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-data-types'
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
    ($$`TEXT` -- shown as `text` in psql's output, matching this project's explicit `columnDefinition = "TEXT"` on `TopicTranslation.summary`$$, TRUE, 0),
    ($$`VARCHAR(255)`, the same type as the `title` column shown just above it$$, FALSE, 1),
    ($$`BIGINT`, the same type as the `id` and `topic_id` columns$$, FALSE, 2),
    ($$`BOOLEAN`, the same type as the `published` column shown just below it$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-data-types'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-data-types')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why does this project's `topic_translation.published` column being `BOOLEAN NOT NULL` matter for its Java mapping to a primitive `boolean`, according to this lesson?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Why does this project's `topic_translation.published` column being `BOOLEAN NOT NULL` matter for its Java mapping to a primitive `boolean`, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states a primitive boolean field in Java can never hold null, so if the column allowed NULL, a NULL value read from the database would have nowhere valid to go -- a NOT NULL column and a non-nullable Java type need to agree, or reading a row can fail in ways that have nothing to do with application logic.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-data-types'
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
    ($$Hibernate automatically converts any NULL boolean value into a boxed `Boolean` regardless of the Java field's declared type$$, FALSE, 0),
    ($$A primitive `boolean` in Java can never hold `null` -- if the column allowed NULL, a NULL value read back would have nowhere valid to go$$, TRUE, 1),
    ($$It doesn't matter at all -- Java's primitive `boolean` can represent a database NULL without any issue$$, FALSE, 2),
    ($$`NOT NULL` is purely a performance optimization here with no relationship to how Java maps the value$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-data-types'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-data-types')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about PostgreSQL data types, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about PostgreSQL data types, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (INTEGER/BIGINT map to Java's Integer/Long; choosing BIGINT/BIGSERIAL for every primary key even in a small table is called a defensive default, since changing a primary key's type later after foreign keys reference it is far more disruptive than the extra bytes cost); mapping a TIMESTAMPTZ column to LocalDateTime is explicitly named as a common mistake that silently loses time zone information (not a safe, lossless choice), and this lesson's own examples show every SQL-to-Java mapping handled automatically by Hibernate WITHOUT any explicit type-conversion annotation (except the TEXT columnDefinition case) -- not requiring one for every single mapping.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-data-types'
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
    ($$Mapping a `TIMESTAMPTZ` column to `LocalDateTime` is a safe, lossless choice with no downside according to this lesson$$, FALSE, 0),
    ($$This project's entities require an explicit type-conversion annotation for every single SQL-to-Java type mapping shown in this lesson, with no exceptions$$, FALSE, 1),
    ($$Choosing `BIGINT`/`BIGSERIAL` for every primary key, even in a table that will stay small, is described as a defensive default worth keeping$$, TRUE, 2),
    ($$`INTEGER`/`BIGINT` map to Java's `Integer`/`Long`, matching this project's own `topic.estimated_minutes` (`INTEGER`) and `id` (`BIGSERIAL`) columns$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-data-types'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
