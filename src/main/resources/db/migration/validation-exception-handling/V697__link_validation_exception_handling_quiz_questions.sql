-- Promotion-style migration linking EN validation-exception-handling quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'validation-exception-handling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which annotation rejects null, an empty string (""), and a whitespace-only string ("   ")?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Which annotation rejects null, an empty string (""), and a whitespace-only string ("   ")?$$,
           NULL, NULL,
           $$@NotBlank rejects null, empty string, and whitespace-only strings alike -- the strictest of the three.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'validation-exception-handling'
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
    ($$@NotNull$$, FALSE, 0),
    ($$@NotEmpty$$, FALSE, 1),
    ($$@NotBlank$$, TRUE, 2),
    ($$@Size(min = 1)$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'validation-exception-handling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: MULTIPLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'validation-exception-handling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following values pass validation for a field annotated @Size(min = 3, max = 50)? (Select all that apply)$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following values pass validation for a field annotated @Size(min = 3, max = 50)? (Select all that apply)$$,
           NULL, NULL,
           $$Both bounds are inclusive -- exactly 3 and exactly 50 characters both pass; 2 and 51 both fail.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'validation-exception-handling'
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
    ($$A string with exactly 2 characters$$, FALSE, 0),
    ($$A string with exactly 51 characters$$, FALSE, 1),
    ($$A string with exactly 3 characters$$, TRUE, 2),
    ($$A string with exactly 50 characters$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'validation-exception-handling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'validation-exception-handling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What triggers Bean Validation rules written on a request record's fields to actually run?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What triggers Bean Validation rules written on a request record's fields to actually run?$$,
           NULL, NULL,
           $$They only run when the parameter is annotated with @Valid (or @Validated).$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'validation-exception-handling'
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
    ($$They run automatically whenever the record is instantiated$$, FALSE, 0),
    ($$They run only if the class also implements Serializable$$, FALSE, 1),
    ($$They run only when the parameter is annotated with @Valid (or @Validated)$$, TRUE, 2),
    ($$They run automatically for every @RequestBody parameter, with no extra annotation needed$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'validation-exception-handling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'validation-exception-handling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A request arrives with address.city blank (""). What happens?$$
      AND code_snippet = $$record Address(@NotBlank String city) {}
record ShippingRequest(String recipient, Address address) {}
// Note: no @Valid on the address field

@PostMapping("/ship")
public String ship(@Valid @RequestBody ShippingRequest request) {
    return "OK";
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$A request arrives with address.city blank (""). What happens?$$,
           $$record Address(@NotBlank String city) {}
record ShippingRequest(String recipient, Address address) {}
// Note: no @Valid on the address field

@PostMapping("/ship")
public String ship(@Valid @RequestBody ShippingRequest request) {
    return "OK";
}$$, $$java$$,
           $$Address's own @NotBlank rule never runs because address lacks its own @Valid -- cascading wasn't enabled, so the nested object's constraints are silently skipped.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'validation-exception-handling'
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
    ($$A NullPointerException is thrown while validating$$, FALSE, 0),
    ($$recipient is also rejected as a side effect$$, FALSE, 1),
    ($$The request is rejected with a validation error mentioning address.city$$, FALSE, 2),
    ($$The request is accepted -- Address's own @NotBlank rule never runs because address lacks its own @Valid (cascading wasn't enabled)$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'validation-exception-handling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'validation-exception-handling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Is @ExceptionHandler, placed directly on a method inside a single @Controller class, scoped to that controller only, or applied application-wide?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Is @ExceptionHandler, placed directly on a method inside a single @Controller class, scoped to that controller only, or applied application-wide?$$,
           NULL, NULL,
           $$Scoped to that same controller only -- it catches exceptions thrown by handler methods in that same class.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'validation-exception-handling'
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
    ($$Scoped to that same controller only -- it catches exceptions thrown by handler methods in that same class$$, TRUE, 0),
    ($$Applied application-wide by default$$, FALSE, 1),
    ($$It requires @RestControllerAdvice to function at all$$, FALSE, 2),
    ($$It only works for @RestControllers, never @Controllers$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'validation-exception-handling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'validation-exception-handling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A @RestControllerAdvice class has @ExceptionHandlers for ResourceNotFoundException, IllegalArgumentException, and Exception (in that file order, Exception written first). Which statements are correct? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A @RestControllerAdvice class has @ExceptionHandlers for ResourceNotFoundException, IllegalArgumentException, and Exception (in that file order, Exception written first). Which statements are correct? (Select all that apply)$$,
           NULL, NULL,
           $$Spring picks the most specific matching handler regardless of file order; Exception.class is a last-resort catch-all that only fires when nothing more specific matches.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'validation-exception-handling'
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
    ($$The Exception.class handler only fires when no more specific handler matches -- it's a last-resort catch-all$$, TRUE, 0),
    ($$Declaring three separate handlers in one class is not allowed -- only one @ExceptionHandler per class is permitted$$, FALSE, 1),
    ($$Spring picks the most specific matching handler for the thrown exception's type, regardless of the order they appear in the file$$, TRUE, 2),
    ($$Since Exception.class is written first, it always wins over the more specific handlers$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'validation-exception-handling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'validation-exception-handling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does ProblemDetail.forStatusAndDetail(status, detail) provide beyond just returning a plain String error message?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does ProblemDetail.forStatusAndDetail(status, detail) provide beyond just returning a plain String error message?$$,
           NULL, NULL,
           $$A standardized RFC 7807 body carrying the status code, an automatically-derived title, and the given detail -- plus the ability to attach custom fields via setProperty(...).$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'validation-exception-handling'
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
    ($$It automatically retries the failed request$$, FALSE, 0),
    ($$A standardized RFC 7807 body carrying the status code, an automatically-derived title, and the given detail -- plus the ability to attach custom fields via setProperty(...)$$, TRUE, 1),
    ($$It disables further exception handling for the rest of the request$$, FALSE, 2),
    ($$It converts the response to XML instead of JSON$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'validation-exception-handling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
