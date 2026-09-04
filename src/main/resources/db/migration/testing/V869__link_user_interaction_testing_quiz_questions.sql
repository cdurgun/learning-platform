-- Promotion-style migration linking EN user-interaction-testing quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'user-interaction-testing')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why do RTL's official docs now recommend user-event over fireEvent?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Why do RTL's official docs now recommend user-event over fireEvent?$$,
           NULL, NULL,
           $$fireEvent dispatches a single DOM event directly; user-event simulates the IN-BETWEEN steps a real user triggers while clicking/typing too (hover, focus, pointer events).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'user-interaction-testing'
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
    ($$user-event simulates the in-between steps a real user triggers (hover, focus, pointer events), not just a single event$$, TRUE, 0),
    ($$fireEvent has been completely removed from React Testing Library and no longer exists$$, FALSE, 1),
    ($$user-event runs tests significantly faster than fireEvent in every case$$, FALSE, 2),
    ($$There's no real difference -- the recommendation is purely stylistic$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'user-interaction-testing'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'user-interaction-testing')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What must you always do with methods like click and type on the object returned by userEvent.setup()?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What must you always do with methods like click and type on the object returned by userEvent.setup()?$$,
           NULL, NULL,
           $$This object's methods are ALWAYS asynchronous and must be awaited -- forget to, and the test moves to the next line before the click finishes, checking a stale DOM state.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'user-interaction-testing'
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
    ($$Nothing special -- they behave as ordinary synchronous function calls$$, FALSE, 0),
    ($$Always await them, since they are always asynchronous$$, TRUE, 1),
    ($$Wrap them in a try/catch block every single time$$, FALSE, 2),
    ($$Call them only inside a beforeEach block, never inside it()$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'user-interaction-testing'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'user-interaction-testing')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does user.type(input, "Ada") actually simulate?$$
      AND code_snippet = $$const user = userEvent.setup();
const input = screen.getByLabelText("Name");
await user.type(input, "Ada");$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What does user.type(input, "Ada") actually simulate?$$,
           $$const user = userEvent.setup();
const input = screen.getByLabelText("Name");
await user.type(input, "Ada");$$, $$jsx$$,
           $$user.type types the given text CHARACTER BY CHARACTER -- each keystroke triggers the controlled component's onChange, much like typing on a real keyboard would.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'user-interaction-testing'
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
    ($$It only triggers onChange once, after all three characters are already typed$$, FALSE, 0),
    ($$It requires the input to already contain the text "Ada" beforehand$$, FALSE, 1),
    ($$It sets the input's value to "Ada" all at once, in a single operation$$, FALSE, 2),
    ($$It types "Ada" character by character, triggering onChange on each keystroke$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'user-interaction-testing'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'user-interaction-testing')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is vi.fn() used for?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What is vi.fn() used for?$$,
           NULL, NULL,
           $$vi.fn() creates a FAKE function that stands in for a real prop -- without any real request leaving the component, we can verify what arguments this function was called with and how many times.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'user-interaction-testing'
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
    ($$Creating a real network request to a test server$$, FALSE, 0),
    ($$Rendering a component into the fake DOM$$, FALSE, 1),
    ($$Simulating a user clicking a specific button on screen$$, FALSE, 2),
    ($$Creating a fake function standing in for a real prop, to verify how and how often it was called$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'user-interaction-testing'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'user-interaction-testing')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What do toHaveBeenCalledWith(...) and toHaveBeenCalledTimes(...) verify?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What do toHaveBeenCalledWith(...) and toHaveBeenCalledTimes(...) verify?$$,
           NULL, NULL,
           $$These are matchers specific to mock functions (like those created with vi.fn()) -- they verify what arguments a function was called with and how many times.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'user-interaction-testing'
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
    ($$What arguments a mock function was called with, and how many times it was called$$, TRUE, 0),
    ($$Whether an element is currently visible in the DOM$$, FALSE, 1),
    ($$Whether a form's input has a specific placeholder text$$, FALSE, 2),
    ($$How long a component took to render, in milliseconds$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'user-interaction-testing'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'user-interaction-testing')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$CourseList fetches data on mount and eventually renders a course title, but not immediately. Which query correctly waits for it to appear?$$
      AND code_snippet = $$render(<CourseList />);
// Immediately after render, the data hasn't arrived yet
const title = await screen.findByText("Introduction to React");$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$CourseList fetches data on mount and eventually renders a course title, but not immediately. Which query correctly waits for it to appear?$$,
           $$render(<CourseList />);
// Immediately after render, the data hasn't arrived yet
const title = await screen.findByText("Introduction to React");$$, $$jsx$$,
           $$findByText is ASYNCHRONOUS: it doesn't throw if the element isn't there immediately, it retries for a set amount of time (1000ms by default) and continues once the element appears -- unlike getByText, which checks the DOM only at that moment.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'user-interaction-testing'
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
    ($$None of RTL's queries can wait for content that isn't there yet$$, FALSE, 0),
    ($$findByText -- it retries for a set amount of time instead of failing immediately$$, TRUE, 1),
    ($$getByText, since it behaves identically to findByText in every situation$$, FALSE, 2),
    ($$queryByText, since it's specifically designed to wait for asynchronous content$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'user-interaction-testing'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'user-interaction-testing')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following correctly describe testing asynchronous UI updates, according to this lesson? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe testing asynchronous UI updates, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$This is the correct way to test anything that changes the DOM over time (fetch, timers, post-animation state); waitFor(...) can be used for the same purpose as findByText.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'user-interaction-testing'
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
    ($$getByText and queryByText are both fully async and retry automatically, just like findByText$$, FALSE, 0),
    ($$Asynchronous DOM updates can never be reliably tested at all$$, FALSE, 1),
    ($$findByText is the correct way to test anything that changes the DOM over time, like a fetch result$$, TRUE, 2),
    ($$waitFor(...) can be used for the same purpose as findByText$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'user-interaction-testing'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
