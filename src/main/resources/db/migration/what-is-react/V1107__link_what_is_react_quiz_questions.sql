-- Links the EN what-is-react questions to the topic's fixed quiz. Same NOT EXISTS /
-- ON CONFLICT DO NOTHING pattern as every prior quiz-link migration: each question is
-- found by its text (or created if missing) and linked at its position, so the file is
-- safe on a fresh database and on one where the promotion migration already ran.

-- Question 1/5 (pair 1 EN, quiz position 1, SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-react')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$On an e-commerce page, the product card, the cart icon and the search box are each built as a separate, reusable piece and then combined. What does React call these pieces?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$On an e-commerce page, the product card, the cart icon and the search box are each built as a separate, reusable piece and then combined. What does React call these pieces?$$,
           NULL, NULL,
           $$React splits a page into small, reusable pieces called components and builds the whole page by combining them. A framework is a different idea altogether: a complete structure you work inside, not a piece of a page.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'what-is-react'
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
        ($$Components$$, TRUE, 0),
        ($$Frameworks$$, FALSE, 1),
        ($$Libraries$$, FALSE, 2),
        ($$Applications$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-react'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/5 (pair 2 EN, quiz position 2, SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-react')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$How does updating the UI change when you use React?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$How does updating the UI change when you use React?$$,
           NULL, NULL,
           $$With React you describe what the UI should look like for the current data. When the data changes, React updates the UI to match. Finding the right element in the DOM and changing it yourself is the manual approach that React replaces.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'what-is-react'
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
        ($$You find each element in the DOM and change it by hand$$, FALSE, 0),
        ($$You change the data, and React updates the UI to match$$, TRUE, 1),
        ($$You reload the page whenever the data changes$$, FALSE, 2),
        ($$You rewrite the page's HTML after every change$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-react'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/5 (pair 3 EN, quiz position 3, SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-react')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$React describes itself as a library rather than a framework. What follows from that in practice?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$React describes itself as a library rather than a framework. What follows from that in practice?$$,
           NULL, NULL,
           $$A library focuses on one question, here how to build the UI. For other needs such as routing or form handling you pick and add separate libraries, for example React Router. Having all of that built in, under the tool's own rules, is what defines a framework such as Angular.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'what-is-react'
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
        ($$Routing, form handling and HTTP requests all come built in$$, FALSE, 0),
        ($$It can only build small parts of a page, never a whole application$$, FALSE, 1),
        ($$For needs such as routing, you choose and add separate libraries yourself$$, TRUE, 2),
        ($$It has to be combined with a framework such as Angular$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-react'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/5 (pair 4 EN, quiz position 4, SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-react')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$In a single page application, what happens when the user clicks a link?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$In a single page application, what happens when the user clicks a link?$$,
           NULL, NULL,
           $$The browser does not reload the whole page from scratch. JavaScript updates only the part that needs to change, which is why there is no brief white flash between pages. A full reload from the server is the traditional behavior that an SPA avoids.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'what-is-react'
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
        ($$The browser reloads the entire page from the server$$, FALSE, 0),
        ($$The new page opens in a separate browser tab$$, FALSE, 1),
        ($$The application starts again from its first screen$$, FALSE, 2),
        ($$JavaScript updates only the part of the page that needs to change$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-react'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/5 (pair 5 EN, quiz position 5, MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-react')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Besides websites, where are React's core ideas used? (Select all that apply)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Besides websites, where are React's core ideas used? (Select all that apply)$$,
           NULL, NULL,
           $$The same ideas power mobile apps through React Native and desktop apps through tools such as Electron. React Router is a routing library for web apps, and Angular is a separate framework rather than a way of running React somewhere else.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'what-is-react'
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
        ($$Mobile apps, with React Native$$, TRUE, 0),
        ($$Mobile apps, with React Router$$, FALSE, 1),
        ($$Desktop apps, with tools such as Electron$$, TRUE, 2),
        ($$Desktop apps, with Angular$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-react'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
