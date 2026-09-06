-- Promotion-style migration linking EN security quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 6 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.

-- Question 1/6 (EN pair 1, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$security$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Per "Authentication vs. Authorization: Two Different Questions," what is the key difference between the two?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Per "Authentication vs. Authorization: Two Different Questions," what is the key difference between the two?$$,
           NULL, NULL,
           $$The lesson explains authentication asks who is this, while authorization asks whether this identity is allowed to do this specific thing -- a separate decision that happens after.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$security$$
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
    ($$They're two names for the exact same check, used interchangeably$$, FALSE, 0),
    ($$Authentication asks "who is this?", while authorization asks "is this identity allowed to do this specific thing?" -- a separate decision that happens after$$, TRUE, 1),
    ($$Authorization always happens before authentication in every system$$, FALSE, 2),
    ($$Authentication only applies to POST requests, authorization only to GET requests$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$security$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (EN pair 2, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$security$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Per "JWT: A Self-Contained, Verifiable Identity," what lets api-gateway and order-service both verify the same token independently, without calling back to a central store?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Per "JWT: A Self-Contained, Verifiable Identity," what lets api-gateway and order-service both verify the same token independently, without calling back to a central store?$$,
           NULL, NULL,
           $$The lesson explains a JWT's cryptographic signature can be verified by anyone holding the issuer's public key.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$security$$
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
    ($$Both services share the exact same in-memory session cache$$, FALSE, 0),
    ($$A JWT's cryptographic signature can be verified by anyone holding the issuer's public key$$, TRUE, 1),
    ($$order-service always trusts whatever api-gateway already checked, without re-verifying$$, FALSE, 2),
    ($$JWTs are stored in a shared database both services query on every request$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$security$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (EN pair 3, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$security$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Per "Why the Gateway Alone Isn't Enough: Zero Trust Between Services," why does order-service verify the JWT itself, instead of trusting that api-gateway already checked it?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Per "Why the Gateway Alone Isn't Enough: Zero Trust Between Services," why does order-service verify the JWT itself, instead of trusting that api-gateway already checked it?$$,
           NULL, NULL,
           $$The lesson explains any path that bypasses api-gateway -- a misconfigured route, a direct internal call -- would otherwise have no protection at all.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$security$$
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
    ($$Because api-gateway technically cannot verify JWTs at all$$, FALSE, 0),
    ($$Because any path that bypasses api-gateway (a misconfigured route, a direct internal call) would otherwise have no protection at all$$, TRUE, 1),
    ($$Because verifying a JWT twice is required by the JWT specification itself$$, FALSE, 2),
    ($$Because order-service and api-gateway use incompatible JWT formats$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$security$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (EN pair 4, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$security$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Given OrderServiceSecurityConfig below, a request arrives at POST /orders carrying a valid, correctly-signed JWT -- but that JWT's identity has no customer role. What HTTP status is returned?$$
      AND code_snippet = $$.authorizeHttpRequests(requests -> requests
        .requestMatchers("/actuator/health").permitAll()
        .requestMatchers(HttpMethod.POST, "/orders").hasRole("customer")
        .anyRequest().authenticated())$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Given OrderServiceSecurityConfig below, a request arrives at POST /orders carrying a valid, correctly-signed JWT -- but that JWT's identity has no customer role. What HTTP status is returned?$$,
           $$.authorizeHttpRequests(requests -> requests
        .requestMatchers("/actuator/health").permitAll()
        .requestMatchers(HttpMethod.POST, "/orders").hasRole("customer")
        .anyRequest().authenticated())$$, $$java$$,
           $$The real OrderServiceSecurityConfig.java requires hasRole("customer") for POST /orders specifically -- an authenticated but unauthorized identity gets 403 Forbidden, not 401.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$security$$
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
    ($$200 OK, since a valid JWT is enough regardless of role$$, FALSE, 0),
    ($$401 Unauthorized, since the token itself is considered invalid$$, FALSE, 1),
    ($$403 Forbidden, since authentication succeeded but this identity isn't authorized for this specific action$$, TRUE, 2),
    ($$404 Not Found, since /orders is hidden from unauthorized identities$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$security$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (EN pair 5, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$security$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Per "Propagating Identity: The Correlation Id's Security Counterpart," what happens if RestClientBearerTokenInterceptor is missing when order-service calls inventory-service?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Per "Propagating Identity: The Correlation Id's Security Counterpart," what happens if RestClientBearerTokenInterceptor is missing when order-service calls inventory-service?$$,
           NULL, NULL,
           $$The lesson explains inventory-service would receive a completely unauthenticated request, even though the original external request was properly authenticated.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$security$$
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
    ($$The call fails immediately with a compilation error$$, FALSE, 0),
    ($$inventory-service receives a completely unauthenticated request, even though the original external request was properly authenticated$$, TRUE, 1),
    ($$order-service's own JWT is automatically regenerated for the outgoing call$$, FALSE, 2),
    ($$inventory-service falls back to trusting order-service unconditionally$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$security$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (EN pair 6, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$security$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about this lesson's security design are correct? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about this lesson's security design are correct? (Select all that apply)$$,
           NULL, NULL,
           $$The lesson's real examples show api-gateway using @EnableWebFluxSecurity (reactive) and order-service using @EnableWebSecurity (servlet), and health check endpoints are deliberately kept public.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$security$$
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
    ($$api-gateway uses the reactive security config style (@EnableWebFluxSecurity), while order-service uses the servlet-based style (@EnableWebSecurity)$$, TRUE, 0),
    ($$A 401 Unauthorized and a 403 Forbidden mean exactly the same thing and can be used interchangeably$$, FALSE, 1),
    ($$Health check endpoints (/actuator/health) are deliberately kept public, since load balancers need to reach them without a token$$, TRUE, 2),
    ($$Once api-gateway verifies a JWT, no other service in this course ever needs to verify it again$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$security$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
