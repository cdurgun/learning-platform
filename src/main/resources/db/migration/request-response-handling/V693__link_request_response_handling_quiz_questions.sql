-- Promotion-style migration linking EN request-response-handling quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'request-response-handling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does @RequestBody do?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does @RequestBody do?$$,
           NULL, NULL,
           $$@RequestBody reads the entire HTTP request body and converts it into a Java object.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'request-response-handling'
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
    ($$It reads a single named value from the query string$$, FALSE, 0),
    ($$It reads the entire HTTP request body and converts it into a Java object$$, TRUE, 1),
    ($$It reads a single HTTP header$$, FALSE, 2),
    ($$It only works with XML payloads, never JSON$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'request-response-handling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'request-response-handling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What actually performs the conversion between a JSON request body and a Java object behind @RequestBody?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What actually performs the conversion between a JSON request body and a Java object behind @RequestBody?$$,
           NULL, NULL,
           $$An HttpMessageConverter -- for JSON, this is backed by Jackson's ObjectMapper.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'request-response-handling'
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
    ($$The ConversionService, the same component used for @PathVariable/@RequestParam$$, FALSE, 0),
    ($$The ViewResolver$$, FALSE, 1),
    ($$@RequestBody has its own built-in parser, independent of any other component$$, FALSE, 2),
    ($$An HttpMessageConverter -- for JSON, this is backed by Jackson's ObjectMapper$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'request-response-handling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'request-response-handling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Two separate requests are sent to a @RequestBody CreateUserRequest endpoint: (1) {"name": "Alice"} (email missing), (2) {"name": "Bob", "email": "b@x.com", "age": 30} (extra unknown field age). What happens in each case?$$
      AND code_snippet = $$record CreateUserRequest(String name, String email) {}
// Jackson uses default settings (no @JsonIgnoreProperties etc.)$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Two separate requests are sent to a @RequestBody CreateUserRequest endpoint: (1) {"name": "Alice"} (email missing), (2) {"name": "Bob", "email": "b@x.com", "age": 30} (extra unknown field age). What happens in each case?$$,
           $$record CreateUserRequest(String name, String email) {}
// Jackson uses default settings (no @JsonIgnoreProperties etc.)$$, $$java$$,
           $$A missing field is silently assigned null, no error at all. An unknown field throws an UnrecognizedPropertyException, since Jackson's default is to reject fields it doesn't recognize.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'request-response-handling'
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
    ($$Both requests are accepted without error$$, FALSE, 0),
    ($$Request 1 is accepted with email set to null; request 2 is rejected with an UnrecognizedPropertyException$$, TRUE, 1),
    ($$Both requests are rejected$$, FALSE, 2),
    ($$Request 1 is rejected for a missing field; request 2 is accepted, ignoring age$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'request-response-handling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: MULTIPLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'request-response-handling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are capabilities ResponseEntity gives a controller method, beyond what a plain return value offers? (Select all that apply)$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are capabilities ResponseEntity gives a controller method, beyond what a plain return value offers? (Select all that apply)$$,
           NULL, NULL,
           $$ResponseEntity gives full control over the status code and lets you add custom headers like Location.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'request-response-handling'
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
    ($$Automatically validating the request body before it arrives$$, FALSE, 0),
    ($$Choosing between JSON and XML output without any other configuration$$, FALSE, 1),
    ($$Setting an arbitrary HTTP status code, like 404 or 201$$, TRUE, 2),
    ($$Adding custom response headers, like Location$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'request-response-handling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'request-response-handling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A client tries to close an account that still has a positive balance -- the request is well-formed, but conflicts with the server's current state. Which status code fits best?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A client tries to close an account that still has a positive balance -- the request is well-formed, but conflicts with the server's current state. Which status code fits best?$$,
           NULL, NULL,
           $$409 Conflict -- the request is well-formed but conflicts with the current server state.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'request-response-handling'
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
    ($$400 Bad Request$$, FALSE, 0),
    ($$403 Forbidden$$, FALSE, 1),
    ($$409 Conflict$$, TRUE, 2),
    ($$422 Unprocessable Entity$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'request-response-handling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'request-response-handling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Inside a controller method, an ArithmeticException is thrown that is caught by neither a ResponseStatusException nor any @ExceptionHandler. What does the client receive?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Inside a controller method, an ArithmeticException is thrown that is caught by neither a ResponseStatusException nor any @ExceptionHandler. What does the client receive?$$,
           NULL, NULL,
           $$A generic 500 Internal Server Error, with exception details staying only in server logs, never leaking to the client.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'request-response-handling'
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
    ($$400 Bad Request, since Spring treats any uncaught exception as a client error$$, FALSE, 0),
    ($$The request simply hangs with no response$$, FALSE, 1),
    ($$The raw stack trace as plain text$$, FALSE, 2),
    ($$A generic 500 Internal Server Error, with exception details staying only in server logs$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'request-response-handling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: CODE_OUTPUT)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'request-response-handling')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A client sends GET /products/1 with header Accept: text/csv. What is the result?$$
      AND code_snippet = $$@GetMapping(path = "/products/1", produces = "application/json")
public String asJson() { return "{...}"; }

@GetMapping(path = "/products/1", produces = "application/xml")
public String asXml() { return "<product>...</product>"; }$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$A client sends GET /products/1 with header Accept: text/csv. What is the result?$$,
           $$@GetMapping(path = "/products/1", produces = "application/json")
public String asJson() { return "{...}"; }

@GetMapping(path = "/products/1", produces = "application/xml")
public String asXml() { return "<product>...</product>"; }$$, $$java$$,
           $$406 Not Acceptable, since the path exists but no produces value matches the requested Accept header.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'request-response-handling'
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
    ($$asJson() runs, since JSON is the default fallback$$, FALSE, 0),
    ($$404 Not Found, since the path is treated as missing$$, FALSE, 1),
    ($$406 Not Acceptable, since the path exists but no produces value matches the requested Accept$$, TRUE, 2),
    ($$415 Unsupported Media Type$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'request-response-handling'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
