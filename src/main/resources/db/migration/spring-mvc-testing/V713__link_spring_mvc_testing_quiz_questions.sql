-- Promotion-style migration linking EN spring-mvc-testing quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-testing')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does @WebMvcTest load, and what does it deliberately exclude?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does @WebMvcTest load, and what does it deliberately exclude?$$,
           NULL, NULL,
           $$It loads DispatcherServlet, message converters, and the given controller(s) -- but excludes @Service/@Repository beans.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-testing'
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
    ($$It loads the entire application, including a real database connection$$, FALSE, 0),
    ($$It loads DispatcherServlet, message converters, and the given controller(s) -- but excludes @Service/@Repository beans$$, TRUE, 1),
    ($$It loads only the @Service layer, excluding all web components$$, FALSE, 2),
    ($$It loads nothing at all until @MockitoBean is added$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-testing'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-testing')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is the key difference between MockMvcBuilders.standaloneSetup(...) and @WebMvcTest combined with an autowired MockMvc?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What is the key difference between MockMvcBuilders.standaloneSetup(...) and @WebMvcTest combined with an autowired MockMvc?$$,
           NULL, NULL,
           $$standaloneSetup(...) wires controllers by hand without a Spring ApplicationContext, while @WebMvcTest loads a real (narrowed) Spring context.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-testing'
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
    ($$standaloneSetup(...) requires a real database connection, @WebMvcTest does not$$, FALSE, 0),
    ($$@WebMvcTest cannot be combined with @MockitoBean$$, FALSE, 1),
    ($$They are functionally identical in every respect$$, FALSE, 2),
    ($$standaloneSetup(...) wires controllers by hand without a Spring ApplicationContext, while @WebMvcTest loads a real (narrowed) Spring context$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-testing'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-testing')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does @MockitoBean do, and why did this project's lesson stop using @MockBean?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does @MockitoBean do, and why did this project's lesson stop using @MockBean?$$,
           NULL, NULL,
           $$@MockitoBean adds a Mockito mock to the test context (or replaces a real bean); @MockBean was deprecated in Spring Boot 3.4 and removed in the 4.1.0 this project runs.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-testing'
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
    ($$@MockitoBean adds a Mockito mock to the test context (or replaces a real bean); @MockBean was deprecated in Spring Boot 3.4 and removed in the 4.1.0 this project runs$$, TRUE, 0),
    ($$@MockitoBean is a stricter, compile-time-only version of @MockBean with no runtime behavior$$, FALSE, 1),
    ($$@MockBean is still the recommended annotation; @MockitoBean is only for @SpringBootTest$$, FALSE, 2),
    ($$@MockitoBean requires manual bean registration in a separate configuration class$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-testing'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-testing')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens when this test runs?$$
      AND code_snippet = $$mockMvc.perform(get("/api/topics"))
    .andExpect(status().isOk())
    .andExpect(jsonPath("$.title").value("Records"));
// The actual response body is: [{"title": "Records"}, {"title": "Generics"}]$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What happens when this test runs?$$,
           $$mockMvc.perform(get("/api/topics"))
    .andExpect(status().isOk())
    .andExpect(jsonPath("$.title").value("Records"));
// The actual response body is: [{"title": "Records"}, {"title": "Generics"}]$$, $$java$$,
           $$It fails, because the response is a JSON array -- the correct expression would be $[0].title, not $.title.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-testing'
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
    ($$It throws a NullPointerException before the assertion runs$$, FALSE, 0),
    ($$It passes only if the array has exactly one element$$, FALSE, 1),
    ($$It passes, since "Records" is indeed present in the response$$, FALSE, 2),
    ($$It fails, because the response is a JSON array -- the correct expression would be $[0].title, not $.title$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-testing'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-testing')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A test sends mockMvc.perform(post("/users").content(requestJson)) -- without calling .contentType(...). Which of the following are consequences? (Select all that apply)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A test sends mockMvc.perform(post("/users").content(requestJson)) -- without calling .contentType(...). Which of the following are consequences? (Select all that apply)$$,
           NULL, NULL,
           $$Without contentType(...), Spring may not know which HttpMessageConverter to use, and the request can be rejected with 415 Unsupported Media Type.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-testing'
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
    ($$Spring may not be able to determine which HttpMessageConverter to use to parse the body$$, TRUE, 0),
    ($$The request can be rejected with 415 Unsupported Media Type$$, TRUE, 1),
    ($$The test always passes regardless, since content() alone is sufficient$$, FALSE, 2),
    ($$contentType(...) is only needed for GET requests, never for POST$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-testing'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-testing')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What actually happens when this test runs?$$
      AND code_snippet = $$mockMvc = MockMvcBuilders.standaloneSetup(new ProductController()).build();
// No .setControllerAdvice(...) call

// Test sends an invalid @Valid @RequestBody that fails validation
mockMvc.perform(post("/products").content(invalidJson).contentType(APPLICATION_JSON))
    .andExpect(status().isBadRequest());$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$What actually happens when this test runs?$$,
           $$mockMvc = MockMvcBuilders.standaloneSetup(new ProductController()).build();
// No .setControllerAdvice(...) call

// Test sends an invalid @Valid @RequestBody that fails validation
mockMvc.perform(post("/products").content(invalidJson).contentType(APPLICATION_JSON))
    .andExpect(status().isBadRequest());$$, $$java$$,
           $$The validator IS set up by default and does throw MethodArgumentNotValidException, but since no advice converts it, the test hits an unexpected 500 instead of the expected 400.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-testing'
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
    ($$The validator IS set up by default and does throw MethodArgumentNotValidException, but since no advice converts it, the test hits an unexpected 500 instead of the expected 400$$, TRUE, 0),
    ($$It throws a compile-time error, since standaloneSetup requires an advice to be passed$$, FALSE, 1),
    ($$It passes, since standaloneSetup automatically adds a ProblemDetail-producing advice$$, FALSE, 2),
    ($$@Valid is silently skipped entirely since no advice was registered, so the test always fails with 200 OK$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-testing'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-testing')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is MockMultipartFile, and when is it used?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What is MockMultipartFile, and when is it used?$$,
           NULL, NULL,
           $$A real spring-test (test-scope) class used to build a fake file for testing multipart/form-data endpoints, paired with the multipart(...) request builder.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-testing'
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
    ($$A production-scope class used to simulate slow network uploads$$, FALSE, 0),
    ($$A real spring-test (test-scope) class used to build a fake file for testing multipart/form-data endpoints, paired with the multipart(...) request builder$$, TRUE, 1),
    ($$A deprecated class replaced by @MockitoBean$$, FALSE, 2),
    ($$A class that can only be used together with @SpringBootTest, never with standaloneSetup(...)$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-testing'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
