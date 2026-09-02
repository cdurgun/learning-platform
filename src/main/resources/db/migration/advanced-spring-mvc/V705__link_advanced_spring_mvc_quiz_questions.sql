-- Promotion-style migration linking EN advanced-spring-mvc quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'advanced-spring-mvc')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is the key architectural difference between a Filter and a HandlerInterceptor?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What is the key architectural difference between a Filter and a HandlerInterceptor?$$,
           NULL, NULL,
           $$Filter is part of the Servlet API and sees every request, before DispatcherServlet; HandlerInterceptor only sees requests DispatcherServlet has matched to a handler.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'advanced-spring-mvc'
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
    ($$They operate at exactly the same layer with no difference$$, FALSE, 0),
    ($$Filter is part of the Servlet API and sees every request (even static files or 404s), before DispatcherServlet; HandlerInterceptor only sees requests DispatcherServlet has matched to a handler$$, TRUE, 1),
    ($$HandlerInterceptor runs before DispatcherServlet, Filter runs after$$, FALSE, 2),
    ($$Filter only works with @RestControllers$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'advanced-spring-mvc'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: MULTIPLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'advanced-spring-mvc')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about HandlerInterceptor's three callbacks are correct? (Select all that apply)$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about HandlerInterceptor's three callbacks are correct? (Select all that apply)$$,
           NULL, NULL,
           $$preHandle runs before the handler, returning false stops the chain; afterCompletion runs even on exception; postHandle runs after the handler succeeds but before the view renders.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'advanced-spring-mvc'
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
    ($$postHandle runs before the handler method is called$$, FALSE, 0),
    ($$postHandle runs after the handler completes successfully, but before the view is rendered$$, TRUE, 1),
    ($$preHandle runs before the handler method; returning false stops the chain immediately$$, TRUE, 2),
    ($$afterCompletion runs after the view is rendered, even if the handler threw an exception$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'advanced-spring-mvc'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'advanced-spring-mvc')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given a Filter wrapping DispatcherServlet's entire call, and a HandlerInterceptor registered on the matched handler, what is the correct nesting order for the "after" phase of a request?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Given a Filter wrapping DispatcherServlet's entire call, and a HandlerInterceptor registered on the matched handler, what is the correct nesting order for the "after" phase of a request?$$,
           NULL, NULL,
           $$The interceptor's afterCompletion runs after the view is rendered, but still before the filter's own "after" code runs.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'advanced-spring-mvc'
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
    ($$Filter's after-code runs, then the interceptor's afterCompletion$$, FALSE, 0),
    ($$The interceptor's afterCompletion runs after the view is rendered, but still before the filter's own "after" code runs$$, TRUE, 1),
    ($$Both run simultaneously, in parallel$$, FALSE, 2),
    ($$afterCompletion never runs if a Filter is also registered$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'advanced-spring-mvc'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'advanced-spring-mvc')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Both interceptors' preHandle return true. In what order do postHandle calls run?$$
      AND code_snippet = $$// Registered in order: AuthInterceptor, then LoggingInterceptor
registry.addInterceptor(authInterceptor);
registry.addInterceptor(loggingInterceptor);$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Both interceptors' preHandle return true. In what order do postHandle calls run?$$,
           $$// Registered in order: AuthInterceptor, then LoggingInterceptor
registry.addInterceptor(authInterceptor);
registry.addInterceptor(loggingInterceptor);$$, $$java$$,
           $$preHandle runs in registration order; postHandle/afterCompletion run in reverse order -- so LoggingInterceptor's postHandle runs first, then AuthInterceptor's.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'advanced-spring-mvc'
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
    ($$A random order, since Spring doesn't guarantee any sequence$$, FALSE, 0),
    ($$Both run simultaneously$$, FALSE, 1),
    ($$AuthInterceptor, then LoggingInterceptor (same as registration order)$$, FALSE, 2),
    ($$LoggingInterceptor, then AuthInterceptor (reverse of registration order)$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'advanced-spring-mvc'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'advanced-spring-mvc')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A request without the X-Api-Key header is sent. What status code does the client actually receive?$$
      AND code_snippet = $$@Override
public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
    if (request.getHeader("X-Api-Key") == null) {
        return false; // status code not set!
    }
    return true;
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A request without the X-Api-Key header is sent. What status code does the client actually receive?$$,
           $$@Override
public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
    if (request.getHeader("X-Api-Key") == null) {
        return false; // status code not set!
    }
    return true;
}$$, $$java$$,
           $$The chain stops, but since response.setStatus(...) was never called, the client gets the default 200 status.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'advanced-spring-mvc'
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
    ($$401 Unauthorized, since that's the semantically correct code$$, FALSE, 0),
    ($$403 Forbidden$$, FALSE, 1),
    ($$200 OK -- the chain stops, but since response.setStatus(...) was never called, the client gets the default status$$, TRUE, 2),
    ($$The request hangs indefinitely with no response$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'advanced-spring-mvc'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'advanced-spring-mvc')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$For a "non-simple" cross-origin request (e.g., one carrying a custom header), what does the browser do before sending the actual request?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$For a "non-simple" cross-origin request (e.g., one carrying a custom header), what does the browser do before sending the actual request?$$,
           NULL, NULL,
           $$It sends a preflight OPTIONS request first, asking the server for permission via Access-Control-Allow-* headers.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'advanced-spring-mvc'
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
    ($$It silently blocks the request without any network activity$$, FALSE, 0),
    ($$It downgrades the request to a "simple" GET automatically$$, FALSE, 1),
    ($$It sends the real request directly, checking headers only in the response$$, FALSE, 2),
    ($$It sends a preflight OPTIONS request first, asking the server for permission via Access-Control-Allow-* headers$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'advanced-spring-mvc'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'advanced-spring-mvc')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A request uploads three files, each 2MB, with max-file-size set to 5MB but max-request-size set to 5MB as well. What happens?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$A request uploads three files, each 2MB, with max-file-size set to 5MB but max-request-size set to 5MB as well. What happens?$$,
           NULL, NULL,
           $$The request is rejected, since the total (6MB) exceeds max-request-size, even though every individual file is under max-file-size -- they're two separate limits.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'advanced-spring-mvc'
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
    ($$All three files are accepted, since each is under max-file-size individually$$, FALSE, 0),
    ($$The request is rejected, since the total (6MB) exceeds max-request-size, even though every individual file is under max-file-size$$, TRUE, 1),
    ($$Only the first two files are accepted, the third silently dropped$$, FALSE, 2),
    ($$max-request-size is ignored when max-file-size is already set$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'advanced-spring-mvc'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
