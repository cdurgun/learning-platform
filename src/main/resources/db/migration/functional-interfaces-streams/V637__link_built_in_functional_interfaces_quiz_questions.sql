-- Promotion-style migration linking EN built-in-functional-interfaces quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: CODE_OUTPUT)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'built-in-functional-interfaces')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$import java.util.function.Predicate;

public class Demo {
    public static void main(String[] args) {
        Predicate<String> isLong = s -> s.length() > 3;
        Predicate<String> startsWithA = s -> s.startsWith("A");
        Predicate<String> combined = isLong.and(startsWithA);
        System.out.println(combined.test("Anna"));
        System.out.println(combined.test("Al"));
    }
}$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.function.Predicate;

public class Demo {
    public static void main(String[] args) {
        Predicate<String> isLong = s -> s.length() > 3;
        Predicate<String> startsWithA = s -> s.startsWith("A");
        Predicate<String> combined = isLong.and(startsWithA);
        System.out.println(combined.test("Anna"));
        System.out.println(combined.test("Al"));
    }
}$$, $$java$$,
           $$and() combines two predicates so both must be true. "Anna" has length 4 (>3) and starts with "A" -- true. "Al" has length 2, which fails the first check -- false.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'built-in-functional-interfaces'
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
    ($$true
false$$, TRUE, 0),
    ($$false
true$$, FALSE, 1),
    ($$true
true$$, FALSE, 2),
    ($$false
false$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'built-in-functional-interfaces'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'built-in-functional-interfaces')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$import java.util.function.Function;

public class Demo {
    public static void main(String[] args) {
        Function<Integer, Integer> addOne = x -> x + 1;
        Function<Integer, Integer> timesTwo = x -> x * 2;
        System.out.println(addOne.andThen(timesTwo).apply(3));
        System.out.println(addOne.compose(timesTwo).apply(3));
    }
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.function.Function;

public class Demo {
    public static void main(String[] args) {
        Function<Integer, Integer> addOne = x -> x + 1;
        Function<Integer, Integer> timesTwo = x -> x * 2;
        System.out.println(addOne.andThen(timesTwo).apply(3));
        System.out.println(addOne.compose(timesTwo).apply(3));
    }
}$$, $$java$$,
           $$f.andThen(g) runs f first, then feeds the result into g: (3+1)*2=8. f.compose(g) runs g first, then feeds the result into f: (3*2)+1=7.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'built-in-functional-interfaces'
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
    ($$8
8$$, FALSE, 0),
    ($$7
7$$, FALSE, 1),
    ($$8
7$$, TRUE, 2),
    ($$7
8$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'built-in-functional-interfaces'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'built-in-functional-interfaces')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which statement correctly distinguishes `Consumer<T>` from `Supplier<T>`?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Which statement correctly distinguishes `Consumer<T>` from `Supplier<T>`?$$,
           NULL, NULL,
           $$Consumer's accept(T) takes a value and performs a side effect, returning nothing. Supplier's get() takes no input at all and produces a value.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'built-in-functional-interfaces'
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
    ($$Consumer's accept(T) takes a value and performs a side effect, returning nothing; Supplier's get() takes no input and produces a value.$$, TRUE, 0),
    ($$Consumer produces a value with no input; Supplier takes a value and performs a side effect.$$, FALSE, 1),
    ($$Both take a value and return a transformed value.$$, FALSE, 2),
    ($$Consumer and Supplier are interchangeable, differing only in name.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'built-in-functional-interfaces'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'built-in-functional-interfaces')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is the relationship between `UnaryOperator<T>` and `Function<T, T>`?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What is the relationship between `UnaryOperator<T>` and `Function<T, T>`?$$,
           NULL, NULL,
           $$UnaryOperator<T> extends Function<T, T> -- it exists purely for readability, to express that input and output share the same type.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'built-in-functional-interfaces'
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
    ($$Function<T, T> extends UnaryOperator<T>.$$, FALSE, 0),
    ($$UnaryOperator<T> can only be used with primitive types, never with objects.$$, FALSE, 1),
    ($$UnaryOperator<T> extends Function<T, T> -- it exists purely for readability, to express that input and output share the same type.$$, TRUE, 2),
    ($$UnaryOperator<T> is a completely unrelated interface with a different abstract method signature.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'built-in-functional-interfaces'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'built-in-functional-interfaces')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$import java.util.function.BiFunction;
import java.util.function.Function;

public class Demo {
    public static void main(String[] args) {
        Function<String, Integer> parse = Integer::parseInt;
        BiFunction<String, String, Boolean> starts = String::startsWith;
        System.out.println(parse.apply("42"));
        System.out.println(starts.apply("hello", "he"));
    }
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.function.BiFunction;
import java.util.function.Function;

public class Demo {
    public static void main(String[] args) {
        Function<String, Integer> parse = Integer::parseInt;
        BiFunction<String, String, Boolean> starts = String::startsWith;
        System.out.println(parse.apply("42"));
        System.out.println(starts.apply("hello", "he"));
    }
}$$, $$java$$,
           $$Integer::parseInt is a Class::staticMethod reference. String::startsWith is an unbound Class::instanceMethod reference -- the first BiFunction argument ("hello") becomes the receiver, the second ("he") becomes startsWith's parameter.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'built-in-functional-interfaces'
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
    ($$42
true$$, TRUE, 0),
    ($$Compile error -- String::startsWith needs an existing String object to bind to.$$, FALSE, 1),
    ($$42
false$$, FALSE, 2),
    ($$Compile error -- BiFunction can't accept a method reference.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'built-in-functional-interfaces'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'built-in-functional-interfaces')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$import java.util.function.Supplier;
import java.util.ArrayList;
import java.util.List;

public class Demo {
    public static void main(String[] args) {
        Supplier<List<String>> listMaker = ArrayList::new;
        List<String> list = listMaker.get();
        list.add("ok");
        System.out.println(list.size());
    }
}$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.function.Supplier;
import java.util.ArrayList;
import java.util.List;

public class Demo {
    public static void main(String[] args) {
        Supplier<List<String>> listMaker = ArrayList::new;
        List<String> list = listMaker.get();
        list.add("ok");
        System.out.println(list.size());
    }
}$$, $$java$$,
           $$Class::new points at a constructor -- ArrayList::new is used here as a Supplier<List<String>>, so calling get() creates a fresh, empty ArrayList each time.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'built-in-functional-interfaces'
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
    ($$Compile error -- ArrayList::new can't be assigned to Supplier.$$, FALSE, 0),
    ($$It throws UnsupportedOperationException.$$, FALSE, 1),
    ($$1$$, TRUE, 2),
    ($$0$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'built-in-functional-interfaces'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'built-in-functional-interfaces')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are true about bound vs. unbound method references? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about bound vs. unbound method references? (Select all that apply)$$,
           NULL, NULL,
           $$A bound reference (object::instanceMethod) points to an instance method on a specific, already-existing object, which the reference captures. An unbound reference (Class::instanceMethod) uses the functional interface's first parameter as the method's receiver, and the rest as arguments.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'built-in-functional-interfaces'
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
    ($$A bound reference (object::instanceMethod) points to an instance method on a specific, already-existing object, which the reference captures.$$, TRUE, 0),
    ($$An unbound reference (Class::instanceMethod) uses the functional interface's first parameter as the method's receiver, and the rest as arguments.$$, TRUE, 1),
    ($$Bound and unbound method references always have identical target-interface signatures.$$, FALSE, 2),
    ($$An unbound reference requires an already-existing object to be captured, exactly like a bound reference.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'built-in-functional-interfaces'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
