-- Links the EN react-performance questions to the topic's fixed quiz. Same NOT EXISTS /
-- ON CONFLICT DO NOTHING pattern as every prior quiz-link migration: each question is
-- found by its text (or created if missing) and linked at its position, so the file is
-- safe on a fresh database and on one where the promotion migration already ran.

-- Question 1/4 (pair 1 EN, quiz position 1, SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-performance')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A parent re-renders because its `count` state changed. Its child receives only an `items` prop, which did not change. By default, what happens to the child?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A parent re-renders because its `count` state changed. Its child receives only an `items` prop, which did not change. By default, what happens to the child?$$,
           NULL, NULL,
           $$By default React re-renders all children of a component that re-renders, whether or not their props changed. Skipping a child whose props are unchanged is not the default behavior; it is what wrapping the child in `memo()` adds.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'react-performance'
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
        ($$It re-renders anyway$$, TRUE, 0),
        ($$It is skipped, since its props did not change$$, FALSE, 1),
        ($$It re-renders only if `items` is a long list$$, FALSE, 2),
        ($$It is removed and created again from scratch$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-performance'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/4 (pair 2 EN, quiz position 2, SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-performance')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does React do before re-rendering a component wrapped in `memo()`?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$What does React do before re-rendering a component wrapped in `memo()`?$$,
           NULL, NULL,
           $$React compares the new props with the props from the last render, using a shallow comparison, and skips the render if they are the same. It does not look inside nested objects, and it does not render first and throw the result away.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'react-performance'
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
        ($$It deeply compares every nested object in the new and previous props$$, FALSE, 0),
        ($$It shallowly compares the new props with the previous ones and skips the render if they match$$, TRUE, 1),
        ($$It renders once more and discards the result if nothing changed$$, FALSE, 2),
        ($$It checks whether the parent's state changed since the last render$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-performance'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/4 (pair 3 EN, quiz position 3, SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-performance')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A `memo`-wrapped child receives a function that its parent defines during render. Why does the child still re-render every time?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$A `memo`-wrapped child receives a function that its parent defines during render. Why does the child still re-render every time?$$,
           NULL, NULL,
           $$Without `useCallback`, a new function is created on every render. Functions are values too, so `memo` sees a different prop and re-renders. `useCallback` keeps the same function reference as long as its dependencies have not changed.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'react-performance'
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
        ($$`memo` never has any effect on a component that receives a function$$, FALSE, 0),
        ($$Function props are compared by their source text, which always differs$$, FALSE, 1),
        ($$A new function is created on every render, so `memo` sees a changed prop$$, TRUE, 2),
        ($$Defining a function during render makes the parent render twice$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-performance'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/4 (pair 4 EN, quiz position 4, SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-performance')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A component sorts a `courses` list inside `useMemo`, with `courses` as its dependency. When does the sort run again?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$A component sorts a `courses` list inside `useMemo`, with `courses` as its dependency. When does the sort run again?$$,
           NULL, NULL,
           $$The calculation runs again only when `courses` changes. If the component re-renders for some other reason, such as an unrelated counter changing, the cached result is reused and the expensive sort is not repeated.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'react-performance'
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
        ($$On every render of the component$$, FALSE, 0),
        ($$Whenever any state of the component changes$$, FALSE, 1),
        ($$Only once, when the component first appears$$, FALSE, 2),
        ($$Only when `courses` changes$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-performance'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
