-- Promotion-style migration linking EN resilience4j quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 6 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.

-- Question 1/6 (EN pair 1, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$resilience4j$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$What real gap in order-service's existing error handling does this lesson's Resilience4j introduction address?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What real gap in order-service's existing error handling does this lesson's Resilience4j introduction address?$$,
           NULL, NULL,
           $$The lesson explains even with 404-vs-unreachable handling in place, order-service still hammered a struggling inventory-service with every request instead of backing off.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$resilience4j$$
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
    ($$order-service had no way to serialize JSON responses before this lesson$$, FALSE, 0),
    ($$Even with 404-vs-unreachable handling in place, order-service still hammered a struggling inventory-service with every request instead of backing off$$, TRUE, 1),
    ($$order-service couldn't connect to any database before this lesson$$, FALSE, 2),
    ($$RestClient didn't exist as an API before Resilience4j was introduced$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$resilience4j$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (EN pair 2, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$resilience4j$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Per "Circuit Breaker: States and Configuration," what happens once the circuit breaker trips to the OPEN state?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Per "Circuit Breaker: States and Configuration," what happens once the circuit breaker trips to the OPEN state?$$,
           NULL, NULL,
           $$The lesson explains every call fails immediately, without even attempting the real call, for a configured wait duration once the circuit is OPEN.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$resilience4j$$
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
    ($$The real call is still attempted, but with a longer timeout$$, FALSE, 0),
    ($$Every call fails immediately, without even attempting the real call, for a configured wait duration$$, TRUE, 1),
    ($$The application immediately shuts down$$, FALSE, 2),
    ($$All future calls are automatically retried three times before failing$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$resilience4j$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (EN pair 3, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$resilience4j$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Per the warning under "Wrapping StockClient with a Circuit Breaker," what happens if a method on the same class calls this.checkStock(...) directly instead of going through the injected bean?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Per the warning under "Wrapping StockClient with a Circuit Breaker," what happens if a method on the same class calls this.checkStock(...) directly instead of going through the injected bean?$$,
           NULL, NULL,
           $$The lesson explains this bypasses Spring's proxy entirely, exactly like @Transactional, so neither @CircuitBreaker nor @Retry ever runs.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$resilience4j$$
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
    ($$Nothing changes -- annotations apply regardless of how a method is invoked$$, FALSE, 0),
    ($$The call bypasses Spring's proxy entirely, so neither @CircuitBreaker nor @Retry ever runs$$, TRUE, 1),
    ($$The application fails to start, throwing a BeanCreationException$$, FALSE, 2),
    ($$The circuit breaker immediately trips to OPEN as a safety measure$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$resilience4j$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (EN pair 4, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$resilience4j$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Per "Retry: Trying Again Before Giving Up," in what order do @Retry and @CircuitBreaker actually interact on the same annotated method?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Per "Retry: Trying Again Before Giving Up," in what order do @Retry and @CircuitBreaker actually interact on the same annotated method?$$,
           NULL, NULL,
           $$The lesson explains @Retry retries a failed call the configured number of times before the circuit breaker ever records that failure.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$resilience4j$$
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
    ($$The circuit breaker always runs first, and retry only applies to genuinely open circuits$$, FALSE, 0),
    ($$@Retry retries a failed call the configured number of times before the circuit breaker ever records that failure$$, TRUE, 1),
    ($$They cannot be combined on the same method at all$$, FALSE, 2),
    ($$@Retry and @CircuitBreaker run in two completely separate threads simultaneously$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$resilience4j$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (EN pair 5, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$resilience4j$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Given this Resilience4j configuration, if 6 of the last 10 calls to inventoryService have failed, what state does the circuit breaker move to?$$
      AND code_snippet = $$resilience4j:
  circuitbreaker:
    instances:
      inventoryService:
        sliding-window-type: COUNT_BASED
        sliding-window-size: 10
        failure-rate-threshold: 50
        wait-duration-in-open-state: 10s$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given this Resilience4j configuration, if 6 of the last 10 calls to inventoryService have failed, what state does the circuit breaker move to?$$,
           $$resilience4j:
  circuitbreaker:
    instances:
      inventoryService:
        sliding-window-type: COUNT_BASED
        sliding-window-size: 10
        failure-rate-threshold: 50
        wait-duration-in-open-state: 10s$$, $$yaml$$,
           $$The lesson explains a failure rate crossing the configured threshold trips the circuit to OPEN -- 60% exceeds the 50% failure-rate-threshold here.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$resilience4j$$
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
    ($$It stays CLOSED, since 6 failures is below the sliding window size of 10$$, FALSE, 0),
    ($$It trips to OPEN, since 60% exceeds the configured 50% failure-rate-threshold$$, TRUE, 1),
    ($$It moves directly to HALF_OPEN, skipping OPEN entirely$$, FALSE, 2),
    ($$It stays CLOSED forever, since wait-duration-in-open-state prevents any state change$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$resilience4j$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (EN pair 6, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$resilience4j$$)
      AND language = $$en$$
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about Resilience4j's guards, per this lesson, are correct? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about Resilience4j's guards, per this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$The lesson explains rate limiters/bulkheads guard against overload even when healthy, and a fallback method's signature must match plus a trailing Throwable; bulkhead-as-substitute and retry-vs-circuit-breaker-as-competing are explicitly called out as misconceptions.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$resilience4j$$
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
    ($$A rate limiter and a bulkhead guard against overload, even when the target service is completely healthy$$, TRUE, 0),
    ($$A bulkhead is a substitute for a circuit breaker when a service is genuinely down$$, FALSE, 1),
    ($$A fallback method's signature must match the original method's parameters plus a trailing Throwable$$, TRUE, 2),
    ($$@Retry and @CircuitBreaker are competing choices that can never be applied together$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$resilience4j$$
  AND quiz.language = $$en$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
