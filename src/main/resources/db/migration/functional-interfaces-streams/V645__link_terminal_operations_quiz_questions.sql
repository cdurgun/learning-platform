-- Promotion-style migration linking EN terminal-operations quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'terminal-operations')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why can `forEach(Consumer<T>)` only end a stream pipeline, never continue it?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Why can `forEach(Consumer<T>)` only end a stream pipeline, never continue it?$$,
           NULL, NULL,
           $$forEach() returns void -- there's no result to chain another operation onto.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'terminal-operations'
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
    ($$Because it returns void -- there's no result to chain another operation onto.$$, TRUE, 0),
    ($$Because it's the only lazy operation in the Stream API.$$, FALSE, 1),
    ($$Because Consumer objects can't be reused after one call.$$, FALSE, 2),
    ($$Because forEach() always throws an exception if chained further.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'terminal-operations'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'terminal-operations')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$import java.util.List;
import java.util.Optional;

public class Demo {
    public static void main(String[] args) {
        List<Integer> nums = List.of(2, 3, 4);
        int sum = nums.stream().reduce(0, Integer::sum);
        Optional<Integer> product = nums.stream().reduce((a, b) -> a * b);
        System.out.println(sum);
        System.out.println(product.get());
    }
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.List;
import java.util.Optional;

public class Demo {
    public static void main(String[] args) {
        List<Integer> nums = List.of(2, 3, 4);
        int sum = nums.stream().reduce(0, Integer::sum);
        Optional<Integer> product = nums.stream().reduce((a, b) -> a * b);
        System.out.println(sum);
        System.out.println(product.get());
    }
}$$, $$java$$,
           $$reduce(identity, accumulator) always returns a plain value, starting from 0: 0+2+3+4=9. reduce(accumulator) with no identity returns Optional<T> instead: 2*3*4=24.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'terminal-operations'
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
    ($$9
Optional[24]$$, FALSE, 0),
    ($$Compile error -- reduce needs an identity every time.$$, FALSE, 1),
    ($$9
24$$, TRUE, 2),
    ($$24
9$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'terminal-operations'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'terminal-operations')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$import java.util.Comparator;
import java.util.List;
import java.util.Optional;

public class Demo {
    public static void main(String[] args) {
        List<String> words = List.of("pear", "fig", "banana");
        Optional<String> longest = words.stream().max(Comparator.comparing(String::length));
        System.out.println(longest.orElse("none"));
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
import java.util.List;
import java.util.Optional;

public class Demo {
    public static void main(String[] args) {
        List<String> words = List.of("pear", "fig", "banana");
        Optional<String> longest = words.stream().max(Comparator.comparing(String::length));
        System.out.println(longest.orElse("none"));
    }
}$$, $$java$$,
           $$max() requires a Comparator, since a stream's element type isn't guaranteed to be Comparable. Comparing by length: pear(4), fig(3), banana(6) -- banana is longest.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'terminal-operations'
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
    ($$banana$$, TRUE, 0),
    ($$fig$$, FALSE, 1),
    ($$none$$, FALSE, 2),
    ($$Compile error -- max() requires no arguments for Comparable elements.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'terminal-operations'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'terminal-operations')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$On a sequential stream, how do `findFirst()` and `findAny()` typically behave, according to this lesson?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$On a sequential stream, how do `findFirst()` and `findAny()` typically behave, according to this lesson?$$,
           NULL, NULL,
           $$On a sequential stream they behave identically -- the difference between them only shows up with parallel streams.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'terminal-operations'
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
    ($$findFirst() throws an exception if called on a sequential stream.$$, FALSE, 0),
    ($$findAny() is not available on sequential streams at all.$$, FALSE, 1),
    ($$They behave identically -- the difference between them only shows up with parallel streams.$$, TRUE, 2),
    ($$findAny() always returns a different element than findFirst().$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'terminal-operations'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'terminal-operations')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$import java.util.List;

public class Demo {
    public static void main(String[] args) {
        List<Integer> nums = List.of(2, 4, 6, 8);
        System.out.println(nums.stream().allMatch(n -> n % 2 == 0));
        System.out.println(nums.stream().anyMatch(n -> n > 7));
        System.out.println(nums.stream().noneMatch(n -> n < 0));
    }
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.List;

public class Demo {
    public static void main(String[] args) {
        List<Integer> nums = List.of(2, 4, 6, 8);
        System.out.println(nums.stream().allMatch(n -> n % 2 == 0));
        System.out.println(nums.stream().anyMatch(n -> n > 7));
        System.out.println(nums.stream().noneMatch(n -> n < 0));
    }
}$$, $$java$$,
           $$allMatch checks every element is even -- true. anyMatch checks if at least one element is greater than 7 -- 8 qualifies, true. noneMatch checks no element is negative -- true.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'terminal-operations'
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
    ($$true
true
true$$, TRUE, 0),
    ($$true
false
true$$, FALSE, 1),
    ($$false
true
true$$, FALSE, 2),
    ($$true
true
false$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'terminal-operations'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'terminal-operations')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens when this code runs?$$
      AND code_snippet = $$import java.util.List;

public class Demo {
    public static void main(String[] args) {
        List<Integer> nums = List.of(1, 2, 3).stream().toList();
        nums.add(4);
    }
}$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What happens when this code runs?$$,
           $$import java.util.List;

public class Demo {
    public static void main(String[] args) {
        List<Integer> nums = List.of(1, 2, 3).stream().toList();
        nums.add(4);
    }
}$$, $$java$$,
           $$Stream.toList() returns an unmodifiable list -- unlike collect(Collectors.toList()), which is mutable. Calling add() on it throws UnsupportedOperationException.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'terminal-operations'
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
    ($$It fails to compile.$$, FALSE, 0),
    ($$It throws ConcurrentModificationException.$$, FALSE, 1),
    ($$It throws UnsupportedOperationException.$$, TRUE, 2),
    ($$It compiles and runs fine, adding 4.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'terminal-operations'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'terminal-operations')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are true about `count()`'s behavior, according to this lesson? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about `count()`'s behavior, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$In some situations, the JDK can compute the count directly from the source's known size and skip running the pipeline entirely. When that optimization applies, even a peek() call earlier in the pipeline is never invoked.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'terminal-operations'
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
    ($$In some situations, the JDK can compute the count directly from the source's known size and skip running the pipeline entirely.$$, TRUE, 0),
    ($$When that optimization applies, even a `peek()` call earlier in the pipeline is never invoked.$$, TRUE, 1),
    ($$count() always processes every element of the pipeline, with no exceptions.$$, FALSE, 2),
    ($$This behavior is a bug that will be fixed in a future Java release.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'terminal-operations'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
