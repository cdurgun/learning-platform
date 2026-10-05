-- Links the EN switch questions to the topic's fixed quiz. Same NOT EXISTS /
-- ON CONFLICT DO NOTHING pattern as every prior quiz-link migration: each question is
-- found by its text (or created if missing) and linked at its position, so the file is
-- safe on a fresh database and on one where the promotion migration already ran.

-- Question 1/6 (pair 1 EN, quiz position 1, MULTIPLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'switch')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of these statements about the classic `switch` syntax are true? (Select all that apply)$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Which of these statements about the classic `switch` syntax are true? (Select all that apply)$$,
           NULL, NULL,
           $$In the classic syntax, `break` is what exits the `switch`, and `default` is the branch that runs when no `case` matches. `default` is optional, so leaving it out still compiles. A `case` does not end by itself when the next label begins: without `break`, execution simply continues into the next `case`.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'switch'
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
        ($$`break` exits the `switch`$$, TRUE, 0),
        ($$`default` runs when no `case` matches$$, TRUE, 1),
        ($$The code does not compile unless a `default` is present$$, FALSE, 2),
        ($$A `case` ends automatically where the next `case` label begins$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'switch'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (pair 2 EN, quiz position 2, CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'switch')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this code print?$$
      AND code_snippet = $$int level = 2;

switch (level) {
    case 1:
        System.out.println("Bronze");
    case 2:
        System.out.println("Silver");
    case 3:
        System.out.println("Gold");
        break;
    default:
        System.out.println("None");
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does this code print?$$,
           $$int level = 2;

switch (level) {
    case 1:
        System.out.println("Bronze");
    case 2:
        System.out.println("Silver");
    case 3:
        System.out.println("Gold");
        break;
    default:
        System.out.println("None");
}$$, $$java$$,
           $$Execution starts at the matching `case 2` and prints `Silver`. Because that case has no `break`, it falls through into `case 3` and prints `Gold` too, even though `level` is not 3. The `break` there finally exits the `switch`, so `default` is never reached. `case 1` is skipped because it comes before the matching label.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'switch'
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
        ($$`Silver`$$, FALSE, 0),
        ($$`Silver`, `Gold`, then `None`$$, FALSE, 1),
        ($$`Silver`, then `Gold`$$, TRUE, 2),
        ($$`Bronze`, `Silver`, then `Gold`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'switch'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (pair 3 EN, quiz position 3, CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'switch')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this code print?$$
      AND code_snippet = $$int month = 4;

switch (month) {
    case 3, 4, 5 -> System.out.println("Spring");
    case 6, 7, 8 -> System.out.println("Summer");
    default -> System.out.println("Other");
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does this code print?$$,
           $$int month = 4;

switch (month) {
    case 3, 4, 5 -> System.out.println("Spring");
    case 6, 7, 8 -> System.out.println("Summer");
    default -> System.out.println("Other");
}$$, $$java$$,
           $$With the arrow syntax each branch runs on its own: there is no fall-through and no `break` is needed. `4` is one of the comma-separated values of the first branch, so only `Spring` is printed. Continuing into `Summer` and `Other` is what the classic syntax would do without `break`.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'switch'
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
        ($$`Spring`, then `Summer`$$, FALSE, 0),
        ($$`Spring`, `Summer`, then `Other`$$, FALSE, 1),
        ($$`Other`$$, FALSE, 2),
        ($$`Spring`$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'switch'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (pair 4 EN, quiz position 4, SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'switch')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$In a switch expression, when is the `yield` keyword needed?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$In a switch expression, when is the `yield` keyword needed?$$,
           NULL, NULL,
           $$A branch written as a single expression after `->` produces its value directly. When a branch needs a block body with several steps, the compiler cannot tell which value the block stands for, so it must be named with `yield`. It is not a per-branch replacement for `break`, and it has nothing to do with how many values a `case` lists.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'switch'
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
        ($$In every branch, as the replacement for `break`$$, FALSE, 0),
        ($$Only in the `default` branch$$, FALSE, 1),
        ($$Whenever a `case` lists more than one value$$, FALSE, 2),
        ($$When a branch has a block body and must state the value it produces$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'switch'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (pair 5 EN, quiz position 5, SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'switch')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A switch expression covers every constant of an enum and has no `default`. Later a new constant is added to the enum, but this `switch` is not updated. What happens?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A switch expression covers every constant of an enum and has no `default`. Later a new constant is added to the enum, but this `switch` is not updated. What happens?$$,
           NULL, NULL,
           $$A switch expression over an enum must be exhaustive. Without a `default`, the compiler checks that every constant has a `case`, so the forgotten `switch` becomes a compile error. That is the point of leaving `default` out: the mistake is caught at compile time instead of surfacing as a silent bug or a failure at runtime.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'switch'
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
        ($$The code no longer compiles, because the `switch` does not cover every constant$$, TRUE, 0),
        ($$It compiles, and the expression evaluates to `null` for the new constant$$, FALSE, 1),
        ($$It compiles, and fails only at runtime when the new constant is passed$$, FALSE, 2),
        ($$It compiles, and the new constant is handled by the last `case`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'switch'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (pair 6 EN, quiz position 6, CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'switch')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this code print?$$
      AND code_snippet = $$String command = new String("start");

switch (command) {
    case "start" -> System.out.println("Starting");
    case "stop" -> System.out.println("Stopping");
    default -> System.out.println("Unknown");
}$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this code print?$$,
           $$String command = new String("start");

switch (command) {
    case "start" -> System.out.println("Starting");
    case "stop" -> System.out.println("Stopping");
    default -> System.out.println("Unknown");
}$$, $$java$$,
           $$A `switch` on a `String` compares content, like `.equals()`. `command` is a separate object created with `new`, but its content is `start`, so the first branch matches. `Unknown` is what you would expect if `switch` compared references the way `==` does, and that trap does not apply here.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'switch'
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
        ($$`Unknown`$$, FALSE, 0),
        ($$`Starting`$$, TRUE, 1),
        ($$`Starting`, then `Stopping`$$, FALSE, 2),
        ($$Nothing, because the code does not compile$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'switch'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
