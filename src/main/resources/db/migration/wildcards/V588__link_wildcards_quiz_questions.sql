-- Promotion-style migration linking EN wildcards quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'wildcards')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which statement correctly describes a wildcard (`?`) in Java generics?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Which statement correctly describes a wildcard (`?`) in Java generics?$$,
           NULL, NULL,
           $$A wildcard stands for an unknown type argument at a specific use of a generic type. Unlike a type parameter (T), a wildcard never gets a name and is never used to declare new generic classes or methods -- it only appears where a generic type is being used.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'wildcards'
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
    ($$It stands for an unknown type argument at a use site, and is never given a name or used to declare a new generic class or method.$$, TRUE, 0),
    ($$It is a named type parameter that can be declared on a generic class.$$, FALSE, 1),
    ($$It always means the same thing as Object as a type argument.$$, FALSE, 2),
    ($$It can only be used inside a method's return type, never in a parameter type.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'wildcards'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'wildcards')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens when this code is compiled?$$
      AND code_snippet = $$static double sumNumbers(List<Number> numbers) {
    double total = 0;
    for (Number n : numbers) total += n.doubleValue();
    return total;
}

public class Demo {
    public static void main(String[] args) {
        List<Integer> ints = List.of(1, 2, 3);
        System.out.println(sumNumbers(ints));
    }
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What happens when this code is compiled?$$,
           $$static double sumNumbers(List<Number> numbers) {
    double total = 0;
    for (Number n : numbers) total += n.doubleValue();
    return total;
}

public class Demo {
    public static void main(String[] args) {
        List<Integer> ints = List.of(1, 2, 3);
        System.out.println(sumNumbers(ints));
    }
}$$, $$java$$,
           $$Java generics are invariant: even though Integer IS-A Number, List<Integer> is NOT a List<Number> -- they're treated as two completely unrelated types. sumNumbers(List<Number> numbers) only accepts a parameter that is exactly List<Number>, so passing a List<Integer> is rejected outright.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'wildcards'
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
    ($$It fails to compile -- List<Integer> is not a List<Number>, even though Integer IS-A Number.$$, TRUE, 0),
    ($$It compiles and prints 6.0.$$, FALSE, 1),
    ($$It compiles but throws ClassCastException at runtime.$$, FALSE, 2),
    ($$It compiles and prints 0.0, since the elements can't be widened.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'wildcards'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'wildcards')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A method accepts a `List<?>` parameter and calls `.size()` on it, then tries `.add("new element")` on the same parameter. What happens?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A method accepts a `List<?>` parameter and calls `.size()` on it, then tries `.add("new element")` on the same parameter. What happens?$$,
           NULL, NULL,
           $$Plain <?> allows neither a meaningful get beyond Object nor any add at all -- the compiler has no way to know the list's real element type, so the add(...) call is rejected, even though size() compiles fine.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'wildcards'
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
    ($$The add(...) call fails to compile, since the compiler has no way to know the list's real element type.$$, TRUE, 0),
    ($$Both calls compile -- List<?> behaves exactly like List<Object> for writing.$$, FALSE, 1),
    ($$Both calls fail to compile, since size() also requires a known element type.$$, FALSE, 2),
    ($$The add(...) call compiles but silently does nothing at runtime.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'wildcards'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'wildcards')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens when this code is compiled?$$
      AND code_snippet = $$static double sum(List<? extends Number> numbers) {
    double total = 0;
    for (Number n : numbers) total += n.doubleValue();
    numbers.add(5);
    return total;
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$What happens when this code is compiled?$$,
           $$static double sum(List<? extends Number> numbers) {
    double total = 0;
    for (Number n : numbers) total += n.doubleValue();
    numbers.add(5);
    return total;
}$$, $$java$$,
           $$List<? extends Number> only ever lets you READ safely (every element is guaranteed to be at least a Number). What ISN'T safe is adding: the compiler has no way to know the list's real element type (it could specifically be a List<Double>), so numbers.add(5) is rejected.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'wildcards'
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
    ($$It fails to compile -- numbers.add(5) is not allowed on a List<? extends Number>.$$, TRUE, 0),
    ($$It compiles and returns the sum, having also appended 5 to the list.$$, FALSE, 1),
    ($$It compiles only when the caller passes a List<Integer> specifically.$$, FALSE, 2),
    ($$It compiles but add(5) throws ClassCastException at runtime.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'wildcards'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'wildcards')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens when this code is compiled?$$
      AND code_snippet = $$static void addOneToFive(List<? super Integer> list) {
    for (int i = 1; i <= 5; i++) list.add(i);
    Integer first = list.get(0);
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$What happens when this code is compiled?$$,
           $$static void addOneToFive(List<? super Integer> list) {
    for (int i = 1; i <= 5; i++) list.add(i);
    Integer first = list.get(0);
}$$, $$java$$,
           $$List<? super Integer> lets you WRITE an Integer safely, no matter which supertype of Integer the list actually holds. What ISN'T safe is reading a specific type back out: the compiler only guarantees the list holds SOME supertype of Integer, which could be as broad as Object, so list.get(0) can only be treated as Object -- assigning it directly to an Integer variable fails to compile.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'wildcards'
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
    ($$It fails to compile -- list.get(0) returns Object, which can't be assigned directly to an Integer variable.$$, TRUE, 0),
    ($$It compiles and assigns 1 to first.$$, FALSE, 1),
    ($$It fails to compile at list.add(i) instead, since the list's real type is unknown.$$, FALSE, 2),
    ($$It compiles but throws ClassCastException when get(0) is called.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'wildcards'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'wildcards')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A method only ever WRITES elements into a `List<T>` parameter and never reads from it. According to PECS, which wildcard form should it use?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A method only ever WRITES elements into a `List<T>` parameter and never reads from it. According to PECS, which wildcard form should it use?$$,
           NULL, NULL,
           $$PECS: "Producer Extends, Consumer Super." If a parameterized type only CONSUMES values from you (you only write into it), use super -- exactly the role addOneToFive(...) plays.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'wildcards'
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
    ($$List<? super T> -- it's a consumer, so super applies.$$, TRUE, 0),
    ($$List<? extends T> -- it's a producer, so extends applies.$$, FALSE, 1),
    ($$List<?> -- an unbounded wildcard, since the method never reads.$$, FALSE, 2),
    ($$List<T> with no wildcard at all, since PECS never applies to write-only parameters.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'wildcards'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'wildcards')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are true about wildcard usage, according to this lesson? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about wildcard usage, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$copy(List<? extends T> src, List<? super T> dest) needs both roles at once: src is a producer (extends), dest is a consumer (super). A wildcard should never appear on a return type -- it forces every caller to deal with an unknown type, with none of PECS's benefit.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'wildcards'
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
    ($$A method that both reads from one list and writes into another can use extends for the source and super for the destination.$$, TRUE, 0),
    ($$A wildcard should never be added to a method's return type.$$, TRUE, 1),
    ($$List<? super T> can be used to reliably read a specific T back out of the list.$$, FALSE, 2),
    ($$If a parameter needs both reading and writing of the same specific type, a wildcard is still the right tool.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'wildcards'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
