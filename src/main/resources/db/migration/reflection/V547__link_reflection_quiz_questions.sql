-- Promotion-style migration linking EN Reflection quiz questions to the
-- topic's fixed quiz created in reflection/V546 -- same NOT EXISTS/ON
-- CONFLICT DO NOTHING pattern used by every prior quiz-link migration in
-- this project. All 7 EN questions from question-promotion/V545
-- (hand-authored and self-reviewed -- no n8n, no OpenAI, no AI Judge). No
-- selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: CODE_OUTPUT)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'reflection')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What will this code print?$$
      AND code_snippet = $$Class<?> a = "hello".getClass();
Class<?> b = String.class;
System.out.println(a == b);$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What will this code print?$$,
           $$Class<?> a = "hello".getClass();
Class<?> b = String.class;
System.out.println(a == b);$$, $$java$$,
           $$The JVM keeps only one Class instance per class, per classloader -- obj.getClass() and Type.class always return the exact same object, so a == b is true even without calling equals().$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'reflection'
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
    ($$true$$, TRUE, 0),
    ($$false$$, FALSE, 1),
    ($$It throws an exception.$$, FALSE, 2),
    ($$The result is unpredictable across runs.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'reflection'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: MULTIPLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'reflection')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about getFields() and getDeclaredFields() are true?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about getFields() and getDeclaredFields() are true?$$, NULL, NULL,
           $$getFields() returns only public fields (including inherited ones); getDeclaredFields() returns only fields declared in that class itself, regardless of access modifier, but never inherited ones. The two methods behave as opposites along the public/inherited axes.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'reflection'
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
    ($$getFields() returns only public fields, including those inherited from superclasses.$$, TRUE, 0),
    ($$getDeclaredFields() returns only fields declared in that class itself, regardless of access modifier.$$, TRUE, 1),
    ($$getDeclaredFields() includes fields inherited from a superclass.$$, FALSE, 2),
    ($$getFields() includes private fields defined in the class itself.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'reflection'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'reflection')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why does getMethods() on a simple, method-less custom class still return a non-empty array?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Why does getMethods() on a simple, method-less custom class still return a non-empty array?$$, NULL, NULL,
           $$getMethods() returns a class's public methods, including those inherited from Object such as toString(), equals(), and hashCode() -- which is why the list turns out bigger than expected even for a simple class.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'reflection'
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
    ($$Because getMethods() includes public methods inherited from Object, such as toString(), equals(), and hashCode().$$, TRUE, 0),
    ($$Because every class automatically gets synthetic accessor methods generated by the compiler.$$, FALSE, 1),
    ($$Because getMethods() always throws unless at least one method is found.$$, FALSE, 2),
    ($$Because Java requires every class to declare at least one public method.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'reflection'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'reflection')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why is the parameterless Class.newInstance() deprecated in favor of getDeclaredConstructor(...).newInstance()?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Why is the parameterless Class.newInstance() deprecated in favor of getDeclaredConstructor(...).newInstance()?$$, NULL, NULL,
           $$Class.newInstance() throws the constructor's checked exceptions directly, unwrapped, bypassing the compiler's checked-exception checking, and it enforces access control on private/protected constructors less consistently than Constructor.newInstance().$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'reflection'
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
    ($$It throws the constructor's checked exceptions directly, unwrapped, bypassing the compiler's checked-exception checking, and it enforces access control less consistently.$$, TRUE, 0),
    ($$It is slower than Constructor.newInstance() by a significant margin.$$, FALSE, 1),
    ($$It cannot create objects of classes with a package-private constructor.$$, FALSE, 2),
    ($$It was removed entirely in Java 9 and no longer compiles.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'reflection'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'reflection')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What will this code print?$$
      AND code_snippet = $$class Calculator {
    public int divide(int a, int b) {
        return a / b;
    }
}

Method m = Calculator.class.getMethod("divide", int.class, int.class);
try {
    m.invoke(new Calculator(), 10, 0);
} catch (ArithmeticException e) {
    System.out.println("caught ArithmeticException");
} catch (java.lang.reflect.InvocationTargetException e) {
    System.out.println("caught InvocationTargetException");
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$What will this code print?$$,
           $$class Calculator {
    public int divide(int a, int b) {
        return a / b;
    }
}

Method m = Calculator.class.getMethod("divide", int.class, int.class);
try {
    m.invoke(new Calculator(), 10, 0);
} catch (ArithmeticException e) {
    System.out.println("caught ArithmeticException");
} catch (java.lang.reflect.InvocationTargetException e) {
    System.out.println("caught InvocationTargetException");
}$$, $$java$$,
           $$Method.invoke() never lets the invoked method's own exception escape directly -- it always wraps it in an InvocationTargetException. The ArithmeticException thrown inside divide() does not match the first catch clause, so it falls to the InvocationTargetException catch.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'reflection'
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
    ($$caught ArithmeticException$$, FALSE, 0),
    ($$caught InvocationTargetException$$, TRUE, 1),
    ($$The program crashes with an uncaught exception.$$, FALSE, 2),
    ($$Both messages are printed.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'reflection'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'reflection')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What will this code print? (Assume no setAccessible(true) call is made.)$$
      AND code_snippet = $$class Secret {
    private String code = "1234";
}

Field f = Secret.class.getDeclaredField("code");
try {
    Object value = f.get(new Secret());
    System.out.println(value);
} catch (IllegalAccessException e) {
    System.out.println("access denied");
}$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$What will this code print? (Assume no setAccessible(true) call is made.)$$,
           $$class Secret {
    private String code = "1234";
}

Field f = Secret.class.getDeclaredField("code");
try {
    Object value = f.get(new Secret());
    System.out.println(value);
} catch (IllegalAccessException e) {
    System.out.println("access denied");
}$$, $$java$$,
           $$Without calling setAccessible(true) first, reading a private field via reflection throws IllegalAccessException -- forgetting this call is one of the most common reflection mistakes.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'reflection'
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
    ($$1234$$, FALSE, 0),
    ($$access denied$$, TRUE, 1),
    ($$The program crashes with an uncaught exception.$$, FALSE, 2),
    ($$null$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'reflection'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'reflection')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$You define a custom annotation but forget to add @Retention(RetentionPolicy.RUNTIME) (leaving the default). What happens when you call isAnnotationPresent() for it via reflection at runtime?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$You define a custom annotation but forget to add @Retention(RetentionPolicy.RUNTIME) (leaving the default). What happens when you call isAnnotationPresent() for it via reflection at runtime?$$, NULL, NULL,
           $$The code compiles and runs fine -- the annotation "looks like it's there" in the source -- but isAnnotationPresent() always returns false, because the annotation's retention doesn't survive to runtime by default.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'reflection'
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
    ($$The code compiles and runs, but isAnnotationPresent() always returns false -- the annotation is invisible to reflection.$$, TRUE, 0),
    ($$A compile error occurs, since every annotation must specify @Retention explicitly.$$, FALSE, 1),
    ($$isAnnotationPresent() throws a RuntimeException because the annotation lacks retention metadata.$$, FALSE, 2),
    ($$isAnnotationPresent() returns true, since annotations are visible to reflection by default.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'reflection'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
