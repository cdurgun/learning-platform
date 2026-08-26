# n8n → Question Ingestion (development only)

This directory holds n8n workflow definitions that call the existing
`POST /api/internal/questions/ingest` endpoint (`QuestionIngestController`/
`QuestionIngestService`). n8n never talks to Postgres directly, never connects
to production, and never publishes/rejects questions — it only ever calls this
one HTTP endpoint, exactly like a manual `curl` call would.

## workflows/question-ingestion-test-batch.json

A small, hand-written test batch: 3 real `SINGLE_CHOICE` questions about the
`enum` topic (the only topic with real published quiz content today), each with
4 options and exactly one correct answer, `source: "N8N"`. It never sends a
`status` field — the API forces `PENDING_REVIEW` regardless.

**Nodes:**
1. Manual Trigger
2. `Build Test Questions` (Code node) — builds the 3 question payloads in-memory. This is where a future workflow would instead call an LLM node to generate questions; for this first test batch the content is fixed/hand-written.
3. `Ingest Question` (HTTP Request, POST) — runs once per item (n8n's default batch behavior when a node follows a multi-item node). `retryOnFail: false` and `onError: "continueRegularOutput"` are both set explicitly, so a bad item surfaces its error clearly in the execution output instead of being silently retried (which could otherwise create duplicate questions) or crashing the whole run.

**Required environment variables** (set on whatever process runs n8n — never hardcoded in the workflow file):
- `QUESTION_INGEST_BASE_URL` — base URL of the **development** app instance (e.g. `http://localhost:8080`, or `http://host.docker.internal:8181` when n8n runs in Docker and the app runs on the host). Never point this at production.
- `QUIZ_INGEST_API_KEY` — must match the app's own `quiz.ingest.api-key` / `QUIZ_INGEST_API_KEY` configuration exactly (see `QuizIngestApiKeyInterceptor`).

n8n blocks `$env` access in expressions by default; run n8n with
`N8N_BLOCK_ENV_ACCESS_IN_NODE=false` for these variables to resolve (this only
affects the local n8n instance's own expression evaluation, not the app).

## Running it (CLI, no UI needed)

```bash
docker volume create n8n-data   # persist so migrations only run once

docker run --rm -v n8n-data:/home/node/.n8n \
  -v "$(pwd)/n8n/workflows/question-ingestion-test-batch.json:/data/workflow.json:ro" \
  --entrypoint sh docker.n8n.io/n8nio/n8n:latest \
  -c "n8n import:workflow --input=/data/workflow.json"

docker run --rm -v n8n-data:/home/node/.n8n \
  -e QUESTION_INGEST_BASE_URL="http://host.docker.internal:8080" \
  -e QUIZ_INGEST_API_KEY="<same key the app is configured with>" \
  -e N8N_BLOCK_ENV_ACCESS_IN_NODE=false \
  --entrypoint sh docker.n8n.io/n8nio/n8n:latest \
  -c "n8n execute --id=question-ingestion-test-batch"
```

The execute command prints the full run result as JSON, including each
`Ingest Question` output item (`{id, status, source}` on success, or the
captured HTTP error on failure).

## workflows/question-generation-enum-test.json

The first real run of the large-scale question generation pipeline, scoped to
exactly one topic (`enum`) as a controlled first test. Uses the 3 new
read-only `/api/internal/**` endpoints added for this workflow
(`GenerationToolingController`): topic metadata, topic markdown content
(EN+TR), and existing question text (all statuses, for duplicate checking).

**Nodes (linear chain):**
1. Manual Trigger
2. `Topic Selection` (Code) — hand-curated list of topic slugs for this run (currently just `["enum"]`, never "all topics").
3. `Load Topic Content` (Code, uses `this.helpers.httpRequest`) — fetches metadata + EN + TR content per topic in one stage.
4. `Build Generation Spec` (Code) — deterministic: parses H2 headings (scope reference only, not a keyword gate), computes a content-depth bucket (`wc -l`-style line count → target question count, same buckets as the Faz 7 methodology), a code-heaviness signal (embed/fence count → type mix), a difficulty distribution from the topic's own baseline difficulty, and builds the full LLM prompt text (grounded in the real fetched lesson content).
5. `Generate Batch` — **HTTP Request node calling the OpenAI Chat Completions API** (`https://api.openai.com/v1/chat/completions`, body `{model, temperature, messages: [{role:"system",...}, {role:"user", content: $json.prompt}]}`). Authenticates via n8n's own credential store (`authentication: "predefinedCredentialType"`, `nodeCredentialType: "openAiApi"`, referencing the existing **"OpenAI account"** credential by id) — the API key itself is never written into the workflow file or read/printed by any tooling; n8n resolves it internally from its encrypted credential store at execution time. `model` defaults to `gpt-4o-mini` but can be overridden via `$env.OPENAI_MODEL`. (The provider was originally designed around Anthropic/Claude in Faz 146 — no usable `ANTHROPIC_API_KEY` was available in that sandbox, so the node was temporarily a Code-node stand-in; it was switched to a real OpenAI HTTP Request node once a working OpenAI credential was confirmed to already exist in the local n8n instance.)
6. `Parse Generated Questions` (Code) — parses the OpenAI response's `choices[0].message.content` (expected to be a raw JSON array string) into one item per question, carrying `topicSlug`/`language` forward.
7. `Validate Output` (Code) — **structural validation only** (required fields, option count, correct-answer-count per type, non-empty/non-duplicate option text, valid enum values). Deliberately does **not** reject a question for lacking H2-heading vocabulary overlap — content-fit is handled upstream by grounding the prompt in real lesson text, per the approved design.
8. `Duplicate Check` (Code, uses `this.helpers.httpRequest` against `/api/internal/questions/existing`) — normalized exact-match + Jaccard word-overlap (threshold 0.6), checked against both the real existing pool (all statuses) and other items in the same batch. No vector DB.
9. `Submit Valid Questions` (Code, uses `this.helpers.httpRequest`) — POSTs only items that passed both prior stages to `/api/internal/questions/ingest` (`source: "N8N"`, no `status` field, no retry logic). Non-qualifying items pass through tagged with a skip reason instead of being dropped.
10. `Record Results` (Code) — final summary (generated/validation-failed/deduped/submitted/failed counts + per-question detail), visible in the execution output.

**Known CLI limitation found while building this:** `n8n execute --id=...` does **not** honor a workflow's `pinData` — a pinned mock response is silently ignored and the real HTTP call is made instead. See `docs/known-constraints.md` ("Faz 146") for the full finding and the Code-node-stand-in workaround used above.

**First real run (Faz 146):** 6 questions (3 EN + 3 TR, grounded in `enum.md`'s `EnumSet`/`EnumMap`/`Singleton Pattern` sections) were generated (via the Code-node stand-in described above, no live LLM call), validated, deduped, and submitted — all landed as `status=PENDING_REVIEW`/`source=N8N` in the real dev DB, confirmed isolated from `/en/practice`, and confirmed visible in the real `/en/admin/questions` screen. Test data was cleaned up afterward.

**First real OpenAI run:** the `Generate Batch` node was switched to the real OpenAI HTTP Request node described above, referencing an existing local n8n credential named "OpenAI account" (`openAiApi` type; only its `id`/`name`/`type` were ever read, never the key itself). A small-batch run (`enum`, EN only, requested count 3) was executed with `n8n execute --id=...` and made a genuine, billed call to `gpt-4o-mini` (3117 prompt + 1332 completion = 4449 tokens). A bug in `Load Topic Content` (it rebuilt the item and dropped `onlyLanguage`/`overrideCount`) meant the requested count override didn't reach the prompt, so OpenAI generated 7 questions instead of 3, and a second bug (`Parse Generated Questions` reading `topicSlug`/`language` from the HTTP node's own output, which the real HTTP Request node replaces with the raw API response) broke `Duplicate Check` with a 404. Both were fixed in the workflow file (`Load Topic Content` now forwards the override fields; `Parse Generated Questions` recovers `topicSlug`/`language` via `$('Build Generation Spec').itemMatching(i)`), but **OpenAI was not called a second time** to avoid a second charge — the 3 questions actually submitted were taken directly from that one real response (validated and deduped with the exact same rules the pipeline nodes use, replicated in a local script) rather than regenerated. The fixed workflow is expected to produce exactly the requested count on the next real run. A larger, multi-topic batch has intentionally **not** been run — that requires separate explicit approval.

**Quality review and prompt improvement (no new OpenAI call made for this step):** the 3 submitted questions (ids 43/44/45, still `PENDING_REVIEW`) were reviewed for correctness, distractor quality, difficulty, and explanation depth. Id 43 ("What is an enum in Java?") was too trivial — pure definition recall with absurdly-wrong distractors. Ids 44 and 45 were technically solid (real API-behavior and concept-distinguishing questions with plausible distractors), but id 45's explanation only justified the correct options, never the false ones. The `buildPrompt()` function in `Build Generation Spec` was rewritten to address this directly:
- caps plain "What is X?" definition questions at one per batch, requiring the rest to test output prediction, API/method choice, distinguishing similar concepts, or a concrete usage scenario;
- requires distractors to reflect plausible misconceptions, not obviously-wrong filler;
- requires explanations to also address why the closest wrong option is wrong, not just restate the correct one;
- asks for varied question phrasing instead of repeating the same sentence pattern across a batch;
- explicitly tells the model to keep code only in `codeSnippet` and never repeat it as a fenced block inside `question` (the root cause of the id-44 rendering bug — see below).

The updated workflow was re-imported (`n8n import:workflow`, no `execute`) to confirm n8n accepts it; this makes no OpenAI call.

**Admin Question Review CODE_OUTPUT rendering fix:** the AI-generated code for id 44 was embedded both in `codeSnippet` (rendered correctly, highlighted) and, redundantly, as a fenced ` ```java ` block inside `question` (rendered as escaped plain text, showing the literal backticks). Fixed at the presentation layer only — `QuestionReviewView.questionDisplayText()` (new derived method, `src/main/java/com/cdurgun/learning/web/review/QuestionReviewView.java`) strips a redundant fenced block from the displayed question text whenever `codeSnippet` is present (which only ever happens for `CODE_OUTPUT`, per the ingestion API's own type rule), leaving `codeSnippet` as the single rendered source of the code. `admin/question-review.html` now calls `q.questionDisplayText()` instead of `q.question()`. The stored `question` column is untouched — no migration, no data mutation. SINGLE_CHOICE/MULTIPLE_CHOICE rendering (no `codeSnippet`) is unaffected. Verified against the real id-44 row in a live app instance.

**Second real OpenAI batch (5 requested, improved prompt):** with the target-count bug fixed, a `topicSlug=enum, overrideCount=5` run genuinely asked for and received exactly 5 questions from `gpt-4o-mini` (3473 prompt + 941 completion = 4414 tokens). Validate Output passed all 5; Duplicate Check correctly excluded one ("What is the main advantage of using an enum over string constants?") as a real 0.60 word-overlap near-duplicate of already-published question id 2. It also caught a **new bug**: because the CODE_OUTPUT prompt fix moved code out of `question` into `codeSnippet`, every CODE_OUTPUT question's `question` text is now the same generic sentence ("What will be the output of the following code?") — so the duplicate check, which only compared `question` text, wrongly flagged two *different* CODE_OUTPUT questions (an `ordinal()` one and a `valueOf()` one) as duplicates of each other. Fixed by making `Duplicate Check` compare `question + codeSnippet` together (`comparableText()`) instead of `question` alone — the existing-pool comparison is unaffected since `/api/internal/questions/existing` doesn't return `codeSnippet`. The n8n run had already submitted 3 questions (ids 46/47/48) before this was caught; rather than call OpenAI again, the wrongly-excluded 4th question was recovered by replaying the (now-fixed) validate+dedup logic locally against the one real API response already obtained, and submitted directly via the ingestion API (id 49). Net result: **4 of the 5 generated questions were submitted** (ids 46, 47, 48, 49, all `PENDING_REVIEW`/`source=OPENAI`); the 5th was correctly left out as a genuine near-duplicate, not resubmitted. All verified in the real dev DB and the real Admin Question Review screen, including that both new CODE_OUTPUT questions (46, 49) render their code once, cleanly, via the presentation fix above.

## Known limitation observed during testing

The ingestion API currently returns Spring Boot's default HTML error page
(not JSON) for `4xx` validation failures (e.g. an unknown `topicSlug`). n8n's
HTTP Request node still captures the full error text either way, so this
doesn't block the workflow, but a future phase could add a small
`@ExceptionHandler` to return a clean JSON error body — not done here since it
wasn't required for this phase's scope.
