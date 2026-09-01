-- Promotion-style migration linking EN generics-with-collections quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generics-with-collections')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which statement correctly describes `List<T>`, `Set<T>`, and `Map<K, V>`?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Which statement correctly describes `List<T>`, `Set<T>`, and `Map<K, V>`?$$,
           NULL, NULL,
           $$List<T>, Set<T>, and Map<K, V> are themselves ordinary generic types, built with exactly the same mechanism covered in "Introduction to Generics" -- List has one type parameter for its elements, Map has two, one for keys and one for values.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generics-with-collections'
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
    ($$They are ordinary generic types, built with the same mechanism as any custom generic class.$$, TRUE, 0),
    ($$They are special language constructs that use a different mechanism than user-defined generic classes.$$, FALSE, 1),
    ($$Only Map is actually generic; List and Set store raw Object references internally.$$, FALSE, 2),
    ($$List<T> and Set<T> share the exact same type parameter T across all collections.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generics-with-collections'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: MULTIPLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generics-with-collections')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A `Map<String, Integer>` is declared, and code tries `map.put("Bob", "thirty")`, passing a String where an Integer value is expected. Which of the following are true? (Select all that apply)$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A `Map<String, Integer>` is declared, and code tries `map.put("Bob", "thirty")`, passing a String where an Integer value is expected. Which of the following are true? (Select all that apply)$$,
           NULL, NULL,
           $$The compile-time checking from "Introduction to Generics" applies to every collection operation -- add, put, get -- not just to construction. Passing "thirty" where an Integer is expected is rejected at compile time, since Map<String, Integer>'s put expects an Integer value.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generics-with-collections'
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
    ($$The call fails to compile, since put(String, Integer) expects an Integer for the value.$$, TRUE, 0),
    ($$Compile-time checking applies to every collection operation, not just construction.$$, TRUE, 1),
    ($$The call compiles, and the mismatch would only surface later as a ClassCastException.$$, FALSE, 2),
    ($$Map.put always accepts a plain Object for its value regardless of the declared type arguments.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generics-with-collections'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generics-with-collections')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens when this code is compiled?$$
      AND code_snippet = $$static void addNumber(List<Object> list) {
    list.add(42);
}

public class Demo {
    public static void main(String[] args) {
        List<String> names = new ArrayList<>();
        addNumber(names);
    }
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$What happens when this code is compiled?$$,
           $$static void addNumber(List<Object> list) {
    list.add(42);
}

public class Demo {
    public static void main(String[] args) {
        List<String> names = new ArrayList<>();
        addNumber(names);
    }
}$$, $$java$$,
           $$If List<String> WERE allowed to be passed where a List<Object> is expected, addNumber(...) could insert an Integer into what its caller believes is purely a list of Strings -- a broken promise the type system has no way to catch later. Invariance is precisely what prevents that: addNumber(names) is rejected at compile time.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generics-with-collections'
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
    ($$It fails to compile -- addNumber(names) is rejected, since List<String> is not a List<Object>.$$, TRUE, 0),
    ($$It compiles and inserts 42 into names, mixing an Integer into a List<String>.$$, FALSE, 1),
    ($$It compiles but throws ClassCastException when addNumber runs.$$, FALSE, 2),
    ($$It compiles because String and Object are related through inheritance.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generics-with-collections'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generics-with-collections')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$List<String> names = new ArrayList<>();
names.add("Sam");
System.out.println(names.getClass().getSimpleName());$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$List<String> names = new ArrayList<>();
names.add("Sam");
System.out.println(names.getClass().getSimpleName());$$, $$java$$,
           $$The diamond operator, <>, infers a constructor's type argument from the variable it's being assigned to -- new ArrayList<>() assigned to a List<String> variable becomes an ArrayList<String>. At runtime, the class is simply ArrayList (erasure means the type argument doesn't appear in getSimpleName()).$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generics-with-collections'
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
    ($$ArrayList$$, TRUE, 0),
    ($$ArrayList<String>$$, FALSE, 1),
    ($$List$$, FALSE, 2),
    ($$Compile error -- the diamond operator requires an explicit type argument on the left.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generics-with-collections'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generics-with-collections')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What type does `scores` have in `var scores = List.of(90, 85, 78);`?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What type does `scores` have in `var scores = List.of(90, 85, 78);`?$$,
           NULL, NULL,
           $$var infers the variable's own type from whatever's on the right-hand side -- var scores = List.of(90, 85, 78) gives scores the type List<Integer>, deduced entirely from List.of(...)'s arguments.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generics-with-collections'
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
    ($$List<Integer>, deduced entirely from List.of(...)'s arguments.$$, TRUE, 0),
    ($$List<Object>, since var always widens to the most general type.$$, FALSE, 1),
    ($$var itself, a genuinely untyped variable that accepts any assignment later.$$, FALSE, 2),
    ($$List<int[]>, since var treats numeric literals as an array.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generics-with-collections'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generics-with-collections')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens when this code is compiled?$$
      AND code_snippet = $$Map<String, Integer> ages = new HashMap<>();
ages.put("Alice", 30);
ages.put(42, 25);$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What happens when this code is compiled?$$,
           $$Map<String, Integer> ages = new HashMap<>();
ages.put("Alice", 30);
ages.put(42, 25);$$, $$java$$,
           $$A Map<K, V>'s type safety covers keys and values independently -- put(...) is checked against both its own key type and value type. ages.put(42, 25) fails because 42 (an int) isn't a valid key for a Map<String, Integer>, even though 25 is a valid value.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generics-with-collections'
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
    ($$It fails to compile -- 42 isn't a valid key type for Map<String, Integer>.$$, TRUE, 0),
    ($$It compiles, since 42 autoboxes to a valid key of any type.$$, FALSE, 1),
    ($$It compiles but throws ClassCastException at runtime.$$, FALSE, 2),
    ($$It compiles because Map only checks the value type, not the key type.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generics-with-collections'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generics-with-collections')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are true about `var`, according to this lesson? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about `var`, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$var infers a variable's entire declared type from its initializer -- it only removes the need to WRITE the type; the compiler still enforces it exactly as if it had been spelled out. It does not make the variable less strictly typed.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generics-with-collections'
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
    ($$It only removes the need to write the type explicitly -- the compiler still enforces it fully.$$, TRUE, 0),
    ($$It infers the variable's entire type from its initializer at compile time.$$, TRUE, 1),
    ($$It makes the variable's type less strict, allowing more values to be assigned later.$$, FALSE, 2),
    ($$It removes compile-time type checking for that variable entirely.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generics-with-collections'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
