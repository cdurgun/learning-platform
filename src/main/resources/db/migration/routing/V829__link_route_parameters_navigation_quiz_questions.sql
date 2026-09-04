-- Promotion-style migration linking EN route-parameters-navigation quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'route-parameters-navigation')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given path="/courses/:courseSlug" and a visit to /courses/java, how do you read courseSlug's value inside the component?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Given path="/courses/:courseSlug" and a visit to /courses/java, how do you read courseSlug's value inside the component?$$,
           NULL, NULL,
           $$Inside the component, we read this value with the useParams() hook; the key on the returned object matches the name used in the Route (courseSlug).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'route-parameters-navigation'
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
    ($$With the useParams() hook, whose returned object has a courseSlug field$$, TRUE, 0),
    ($$It's automatically injected as a global variable named courseSlug$$, FALSE, 1),
    ($$By reading window.location.pathname and manually splitting the string$$, FALSE, 2),
    ($$It can't be read at all -- route parameters are write-only$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'route-parameters-navigation'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'route-parameters-navigation')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does writing one Route INSIDE another create?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does writing one Route INSIDE another create?$$,
           NULL, NULL,
           $$Writing one Route inside another creates a nested structure -- a nested route.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'route-parameters-navigation'
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
    ($$An infinite redirect loop$$, FALSE, 0),
    ($$A nested route structure$$, TRUE, 1),
    ($$A syntax error, since Routes can never be nested inside each other$$, FALSE, 2),
    ($$Two completely independent, unrelated pages$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'route-parameters-navigation'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'route-parameters-navigation')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$CourseLayout is the parent route's element, but it does NOT include an <Outlet />. What happens to the matching nested child route?$$
      AND code_snippet = $$function CourseLayout() {
    return (
        <div>
            <h1>Course Page</h1>
            {/* No <Outlet /> here at all */}
        </div>
    );
}

<Route path="/courses/:courseSlug" element={<CourseLayout />}>
    <Route path=":topicSlug" element={<TopicContent />} />
</Route>$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$CourseLayout is the parent route's element, but it does NOT include an <Outlet />. What happens to the matching nested child route?$$,
           $$function CourseLayout() {
    return (
        <div>
            <h1>Course Page</h1>
            {/* No <Outlet /> here at all */}
        </div>
    );
}

<Route path="/courses/:courseSlug" element={<CourseLayout />}>
    <Route path=":topicSlug" element={<TopicContent />} />
</Route>$$, $$jsx$$,
           $$The Outlet placed inside the parent component marks exactly where the matching child route should render -- without Outlet, the child route wouldn't appear anywhere, even though its path still matches.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'route-parameters-navigation'
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
    ($$React throws a compile-time error, since Outlet is mandatory syntax$$, FALSE, 0),
    ($$CourseLayout itself fails to render at all$$, FALSE, 1),
    ($$TopicContent renders automatically at the bottom of CourseLayout regardless$$, FALSE, 2),
    ($$TopicContent never appears anywhere on screen, even though its path matches$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'route-parameters-navigation'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'route-parameters-navigation')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does the useNavigate() hook give you?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does the useNavigate() hook give you?$$,
           NULL, NULL,
           $$The useNavigate() hook gives us a navigate function; calling it from inside an event handler changes the URL.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'route-parameters-navigation'
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
    ($$A list of every route currently defined in the app$$, FALSE, 0),
    ($$A boolean indicating whether the current page has fully loaded$$, FALSE, 1),
    ($$A reference to the browser's address bar DOM element$$, FALSE, 2),
    ($$A navigate function that changes the URL when called$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'route-parameters-navigation'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'route-parameters-navigation')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens after this form is submitted?$$
      AND code_snippet = $$function AddCourseForm() {
    const navigate = useNavigate();

    function handleSubmit(event) {
        event.preventDefault();
        // ... save logic here ...
        navigate("/courses");
    }

    return <form onSubmit={handleSubmit}>...</form>;
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What happens after this form is submitted?$$,
           $$function AddCourseForm() {
    const navigate = useNavigate();

    function handleSubmit(event) {
        event.preventDefault();
        // ... save logic here ...
        navigate("/courses");
    }

    return <form onSubmit={handleSubmit}>...</form>;
}$$, $$jsx$$,
           $$After the form is "submitted," the user is redirected to the course list with navigate("/courses") -- a common use of useNavigate for redirecting after an action.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'route-parameters-navigation'
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
    ($$Nothing happens to the URL -- navigate only logs a message to the console$$, FALSE, 0),
    ($$The user is redirected to /courses after the form's save logic runs$$, TRUE, 1),
    ($$The browser reloads the entire page and shows /courses$$, FALSE, 2),
    ($$navigate("/courses") only works if it's called from inside a Link component$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'route-parameters-navigation'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'route-parameters-navigation')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following correctly describe navigate(-1), according to this lesson? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe navigate(-1), according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$navigate can be given a number instead of a URL, used to move in browser history; navigate(-1) does the same thing as the browser's back button, and is usually preferred for Back buttons since it returns to wherever the user came from.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'route-parameters-navigation'
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
    ($$navigate(-1) is only usable inside a Link component, never inside an event handler$$, FALSE, 0),
    ($$navigate can be given a number instead of a URL, to move forward or backward in browser history$$, TRUE, 1),
    ($$navigate(-1) does the same thing as the browser's "back" button$$, TRUE, 2),
    ($$navigate(-1) always sends the user to a fixed page like /courses, regardless of history$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'route-parameters-navigation'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'route-parameters-navigation')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following correctly distinguish Link from useNavigate, according to this lesson? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly distinguish Link from useNavigate, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$Link always requires the user to CLICK something; useNavigate lets you change pages from code as a result of something -- a condition, an action -- not tied to a click.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'route-parameters-navigation'
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
    ($$useNavigate can only be called from inside a Link component's onClick prop$$, FALSE, 0),
    ($$Link and useNavigate are two interchangeable names for exactly the same mechanism$$, FALSE, 1),
    ($$Link always requires the user to click something to trigger navigation$$, TRUE, 2),
    ($$useNavigate lets you change pages from code, as a result of a condition rather than a click$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'route-parameters-navigation'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
