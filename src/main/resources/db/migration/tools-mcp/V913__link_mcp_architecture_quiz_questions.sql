-- Promotion-style migration linking EN mcp-architecture quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.


-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'mcp-architecture')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What wire format does MCP use for messages exchanged between a client and a server?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What wire format does MCP use for messages exchanged between a client and a server?$$,
           NULL, NULL,
           $$The lesson is explicit that MCP does not invent its own message format -- it adopts JSON-RPC 2.0, a small, pre-existing, general-purpose, text-based format unrelated to MCP itself, as its wire format.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'mcp-architecture'
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
    ($$JSON-RPC 2.0 -- a pre-existing, general-purpose message format that MCP adopted rather than inventing its own$$, TRUE, 0),
    ($$A custom binary format designed specifically and exclusively for MCP$$, FALSE, 1),
    ($$Plain, unstructured text with no defined message shape$$, FALSE, 2),
    ($$XML-RPC, an XML-based predecessor format that MCP replaced$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'mcp-architecture'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'mcp-architecture')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to this lesson, what are the two most common transports for carrying MCP's JSON-RPC messages?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$According to this lesson, what are the two most common transports for carrying MCP's JSON-RPC messages?$$,
           NULL, NULL,
           $$The lesson names stdio (client launches the server as a local subprocess, messages travel over standard input/output) and Streamable HTTP (server runs as an independent, possibly remote process reachable over HTTP) as the two most common transports.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'mcp-architecture'
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
    ($$Bluetooth and USB$$, FALSE, 0),
    ($$stdio and Streamable HTTP$$, TRUE, 1),
    ($$WebSockets and gRPC$$, FALSE, 2),
    ($$FTP and SMTP$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'mcp-architecture'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'mcp-architecture')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given this JSON-RPC 2.0 request MCP would send to invoke a tool, what does the "method" field's value indicate is happening?$$
      AND code_snippet = $${
  "jsonrpc": "2.0",
  "id": 1,
  "method": "tools/call",
  "params": {
    "name": "get_capital_city",
    "arguments": { "country": "Japan" }
  }
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given this JSON-RPC 2.0 request MCP would send to invoke a tool, what does the "method" field's value indicate is happening?$$,
           $${
  "jsonrpc": "2.0",
  "id": 1,
  "method": "tools/call",
  "params": {
    "name": "get_capital_city",
    "arguments": { "country": "Japan" }
  }
}$$, $$json$$,
           $$The "method" field's value, "tools/call", identifies this as an invocation request -- the client is asking the server to actually run the named tool (get_capital_city) with the given arguments, as opposed to a discovery request like "tools/list".$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'mcp-architecture'
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
    ($$This is the server's response, returning the result of a tool call back to the client$$, FALSE, 0),
    ($$This is an initialize request establishing the protocol version between client and server$$, FALSE, 1),
    ($$This is a tool invocation request -- the client is asking the server to actually run the get_capital_city tool with the given arguments$$, TRUE, 2),
    ($$This is a discovery request asking the server to list all of its available tools$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'mcp-architecture'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'mcp-architecture')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Put the three phases of an MCP connection's lifecycle in the correct order, as this lesson describes them.$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Put the three phases of an MCP connection's lifecycle in the correct order, as this lesson describes them.$$,
           NULL, NULL,
           $$The lesson lays out the lifecycle as Initialize (agree on protocol version and capabilities) first, then Discover (tools/list, resources/list, prompts/list), then Invoke (tools/call, resources/read) -- a single connection typically runs one initialize phase, then repeats discovery and invocation many times.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'mcp-architecture'
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
    ($$Discover, then Initialize, then Invoke$$, FALSE, 0),
    ($$Invoke, then Discover, then Initialize$$, FALSE, 1),
    ($$Discover, then Invoke, then Initialize$$, FALSE, 2),
    ($$Initialize, then Discover, then Invoke$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'mcp-architecture'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'mcp-architecture')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$During the initialize phase, a client and server each declare which optional MCP features they actually support (for example, whether the server supports resources at all). What is this called, and why does it exist?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$During the initialize phase, a client and server each declare which optional MCP features they actually support (for example, whether the server supports resources at all). What is this called, and why does it exist?$$,
           NULL, NULL,
           $$This is called capability negotiation, and it exists because not every host or server needs every MCP feature -- a minimal server that only exposes tools doesn't need to implement resource support, and a client only prepares for the capabilities a given server actually declares.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'mcp-architecture'
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
    ($$Capability negotiation -- it exists because not every host or server needs to support every MCP feature$$, TRUE, 0),
    ($$Tool discovery -- it exists so the client can learn the names of all available tools$$, FALSE, 1),
    ($$Transport selection -- it exists so the client can choose between stdio and Streamable HTTP$$, FALSE, 2),
    ($$Authentication -- it exists so the server can verify the client's identity before allowing any connection$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'mcp-architecture'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'mcp-architecture')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$This course's hands-on example connects its client and server using an in-memory transport instead of stdio or Streamable HTTP. According to this lesson, why?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$This course's hands-on example connects its client and server using an in-memory transport instead of stdio or Streamable HTTP. According to this lesson, why?$$,
           NULL, NULL,
           $$The lesson explicitly frames the in-memory transport as a deliberate simplification for a self-contained, runnable lesson -- both sides run in the same process, exchanging the exact same JSON-RPC messages, and the lesson explicitly states a production setup almost always uses stdio or Streamable HTTP instead.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'mcp-architecture'
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
    ($$In-memory transport is required whenever a server exposes more than one tool$$, FALSE, 0),
    ($$It's a deliberate simplification to keep the hands-on example self-contained and runnable -- production setups almost always use stdio or Streamable HTTP instead$$, TRUE, 1),
    ($$In-memory transport is the recommended production standard for all real MCP deployments$$, FALSE, 2),
    ($$stdio and Streamable HTTP are both deprecated and no longer supported by the MCP specification$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'mcp-architecture'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'mcp-architecture')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about MCP architecture, as covered in this lesson, are correct? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about MCP architecture, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (a JSON-RPC response carries a matching id with either a result or an error; which transport is used is invisible to the tool-calling logic, and a tool's name/description/behavior are identical regardless of transport); the lesson explicitly says a connection typically runs discovery and invocation many times after a single initialize phase, not the reverse, and the connection lifecycle applies across stdio, Streamable HTTP, and in-memory transports alike, not only to in-memory ones.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'mcp-architecture'
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
    ($$A single MCP connection typically runs the initialize phase many times, once before every single discovery or invocation$$, FALSE, 0),
    ($$The initialize/discover/invoke lifecycle only applies to connections using the in-memory transport, not stdio or Streamable HTTP$$, FALSE, 1),
    ($$A JSON-RPC 2.0 response carries an id matching the request, along with either a result or an error$$, TRUE, 2),
    ($$A tool's name, description, and behavior are identical regardless of which transport (stdio, Streamable HTTP, or in-memory) carries the messages$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'mcp-architecture'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
