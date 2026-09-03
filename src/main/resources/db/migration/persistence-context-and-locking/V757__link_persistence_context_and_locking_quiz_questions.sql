-- Promotion-style migration linking EN persistence-context-and-locking quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'persistence-context-and-locking')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$An entity's transaction has just ended, so the persistence context no longer tracks it, but its field changes had already been made while it was tracked. What state is it in now?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$An entity's transaction has just ended, so the persistence context no longer tracks it, but its field changes had already been made while it was tracked. What state is it in now?$$,
           NULL, NULL,
           $$DETACHED -- the persistence context no longer tracks it, so further field changes are not written back automatically anymore.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'persistence-context-and-locking'
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
    ($$TRANSIENT$$, FALSE, 0),
    ($$MANAGED$$, FALSE, 1),
    ($$DETACHED$$, TRUE, 2),
    ($$REMOVED$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'persistence-context-and-locking'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'persistence-context-and-locking')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Within a single transaction, both of these calls execute. How many database queries actually run?$$
      AND code_snippet = $$Topic first = repository.findById(5L).get();
Topic second = repository.findById(5L).get();

System.out.println(first == second);$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Within a single transaction, both of these calls execute. How many database queries actually run?$$,
           $$Topic first = repository.findById(5L).get();
Topic second = repository.findById(5L).get();

System.out.println(first == second);$$, $$java$$,
           $$Only one query -- the first-level cache recognizes entity 5 is already being tracked and hands back the exact same instance for the second call, so first == second prints true.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'persistence-context-and-locking'
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
    ($$Zero queries -- Spring Data JPA never actually needs to hit the database for a findById call$$, FALSE, 0),
    ($$Two queries, and first == second prints false, since they're two separate object instances$$, FALSE, 1),
    ($$Two queries, but first == second still prints true, since Java always caches equal objects$$, FALSE, 2),
    ($$One query -- the second call is answered entirely from the first-level cache, and first == second prints true$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'persistence-context-and-locking'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'persistence-context-and-locking')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A detached entity, one that already has a real id but isn't currently tracked, needs to be re-attached and updated. Which operation is correct?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A detached entity, one that already has a real id but isn't currently tracked, needs to be re-attached and updated. Which operation is correct?$$,
           NULL, NULL,
           $$merge() -- it copies the object's field values onto a managed entity and returns THAT managed entity; persist() risks a duplicate-key error since it's meant for entities that never existed in the database.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'persistence-context-and-locking'
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
    ($$remove(), followed immediately by a fresh persist() with the same field values$$, FALSE, 0),
    ($$detach(), which automatically re-attaches the entity on the next query$$, FALSE, 1),
    ($$persist(), since it's the general-purpose way to bring any entity under management$$, FALSE, 2),
    ($$merge() -- it copies the object's field values onto a managed entity and returns that managed entity$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'persistence-context-and-locking'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'persistence-context-and-locking')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A field's value is changed on a managed entity, and then a JPQL query filtering on that same field runs, without flush() ever being called explicitly. What happens?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A field's value is changed on a managed entity, and then a JPQL query filtering on that same field runs, without flush() ever being called explicitly. What happens?$$,
           NULL, NULL,
           $$Hibernate auto-flushes before running a query whose result could be affected by pending changes, so the query's result reflects the change.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'persistence-context-and-locking'
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
    ($$The query's result ignores the change entirely, since it was never explicitly flushed$$, FALSE, 0),
    ($$The application throws an exception, since a pending change exists when the query runs$$, FALSE, 1),
    ($$The change is silently discarded, and the field reverts to its previous value$$, FALSE, 2),
    ($$The query's result reflects the change, since Hibernate auto-flushes before a query that could be affected by pending changes$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'persistence-context-and-locking'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'persistence-context-and-locking')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does adding @Version to an entity's field actually do?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does adding @Version to an entity's field actually do?$$,
           NULL, NULL,
           $$Hibernate manages it entirely on its own -- every UPDATE increments it, and every UPDATE's WHERE clause checks it still matches the value the entity was loaded with.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'persistence-context-and-locking'
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
    ($$It holds a real database lock on the row from the moment it's read until the transaction ends$$, FALSE, 0),
    ($$Hibernate increments it on every UPDATE, and every UPDATE's WHERE clause checks it still matches the loaded value$$, TRUE, 1),
    ($$It requires the application to manually increment it before every save call$$, FALSE, 2),
    ($$It prevents more than one transaction from reading the same row at the same time$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'persistence-context-and-locking'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'persistence-context-and-locking')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$loadedByUserA and loadedByUserB both load the same @Version-protected row at version = 3. User A saves first and succeeds, moving the row to version = 4. User B then tries to save, still believing the version is 3. What happens?$$
      AND code_snippet = $$// Both loaded at version = 3
userA.save(loadedByUserA); // succeeds, row is now version = 4
userB.save(loadedByUserB); // User B's WHERE clause still checks version = 3$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$loadedByUserA and loadedByUserB both load the same @Version-protected row at version = 3. User A saves first and succeeds, moving the row to version = 4. User B then tries to save, still believing the version is 3. What happens?$$,
           $$// Both loaded at version = 3
userA.save(loadedByUserA); // succeeds, row is now version = 4
userB.save(loadedByUserB); // User B's WHERE clause still checks version = 3$$, $$java$$,
           $$User B's UPDATE ... WHERE version = 3 now matches zero rows -- Spring Data JPA surfaces this as an OptimisticLockingFailureException rather than silently doing nothing or overwriting User A's change.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'persistence-context-and-locking'
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
    ($$Both saves are automatically merged field-by-field into one final row$$, FALSE, 0),
    ($$User B's save silently overwrites User A's change, with the row ending at User B's values$$, FALSE, 1),
    ($$User B's save throws an OptimisticLockingFailureException, since its WHERE ... AND version = 3 now matches nothing$$, TRUE, 2),
    ($$User B's save succeeds normally, since @Version only checks on the very first save of a row$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'persistence-context-and-locking'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'persistence-context-and-locking')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following correctly describe @Lock(LockModeType.PESSIMISTIC_WRITE)? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe @Lock(LockModeType.PESSIMISTIC_WRITE)? (Select all that apply)$$,
           NULL, NULL,
           $$It adds a real database-level lock at read time (PostgreSQL's SELECT ... FOR UPDATE), making other transactions wait -- reach for it for genuinely high-contention operations, not as a default in place of optimistic locking.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'persistence-context-and-locking'
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
    ($$It should be the default locking strategy in place of @Version for every entity$$, FALSE, 0),
    ($$It detects a collision after it happens, the same way @Version does$$, FALSE, 1),
    ($$It adds a real database-level lock at read time, using PostgreSQL's SELECT ... FOR UPDATE$$, TRUE, 2),
    ($$Any other transaction trying to acquire the same lock on the same row simply waits until this one commits or rolls back$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'persistence-context-and-locking'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
