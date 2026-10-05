-- Links the EN enhanced-for-loop questions to the topic's fixed quiz. Same NOT EXISTS /
-- ON CONFLICT DO NOTHING pattern as every prior quiz-link migration: each question is
-- found by its text (or created if missing) and linked at its position, so the file is
-- safe on a fresh database and on one where the promotion migration already ran.

-- Question 1/5 (pair 1 EN, quiz position 1, SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'enhanced-for-loop')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$You need to print each element together with its position, such as `1: Ada`. What does an enhanced for loop give you to work with?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$You need to print each element together with its position, such as `1: Ada`. What does an enhanced for loop give you to work with?$$,
           NULL, NULL,
           $$Enhanced for hands you each element's value and nothing about where it sits. For output that includes the position you either keep a counter variable yourself or switch to a classic `for`, which has the index at every step. There is no built-in index variable to read.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'enhanced-for-loop'
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
        ($$Only each element's value; the position needs a manual counter or a classic `for`$$, TRUE, 0),
        ($$Both the value and the position, through a built-in `index` variable$$, FALSE, 1),
        ($$Only the position; the value is then read with `array[i]`$$, FALSE, 2),
        ($$Both, as long as the loop variable is declared as `int`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'enhanced-for-loop'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/5 (pair 2 EN, quiz position 2, CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'enhanced-for-loop')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this code print?$$
      AND code_snippet = $$int[] prices = {10, 20, 30};

for (int price : prices) {
    price = price * 2;
}

System.out.println(prices[0] + prices[1] + prices[2]);$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this code print?$$,
           $$int[] prices = {10, 20, 30};

for (int price : prices) {
    price = price * 2;
}

System.out.println(prices[0] + prices[1] + prices[2]);$$, $$java$$,
           $$The loop variable `price` is a copy of each element. Doubling it changes only that copy, so the array still holds 10, 20 and 30 and their sum is 60. A result of 120 would require writing back into the array, which needs an index and therefore a classic `for`.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'enhanced-for-loop'
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
        ($$`120`$$, FALSE, 0),
        ($$`60`$$, TRUE, 1),
        ($$`40`$$, FALSE, 2),
        ($$`30`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'enhanced-for-loop'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/5 (pair 3 EN, quiz position 3, SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'enhanced-for-loop')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What generally happens when `list.remove(...)` is called inside an enhanced for that is running over that same `List`?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What generally happens when `list.remove(...)` is called inside an enhanced for that is running over that same `List`?$$,
           NULL, NULL,
           $$Adding or removing elements changes the list's structure while the loop is still walking it, and the loop detects this by throwing `ConcurrentModificationException`. It is valid Java, so it compiles. Even the cases where no exception happens to be thrown are not safe: they silently produce a wrong result.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'enhanced-for-loop'
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
        ($$The element is removed and the loop safely continues with the next one$$, FALSE, 0),
        ($$The code does not compile$$, FALSE, 1),
        ($$`ConcurrentModificationException` is thrown$$, TRUE, 2),
        ($$The loop starts again from the first element$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'enhanced-for-loop'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/5 (pair 4 EN, quiz position 4, SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'enhanced-for-loop')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of these tasks requires a classic `for` rather than an enhanced for?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Which of these tasks requires a classic `for` rather than an enhanced for?$$,
           NULL, NULL,
           $$Changing an array in place means writing to a specific position, and only a classic `for` has the index for that. Summing, printing and finding a maximum only read the values, which is exactly the case where enhanced for is shorter and less error-prone.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'enhanced-for-loop'
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
        ($$Adding up all the elements of an array$$, FALSE, 0),
        ($$Printing every element of a `List`$$, FALSE, 1),
        ($$Finding the largest value in an array$$, FALSE, 2),
        ($$Doubling every element of an array in place$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'enhanced-for-loop'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/5 (pair 5 EN, quiz position 5, CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'enhanced-for-loop')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this code print?$$
      AND code_snippet = $$String[] names = {"Ada", "Bo"};
int[] scores = {90, 70};
int pairs = 0;

for (String name : names) {
    for (int score : scores) {
        pairs++;
    }
}

System.out.println(pairs);$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this code print?$$,
           $$String[] names = {"Ada", "Bo"};
int[] scores = {90, 70};
int pairs = 0;

for (String name : names) {
    for (int score : scores) {
        pairs++;
    }
}

System.out.println(pairs);$$, $$java$$,
           $$Nesting two enhanced for loops pairs every name with every score: 2 names times 2 scores gives 4 combinations. This is a cartesian product, not a parallel walk. Matching each name only with its own score, which would give 2, needs a classic `for` with one shared index.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'enhanced-for-loop'
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
        ($$`4`$$, TRUE, 0),
        ($$`2`$$, FALSE, 1),
        ($$`3`$$, FALSE, 2),
        ($$`1`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'enhanced-for-loop'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
