-- Promotion-style migration linking EN error-boundaries quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'error-boundaries')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Can an error boundary be written as a function component using hooks?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Can an error boundary be written as a function component using hooks?$$,
           NULL, NULL,
           $$There's no way to write error boundaries with hooks -- they can only be written using class components.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'error-boundaries'
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
    ($$No -- error boundaries can only be written using class components$$, TRUE, 0),
    ($$Yes -- any function component automatically becomes an error boundary$$, FALSE, 1),
    ($$Yes, using useState combined with useEffect$$, FALSE, 2),
    ($$Yes, but only when combined with a custom hook$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'error-boundaries'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'error-boundaries')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is static getDerivedStateFromError() used for?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What is static getDerivedStateFromError() used for?$$,
           NULL, NULL,
           $$It is called by React when a child throws an error -- whatever it returns becomes the new state, used to show the fallback UI.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'error-boundaries'
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
    ($$It runs once when the application first starts, regardless of errors$$, FALSE, 0),
    ($$It's called when a child throws; whatever it returns becomes the new state, driving the fallback UI$$, TRUE, 1),
    ($$It sends the error automatically to an external logging service$$, FALSE, 2),
    ($$It prevents any error from ever being thrown in the first place$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'error-boundaries'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'error-boundaries')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why is componentDidCatch needed, given that getDerivedStateFromError already exists?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Why is componentDidCatch needed, given that getDerivedStateFromError already exists?$$,
           NULL, NULL,
           $$getDerivedStateFromError is ONLY for showing the fallback UI -- sending the error somewhere (logging it) requires the separate componentDidCatch(error, errorInfo) method.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'error-boundaries'
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
    ($$componentDidCatch is required to prevent the app from crashing at all$$, FALSE, 0),
    ($$componentDidCatch runs before getDerivedStateFromError, not after$$, FALSE, 1),
    ($$getDerivedStateFromError only shows the fallback UI; componentDidCatch is the separate method for logging the error$$, TRUE, 2),
    ($$componentDidCatch replaces getDerivedStateFromError entirely -- only one is ever needed$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'error-boundaries'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'error-boundaries')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$BuggyCounter throws when count reaches 3, and it's wrapped in an ErrorBoundary. What does the user see after the count reaches 3?$$
      AND code_snippet = $$function BuggyCounter({ count }) {
    if (count === 3) {
        throw new Error("Counter crashed!");
    }
    return <p>{count}</p>;
}

<ErrorBoundary>
    <BuggyCounter count={3} />
</ErrorBoundary>$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$BuggyCounter throws when count reaches 3, and it's wrapped in an ErrorBoundary. What does the user see after the count reaches 3?$$,
           $$function BuggyCounter({ count }) {
    if (count === 3) {
        throw new Error("Counter crashed!");
    }
    return <p>{count}</p>;
}

<ErrorBoundary>
    <BuggyCounter count={3} />
</ErrorBoundary>$$, $$jsx$$,
           $$ErrorBoundary catches the thrown error and replaces the normal render with a fallback UI -- BuggyCounter itself doesn't need to handle the error, that's the error boundary's job.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'error-boundaries'
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
    ($$A blank white screen, since React unmounts the entire application$$, FALSE, 0),
    ($$ErrorBoundary's fallback UI, since it caught the error thrown during rendering$$, TRUE, 1),
    ($$The browser's default JavaScript error console dialog$$, FALSE, 2),
    ($$The number 3 is displayed normally, as if nothing happened$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'error-boundaries'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'error-boundaries')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why does this lesson recommend using multiple, small error boundaries instead of one big one?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Why does this lesson recommend using multiple, small error boundaries instead of one big one?$$,
           NULL, NULL,
           $$If one section crashes inside its own boundary, the other sections (wrapped in separate boundaries) are NOT affected; with a single large boundary, any error could turn the ENTIRE page into a fallback message.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'error-boundaries'
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
    ($$So a crash in one section doesn't turn the entire page into a fallback message$$, TRUE, 0),
    ($$Because a single error boundary can only catch exactly one error total, ever$$, FALSE, 1),
    ($$Because React requires at least two error boundaries per application$$, FALSE, 2),
    ($$Small boundaries make the application's JavaScript bundle smaller$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'error-boundaries'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'error-boundaries')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are true about what error boundaries do NOT catch, according to this lesson? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about what error boundaries do NOT catch, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$Error boundaries only catch errors thrown during RENDERING -- they do NOT catch errors in event handlers, asynchronous code, server-side rendering, or errors thrown in the boundary itself.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'error-boundaries'
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
    ($$Every kind of error in the entire application, with no exceptions at all$$, FALSE, 0),
    ($$Errors thrown inside an event handler, like onClick$$, TRUE, 1),
    ($$Errors thrown in asynchronous code, like setTimeout or fetch callbacks$$, TRUE, 2),
    ($$Errors thrown during rendering by a component the boundary wraps$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'error-boundaries'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: CODE_OUTPUT)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'error-boundaries')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$An error is thrown inside this onClick handler, and the button is wrapped in an ErrorBoundary. Does the ErrorBoundary catch it?$$
      AND code_snippet = $$function handleClick() {
    throw new Error("Click failed!");
}

<ErrorBoundary>
    <button onClick={handleClick}>Click me</button>
</ErrorBoundary>$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$An error is thrown inside this onClick handler, and the button is wrapped in an ErrorBoundary. Does the ErrorBoundary catch it?$$,
           $$function handleClick() {
    throw new Error("Click failed!");
}

<ErrorBoundary>
    <button onClick={handleClick}>Click me</button>
</ErrorBoundary>$$, $$jsx$$,
           $$Error boundaries do NOT catch errors in event handlers -- only errors thrown during rendering. Regular try/catch is needed for errors inside handleClick.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'error-boundaries'
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
    ($$Only if getDerivedStateFromError is combined with componentDidCatch$$, FALSE, 0),
    ($$It depends on whether the button also has an onError prop defined$$, FALSE, 1),
    ($$Yes -- ErrorBoundary catches any error thrown by a component it wraps, including event handlers$$, FALSE, 2),
    ($$No -- error boundaries only catch errors thrown during rendering, not inside event handlers$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'error-boundaries'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
