-- Promotion-style migration linking EN databases-schemas-tables-and-basic-sql quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.


-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'databases-schemas-tables-and-basic-sql')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to this lesson, what is the full hierarchy from a PostgreSQL server down to a table?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$According to this lesson, what is the full hierarchy from a PostgreSQL server down to a table?$$,
           NULL, NULL,
           $$The lesson states the full hierarchy is server -> database -> schema -> table: a server can host many databases, a database can have several schemas, and a schema can have many tables.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'databases-schemas-tables-and-basic-sql'
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
    ($$server -> database -> schema -> table$$, TRUE, 0),
    ($$server -> schema -> database -> table$$, FALSE, 1),
    ($$database -> server -> table -> schema$$, FALSE, 2),
    ($$table -> schema -> database -> server$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'databases-schemas-tables-and-basic-sql'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'databases-schemas-tables-and-basic-sql')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$`CREATE TABLE` belongs to which category of SQL, according to this lesson?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$`CREATE TABLE` belongs to which category of SQL, according to this lesson?$$,
           NULL, NULL,
           $$The lesson classifies CREATE TABLE (along with ALTER TABLE and DROP TABLE) as DDL (Data Definition Language) -- statements that define or change the structure of a database, distinct from DML (INSERT/UPDATE/DELETE/SELECT), which reads and writes rows within a structure DDL already created.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'databases-schemas-tables-and-basic-sql'
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
    ($$It belongs to both DDL and DML equally, depending on which columns are defined$$, FALSE, 0),
    ($$DDL (Data Definition Language) -- it defines or changes structure, not rows$$, TRUE, 1),
    ($$DML (Data Manipulation Language) -- it reads and writes rows within an existing structure$$, FALSE, 2),
    ($$It doesn't belong to either category -- CREATE TABLE is considered a purely administrative command$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'databases-schemas-tables-and-basic-sql'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'databases-schemas-tables-and-basic-sql')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to "Statement Terminators, Case Sensitivity, and Identifiers," what happens to an unquoted table name like `Course` when PostgreSQL processes it?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$According to "Statement Terminators, Case Sensitivity, and Identifiers," what happens to an unquoted table name like `Course` when PostgreSQL processes it?$$,
           NULL, NULL,
           $$The lesson states unquoted identifiers (table and column names) are automatically lowercased by PostgreSQL regardless of how they're typed -- so `Course`, `COURSE`, and `course` all refer to the identical table, unless one of them was created with double quotes.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'databases-schemas-tables-and-basic-sql'
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
    ($$PostgreSQL rejects it outright, since unquoted identifiers must always be entirely lowercase to begin with$$, FALSE, 0),
    ($$It's automatically converted to uppercase, the opposite of PostgreSQL's actual behavior$$, FALSE, 1),
    ($$It is automatically folded to lowercase (`course`), so `Course`, `COURSE`, and `course` all refer to the identical table$$, TRUE, 2),
    ($$It stays exactly as typed, case-sensitive, the same way an unquoted Java identifier would$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'databases-schemas-tables-and-basic-sql'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'databases-schemas-tables-and-basic-sql')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to this lesson's "Common Misconceptions," is a database and a schema the same thing?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$According to this lesson's "Common Misconceptions," is a database and a schema the same thing?$$,
           NULL, NULL,
           $$The lesson explicitly says they're not the same -- a database is the top-level container psql's \l lists and \c switches between; a schema is a namespace INSIDE one database, which \dn lists. A single database can hold many schemas, even though this project happens to have exactly one (public) per database.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'databases-schemas-tables-and-basic-sql'
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
    ($$Yes -- "database" and "schema" are simply two different names PostgreSQL uses interchangeably for the identical concept$$, FALSE, 0),
    ($$No, but only because this specific project defines multiple schemas per database$$, FALSE, 1),
    ($$Yes, and \dn and \l are described as producing identical output for that reason$$, FALSE, 2),
    ($$No -- a database is the top-level container (\l/\c); a schema is a namespace inside one database (\dn), and a database can hold many schemas$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'databases-schemas-tables-and-basic-sql'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'databases-schemas-tables-and-basic-sql')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What starts a single-line SQL comment in this project's migrations, according to this lesson?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What starts a single-line SQL comment in this project's migrations, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states `--` starts a single-line SQL comment, running to the end of that line -- unrelated to Java's `//` in origin, but serving the identical purpose; SQL also supports block comments (/* ... */), though this project's migrations only ever use `--`.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'databases-schemas-tables-and-basic-sql'
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
    ($$`--` -- it starts a single-line comment running to the end of that line$$, TRUE, 0),
    ($$`//`, the exact same syntax Java uses for a single-line comment$$, FALSE, 1),
    ($$`#`, the same character used for comments in some scripting languages$$, FALSE, 2),
    ($$SQL has no concept of comments at all -- every line must be executable$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'databases-schemas-tables-and-basic-sql'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'databases-schemas-tables-and-basic-sql')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given this real column definition from V1__init_schema.sql, which of the following does it guarantee, according to this lesson's reading of the syntax?$$
      AND code_snippet = $$slug VARCHAR(255) NOT NULL UNIQUE$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given this real column definition from V1__init_schema.sql, which of the following does it guarantee, according to this lesson's reading of the syntax?$$,
           $$slug VARCHAR(255) NOT NULL UNIQUE$$, $$sql$$,
           $$The lesson reads this left to right: a VARCHAR(255) column that can never be NULL, plus a UNIQUE constraint meaning no two rows in this table may share the same value -- reading the syntax fluently, as this lesson's job is, rather than the full constraint mechanics (deferred to "Constraints and Keys").$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'databases-schemas-tables-and-basic-sql'
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
    ($$The column's value must be unique only when combined with another column also marked UNIQUE elsewhere$$, FALSE, 0),
    ($$The column can never be NULL, and no two rows in the table may share the same `slug` value$$, TRUE, 1),
    ($$The column can be NULL for at most one row, since UNIQUE permits exactly one NULL$$, FALSE, 2),
    ($$The column enforces a maximum of 255 rows in the entire table$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'databases-schemas-tables-and-basic-sql'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'databases-schemas-tables-and-basic-sql')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about SQL syntax, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about SQL syntax, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (SQL keywords are case-insensitive -- uppercase is a readability convention this project follows, not a requirement; a UNIQUE column can still hold multiple NULLs, since PostgreSQL never treats one NULL as equal to another, including for uniqueness); the lesson does not claim NOT NULL prevents duplicate values (NOT NULL and UNIQUE are independent constraints), and it explicitly says PostgreSQL supports transactional DDL, meaning a CREATE TABLE inside a transaction CAN be rolled back, not that it can never be.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'databases-schemas-tables-and-basic-sql'
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
    ($$A `NOT NULL` constraint on a column also automatically prevents that column from holding duplicate values across rows$$, FALSE, 0),
    ($$PostgreSQL does not support transactional DDL -- a `CREATE TABLE` inside a transaction can never be rolled back$$, FALSE, 1),
    ($$SQL keywords like `CREATE TABLE` and `NOT NULL` are case-insensitive in PostgreSQL -- uppercase is a readability convention, not a requirement$$, TRUE, 2),
    ($$A `UNIQUE` column can still hold multiple `NULL` rows, since PostgreSQL never considers one `NULL` equal to another, even for uniqueness checks$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'databases-schemas-tables-and-basic-sql'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
