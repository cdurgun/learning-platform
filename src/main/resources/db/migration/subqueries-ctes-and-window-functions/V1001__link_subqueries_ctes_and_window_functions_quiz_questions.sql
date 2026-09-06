-- Promotion-style migration linking EN subqueries-ctes-and-window-functions quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.


-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'subqueries-ctes-and-window-functions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What must a scalar subquery return in order to be used in a comparison like `WHERE estimated_minutes > (SELECT ...)`?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What must a scalar subquery return in order to be used in a comparison like `WHERE estimated_minutes > (SELECT ...)`?$$,
           NULL, NULL,
           $$The lesson defines a scalar subquery as one that must return exactly one row and one column, since it's being compared to a single column value with > the same way a literal number would be.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'subqueries-ctes-and-window-functions'
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
    ($$Exactly one row and one column$$, TRUE, 0),
    ($$Any number of rows, as long as there's exactly one column$$, FALSE, 1),
    ($$Exactly one row, but any number of columns$$, FALSE, 2),
    ($$Nothing -- a subquery can never appear on the right-hand side of a comparison operator$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'subqueries-ctes-and-window-functions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'subqueries-ctes-and-window-functions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given this sample `topic` data and correlated subquery, which `estimated_minutes` values does the query return?$$
      AND code_snippet = $$-- topic (category_id, estimated_minutes) sample rows:
-- (1, 10), (1, 20), (1, 30), (2, 5), (2, 15)

SELECT t.estimated_minutes
FROM topic t
WHERE t.estimated_minutes > (
    SELECT AVG(t2.estimated_minutes)
    FROM topic t2
    WHERE t2.category_id = t.category_id
);$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given this sample `topic` data and correlated subquery, which `estimated_minutes` values does the query return?$$,
           $$-- topic (category_id, estimated_minutes) sample rows:
-- (1, 10), (1, 20), (1, 30), (2, 5), (2, 15)

SELECT t.estimated_minutes
FROM topic t
WHERE t.estimated_minutes > (
    SELECT AVG(t2.estimated_minutes)
    FROM topic t2
    WHERE t2.category_id = t.category_id
);$$, $$sql$$,
           $$The lesson explains a correlated subquery re-evaluates once per outer row, using t.category_id: category 1's average is (10+20+30)/3=20, so only 30 exceeds it; category 2's average is (5+15)/2=10, so only 15 exceeds it -- the subquery is NOT one platform-wide average, it's recomputed per category.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'subqueries-ctes-and-window-functions'
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
    ($$None -- correlated subqueries cannot be compared with `>`$$, FALSE, 0),
    ($$30 and 15 -- each compared against its own category's average, not a single platform-wide average$$, TRUE, 1),
    ($$30 only -- since 30 is the single highest value in the entire table$$, FALSE, 2),
    ($$All five values -- since every row is at least as large as some category's average$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'subqueries-ctes-and-window-functions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'subqueries-ctes-and-window-functions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does a `WITH <name> AS (...)` clause (a CTE) let the rest of the query do, according to this lesson?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does a `WITH <name> AS (...)` clause (a CTE) let the rest of the query do, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states a CTE names a subquery up front, letting the main query reference it like a real table for the rest of that one statement -- it isn't a real table anywhere in the schema, it exists only for the duration of that query.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'subqueries-ctes-and-window-functions'
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
    ($$Run the subquery once per row of the outer query, the same way a correlated subquery does$$, FALSE, 0),
    ($$Replace the need for a `FROM` clause anywhere else in the same statement$$, FALSE, 1),
    ($$Reference the named subquery like a real table, for the remainder of that same statement$$, TRUE, 2),
    ($$Permanently create a new table in the database schema that persists after the query finishes$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'subqueries-ctes-and-window-functions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'subqueries-ctes-and-window-functions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Without `RECURSIVE`, can a CTE in a `WITH` clause reference another CTE defined later in the same clause, according to this lesson?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Without `RECURSIVE`, can a CTE in a `WITH` clause reference another CTE defined later in the same clause, according to this lesson?$$,
           NULL, NULL,
           $$The lesson explicitly lists this as a common mistake: CTEs (without RECURSIVE) can only reference the ones defined before them in the same WITH clause, in order -- the same top-to-bottom dependency direction as reading the query itself.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'subqueries-ctes-and-window-functions'
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
    ($$Yes -- CTEs in the same `WITH` clause can reference each other in any order, regardless of position$$, FALSE, 0),
    ($$Yes, but only if both CTEs are explicitly aliased with `AS`$$, FALSE, 1),
    ($$Yes, but only when the later CTE is a window function rather than a plain aggregate$$, FALSE, 2),
    ($$No -- a CTE can only reference ones defined before it in the same `WITH` clause, top to bottom$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'subqueries-ctes-and-window-functions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'subqueries-ctes-and-window-functions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given this sample data and window function query, how many rows are returned, and what is `category_avg` for the row with `estimated_minutes = 10`?$$
      AND code_snippet = $$-- topic (slug, category_id, estimated_minutes) sample rows:
-- ('a', 1, 10), ('b', 1, 20), ('c', 2, 5)

SELECT slug, category_id, estimated_minutes,
       AVG(estimated_minutes) OVER (PARTITION BY category_id) AS category_avg
FROM topic;$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given this sample data and window function query, how many rows are returned, and what is `category_avg` for the row with `estimated_minutes = 10`?$$,
           $$-- topic (slug, category_id, estimated_minutes) sample rows:
-- ('a', 1, 10), ('b', 1, 20), ('c', 2, 5)

SELECT slug, category_id, estimated_minutes,
       AVG(estimated_minutes) OVER (PARTITION BY category_id) AS category_avg
FROM topic;$$, $$sql$$,
           $$The lesson states a window function never collapses rows the way GROUP BY does -- all 3 original rows survive, each carrying its own category's average alongside it. Category 1's average is (10+20)/2=15, so slug 'a' (in category 1) shows category_avg=15, not a platform-wide average.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'subqueries-ctes-and-window-functions'
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
    ($$3 rows, all preserved; `category_avg` for slug 'a' (category 1) is 15$$, TRUE, 0),
    ($$2 rows, one per category; `category_avg` for slug 'a' is 10$$, FALSE, 1),
    ($$1 row total, since a window function always collapses to a single summary row$$, FALSE, 2),
    ($$3 rows preserved, but `category_avg` for slug 'a' is 11.67, the platform-wide average across all rows$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'subqueries-ctes-and-window-functions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'subqueries-ctes-and-window-functions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given this sample data with a tie, what `rn` (ROW_NUMBER) and `rk` (RANK) values do rows 'a' and 'b' get, and what `rk` does 'c' get?$$
      AND code_snippet = $$-- topic (slug, category_id, estimated_minutes) sample rows:
-- ('a', 1, 20), ('b', 1, 20), ('c', 1, 10)

SELECT slug,
       ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY estimated_minutes DESC) AS rn,
       RANK() OVER (PARTITION BY category_id ORDER BY estimated_minutes DESC) AS rk
FROM topic;$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Given this sample data with a tie, what `rn` (ROW_NUMBER) and `rk` (RANK) values do rows 'a' and 'b' get, and what `rk` does 'c' get?$$,
           $$-- topic (slug, category_id, estimated_minutes) sample rows:
-- ('a', 1, 20), ('b', 1, 20), ('c', 1, 10)

SELECT slug,
       ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY estimated_minutes DESC) AS rn,
       RANK() OVER (PARTITION BY category_id ORDER BY estimated_minutes DESC) AS rk
FROM topic;$$, $$sql$$,
           $$The lesson explains ROW_NUMBER() never ties, producing a strict 1,2,3 sequence even for equal values (so 'a' and 'b' get rn 1 and 2, in some order), while RANK() gives tied rows the same rank and skips the next number accordingly -- 'a' and 'b' both get rk=1, and 'c' (the only row with 10) gets rk=3, not 2.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'subqueries-ctes-and-window-functions'
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
    ($$`a`/`b` get the same `rk` (1), and `c` also gets `rk` = 1, since `RANK()` ignores the `ORDER BY` value entirely$$, FALSE, 0),
    ($$`a`/`b` get distinct `rn` values (1 and 2, in some order) but the same `rk` (1); `c` gets `rk` = 3, skipping 2$$, TRUE, 1),
    ($$`a`/`b` get the same `rn` (1) and the same `rk` (1); `c` gets `rk` = 2$$, FALSE, 2),
    ($$`a`/`b` get distinct `rn` and distinct `rk` values, since ties are impossible in PostgreSQL window functions$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'subqueries-ctes-and-window-functions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'subqueries-ctes-and-window-functions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about subqueries, CTEs, and window functions, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about subqueries, CTEs, and window functions, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (a window function never reduces row count, unlike GROUP BY -- this is precisely why the two solve different problems even starting from the same aggregate; PARTITION BY divides rows into independent groups for a window function, the window-function equivalent of GROUP BY's grouping); the lesson explicitly says a CTE is NOT always faster than an equivalent subquery (it's primarily a readability/reusability tool), and RANK()/ROW_NUMBER() are only interchangeable when there are no ties, not always.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'subqueries-ctes-and-window-functions'
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
    ($$A CTE is always faster than the logically equivalent nested subquery$$, FALSE, 0),
    ($$`RANK()` and `ROW_NUMBER()` are always fully interchangeable, regardless of whether the `ORDER BY` column contains ties$$, FALSE, 1),
    ($$A window function never reduces the number of output rows, unlike `GROUP BY`$$, TRUE, 2),
    ($$`PARTITION BY` divides rows into independent groups for a window function, analogous to `GROUP BY`'s grouping for aggregation$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'subqueries-ctes-and-window-functions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
