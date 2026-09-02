-- Promotion-style migration linking EN stream-fundamentals quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'stream-fundamentals')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which statement correctly describes what a `Stream<T>` actually is?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Which statement correctly describes what a `Stream<T>` actually is?$$,
           NULL, NULL,
           $$A Stream is a single-use pipeline that processes elements from a source in sequence -- it doesn't store data itself, unlike a data structure such as a List or a Set.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'stream-fundamentals'
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
    ($$A single-use pipeline that processes elements from a source in sequence -- it doesn't store data itself.$$, TRUE, 0),
    ($$A data structure, similar to a List, that stores its elements internally.$$, FALSE, 1),
    ($$A reusable pipeline that can be traversed multiple times via separate terminal operations.$$, FALSE, 2),
    ($$A synchronized wrapper around a Collection for thread-safe access.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'stream-fundamentals'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'stream-fundamentals')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$import java.util.List;

public class Demo {
    public static void main(String[] args) {
        List<String> names = List.of("Ann", "Bob", "Cara", "Dan");
        List<String> result = names.stream()
                .filter(n -> n.length() > 3)
                .map(String::toUpperCase)
                .toList();
        System.out.println(result);
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

public class Demo {
    public static void main(String[] args) {
        List<String> names = List.of("Ann", "Bob", "Cara", "Dan");
        List<String> result = names.stream()
                .filter(n -> n.length() > 3)
                .map(String::toUpperCase)
                .toList();
        System.out.println(result);
    }
}$$, $$java$$,
           $$filter() keeps only elements matching the predicate -- of Ann(3), Bob(3), Cara(4), Dan(3), only "Cara" has length > 3. map() then transforms the surviving element to uppercase.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'stream-fundamentals'
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
    ($$[]$$, FALSE, 0),
    ($$Compile error.$$, FALSE, 1),
    ($$[CARA]$$, TRUE, 2),
    ($$[ANN, BOB, CARA, DAN]$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'stream-fundamentals'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'stream-fundamentals')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$import java.util.List;
import java.util.stream.Collectors;

public class Demo {
    public static void main(String[] args) {
        List<List<Integer>> nested = List.of(List.of(1, 2), List.of(3, 4), List.of(5));
        List<Integer> flat = nested.stream()
                .flatMap(List::stream)
                .collect(Collectors.toList());
        System.out.println(flat);
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
import java.util.stream.Collectors;

public class Demo {
    public static void main(String[] args) {
        List<List<Integer>> nested = List.of(List.of(1, 2), List.of(3, 4), List.of(5));
        List<Integer> flat = nested.stream()
                .flatMap(List::stream)
                .collect(Collectors.toList());
        System.out.println(flat);
    }
}$$, $$java$$,
           $$flatMap() turns each inner List into a stream and merges those streams into a single flat stream, avoiding the "stream of streams" problem map() would produce.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'stream-fundamentals'
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
    ($$[1, 2, 3, 4, 5]$$, TRUE, 0),
    ($$[[1, 2], [3, 4], [5]]$$, FALSE, 1),
    ($$[1, 2]$$, FALSE, 2),
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
WHERE t.slug = 'stream-fundamentals'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'stream-fundamentals')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does `distinct()` use to determine whether two stream elements are duplicates?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does `distinct()` use to determine whether two stream elements are duplicates?$$,
           NULL, NULL,
           $$distinct() removes duplicate elements based on equals().$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'stream-fundamentals'
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
    ($$`hashCode()` alone, without calling equals()$$, FALSE, 0),
    ($$`compareTo()` from Comparable$$, FALSE, 1),
    ($$`equals()`$$, TRUE, 2),
    ($$`==` reference identity only$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'stream-fundamentals'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'stream-fundamentals')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$import java.util.List;

public class Demo {
    public static void main(String[] args) {
        List<Integer> nums = List.of(10, 20, 30, 40, 50, 60);
        List<Integer> page = nums.stream()
                .skip(2)
                .limit(2)
                .toList();
        System.out.println(page);
    }
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.List;

public class Demo {
    public static void main(String[] args) {
        List<Integer> nums = List.of(10, 20, 30, 40, 50, 60);
        List<Integer> page = nums.stream()
                .skip(2)
                .limit(2)
                .toList();
        System.out.println(page);
    }
}$$, $$java$$,
           $$skip(2) discards the first two elements, leaving [30, 40, 50, 60]. limit(2) then keeps only the first two of those: [30, 40].$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'stream-fundamentals'
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
    ($$[30, 40]$$, TRUE, 0),
    ($$[10, 20]$$, FALSE, 1),
    ($$[50, 60]$$, FALSE, 2),
    ($$[20, 30]$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'stream-fundamentals'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'stream-fundamentals')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are true about intermediate operations like `filter()` and `map()`? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about intermediate operations like `filter()` and `map()`? (Select all that apply)$$,
           NULL, NULL,
           $$Intermediate operations are lazy -- calling them doesn't run anything yet, it just adds a step to the pipeline's description. Real work only starts once a terminal operation is called.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'stream-fundamentals'
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
    ($$Each intermediate operation processes the entire source collection to completion before the next operation starts.$$, FALSE, 0),
    ($$An intermediate operation returns void, so it can't be chained further.$$, FALSE, 1),
    ($$They are lazy -- calling them doesn't run anything yet, it just adds a step to the pipeline's description.$$, TRUE, 2),
    ($$Real work only starts once a terminal operation is called.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'stream-fundamentals'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: CODE_OUTPUT)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'stream-fundamentals')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens when this code runs?$$
      AND code_snippet = $$import java.util.List;
import java.util.stream.Stream;

public class Demo {
    public static void main(String[] args) {
        Stream<String> stream = List.of("a", "b", "c").stream();
        long count = stream.count();
        System.out.println(count);
        stream.forEach(System.out::println);
    }
}$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$What happens when this code runs?$$,
           $$import java.util.List;
import java.util.stream.Stream;

public class Demo {
    public static void main(String[] args) {
        Stream<String> stream = List.of("a", "b", "c").stream();
        long count = stream.count();
        System.out.println(count);
        stream.forEach(System.out::println);
    }
}$$, $$java$$,
           $$A stream is single-use: once a terminal operation like count() runs, the stream is closed, and trying to reuse the same stream reference throws IllegalStateException.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'stream-fundamentals'
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
    ($$It prints 3, then throws IllegalStateException on the second use.$$, TRUE, 0),
    ($$It prints 3, then a, b, c.$$, FALSE, 1),
    ($$It fails to compile -- a Stream reference can't be reused at all, even syntactically.$$, FALSE, 2),
    ($$It prints 3 and silently does nothing on the second call.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'stream-fundamentals'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
