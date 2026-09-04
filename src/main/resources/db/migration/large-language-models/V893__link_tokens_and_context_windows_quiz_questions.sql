-- Promotion-style migration linking EN tokens-and-context-windows quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.


-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'tokens-and-context-windows')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is a "token" in the context of an LLM?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What is a "token" in the context of an LLM?$$,
           NULL, NULL,
           $$This matches the lesson's precise definition; tokens are not a payment-only concept, are not always exactly one character, and are not authentication credentials.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'tokens-and-context-windows'
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
    ($$The actual unit of text an LLM reads and generates -- often close to a word, but not always$$, TRUE, 0),
    ($$A unit of payment charged only for image-generation requests$$, FALSE, 1),
    ($$A single character, always exactly one character long, never more or less$$, FALSE, 2),
    ($$A unique password required to start a new conversation$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'tokens-and-context-windows'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'tokens-and-context-windows')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why do LLMs use sub-word tokens instead of a vocabulary made only of whole words?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Why do LLMs use sub-word tokens instead of a vocabulary made only of whole words?$$,
           NULL, NULL,
           $$This matches the lesson's explicit reasoning: a whole-word-only vocabulary would either be enormous or constantly fail on unseen words (typos, names, made-up words); sub-word tokens let a modest vocabulary represent any text -- the other options are unsupported or contradict the lesson.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'tokens-and-context-windows'
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
    ($$It's purely a historical accident with no practical reasoning behind it$$, FALSE, 0),
    ($$A whole-word-only vocabulary would either be enormous or constantly fail on unseen words (typos, names, made-up words); sub-word tokens let a modest vocabulary represent any text$$, TRUE, 1),
    ($$Sub-word tokens make the model run more slowly on purpose, to improve accuracy$$, FALSE, 2),
    ($$Whole words cannot be represented as numbers, only sub-word pieces can$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'tokens-and-context-windows'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'tokens-and-context-windows')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A model has a context window of 8,000 tokens. A user's conversation, including instructions and history, reaches 8,500 tokens. What must happen?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A model has a context window of 8,000 tokens. A user's conversation, including instructions and history, reaches 8,500 tokens. What must happen?$$,
           NULL, NULL,
           $$This matches the lesson: the context window is a hard ceiling, so something has to give -- older content gets dropped, summarized, or the request is rejected outright, depending on the system; it isn't a "soft suggestion," the model doesn't auto-expand its own window, and it doesn't silently drop the newest content instead of the oldest.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'tokens-and-context-windows'
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
    ($$The model automatically increases its own context window to fit the request$$, FALSE, 0),
    ($$The model silently ignores the newest 500 tokens instead of the oldest$$, FALSE, 1),
    ($$Something has to give: older content gets dropped, summarized, or the request is rejected outright, since the limit is a hard ceiling$$, TRUE, 2),
    ($$Nothing -- context windows are a soft suggestion, not an actual limit$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'tokens-and-context-windows'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'tokens-and-context-windows')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A user says something important early in a very long conversation. Later, once the conversation exceeds the context window and the earliest messages are dropped, the model no longer references that information. Why?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A user says something important early in a very long conversation. Later, once the conversation exceeds the context window and the earliest messages are dropped, the model no longer references that information. Why?$$,
           NULL, NULL,
           $$This matches the lesson exactly: the model has no memory of its own beyond current context, re-reading only what's currently present on every response; dropped content is functionally identical to never having been said -- this is normal, expected, structural behavior, not a rare bug or a deliberate choice.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'tokens-and-context-windows'
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
    ($$The model has a deeper memory of the conversation but chooses not to use it$$, FALSE, 0),
    ($$The model deliberately ignores information it disagrees with$$, FALSE, 1),
    ($$This only happens due to a rare bug, not normal expected behavior$$, FALSE, 2),
    ($$Once content falls out of the context window, the model has no access to it at all -- it re-reads only what's currently in context on every response, with no memory beyond that$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'tokens-and-context-windows'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'tokens-and-context-windows')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why does including a long, mostly irrelevant document in an LLM's context, "just in case," have a real downside even if the context window is large enough to fit it?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Why does including a long, mostly irrelevant document in an LLM's context, "just in case," have a real downside even if the context window is large enough to fit it?$$,
           NULL, NULL,
           $$This matches the lesson: tokens are billed for input and output, and every response re-reads the full context, so cost and latency scale with context size regardless of window headroom -- the other options falsely claim there's no cost.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'tokens-and-context-windows'
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
    ($$Every included token adds real cost (billing) and latency, since the model re-reads the entire context on every response, regardless of whether the window has room$$, TRUE, 0),
    ($$There is no downside as long as it fits within the context window$$, FALSE, 1),
    ($$Extra tokens are free as long as the response itself is short$$, FALSE, 2),
    ($$Large context windows eliminate any cost associated with token count$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'tokens-and-context-windows'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'tokens-and-context-windows')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A system needs to let a user reference something said much earlier in a long conversation, but can't afford to keep the entire raw history in context forever. Which strategy fetches only the specific, relevant pieces of information needed for the current request, rather than keeping everything or compressing everything?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A system needs to let a user reference something said much earlier in a long conversation, but can't afford to keep the entire raw history in context forever. Which strategy fetches only the specific, relevant pieces of information needed for the current request, rather than keeping everything or compressing everything?$$,
           NULL, NULL,
           $$Retrieval fetches only relevant pieces on demand, matching the lesson; truncation simply drops the oldest content, summarization compresses everything into a shorter gist (losing exact wording), and tokenization is an unrelated text-splitting process, not a context-management strategy.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'tokens-and-context-windows'
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
    ($$Tokenization$$, FALSE, 0),
    ($$Retrieval$$, TRUE, 1),
    ($$Truncation$$, FALSE, 2),
    ($$Summarization$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'tokens-and-context-windows'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'tokens-and-context-windows')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about tokens and context windows, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about tokens and context windows, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and C are directly stated in the lesson (tokenization varying by language; token count differing from word count); a larger window still costs tokens for irrelevant content, so cost/latency don't disappear, and the three context-management strategies have explicitly different trade-offs, not identical ones.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'tokens-and-context-windows'
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
    ($$A larger context window removes the need to think about what information is actually included, since irrelevant content no longer has any cost$$, FALSE, 0),
    ($$Truncation, summarization, and retrieval are interchangeable strategies with identical trade-offs in every situation$$, FALSE, 1),
    ($$Tokenization can vary meaningfully by language, so the same sentence can cost noticeably different numbers of tokens in different languages$$, TRUE, 2),
    ($$Token count is not the same as word count -- estimating context usage by word count alone can be misleading$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'tokens-and-context-windows'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
