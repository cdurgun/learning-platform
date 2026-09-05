-- Promotion-style migration linking EN introduction-to-mcp quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.


-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-mcp')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is the Model Context Protocol (MCP), according to this lesson?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What is the Model Context Protocol (MCP), according to this lesson?$$,
           NULL, NULL,
           $$MCP is an open protocol that standardizes how an AI application connects to external tools, data sources, and prompt templates -- it doesn't replace the tool-calling loop, it standardizes the server side of it, so the same tool implementation can be reused by any MCP-compatible application.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'introduction-to-mcp'
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
    ($$An open protocol that standardizes how an AI application connects to external tools, data sources, and prompt templates$$, TRUE, 0),
    ($$A specific large language model optimized for tool calling$$, FALSE, 1),
    ($$A replacement for the tool-calling loop described in the previous lesson$$, FALSE, 2),
    ($$A programming language used exclusively for writing AI agents$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-mcp'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-mcp')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why does MCP exist? What problem does it solve, according to this lesson?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Why does MCP exist? What problem does it solve, according to this lesson?$$,
           NULL, NULL,
           $$Without a shared standard, connecting M applications to N tools/data sources requires many separate custom integrations; MCP standardizes that architecture so a tool or data source is implemented once as a server and any MCP-compatible application can connect to it unmodified -- often summarized as "M x N -> M + N" (a simplified mental model, not a precise formula).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'introduction-to-mcp'
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
    ($$It guarantees that a model's answers are always factually correct$$, FALSE, 0),
    ($$It reduces the need for a separate, custom integration between every AI application and every tool or data source, often summarized as "M x N -> M + N"$$, TRUE, 1),
    ($$It makes LLM inference run faster by compressing the model's weights$$, FALSE, 2),
    ($$It eliminates the need for tools to have a name, description, or parameter schema$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-mcp'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-mcp')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is the "host" in MCP's host/client/server model?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What is the "host" in MCP's host/client/server model?$$,
           NULL, NULL,
           $$The host is the AI application the person actually interacts with (a chat app, an IDE, a custom agent) -- responsible for talking to the LLM and deciding when to use MCP; it is not the separate program exposing tools (that's the server) and not the internal connection component (that's the client).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'introduction-to-mcp'
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
    ($$The internal component that maintains a one-to-one connection to exactly one server$$, FALSE, 0),
    ($$The physical machine or cloud instance where the LLM's weights are stored$$, FALSE, 1),
    ($$The AI application the person actually interacts with, responsible for talking to the LLM and deciding when to use MCP$$, TRUE, 2),
    ($$The separate program that exposes tools, data, or prompt templates to any connecting client$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-mcp'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-mcp')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A host application needs to reach three different MCP servers at once. According to this lesson, how does this work internally?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A host application needs to reach three different MCP servers at once. According to this lesson, how does this work internally?$$,
           NULL, NULL,
           $$The lesson states a client maintains a single, one-to-one connection to exactly one server -- a host that needs to reach three different servers runs three clients internally, one per connection; it isn't one client juggling three connections, and it doesn't mean three separate hosts are required.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'introduction-to-mcp'
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
    ($$The host runs a single client that juggles all three server connections simultaneously$$, FALSE, 0),
    ($$This requires three completely separate host applications, one per server$$, FALSE, 1),
    ($$This is not possible -- a host can only ever connect to one MCP server at a time$$, FALSE, 2),
    ($$The host runs three clients internally, one per server connection, since each client maintains a one-to-one connection to exactly one server$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-mcp'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-mcp')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to this lesson, does an MCP server need to know which host application or which underlying LLM will eventually call it?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$According to this lesson, does an MCP server need to know which host application or which underlying LLM will eventually call it?$$,
           NULL, NULL,
           $$The lesson explicitly states a server doesn't know or care which host it's talking to, or which underlying LLM the host uses -- it only speaks the protocol; this separation is what makes the "write once, use anywhere" property work.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'introduction-to-mcp'
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
    ($$No -- a server doesn't know or care which host or LLM is calling it, it only speaks the protocol$$, TRUE, 0),
    ($$Yes -- a server must be custom-built for one specific host application and LLM combination$$, FALSE, 1),
    ($$Yes, but only for the LLM, not the host application$$, FALSE, 2),
    ($$Yes, but only for the host application, not the underlying LLM$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-mcp'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-mcp')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$An MCP server offers a specific file's contents to the host application, which the model can read but which involves no computation and performs no action. According to this lesson, which primitive is this?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$An MCP server offers a specific file's contents to the host application, which the model can read but which involves no computation and performs no action. According to this lesson, which primitive is this?$$,
           NULL, NULL,
           $$The lesson defines a resource as readable data the host can pull in, identified by a URI, that is read (not executed) and supplies information rather than performing an action -- distinct from a tool (an executable function that performs an action or computation) and a prompt (a reusable prompt template).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'introduction-to-mcp'
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
    ($$None of MCP's primitives cover this case -- it would require a custom, non-standard extension$$, FALSE, 0),
    ($$A resource -- readable data that is read, not executed, and supplies information rather than performing an action$$, TRUE, 1),
    ($$A tool -- since anything a server exposes to a client counts as a tool$$, FALSE, 2),
    ($$A prompt -- since it's information the model will use in generating a response$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-mcp'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-mcp')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about MCP, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about MCP, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (MCP standardizes discovery/invocation without changing how a model decides to use a tool; a server can expose tools, resources, and prompts, but isn't required to offer all three); MCP does not require every AI application to use exactly the same underlying LLM (servers are LLM-agnostic, not LLM-restrictive), and it does not replace or compete with the underlying idea of tool use from the previous lesson.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'introduction-to-mcp'
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
    ($$MCP requires every AI application connecting to a server to use the exact same underlying LLM$$, FALSE, 0),
    ($$MCP replaces the tool-calling loop and the underlying idea of tool use described in the previous lesson$$, FALSE, 1),
    ($$MCP standardizes how tools are discovered and invoked, without changing how a model itself decides whether and how to use a tool$$, TRUE, 2),
    ($$A given MCP server is free to expose just one of the three primitives (tools, resources, prompts) rather than being required to offer all of them$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-mcp'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
