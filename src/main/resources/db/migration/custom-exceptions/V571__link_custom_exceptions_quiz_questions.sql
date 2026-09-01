-- Promotion-style migration linking EN custom-exceptions quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'custom-exceptions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What makes a class a valid, usable custom exception type?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What makes a class a valid, usable custom exception type?$$,
           NULL, NULL,
           $$A custom exception is simply a class that extends Exception (making it checked) or RuntimeException (making it unchecked) -- nothing more is required to make it real and usable.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'custom-exceptions'
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
    ($$It must override toString().$$, FALSE, 0),
    ($$It must extend Exception (checked) or RuntimeException (unchecked) -- nothing more is required.$$, TRUE, 1),
    ($$It must be declared final.$$, FALSE, 2),
    ($$It must implement the Throwable interface directly, bypassing Exception/RuntimeException.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'custom-exceptions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'custom-exceptions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$class InvalidOrderQuantityException extends RuntimeException {
    private final int quantity;
    InvalidOrderQuantityException(int quantity) {
        super("invalid quantity: " + quantity);
        this.quantity = quantity;
    }
    int getQuantity() { return quantity; }
}

public class Demo {
    static void placeOrder(int quantity) {
        if (quantity <= 0) {
            throw new InvalidOrderQuantityException(quantity);
        }
    }
    public static void main(String[] args) {
        try {
            placeOrder(-3);
        } catch (InvalidOrderQuantityException e) {
            System.out.println(e.getMessage() + " / qty=" + e.getQuantity());
        }
    }
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$class InvalidOrderQuantityException extends RuntimeException {
    private final int quantity;
    InvalidOrderQuantityException(int quantity) {
        super("invalid quantity: " + quantity);
        this.quantity = quantity;
    }
    int getQuantity() { return quantity; }
}

public class Demo {
    static void placeOrder(int quantity) {
        if (quantity <= 0) {
            throw new InvalidOrderQuantityException(quantity);
        }
    }
    public static void main(String[] args) {
        try {
            placeOrder(-3);
        } catch (InvalidOrderQuantityException e) {
            System.out.println(e.getMessage() + " / qty=" + e.getQuantity());
        }
    }
}$$, $$java$$,
           $$The custom exception stores the rejected quantity in its own field and forwards a message to Exception's constructor -- the catch block reads both the inherited getMessage() and the custom getQuantity() directly.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'custom-exceptions'
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
    ($$invalid quantity: -3 / qty=-3$$, TRUE, 0),
    ($$invalid quantity: -3 / qty=0$$, FALSE, 1),
    ($$Compile error -- getQuantity() is not accessible.$$, FALSE, 2),
    ($$null / qty=-3$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'custom-exceptions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'custom-exceptions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$How many standard constructor shapes does `Throwable` offer, that a well-designed custom exception commonly mirrors?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$How many standard constructor shapes does `Throwable` offer, that a well-designed custom exception commonly mirrors?$$,
           NULL, NULL,
           $$Throwable itself offers four constructors: no-argument, message-only, message-with-cause, and cause-only. A well-designed custom exception commonly mirrors all four.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'custom-exceptions'
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
    ($$Two: no-argument and message-only.$$, FALSE, 0),
    ($$Three: message, cause, and message+cause.$$, FALSE, 1),
    ($$Four: no-argument, message-only, message-with-cause, and cause-only.$$, TRUE, 2),
    ($$One: message-only, since cause is set separately with initCause().$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'custom-exceptions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'custom-exceptions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does this print?$$
      AND code_snippet = $$class PaymentException extends RuntimeException {
    PaymentException(String message) { super(message); }
}
class CardDeclinedException extends PaymentException {
    CardDeclinedException(String message) { super(message); }
}
class PaymentGatewayTimeoutException extends PaymentException {
    PaymentGatewayTimeoutException(String message) { super(message); }
}

public class Demo {
    static void process(int attempt) {
        if (attempt == 1) throw new CardDeclinedException("card declined");
        throw new PaymentGatewayTimeoutException("gateway timeout");
    }
    public static void main(String[] args) {
        for (int i = 1; i <= 2; i++) {
            try {
                process(i);
            } catch (PaymentException e) {
                System.out.println(e.getClass().getSimpleName() + ": " + e.getMessage());
            }
        }
    }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$What does this print?$$,
           $$class PaymentException extends RuntimeException {
    PaymentException(String message) { super(message); }
}
class CardDeclinedException extends PaymentException {
    CardDeclinedException(String message) { super(message); }
}
class PaymentGatewayTimeoutException extends PaymentException {
    PaymentGatewayTimeoutException(String message) { super(message); }
}

public class Demo {
    static void process(int attempt) {
        if (attempt == 1) throw new CardDeclinedException("card declined");
        throw new PaymentGatewayTimeoutException("gateway timeout");
    }
    public static void main(String[] args) {
        for (int i = 1; i <= 2; i++) {
            try {
                process(i);
            } catch (PaymentException e) {
                System.out.println(e.getClass().getSimpleName() + ": " + e.getMessage());
            }
        }
    }
}$$, $$java$$,
           $$Both CardDeclinedException and PaymentGatewayTimeoutException extend PaymentException, so a single catch (PaymentException e) block catches both -- getClass().getSimpleName() still resolves to each exception's actual runtime type.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'custom-exceptions'
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
    ($$CardDeclinedException: card declined / PaymentGatewayTimeoutException: gateway timeout$$, TRUE, 0),
    ($$PaymentException: card declined / PaymentException: gateway timeout$$, FALSE, 1),
    ($$Only the first exception is caught, the second crashes the program.$$, FALSE, 2),
    ($$Compile error -- catching a superclass of a thrown subclass is not allowed.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'custom-exceptions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'custom-exceptions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A custom exception's constructor forgets to call `super(message)`. What is the observable consequence?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A custom exception's constructor forgets to call `super(message)`. What is the observable consequence?$$,
           NULL, NULL,
           $$Common Mistakes explicitly calls out forgetting to call super(message) (or super(message, cause)), leaving getMessage() returning null for no reason.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'custom-exceptions'
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
    ($$The class fails to compile.$$, FALSE, 0),
    ($$getMessage() returns null for no apparent reason.$$, TRUE, 1),
    ($$The exception can no longer be thrown.$$, FALSE, 2),
    ($$getStackTrace() throws a NullPointerException.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'custom-exceptions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'custom-exceptions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why does extending `Throwable` directly (instead of `Exception` or `RuntimeException`) count as a common mistake?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Why does extending `Throwable` directly (instead of `Exception` or `RuntimeException`) count as a common mistake?$$,
           NULL, NULL,
           $$Common Mistakes calls this out: extending Throwable directly bypasses the checked/unchecked distinction entirely and is almost never what you actually want.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'custom-exceptions'
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
    ($$Throwable cannot be extended at all.$$, FALSE, 0),
    ($$It bypasses the checked/unchecked distinction entirely, and is almost never what you actually want.$$, TRUE, 1),
    ($$It makes the exception automatically checked.$$, FALSE, 2),
    ($$It prevents the exception from carrying a message.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'custom-exceptions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'custom-exceptions')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are Best Practices for designing custom exceptions, according to this lesson? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are Best Practices for designing custom exceptions, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$Name every custom exception with an Exception suffix, and add fields for structured data a catch block might need, instead of encoding it only into the message string.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'custom-exceptions'
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
    ($$Name every custom exception type with an Exception suffix.$$, TRUE, 0),
    ($$Add fields for structured data a catch block might need, instead of encoding it only into the message string.$$, TRUE, 1),
    ($$Build a deep hierarchy of custom exceptions "just in case" future subtypes might be useful.$$, FALSE, 2),
    ($$Always extend Exception (checked), regardless of whether callers can recover.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'custom-exceptions'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
