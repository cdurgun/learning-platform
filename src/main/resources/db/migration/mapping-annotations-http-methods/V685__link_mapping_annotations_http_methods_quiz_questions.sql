-- Promotion-style migration linking EN mapping-annotations-http-methods quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'mapping-annotations-http-methods')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens if @RequestMapping("/items") is written without specifying a method attribute?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What happens if @RequestMapping("/items") is written without specifying a method attribute?$$,
           NULL, NULL,
           $$Without a method attribute, @RequestMapping responds to every HTTP method (GET, POST, DELETE, etc.).$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'mapping-annotations-http-methods'
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
    ($$It responds to no HTTP method at all$$, FALSE, 0),
    ($$It responds only to GET, as a safety default$$, FALSE, 1),
    ($$It responds to every HTTP method (GET, POST, DELETE, etc.)$$, TRUE, 2),
    ($$It causes a startup error$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'mapping-annotations-http-methods'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'mapping-annotations-http-methods')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is @GetMapping("/users") in relation to @RequestMapping?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What is @GetMapping("/users") in relation to @RequestMapping?$$,
           NULL, NULL,
           $$@GetMapping is a meta-annotation equivalent to @RequestMapping(path="/users", method=RequestMethod.GET).$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'mapping-annotations-http-methods'
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
    ($$A deprecated annotation kept only for backward compatibility$$, FALSE, 0),
    ($$An annotation that can only be used at the class level$$, FALSE, 1),
    ($$A completely independent annotation with its own separate mechanism$$, FALSE, 2),
    ($$A meta-annotation that is equivalent to @RequestMapping(path="/users", method=RequestMethod.GET)$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'mapping-annotations-http-methods'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'mapping-annotations-http-methods')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A GET /users/search?q=alice request is sent. Even though search is declared after {id}, which method handles it?$$
      AND code_snippet = $$@RestController
@RequestMapping("/users")
public class UserController {
    @GetMapping("/{id}")
    public String getOne(@PathVariable Long id) { return "one:" + id; }

    @GetMapping("/search")
    public String search(@RequestParam String q) { return "search:" + q; }
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A GET /users/search?q=alice request is sent. Even though search is declared after {id}, which method handles it?$$,
           $$@RestController
@RequestMapping("/users")
public class UserController {
    @GetMapping("/{id}")
    public String getOne(@PathVariable Long id) { return "one:" + id; }

    @GetMapping("/search")
    public String search(@RequestParam String q) { return "search:" + q; }
}$$, $$java$$,
           $$Spring always treats a literal path segment as more specific than a variable segment, regardless of declaration order -- so /search matches search(), not getOne().$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'mapping-annotations-http-methods'
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
    ($$getOne, because it was declared first$$, FALSE, 0),
    ($$Neither -- this causes an ambiguous mapping error at startup$$, FALSE, 1),
    ($$search, because Spring always treats a literal path segment as more specific than a variable segment, regardless of declaration order$$, TRUE, 2),
    ($$It is nondeterministic -- either method could be called$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'mapping-annotations-http-methods'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'mapping-annotations-http-methods')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Two methods both map POST /orders, one with consumes = "application/json" and the other with consumes = "application/xml". How does Spring decide which one handles an incoming request?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Two methods both map POST /orders, one with consumes = "application/json" and the other with consumes = "application/xml". How does Spring decide which one handles an incoming request?$$,
           NULL, NULL,
           $$Spring inspects the request's Content-Type header and routes to the matching consumes value.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'mapping-annotations-http-methods'
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
    ($$It inspects the request's Content-Type header and routes to the matching consumes value$$, TRUE, 0),
    ($$It throws an exception because the same path is mapped twice$$, FALSE, 1),
    ($$It always picks the first one declared$$, FALSE, 2),
    ($$It merges both into a single handler$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'mapping-annotations-http-methods'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'mapping-annotations-http-methods')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are true regarding HTTP method safety and idempotency? (Select all that apply)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are true regarding HTTP method safety and idempotency? (Select all that apply)$$,
           NULL, NULL,
           $$GET must be safe and idempotent; POST is neither; DELETE is idempotent even though not safe. PUT is idempotent but not safe (it changes state), so the PUT-is-safe option is wrong.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'mapping-annotations-http-methods'
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
    ($$GET must be both safe (no state change) and idempotent$$, TRUE, 0),
    ($$POST is neither safe nor idempotent -- each call typically creates a new resource$$, TRUE, 1),
    ($$PUT is safe, because it only updates existing data$$, FALSE, 2),
    ($$DELETE is idempotent, even though it is not safe$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'mapping-annotations-http-methods'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'mapping-annotations-http-methods')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$The current profile is {"name": "Alice", "city": "Berlin"}. A client sends PUT /profiles/1 with body {"city": "Paris"}. What is the resulting state of profile?$$
      AND code_snippet = $$@PatchMapping("/profiles/{id}")
public void update(@PathVariable Long id, @RequestBody Map<String, Object> fields) {
    profile.putAll(fields); // only overwrites keys present in fields
}

@PutMapping("/profiles/{id}")
public void replace(@PathVariable Long id, @RequestBody Map<String, Object> fields) {
    profile.clear();
    profile.putAll(fields);
}$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$The current profile is {"name": "Alice", "city": "Berlin"}. A client sends PUT /profiles/1 with body {"city": "Paris"}. What is the resulting state of profile?$$,
           $$@PatchMapping("/profiles/{id}")
public void update(@PathVariable Long id, @RequestBody Map<String, Object> fields) {
    profile.putAll(fields); // only overwrites keys present in fields
}

@PutMapping("/profiles/{id}")
public void replace(@PathVariable Long id, @RequestBody Map<String, Object> fields) {
    profile.clear();
    profile.putAll(fields);
}$$, $$java$$,
           $$PUT replaces the entire resource -- replace() clears the profile first, so name is lost, leaving only {"city": "Paris"}.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'mapping-annotations-http-methods'
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
    ($${"name": "Alice", "city": "Berlin"} -- unchanged$$, FALSE, 0),
    ($$A 409 Conflict is returned since name is missing$$, FALSE, 1),
    ($${"name": "Alice", "city": "Paris"}$$, FALSE, 2),
    ($${"city": "Paris"} -- name is lost because PUT replaces the entire resource$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'mapping-annotations-http-methods'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'mapping-annotations-http-methods')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A path /books/{id} has mappings for GET and PUT only. A client sends DELETE /books/5. What does Spring return, and why?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$A path /books/{id} has mappings for GET and PUT only. A client sends DELETE /books/5. What does Spring return, and why?$$,
           NULL, NULL,
           $$405 Method Not Allowed -- the path exists but has no mapping for DELETE. 404 would be wrong since the path itself is found.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'mapping-annotations-http-methods'
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
    ($$404 Not Found, because the path segment doesn't exist$$, FALSE, 0),
    ($$405 Method Not Allowed, because the path exists but has no mapping for DELETE$$, TRUE, 1),
    ($$200 OK, since DELETE silently falls back to GET$$, FALSE, 2),
    ($$500 Internal Server Error, because no handler was matched$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'mapping-annotations-http-methods'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
