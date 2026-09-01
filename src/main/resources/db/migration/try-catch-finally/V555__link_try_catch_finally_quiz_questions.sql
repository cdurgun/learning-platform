-- Promotion-style migration linking EN try-catch-finally quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'try-catch-finally')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following will fail to compile?$$
      AND code_snippet = $$try {
    int[] arr = new int[2];
    System.out.println(arr[5]);
} catch (RuntimeException e) {
    System.out.println("runtime");
} catch (ArrayIndexOutOfBoundsException e) {
    System.out.println("array");
}$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following will fail to compile?$$,
           $$try {
    int[] arr = new int[2];
    System.out.println(arr[5]);
} catch (RuntimeException e) {
    System.out.println("runtime");
} catch (ArrayIndexOutOfBoundsException e) {
    System.out.println("array");
}$$, $$java$$,
           $$A catch block for a superclass (RuntimeException) placed before a catch block for one of its subclasses (ArrayIndexOutOfBoundsException) makes the second block unreachable -- the compiler rejects this as an error, exactly as covered in "Multiple catch Blocks: Matching in Order".$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'try-catch-finally'
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
    ($$It compiles and prints "runtime".$$, FALSE, 0),
    ($$It compiles and prints "array".$$, FALSE, 1),
    ($$It fails to compile because the second catch block is unreachable.$$, TRUE, 2),
    ($$It compiles but throws an uncaught exception at runtime.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'try-catch-finally'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'try-catch-finally')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$public class Demo {
    static int test() {
        try {
            System.out.println("try");
            return 1;
        } finally {
            System.out.println("finally");
        }
    }
    public static void main(String[] args) {
        System.out.println("result: " + test());
    }
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$public class Demo {
    static int test() {
        try {
            System.out.println("try");
            return 1;
        } finally {
            System.out.println("finally");
        }
    }
    public static void main(String[] args) {
        System.out.println("result: " + test());
    }
}$$, $$java$$,
           $$finally always runs, even when the try block already contains a return -- it runs between the return value being evaluated and control actually leaving the method, so "finally" prints before "result: 1".$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'try-catch-finally'
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
    ($$try / finally / result: 1$$, TRUE, 0),
    ($$try / result: 1 / finally$$, FALSE, 1),
    ($$finally / try / result: 1$$, FALSE, 2),
    ($$try / result: 1 (finally never runs)$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'try-catch-finally'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'try-catch-finally')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$public class Demo {
    static int risky() {
        try {
            throw new RuntimeException("boom");
        } finally {
            return 42;
        }
    }
    public static void main(String[] args) {
        System.out.println(risky());
    }
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$public class Demo {
    static int risky() {
        try {
            throw new RuntimeException("boom");
        } finally {
            return 42;
        }
    }
    public static void main(String[] args) {
        System.out.println(risky());
    }
}$$, $$java$$,
           $$When finally itself contains a return, it silently overrides whatever the try/catch was about to produce -- including a genuinely uncaught exception already propagating. The RuntimeException is discarded entirely and 42 is returned.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'try-catch-finally'
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
    ($$42, the exception is discarded.$$, TRUE, 0),
    ($$Throws RuntimeException: boom.$$, FALSE, 1),
    ($$Compile error -- you can't return from finally.$$, FALSE, 2),
    ($$Prints 42, then the exception is thrown afterward.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'try-catch-finally'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'try-catch-finally')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which multi-catch block correctly handles both NumberFormatException and ArrayIndexOutOfBoundsException with identical code?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Which multi-catch block correctly handles both NumberFormatException and ArrayIndexOutOfBoundsException with identical code?$$,
           NULL, NULL,
           $$Multi-catch (Java 7+) lists several unrelated exception types separated by | inside a single catch block, sharing one parameter and one handling body.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'try-catch-finally'
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
    ($$catch (NumberFormatException, ArrayIndexOutOfBoundsException e)$$, FALSE, 0),
    ($$catch (NumberFormatException | ArrayIndexOutOfBoundsException e)$$, TRUE, 1),
    ($$catch (NumberFormatException e | ArrayIndexOutOfBoundsException e)$$, FALSE, 2),
    ($$catch NumberFormatException, ArrayIndexOutOfBoundsException (e)$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'try-catch-finally'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'try-catch-finally')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$In `catch (IOException e) { ... }`, what is `e`?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$In `catch (IOException e) { ... }`, what is `e`?$$,
           NULL, NULL,
           $$The catch parameter is a genuine, ordinary local variable, scoped only to that catch block -- any method Throwable defines can be called on it, most commonly getMessage().$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'try-catch-finally'
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
    ($$A static field of the enclosing class.$$, FALSE, 0),
    ($$An ordinary local variable scoped to that catch block, on which any Throwable method can be called.$$, TRUE, 1),
    ($$A keyword with no type.$$, FALSE, 2),
    ($$A reference that can only be used to print the exception's class name.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'try-catch-finally'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'try-catch-finally')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about `finally` are true? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about `finally` are true? (Select all that apply)$$,
           NULL, NULL,
           $$finally runs unconditionally: whether the try block succeeds, an exception is caught, or an exception propagates past every catch block uncaught -- in every one of those cases, finally still runs.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'try-catch-finally'
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
    ($$finally runs even if the try block contains a return statement.$$, TRUE, 0),
    ($$finally runs even if an exception propagates past every catch block uncaught.$$, TRUE, 1),
    ($$finally is skipped if the matching catch block itself throws a new exception.$$, FALSE, 2),
    ($$finally only runs if at least one catch block executed.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'try-catch-finally'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'try-catch-finally')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are considered mistakes according to this lesson? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are considered mistakes according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$Ordering a superclass catch before a subclass catch is a genuine compile error, and wrapping an entire method body in one giant try "just in case" makes it hard to tell which line an exception actually protects.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'try-catch-finally'
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
    ($$Ordering a superclass catch block before a subclass catch block.$$, TRUE, 0),
    ($$Wrapping an entire method body in one giant try block "just in case".$$, TRUE, 1),
    ($$Using multi-catch when two unrelated exception types need identical handling.$$, FALSE, 2),
    ($$Ordering the most specific catch block first.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'try-catch-finally'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
