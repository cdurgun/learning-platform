-- Promotion-style migration linking EN bounded-type-parameters quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: CODE_OUTPUT)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'bounded-type-parameters')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens when this code is compiled?$$
      AND code_snippet = $$class Utils {
    static <T> double describe(T value) {
        return value.doubleValue();
    }
}$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What happens when this code is compiled?$$,
           $$class Utils {
    static <T> double describe(T value) {
        return value.doubleValue();
    }
}$$, $$java$$,
           $$An unbounded T could be absolutely anything, so the compiler can only assume it has the methods every Object has -- toString(), equals(), and nothing more specific. doubleValue() isn't guaranteed to exist, so this fails to compile.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'bounded-type-parameters'
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
    ($$It fails to compile -- doubleValue() isn't a method every Object is guaranteed to have.$$, TRUE, 0),
    ($$It compiles because T is always assumed to be a Number.$$, FALSE, 1),
    ($$It compiles and returns 0.0 for any non-numeric argument.$$, FALSE, 2),
    ($$It compiles but throws NoSuchMethodException at runtime.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'bounded-type-parameters'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'bounded-type-parameters')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$class Utils {
    static <T extends Number> double sum(List<T> numbers) {
        double total = 0;
        for (T n : numbers) total += n.doubleValue();
        return total;
    }
}

public class Demo {
    public static void main(String[] args) {
        System.out.println(Utils.sum(List.of(1, 2, 3)));
    }
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$class Utils {
    static <T extends Number> double sum(List<T> numbers) {
        double total = 0;
        for (T n : numbers) total += n.doubleValue();
        return total;
    }
}

public class Demo {
    public static void main(String[] args) {
        System.out.println(Utils.sum(List.of(1, 2, 3)));
    }
}$$, $$java$$,
           $$T extends Number guarantees every possible T -- Integer, Double, Long, or any other Number subtype -- has doubleValue(). List.of(1, 2, 3) is a List<Integer>, which qualifies since Integer extends Number, so the call compiles and sums to 6.0.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'bounded-type-parameters'
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
    ($$6.0$$, TRUE, 0),
    ($$Compile error -- sum only accepts List<Number>, not List<Integer>.$$, FALSE, 1),
    ($$6$$, FALSE, 2),
    ($$Compile error -- T extends Number requires an explicit type witness.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'bounded-type-parameters'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'bounded-type-parameters')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following correctly declares a type parameter bounded by both `Number` and `Comparable<T>`?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly declares a type parameter bounded by both `Number` and `Comparable<T>`?$$,
           NULL, NULL,
           $$Multiple bounds are joined with &. At most one bound may be a class, and if there is one, it must come first, followed by interfaces -- so <T extends Number & Comparable<T>> is correct.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'bounded-type-parameters'
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
    ($$<T extends Number & Comparable<T>>$$, TRUE, 0),
    ($$<T extends Comparable<T> & Number>$$, FALSE, 1),
    ($$<T extends Number, Comparable<T>>$$, FALSE, 2),
    ($$<T extends Number | Comparable<T>>$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'bounded-type-parameters'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'bounded-type-parameters')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens when this code is compiled?$$
      AND code_snippet = $$class NumericBox<T extends Number> {
    private T value;
    void set(T value) { this.value = value; }
}

public class Demo {
    public static void main(String[] args) {
        NumericBox<String> box = new NumericBox<>();
    }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What happens when this code is compiled?$$,
           $$class NumericBox<T extends Number> {
    private T value;
    void set(T value) { this.value = value; }
}

public class Demo {
    public static void main(String[] args) {
        NumericBox<String> box = new NumericBox<>();
    }
}$$, $$java$$,
           $$NumericBox<T extends Number> means NumericBox<String> simply cannot be written -- it fails to compile, because String doesn't satisfy the bound (it isn't a Number).$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'bounded-type-parameters'
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
    ($$It fails to compile -- String doesn't satisfy the bound T extends Number.$$, TRUE, 0),
    ($$It compiles because NumericBox never actually stores anything.$$, FALSE, 1),
    ($$It compiles but throws ClassCastException when set(...) is called.$$, FALSE, 2),
    ($$It compiles, treating String as a boxed numeric type.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'bounded-type-parameters'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'bounded-type-parameters')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$class Utils {
    static <T extends Comparable<T>> T max(List<T> items) {
        T best = items.get(0);
        for (T item : items) {
            if (item.compareTo(best) > 0) best = item;
        }
        return best;
    }
}

public class Demo {
    public static void main(String[] args) {
        System.out.println(Utils.max(List.of("banana", "apple", "cherry")));
    }
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$class Utils {
    static <T extends Comparable<T>> T max(List<T> items) {
        T best = items.get(0);
        for (T item : items) {
            if (item.compareTo(best) > 0) best = item;
        }
        return best;
    }
}

public class Demo {
    public static void main(String[] args) {
        System.out.println(Utils.max(List.of("banana", "apple", "cherry")));
    }
}$$, $$java$$,
           $$<T extends Comparable<T>> accepts any type that can compare itself to another of the same type -- String qualifies, with no relationship to Number required at all. "cherry" compares greatest among the three (lexicographic order).$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'bounded-type-parameters'
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
    ($$cherry$$, TRUE, 0),
    ($$Compile error -- max only accepts List<T extends Number>.$$, FALSE, 1),
    ($$apple$$, FALSE, 2),
    ($$banana$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'bounded-type-parameters'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'bounded-type-parameters')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A type parameter is written as `<T extends Comparable<T> & Number>` (interface before class). Which of the following are true? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A type parameter is written as `<T extends Comparable<T> & Number>` (interface before class). Which of the following are true? (Select all that apply)$$,
           NULL, NULL,
           $$At most one bound may be a class, and if there is one, it must come first, followed by interfaces. Writing <T extends Comparable & Number> puts the interface before the class bound Number -- this doesn't compile.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'bounded-type-parameters'
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
    ($$This fails to compile, since a class bound must always come before any interface bounds.$$, TRUE, 0),
    ($$Writing it as <T extends Number & Comparable<T>> instead would fix the problem.$$, TRUE, 1),
    ($$Interfaces and classes can appear in any order in a multiple-bound declaration.$$, FALSE, 2),
    ($$The compiler silently drops whichever bound comes second.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'bounded-type-parameters'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'bounded-type-parameters')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does `<T extends Comparable<T>>` on a class or method actually restrict?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does `<T extends Comparable<T>>` on a class or method actually restrict?$$,
           NULL, NULL,
           $$Common Mistakes calls this out: the bound describes which types are allowed to be substituted in for the type parameter -- it does NOT restrict what the class or method itself can do, and it isn't a statement about the generic class's own behavior.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'bounded-type-parameters'
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
    ($$Which types are allowed to be substituted in for T -- not what the class or method itself can do.$$, TRUE, 0),
    ($$How many instances of the generic class can be created at once.$$, FALSE, 1),
    ($$Whether the generic class itself is allowed to implement Comparable.$$, FALSE, 2),
    ($$The order in which the class's own methods are compiled.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'bounded-type-parameters'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
