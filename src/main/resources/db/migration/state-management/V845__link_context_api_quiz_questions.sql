-- Promotion-style migration linking EN context-api quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'context-api')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does the value passed to createContext("light") represent?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does the value passed to createContext("light") represent?$$,
           NULL, NULL,
           $$The value in the parentheses is the DEFAULT value used when there's no Provider.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'context-api'
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
    ($$The default value used when there's no Provider$$, TRUE, 0),
    ($$A CSS theme name applied automatically to every component$$, FALSE, 1),
    ($$The name of the Context, used for debugging purposes only$$, FALSE, 2),
    ($$A required prop every component using this Context must supply$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'context-api'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'context-api')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does <ThemeContext.Provider value="dark"> do?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does <ThemeContext.Provider value="dark"> do?$$,
           NULL, NULL,
           $$It OVERRIDES the context's value to "dark" for the entire tree inside it.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'context-api'
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
    ($$Requires every child component to explicitly opt in with a special prop$$, FALSE, 0),
    ($$Overrides the context's value to "dark" for the entire tree inside the Provider$$, TRUE, 1),
    ($$Deletes the context's default value permanently, for the whole application$$, FALSE, 2),
    ($$Only affects the Provider's direct parent component, not its children$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'context-api'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'context-api')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$ThemedButton calls useContext(ThemeContext). What value does it read?$$
      AND code_snippet = $$const ThemeContext = createContext("light");

function App() {
    return (
        <ThemeContext.Provider value="dark">
            <ThemedButton />
        </ThemeContext.Provider>
    );
}

function ThemedButton() {
    const theme = useContext(ThemeContext);
    return <button className={theme}>Click</button>;
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$ThemedButton calls useContext(ThemeContext). What value does it read?$$,
           $$const ThemeContext = createContext("light");

function App() {
    return (
        <ThemeContext.Provider value="dark">
            <ThemedButton />
        </ThemeContext.Provider>
    );
}

function ThemedButton() {
    const theme = useContext(ThemeContext);
    return <button className={theme}>Click</button>;
}$$, $$jsx$$,
           $$useContext(ThemeContext) reads the value from the nearest Provider -- since ThemedButton is inside a Provider with value="dark", it reads "dark", not the createContext default.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'context-api'
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
    ($$undefined, since ThemedButton is a child, not the Provider itself$$, FALSE, 0),
    ($$Both "light" and "dark" are returned together as an array$$, FALSE, 1),
    ($$"light", the default value from createContext$$, FALSE, 2),
    ($$"dark", the value from the nearest Provider$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'context-api'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'context-api')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$There is no Provider anywhere in this tree at all. What value does useContext(ThemeContext) return inside ThemedButton?$$
      AND code_snippet = $$const ThemeContext = createContext("light");

function App() {
    return <ThemedButton />; // no Provider anywhere
}

function ThemedButton() {
    const theme = useContext(ThemeContext);
    return <button className={theme}>Click</button>;
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$There is no Provider anywhere in this tree at all. What value does useContext(ThemeContext) return inside ThemedButton?$$,
           $$const ThemeContext = createContext("light");

function App() {
    return <ThemedButton />; // no Provider anywhere
}

function ThemedButton() {
    const theme = useContext(ThemeContext);
    return <button className={theme}>Click</button>;
}$$, $$jsx$$,
           $$A Provider isn't always required -- without one, useContext returns the default value given to createContext, which is "light" here.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'context-api'
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
    ($$"light" -- the default value given to createContext is used when there's no Provider$$, TRUE, 0),
    ($$It throws a runtime error immediately, since a Provider is always mandatory$$, FALSE, 1),
    ($$null, since Context requires an explicit Provider to function at all$$, FALSE, 2),
    ($$undefined, since there's no Provider to read from$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'context-api'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'context-api')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does value={{ items, addItem }} give the Provider?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does value={{ items, addItem }} give the Provider?$$,
           NULL, NULL,
           $$value={{ items, addItem }} gives the Provider an OBJECT -- both the current items list and the addItem function that updates it. This is the most common way Context is used in real applications.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'context-api'
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
    ($$An object carrying both the current items list and the addItem function that updates it$$, TRUE, 0),
    ($$Only the items list -- functions can never be passed through Context$$, FALSE, 1),
    ($$A string combining items and addItem into one piece of text$$, FALSE, 2),
    ($$Two separate, unrelated Contexts created at once$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'context-api'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'context-api')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following correctly describe wrapping Context in a custom hook like useTheme(), according to this lesson? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe wrapping Context in a custom hook like useTheme(), according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$useTheme() wraps useContext(ThemeContext) to expose a cleaner API -- the consuming component calls useTheme() without dealing with the concept of "context"; throwing an error when used outside a Provider catches misuse early.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'context-api'
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
    ($$Wrapping Context in a custom hook is required syntax and won't work without it$$, FALSE, 0),
    ($$useTheme() wraps useContext(ThemeContext) to expose a cleaner API to the consuming component$$, TRUE, 1),
    ($$Throwing an error when the hook is used outside a Provider catches misuse early$$, TRUE, 2),
    ($$A custom hook wrapping Context can never itself call useContext$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'context-api'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'context-api')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are true about how Context solves the props-drilling problem from Sharing State, according to this lesson? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about how Context solves the props-drilling problem from Sharing State, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$None of Level1, Level2, Level3 even know about the user prop anymore -- only Level4, at the very bottom, reads it directly from UserContext; nothing needs to be passed through the intermediate layers.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'context-api'
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
    ($$Context still requires every intermediate component to explicitly forward the value as a prop$$, FALSE, 0),
    ($$Context replaces the need for a Provider anywhere in the tree$$, FALSE, 1),
    ($$Intermediate levels no longer need to know about the value at all$$, TRUE, 2),
    ($$Only the component that actually needs the value reads it directly from Context$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'context-api'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
