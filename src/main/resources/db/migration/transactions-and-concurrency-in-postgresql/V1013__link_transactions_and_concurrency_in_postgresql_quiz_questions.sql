-- Promotion-style migration linking EN transactions-and-concurrency-in-postgresql quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.


-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'transactions-and-concurrency-in-postgresql')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$After `BEGIN; UPDATE topic SET estimated_minutes = 999 WHERE slug = 'joins'; ROLLBACK;`, what is true of that UPDATE as far as any other session is concerned?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$After `BEGIN; UPDATE topic SET estimated_minutes = 999 WHERE slug = 'joins'; ROLLBACK;`, what is true of that UPDATE as far as any other session is concerned?$$,
           NULL, NULL,
           $$The lesson states ROLLBACK discards the transaction entirely, as if it never ran -- the UPDATE was real and readable within the transaction, then completely undone, with no partial trace left behind, as far as any other session is concerned.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'transactions-and-concurrency-in-postgresql'
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
    ($$It never happened -- `ROLLBACK` discards it entirely, with no partial trace left behind$$, TRUE, 0),
    ($$It is partially applied, with some but not all of its effects surviving$$, FALSE, 1),
    ($$It is applied immediately but flagged for cleanup by a later background process$$, FALSE, 2),
    ($$It never even executed in the first place, since `BEGIN` prevents any statement from running until `COMMIT`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'transactions-and-concurrency-in-postgresql'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'transactions-and-concurrency-in-postgresql')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why did every single-statement `INSERT` in this project's real Flyway migrations never need an explicit `BEGIN`/`COMMIT`, according to this lesson?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Why did every single-statement `INSERT` in this project's real Flyway migrations never need an explicit `BEGIN`/`COMMIT`, according to this lesson?$$,
           NULL, NULL,
           $$The lesson explains PostgreSQL wraps any statement not inside an explicit transaction in an implicit one of its own, committing it immediately if it succeeds -- this is autocommit, and it's why every single-statement migration already ran as its own single-statement transaction.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'transactions-and-concurrency-in-postgresql'
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
    ($$`INSERT` statements never require any transaction, under any relational database system$$, FALSE, 0),
    ($$PostgreSQL wraps any statement outside an explicit transaction in an implicit one, committing it immediately if it succeeds$$, TRUE, 1),
    ($$Flyway migrations are described as being exempt from transactional behavior entirely$$, FALSE, 2),
    ($$Flyway itself performs the actual `COMMIT` outside of PostgreSQL, before the statement even reaches the database$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'transactions-and-concurrency-in-postgresql'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'transactions-and-concurrency-in-postgresql')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does MVCC's "PostgreSQL never overwrites a row in place when it's updated" actually mean, according to this lesson?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does MVCC's "PostgreSQL never overwrites a row in place when it's updated" actually mean, according to this lesson?$$,
           NULL, NULL,
           $$The lesson explains MVCC means PostgreSQL writes a new version of the row and marks the old version as superseded, keeping both around until nothing could possibly still need the old one -- tracked via hidden xmin/xmax system columns.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'transactions-and-concurrency-in-postgresql'
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
    ($$PostgreSQL locks the row until every currently open transaction finishes, and only then physically overwrites it$$, FALSE, 0),
    ($$PostgreSQL records the update in a separate log file, leaving the actual table's row completely untouched$$, FALSE, 1),
    ($$PostgreSQL writes a new version of the row and marks the old one as superseded, keeping both until nothing needs the old one$$, TRUE, 2),
    ($$PostgreSQL immediately deletes the old row entirely and replaces it with a completely unrelated new row$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'transactions-and-concurrency-in-postgresql'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'transactions-and-concurrency-in-postgresql')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Session A begins a transaction and updates a row, but has not committed. Session B, concurrently, reads that same row. According to this lesson, does Session B block, and what does it see?$$
      AND code_snippet = $$-- Session A
BEGIN;
UPDATE topic SET estimated_minutes = 999 WHERE slug = 'joins';
-- not committed yet

-- Session B, concurrently
SELECT estimated_minutes FROM topic WHERE slug = 'joins';$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Session A begins a transaction and updates a row, but has not committed. Session B, concurrently, reads that same row. According to this lesson, does Session B block, and what does it see?$$,
           $$-- Session A
BEGIN;
UPDATE topic SET estimated_minutes = 999 WHERE slug = 'joins';
-- not committed yet

-- Session B, concurrently
SELECT estimated_minutes FROM topic WHERE slug = 'joins';$$, $$sql$$,
           $$The lesson explicitly states readers never block writers, and writers never block readers, in PostgreSQL -- Session B's SELECT doesn't block, and it sees the row version as it existed before Session A's uncommitted change, since a transaction only sees committed data (or its own uncommitted changes).$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'transactions-and-concurrency-in-postgresql'
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
    ($$Session B blocks until Session A commits or rolls back, since MVCC still requires readers to wait for writers$$, FALSE, 0),
    ($$Session B does not block, but sees `999` immediately, even though Session A hasn't committed$$, FALSE, 1),
    ($$Session B's query fails outright with a "row is locked" error$$, FALSE, 2),
    ($$Session B does not block, and sees the original (pre-update) value, since it can't see Session A's uncommitted change$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'transactions-and-concurrency-in-postgresql'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'transactions-and-concurrency-in-postgresql')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to this lesson's "A Real FOR UPDATE Scenario," what real problem does wrapping a read-then-write in `SELECT ... FOR UPDATE` prevent?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$According to this lesson's "A Real FOR UPDATE Scenario," what real problem does wrapping a read-then-write in `SELECT ... FOR UPDATE` prevent?$$,
           NULL, NULL,
           $$The lesson explains without FOR UPDATE, two concurrent transactions could both read the same value, both compute the same "next" value independently, and both write it -- a lost update, since the second write silently overwrites the first without either transaction knowing the other happened.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'transactions-and-concurrency-in-postgresql'
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
    ($$A lost update -- two concurrent transactions both computing the same "next" value, with the second write silently overwriting the first$$, TRUE, 0),
    ($$A deadlock between the two concurrent transactions attempting the same operation$$, FALSE, 1),
    ($$A SQL syntax error that occurs when two transactions run the identical `UPDATE` statement at the same time$$, FALSE, 2),
    ($$Permanent data loss from disk following an unexpected server crash$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'transactions-and-concurrency-in-postgresql'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'transactions-and-concurrency-in-postgresql')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given this sequence producing a deadlock, what does PostgreSQL do once it detects the cyclic wait?$$
      AND code_snippet = $$-- Session A
BEGIN;
UPDATE topic SET estimated_minutes = 1 WHERE slug = 'joins';

-- Session B, concurrently
BEGIN;
UPDATE topic SET estimated_minutes = 1 WHERE slug = 'aggregation-and-group-by';

-- Session A, next
UPDATE topic SET estimated_minutes = 2 WHERE slug = 'aggregation-and-group-by';
-- blocks, waiting for Session B's lock

-- Session B, next
UPDATE topic SET estimated_minutes = 2 WHERE slug = 'joins';
-- would also block, waiting for Session A's lock$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given this sequence producing a deadlock, what does PostgreSQL do once it detects the cyclic wait?$$,
           $$-- Session A
BEGIN;
UPDATE topic SET estimated_minutes = 1 WHERE slug = 'joins';

-- Session B, concurrently
BEGIN;
UPDATE topic SET estimated_minutes = 1 WHERE slug = 'aggregation-and-group-by';

-- Session A, next
UPDATE topic SET estimated_minutes = 2 WHERE slug = 'aggregation-and-group-by';
-- blocks, waiting for Session B's lock

-- Session B, next
UPDATE topic SET estimated_minutes = 2 WHERE slug = 'joins';
-- would also block, waiting for Session A's lock$$, $$sql$$,
           $$The lesson explains PostgreSQL actively detects this cycle rather than letting both sessions wait forever -- one transaction (the "victim," typically whichever would be cheaper to roll back) gets a real "deadlock detected" error and is automatically rolled back, freeing its locks so the other transaction can proceed.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'transactions-and-concurrency-in-postgresql'
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
    ($$Both transactions are silently rolled back at the same time, with no error reported to either session$$, FALSE, 0),
    ($$One transaction gets a "deadlock detected" error and is automatically rolled back, freeing its locks for the other$$, TRUE, 1),
    ($$Both transactions wait indefinitely until a database administrator manually intervenes$$, FALSE, 2),
    ($$PostgreSQL automatically merges the two transactions' updates into a single, combined transaction$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'transactions-and-concurrency-in-postgresql'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'transactions-and-concurrency-in-postgresql')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about transactions and concurrency, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about transactions and concurrency, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (SELECT ... FOR UPDATE locks only the specific rows it returns, not the whole table -- MVCC means ordinary reads never lock anything for anyone; the fix for this lesson's deadlock example is a coding discipline -- always acquiring locks on multiple rows in the same, consistent order -- not a database configuration setting); the lesson explicitly says MVCC reduces how often locks are needed but genuine write-write conflicts on the same row still need row-level locking (MVCC doesn't eliminate the need for locks entirely), and it says a transaction a client simply disconnects from also gets rolled back automatically, not left in limbo.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'transactions-and-concurrency-in-postgresql'
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
    ($$MVCC means PostgreSQL never needs row-level locks for any purpose whatsoever$$, FALSE, 0),
    ($$An uncommitted transaction whose client simply disconnects is left in an indeterminate state, neither committed nor rolled back$$, FALSE, 1),
    ($$`SELECT ... FOR UPDATE` locks only the specific rows it returns, not the entire table$$, TRUE, 2),
    ($$The fix for this lesson's deadlock example is a coding discipline -- always locking multiple rows in the same, consistent order -- not a database setting$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'transactions-and-concurrency-in-postgresql'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
