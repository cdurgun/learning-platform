-- Promotion-style migration linking EN lazy-loading-code-splitting quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lazy-loading-code-splitting')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does lazy(() => import("./CourseDetails.jsx")) do to CourseDetails's code?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does lazy(() => import("./CourseDetails.jsx")) do to CourseDetails's code?$$,
           NULL, NULL,
           $$It removes CourseDetails's code from the app's initial bundle -- it's only downloaded once it's actually needed.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lazy-loading-code-splitting'
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
    ($$It removes CourseDetails's code from the initial bundle, downloading it only when needed$$, TRUE, 0),
    ($$It deletes CourseDetails's code from the project entirely$$, FALSE, 1),
    ($$It duplicates CourseDetails's code into every other bundle for redundancy$$, FALSE, 2),
    ($$It has no effect on bundling at all -- lazy() is purely a naming convention$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lazy-loading-code-splitting'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lazy-loading-code-splitting')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is Suspense required for when using lazy()?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What is Suspense required for when using lazy()?$$,
           NULL, NULL,
           $$Suspense is required to show a fallback during the download of the lazily-loaded component's code.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lazy-loading-code-splitting'
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
    ($$It's entirely optional and has no real purpose when paired with lazy()$$, FALSE, 0),
    ($$To show a fallback while the lazily-loaded component's code is downloading$$, TRUE, 1),
    ($$To automatically retry the download if it fails, with no other configuration$$, FALSE, 2),
    ($$To convert a named export into a default export$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lazy-loading-code-splitting'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lazy-loading-code-splitting')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A user visits only the home page and never navigates to /about. Given this setup, is AboutPage's code ever downloaded?$$
      AND code_snippet = $$const AboutPage = lazy(() => import("./AboutPage.jsx"));

<Routes>
    <Route path="/" element={<Home />} />
    <Route path="/about" element={
        <Suspense fallback={<p>Loading...</p>}>
            <AboutPage />
        </Suspense>
    } />
</Routes>$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A user visits only the home page and never navigates to /about. Given this setup, is AboutPage's code ever downloaded?$$,
           $$const AboutPage = lazy(() => import("./AboutPage.jsx"));

<Routes>
    <Route path="/" element={<Home />} />
    <Route path="/about" element={
        <Suspense fallback={<p>Loading...</p>}>
            <AboutPage />
        </Suspense>
    } />
</Routes>$$, $$jsx$$,
           $$If a user never visits /about, that page's code is never downloaded -- this is route-based code splitting.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lazy-loading-code-splitting'
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
    ($$Yes, but only after a 5-second delay regardless of navigation$$, FALSE, 0),
    ($$It depends on whether Home also imports AboutPage internally$$, FALSE, 1),
    ($$No -- since the user never visits /about, AboutPage's code is never downloaded$$, TRUE, 2),
    ($$Yes -- lazy() always downloads every route's code immediately at app startup$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lazy-loading-code-splitting'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lazy-loading-code-splitting')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$CourseChart is a NAMED export, not a default export. Why is .then((module) => ({ default: module.CourseChart })) needed here?$$
      AND code_snippet = $$const CourseChart = lazy(() =>
    import("./CourseChart.jsx").then((module) => ({ default: module.CourseChart }))
);$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$CourseChart is a NAMED export, not a default export. Why is .then((module) => ({ default: module.CourseChart })) needed here?$$,
           $$const CourseChart = lazy(() =>
    import("./CourseChart.jsx").then((module) => ({ default: module.CourseChart }))
);$$, $$jsx$$,
           $$lazy() expects import() to resolve to a DEFAULT export -- .then(...) converts the named export CourseChart into the { default: ... } shape that lazy expects.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lazy-loading-code-splitting'
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
    ($$Because named exports cannot be used with the import() syntax at all$$, FALSE, 0),
    ($$Because it makes CourseChart's code load faster than a default export would$$, FALSE, 1),
    ($$It's unnecessary boilerplate with no actual functional purpose$$, FALSE, 2),
    ($$Because lazy() expects import() to resolve to a default export, and this converts the named export into that shape$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lazy-loading-code-splitting'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lazy-loading-code-splitting')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Is lazy() only useful for splitting pages/routes, according to this lesson?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Is lazy() only useful for splitting pages/routes, according to this lesson?$$,
           NULL, NULL,
           $$lazy() is useful not just for pages, but for ANY rarely-used component, like EmojiPicker -- its code is never downloaded until showPicker becomes true for the first time.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lazy-loading-code-splitting'
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
    ($$No -- it's also useful for any rarely-used component, like an emoji picker$$, TRUE, 0),
    ($$Yes -- lazy() only works when combined with a Route component$$, FALSE, 1),
    ($$Yes, and it can never be triggered by a state change like showPicker$$, FALSE, 2),
    ($$No -- but rarely-used components must be split with a completely different API$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lazy-loading-code-splitting'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lazy-loading-code-splitting')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following correctly describe code splitting, according to this lesson? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe code splitting, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$Code splitting is breaking an application into multiple small pieces instead of one giant bundle; a bundle is an application's JavaScript files combined together; a chunk is a small, separately downloadable file produced by code splitting.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lazy-loading-code-splitting'
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
    ($$A bundle and a chunk are two interchangeable names for exactly the same thing$$, FALSE, 0),
    ($$It's the technique of breaking an application into multiple small pieces instead of one giant bundle$$, TRUE, 1),
    ($$A chunk is a small, separately downloadable JavaScript file produced by code splitting$$, TRUE, 2),
    ($$Code splitting always requires rewriting an application entirely in a different language$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lazy-loading-code-splitting'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'lazy-loading-code-splitting')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following correctly summarize lazy()'s overall effect, according to this lesson? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly summarize lazy()'s overall effect, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$lazy() splits a component's code into a separate chunk, downloading it only when actually needed -- this reduces the amount of JavaScript loaded initially; lazy() is always used together with Suspense.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'lazy-loading-code-splitting'
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
    ($$lazy() increases the total amount of JavaScript the browser ever downloads, in every case$$, FALSE, 0),
    ($$lazy() eliminates the need for a bundler entirely$$, FALSE, 1),
    ($$It reduces the amount of JavaScript loaded initially, by downloading code only when needed$$, TRUE, 2),
    ($$lazy() is always used together with Suspense, since a fallback is needed while code downloads$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'lazy-loading-code-splitting'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
