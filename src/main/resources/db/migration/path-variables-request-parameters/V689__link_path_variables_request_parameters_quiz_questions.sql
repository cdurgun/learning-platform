-- Promotion-style migration linking EN path-variables-request-parameters quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'path-variables-request-parameters')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$In @GetMapping("/products/{id}") with getProduct(@PathVariable Long id), how does id get its value?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$In @GetMapping("/products/{id}") with getProduct(@PathVariable Long id), how does id get its value?$$,
           NULL, NULL,
           $$It is bound by name-matching against the {id} placeholder.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'path-variables-request-parameters'
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
    ($$It is bound by position, always the first path segment$$, FALSE, 0),
    ($$It is bound by name-matching against the {id} placeholder$$, TRUE, 1),
    ($$It must always be explicitly written as @PathVariable("id")$$, FALSE, 2),
    ($$It defaults to null unless a query parameter named id is also sent$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'path-variables-request-parameters'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'path-variables-request-parameters')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A GET /articles/spring-mvc request is sent. What does the method return?$$
      AND code_snippet = $$@GetMapping("/articles/{articleSlug}")
public String getArticle(@PathVariable("articleSlug") String slug) {
    return "Article: " + slug;
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A GET /articles/spring-mvc request is sent. What does the method return?$$,
           $$@GetMapping("/articles/{articleSlug}")
public String getArticle(@PathVariable("articleSlug") String slug) {
    return "Article: " + slug;
}$$, $$java$$,
           $$@PathVariable("articleSlug") explicitly binds slug to the {articleSlug} placeholder, so slug receives "spring-mvc".$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'path-variables-request-parameters'
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
    ($$A 400 Bad Request, since slug doesn't match articleSlug$$, FALSE, 0),
    ($$A NullPointerException, since the parameter name differs from the placeholder$$, FALSE, 1),
    ($$Article: articleSlug$$, FALSE, 2),
    ($$Article: spring-mvc$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'path-variables-request-parameters'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'path-variables-request-parameters')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to the distinction taught in this lesson, which of the following should be a path variable rather than a query parameter?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$According to the distinction taught in this lesson, which of the following should be a path variable rather than a query parameter?$$,
           NULL, NULL,
           $$An id identifying which specific article to retrieve is required -- the request is meaningless without it, so it belongs in the path.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'path-variables-request-parameters'
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
    ($$A category filter narrowing a product listing$$, FALSE, 0),
    ($$A page number for pagination$$, FALSE, 1),
    ($$An id identifying which specific article to retrieve -- the request is meaningless without it$$, TRUE, 2),
    ($$A sortBy field name for ordering results$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'path-variables-request-parameters'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'path-variables-request-parameters')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$By default, is @RequestParam required or optional if the client doesn't send it?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$By default, is @RequestParam required or optional if the client doesn't send it?$$,
           NULL, NULL,
           $$@RequestParam is required by default -- the client gets a 400 Bad Request if it's missing.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'path-variables-request-parameters'
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
    ($$It depends on the HTTP method used$$, FALSE, 0),
    ($$It is always optional unless required = true is explicitly written$$, FALSE, 1),
    ($$Required by default -- the client gets a 400 Bad Request if it's missing$$, TRUE, 2),
    ($$Optional by default, just like @PathVariable$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'path-variables-request-parameters'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'path-variables-request-parameters')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A method has the parameter @RequestParam(required = false) List<String> tag. Which of the following requests correctly populates tag with ["java", "spring"]?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A method has the parameter @RequestParam(required = false) List<String> tag. Which of the following requests correctly populates tag with ["java", "spring"]?$$,
           NULL, NULL,
           $$Spring's List binding expects the same key to be repeated (?tag=java&tag=spring), not a single comma-separated value, and not omitted entirely.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'path-variables-request-parameters'
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
    ($$?tag=java&tag=spring$$, TRUE, 0),
    ($$?tag=java,spring$$, FALSE, 1),
    ($$Sending no tag parameter at all -- tag becomes ["java", "spring"] automatically$$, FALSE, 2),
    ($$A malformed request that Spring rejects with 400 Bad Request$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'path-variables-request-parameters'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'path-variables-request-parameters')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is the main trade-off of binding @RequestParam to a Map<String, String> instead of declaring each parameter individually?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What is the main trade-off of binding @RequestParam to a Map<String, String> instead of declaring each parameter individually?$$,
           NULL, NULL,
           $$It captures every parameter regardless of name, but loses compile-time type safety -- everything arrives as String.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'path-variables-request-parameters'
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
    ($$It captures every parameter regardless of name, but loses compile-time type safety -- everything arrives as String$$, TRUE, 0),
    ($$It automatically converts every value to its correct Java type$$, FALSE, 1),
    ($$It only works with POST requests$$, FALSE, 2),
    ($$It requires a custom ConversionService to be registered$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'path-variables-request-parameters'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: CODE_OUTPUT)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'path-variables-request-parameters')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A client sends GET /products/abc. What happens?$$
      AND code_snippet = $$@GetMapping("/products/{id}")
public String getProduct(@PathVariable Long id) {
    return "Product: " + id;
}$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$A client sends GET /products/abc. What happens?$$,
           $$@GetMapping("/products/{id}")
public String getProduct(@PathVariable Long id) {
    return "Product: " + id;
}$$, $$java$$,
           $$Type conversion fails at the DispatcherServlet layer, before the controller method is ever called, resulting in 400 Bad Request.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'path-variables-request-parameters'
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
    ($$id is set to null and the method runs normally$$, FALSE, 0),
    ($$The method runs and throws a NumberFormatException inside the method body$$, FALSE, 1),
    ($$The request never reaches getProduct at all -- type conversion fails at the DispatcherServlet layer, resulting in 400 Bad Request$$, TRUE, 2),
    ($$id is set to 0 as a default fallback value$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'path-variables-request-parameters'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
