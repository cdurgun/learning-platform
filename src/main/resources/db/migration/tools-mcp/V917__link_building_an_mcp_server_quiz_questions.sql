-- Promotion-style migration linking EN building-an-mcp-server quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- EN batch is linked.


-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'building-an-mcp-server')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why must "type": "module" remain in package.json for this lesson's MCP server project?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Why must "type": "module" remain in package.json for this lesson's MCP server project?$$,
           NULL, NULL,
           $$The lesson is explicit: without "type": "module", Node treats compiled output as CommonJS, and the top-level await used throughout RunServerWithClient.ts fails to run -- it is not an optional stylistic setting.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'building-an-mcp-server'
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
    ($$Without it, Node treats compiled output as CommonJS, and the top-level await used in RunServerWithClient.ts fails to run$$, TRUE, 0),
    ($$It's purely a stylistic convention with no functional effect on how the code runs$$, FALSE, 1),
    ($$It's required only if the project uses the calculate_sum tool specifically$$, FALSE, 2),
    ($$It tells npm to install packages faster by skipping dependency resolution$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'building-an-mcp-server'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'building-an-mcp-server')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$In GeoFactsServer.ts, what three parts does server.registerTool() give each tool, matching the pattern from "Tools and Function Calling"?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$In GeoFactsServer.ts, what three parts does server.registerTool() give each tool, matching the pattern from "Tools and Function Calling"?$$,
           NULL, NULL,
           $$The lesson states registerTool() gives each tool exactly the three parts "Defining a Tool: Name, Description, and Schema" described -- a name, a description, and a zod-based parameter schema.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'building-an-mcp-server'
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
    ($$A class name, a constructor, and a set of getters/setters$$, FALSE, 0),
    ($$A name, a description, and a zod-based parameter schema$$, TRUE, 1),
    ($$A name, a version number, and a list of dependencies$$, FALSE, 2),
    ($$A URL, an HTTP method, and a request body$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'building-an-mcp-server'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'building-an-mcp-server')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Given this tool handler from GeoFactsServer.ts, what does calling get_capital_city with country="Turkey" return?$$
      AND code_snippet = $$const CAPITALS: Record<string, string> = {
  France: "Paris",
  Japan: "Tokyo",
  Turkey: "Ankara",
};

async ({ country }) => {
  const capital = CAPITALS[country];
  if (!capital) {
    return {
      content: [{ type: "text", text: `No capital known for "${country}".` }],
      isError: true,
    };
  }
  return { content: [{ type: "text", text: `The capital of ${country} is ${capital}.` }] };
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Given this tool handler from GeoFactsServer.ts, what does calling get_capital_city with country="Turkey" return?$$,
           $$const CAPITALS: Record<string, string> = {
  France: "Paris",
  Japan: "Tokyo",
  Turkey: "Ankara",
};

async ({ country }) => {
  const capital = CAPITALS[country];
  if (!capital) {
    return {
      content: [{ type: "text", text: `No capital known for "${country}".` }],
      isError: true,
    };
  }
  return { content: [{ type: "text", text: `The capital of ${country} is ${capital}.` }] };
}$$, $$typescript$$,
           $$"Turkey" is present in the CAPITALS map with the value "Ankara", so the capital branch runs and returns the text "The capital of Turkey is Ankara." with no isError flag -- the isError:true path only triggers for a country missing from the map.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'building-an-mcp-server'
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
    ($$An unhandled exception is thrown, since Turkey is not explicitly checked before the lookup$$, FALSE, 0),
    ($$content: [{ type: "text", text: "Turkey" }]  (the country name echoed back unchanged)$$, FALSE, 1),
    ($$content: [{ type: "text", text: "The capital of Turkey is Ankara." }]  (no isError)$$, TRUE, 2),
    ($$content: [{ type: "text", text: "No capital known for \"Turkey\"." }], isError: true$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'building-an-mcp-server'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'building-an-mcp-server')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$In RunServerWithClient.ts, the client calls client.listTools() before calling any tool. What does the console output show for this line, based on the two tools GeoFactsServer.ts registers?$$
      AND code_snippet = $$const toolList = await client.listTools();
console.log("Tools discovered by client:", toolList.tools.map((t) => t.name));$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$In RunServerWithClient.ts, the client calls client.listTools() before calling any tool. What does the console output show for this line, based on the two tools GeoFactsServer.ts registers?$$,
           $$const toolList = await client.listTools();
console.log("Tools discovered by client:", toolList.tools.map((t) => t.name));$$, $$typescript$$,
           $$The lesson's shown, actually-run output for this exact line is: Tools discovered by client: [ 'get_capital_city', 'calculate_sum' ] -- this is the tools/list discovery step, proving the client learned both tool names from the server over the protocol rather than having them hardcoded.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'building-an-mcp-server'
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
    ($$Tools discovered by client: [ ]  (an empty list, since no tool has been called yet)$$, FALSE, 0),
    ($$Tools discovered by client: [ 'GeoFactsServer', 'RunServerWithClient' ]  (the file names)$$, FALSE, 1),
    ($$This line throws an error, since listTools() cannot run before the first callTool()$$, FALSE, 2),
    ($$Tools discovered by client: [ 'get_capital_city', 'calculate_sum' ]$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'building-an-mcp-server'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'building-an-mcp-server')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$get_capital_city returns isError: true with a clear message when asked about "Wakanda", a country not in CAPITALS, instead of throwing an exception or guessing an answer. According to this lesson, why is this a good pattern?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$get_capital_city returns isError: true with a clear message when asked about "Wakanda", a country not in CAPITALS, instead of throwing an exception or guessing an answer. According to this lesson, why is this a good pattern?$$,
           NULL, NULL,
           $$The lesson states this gives the model something concrete to work with instead of an opaque failure -- it's a direct application of the idea, from "Tools and Function Calling", that the tool-calling loop should hand the model something concrete even when a tool fails, rather than crashing or silently making up a wrong answer.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'building-an-mcp-server'
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
    ($$It gives the model something concrete to work with instead of an opaque failure, rather than crashing or silently making up a wrong answer$$, TRUE, 0),
    ($$It makes the tool run measurably faster than throwing an exception would$$, FALSE, 1),
    ($$It's required by the MCP specification for every single tool without exception$$, FALSE, 2),
    ($$It prevents the client from ever being able to call this tool again in the same session$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'building-an-mcp-server'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'building-an-mcp-server')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why do imports from the SDK in this lesson's TypeScript files need an explicit ".js" extension (e.g., "@modelcontextprotocol/sdk/server/mcp.js"), even though the source files are ".ts"?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Why do imports from the SDK in this lesson's TypeScript files need an explicit ".js" extension (e.g., "@modelcontextprotocol/sdk/server/mcp.js"), even though the source files are ".ts"?$$,
           NULL, NULL,
           $$The lesson states this is specifically because the SDK ships as native ESM, and the "module": "NodeNext" / "moduleResolution": "NodeNext" settings in tsconfig.json require that .js extension even from .ts source files -- omitting it produces a module-not-found error at compile time.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'building-an-mcp-server'
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
    ($$It's a purely cosmetic convention with no effect on whether the code compiles$$, FALSE, 0),
    ($$Because the SDK ships as native ESM, and NodeNext module resolution requires the .js extension even from .ts source files$$, TRUE, 1),
    ($$Because TypeScript files are always secretly renamed to .js before being saved to disk$$, FALSE, 2),
    ($$Because the zod library requires all its dependencies to use the .js extension specifically$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'building-an-mcp-server'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'building-an-mcp-server')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about moving this lesson's demo to a real deployment are correct, according to "From This Demo to a Real Deployment"? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about moving this lesson's demo to a real deployment are correct, according to "From This Demo to a Real Deployment"? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (only the transport changes -- connecting to StdioServerTransport instead of the in-memory transport -- while GeoFactsServer.ts's tool definitions and behavior stay completely unchanged, and this is exactly why the server definition is kept in its own createGeoFactsServer() function separate from the demo's transport wiring); the tool logic in GeoFactsServer.ts does not need to be rewritten for a real deployment, and the server does not need to run in-process together with the host application in a real setup.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'building-an-mcp-server'
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
    ($$The tool definitions and their behavior in GeoFactsServer.ts need to be substantially rewritten before they can work in a real deployment$$, FALSE, 0),
    ($$In a real deployment, the server must run in the exact same process as the host application, just as it does in this lesson's in-memory demo$$, FALSE, 1),
    ($$Only the transport changes -- for example, connecting server to a StdioServerTransport instead of the in-memory transport used in the demo$$, TRUE, 2),
    ($$Keeping the server definition in its own function, separate from the demo's transport wiring, is what makes it reusable for a real deployment$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'building-an-mcp-server'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
