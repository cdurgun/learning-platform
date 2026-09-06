-- Promotion-style migration linking EN postgresql-specific-data-types quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 6 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.


-- Question 1/6 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-specific-data-types')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does `gen_random_uuid()` do, according to this lesson?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does `gen_random_uuid()` do, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states gen_random_uuid() is PostgreSQL's own built-in function for generating a random (version 4) UUID as a column default -- the direct UUID equivalent of BIGSERIAL's implicit sequence, with no application code involved.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-specific-data-types'
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
    ($$PostgreSQL's built-in function for generating a random (version 4) UUID, usable as a column default$$, TRUE, 0),
    ($$Converts an existing `BIGSERIAL` value in a table into its equivalent `UUID` representation$$, FALSE, 1),
    ($$Generates a sequential, predictable UUID, incrementing by one each time it's called$$, FALSE, 2),
    ($$A Java method provided by Hibernate, not an actual PostgreSQL function$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-specific-data-types'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-specific-data-types')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is the key difference between `JSON` and `JSONB`, according to this lesson?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What is the key difference between `JSON` and `JSONB`, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states JSON stores the exact text submitted, byte for byte, re-parsing it every time it's queried; JSONB stores a parsed, more efficient internal representation, supports indexing (which plain JSON doesn't), at the cost of not preserving original key order or duplicate keys.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-specific-data-types'
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
    ($$`JSONB` re-parses the text on every query, while `JSON` stores an indexable binary representation$$, FALSE, 0),
    ($$`JSON` stores the exact submitted text and re-parses it on every query; `JSONB` stores a parsed binary form and supports indexing$$, TRUE, 1),
    ($$`JSON` supports indexing while `JSONB` does not, since `JSONB` is the older, less efficient format$$, FALSE, 2),
    ($$They are functionally identical in every respect -- `JSONB` is purely a newer alias for `JSON`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-specific-data-types'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-specific-data-types')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given a `settings` value of `{"theme": "dark"}`, what do these two comparisons evaluate to?$$
      AND code_snippet = $$SELECT settings -> 'theme' = 'dark' AS via_arrow,
       settings ->> 'theme' = 'dark' AS via_double_arrow
FROM user_preference;$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given a `settings` value of `{"theme": "dark"}`, what do these two comparisons evaluate to?$$,
           $$SELECT settings -> 'theme' = 'dark' AS via_arrow,
       settings ->> 'theme' = 'dark' AS via_double_arrow
FROM user_preference;$$, $$sql$$,
           $$The lesson explains -> extracts a value AS JSONB, while ->> extracts it as text; comparing a JSONB value to a plain text literal with = never matches (different types, even when they "look" the same), so via_arrow is false; ->> gives text, so text = text correctly evaluates to true.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-specific-data-types'
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
    ($$Both `via_arrow` and `via_double_arrow` = false$$, FALSE, 0),
    ($$`via_arrow` = true; `via_double_arrow` = false$$, FALSE, 1),
    ($$`via_arrow` = false; `via_double_arrow` = true$$, TRUE, 2),
    ($$Both `via_arrow` and `via_double_arrow` = true$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-specific-data-types'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-specific-data-types')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given these two `user_preference.settings` rows, what does this query return?$$
      AND code_snippet = $$-- row 1 settings: {"theme": "dark", "lang": "en"}
-- row 2 settings: {"theme": "light"}

SELECT count(*) FROM user_preference WHERE settings @> '{"theme": "dark"}';$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given these two `user_preference.settings` rows, what does this query return?$$,
           $$-- row 1 settings: {"theme": "dark", "lang": "en"}
-- row 2 settings: {"theme": "light"}

SELECT count(*) FROM user_preference WHERE settings @> '{"theme": "dark"}';$$, $$sql$$,
           $$The lesson explains @> checks whether one JSONB value contains another -- row 1's settings contains {"theme": "dark"} (however much else the object has), row 2's does not (its theme is light), so exactly 1 row matches.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-specific-data-types'
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
    ($$2 -- both rows match, since `@>` ignores the actual key values$$, FALSE, 0),
    ($$0 -- `@>` requires an exact, full match of the entire JSONB object, not a partial one$$, FALSE, 1),
    ($$An error -- `@>` only works on arrays, not on `JSONB` objects$$, FALSE, 2),
    ($$1 -- only row 1's `settings` contains `{"theme": "dark"}`$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-specific-data-types'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (Pair 5 EN, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-specific-data-types')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given a `code_example.tags` value of `ARRAY['records', 'immutability']`, what do `tags[1]` and `'records' = ANY(tags)` evaluate to?$$
      AND code_snippet = $$SELECT tags[1] AS first_tag, 'records' = ANY(tags) AS has_records
FROM code_example;$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given a `code_example.tags` value of `ARRAY['records', 'immutability']`, what do `tags[1]` and `'records' = ANY(tags)` evaluate to?$$,
           $$SELECT tags[1] AS first_tag, 'records' = ANY(tags) AS has_records
FROM code_example;$$, $$sql$$,
           $$The lesson explicitly states PostgreSQL arrays are 1-indexed, not 0-indexed -- so tags[1] is the first element, 'records'; ANY(tags) checks whether a single value appears anywhere in the array, and 'records' does appear, so has_records is true.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-specific-data-types'
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
    ($$`first_tag` = `'records'`; `has_records` = `true`$$, TRUE, 0),
    ($$`first_tag` = `NULL`, since PostgreSQL arrays are 0-indexed and index 1 is out of bounds for a two-element array$$, FALSE, 1),
    ($$`first_tag` = `'immutability'`; `has_records` = `true`$$, FALSE, 2),
    ($$`first_tag` = `'records'`; `has_records` = `false`, since `ANY` only checks the first element$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-specific-data-types'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (Pair 6 EN, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-specific-data-types')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about PostgreSQL-specific data types, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about PostgreSQL-specific data types, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (JSONB normalizes the input, which is exactly why it does NOT preserve original key order or duplicate keys, unlike JSON; PostgreSQL arrays are explicitly 1-indexed, called out as a real, easy-to-forget difference from Java); the lesson explicitly says a UUID hides sequential information but that isn't the same as "secure" -- access control still happens at the application/authorization layer regardless of key type, and it says storing data as JSONB defers the schema design decision rather than eliminating it entirely.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-specific-data-types'
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
    ($$Storing data as `JSONB` is described in this lesson as eliminating the need to design a schema at all$$, FALSE, 0),
    ($$`JSONB` does not preserve the original key order or duplicate keys the way plain `JSON` does$$, TRUE, 1),
    ($$PostgreSQL arrays are 1-indexed, not 0-indexed$$, TRUE, 2),
    ($$A `UUID` primary key is described in this lesson as always more secure than `BIGSERIAL`, full stop$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-specific-data-types'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
