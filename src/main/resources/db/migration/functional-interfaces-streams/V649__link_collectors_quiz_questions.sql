-- Promotion-style migration linking EN collectors quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: CODE_OUTPUT)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'collectors')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$import java.util.List;
import java.util.stream.Collectors;

public class Demo {
    public static void main(String[] args) {
        List<Integer> nums = List.of(1, 2, 3).stream().collect(Collectors.toList());
        nums.add(4);
        System.out.println(nums);
    }
}$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.List;
import java.util.stream.Collectors;

public class Demo {
    public static void main(String[] args) {
        List<Integer> nums = List.of(1, 2, 3).stream().collect(Collectors.toList());
        nums.add(4);
        System.out.println(nums);
    }
}$$, $$java$$,
           $$Unlike Stream.toList(), the list collect(Collectors.toList()) returns is mutable -- add() works fine.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'collectors'
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
    ($$[1, 2, 3, 4]$$, TRUE, 0),
    ($$It throws UnsupportedOperationException.$$, FALSE, 1),
    ($$[1, 2, 3]$$, FALSE, 2),
    ($$Compile error.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'collectors'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'collectors')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following is NOT a valid overload of `Collectors.joining()`?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Which of the following is NOT a valid overload of `Collectors.joining()`?$$,
           NULL, NULL,
           $$Collectors.joining() has exactly three overloads: no arguments, a delimiter, and a delimiter with a prefix and suffix. There is no four-argument form with a limit.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'collectors'
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
    ($$`joining(delimiter)`$$, FALSE, 0),
    ($$`joining(delimiter, prefix, suffix)`$$, FALSE, 1),
    ($$`joining(delimiter, prefix, suffix, limit)`$$, TRUE, 2),
    ($$`joining()` with no arguments$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'collectors'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'collectors')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class Demo {
    public static void main(String[] args) {
        List<String> words = List.of("cat", "car", "dog", "door");
        Map<Character, List<String>> byFirst = words.stream()
                .collect(Collectors.groupingBy(w -> w.charAt(0)));
        System.out.println(byFirst.get('c'));
        System.out.println(byFirst.get('d'));
    }
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class Demo {
    public static void main(String[] args) {
        List<String> words = List.of("cat", "car", "dog", "door");
        Map<Character, List<String>> byFirst = words.stream()
                .collect(Collectors.groupingBy(w -> w.charAt(0)));
        System.out.println(byFirst.get('c'));
        System.out.println(byFirst.get('d'));
    }
}$$, $$java$$,
           $$groupingBy() derives a key from each element (its first character here) and groups elements sharing that key into a List, producing a Map<K, List<T>>.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'collectors'
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
    ($$[cat, car]
[dog, door]$$, TRUE, 0),
    ($$[dog, door]
[cat, car]$$, FALSE, 1),
    ($$[cat, car, dog, door]
null$$, FALSE, 2),
    ($$Compile error.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'collectors'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'collectors')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class Demo {
    public static void main(String[] args) {
        List<String> words = List.of("cat", "car", "dog", "door", "duck");
        Map<Character, Long> countByFirst = words.stream()
                .collect(Collectors.groupingBy(w -> w.charAt(0), Collectors.counting()));
        System.out.println(countByFirst.get('c'));
        System.out.println(countByFirst.get('d'));
    }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class Demo {
    public static void main(String[] args) {
        List<String> words = List.of("cat", "car", "dog", "door", "duck");
        Map<Character, Long> countByFirst = words.stream()
                .collect(Collectors.groupingBy(w -> w.charAt(0), Collectors.counting()));
        System.out.println(countByFirst.get('c'));
        System.out.println(countByFirst.get('d'));
    }
}$$, $$java$$,
           $$A downstream collector determines what happens to each group's elements instead of the default List. Collectors.counting() reduces each group directly to its size.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'collectors'
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
    ($$[cat, car]
[dog, door, duck]$$, FALSE, 0),
    ($$Compile error -- groupingBy() only accepts one argument.$$, FALSE, 1),
    ($$2
3$$, TRUE, 2),
    ($$3
2$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'collectors'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'collectors')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$How does `Collectors.partitioningBy(predicate)` differ from `Collectors.groupingBy()` in terms of guaranteed map keys?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$How does `Collectors.partitioningBy(predicate)` differ from `Collectors.groupingBy()` in terms of guaranteed map keys?$$,
           NULL, NULL,
           $$partitioningBy() always produces both a true and a false key in the result Map, even if one group is empty; groupingBy() only includes keys that actually had matching elements.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'collectors'
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
    ($$partitioningBy() always produces both a true and a false key, even if one group is empty; groupingBy() only includes keys that actually had matching elements.$$, TRUE, 0),
    ($$groupingBy() always produces exactly two keys, just like partitioningBy().$$, FALSE, 1),
    ($$partitioningBy() omits a key entirely if that group is empty, exactly like groupingBy().$$, FALSE, 2),
    ($$Neither guarantees any particular set of keys in the result.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'collectors'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'collectors')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens when this code runs?$$
      AND code_snippet = $$import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class Demo {
    public static void main(String[] args) {
        List<String> words = List.of("cat", "car", "dog");
        Map<Character, String> byFirst = words.stream()
                .collect(Collectors.toMap(w -> w.charAt(0), w -> w));
        System.out.println(byFirst);
    }
}$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$What happens when this code runs?$$,
           $$import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class Demo {
    public static void main(String[] args) {
        List<String> words = List.of("cat", "car", "dog");
        Map<Character, String> byFirst = words.stream()
                .collect(Collectors.toMap(w -> w.charAt(0), w -> w));
        System.out.println(byFirst);
    }
}$$, $$java$$,
           $$Collectors.toMap()'s sharpest edge: if two different elements produce the same key, it throws IllegalStateException by default. Here "cat" and "car" both map to the key 'c'.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'collectors'
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
    ($$The map keeps only "cat" (first one wins).$$, FALSE, 0),
    ($$It compiles but silently produces an empty map.$$, FALSE, 1),
    ($$It throws IllegalStateException, since "cat" and "car" both map to the key 'c'.$$, TRUE, 2),
    ($$The map keeps only "car" (last one wins).$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'collectors'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'collectors')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following correctly describe the three functions that make up a `Collector`? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe the three functions that make up a `Collector`? (Select all that apply)$$,
           NULL, NULL,
           $$A supplier creates an empty container to hold the result, like an empty ArrayList. An accumulator adds each element into that container.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'collectors'
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
    ($$A supplier creates an empty container to hold the result, like an empty ArrayList.$$, TRUE, 0),
    ($$An accumulator adds each element into that container.$$, TRUE, 1),
    ($$A combiner is only ever used for sequential streams, never for parallel ones.$$, FALSE, 2),
    ($$Every static method in the Collectors class requires you to define all three functions yourself.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'collectors'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
