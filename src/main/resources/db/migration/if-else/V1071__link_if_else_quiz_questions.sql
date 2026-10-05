-- Links the EN if-else questions to the topic's fixed quiz. Same NOT EXISTS /
-- ON CONFLICT DO NOTHING pattern as every prior quiz-link migration: each question is
-- found by its text (or created if missing) and linked at its position, so the file is
-- safe on a fresh database and on one where the promotion migration already ran.

-- Question 1/6 (pair 1 EN, quiz position 1, SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'if-else')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A developer coming from C writes `if (count)` in Java, where `count` is an `int`. What happens?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$A developer coming from C writes `if (count)` in Java, where `count` is an `int`. What happens?$$,
           NULL, NULL,
           $$Java only accepts a `boolean` expression as a condition and never converts a number to `boolean` implicitly, so `if (count)` is a compile error. Running the block whenever the value is nonzero is how C behaves; Java deliberately rejected that idiom.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'if-else'
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
        ($$The code does not compile, because the condition must be a `boolean` expression$$, TRUE, 0),
        ($$It compiles, and the block runs whenever `count` is not zero$$, FALSE, 1),
        ($$It compiles, but the block never runs because an `int` counts as `false`$$, FALSE, 2),
        ($$It compiles with a warning, and `count` is converted to `boolean` at runtime$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'if-else'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (pair 2 EN, quiz position 2, CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'if-else')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this code print?$$
      AND code_snippet = $$int score = 95;
String grade;

if (score >= 60) {
    grade = "D";
} else if (score >= 90) {
    grade = "A";
} else {
    grade = "F";
}

System.out.println(grade);$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does this code print?$$,
           $$int score = 95;
String grade;

if (score >= 60) {
    grade = "D";
} else if (score >= 90) {
    grade = "A";
} else {
    grade = "F";
}

System.out.println(grade);$$, $$java$$,
           $$Conditions are checked top to bottom and the first one that is `true` wins. `95 >= 60` is already `true`, so `grade` becomes `D` and the rest of the chain is skipped. `score >= 90` would also be `true`, but it is never evaluated, because the broader condition was written before the more specific one.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'if-else'
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
        ($$`A`$$, FALSE, 0),
        ($$`D`$$, TRUE, 1),
        ($$`F`$$, FALSE, 2),
        ($$Nothing, because the code does not compile$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'if-else'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (pair 3 EN, quiz position 3, CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'if-else')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this code print?$$
      AND code_snippet = $$int stock = 0;

if (stock > 0)
    System.out.println("In stock");
    System.out.println("Ships today");$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this code print?$$,
           $$int stock = 0;

if (stock > 0)
    System.out.println("In stock");
    System.out.println("Ships today");$$, $$java$$,
           $$Without braces, an `if` covers only the single statement right after it. The condition is `false`, so `In stock` is skipped, but the second `println` is not part of the `if` at all and always runs. The indentation only makes it look as if both lines belong to the condition.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'if-else'
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
        ($$Nothing is printed$$, FALSE, 0),
        ($$`In stock`, then `Ships today`$$, FALSE, 1),
        ($$`Ships today`$$, TRUE, 2),
        ($$`In stock`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'if-else'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (pair 4 EN, quiz position 4, MULTIPLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'if-else')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of these statements about `==` in Java are true? (Select all that apply)$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of these statements about `==` in Java are true? (Select all that apply)$$,
           NULL, NULL,
           $$`0.1 + 0.2 == 0.3` is `false` because binary floating point cannot store these decimals exactly, and for objects such as `String`, `==` compares references, which is why `.equals()` is used for content. For primitives like `int`, `==` compares the values themselves, and like every comparison operator it produces a `boolean`, so it works directly as a condition.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'if-else'
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
        ($$`0.1 + 0.2 == 0.3` evaluates to `false`$$, TRUE, 0),
        ($$For two `int` values, `==` compares references, not values$$, FALSE, 1),
        ($$`==` cannot be used directly as an `if` condition$$, FALSE, 2),
        ($$For two `String` objects, `==` compares references, not content$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'if-else'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (pair 5 EN, quiz position 5, SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'if-else')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$In `if (user != null && user.isActive())`, what happens when `user` is `null`?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$In `if (user != null && user.isActive())`, what happens when `user` is `null`?$$,
           NULL, NULL,
           $$`&&` is short-circuited: once the left side is `false`, the result is already known and the right side is never evaluated. That is exactly why this pattern is safe. If both sides were always evaluated, calling a method on `null` would throw a `NullPointerException`.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'if-else'
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
        ($$`user.isActive()` is called and throws a `NullPointerException`$$, FALSE, 0),
        ($$`user.isActive()` is never called, because the left side is already `false`$$, TRUE, 1),
        ($$Both sides are evaluated, and the combined result is `false`$$, FALSE, 2),
        ($$The code does not compile, because a method call cannot follow a `null` check$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'if-else'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (pair 6 EN, quiz position 6, SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'if-else')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why can a ternary operator appear on the right-hand side of an assignment, while an `if`/`else` cannot?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Why can a ternary operator appear on the right-hand side of an assignment, while an `if`/`else` cannot?$$,
           NULL, NULL,
           $$The ternary operator is an expression: it evaluates directly to a value, which can then be assigned. `if`/`else` is a statement and produces no value. Both need a `boolean` condition, so the type of the condition is not what separates them.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'if-else'
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
        ($$The ternary operator accepts any type as its condition, while `if`/`else` needs a `boolean`$$, FALSE, 0),
        ($$The ternary operator can check several conditions at once, while `if`/`else` checks only one$$, FALSE, 1),
        ($$The ternary operator is an expression that evaluates to a value, while `if`/`else` is a statement$$, TRUE, 2),
        ($$The ternary operator is evaluated at compile time, while `if`/`else` runs at runtime$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'if-else'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
