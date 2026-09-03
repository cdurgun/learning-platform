-- Promotion-style migration linking EN use-ref quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'use-ref')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does writing ref={inputRef} on a JSX element actually do?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does writing ref={inputRef} on a JSX element actually do?$$,
           NULL, NULL,
           $$It tells React "put this element's real DOM node into inputRef.current" -- inputRef.current becomes a real DOM element you can call browser methods on, like focus().$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'use-ref'
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
    ($$It tells React to put that element's real DOM node into inputRef.current$$, TRUE, 0),
    ($$It creates a new state variable that re-renders whenever the input changes$$, FALSE, 1),
    ($$It attaches a CSS style directly to the element$$, FALSE, 2),
    ($$It passes the element as a prop to a child component automatically$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'use-ref'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'use-ref')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Does incrementing renderCount.current on every render, by itself, trigger a re-render?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Does incrementing renderCount.current on every render, by itself, trigger a re-render?$$,
           NULL, NULL,
           $$No -- renderCount.current increases and its value persists across renders, but that increase doesn't trigger a re-render on its own; you only see the updated value on the next render, triggered for some other reason.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'use-ref'
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
    ($$It depends on whether useEffect is also used in the same component$$, FALSE, 0),
    ($$No -- the increase doesn't trigger a re-render on its own$$, TRUE, 1),
    ($$Yes -- any change to a ref's .current value always triggers a re-render$$, FALSE, 2),
    ($$Yes, but only on every third render$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'use-ref'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'use-ref')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is the key difference between useRef and useState, according to this lesson?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What is the key difference between useRef and useState, according to this lesson?$$,
           NULL, NULL,
           $$Changing state with useState TRIGGERS a re-render; changing a ref does NOT.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'use-ref'
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
    ($$useState is always slower than useRef in every circumstance$$, FALSE, 0),
    ($$useRef requires a dependency array, while useState never does$$, FALSE, 1),
    ($$Changing state with useState triggers a re-render; changing a ref does not$$, TRUE, 2),
    ($$useRef can only store numbers, while useState can store any type$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'use-ref'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'use-ref')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What happens on screen when the "Increment Ref" button is clicked?$$
      AND code_snippet = $$function Counter() {
    const refValue = useRef(0);

    function handleClick() {
        refValue.current = refValue.current + 1;
        console.log(refValue.current);
    }

    return <button onClick={handleClick}>Increment Ref: {refValue.current}</button>;
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What happens on screen when the "Increment Ref" button is clicked?$$,
           $$function Counter() {
    const refValue = useRef(0);

    function handleClick() {
        refValue.current = refValue.current + 1;
        console.log(refValue.current);
    }

    return <button onClick={handleClick}>Increment Ref: {refValue.current}</button>;
}$$, $$jsx$$,
           $$The ref's value really does change (visible in the console), but nothing changes on screen -- a ref change doesn't tell React "re-render," so the displayed number stays the same until some other state change causes a re-render.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'use-ref'
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
    ($$The console logs the new value, but the number shown on the button does not visually update$$, TRUE, 0),
    ($$Nothing happens at all -- refValue.current never actually changes$$, FALSE, 1),
    ($$React throws an error, since refs cannot be mutated inside an event handler$$, FALSE, 2),
    ($$The displayed number on the button increases by 1 immediately, as expected$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'use-ref'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'use-ref')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to this lesson's guidance, when should you reach for state versus a ref?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$According to this lesson's guidance, when should you reach for state versus a ref?$$,
           NULL, NULL,
           $$A value that needs to be VISIBLE on screen should be state; a value that just needs to be "remembered," without appearing on screen, can be a ref.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'use-ref'
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
    ($$A value that needs to be visible on screen should be state; a "background" value that doesn't need to appear can be a ref$$, TRUE, 0),
    ($$Refs should always be preferred over state, since they never trigger unnecessary re-renders$$, FALSE, 1),
    ($$State and refs are fully interchangeable and the choice never matters$$, FALSE, 2),
    ($$Refs are only for numbers; state must be used for strings and objects$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'use-ref'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'use-ref')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$count starts at 5, then the component re-renders after count changes to 8. What does previousCountRef.current hold DURING that render, before the effect runs again?$$
      AND code_snippet = $$function Tracker({ count }) {
    const previousCountRef = useRef();

    useEffect(() => {
        previousCountRef.current = count;
    });

    return <p>Now: {count}, Before: {previousCountRef.current}</p>;
}
// count changes from 5 to 8, triggering a re-render$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$count starts at 5, then the component re-renders after count changes to 8. What does previousCountRef.current hold DURING that render, before the effect runs again?$$,
           $$function Tracker({ count }) {
    const previousCountRef = useRef();

    useEffect(() => {
        previousCountRef.current = count;
    });

    return <p>Now: {count}, Before: {previousCountRef.current}</p>;
}
// count changes from 5 to 8, triggering a re-render$$, $$jsx$$,
           $$Since updating a ref doesn't trigger a new render on its own, previousCountRef.current still holds the value from the PREVIOUS render (5) during this render, before the effect (which runs after render) updates it to 8.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'use-ref'
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
    ($$It's always equal to whatever count currently is, on every render$$, FALSE, 0),
    ($$8, because the ref updates immediately when count changes$$, FALSE, 1),
    ($$5, the value saved from the previous render, since the effect hasn't run for this render yet$$, TRUE, 2),
    ($$undefined, since the ref was never initialized with a starting value$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'use-ref'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'use-ref')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are true about useRef's .current field, according to this lesson? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about useRef's .current field, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$.current holds the currently stored value, whether that's a real DOM node (via the ref attribute) or a plain persisted value; changing .current doesn't trigger a re-render.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'use-ref'
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
    ($$Changing .current always causes the component to re-render, just like calling a state setter$$, FALSE, 0),
    ($$.current can only ever hold a DOM element, never a plain number or other value$$, FALSE, 1),
    ($$.current is the field on the object useRef returns that holds the currently stored value$$, TRUE, 2),
    ($$When used with the ref attribute, .current becomes a real DOM element you can call browser methods on$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'use-ref'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
