-- Promotion-style migration linking EN dynamic-queries-with-specifications quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dynamic-queries-with-specifications')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is a Specification<T>, precisely?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What is a Specification<T>, precisely?$$,
           NULL, NULL,
           $$A description of how to build one WHERE condition -- nothing runs until it's handed to a repository that extends JpaSpecificationExecutor.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dynamic-queries-with-specifications'
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
    ($$A description of how to build one WHERE condition -- nothing runs until it's handed to a repository$$, TRUE, 0),
    ($$A complete, already-executed query that returns results the moment it's created$$, FALSE, 1),
    ($$A native SQL string written directly against the schema$$, FALSE, 2),
    ($$A replacement for the entire JpaRepository interface$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dynamic-queries-with-specifications'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dynamic-queries-with-specifications')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is the relationship between Specification and JPA's Criteria API (Root, CriteriaBuilder, Predicate)?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What is the relationship between Specification and JPA's Criteria API (Root, CriteriaBuilder, Predicate)?$$,
           NULL, NULL,
           $$Specification is a thin, convenient wrapper around the Criteria API -- it doesn't replace it.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dynamic-queries-with-specifications'
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
    ($$Specification replaced the Criteria API entirely in modern Spring Data JPA$$, FALSE, 0),
    ($$Specification is a thin, convenient wrapper around the Criteria API -- it doesn't replace it$$, TRUE, 1),
    ($$Specification is a completely separate mechanism unrelated to the Criteria API$$, FALSE, 2),
    ($$The Criteria API is built on top of Specification, not the other way around$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dynamic-queries-with-specifications'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dynamic-queries-with-specifications')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What must a repository interface do to be able to accept a Specification at all?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What must a repository interface do to be able to accept a Specification at all?$$,
           NULL, NULL,
           $$It must extend JpaSpecificationExecutor<T> alongside JpaRepository<T, ID> -- without it, findAll(Specification) simply doesn't exist on the interface.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dynamic-queries-with-specifications'
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
    ($$It must be annotated with @EnableSpecifications at the class level$$, FALSE, 0),
    ($$It must implement a custom findAll(Specification) method by hand$$, FALSE, 1),
    ($$Nothing -- every JpaRepository accepts a Specification automatically by default$$, FALSE, 2),
    ($$It must extend JpaSpecificationExecutor<T> alongside JpaRepository<T, ID>$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dynamic-queries-with-specifications'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dynamic-queries-with-specifications')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this Specification chain produce?$$
      AND code_snippet = $$Specification<Topic> spec = Specification
        .where(hasCategory("spring-mvc"))
        .and(hasDifficulty("ADVANCED"));

repository.findAll(spec);$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this Specification chain produce?$$,
           $$Specification<Topic> spec = Specification
        .where(hasCategory("spring-mvc"))
        .and(hasDifficulty("ADVANCED"));

repository.findAll(spec);$$, $$java$$,
           $$A single combined WHERE condition requiring BOTH category = 'spring-mvc' AND difficulty = 'ADVANCED' at once, executed as one real SQL query.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dynamic-queries-with-specifications'
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
    ($$A single WHERE clause requiring BOTH category = 'spring-mvc' AND difficulty = 'ADVANCED' at once$$, TRUE, 0),
    ($$A WHERE clause matching EITHER condition, since .and(...) behaves like OR here$$, FALSE, 1),
    ($$Nothing runs at all until .or(...) is also called on the chain$$, FALSE, 2),
    ($$Two separate queries, one per condition, with results merged in Java afterward$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dynamic-queries-with-specifications'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dynamic-queries-with-specifications')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A request arrives with neither category nor difficulty supplied. What query does this code end up running?$$
      AND code_snippet = $$Specification<Topic> spec = Specification.where(null);
if (category != null)   spec = spec.and(hasCategory(category));
if (difficulty != null) spec = spec.and(hasDifficulty(difficulty));

Page<Topic> page = repository.findAll(spec, pageable);$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A request arrives with neither category nor difficulty supplied. What query does this code end up running?$$,
           $$Specification<Topic> spec = Specification.where(null);
if (category != null)   spec = spec.and(hasCategory(category));
if (difficulty != null) spec = spec.and(hasDifficulty(difficulty));

Page<Topic> page = repository.findAll(spec, pageable);$$, $$java$$,
           $$Since both category and difficulty are null, no .and(...) is ever added -- the query filters on nothing at all, returning every row (paged).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dynamic-queries-with-specifications'
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
    ($$A query that filters nothing at all, returning every row (paged)$$, TRUE, 0),
    ($$A query that throws a NullPointerException, since Specification.where(null) is invalid$$, FALSE, 1),
    ($$A query that matches nothing, returning an empty page$$, FALSE, 2),
    ($$A query filtered on category = null AND difficulty = null as literal SQL conditions$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dynamic-queries-with-specifications'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dynamic-queries-with-specifications')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are true about repository.findAll(spec, pageable)? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about repository.findAll(spec, pageable)? (Select all that apply)$$,
           NULL, NULL,
           $$It generates a filtered, paged query PLUS a filtered count query -- the same two-query shape as Page<T>, now with a dynamic WHERE clause.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dynamic-queries-with-specifications'
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
    ($$It requires a completely separate repository method for every possible combination of filters$$, FALSE, 0),
    ($$It generates a filtered, paged query plus a separate filtered count query$$, TRUE, 1),
    ($$Dynamic filtering and real pagination combine into a single repository call, not two separate steps$$, TRUE, 2),
    ($$It ignores the Specification entirely when a Pageable is also supplied$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dynamic-queries-with-specifications'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dynamic-queries-with-specifications')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following correctly describe when to reach for a Specification versus a derived query method or @Query? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe when to reach for a Specification versus a derived query method or @Query? (Select all that apply)$$,
           NULL, NULL,
           $$Derived methods and @Query are fixed at compile time; Specification earns its place once the set of active conditions genuinely isn't known until a request arrives. A small, fixed set of optional conditions can sometimes be expressed with a single JPQL :param IS NULL OR ... query instead.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dynamic-queries-with-specifications'
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
    ($$Dynamic filtering always needs a Specification -- there's no other way to express an optional condition$$, FALSE, 0),
    ($$A Specification should be the default choice for every repository query, regardless of whether filtering is dynamic$$, FALSE, 1),
    ($$A derived query method's conditions are fixed at compile time -- it can't express "filter by category, but only if supplied"$$, TRUE, 2),
    ($$Specification earns its place once the SET of active filter conditions genuinely isn't known until a request arrives$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dynamic-queries-with-specifications'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
