-- Promotion-style migration linking EN lambda-expressions quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lambda-expressions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following lambda expressions fails to compile?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Which of the following lambda expressions fails to compile?$$,
           NULL, NULL,
           $$For exactly one parameter, parentheses are optional, but for two or more parameters, parentheses become mandatory again -- a, b -> a + b doesn't compile, you have to write (a, b) -> a + b.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lambda-expressions'
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
    ($$`a, b -> a + b`$$, TRUE, 0),
    ($$`(a, b) -> a + b`$$, FALSE, 1),
    ($$`x -> x * 2`$$, FALSE, 2),
    ($$`() -> 42`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lambda-expressions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lambda-expressions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens when this code is compiled?$$
      AND code_snippet = $$import java.util.function.Function;

public class Demo {
    public static void main(String[] args) {
        Function<String, String> greet = name -> {
            "Hi, " + name;
        };
        System.out.println(greet.apply("Ana"));
    }
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What happens when this code is compiled?$$,
           $$import java.util.function.Function;

public class Demo {
    public static void main(String[] args) {
        Function<String, String> greet = name -> {
            "Hi, " + name;
        };
        System.out.println(greet.apply("Ana"));
    }
}$$, $$java$$,
           $$The moment a lambda body is wrapped in { }, return becomes explicit and mandatory on every path that produces a value. Without it, "Hi, " + name; isn't even a valid statement on its own, so this fails to compile.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lambda-expressions'
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
    ($$It compiles and prints "null".$$, FALSE, 0),
    ($$It compiles but throws a NullPointerException at runtime.$$, FALSE, 1),
    ($$It fails to compile.$$, TRUE, 2),
    ($$It compiles and prints "Hi, Ana".$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lambda-expressions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lambda-expressions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$import java.util.Comparator;
import java.util.function.BiFunction;

public class Demo {
    public static void main(String[] args) {
        Comparator<String> cmp = (a, b) -> a.length() - b.length();
        BiFunction<String, String, Integer> fn = (a, b) -> a.length() - b.length();
        System.out.println(cmp.compare("hi", "hello"));
        System.out.println(fn.apply("hi", "hello"));
    }
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.Comparator;
import java.util.function.BiFunction;

public class Demo {
    public static void main(String[] args) {
        Comparator<String> cmp = (a, b) -> a.length() - b.length();
        BiFunction<String, String, Integer> fn = (a, b) -> a.length() - b.length();
        System.out.println(cmp.compare("hi", "hello"));
        System.out.println(fn.apply("hi", "hello"));
    }
}$$, $$java$$,
           $$A lambda has no type of its own -- the compiler assigns it one from context. Since Comparator's compare and BiFunction's apply have the exact same shape (two Strings in, one result out), the exact same lambda expression fits both.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lambda-expressions'
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
    ($$-3
-3$$, TRUE, 0),
    ($$Compile error -- the same lambda can't implement two different interfaces.$$, FALSE, 1),
    ($$-3
Compile error.$$, FALSE, 2),
    ($$3
3$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lambda-expressions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lambda-expressions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens when this code is compiled?$$
      AND code_snippet = $$import java.util.function.Supplier;

public class Demo {
    public static void main(String[] args) {
        int count = 5;
        Supplier<Integer> supplier = () -> count * 2;
        count = 10;
        System.out.println(supplier.get());
    }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$What happens when this code is compiled?$$,
           $$import java.util.function.Supplier;

public class Demo {
    public static void main(String[] args) {
        int count = 5;
        Supplier<Integer> supplier = () -> count * 2;
        count = 10;
        System.out.println(supplier.get());
    }
}$$, $$java$$,
           $$A lambda can only capture a local variable that is effectively final -- never reassigned after its first assignment. count is reassigned to 10 after the lambda captures it, so this fails to compile, even though the reassignment happens after the lambda is defined.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lambda-expressions'
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
    ($$It compiles and prints 20.$$, FALSE, 0),
    ($$It compiles but throws IllegalStateException at runtime.$$, FALSE, 1),
    ($$It fails to compile.$$, TRUE, 2),
    ($$It compiles and prints 10.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lambda-expressions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lambda-expressions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are true about the difference between an anonymous inner class and a lambda? (Select all that apply)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about the difference between an anonymous inner class and a lambda? (Select all that apply)$$,
           NULL, NULL,
           $$Inside an anonymous inner class, this refers to the anonymous class's own instance. Inside a lambda, this refers to the enclosing object, as if the lambda's body had been pasted directly into the surrounding method.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lambda-expressions'
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
    ($$Inside an anonymous inner class, `this` refers to the anonymous class's own instance.$$, TRUE, 0),
    ($$Inside a lambda, `this` refers to the enclosing object, as if the lambda's body were pasted directly into the surrounding method.$$, TRUE, 1),
    ($$A lambda produces a separate compiled class, the same way an anonymous inner class does.$$, FALSE, 2),
    ($$Inside a lambda, `this` refers to the lambda's own instance, requiring `OuterClass.this` to reach the enclosing object.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lambda-expressions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lambda-expressions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why can the exact same lambda expression `(a, b) -> a.length() - b.length()` be assigned to both `Comparator<String>` and `BiFunction<String, String, Integer>`?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Why can the exact same lambda expression `(a, b) -> a.length() - b.length()` be assigned to both `Comparator<String>` and `BiFunction<String, String, Integer>`?$$,
           NULL, NULL,
           $$Both interfaces' single abstract method has the exact same shape -- two Strings in, one Integer/int result out -- so the same lambda expression fits both target types.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lambda-expressions'
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
    ($$Because the compiler automatically converts between any two functional interfaces.$$, FALSE, 0),
    ($$Because lambdas are dynamically typed at runtime, so the target interface doesn't matter.$$, FALSE, 1),
    ($$Because both interfaces' single abstract method has the exact same shape -- two Strings in, one Integer/int result out.$$, TRUE, 2),
    ($$Because Comparator and BiFunction are actually the same interface under different names.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lambda-expressions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lambda-expressions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to this lesson, what was the primary way to "pass a piece of behavior as a parameter" before lambdas existed in Java?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$According to this lesson, what was the primary way to "pass a piece of behavior as a parameter" before lambdas existed in Java?$$,
           NULL, NULL,
           $$Before lambdas, the only tool for passing a piece of behavior as a parameter was the anonymous inner class -- even a single line of logic needed several lines of boilerplate around it.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lambda-expressions'
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
    ($$An anonymous inner class, which required several lines of boilerplate even for a single line of logic.$$, TRUE, 0),
    ($$A static utility method reference, exactly like today's method references.$$, FALSE, 1),
    ($$Reflection-based dynamic method invocation.$$, FALSE, 2),
    ($$There was no way to do this before Java 8 at all.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lambda-expressions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
