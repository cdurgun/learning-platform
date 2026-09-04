-- Promotion-style migration linking EN suspense quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'suspense')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$When does Suspense show its fallback?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$When does Suspense show its fallback?$$,
           NULL, NULL,
           $$Suspense shows a fallback while something INSIDE it isn't ready yet.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'suspense'
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
    ($$While something inside the Suspense boundary isn't ready yet$$, TRUE, 0),
    ($$Permanently, for as long as the component using Suspense exists$$, FALSE, 1),
    ($$Only when the browser window is resized$$, FALSE, 2),
    ($$Only during the very first render of the entire application$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'suspense'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'suspense')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What can the fallback prop be, and what happens to it once the content is ready?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What can the fallback prop be, and what happens to it once the content is ready?$$,
           NULL, NULL,
           $$fallback can be ANY JSX, not just text -- a spinner, a skeleton screen, or another component; once the component inside is ready, fallback is automatically REPLACED with the real content.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'suspense'
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
    ($$It must be manually removed with a separate function call once loading finishes$$, FALSE, 0),
    ($$Any JSX at all, like a spinner or skeleton screen; it's automatically replaced once the content is ready$$, TRUE, 1),
    ($$Only a plain text string -- JSX elements are not allowed as fallback$$, FALSE, 2),
    ($$It stays visible forever, alongside the real content, once it's ready$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'suspense'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'suspense')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$CourseHeader has already loaded, but CourseReviews inside the inner Suspense hasn't. What does the user see for the rest of the page?$$
      AND code_snippet = $$<Suspense fallback={<p>Loading page...</p>}>
    <CourseHeader />
    <Suspense fallback={<p>Loading reviews...</p>}>
        <CourseReviews />
    </Suspense>
</Suspense>$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$CourseHeader has already loaded, but CourseReviews inside the inner Suspense hasn't. What does the user see for the rest of the page?$$,
           $$<Suspense fallback={<p>Loading page...</p>}>
    <CourseHeader />
    <Suspense fallback={<p>Loading reviews...</p>}>
        <CourseReviews />
    </Suspense>
</Suspense>$$, $$jsx$$,
           $$Once CourseHeader appears, the inner Suspense only covers CourseReviews -- the rest of the page does NOT go back to a loading state; only the still-waiting part shows loading.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'suspense'
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
    ($$Nothing renders at all until both CourseHeader and CourseReviews are ready together$$, FALSE, 0),
    ($$Both fallback messages show at the same time, stacked on top of each other$$, FALSE, 1),
    ($$The entire page reverts to "Loading page...", including CourseHeader$$, FALSE, 2),
    ($$CourseHeader stays visible, and only "Loading reviews..." shows in place of CourseReviews$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'suspense'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'suspense')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does the use() hook (React 19) let you do with a Promise?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does the use() hook (React 19) let you do with a Promise?$$,
           NULL, NULL,
           $$The use() hook can integrate a Promise DIRECTLY with Suspense -- given a Promise, if it hasn't resolved yet, it tells React to wait, showing the nearest Suspense's fallback.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'suspense'
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
    ($$Convert any Promise into a synchronous value with zero delay$$, FALSE, 0),
    ($$Cancel a pending Promise automatically after a fixed timeout$$, FALSE, 1),
    ($$Replace useState entirely for every kind of component state$$, FALSE, 2),
    ($$Integrate it directly with Suspense -- if unresolved, it tells React to wait and show the nearest fallback$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'suspense'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'suspense')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Unlike other hooks, can use() be called conditionally, according to this lesson?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Unlike other hooks, can use() be called conditionally, according to this lesson?$$,
           NULL, NULL,
           $$Unlike other hooks, use() can also be called CONDITIONALLY.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'suspense'
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
    ($$Yes -- unlike other hooks, use() can be called conditionally$$, TRUE, 0),
    ($$No -- use() follows the exact same top-level-only rule as every other hook, no exceptions$$, FALSE, 1),
    ($$Only inside a class component's render method$$, FALSE, 2),
    ($$Only when wrapped in a custom hook first$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'suspense'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'suspense')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$This component uses the classic useEffect + fetch pattern inside a Suspense boundary. Does Suspense automatically show its fallback while the fetch is pending?$$
      AND code_snippet = $$function CourseList() {
    const [courses, setCourses] = useState(null);
    useEffect(() => {
        fetch("/courses").then((r) => r.json()).then(setCourses);
    }, []);
    return <ul>{courses?.map((c) => <li key={c.id}>{c.title}</li>)}</ul>;
}

<Suspense fallback={<p>Loading...</p>}>
    <CourseList />
</Suspense>$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$This component uses the classic useEffect + fetch pattern inside a Suspense boundary. Does Suspense automatically show its fallback while the fetch is pending?$$,
           $$function CourseList() {
    const [courses, setCourses] = useState(null);
    useEffect(() => {
        fetch("/courses").then((r) => r.json()).then(setCourses);
    }, []);
    return <ul>{courses?.map((c) => <li key={c.id}>{c.title}</li>)}</ul>;
}

<Suspense fallback={<p>Loading...</p>}>
    <CourseList />
</Suspense>$$, $$jsx$$,
           $$The useEffect + fetch pattern does NOT automatically trigger Suspense -- Suspense only works with a Promise source that React DIRECTLY recognizes, like use(); this component still needs to manage its own loading state.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'suspense'
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
    ($$Only if setCourses is called with null explicitly first$$, FALSE, 0),
    ($$Yes -- any component inside a Suspense boundary automatically shows the fallback while fetching$$, FALSE, 1),
    ($$No -- useEffect + fetch does not automatically trigger Suspense; the component must manage its own loading state$$, TRUE, 2),
    ($$Only if the fetch call takes longer than 1000ms$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'suspense'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'suspense')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following correctly describe what Suspense does and doesn't do automatically, according to this lesson? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe what Suspense does and doesn't do automatically, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$Suspense only works with a Promise source that React directly recognizes, like use(); "classic" data-fetching patterns like useEffect + fetch do NOT automatically trigger it.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'suspense'
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
    ($$Every asynchronous operation in a React app automatically triggers the nearest Suspense$$, FALSE, 0),
    ($$Suspense requires manually calling a triggerSuspense() function for every async operation$$, FALSE, 1),
    ($$Suspense only works automatically with a Promise source that React directly recognizes, like use()$$, TRUE, 2),
    ($$"Classic" patterns like useEffect + fetch do not automatically trigger Suspense$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'suspense'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
