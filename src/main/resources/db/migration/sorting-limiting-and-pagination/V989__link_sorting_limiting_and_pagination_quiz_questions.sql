-- Promotion-style migration linking EN sorting-limiting-and-pagination quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 6 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.


-- Question 1/6 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'sorting-limiting-and-pagination')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Without an `ORDER BY`, what does PostgreSQL guarantee about the order of returned rows, according to this lesson?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Without an `ORDER BY`, what does PostgreSQL guarantee about the order of returned rows, according to this lesson?$$,
           NULL, NULL,
           $$The lesson is explicit: without ORDER BY, PostgreSQL makes no promise about row order at all -- not insertion order, not primary key order, genuinely unspecified, and it can change between runs of the identical query.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'sorting-limiting-and-pagination'
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
    ($$Nothing -- row order is genuinely unspecified and can change between runs of the identical query$$, TRUE, 0),
    ($$Rows are always returned in the order they were originally inserted$$, FALSE, 1),
    ($$Rows are always returned in ascending order of their primary key$$, FALSE, 2),
    ($$Rows are always returned in the order columns were listed in the SELECT clause$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'sorting-limiting-and-pagination'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'sorting-limiting-and-pagination')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$In `ORDER BY difficulty ASC, sort_order DESC`, how does the second sort key actually apply, according to this lesson?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$In `ORDER BY difficulty ASC, sort_order DESC`, how does the second sort key actually apply, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states sorting is applied left to right: rows are grouped by difficulty first, and only WITHIN each identical difficulty value are they then ordered by sort_order -- the second column only breaks ties left by the first, it doesn't independently re-sort the whole result.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'sorting-limiting-and-pagination'
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
    ($$`sort_order` is applied first, and `difficulty` only breaks any remaining ties$$, FALSE, 0),
    ($$`sort_order` only breaks ties within rows that already share the same `difficulty` value -- it doesn't independently re-sort everything$$, TRUE, 1),
    ($$Both columns are applied completely independently, each re-sorting the entire result set separately$$, FALSE, 2),
    ($$Only `difficulty` actually has any effect -- listing a second `ORDER BY` column after it is silently ignored$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'sorting-limiting-and-pagination'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'sorting-limiting-and-pagination')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given a page size of 3, what does this query return, according to this lesson's paging pattern?$$
      AND code_snippet = $$SELECT slug FROM topic
ORDER BY sort_order
LIMIT 3 OFFSET 3;$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given a page size of 3, what does this query return, according to this lesson's paging pattern?$$,
           $$SELECT slug FROM topic
ORDER BY sort_order
LIMIT 3 OFFSET 3;$$, $$sql$$,
           $$The lesson explains OFFSET for page n (zero-indexed) with page size s is n * s -- OFFSET 3 with LIMIT 3 is page 2 (the second group of 3 rows), skipping the first 3 rows (page 1) and returning the next 3.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'sorting-limiting-and-pagination'
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
    ($$Page 4 -- the 10th, 11th, and 12th rows in `sort_order`$$, FALSE, 0),
    ($$All rows starting from row 3 to the end of the table, with no upper limit$$, FALSE, 1),
    ($$Page 2 -- the 4th, 5th, and 6th rows in `sort_order`, skipping the first 3$$, TRUE, 2),
    ($$Page 1 -- the very first 3 rows in `sort_order`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'sorting-limiting-and-pagination'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'sorting-limiting-and-pagination')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$By PostgreSQL's default sort behavior, where do `NULL` values in `estimated_minutes` end up with this query?$$
      AND code_snippet = $$SELECT slug, estimated_minutes FROM topic
ORDER BY estimated_minutes ASC;$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$By PostgreSQL's default sort behavior, where do `NULL` values in `estimated_minutes` end up with this query?$$,
           $$SELECT slug, estimated_minutes FROM topic
ORDER BY estimated_minutes ASC;$$, $$sql$$,
           $$The lesson states PostgreSQL sorts NULL values as larger than any real value by default, which means a plain ORDER BY in ascending order places every NULL at the END -- the opposite would be true in descending order, where NULLs would sort first.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'sorting-limiting-and-pagination'
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
    ($$At the beginning of the result -- `NULL` always sorts first regardless of `ASC` or `DESC`$$, FALSE, 0),
    ($$`NULL` rows are silently excluded from the result entirely when sorting ascending$$, FALSE, 1),
    ($$PostgreSQL raises an error when trying to `ORDER BY` a nullable column without `NULLS LAST` specified explicitly$$, FALSE, 2),
    ($$At the end of the result -- PostgreSQL sorts `NULL` as larger than any real value by default in ascending order$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'sorting-limiting-and-pagination'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'sorting-limiting-and-pagination')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to "The Cost of OFFSET on Large Tables," does `OFFSET 100000` skip those rows for free?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$According to "The Cost of OFFSET on Large Tables," does `OFFSET 100000` skip those rows for free?$$,
           NULL, NULL,
           $$The lesson explicitly states OFFSET doesn't skip rows for free -- PostgreSQL still has to scan and discard every one of them before it can start returning the rows actually wanted, so OFFSET 100000 does meaningfully more work than OFFSET 10, even though both return the same number of rows.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'sorting-limiting-and-pagination'
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
    ($$No -- PostgreSQL must scan and discard every skipped row first, so a larger offset does meaningfully more work$$, TRUE, 0),
    ($$Yes -- PostgreSQL has an internal index that lets it jump directly to any offset with zero extra cost$$, FALSE, 1),
    ($$Yes, but only for tables smaller than a certain fixed row-count threshold$$, FALSE, 2),
    ($$This lesson doesn't address whether OFFSET has any performance cost at all$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'sorting-limiting-and-pagination'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (Pair 6 EN, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'sorting-limiting-and-pagination')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about pagination, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about pagination, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (Pageable was never a separate mechanism from LIMIT/OFFSET -- PageRequest.of(page, size, sort) directly computes LIMIT size OFFSET page*size plus an ORDER BY, and Spring Data JPA also runs a second SELECT count(*) behind the scenes for Page<T>'s totals; LIMIT/OFFSET only make sense paired with an explicit ORDER BY, since without one, "the first N" and "the next N" aren't well-defined concepts); the lesson explicitly calls a plain LIMIT without ORDER BY non-deterministic across repeated runs (not reliably "the first N" rows), and it names keyset pagination -- not something covered in depth in this lesson -- as the faster alternative covered properly later, in "Indexes and Query Performance with EXPLAIN."$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'sorting-limiting-and-pagination'
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
    ($$This lesson covers keyset pagination in full depth as the primary pagination technique, rather than `OFFSET`-based paging$$, FALSE, 0),
    ($$`Pageable`'s `PageRequest.of(page, size, sort)` directly computes `LIMIT size OFFSET page * size` plus an `ORDER BY` -- not a separate mechanism from raw SQL pagination$$, TRUE, 1),
    ($$`LIMIT`/`OFFSET` only make sense paired with an explicit `ORDER BY`, since without one, row order (and therefore "the first N") is undefined$$, TRUE, 2),
    ($$A plain `LIMIT` without `ORDER BY` is described as reliably deterministic, always returning the same "first N" rows across repeated runs$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'sorting-limiting-and-pagination'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
