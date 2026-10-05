-- Links the EN nested-loops questions to the topic's fixed quiz. Same NOT EXISTS /
-- ON CONFLICT DO NOTHING pattern as every prior quiz-link migration: each question is
-- found by its text (or created if missing) and linked at its position, so the file is
-- safe on a fresh database and on one where the promotion migration already ran.

-- Question 1/5 (pair 1 EN, quiz position 1, CODE_OUTPUT)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'nested-loops')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this code print?$$
      AND code_snippet = $$int count = 0;

for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 4; j++) {
        count++;
    }
}

System.out.println(count);$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does this code print?$$,
           $$int count = 0;

for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 4; j++) {
        count++;
    }
}

System.out.println(count);$$, $$java$$,
           $$For each of the outer loop's 3 steps the inner loop runs completely, 4 times, so the body runs 3 × 4 = 12 times. Adding the two counts to get 7 misses that the inner loop starts over on every outer step.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'nested-loops'
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
        ($$`12`$$, TRUE, 0),
        ($$`7`$$, FALSE, 1),
        ($$`4`$$, FALSE, 2),
        ($$`3`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'nested-loops'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/5 (pair 2 EN, quiz position 2, CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'nested-loops')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this code print?$$
      AND code_snippet = $$int[][] matrix = {{1, 2, 3}, {4, 5}};
int total = 0;

for (int row = 0; row < matrix.length; row++) {
    for (int col = 0; col < matrix[row].length; col++) {
        total += matrix[row][col];
    }
}

System.out.println(total);$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this code print?$$,
           $$int[][] matrix = {{1, 2, 3}, {4, 5}};
int total = 0;

for (int row = 0; row < matrix.length; row++) {
    for (int col = 0; col < matrix[row].length; col++) {
        total += matrix[row][col];
    }
}

System.out.println(total);$$, $$java$$,
           $$The outer loop walks the 2 rows and the inner loop walks each row's own columns, because its bound is `matrix[row].length`: 3 for the first row and 2 for the second. Every value is added once, giving 15. Using a fixed column count instead would read past the end of the shorter row.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'nested-loops'
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
        ($$`6`$$, FALSE, 0),
        ($$`15`$$, TRUE, 1),
        ($$`12`$$, FALSE, 2),
        ($$`9`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'nested-loops'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/5 (pair 3 EN, quiz position 3, CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'nested-loops')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this code print?$$
      AND code_snippet = $$for (int row = 1; row <= 2; row++) {
    for (int col = 1; col <= 3; col++) {
        if (col == 2) {
            break;
        }
        System.out.println(row + "-" + col);
    }
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this code print?$$,
           $$for (int row = 1; row <= 2; row++) {
    for (int col = 1; col <= 3; col++) {
        if (col == 2) {
            break;
        }
        System.out.println(row + "-" + col);
    }
}$$, $$java$$,
           $$An unlabeled `break` ends only the innermost loop it is written in. On each row the inner loop prints column 1 and is cut off at column 2, but the outer loop carries on, so the second row is processed as well. Stopping after `1-1` would require a labeled `break` aimed at the outer loop.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'nested-loops'
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
        ($$`1-1`$$, FALSE, 0),
        ($$`1-1`, `1-3`, `2-1`, then `2-3`$$, FALSE, 1),
        ($$`1-1`, then `2-1`$$, TRUE, 2),
        ($$`1-1`, `1-2`, `2-1`, then `2-2`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'nested-loops'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/5 (pair 4 EN, quiz position 4, SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'nested-loops')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Inside the inner loop of two nested loops, a search finds its match and must stop both loops at once. Which statement does that?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Inside the inner loop of two nested loops, a search finds its match and must stop both loops at once. Which statement does that?$$,
           NULL, NULL,
           $$A label placed before the outer loop lets `break` name the loop it should end, so `break searchLoop;` leaves the inner and the outer loop together. A plain `break` would stop only the inner loop and the outer one would keep searching. A labeled `continue` does not stop anything; it moves on to the outer loop's next step.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'nested-loops'
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
        ($$A plain `break;`$$, FALSE, 0),
        ($$`continue` with the outer loop's label$$, FALSE, 1),
        ($$Two `break;` statements, one after the other$$, FALSE, 2),
        ($$`break` with the outer loop's label, such as `break searchLoop;`$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'nested-loops'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/5 (pair 5 EN, quiz position 5, SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'nested-loops')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Two nested loops each run over the same `n` elements. When `n` grows from 10 to 100, how does the number of times the inner body runs change?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Two nested loops each run over the same `n` elements. When `n` grows from 10 to 100, how does the number of times the inner body runs change?$$,
           NULL, NULL,
           $$The body runs `n × n` times: 100 times for `n` equal to 10, and 10,000 times for `n` equal to 100. A tenfold increase in the data therefore means a hundredfold increase in work. Growth in step with `n` is what a single loop would give, not two nested ones.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'nested-loops'
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
        ($$From 100 to 10,000: a hundredfold increase$$, TRUE, 0),
        ($$From 10 to 100: a tenfold increase$$, FALSE, 1),
        ($$From 20 to 200: a tenfold increase$$, FALSE, 2),
        ($$From 100 to 1,000: a tenfold increase$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'nested-loops'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
