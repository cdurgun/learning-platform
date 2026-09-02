-- Promotion-style migration linking EN optional quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: CODE_OUTPUT)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'optional')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens when this code runs?$$
      AND code_snippet = $$import java.util.Optional;

public class Demo {
    public static void main(String[] args) {
        String value = null;
        Optional<String> opt = Optional.ofNullable(value);
        System.out.println(opt.isPresent());
        Optional<String> opt2 = Optional.of(value);
    }
}$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$What happens when this code runs?$$,
           $$import java.util.Optional;

public class Demo {
    public static void main(String[] args) {
        String value = null;
        Optional<String> opt = Optional.ofNullable(value);
        System.out.println(opt.isPresent());
        Optional<String> opt2 = Optional.of(value);
    }
}$$, $$java$$,
           $$Optional.ofNullable(value) safely wraps a possibly-null value, producing an empty Optional if it is null -- so isPresent() prints false. Optional.of(value) asserts the value is never null -- given null, it throws NullPointerException immediately.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'optional'
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
    ($$It prints false, then throws NullPointerException at Optional.of(value).$$, TRUE, 0),
    ($$It prints false, then true.$$, FALSE, 1),
    ($$It throws NullPointerException immediately at ofNullable.$$, FALSE, 2),
    ($$It prints true, then throws NullPointerException.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'optional'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'optional')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$import java.util.Optional;

public class Demo {
    static String compute() {
        System.out.println("computing");
        return "default";
    }
    public static void main(String[] args) {
        Optional<String> present = Optional.of("value");
        System.out.println(present.orElseGet(Demo::compute));
    }
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.Optional;

public class Demo {
    static String compute() {
        System.out.println("computing");
        return "default";
    }
    public static void main(String[] args) {
        Optional<String> present = Optional.of("value");
        System.out.println(present.orElseGet(Demo::compute));
    }
}$$, $$java$$,
           $$orElseGet()'s Supplier is only invoked if the Optional turns out to be empty. Since present already has a value, compute() never runs.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'optional'
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
    ($$computing
default$$, FALSE, 0),
    ($$default$$, FALSE, 1),
    ($$value$$, TRUE, 2),
    ($$computing
value$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'optional'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'optional')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$When `orElseThrow(Supplier<X>)` is called on an Optional that already has a value present, what happens to the supplied Supplier?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$When `orElseThrow(Supplier<X>)` is called on an Optional that already has a value present, what happens to the supplied Supplier?$$,
           NULL, NULL,
           $$If the Optional is present, the Supplier is never called -- the same lazy-evaluation logic as orElseGet().$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'optional'
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
    ($$It is never invoked -- the same lazy-evaluation logic as orElseGet().$$, TRUE, 0),
    ($$It is always invoked, but its result is discarded.$$, FALSE, 1),
    ($$It throws the exception immediately regardless of whether a value is present.$$, FALSE, 2),
    ($$It is invoked exactly once per Optional instance, regardless of when orElseThrow() is called.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'optional'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'optional')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$import java.util.Optional;

public class Demo {
    static Optional<Integer> parse(String s) {
        try {
            return Optional.of(Integer.parseInt(s));
        } catch (NumberFormatException e) {
            return Optional.empty();
        }
    }
    public static void main(String[] args) {
        Optional<String> input = Optional.of("42");
        Optional<Integer> result = input.flatMap(Demo::parse);
        System.out.println(result.get());
    }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.Optional;

public class Demo {
    static Optional<Integer> parse(String s) {
        try {
            return Optional.of(Integer.parseInt(s));
        } catch (NumberFormatException e) {
            return Optional.empty();
        }
    }
    public static void main(String[] args) {
        Optional<String> input = Optional.of("42");
        Optional<Integer> result = input.flatMap(Demo::parse);
        System.out.println(result.get());
    }
}$$, $$java$$,
           $$flatMap() merges the inner Optional returned by parse() directly into the outer one, instead of producing an awkward Optional<Optional<Integer>>.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'optional'
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
    ($$Compile error -- flatMap requires a Function returning a plain value, not an Optional.$$, FALSE, 0),
    ($$It throws NoSuchElementException.$$, FALSE, 1),
    ($$42$$, TRUE, 2),
    ($$Optional[42]$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'optional'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'optional')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are true about `ifPresent()` and `ifPresentOrElse()`? (Select all that apply)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about `ifPresent()` and `ifPresentOrElse()`? (Select all that apply)$$,
           NULL, NULL,
           $$ifPresent(Consumer) runs a side effect only if a value is present, with no explicit null check needed. ifPresentOrElse(Consumer, Runnable) adds a branch for the empty case, something ifPresent() alone can't express.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'optional'
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
    ($$ifPresent(Consumer) runs a side effect only if a value is present, with no explicit null check needed.$$, TRUE, 0),
    ($$ifPresentOrElse(Consumer, Runnable) adds a branch for the empty case, something ifPresent() alone can't express.$$, TRUE, 1),
    ($$ifPresent() runs its Consumer even when the Optional is empty, passing null.$$, FALSE, 2),
    ($$ifPresentOrElse() requires both branches to return the same type.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'optional'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'optional')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$import java.util.Optional;

public class Demo {
    public static void main(String[] args) {
        Optional<Integer> num = Optional.of(4);
        Optional<Integer> filtered = num.filter(n -> n > 10);
        System.out.println(filtered.isPresent());
    }
}$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$import java.util.Optional;

public class Demo {
    public static void main(String[] args) {
        Optional<Integer> num = Optional.of(4);
        Optional<Integer> filtered = num.filter(n -> n > 10);
        System.out.println(filtered.isPresent());
    }
}$$, $$java$$,
           $$filter(Predicate) keeps the value only if it satisfies the condition -- otherwise it turns a present Optional into an empty one. 4 is not greater than 10, so filtered becomes empty.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'optional'
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
    ($$It throws NoSuchElementException.$$, FALSE, 0),
    ($$Compile error.$$, FALSE, 1),
    ($$false$$, TRUE, 2),
    ($$true$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'optional'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'optional')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to this lesson's Best Practices, where should `Optional` be used?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$According to this lesson's Best Practices, where should `Optional` be used?$$,
           NULL, NULL,
           $$Optional's design intent is purely to communicate "this method might not return a value" -- using it as a field type, a method parameter, or a collection element type is widely discouraged.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'optional'
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
    ($$Only as a method return type -- using it as a field type, a method parameter, or a collection element type is widely discouraged.$$, TRUE, 0),
    ($$As a field type in every class that might have a missing value.$$, FALSE, 1),
    ($$As the element type of a List whenever elements might be absent.$$, FALSE, 2),
    ($$Only as a method parameter, never as a return type.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'optional'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
