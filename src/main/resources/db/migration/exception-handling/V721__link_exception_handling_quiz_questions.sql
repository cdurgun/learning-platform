-- Promotion-style migration linking EN exception-handling quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-handling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What exception does Spring throw when @Valid fails on a @RequestBody, and what does it carry?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What exception does Spring throw when @Valid fails on a @RequestBody, and what does it carry?$$,
           NULL, NULL,
           $$MethodArgumentNotValidException, carrying a BindingResult with per-field errors.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'exception-handling'
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
    ($$IllegalArgumentException, carrying nothing useful$$, FALSE, 0),
    ($$MethodArgumentNotValidException, carrying a BindingResult with per-field errors$$, TRUE, 1),
    ($$ConstraintViolationException, carrying a raw Set<ConstraintViolation> only$$, FALSE, 2),
    ($$ValidationException, carrying the original request body$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-handling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-handling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$The request body fails both @NotBlank on name and the class-level @ValidDateRange custom constraint. What does the client's errors array contain?$$
      AND code_snippet = $$@ExceptionHandler(MethodArgumentNotValidException.class)
public ProblemDetail handle(MethodArgumentNotValidException ex) {
    List<String> errors = ex.getBindingResult().getFieldErrors().stream()
        .map(fe -> fe.getField() + ": " + fe.getDefaultMessage())
        .toList();
    ProblemDetail pd = ProblemDetail.forStatusAndDetail(HttpStatus.BAD_REQUEST, "Validation failed");
    pd.setProperty("errors", errors);
    return pd;
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$The request body fails both @NotBlank on name and the class-level @ValidDateRange custom constraint. What does the client's errors array contain?$$,
           $$@ExceptionHandler(MethodArgumentNotValidException.class)
public ProblemDetail handle(MethodArgumentNotValidException ex) {
    List<String> errors = ex.getBindingResult().getFieldErrors().stream()
        .map(fe -> fe.getField() + ": " + fe.getDefaultMessage())
        .toList();
    ProblemDetail pd = ProblemDetail.forStatusAndDetail(HttpStatus.BAD_REQUEST, "Validation failed");
    pd.setProperty("errors", errors);
    return pd;
}$$, $$java$$,
           $$Only the name failure -- the @ValidDateRange failure surfaces as an ObjectError in getGlobalErrors(), which this handler never reads.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'exception-handling'
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
    ($$Neither failure, since combining a field and a class-level failure throws a different exception$$, FALSE, 0),
    ($$Only the @ValidDateRange failure, since class-level constraints are checked first$$, FALSE, 1),
    ($$Both failures, since getFieldErrors() covers every validation failure$$, FALSE, 2),
    ($$Only the name failure -- the @ValidDateRange failure surfaces as an ObjectError in getGlobalErrors(), which this handler never reads$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-handling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: MULTIPLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-handling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are legitimate reasons to attach custom properties to a ProblemDetail beyond a single "errors" list? (Select all that apply)$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are legitimate reasons to attach custom properties to a ProblemDetail beyond a single "errors" list? (Select all that apply)$$,
           NULL, NULL,
           $$A machine-readable errorCode and details like resource id/timestamp are legitimate custom properties; ProblemDetail doesn't require custom properties, and adding them doesn't break RFC 7807.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'exception-handling'
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
    ($$Attaching a machine-readable errorCode a client can branch on reliably, unlike a human-readable message$$, TRUE, 0),
    ($$Attaching the specific resource id involved, or a timestamp$$, TRUE, 1),
    ($$It's required -- ProblemDetail cannot be returned without at least one custom property$$, FALSE, 2),
    ($$It breaks RFC 7807 compliance, since the standard only allows fixed fields$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-handling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-handling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A client tries to register with an email address that's already taken by another account -- the request is well-formed, but conflicts with existing data. Which status code fits?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A client tries to register with an email address that's already taken by another account -- the request is well-formed, but conflicts with existing data. Which status code fits?$$,
           NULL, NULL,
           $$409 Conflict -- the request is well-formed but conflicts with existing state.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'exception-handling'
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
    ($$422 Unprocessable Entity$$, FALSE, 0),
    ($$404 Not Found$$, FALSE, 1),
    ($$400 Bad Request$$, FALSE, 2),
    ($$409 Conflict$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-handling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-handling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is the purpose of extending ResponseEntityExceptionHandler and overriding one method like handleMethodArgumentNotValid(...)?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$What is the purpose of extending ResponseEntityExceptionHandler and overriding one method like handleMethodArgumentNotValid(...)?$$,
           NULL, NULL,
           $$It customizes exactly that one case while every other framework exception it already handles keeps its sensible default behavior automatically.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'exception-handling'
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
    ($$It replaces @RestControllerAdvice entirely for an application's own custom exceptions$$, FALSE, 0),
    ($$It customizes exactly that one case while every other framework exception it already handles keeps its sensible default behavior automatically$$, TRUE, 1),
    ($$It disables Spring's default exception handling for the whole application$$, FALSE, 2),
    ($$It only works for @Controllers, never @RestControllers$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-handling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-handling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following describe a "safe" error response? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Which of the following describe a "safe" error response? (Select all that apply)$$,
           NULL, NULL,
           $$Logging the full exception internally and returning a generic message to the client are safe; leaking stack traces or internal hostnames/paths is not.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'exception-handling'
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
    ($$Returning the exception's stack trace in the response body so the client can debug the issue themselves$$, FALSE, 0),
    ($$Including an internal database hostname or file path in the response for transparency$$, FALSE, 1),
    ($$Logging the full exception (message + stack trace) where only the team can see it, such as server logs$$, TRUE, 2),
    ($$Returning a generic, constant message to the client instead of e.getMessage() or e.toString()$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-handling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-handling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why is returning 500 Internal Server Error for every kind of failure considered a design mistake?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Why is returning 500 Internal Server Error for every kind of failure considered a design mistake?$$,
           NULL, NULL,
           $$It can't tell "you sent bad data" apart from "our database is down," giving the client no way to know if retrying would help.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'exception-handling'
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
    ($$500 is technically not a valid HTTP status code in modern APIs$$, FALSE, 0),
    ($$It can't tell "you sent bad data" apart from "our database is down," giving the client no way to know if retrying would help$$, TRUE, 1),
    ($$500 responses are always slower to generate than 4xx responses$$, FALSE, 2),
    ($$Spring MVC doesn't allow 500 to be returned manually, only automatically$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-handling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
