-- Promotion-style migration linking EN rest-api-design quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: MULTIPLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'rest-api-design')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What are the risks of returning a JPA entity directly from a @RestController? (Select all that apply)$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What are the risks of returning a JPA entity directly from a @RestController? (Select all that apply)$$,
           NULL, NULL,
           $$An entity can expose fields no client should see (like a password hash), and a lazily-loaded field can throw LazyInitializationException during serialization.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'rest-api-design'
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
    ($$It can expose internal fields no client should see, like a password hash$$, TRUE, 0),
    ($$A lazily-loaded field can throw a LazyInitializationException if touched during serialization$$, TRUE, 1),
    ($$It is always significantly slower than using a DTO$$, FALSE, 2),
    ($$Jackson is fundamentally unable to serialize any JPA entity$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'rest-api-design'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'rest-api-design')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$When a @RestController method's parameter is typed Pageable, how does Spring populate it?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$When a @RestController method's parameter is typed Pageable, how does Spring populate it?$$,
           NULL, NULL,
           $$It is automatically resolved from ?page=/?size=/?sort= query parameters, no manual parsing needed.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'rest-api-design'
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
    ($$It always defaults to page 0, size 20, with no way to override it$$, FALSE, 0),
    ($$It requires a custom HandlerMethodArgumentResolver to be written by the developer$$, FALSE, 1),
    ($$It must be manually built inside the method body$$, FALSE, 2),
    ($$It is automatically resolved from ?page=/?size=/?sort= query parameters$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'rest-api-design'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'rest-api-design')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which client-sent query string is the equivalent request-side representation of this Sort object?$$
      AND code_snippet = $$Sort sort = Sort.by(Sort.Direction.ASC, "difficulty")
                 .and(Sort.by(Sort.Direction.DESC, "title"));$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which client-sent query string is the equivalent request-side representation of this Sort object?$$,
           $$Sort sort = Sort.by(Sort.Direction.ASC, "difficulty")
                 .and(Sort.by(Sort.Direction.DESC, "title"));$$, $$java$$,
           $$?sort=difficulty,asc&sort=title,desc is the server-side equivalent request that Spring resolves into exactly this kind of Sort object.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'rest-api-design'
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
    ($$?sort=difficulty&sort=title$$, FALSE, 0),
    ($$?sort=difficulty,asc&sort=title,desc$$, TRUE, 1),
    ($$?sortAsc=difficulty&sortDesc=title$$, FALSE, 2),
    ($$?orderBy=difficulty+title$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'rest-api-design'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'rest-api-design')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A request GET /topics is sent without a category parameter. What happens?$$
      AND code_snippet = $$@GetMapping("/topics")
public List<Topic> list(@RequestParam(required = false) String category) {
    return allTopics.stream()
        .filter(t -> category.equals(t.getCategory()))
        .toList();
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$A request GET /topics is sent without a category parameter. What happens?$$,
           $$@GetMapping("/topics")
public List<Topic> list(@RequestParam(required = false) String category) {
    return allTopics.stream()
        .filter(t -> category.equals(t.getCategory()))
        .toList();
}$$, $$java$$,
           $$A NullPointerException is thrown, because category is null and .equals(...) is called on it directly -- every optional filter needs to explicitly express "no effect when not supplied".$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'rest-api-design'
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
    ($$A NullPointerException is thrown, because category is null and .equals(...) is called on it directly$$, TRUE, 0),
    ($$It returns 400 Bad Request, since category is technically required$$, FALSE, 1),
    ($$It returns all topics, since the filter has no effect when category is absent$$, FALSE, 2),
    ($$It returns an empty list$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'rest-api-design'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'rest-api-design')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why does Spring Data itself advise against returning Page<T> directly from a controller method?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Why does Spring Data itself advise against returning Page<T> directly from a controller method?$$,
           NULL, NULL,
           $$PageImpl's internal fields aren't a documented, stable contract, and its default JSON shape has changed across Spring Data versions.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'rest-api-design'
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
    ($$Page<T> cannot be serialized to JSON at all$$, FALSE, 0),
    ($$PageImpl's internal fields aren't a documented, stable contract, and its default JSON shape has changed across Spring Data versions$$, TRUE, 1),
    ($$It is a security risk, always exposing internal database IDs$$, FALSE, 2),
    ($$It forces the response to use XML instead of JSON$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'rest-api-design'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'rest-api-design')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are true about API versioning strategies covered in this lesson? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about API versioning strategies covered in this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$URI versioning is impossible to miss but leaks into every client URL permanently; header versioning keeps the URL fixed but makes the version invisible without documentation.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'rest-api-design'
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
    ($$Mixing both strategies in the same API is the recommended best practice$$, FALSE, 0),
    ($$There is a single, universally settled answer to which strategy is objectively best$$, FALSE, 1),
    ($$URI versioning (/api/v1/...) is impossible to miss but leaks into every client URL permanently$$, TRUE, 2),
    ($$Header versioning (Api-Version: 2) keeps the URL fixed, but makes the version invisible without documentation$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'rest-api-design'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'rest-api-design')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A client's POST /orders request times out, so it retries with the exact same Idempotency-Key header. If the server already processed the original request, what does it do on the retry?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$A client's POST /orders request times out, so it retries with the exact same Idempotency-Key header. If the server already processed the original request, what does it do on the retry?$$,
           NULL, NULL,
           $$It returns the original result again, without creating a new resource -- the second call has exactly the same effect as the first.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'rest-api-design'
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
    ($$It creates a second, duplicate order$$, FALSE, 0),
    ($$It rejects the retry with 409 Conflict$$, FALSE, 1),
    ($$It returns the original result again, without creating a new resource$$, TRUE, 2),
    ($$It ignores the Idempotency-Key header entirely on POST requests$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'rest-api-design'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
