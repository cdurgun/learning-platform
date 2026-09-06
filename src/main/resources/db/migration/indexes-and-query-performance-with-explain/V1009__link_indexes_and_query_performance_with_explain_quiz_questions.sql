-- Promotion-style migration linking EN indexes-and-query-performance-with-explain quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.


-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'indexes-and-query-performance-with-explain')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does plain `EXPLAIN` (without `ANALYZE`) actually do, according to this lesson?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does plain `EXPLAIN` (without `ANALYZE`) actually do, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states EXPLAIN shows how PostgreSQL intends to execute a query, without actually running it -- it's an estimate (cost, estimated rows, estimated width), not real execution data.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'indexes-and-query-performance-with-explain'
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
    ($$Shows PostgreSQL's intended query plan and cost estimate, without actually running the query$$, TRUE, 0),
    ($$Runs the query for real and reports the actual elapsed time it took$$, FALSE, 1),
    ($$Only works on `SELECT` statements -- it cannot be used on `UPDATE` or `DELETE` at all$$, FALSE, 2),
    ($$Permanently rewrites the query internally to make it faster the next time it runs$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'indexes-and-query-performance-with-explain'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'indexes-and-query-performance-with-explain')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Is a `Seq Scan` always a sign that something is wrong with a query, according to this lesson?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Is a `Seq Scan` always a sign that something is wrong with a query, according to this lesson?$$,
           NULL, NULL,
           $$The lesson explicitly states a Seq Scan isn't inherently bad -- on a small table, scanning every row is often genuinely the cheapest option, cheaper than the overhead of consulting an index at all.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'indexes-and-query-performance-with-explain'
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
    ($$No, but only because indexes are described as not working on foreign key columns$$, FALSE, 0),
    ($$No -- on a small table, a `Seq Scan` is often genuinely the cheapest option, cheaper than consulting an index at all$$, TRUE, 1),
    ($$Yes -- a `Seq Scan` always means a necessary index is missing from the table$$, FALSE, 2),
    ($$Yes, but only when the query uses `SELECT *` specifically instead of naming columns$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'indexes-and-query-performance-with-explain'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'indexes-and-query-performance-with-explain')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Without specifying `USING <method>`, what index type does `CREATE INDEX` default to, according to this lesson?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Without specifying `USING <method>`, what index type does `CREATE INDEX` default to, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states CREATE INDEX defaults to a B-tree -- a balanced tree structure keeping values in sorted order, the right default for equality and range conditions (=, <, >, BETWEEN), and by far the most common index type in practice, including every index this project's own schema defines.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'indexes-and-query-performance-with-explain'
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
    ($$A full-text search index, designed for matching words inside long text columns$$, FALSE, 0),
    ($$A partial index, covering only a subset of the table's rows by default$$, FALSE, 1),
    ($$A B-tree -- efficient for equality and range conditions, and the most common index type in practice$$, TRUE, 2),
    ($$A hash index, optimized specifically for equality comparisons only$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'indexes-and-query-performance-with-explain'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'indexes-and-query-performance-with-explain')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given this `EXPLAIN` and `EXPLAIN ANALYZE` output for the same query, what does the gap between estimated `rows=10` and actual `rows=3` suggest, according to this lesson?$$
      AND code_snippet = $$EXPLAIN SELECT * FROM topic WHERE category_id = 1;
-- Seq Scan on topic (cost=0.00..1.14 rows=10 width=44)

EXPLAIN ANALYZE SELECT * FROM topic WHERE category_id = 1;
-- Seq Scan on topic (cost=0.00..1.14 rows=10 width=44)
--                    (actual time=0.012..0.018 rows=3 loops=1)$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given this `EXPLAIN` and `EXPLAIN ANALYZE` output for the same query, what does the gap between estimated `rows=10` and actual `rows=3` suggest, according to this lesson?$$,
           $$EXPLAIN SELECT * FROM topic WHERE category_id = 1;
-- Seq Scan on topic (cost=0.00..1.14 rows=10 width=44)

EXPLAIN ANALYZE SELECT * FROM topic WHERE category_id = 1;
-- Seq Scan on topic (cost=0.00..1.14 rows=10 width=44)
--                    (actual time=0.012..0.018 rows=3 loops=1)$$, $$text$$,
           $$The lesson states comparing EXPLAIN's estimated rows against EXPLAIN ANALYZE's actual rows is one of the most useful things this pair of tools offers -- a big gap between them means PostgreSQL's own statistics about the table are stale or misleading, which can itself cause it to pick a worse plan than it otherwise would.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'indexes-and-query-performance-with-explain'
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
    ($$The query has a syntax error that only `EXPLAIN ANALYZE` is able to detect$$, FALSE, 0),
    ($$`EXPLAIN ANALYZE` always overstates the actual row count compared to plain `EXPLAIN`$$, FALSE, 1),
    ($$This gap is meaningless -- small differences like this always occur and carry no diagnostic value$$, FALSE, 2),
    ($$PostgreSQL's own statistics about the table are likely stale or misleading, which can cause it to pick a worse plan$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'indexes-and-query-performance-with-explain'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'indexes-and-query-performance-with-explain')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A partial index is created `WHERE language = 'en' AND published = true`. Does a query filtering `WHERE language = 'tr'` benefit from it, according to this lesson?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A partial index is created `WHERE language = 'en' AND published = true`. Does a query filtering `WHERE language = 'tr'` benefit from it, according to this lesson?$$,
           NULL, NULL,
           $$The lesson explicitly states a partial index is a genuine trade-off: it only helps queries whose own condition matches (or is implied by) the index's WHERE clause -- a query filtering on language = 'tr' gets no benefit from an index defined WHERE language = 'en'.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'indexes-and-query-performance-with-explain'
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
    ($$No -- a partial index only helps queries whose own condition matches (or is implied by) the index's own `WHERE` clause$$, TRUE, 0),
    ($$Yes -- a partial index still covers every value of the indexed column, regardless of its own `WHERE` clause$$, FALSE, 1),
    ($$Yes, but only if the query also explicitly filters on `published = true`$$, FALSE, 2),
    ($$No, because partial indexes never provide any benefit to any query under any circumstances$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'indexes-and-query-performance-with-explain'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'indexes-and-query-performance-with-explain')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$With an index on `sort_order`, which of these two approaches gets measurably more expensive the deeper a page sits in the results, according to this lesson?$$
      AND code_snippet = $$-- Approach A:
SELECT slug FROM topic ORDER BY sort_order LIMIT 20 OFFSET 300;

-- Approach B:
SELECT slug FROM topic WHERE sort_order > 300 ORDER BY sort_order LIMIT 20;$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$With an index on `sort_order`, which of these two approaches gets measurably more expensive the deeper a page sits in the results, according to this lesson?$$,
           $$-- Approach A:
SELECT slug FROM topic ORDER BY sort_order LIMIT 20 OFFSET 300;

-- Approach B:
SELECT slug FROM topic WHERE sort_order > 300 ORDER BY sort_order LIMIT 20;$$, $$sql$$,
           $$The lesson explains OFFSET's cost keeps growing the deeper into results a page sits, since PostgreSQL must scan and discard every skipped row -- Approach B's WHERE condition, with an index on sort_order, becomes an Index Scan that jumps directly to the right starting point regardless of depth.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'indexes-and-query-performance-with-explain'
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
    ($$Neither grows in cost -- both are capped by the same `LIMIT 20`, which is described as the only relevant cost factor$$, FALSE, 0),
    ($$Approach A (`OFFSET`) -- it must scan and discard every skipped row, unlike Approach B's `WHERE`-based keyset pagination$$, TRUE, 1),
    ($$Approach B (`WHERE sort_order > 300`) -- keyset pagination is described as always more expensive than `OFFSET`$$, FALSE, 2),
    ($$Both approaches grow in cost identically as the page number increases$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'indexes-and-query-performance-with-explain'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'indexes-and-query-performance-with-explain')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about indexes and query performance, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about indexes and query performance, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (every index costs something on every INSERT/UPDATE/DELETE to that table, a cost EXPLAIN on a SELECT never shows; an index built on a raw column doesn't help a query filtering on a transformed version of it, like LOWER(column) -- the index has to be built on the same expression the query actually filters on); the lesson explicitly warns "more indexes are always better" is a misconception (an unused index is pure cost with no benefit, not something the planner ignores for free), and EXPLAIN and EXPLAIN ANALYZE do NOT show the same thing -- one estimates, the other genuinely executes the query.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'indexes-and-query-performance-with-explain'
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
    ($$More indexes are always better, since the query planner simply ignores any index it doesn't need at zero cost$$, FALSE, 0),
    ($$`EXPLAIN` and `EXPLAIN ANALYZE` always produce identical output, differing only in formatting$$, FALSE, 1),
    ($$An index adds overhead to every `INSERT`/`UPDATE`/`DELETE` on the indexed table, not just to reads$$, TRUE, 2),
    ($$An index built on a raw column doesn't help a query filtering on a transformed version of that column, like `LOWER(column)`$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'indexes-and-query-performance-with-explain'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
