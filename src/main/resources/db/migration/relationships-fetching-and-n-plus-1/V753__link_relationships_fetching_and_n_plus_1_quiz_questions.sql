-- Promotion-style migration linking EN relationships-fetching-and-n-plus-1 quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Does @OneToMany(mappedBy = "category") add its own foreign-key column to the database?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Does @OneToMany(mappedBy = "category") add its own foreign-key column to the database?$$,
           NULL, NULL,
           $$No -- it's the mirror image of an existing @ManyToOne; the foreign key still lives only on the owning (@ManyToOne) side's table.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'relationships-fetching-and-n-plus-1'
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
    ($$No -- it's the mirror image of an existing @ManyToOne, adding no column of its own$$, TRUE, 0),
    ($$Yes -- it adds a foreign-key column on the "one" side's own table$$, FALSE, 1),
    ($$Yes -- it creates an entirely separate join table automatically$$, FALSE, 2),
    ($$It depends on whether cascade is also specified$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'relationships-fetching-and-n-plus-1'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$When should an explicit join entity (like this project's real QuizQuestion) be preferred over a plain @ManyToMany with @JoinTable?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$When should an explicit join entity (like this project's real QuizQuestion) be preferred over a plain @ManyToMany with @JoinTable?$$,
           NULL, NULL,
           $$A plain @ManyToMany join table has no room for data ABOUT the relationship itself -- an explicit join entity is needed the moment the relationship needs to carry more than just the link.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'relationships-fetching-and-n-plus-1'
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
    ($$Only when performance profiling shows @ManyToMany is measurably slower$$, FALSE, 0),
    ($$The moment the relationship itself needs to carry its own data, like a position column$$, TRUE, 1),
    ($$Never -- @ManyToMany with @JoinTable is always the superior choice in every scenario$$, FALSE, 2),
    ($$Only when the two related entities have the exact same number of fields$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'relationships-fetching-and-n-plus-1'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: MULTIPLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following correctly distinguish cascade from orphanRemoval? (Select all that apply)$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly distinguish cascade from orphanRemoval? (Select all that apply)$$,
           NULL, NULL,
           $$cascade propagates an explicit save/delete on the parent to its children; orphanRemoval deletes a child specifically because it was removed from its parent's collection, with no explicit delete on the child at all.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'relationships-fetching-and-n-plus-1'
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
    ($$cascade and orphanRemoval are simply two different names for the exact same mechanism$$, FALSE, 0),
    ($$orphanRemoval requires CascadeType.REMOVE to also be set before it has any effect at all$$, FALSE, 1),
    ($$cascade propagates an explicit save/delete operation performed on the parent to its children$$, TRUE, 2),
    ($$orphanRemoval deletes a child specifically because it was removed from its parent's collection, with no explicit delete on the child$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'relationships-fetching-and-n-plus-1'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$How many total queries does this code run against a database with 7 Category rows?$$
      AND code_snippet = $$for (Category c : categoryRepository.findAll()) {
    System.out.println(c.getName() + ": " + c.getTopics().size());
    // getTopics() is a lazy @OneToMany
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$How many total queries does this code run against a database with 7 Category rows?$$,
           $$for (Category c : categoryRepository.findAll()) {
    System.out.println(c.getName() + ": " + c.getTopics().size());
    // getTopics() is a lazy @OneToMany
}$$, $$java$$,
           $$1 query to fetch the categories, plus 1 more query per category when the lazy getTopics() is accessed inside the loop -- 1+7=8 total.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'relationships-fetching-and-n-plus-1'
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
    ($$7 -- one query per category, with no separate query for the categories themselves$$, FALSE, 0),
    ($$8 -- 1 query for the categories, plus 1 more per category when getTopics() is accessed in the loop$$, TRUE, 1),
    ($$14 -- 2 queries per category, one for the name and one for the topics$$, FALSE, 2),
    ($$1 -- a single query fetches everything needed, including every category's topics$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'relationships-fetching-and-n-plus-1'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$How does adding @EntityGraph(attributePaths = "topics") to findAll() change the query count for the same 7-category loop from before?$$
      AND code_snippet = $$@EntityGraph(attributePaths = "topics")
List<Category> findAll();$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$How does adding @EntityGraph(attributePaths = "topics") to findAll() change the query count for the same 7-category loop from before?$$,
           $$@EntityGraph(attributePaths = "topics")
List<Category> findAll();$$, $$java$$,
           $$findAll() now runs ONE query, with topics already joined in -- down from the 1+7=8 queries of the unfixed N+1 example.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'relationships-fetching-and-n-plus-1'
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
    ($$It has no effect on query count -- @EntityGraph only changes which fields get selected, not how many queries run$$, FALSE, 0),
    ($$It runs exactly ONE query, with topics already joined in, instead of 1+7=8$$, TRUE, 1),
    ($$It runs 7 queries -- one batched query per category, grouped by @EntityGraph$$, FALSE, 2),
    ($$It requires switching findAll() to a native query before it has any effect$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'relationships-fetching-and-n-plus-1'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$With 7 categories and @BatchSize(size = 20) on the lazy topics collection, how many total queries does the previous loop run?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$With 7 categories and @BatchSize(size = 20) on the lazy topics collection, how many total queries does the previous loop run?$$,
           NULL, NULL,
           $$1+1=2: one query for the categories, one batched query covering every category's topics together (via a single WHERE category_id IN (...)), since 7 fits within the batch size of 20.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'relationships-fetching-and-n-plus-1'
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
    ($$1 -- @BatchSize eliminates every extra query entirely, identical to @EntityGraph$$, FALSE, 0),
    ($$1+7=8 -- @BatchSize has no actual effect on the query count$$, FALSE, 1),
    ($$1+1=2 -- one query for the categories, one batched query covering all 7 categories' topics together$$, TRUE, 2),
    ($$1+20=21 -- one query per configured batch size slot, regardless of actual category count$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'relationships-fetching-and-n-plus-1'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following correctly match an N+1 fix to the situation it best suits? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly match an N+1 fix to the situation it best suits? (Select all that apply)$$,
           NULL, NULL,
           $$@EntityGraph suits a single, specific query that always needs the relationship. Batch fetching suits a relationship touched by many different queries. A projection is the cheapest fix, suited to a query that never needed the relationship's data at all.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'relationships-fetching-and-n-plus-1'
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
    ($$Batch fetching is the right choice specifically when only one query ever touches the relationship$$, FALSE, 0),
    ($$cascade is one of the four fixes for N+1, alongside @EntityGraph, batch fetching, and projections$$, FALSE, 1),
    ($$@EntityGraph suits a single, specific query that always needs the relationship$$, TRUE, 2),
    ($$A projection is the cheapest fix, suited to a query that never needed the relationship's data to begin with$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'relationships-fetching-and-n-plus-1'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
