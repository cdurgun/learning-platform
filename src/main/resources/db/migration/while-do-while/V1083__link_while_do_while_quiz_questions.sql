-- Links the EN while-do-while questions to the topic's fixed quiz. Same NOT EXISTS /
-- ON CONFLICT DO NOTHING pattern as every prior quiz-link migration: each question is
-- found by its text (or created if missing) and linked at its position, so the file is
-- safe on a fresh database and on one where the promotion migration already ran.

-- Question 1/5 (pair 1 EN, quiz position 1, SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'while-do-while')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$When is `while` a better fit than `for`?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$When is `while` a better fit than `for`?$$,
           NULL, NULL,
           $$`for` bundles initialization, condition and increment because those usually belong to a counter. When the repetition is about a state, such as retrying until a connection succeeds, there is only a condition, and `while` expresses that directly. A known number of iterations is exactly the case `for` was made for.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'while-do-while'
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
        ($$When the repetition depends on a state or condition rather than on a counter$$, TRUE, 0),
        ($$When the number of iterations is known in advance$$, FALSE, 1),
        ($$When the loop needs `break` or `continue` in its body$$, FALSE, 2),
        ($$When the body has to run at least once$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'while-do-while'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/5 (pair 2 EN, quiz position 2, CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'while-do-while')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this code print?$$
      AND code_snippet = $$int n = 10;
int steps = 0;

while (n > 1) {
    n = n / 2;
    steps++;
}

System.out.println(steps);$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does this code print?$$,
           $$int n = 10;
int steps = 0;

while (n > 1) {
    n = n / 2;
    steps++;
}

System.out.println(steps);$$, $$java$$,
           $$The body runs while `n > 1`: integer division takes `n` from 10 to 5, then to 2, then to 1, counting three steps. With `n` equal to 1 the condition is `false` and the loop stops. A fourth step would need the condition to be checked after the body, which is how `do-while` works, not `while`.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'while-do-while'
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
        ($$`2`$$, FALSE, 0),
        ($$`3`$$, TRUE, 1),
        ($$`4`$$, FALSE, 2),
        ($$`5`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'while-do-while'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/5 (pair 3 EN, quiz position 3, SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'while-do-while')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which task is the most natural fit for `do-while` rather than `while`?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Which task is the most natural fit for `do-while` rather than `while`?$$,
           NULL, NULL,
           $$`do-while` checks its condition after the body, so the body always runs at least once. Input validation needs exactly that: the value cannot be checked before it has been read. A queue that may already be empty is the opposite case, where the body should be able to run zero times.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'while-do-while'
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
        ($$Processing a queue that may already be empty$$, FALSE, 0),
        ($$Repeating a block exactly ten times$$, FALSE, 1),
        ($$Asking the user for a value until it is valid$$, TRUE, 2),
        ($$Reading every element of an array of known size$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'while-do-while'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/5 (pair 4 EN, quiz position 4, CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'while-do-while')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this code print?$$
      AND code_snippet = $$int count = 5;

while (count < 3) {
    System.out.println("while: " + count);
    count++;
}

do {
    System.out.println("do-while: " + count);
    count++;
} while (count < 3);$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this code print?$$,
           $$int count = 5;

while (count < 3) {
    System.out.println("while: " + count);
    count++;
}

do {
    System.out.println("do-while: " + count);
    count++;
} while (count < 3);$$, $$java$$,
           $$`count < 3` is `false` from the start. `while` checks before the body, so its body never runs and `count` stays 5. `do-while` checks after the body, so its body runs once and prints `do-while: 5` before the condition ends the loop. That zero-times versus one-time difference is the only thing separating the two loops.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'while-do-while'
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
        ($$`while: 5`, then `do-while: 6`$$, FALSE, 0),
        ($$`while: 5`$$, FALSE, 1),
        ($$Nothing is printed$$, FALSE, 2),
        ($$`do-while: 5`$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'while-do-while'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/5 (pair 5 EN, quiz position 5, MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'while-do-while')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of these are real mistakes when writing `while` and `do-while` loops? (Select all that apply)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of these are real mistakes when writing `while` and `do-while` loops? (Select all that apply)$$,
           NULL, NULL,
           $$If nothing in the body updates the variable the condition depends on, the condition never changes and the loop runs forever. A `do-while` must end with `} while (condition);`, and leaving out that `;` is a compile error. Using `break`, or writing a `while` whose body may run zero times, are both normal and often exactly what is intended.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'while-do-while'
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
        ($$Never updating the variable the condition depends on$$, TRUE, 0),
        ($$Ending a `while` loop early with `break`$$, FALSE, 1),
        ($$Leaving out the `;` after `while (condition)` at the end of a `do-while`$$, TRUE, 2),
        ($$Writing a `while` whose body may run zero times$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'while-do-while'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
