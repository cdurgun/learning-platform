-- Links the EN for-loop questions to the topic's fixed quiz. Same NOT EXISTS /
-- ON CONFLICT DO NOTHING pattern as every prior quiz-link migration: each question is
-- found by its text (or created if missing) and linked at its position, so the file is
-- safe on a fresh database and on one where the promotion migration already ran.

-- Question 1/6 (pair 1 EN, quiz position 1, SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'for-loop')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$In `for (int i = 0; i < 5; i++)`, when does `i++` run?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$In `for (int i = 0; i < 5; i++)`, when does `i++` run?$$,
           NULL, NULL,
           $$The update part runs at the end of every iteration, after the body, and the condition is then checked again. Running once before the loop starts describes the initialization (`int i = 0`), not the update.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'for-loop'
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
        ($$At the end of every iteration, before the condition is checked again$$, TRUE, 0),
        ($$Once, before the loop starts$$, FALSE, 1),
        ($$At the start of every iteration, before the body$$, FALSE, 2),
        ($$Only when the condition becomes `false`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'for-loop'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (pair 2 EN, quiz position 2, MULTIPLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'for-loop')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of these can be written as the update part of a `for` loop to change the counter `i`? (Select all that apply)$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Which of these can be written as the update part of a `for` loop to change the counter `i`? (Select all that apply)$$,
           NULL, NULL,
           $$All three parts of a `for` are flexible: `i--` counts down and `i += 2` advances two at a time. `i++` is only the most common form, not the only one. `i + 1` merely computes a value without storing it, so it does not change `i`, and Java does not even accept it as a statement.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'for-loop'
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
        ($$`i + 1`, to advance one at a time$$, FALSE, 0),
        ($$Only `i++`; no other update expression compiles$$, FALSE, 1),
        ($$`i--`, to count down$$, TRUE, 2),
        ($$`i += 2`, to advance two at a time$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'for-loop'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (pair 3 EN, quiz position 3, CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'for-loop')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this code print?$$
      AND code_snippet = $$for (int i = 1; i <= 5; i++) {
    if (i == 3) {
        break;
    }
    System.out.println(i);
}

System.out.println("Done");$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does this code print?$$,
           $$for (int i = 1; i <= 5; i++) {
    if (i == 3) {
        break;
    }
    System.out.println(i);
}

System.out.println("Done");$$, $$java$$,
           $$When `i` reaches 3, `break` ends the loop immediately, even though `i <= 5` is still `true`, and control jumps to the line after the loop. So 3 is never printed and neither are 4 and 5. Skipping only 3 and carrying on with 4 and 5 is what `continue` would do.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'for-loop'
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
        ($$`1`, `2`, `4`, `5`, then `Done`$$, FALSE, 0),
        ($$`1`, `2`, then `Done`$$, TRUE, 1),
        ($$`1`, `2`, `3`, then `Done`$$, FALSE, 2),
        ($$`1`, then `2`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'for-loop'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (pair 4 EN, quiz position 4, CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'for-loop')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this code print?$$
      AND code_snippet = $$for (int i = 1; i <= 5; i++) {
    if (i % 2 == 0) {
        continue;
    }
    System.out.println(i);
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does this code print?$$,
           $$for (int i = 1; i <= 5; i++) {
    if (i % 2 == 0) {
        continue;
    }
    System.out.println(i);
}$$, $$java$$,
           $$For even values of `i`, `continue` skips the rest of that iteration, so `println` is not reached, and the loop moves on to the update step. The loop itself does not end, which is why 3 and 5 are still printed. Stopping after 1 is what `break` would do.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'for-loop'
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
        ($$`1`$$, FALSE, 0),
        ($$`2`, then `4`$$, FALSE, 1),
        ($$`1`, `2`, `3`, `4`, then `5`$$, FALSE, 2),
        ($$`1`, `3`, then `5`$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'for-loop'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (pair 5 EN, quiz position 5, SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'for-loop')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A loop is written as `for (;;)`. In normal control flow, what makes it stop?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A loop is written as `for (;;)`. In normal control flow, what makes it stop?$$,
           NULL, NULL,
           $$With all three parts left out there is no condition that could ever become `false`, so the loop does not end on its own. In normal control flow it is left through a `break` or a `return` in the body. Outside normal flow, an uncaught exception or the program exiting would end it as well. It is valid Java, used deliberately when you cannot know in advance when to stop.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'for-loop'
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
        ($$A `break` or a `return` in its body, since it has no condition that could end it$$, TRUE, 0),
        ($$Nothing has to, since the compiler rejects a `for` that has no condition$$, FALSE, 1),
        ($$Its hidden counter, which ends the loop once it reaches a built-in limit$$, FALSE, 2),
        ($$A `continue` in its body, since skipping a step also leaves the loop$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'for-loop'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (pair 6 EN, quiz position 6, SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'for-loop')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A loop over `int[] values` is written as `for (int i = 0; i <= values.length; i++)` and reads `values[i]` in its body. What goes wrong?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A loop over `int[] values` is written as `for (int i = 0; i <= values.length; i++)` and reads `values[i]` in its body. What goes wrong?$$,
           NULL, NULL,
           $$Valid indexes run from `0` to `length - 1`. With `<=`, the loop runs one extra time with `i` equal to `values.length`, an index that does not exist, and Java throws `ArrayIndexOutOfBoundsException`. The loop does end and every real element is read; the problem is the one read past the end.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'for-loop'
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
        ($$The last element of the array is never read$$, FALSE, 0),
        ($$The last iteration reads an index that does not exist and throws `ArrayIndexOutOfBoundsException`$$, TRUE, 1),
        ($$The loop never ends, because the condition stays `true`$$, FALSE, 2),
        ($$The code does not compile, because `<=` cannot be combined with `.length`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'for-loop'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
