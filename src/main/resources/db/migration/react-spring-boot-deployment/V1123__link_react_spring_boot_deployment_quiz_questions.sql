-- Links the EN react-spring-boot-deployment questions to the topic's fixed quiz. Same NOT EXISTS /
-- ON CONFLICT DO NOTHING pattern as every prior quiz-link migration: each question is
-- found by its text (or created if missing) and linked at its position, so the file is
-- safe on a fresh database and on one where the promotion migration already ran.

-- Question 1/5 (pair 1 EN, quiz position 1, SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-spring-boot-deployment')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why is the Spring Boot backend deployed to a different platform than the React app on Vercel?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Why is the Spring Boot backend deployed to a different platform than the React app on Vercel?$$,
           NULL, NULL,
           $$Vercel is built for static sites and short-lived serverless functions. Spring Boot needs a continuously running Java server process with embedded Tomcat, which Vercel cannot host. The usual pattern is therefore React on Vercel and the backend on a platform made for long-running servers.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'react-spring-boot-deployment'
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
        ($$Vercel cannot host the continuously running Java process Spring Boot needs$$, TRUE, 0),
        ($$Vercel does not let a frontend send requests to any backend$$, FALSE, 1),
        ($$A Spring Boot application cannot return JSON to a React app$$, FALSE, 2),
        ($$A frontend and its backend are never allowed to share a platform$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-spring-boot-deployment'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/5 (pair 2 EN, quiz position 2, SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-spring-boot-deployment')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$The backend address is read from `VITE_API_BASE_URL`. What differs between local development and production?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$The backend address is read from `VITE_API_BASE_URL`. What differs between local development and production?$$,
           NULL, NULL,
           $$Only the value of the variable differs: locally it points at Spring Boot on `localhost:8080`, and in production at the real address the hosting platform gives you. The code that reads the variable and calls the backend never changes.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'react-spring-boot-deployment'
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
        ($$The `fetch` calls are rewritten for production$$, FALSE, 0),
        ($$Only the variable's value; the code stays the same$$, TRUE, 1),
        ($$A different component is rendered in production$$, FALSE, 2),
        ($$The variable gets a different name on Vercel$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-spring-boot-deployment'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/5 (pair 3 EN, quiz position 3, SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-spring-boot-deployment')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A component that talked to `json-server` during development now talks to a deployed Spring Boot app. What has to change in its `useEffect` + `fetch` logic?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A component that talked to `json-server` during development now talks to a deployed Spring Boot app. What has to change in its `useEffect` + `fetch` logic?$$,
           NULL, NULL,
           $$Nothing has to change. All `fetch` sees is a URL and a JSON response, so the component behaves the same whatever sits at the other end. The loading and error handling stays exactly as it was.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'react-spring-boot-deployment'
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
        ($$The loading and error states must be removed$$, FALSE, 0),
        ($$`fetch` must be replaced by a Spring-specific client$$, FALSE, 1),
        ($$Nothing; `fetch` only sees a URL and a JSON response$$, TRUE, 2),
        ($$The response must be converted from XML to JSON$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-spring-boot-deployment'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/5 (pair 4 EN, quiz position 4, SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-spring-boot-deployment')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$`CORS_ALLOWED_ORIGIN` is set to `https://my-app.vercel.app/`, with a trailing slash. What happens to requests from the deployed frontend?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$`CORS_ALLOWED_ORIGIN` is set to `https://my-app.vercel.app/`, with a trailing slash. What happens to requests from the deployed frontend?$$,
           NULL, NULL,
           $$The origin has to match exactly, including `https://` and with no trailing `/`. With the extra slash it does not match, and the browser blocks the request with a CORS error. Nothing about this depends on the HTTP method.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'react-spring-boot-deployment'
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
        ($$They succeed, since a trailing slash is ignored when origins are compared$$, FALSE, 0),
        ($$They succeed for `GET` requests and fail for all other methods$$, FALSE, 1),
        ($$The backend answers with a 404 before CORS is ever checked$$, FALSE, 2),
        ($$The browser blocks them with a CORS error, since the origin must match exactly$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-spring-boot-deployment'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/5 (pair 5 EN, quiz position 5, SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'react-spring-boot-deployment')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$React needs the backend's address, and the backend needs React's address. In which order are they deployed and configured?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$React needs the backend's address, and the backend needs React's address. In which order are they deployed and configured?$$,
           NULL, NULL,
           $$The backend goes first because it produces the URL that React needs in `VITE_API_BASE_URL`. Deploying React then produces the second URL, which goes into `CORS_ALLOWED_ORIGIN` back on the backend. Setting the CORS variable any earlier is impossible, because the frontend's address does not exist yet.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'react-spring-boot-deployment'
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
        ($$Backend first, then React with the backend URL, then the CORS variable$$, TRUE, 0),
        ($$React first, then the CORS variable, then the backend$$, FALSE, 1),
        ($$The CORS variable first, then both applications together$$, FALSE, 2),
        ($$Backend first, then the CORS variable, then React$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'react-spring-boot-deployment'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
