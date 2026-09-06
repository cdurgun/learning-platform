-- Promotion-style migration linking EN constraints-and-keys quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.


-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'constraints-and-keys')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What two constraints does `PRIMARY KEY` bundle together, according to this lesson?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What two constraints does `PRIMARY KEY` bundle together, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states PRIMARY KEY is really two constraints bundled together: NOT NULL (a primary key column can never be empty) plus UNIQUE (no two rows can share the same value) -- and PostgreSQL automatically builds an index on it.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'constraints-and-keys'
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
    ($$`NOT NULL` plus `UNIQUE`$$, TRUE, 0),
    ($$`CHECK` plus `FOREIGN KEY`$$, FALSE, 1),
    ($$`UNIQUE` plus `FOREIGN KEY`$$, FALSE, 2),
    ($$`NOT NULL` plus `CHECK`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'constraints-and-keys'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'constraints-and-keys')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What actually happens if application code tries to `INSERT` a `category` row with a `course_id` of `9999` when no course with that id exists, according to this lesson?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What actually happens if application code tries to `INSERT` a `category` row with a `course_id` of `9999` when no course with that id exists, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states the FOREIGN KEY constraint enforces referential integrity: PostgreSQL itself rejects the INSERT outright with a real, specific error ("violates foreign key constraint"), regardless of what Java code did or didn't validate beforehand.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'constraints-and-keys'
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
    ($$The row is inserted successfully, but a warning is logged rather than the operation failing$$, FALSE, 0),
    ($$PostgreSQL rejects the INSERT outright with a specific "violates foreign key constraint" error, regardless of Java-level validation$$, TRUE, 1),
    ($$The row is inserted successfully, with `course_id` silently set to `NULL` instead of `9999`$$, FALSE, 2),
    ($$The row is inserted successfully, and PostgreSQL automatically creates a new `course` row with id `9999`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'constraints-and-keys'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'constraints-and-keys')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given this real foreign key from V1__init_schema.sql, if a `course` row is deleted, what happens to the `category` rows that reference it?$$
      AND code_snippet = $$CREATE TABLE category
(
    id        BIGSERIAL PRIMARY KEY,
    course_id BIGINT       NOT NULL REFERENCES course (id) ON DELETE CASCADE,
    name      VARCHAR(255) NOT NULL,
    slug      VARCHAR(255) NOT NULL
);$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given this real foreign key from V1__init_schema.sql, if a `course` row is deleted, what happens to the `category` rows that reference it?$$,
           $$CREATE TABLE category
(
    id        BIGSERIAL PRIMARY KEY,
    course_id BIGINT       NOT NULL REFERENCES course (id) ON DELETE CASCADE,
    name      VARCHAR(255) NOT NULL,
    slug      VARCHAR(255) NOT NULL
);$$, $$sql$$,
           $$The lesson explains ON DELETE CASCADE means deleting a course row automatically deletes every category row that references it -- which cascades further into every topic and topic_translation that depends on those categories, since deleting one row intentionally deletes an entire dependent subtree.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'constraints-and-keys'
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
    ($$The `category` rows survive unchanged, but their `course_id` column is set to `NULL`$$, FALSE, 0),
    ($$Nothing happens to `category` rows -- `ON DELETE CASCADE` only affects the `course` table's own rows$$, FALSE, 1),
    ($$Every `category` row referencing that `course` is automatically deleted too, cascading further into dependent `topic` rows$$, TRUE, 2),
    ($$The `DELETE` on `course` fails outright, since a foreign key always blocks deleting a referenced row$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'constraints-and-keys'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'constraints-and-keys')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given this real constraint from `quiz_question_link`, what happens when `DELETE FROM question WHERE id = ...` is attempted for a question still linked into a published quiz?$$
      AND code_snippet = $$-- question_id: ON DELETE RESTRICT KASITLI -- bir soru, canli bir sabit quiz'in
-- parcasi oldugu surece hard-delete edilemez.
quiz_id     BIGINT NOT NULL REFERENCES quiz (id) ON DELETE CASCADE,
question_id BIGINT NOT NULL REFERENCES question (id) ON DELETE RESTRICT$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given this real constraint from `quiz_question_link`, what happens when `DELETE FROM question WHERE id = ...` is attempted for a question still linked into a published quiz?$$,
           $$-- question_id: ON DELETE RESTRICT KASITLI -- bir soru, canli bir sabit quiz'in
-- parcasi oldugu surece hard-delete edilemez.
quiz_id     BIGINT NOT NULL REFERENCES quiz (id) ON DELETE CASCADE,
question_id BIGINT NOT NULL REFERENCES question (id) ON DELETE RESTRICT$$, $$sql$$,
           $$The lesson explains ON DELETE RESTRICT blocks the delete outright: as long as a question is linked into any published quiz, DELETE FROM question fails with an error instead of silently removing the link along with it -- the opposite of CASCADE's behavior.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'constraints-and-keys'
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
    ($$The `question` row is deleted, and its `quiz_question_link` row is automatically deleted along with it$$, FALSE, 0),
    ($$The `question` row is deleted, and its `quiz_question_link.question_id` is automatically set to `NULL`$$, FALSE, 1),
    ($$Nothing happens -- `RESTRICT` is purely documentation and has no actual enforcement effect$$, FALSE, 2),
    ($$The `DELETE` fails with an error -- `ON DELETE RESTRICT` blocks it outright while the link still exists$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'constraints-and-keys'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'constraints-and-keys')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$This project's real `CONSTRAINT uq_category_course_slug UNIQUE (course_id, slug)` allows two different courses to each have a category with the slug `fundamentals`. Why, according to this lesson?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$This project's real `CONSTRAINT uq_category_course_slug UNIQUE (course_id, slug)` allows two different courses to each have a category with the slug `fundamentals`. Why, according to this lesson?$$,
           NULL, NULL,
           $$The lesson explains a composite (table-level) UNIQUE only forbids duplicates across the combination of both columns -- two different courses are free to each have a category with the slug `fundamentals`, but the same course can't have two; this is genuinely different from two separate single-column UNIQUE constraints, which would each reject duplicates of that column alone.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'constraints-and-keys'
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
    ($$A composite UNIQUE only rejects duplicates of the combination of both columns -- the same `slug` under two different `course_id`s is not a duplicate$$, TRUE, 0),
    ($$It's a bug in this project's schema -- a composite UNIQUE was supposed to behave exactly like two separate single-column UNIQUE constraints$$, FALSE, 1),
    ($$`UNIQUE` constraints in PostgreSQL only apply to the first column listed, silently ignoring any additional columns$$, FALSE, 2),
    ($$The composite constraint only applies to rows inserted after the constraint was added, not to any table-level guarantee$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'constraints-and-keys'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'constraints-and-keys')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$This project's real `topic.estimated_minutes` column has no `CHECK` constraint today. According to this lesson, what does this mean in practice?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$This project's real `topic.estimated_minutes` column has no `CHECK` constraint today. According to this lesson, what does this mean in practice?$$,
           NULL, NULL,
           $$The lesson states this is a real, honest gap: nothing at the database level currently stops a migration from inserting a negative value into estimated_minutes -- only application-level care (and, so far, correct migrations) has kept every row valid; a CHECK constraint would turn that assumption into one PostgreSQL itself refuses to let a row violate.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'constraints-and-keys'
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
    ($$This column is described as being impossible to ever set to a negative value, by design of the BIGSERIAL type$$, FALSE, 0),
    ($$Nothing at the database level currently prevents a migration from inserting a negative `estimated_minutes` value -- only application-level care has kept rows valid so far$$, TRUE, 1),
    ($$PostgreSQL automatically infers a reasonable positive-only range for any INTEGER column, even without an explicit CHECK$$, FALSE, 2),
    ($$Hibernate enforces a positive-value rule on this column automatically, making a database-level CHECK unnecessary$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'constraints-and-keys'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'constraints-and-keys')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about constraints and keys, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about constraints and keys, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (the default behavior with no ON DELETE clause at all is effectively RESTRICT, blocking the delete; table-level constraints spanning more than one column, like uq_category_course_slug, are always named explicitly in this project because an auto-generated name is harder to recognize in an error message or a later DROP CONSTRAINT); the lesson explicitly says UNIQUE does NOT imply NOT NULL (a UNIQUE column can hold multiple NULLs), and a CHECK constraint can only see the current row's own values, not another table's data -- cross-table validation needs a trigger or application-level check instead.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'constraints-and-keys'
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
    ($$A `UNIQUE` constraint on a column automatically implies that column is also `NOT NULL`$$, FALSE, 0),
    ($$A `CHECK` constraint can reference and validate against another table's data, not just the current row's own values$$, FALSE, 1),
    ($$With no `ON DELETE` clause specified at all, the default behavior is effectively `RESTRICT` -- the delete is blocked$$, TRUE, 2),
    ($$This project always names table-level constraints spanning more than one column explicitly, rather than relying on an auto-generated name$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'constraints-and-keys'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
