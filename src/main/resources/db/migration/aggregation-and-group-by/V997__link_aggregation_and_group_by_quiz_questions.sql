-- Promotion-style migration linking EN aggregation-and-group-by quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.


-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'aggregation-and-group-by')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$On this project's nullable `estimated_minutes` column, could `COUNT(*)` and `COUNT(estimated_minutes)` return different numbers, according to this lesson?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$On this project's nullable `estimated_minutes` column, could `COUNT(*)` and `COUNT(estimated_minutes)` return different numbers, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states COUNT(*) counts rows regardless of any column's value, while COUNT(column) counts only rows where that column is not NULL -- a real distinction on this project's own nullable estimated_minutes column, where the two could genuinely differ if any row had it unset.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'aggregation-and-group-by'
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
    ($$Yes -- `COUNT(*)` counts every row, while `COUNT(estimated_minutes)` counts only rows where it's not `NULL`$$, TRUE, 0),
    ($$No -- `COUNT(*)` and `COUNT(column)` always return identical results for any column, nullable or not$$, FALSE, 1),
    ($$No, but only because `estimated_minutes` happens to be a `BIGSERIAL` column, not because of how `COUNT` works$$, FALSE, 2),
    ($$Yes, but only because `COUNT(*)` is always exactly double `COUNT(column)`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'aggregation-and-group-by'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'aggregation-and-group-by')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$`SELECT COUNT(*) FROM topic;` (no `GROUP BY`) returns exactly one row, no matter how many rows `topic` has. Why, according to this lesson?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`SELECT COUNT(*) FROM topic;` (no `GROUP BY`) returns exactly one row, no matter how many rows `topic` has. Why, according to this lesson?$$,
           NULL, NULL,
           $$The lesson explains an aggregate function with no GROUP BY treats the entire result of the FROM/WHERE clauses as a single group -- the whole filtered table is one group, so the aggregate computes one summary value across all of it.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'aggregation-and-group-by'
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
    ($$The `topic` table is described as having exactly one row for the purposes of this specific example$$, FALSE, 0),
    ($$An aggregate function with no `GROUP BY` treats the entire filtered result as a single group, producing one summary row$$, TRUE, 1),
    ($$PostgreSQL silently applies `LIMIT 1` to every query that uses an aggregate function$$, FALSE, 2),
    ($$`COUNT(*)` is a special case that always returns exactly one row regardless of `GROUP BY`, unlike every other aggregate function$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'aggregation-and-group-by'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'aggregation-and-group-by')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why does `SELECT slug, difficulty, COUNT(*) FROM topic GROUP BY difficulty` get rejected by PostgreSQL, according to this lesson?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Why does `SELECT slug, difficulty, COUNT(*) FROM topic GROUP BY difficulty` get rejected by PostgreSQL, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states every column in the SELECT list must be either an aggregate function or one of the columns named in GROUP BY -- for a given difficulty group, PostgreSQL has no single slug to report, since there could be many, so it rejects the query rather than picking one arbitrarily.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'aggregation-and-group-by'
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
    ($$`GROUP BY` only supports grouping by exactly one column total, and this query attempts to group by two$$, FALSE, 0),
    ($$`COUNT(*)` cannot be combined with any other column in the same `SELECT` list under any circumstances$$, FALSE, 1),
    ($$`slug` is neither an aggregate function nor a `GROUP BY` column -- for a given `difficulty` group, there could be many different `slug` values, with no single one to report$$, TRUE, 2),
    ($$PostgreSQL doesn't actually reject this query -- it silently picks one arbitrary `slug` per group without any error$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'aggregation-and-group-by'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'aggregation-and-group-by')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$`HAVING` filters groups after aggregation; `WHERE` filters rows before grouping. Why can't `WHERE COUNT(*) >= 5` be used instead of `HAVING COUNT(*) >= 5`, according to this lesson?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`HAVING` filters groups after aggregation; `WHERE` filters rows before grouping. Why can't `WHERE COUNT(*) >= 5` be used instead of `HAVING COUNT(*) >= 5`, according to this lesson?$$,
           NULL, NULL,
           $$The lesson explains WHERE runs before aggregation exists at all -- COUNT(*) doesn't exist yet for any single row being filtered, it only exists once the grouping has already happened; this is exactly why HAVING is a separate clause rather than an extra condition tacked onto WHERE.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'aggregation-and-group-by'
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
    ($$`WHERE COUNT(*) >= 5` is valid and equivalent -- `HAVING` is purely a stylistic alternative with no functional difference$$, FALSE, 0),
    ($$`WHERE` can reference aggregates, but only for `COUNT`, never for `SUM`, `AVG`, `MIN`, or `MAX`$$, FALSE, 1),
    ($$`HAVING` is only required when the query has no `GROUP BY` clause at all$$, FALSE, 2),
    ($$`WHERE` runs before aggregation exists -- `COUNT(*)` has no value yet at the point `WHERE` would need to evaluate it$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'aggregation-and-group-by'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'aggregation-and-group-by')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given this real query, why is `COUNT(t.id)` used instead of `COUNT(*)` to correctly report `0` for a category with no topics?$$
      AND code_snippet = $$SELECT cat.name AS category_name, COUNT(t.id) AS topic_count
FROM category cat
LEFT JOIN topic t ON t.category_id = cat.id
GROUP BY cat.name;$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given this real query, why is `COUNT(t.id)` used instead of `COUNT(*)` to correctly report `0` for a category with no topics?$$,
           $$SELECT cat.name AS category_name, COUNT(t.id) AS topic_count
FROM category cat
LEFT JOIN topic t ON t.category_id = cat.id
GROUP BY cat.name;$$, $$sql$$,
           $$The lesson explains that with the LEFT JOIN, a category with no matching topics still produces one output row where every t.* column is NULL -- COUNT(*) would count that all-NULL row as 1, while COUNT(t.id) correctly counts it as 0, since t.id itself is NULL for it.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'aggregation-and-group-by'
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
    ($$Because a category with no matching topics still produces one all-`NULL` row via the `LEFT JOIN`; `COUNT(t.id)` correctly sees `t.id` as `NULL` and doesn't count it, while `COUNT(*)` would count it as 1$$, TRUE, 0),
    ($$Because `COUNT(*)` is invalid syntax when used alongside a `LEFT JOIN`$$, FALSE, 1),
    ($$There's no real difference here -- `COUNT(t.id)` and `COUNT(*)` always produce identical results after any `LEFT JOIN`$$, FALSE, 2),
    ($$Because `COUNT(t.id)` runs faster than `COUNT(*)`, which is the only reason for the choice$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'aggregation-and-group-by'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'aggregation-and-group-by')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given this real query, in what order do `WHERE`, `GROUP BY`, and `HAVING` actually run?$$
      AND code_snippet = $$SELECT category_id, COUNT(*) AS topic_count
FROM topic
WHERE difficulty = 'ADVANCED'
GROUP BY category_id
HAVING COUNT(*) >= 2;$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Given this real query, in what order do `WHERE`, `GROUP BY`, and `HAVING` actually run?$$,
           $$SELECT category_id, COUNT(*) AS topic_count
FROM topic
WHERE difficulty = 'ADVANCED'
GROUP BY category_id
HAVING COUNT(*) >= 2;$$, $$sql$$,
           $$The lesson lays out the exact sequence: WHERE difficulty = 'ADVANCED' runs first, discarding non-ADVANCED rows entirely before any grouping happens; GROUP BY category_id then groups whatever rows survived; HAVING COUNT(*) >= 2 runs last, keeping only the resulting groups whose count (of already-filtered rows) meets the threshold.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'aggregation-and-group-by'
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
    ($$All three run simultaneously, in a single, unordered pass over the table$$, FALSE, 0),
    ($$`WHERE` first (discarding non-`ADVANCED` rows), then `GROUP BY` (grouping the survivors), then `HAVING` last (filtering the resulting groups)$$, TRUE, 1),
    ($$`HAVING` first, then `GROUP BY`, then `WHERE` last$$, FALSE, 2),
    ($$`GROUP BY` first, then `HAVING`, then `WHERE` last$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'aggregation-and-group-by'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'aggregation-and-group-by')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about aggregation and GROUP BY, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about aggregation and GROUP BY, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (AVG/SUM/MIN/MAX all ignore NULLs automatically rather than letting one NULL poison the whole calculation; GROUP BY and DISTINCT are explicitly called out as NOT the same job -- DISTINCT only removes exact row duplicates, it can't compute a count/sum/average per group the way GROUP BY genuinely can); the lesson does not say a non-aggregated, non-grouped SELECT column is merely a style warning (PostgreSQL actively rejects the query outright), and multiple aggregate functions ARE explicitly shown appearing together in one query, each computed per group.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'aggregation-and-group-by'
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
    ($$Selecting a non-aggregated, non-grouped column alongside `GROUP BY` is merely a style warning in PostgreSQL, not something that causes the query to be rejected$$, FALSE, 0),
    ($$This lesson states that only one aggregate function may appear in a single `SELECT` list -- multiple aggregates together in one query are not possible$$, FALSE, 1),
    ($$`AVG`/`SUM`/`MIN`/`MAX` all ignore `NULL`s automatically, rather than letting a single `NULL` poison the whole calculation$$, TRUE, 2),
    ($$`GROUP BY` and `DISTINCT` do not do the same job -- `DISTINCT` only removes exact row duplicates, it cannot compute a count, sum, or average per group$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'aggregation-and-group-by'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
