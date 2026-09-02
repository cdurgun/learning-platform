-- Promotion-style migration linking EN primitive-parallel-streams quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: CODE_OUTPUT)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'primitive-parallel-streams')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$import java.util.stream.IntStream;

public class Demo {
    public static void main(String[] args) {
        System.out.println(IntStream.range(1, 5).sum());
        System.out.println(IntStream.rangeClosed(1, 5).sum());
    }
}$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.stream.IntStream;

public class Demo {
    public static void main(String[] args) {
        System.out.println(IntStream.range(1, 5).sum());
        System.out.println(IntStream.rangeClosed(1, 5).sum());
    }
}$$, $$java$$,
           $$IntStream.range(start, end) excludes the end: 1+2+3+4=10. IntStream.rangeClosed(start, end) includes it: 1+2+3+4+5=15.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'primitive-parallel-streams'
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
    ($$10
15$$, TRUE, 0),
    ($$15
10$$, FALSE, 1),
    ($$10
10$$, FALSE, 2),
    ($$15
15$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'primitive-parallel-streams'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'primitive-parallel-streams')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$import java.util.OptionalDouble;
import java.util.stream.IntStream;

public class Demo {
    public static void main(String[] args) {
        IntStream empty = IntStream.of();
        System.out.println(empty.sum());
        OptionalDouble avg = IntStream.of().average();
        System.out.println(avg.isPresent());
    }
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.OptionalDouble;
import java.util.stream.IntStream;

public class Demo {
    public static void main(String[] args) {
        IntStream empty = IntStream.of();
        System.out.println(empty.sum());
        OptionalDouble avg = IntStream.of().average();
        System.out.println(avg.isPresent());
    }
}$$, $$java$$,
           $$sum() returns a plain int directly, 0 for an empty stream. average() returns OptionalDouble instead -- for an empty stream, it's empty, so isPresent() is false.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'primitive-parallel-streams'
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
    ($$0
true$$, FALSE, 0),
    ($$It throws NoSuchElementException on sum().$$, FALSE, 1),
    ($$0
false$$, TRUE, 2),
    ($$Compile error -- IntStream.of() needs at least one argument.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'primitive-parallel-streams'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'primitive-parallel-streams')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class Demo {
    public static void main(String[] args) {
        List<Integer> list = IntStream.rangeClosed(1, 3)
                .boxed()
                .collect(Collectors.toList());
        System.out.println(list);
    }
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class Demo {
    public static void main(String[] args) {
        List<Integer> list = IntStream.rangeClosed(1, 3)
                .boxed()
                .collect(Collectors.toList());
        System.out.println(list);
    }
}$$, $$java$$,
           $$boxed() converts an IntStream directly into a Stream<Integer>, wrapping each primitive value into its corresponding boxed type -- needed here since collect()/Collectors only works with object streams.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'primitive-parallel-streams'
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
    ($$[1, 2, 3]$$, TRUE, 0),
    ($$Compile error -- IntStream can't be collected into a List<Integer>.$$, FALSE, 1),
    ($$[1, 2, 3, 4]$$, FALSE, 2),
    ($$6$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'primitive-parallel-streams'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'primitive-parallel-streams')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$For an associative operation, what changes when you use `parallelStream()` instead of `stream()`?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$For an associative operation, what changes when you use `parallelStream()` instead of `stream()`?$$,
           NULL, NULL,
           $$Only the execution strategy changes -- the result is identical, but the work is split across multiple threads in the common ForkJoinPool.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'primitive-parallel-streams'
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
    ($$parallelStream() only works with primitive streams, never with object streams.$$, FALSE, 0),
    ($$parallelStream() always produces a sorted result, unlike stream().$$, FALSE, 1),
    ($$Only the execution strategy changes -- the result is identical, but the work is split across multiple threads.$$, TRUE, 2),
    ($$The result becomes different because elements are processed in a different mathematical order.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'primitive-parallel-streams'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'primitive-parallel-streams')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$On a parallel stream, what is the key difference between `forEach()` and `forEachOrdered()`?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$On a parallel stream, what is the key difference between `forEach()` and `forEachOrdered()`?$$,
           NULL, NULL,
           $$forEach() processes elements in whatever order each thread picks them up, with no ordering guarantee; forEachOrdered() forces the result back into encounter order, at the cost of most of the parallelism benefit.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'primitive-parallel-streams'
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
    ($$forEach() has no ordering guarantee; forEachOrdered() forces encounter order, at the cost of most of the parallelism benefit.$$, TRUE, 0),
    ($$forEach() always preserves encounter order; forEachOrdered() does not.$$, FALSE, 1),
    ($$forEachOrdered() runs faster than forEach() because it skips thread coordination.$$, FALSE, 2),
    ($$The two are functionally identical on a parallel stream.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'primitive-parallel-streams'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'primitive-parallel-streams')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are true about writing into a plain `ArrayList` from inside a parallel `forEach()`? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about writing into a plain `ArrayList` from inside a parallel `forEach()`? (Select all that apply)$$,
           NULL, NULL,
           $$It creates a genuine data race that can silently produce fewer elements than expected, with no exception thrown. The correct fix is collect(Collectors.toList()), which handles thread-safety internally.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'primitive-parallel-streams'
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
    ($$The bug is guaranteed to occur identically on every single run, making it easy to catch in testing.$$, FALSE, 0),
    ($$Java automatically synchronizes ArrayList.add() calls made from a parallel stream.$$, FALSE, 1),
    ($$It creates a genuine data race that can silently produce fewer elements than expected, with no exception thrown.$$, TRUE, 2),
    ($$The correct fix is to use collect(Collectors.toList()) instead, which handles thread-safety internally.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'primitive-parallel-streams'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'primitive-parallel-streams')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to this lesson, which condition must hold for a parallel stream to be worth using?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$According to this lesson, which condition must hold for a parallel stream to be worth using?$$,
           NULL, NULL,
           $$Parallel streams pay off when all conditions hold together: the dataset is large, the operation is CPU-intensive, and the operation is associative/stateless.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'primitive-parallel-streams'
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
    ($$The dataset must be large, the operation must be CPU-intensive, and the operation must be associative/stateless -- all three together.$$, TRUE, 0),
    ($$Any dataset size benefits from parallelStream(), as long as the operation has no side effects.$$, FALSE, 1),
    ($$Parallel streams are always faster regardless of dataset size or operation cost.$$, FALSE, 2),
    ($$Parallel streams should be used whenever the elements are primitive types like int or long.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'primitive-parallel-streams'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
