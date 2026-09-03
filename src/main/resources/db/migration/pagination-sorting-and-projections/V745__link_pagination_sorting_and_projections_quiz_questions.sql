-- Promotion-style migration linking EN pagination-sorting-and-projections quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'pagination-sorting-and-projections')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A repository method's return type is changed from List<Topic> to Page<Topic>. What actually happens underneath?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$A repository method's return type is changed from List<Topic> to Page<Topic>. What actually happens underneath?$$,
           NULL, NULL,
           $$Spring Data JPA generates a query with a real LIMIT/OFFSET, plus a second query counting the total matching rows.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'pagination-sorting-and-projections'
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
    ($$Spring Data JPA generates a query with LIMIT/OFFSET, plus a separate query counting the total matching rows$$, TRUE, 0),
    ($$Nothing changes underneath -- Page is just a wrapper class around the exact same single query$$, FALSE, 1),
    ($$Spring Data JPA fetches every row and then discards the ones outside the requested page in Java$$, FALSE, 2),
    ($$The method now requires a Pageable parameter to be added manually before it will compile$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'pagination-sorting-and-projections'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'pagination-sorting-and-projections')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Where does a repository's findAll(Sort sort) method actually come from?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Where does a repository's findAll(Sort sort) method actually come from?$$,
           NULL, NULL,
           $$It's inherited directly from PagingAndSortingRepository -- no new method needs to be written in the interface at all.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'pagination-sorting-and-projections'
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
    ($$It comes from JpaSpecificationExecutor, not the base repository hierarchy$$, FALSE, 0),
    ($$It's inherited directly from PagingAndSortingRepository, needing no declaration in the interface$$, TRUE, 1),
    ($$It must be declared explicitly in every repository interface that needs sorting$$, FALSE, 2),
    ($$It's generated fresh, from scratch, for each repository based on its entity's fields$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'pagination-sorting-and-projections'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'pagination-sorting-and-projections')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given this Pageable construction, does the repository method it's passed to need a separate Sort parameter as well?$$
      AND code_snippet = $$Pageable pageable = PageRequest.of(1, 5, Sort.by("slug"));
Page<Topic> result = repository.findByDifficulty("ADVANCED", pageable);$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given this Pageable construction, does the repository method it's passed to need a separate Sort parameter as well?$$,
           $$Pageable pageable = PageRequest.of(1, 5, Sort.by("slug"));
Page<Topic> result = repository.findByDifficulty("ADVANCED", pageable);$$, $$java$$,
           $$No -- a Pageable already carries its own embedded Sort; PageRequest.of(page, size, sort) already bundles ordering into it.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'pagination-sorting-and-projections'
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
    ($$It depends on whether the method is a derived query or written with @Query$$, FALSE, 0),
    ($$Yes, but only when the entity has more than one sortable field$$, FALSE, 1),
    ($$Yes -- Pageable and Sort are always two separate arguments that must both be supplied$$, FALSE, 2),
    ($$No -- a Pageable already carries its own embedded Sort, so a separate Sort parameter isn't needed$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'pagination-sorting-and-projections'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'pagination-sorting-and-projections')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does declaring an interface projection like TopicSummary (with getSlug()/getDifficulty()) actually change about the generated SQL?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does declaring an interface projection like TopicSummary (with getSlug()/getDifficulty()) actually change about the generated SQL?$$,
           NULL, NULL,
           $$Spring Data JPA generates a SQL SELECT naming only those specific columns, not every column the full entity would require.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'pagination-sorting-and-projections'
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
    ($$It generates a SQL SELECT naming only the columns the interface's getters correspond to$$, TRUE, 0),
    ($$It forces the query to run as a native query instead of JPQL$$, FALSE, 1),
    ($$It disables lazy loading entirely for every field of the underlying entity$$, FALSE, 2),
    ($$Nothing at the SQL level -- it only reduces how much Java code needs to be written$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'pagination-sorting-and-projections'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'pagination-sorting-and-projections')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why does this projection need a constructor-expression (select new ...) rather than a simple interface projection?$$
      AND code_snippet = $$record TopicTitleView(String slug, String title) {}

@Query("select new com.example.TopicTitleView(tt.topic.slug, tt.title) " +
       "from TopicTranslation tt where tt.language = :language")
List<TopicTitleView> findAllTitles(String language);$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Why does this projection need a constructor-expression (select new ...) rather than a simple interface projection?$$,
           $$record TopicTitleView(String slug, String title) {}

@Query("select new com.example.TopicTitleView(tt.topic.slug, tt.title) " +
       "from TopicTranslation tt where tt.language = :language")
List<TopicTitleView> findAllTitles(String language);$$, $$java$$,
           $$The fields span a relationship (tt.topic.slug comes from a different entity than tt.title) -- an interface projection only works for a straightforward subset of ONE entity's own getters.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'pagination-sorting-and-projections'
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
    ($$Because interface projections are entirely deprecated in modern Spring Data JPA$$, FALSE, 0),
    ($$Because the fields span a relationship -- slug comes from Topic, title from TopicTranslation -- which a plain interface projection can't express$$, TRUE, 1),
    ($$Because records can never be used as any kind of projection$$, FALSE, 2),
    ($$Because the query returns more than one row$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'pagination-sorting-and-projections'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'pagination-sorting-and-projections')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following correctly describe the real benefit of a projection? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe the real benefit of a projection? (Select all that apply)$$,
           NULL, NULL,
           $$A projection narrows the generated SQL SELECT itself, fetching fewer columns -- not merely producing a smaller Java type.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'pagination-sorting-and-projections'
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
    ($$It always requires switching the query to nativeQuery = true$$, FALSE, 0),
    ($$It narrows the SQL SELECT itself, fetching fewer columns from the database$$, TRUE, 1),
    ($$It avoids the overhead of managing a full entity for data that will only ever be read$$, TRUE, 2),
    ($$Its only real benefit is writing less Java code, with no effect on the generated SQL$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'pagination-sorting-and-projections'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'pagination-sorting-and-projections')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A single method findByDifficulty(String difficulty, Pageable pageable) is called with a Pageable built via PageRequest.of(page, size, sort). How many distinct concerns does this ONE method call handle at once?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$A single method findByDifficulty(String difficulty, Pageable pageable) is called with a Pageable built via PageRequest.of(page, size, sort). How many distinct concerns does this ONE method call handle at once?$$,
           NULL, NULL,
           $$Three: filtering (difficulty), paging, and ordering -- all bundled into a single, unremarkable method signature.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'pagination-sorting-and-projections'
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
    ($$Three -- filtering, paging, and ordering, all handled by this single method call$$, TRUE, 0),
    ($$Four -- filtering, paging, ordering, and projection, all in one call$$, FALSE, 1),
    ($$One -- only filtering, since Pageable is unrelated to sorting$$, FALSE, 2),
    ($$Two -- filtering and paging only, sorting requires a separate call$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'pagination-sorting-and-projections'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
