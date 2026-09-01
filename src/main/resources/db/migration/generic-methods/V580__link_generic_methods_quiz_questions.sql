-- Promotion-style migration linking EN generic-methods quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generic-methods')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Where does a generic method's type parameter appear in its declaration?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Where does a generic method's type parameter appear in its declaration?$$,
           NULL, NULL,
           $$The type parameter appears once, in angle brackets, right before the return type -- static <T> T firstElement(...). It belongs to the method alone, independent of whether the enclosing class is generic.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generic-methods'
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
    ($$In angle brackets, right before the return type.$$, TRUE, 0),
    ($$In angle brackets, right after the method name.$$, FALSE, 1),
    ($$It must match a type parameter already declared on the enclosing class.$$, FALSE, 2),
    ($$At the end of the parameter list, after the last parameter.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generic-methods'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generic-methods')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$class Utils {
    static <T> T firstElement(List<T> list) {
        return list.get(0);
    }
}

public class Demo {
    public static void main(String[] args) {
        List<String> names = List.of("Zoe", "Amir");
        List<Integer> scores = List.of(90, 85);
        String first = Utils.firstElement(names);
        Integer topScore = Utils.firstElement(scores);
        System.out.println(first + " " + topScore);
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
    static <T> T firstElement(List<T> list) {
        return list.get(0);
    }
}

public class Demo {
    public static void main(String[] args) {
        List<String> names = List.of("Zoe", "Amir");
        List<Integer> scores = List.of(90, 85);
        String first = Utils.firstElement(names);
        Integer topScore = Utils.firstElement(scores);
        System.out.println(first + " " + topScore);
    }
}$$, $$java$$,
           $$The compiler deduces T entirely from the argument passed at each call site -- Utils.firstElement(names) infers T as String, Utils.firstElement(scores) infers T as Integer, on the very same method.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generic-methods'
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
    ($$Zoe 90$$, TRUE, 0),
    ($$Zoe Zoe$$, FALSE, 1),
    ($$Compile error -- firstElement's T is ambiguous across two calls.$$, FALSE, 2),
    ($$90 Zoe$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generic-methods'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generic-methods')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is a "type witness" like `Utils.<String>firstElement(names)`?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What is a "type witness" like `Utils.<String>firstElement(names)`?$$,
           NULL, NULL,
           $$A type witness is an explicit type argument supplied at a generic method's call site, overriding inference -- it's rarely needed in everyday code, only for the rare cases where the compiler can't infer the type on its own.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generic-methods'
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
    ($$An explicit type argument supplied at the call site, overriding inference -- rarely needed in everyday code.$$, TRUE, 0),
    ($$A mandatory declaration required on every generic method call.$$, FALSE, 1),
    ($$A runtime check that verifies the inferred type matches the actual argument.$$, FALSE, 2),
    ($$A comment documenting what type a generic method is expected to receive.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generic-methods'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generic-methods')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$class Utils {
    static <K, V> String describeEntry(K key, V value) {
        return key + " -> " + value;
    }
}

public class Demo {
    public static void main(String[] args) {
        System.out.println(Utils.describeEntry("age", 30));
        System.out.println(Utils.describeEntry(101, "order-created"));
    }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$class Utils {
    static <K, V> String describeEntry(K key, V value) {
        return key + " -> " + value;
    }
}

public class Demo {
    public static void main(String[] args) {
        System.out.println(Utils.describeEntry("age", 30));
        System.out.println(Utils.describeEntry(101, "order-created"));
    }
}$$, $$java$$,
           $$describeEntry(K key, V value) deduces K and V independently on every call -- describeEntry("age", 30) and describeEntry(101, "order-created") are both valid, unrelated uses of the same method, each with its own inferred type pair.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generic-methods'
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
    ($$age -> 30
101 -> order-created$$, TRUE, 0),
    ($$Compile error -- K and V must be the same type on every call.$$, FALSE, 1),
    ($$age -> 30
age -> 30$$, FALSE, 2),
    ($$Compile error -- describeEntry can only be called once per K/V pair.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generic-methods'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generic-methods')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$class Container<T> {
    private T value;
    Container(T value) { this.value = value; }
    <U> String combineWith(U other) {
        return value + "+" + other;
    }
}

public class Demo {
    public static void main(String[] args) {
        Container<String> c = new Container<>("A");
        System.out.println(c.combineWith(42));
        System.out.println(c.combineWith(true));
    }
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$class Container<T> {
    private T value;
    Container(T value) { this.value = value; }
    <U> String combineWith(U other) {
        return value + "+" + other;
    }
}

public class Demo {
    public static void main(String[] args) {
        Container<String> c = new Container<>("A");
        System.out.println(c.combineWith(42));
        System.out.println(c.combineWith(true));
    }
}$$, $$java$$,
           $$Container<T> fixes T as String once, for the whole instance. But combineWith's U is decided fresh on every call, completely independent of T -- the same Container<String> instance calls combineWith with an Integer, then a Boolean, and each call gets its own U.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generic-methods'
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
    ($$A+42
A+true$$, TRUE, 0),
    ($$Compile error -- U must match T, which is String.$$, FALSE, 1),
    ($$A+42
Compile error on the second call, U was already bound to Integer.$$, FALSE, 2),
    ($$42+A
true+A$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generic-methods'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generic-methods')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A method is written as `static T firstElement(List<T> list) { ... }`, without a `<T>` before the return type. What is the result?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$A method is written as `static T firstElement(List<T> list) { ... }`, without a `<T>` before the return type. What is the result?$$,
           NULL, NULL,
           $$Forgetting the <T> declaration before the return type -- writing static T firstElement(...) -- doesn't compile, since T would be an undeclared type with nothing introducing it.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generic-methods'
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
    ($$It fails to compile -- T is undeclared, since the <T> before the return type was omitted.$$, TRUE, 0),
    ($$It compiles and behaves identically to static <T> T firstElement(List<T> list).$$, FALSE, 1),
    ($$It compiles, treating T as an alias for Object.$$, FALSE, 2),
    ($$It compiles but throws an exception on the first call.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generic-methods'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generic-methods')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are Best Practices recommended in this lesson? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are Best Practices recommended in this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$Prefer a generic method over a generic class when the behavior belongs to a single operation, not a whole family of state; let type inference do its job and only reach for an explicit type witness when the compiler genuinely can't infer the type.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generic-methods'
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
    ($$Prefer a generic method over a generic class when the behavior belongs to a single operation, not a whole family of state.$$, TRUE, 0),
    ($$Let type inference do its job -- only use an explicit type witness when the compiler genuinely can't infer the type.$$, TRUE, 1),
    ($$Add a type witness to every generic method call to make the type parameter explicit.$$, FALSE, 2),
    ($$Make an entire class generic whenever any one of its methods needs a type parameter.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generic-methods'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
