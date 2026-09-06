-- Promotion-style migration linking EN select-and-filtering quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.


-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'select-and-filtering')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is the full shape of a basic `SELECT` statement, according to this lesson?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What is the full shape of a basic `SELECT` statement, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states the shape is SELECT <columns> FROM <table> WHERE <condition>; -- columns first, then the table, then an optional filter.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'select-and-filtering'
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
    ($$`SELECT <columns> FROM <table> WHERE <condition>;`$$, TRUE, 0),
    ($$`FROM <table> SELECT <columns> WHERE <condition>;`$$, FALSE, 1),
    ($$`WHERE <condition> SELECT <columns> FROM <table>;`$$, FALSE, 2),
    ($$`SELECT <table> FROM <columns> WHERE <condition>;`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'select-and-filtering'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'select-and-filtering')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to this lesson, why is `SELECT *` worth avoiding in anything meant to last?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$According to this lesson, why is `SELECT *` worth avoiding in anything meant to last?$$,
           NULL, NULL,
           $$The lesson states SELECT * silently changes shape the moment a migration adds a column, and it fetches columns nothing downstream needed -- naming columns explicitly keeps a query's output shape stable regardless of what the table grows into later.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'select-and-filtering'
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
    ($$It runs measurably slower than naming every column explicitly, in every single case$$, FALSE, 0),
    ($$It silently changes result shape the moment a migration adds a column, and fetches columns nothing downstream needs$$, TRUE, 1),
    ($$It is syntactically invalid in PostgreSQL and will always produce an error$$, FALSE, 2),
    ($$It only works correctly on tables that have exactly one column$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'select-and-filtering'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'select-and-filtering')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$In `WHERE difficulty = 'ADVANCED' OR difficulty = 'BEGINNER' AND category_id = 5` (no parentheses), how does this actually get evaluated, according to this lesson?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$In `WHERE difficulty = 'ADVANCED' OR difficulty = 'BEGINNER' AND category_id = 5` (no parentheses), how does this actually get evaluated, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states AND binds tighter than OR, the same precedence arithmetic's * has over + -- so this reads as "difficulty = 'ADVANCED'" OR ("difficulty = 'BEGINNER' AND category_id = 5"), which is almost certainly not what's intended without parentheses making the grouping explicit.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'select-and-filtering'
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
    ($$PostgreSQL rejects this statement outright as ambiguous, requiring explicit parentheses to run at all$$, FALSE, 0),
    ($$Left to right with no precedence rules at all, evaluating each condition strictly in the order written$$, FALSE, 1),
    ($$As `difficulty = 'ADVANCED'` OR (`difficulty = 'BEGINNER' AND category_id = 5`) -- `AND` binds tighter than `OR`$$, TRUE, 2),
    ($$As (`difficulty = 'ADVANCED'` OR `difficulty = 'BEGINNER'`) AND `category_id = 5` -- `OR` binds tighter than `AND`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'select-and-filtering'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'select-and-filtering')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given this project's real `topic` slugs `postgresql-and-the-relational-model`, `postgresql-data-types`, and `connecting-to-postgresql`, which ones does `WHERE slug LIKE 'postgresql%'` match?$$
      AND code_snippet = $$SELECT slug FROM topic WHERE slug LIKE 'postgresql%';$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given this project's real `topic` slugs `postgresql-and-the-relational-model`, `postgresql-data-types`, and `connecting-to-postgresql`, which ones does `WHERE slug LIKE 'postgresql%'` match?$$,
           $$SELECT slug FROM topic WHERE slug LIKE 'postgresql%';$$, $$sql$$,
           $$The lesson explains the trailing % only matches slugs STARTING WITH postgresql -- connecting-to-postgresql does NOT match (postgresql appears at the end, not the start), while postgresql-and-the-relational-model and postgresql-data-types both do.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'select-and-filtering'
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
    ($$All three slugs, since `postgresql` appears somewhere in each one$$, FALSE, 0),
    ($$Only `connecting-to-postgresql`, since it ends with `postgresql`$$, FALSE, 1),
    ($$None of the three -- `LIKE` requires wildcards on both sides to match anything at all$$, FALSE, 2),
    ($$`postgresql-and-the-relational-model` and `postgresql-data-types` -- `connecting-to-postgresql` doesn't start with `postgresql`$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'select-and-filtering'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'select-and-filtering')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Is `estimated_minutes BETWEEN 15 AND 20` inclusive or exclusive of its bounds, according to this lesson?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Is `estimated_minutes BETWEEN 15 AND 20` inclusive or exclusive of its bounds, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states BETWEEN checks an inclusive range in one condition -- equivalent to estimated_minutes >= 15 AND estimated_minutes <= 20, both bounds included.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'select-and-filtering'
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
    ($$Inclusive of both bounds -- equivalent to `>= 15 AND <= 20`$$, TRUE, 0),
    ($$Exclusive of both bounds -- equivalent to `> 15 AND < 20`$$, FALSE, 1),
    ($$Inclusive of the lower bound only -- equivalent to `>= 15 AND < 20`$$, FALSE, 2),
    ($$Inclusive of the upper bound only -- equivalent to `> 15 AND <= 20`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'select-and-filtering'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'select-and-filtering')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$This project's `topic.estimated_minutes` column is nullable, and some rows have it set to `NULL`. What does `SELECT slug FROM topic WHERE estimated_minutes = NULL;` return?$$
      AND code_snippet = $$SELECT slug FROM topic WHERE estimated_minutes = NULL;$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$This project's `topic.estimated_minutes` column is nullable, and some rows have it set to `NULL`. What does `SELECT slug FROM topic WHERE estimated_minutes = NULL;` return?$$,
           $$SELECT slug FROM topic WHERE estimated_minutes = NULL;$$, $$sql$$,
           $$The lesson explicitly states this returns ZERO rows, always -- not "rows where estimated_minutes is NULL." Comparing anything to NULL with = evaluates to unknown in PostgreSQL's three-valued logic, and WHERE only keeps rows where the condition is true, so an unknown row is silently dropped. IS NULL is the only correct way to test for NULL.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'select-and-filtering'
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
    ($$Every row in the table, since `NULL` is treated as a wildcard matching any value$$, FALSE, 0),
    ($$Zero rows, always -- `= NULL` never evaluates to true, even for rows that genuinely have `NULL`$$, TRUE, 1),
    ($$Every row where `estimated_minutes` is actually `NULL` -- the same result `IS NULL` would give$$, FALSE, 2),
    ($$A syntax error -- PostgreSQL doesn't allow `NULL` as a literal on the right-hand side of `=`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'select-and-filtering'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'select-and-filtering')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about SELECT and filtering, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about SELECT and filtering, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (!= and <> are both "not equal," with <> being the SQL-standard spelling and != a widely supported alias -- this project has no strong preference between them; ILIKE is PostgreSQL-specific, not part of standard SQL, and is the case-insensitive version of LIKE); the lesson explicitly says LIKE '%text%' and full-text search are NOT the same thing (LIKE has no notion of word boundaries, relevance ranking, or stemming), and IN(...) offers no automatic deduplication or type coercion beyond what a single = comparison would already do.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'select-and-filtering'
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
    ($$`LIKE '%text%'` and PostgreSQL's actual full-text search feature are described in this lesson as being the same thing$$, FALSE, 0),
    ($$`IN (...)` automatically deduplicates its list of values and performs type coercion beyond what a single `=` comparison would do$$, FALSE, 1),
    ($$`!=` and `<>` both mean "not equal" -- `<>` is the SQL-standard spelling, `!=` a widely supported alias$$, TRUE, 2),
    ($$`ILIKE` is PostgreSQL-specific (not standard SQL) and is the case-insensitive equivalent of `LIKE`$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'select-and-filtering'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
