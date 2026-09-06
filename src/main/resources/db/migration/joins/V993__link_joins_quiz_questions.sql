-- Promotion-style migration linking EN joins quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.


-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'joins')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why does getting a `category`'s name alongside its `course`'s name require a JOIN, according to this lesson?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Why does getting a `category`'s name alongside its `course`'s name require a JOIN, according to this lesson?$$,
           NULL, NULL,
           $$The lesson explains a category row only stores a course_id -- it doesn't repeat the course's name; getting both names in one result therefore means combining two tables, row by row, wherever their foreign key relationship connects them.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'joins'
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
    ($$A `category` row only stores `course_id`, not the course's name -- combining both requires matching rows across the two tables$$, TRUE, 0),
    ($$PostgreSQL requires a `JOIN` any time more than one column is selected, even from a single table$$, FALSE, 1),
    ($$Because `category` and `course` are stored on physically separate database servers$$, FALSE, 2),
    ($$Because `category.name` and `course.name` have genuinely different data types that need converting$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'joins'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'joins')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What rows does an `INNER JOIN` return, according to this lesson?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What rows does an `INNER JOIN` return, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states INNER JOIN (often just written JOIN, with INNER implied) returns only rows that have a match on both sides -- a category row with no matching course simply wouldn't appear.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'joins'
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
    ($$Only rows that have NO match on either side of the join$$, FALSE, 0),
    ($$Only rows that have a match on both sides of the join$$, TRUE, 1),
    ($$Every row from the left-hand table, regardless of whether a match exists on the right$$, FALSE, 2),
    ($$Every row from both tables, combined, whether or not a match exists on either side$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'joins'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'joins')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given this real three-table chain, how many rows does this query return against this project's own data?$$
      AND code_snippet = $$SELECT t.slug, cat.name AS category_name, c.name AS course_name
FROM topic t
INNER JOIN category cat ON t.category_id = cat.id
INNER JOIN course c ON cat.course_id = c.id
WHERE t.slug = 'joins';$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given this real three-table chain, how many rows does this query return against this project's own data?$$,
           $$SELECT t.slug, cat.name AS category_name, c.name AS course_name
FROM topic t
INNER JOIN category cat ON t.category_id = cat.id
INNER JOIN course c ON cat.course_id = c.id
WHERE t.slug = 'joins';$$, $$sql$$,
           $$The lesson states this returns exactly one row: 'joins', 'PostgreSQL Foundations', 'PostgreSQL' -- since t.slug = 'joins' matches exactly one topic row, and each INNER JOIN step matches it to exactly one category and one course, per this project's real content hierarchy.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'joins'
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
    ($$Ten rows, one for every topic in the `postgresql-foundations` category$$, FALSE, 0),
    ($$Exactly one row, but with `category_name` and `course_name` both `NULL`$$, FALSE, 1),
    ($$Exactly one row: `joins`, `PostgreSQL Foundations`, `PostgreSQL`$$, TRUE, 2),
    ($$Zero rows, since three-table `INNER JOIN` chains are not valid SQL syntax$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'joins'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'joins')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to "From JPQL join fetch to a Real SQL JOIN," what does this project's `TopicRepository.findBySlugWithCategoryAndCourse`'s JPQL `join fetch` compile to?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$According to "From JPQL join fetch to a Real SQL JOIN," what does this project's `TopicRepository.findBySlugWithCategoryAndCourse`'s JPQL `join fetch` compile to?$$,
           NULL, NULL,
           $$The lesson states join fetch isn't a different kind of join from SQL's JOIN -- it's Hibernate choosing to express a Java-level "also load this related entity" instruction as a real SQL JOIN, compiling to essentially the same three-table INNER JOIN chain written by hand.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'joins'
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
    ($$A completely different mechanism from a SQL `JOIN`, using a proprietary Hibernate-only query protocol$$, FALSE, 0),
    ($$Two or more separate, follow-up `SELECT` queries, one per related entity, run one after another$$, FALSE, 1),
    ($$A `LEFT JOIN` specifically, regardless of what the JPQL itself says$$, FALSE, 2),
    ($$Essentially the same three-table `INNER JOIN` chain -- `join fetch` is the same relational operation, expressed from the JPQL side$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'joins'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'joins')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given this real query, what does `tt.title` show for a `topic` row that has no English `topic_translation` row at all?$$
      AND code_snippet = $$SELECT t.slug, tt.title
FROM topic t
LEFT JOIN topic_translation tt ON tt.topic_id = t.id AND tt.language = 'en';$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given this real query, what does `tt.title` show for a `topic` row that has no English `topic_translation` row at all?$$,
           $$SELECT t.slug, tt.title
FROM topic t
LEFT JOIN topic_translation tt ON tt.topic_id = t.id AND tt.language = 'en';$$, $$sql$$,
           $$The lesson explains LEFT JOIN keeps every row from the left-hand table (topic) whether or not it finds a match on the right -- when there's no match, the right side's columns simply come back as NULL, rather than that topic row silently disappearing the way an INNER JOIN would make it.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'joins'
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
    ($$`NULL` -- the `topic` row still appears, but `tt.title` comes back `NULL` since there's no matching row$$, TRUE, 0),
    ($$The `topic` row disappears from the result entirely, the same as an `INNER JOIN` would produce$$, FALSE, 1),
    ($$An empty string `''`, rather than `NULL`, since `LEFT JOIN` never produces `NULL` values$$, FALSE, 2),
    ($$The query fails with an error, since `LEFT JOIN` requires a match on every row$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'joins'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'joins')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A developer writes `LEFT JOIN topic_translation en ON en.topic_id = t.id AND en.language = 'en' WHERE en.published = true`, intending to find topics with no published English translation. According to this lesson's "Common Mistakes," what actually happens?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A developer writes `LEFT JOIN topic_translation en ON en.topic_id = t.id AND en.language = 'en' WHERE en.published = true`, intending to find topics with no published English translation. According to this lesson's "Common Mistakes," what actually happens?$$,
           NULL, NULL,
           $$The lesson explicitly warns that filtering an outer-joined table's column in WHERE instead of ON silently turns a LEFT JOIN back into the equivalent of an INNER JOIN -- WHERE runs after the join and drops any row where the condition isn't true, including exactly the NULL rows the LEFT JOIN was meant to preserve.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'joins'
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
    ($$PostgreSQL automatically rewrites the `WHERE` clause into the `ON` clause to preserve the intended `LEFT JOIN` behavior$$, FALSE, 0),
    ($$`WHERE en.published = true` silently turns this back into the equivalent of an `INNER JOIN`, dropping exactly the unmatched rows meant to be found$$, TRUE, 1),
    ($$This works exactly as intended -- `WHERE` and `ON` are fully interchangeable for any condition on an outer-joined table$$, FALSE, 2),
    ($$The query fails outright with a syntax error, since `WHERE` cannot reference a `LEFT JOIN`ed table's columns$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'joins'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'joins')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about `RIGHT JOIN` and `FULL JOIN`, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about `RIGHT JOIN` and `FULL JOIN`, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (A LEFT JOIN B and B RIGHT JOIN A return the same rows, just with columns in a different order -- which is why RIGHT JOIN is rarely needed in practice; FULL JOIN keeps every row from both sides regardless of match, filling in NULL on whichever side has no counterpart); the lesson explicitly says this project's own code never uses RIGHT JOIN, and it says LEFT JOIN is not inherently slower than INNER JOIN -- any performance difference comes down to indexes and row counts, not the join type itself.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'joins'
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
    ($$This project's own real code is described in this lesson as using `RIGHT JOIN` extensively throughout its queries$$, FALSE, 0),
    ($$`LEFT JOIN` is described in this lesson as inherently, always slower than `INNER JOIN`, regardless of indexes or row counts$$, FALSE, 1),
    ($$`A LEFT JOIN B` and `B RIGHT JOIN A` return the same rows, just with columns in a different order$$, TRUE, 2),
    ($$`FULL JOIN` keeps every row from both sides regardless of match, filling in `NULL` on whichever side has no counterpart$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'joins'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
