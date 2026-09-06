-- Promotion-style migration linking EN inserting-updating-and-deleting-data quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.


-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'inserting-updating-and-deleting-data')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$In `INSERT INTO course (name, slug, sort_order) VALUES ('PostgreSQL', 'postgresql', 5);`, what determines which value is assigned to which column?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$In `INSERT INTO course (name, slug, sort_order) VALUES ('PostgreSQL', 'postgresql', 5);`, what determines which value is assigned to which column?$$,
           NULL, NULL,
           $$The lesson states column order in the parentheses must match the value order that follows -- the first named column gets the first value, and so on; any column left out entirely (like id) takes its default.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'inserting-updating-and-deleting-data'
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
    ($$Position -- the order of columns in the parentheses must match the order of values that follows$$, TRUE, 0),
    ($$Alphabetical order of the column names, regardless of how they're listed in the statement$$, FALSE, 1),
    ($$The order columns were originally defined in the table's `CREATE TABLE` statement, ignoring the INSERT's own column list$$, FALSE, 2),
    ($$PostgreSQL matches values to columns automatically by data type, not by position$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'inserting-updating-and-deleting-data'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'inserting-updating-and-deleting-data')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why does `UPDATE`/`DELETE` need a `WHERE` clause, according to this lesson?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Why does `UPDATE`/`DELETE` need a `WHERE` clause, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states there's no such concept as affecting only "the current row" in SQL -- omitting WHERE targets every row in the table, immediately, with no confirmation prompt; a WHERE clause is what narrows which specific rows are affected.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'inserting-updating-and-deleting-data'
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
    ($$`WHERE` is required only for `DELETE`, not for `UPDATE`$$, FALSE, 0),
    ($$Without it, every row in the table is affected immediately, with no confirmation prompt$$, TRUE, 1),
    ($$It's optional and purely stylistic -- omitting it only affects a single, unspecified "current" row$$, FALSE, 2),
    ($$PostgreSQL requires `WHERE` syntactically -- a statement without one simply fails to parse$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'inserting-updating-and-deleting-data'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'inserting-updating-and-deleting-data')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given this real migration pattern, what happens to the `INSERT` if no `category` row has `slug = 'postgresql-foundations'`?$$
      AND code_snippet = $$INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'connecting-to-postgresql', 'BEGINNER', 15, 2
FROM category
WHERE slug = 'postgresql-foundations';$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given this real migration pattern, what happens to the `INSERT` if no `category` row has `slug = 'postgresql-foundations'`?$$,
           $$INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'connecting-to-postgresql', 'BEGINNER', 15, 2
FROM category
WHERE slug = 'postgresql-foundations';$$, $$sql$$,
           $$The lesson explicitly warns that INSERT ... SELECT's SELECT can return zero rows (a slug that doesn't match anything) -- the INSERT then silently inserts zero rows too, with no error, a much quieter failure than a typo in a VALUES literal would produce.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'inserting-updating-and-deleting-data'
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
    ($$The `INSERT` inserts one row anyway, with `category_id` set to `NULL`$$, FALSE, 0),
    ($$PostgreSQL automatically creates a new `category` row with that slug before completing the `INSERT`$$, FALSE, 1),
    ($$The `INSERT` silently inserts zero rows, with no error at all$$, TRUE, 2),
    ($$The `INSERT` fails with a specific "no matching category" error$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'inserting-updating-and-deleting-data'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'inserting-updating-and-deleting-data')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given this statement, does PostgreSQL need a separate, follow-up `SELECT` to obtain the new row's generated `id`?$$
      AND code_snippet = $$INSERT INTO course (name, slug, sort_order)
VALUES ('PostgreSQL', 'postgresql', 5)
RETURNING id;$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given this statement, does PostgreSQL need a separate, follow-up `SELECT` to obtain the new row's generated `id`?$$,
           $$INSERT INTO course (name, slug, sort_order)
VALUES ('PostgreSQL', 'postgresql', 5)
RETURNING id;$$, $$sql$$,
           $$The lesson explicitly states RETURNING doesn't run a second query -- it's the same single statement, returning data it already computed while performing the write, immediately handing back the id PostgreSQL just generated via BIGSERIAL, without a round trip to query for it separately.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'inserting-updating-and-deleting-data'
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
    ($$Yes -- `RETURNING` triggers PostgreSQL to automatically run a hidden `SELECT` immediately afterward$$, FALSE, 0),
    ($$Yes -- `RETURNING` only works if a separate `SELECT id FROM course WHERE ...` is issued right after it$$, FALSE, 1),
    ($$`RETURNING id` is invalid syntax on an `INSERT` statement -- it only works on `UPDATE`/`DELETE`$$, FALSE, 2),
    ($$No -- `RETURNING id` hands back the generated id as part of the same single statement, with no extra round trip$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'inserting-updating-and-deleting-data'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'inserting-updating-and-deleting-data')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why doesn't this project's own Flyway migrations ever use `ON CONFLICT`, according to this lesson?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Why doesn't this project's own Flyway migrations ever use `ON CONFLICT`, according to this lesson?$$,
           NULL, NULL,
           $$The lesson explains Flyway guarantees each numbered migration runs exactly once per database, in order, and is checksummed against modification -- so a migration inserting a row can safely assume it doesn't exist yet; there's no conflict to handle because Flyway itself is the mechanism preventing one.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'inserting-updating-and-deleting-data'
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
    ($$Flyway guarantees each migration runs exactly once per database, so there's no conflict to handle in the first place$$, TRUE, 0),
    ($$`ON CONFLICT` is a feature this specific PostgreSQL version doesn't support$$, FALSE, 1),
    ($$This project's migrations are described as containing a real bug that happens to avoid needing `ON CONFLICT`$$, FALSE, 2),
    ($$`ON CONFLICT` only works with `UPDATE` statements, never with `INSERT`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'inserting-updating-and-deleting-data'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'inserting-updating-and-deleting-data')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given this statement, what does `EXCLUDED.name` refer to, if a `category` row with `(course_id=5, slug='postgresql-foundations')` already exists with `name = 'Old Name'`?$$
      AND code_snippet = $$INSERT INTO category (course_id, name, slug, sort_order)
VALUES (5, 'PostgreSQL Foundations', 'postgresql-foundations', 1)
ON CONFLICT (course_id, slug)
DO UPDATE SET name = EXCLUDED.name;$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given this statement, what does `EXCLUDED.name` refer to, if a `category` row with `(course_id=5, slug='postgresql-foundations')` already exists with `name = 'Old Name'`?$$,
           $$INSERT INTO category (course_id, name, slug, sort_order)
VALUES (5, 'PostgreSQL Foundations', 'postgresql-foundations', 1)
ON CONFLICT (course_id, slug)
DO UPDATE SET name = EXCLUDED.name;$$, $$sql$$,
           $$The lesson explains EXCLUDED refers to the row that was about to be inserted, not the existing row -- so EXCLUDED.name is the new 'PostgreSQL Foundations' value from the VALUES clause, and after this statement runs, the existing row's name is updated from 'Old Name' to 'PostgreSQL Foundations'.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'inserting-updating-and-deleting-data'
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
    ($$Both values combined into a single concatenated string$$, FALSE, 0),
    ($$The new value from the `VALUES` clause, `'PostgreSQL Foundations'` -- `EXCLUDED` refers to the row that was about to be inserted$$, TRUE, 1),
    ($$The existing row's current value, `'Old Name'` -- `EXCLUDED` refers to the row already in the table$$, FALSE, 2),
    ($$Nothing -- `EXCLUDED` is only valid inside a `DO NOTHING` clause, not `DO UPDATE`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'inserting-updating-and-deleting-data'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'inserting-updating-and-deleting-data')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about INSERT/UPDATE/DELETE, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about INSERT/UPDATE/DELETE, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (ON CONFLICT only catches a UNIQUE/PRIMARY KEY/EXCLUDE constraint violation on the specific column(s) named -- a NOT NULL or foreign key violation still fails the statement outright; DELETE FROM table with no WHERE removes rows one by one, slower than TRUNCATE on a large table and firing any triggers, unlike TRUNCATE's faster structural operation); the lesson explicitly recommends INSERT...SELECT over hardcoding a foreign key's numeric id (not the reverse), and it states RETURNING works identically on UPDATE and DELETE too, not only on INSERT.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'inserting-updating-and-deleting-data'
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
    ($$This lesson recommends hardcoding a foreign key's numeric id directly, rather than using the `INSERT ... SELECT` pattern$$, FALSE, 0),
    ($$`RETURNING` only works on `INSERT` statements, not on `UPDATE` or `DELETE`$$, FALSE, 1),
    ($$`ON CONFLICT` only catches a `UNIQUE`/`PRIMARY KEY`/`EXCLUDE` violation on the specific column(s) named -- a `NOT NULL` violation still fails the statement outright$$, TRUE, 2),
    ($$`DELETE FROM table` (no `WHERE`) removes rows one by one and fires triggers, unlike the faster, purely structural `TRUNCATE TABLE`$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'inserting-updating-and-deleting-data'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
