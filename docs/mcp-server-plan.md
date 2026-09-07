# LearnForgeX MCP Server — Implementation Plan

**Status: PLAN ONLY — NO IMPLEMENTATION**
**Current phase: Phase 0 COMPLETE**
**Next approved action: Phase 1 only, after explicit user approval**

This document is the single, authoritative, consolidated plan for the LearnForgeX MCP
(Model Context Protocol) server. It supersedes all earlier draft plans discussed in
chat. Another session should be able to implement Phase 1 from this document alone,
without reconstructing the architectural reasoning from conversation history.

---

## 1. Overview

**Purpose.** Expose LearnForgeX's curriculum, lesson content, and question/quiz pool to
an MCP-capable AI client, so an assistant can help author, review, and reason about
content using the platform's real data instead of guessing at it.

**Phase 1 scope, precisely:**
- Primary MCP client: **Claude Code / Claude Desktop**, run as a local subprocess.
- Database: **local development PostgreSQL only** (the same instance
  `application-dev.yml` already points at).
- Capability: **read-only**. No create/update/delete/publish/reject tool of any kind.
- Transport: **stdio only**. The server is launched as a subprocess by the MCP client
  and communicates over stdin/stdout JSON-RPC.

**Explicitly out of scope for Phase 1:**
- No production database, and no configuration path that could reach one (no `mcp-prod`
  profile is created).
- No remote/network-facing transport (no Streamable HTTP, no new port, no new API key
  or session-based auth mechanism). That is a distinct, later phase (Phase 7) requiring
  its own authorization design.
- No write operations of any kind.

---

## 2. Architecture

```
Claude Code / Claude Desktop
        │
        ▼
     MCP STDIO   (JSON-RPC over stdin/stdout, in-process subprocess)
        │
        ▼
McpStdioServerApplication   (com.cdurgun.learning.mcp)
        │
        ▼
     MCP Tools   (@McpTool methods — thin adapters only)
        │
        ▼
     Services    (existing services reused + two new thin services)
        │
        ▼
   Repositories  (existing Spring Data JPA repositories, unchanged)
        │
        ▼
  Local PostgreSQL (dev instance only)
```

**Hard architectural rule: MCP → Service → Repository.**

- MCP tools must **never** `@Autowire`/inject a repository, and must never call one
  directly.
- MCP tools must **never** contain business logic (what counts as "published", how a
  quiz orders its questions, which statuses exist, etc.). All such logic stays in the
  service layer, exactly where it already lives today.
- Each `@McpTool` method is a thin adapter with exactly four responsibilities, in order:
  1. Parse and validate input (e.g. reject an unrecognized `language`/`status` string).
  2. Call **exactly one** service method.
  3. Map the service's return value to a plain Java record for JSON serialization.
  4. Catch exceptions at this boundary and translate them into a safe MCP error result
     (see section 9) — never let an internal exception/stack trace reach the client.

---

## 3. Spring Application Context

**Design: a second, lean entry point in the same Maven module** — not a separate
module, not a hand-assembled `ApplicationContext`.

```java
@SpringBootApplication(
    scanBasePackages = {
        "com.cdurgun.learning.domain",
        "com.cdurgun.learning.repository",
        "com.cdurgun.learning.service",
        "com.cdurgun.learning.mcp"
    },
    excludeFilters = @ComponentScan.Filter(
        type = FilterType.ASSIGNABLE_TYPE,
        classes = {
            UserRegistrationService.class,
            CustomUserDetailsService.class,
            PdfExportService.class
        }
    ),
    exclude = {
        SecurityAutoConfiguration.class,
        WebMvcAutoConfiguration.class,
        ThymeleafAutoConfiguration.class
    }
)
public class McpStdioServerApplication {
    public static void main(String[] args) {
        new SpringApplicationBuilder(McpStdioServerApplication.class)
            .web(WebApplicationType.NONE)
            .run(args);
    }
}
```

**Why the three `excludeFilters` classes are necessary (verified, not hypothetical):**
scanning the whole `service` package as-is would break context startup, because:
- `UserRegistrationService` requires a `PasswordEncoder` bean, which only exists as a
  `@Bean` inside `SecurityConfig` — excluded here.
- `PdfExportService` requires Thymeleaf's `ITemplateEngine` — also excluded here.
- `CustomUserDetailsService` would instantiate without error (it only needs
  `UserRepository`), but it is irrelevant to MCP and is excluded to keep the context to
  what's actually used.

All other classes in `service/` (`NavigationService`, `QuizService`, `ContentResolver`,
`CodeExampleResolver`, `MarkdownService`, `QuestionIngestService`,
`QuestionReviewService`, `QuestionPublishAuditService`, `QuizDefinitionService`,
`QuizNavigationService`, `QuestionScorer`, `GenerationToolingService`) depend only on
repositories and `@Value` properties, and scan cleanly.

**Other required settings, all confined to a new `mcp` Spring profile:**
- `WebApplicationType.NONE` — no embedded Tomcat.
- Security, WebMvc, and Thymeleaf autoconfiguration excluded, as above — no filter
  chain, no controllers, no view engine are ever initialized.
- **JPA/Hibernate/DataSource remain fully active** — this is the entire point: the MCP
  server needs a real, working persistence layer to reuse the existing
  service/repository code against the same local dev Postgres instance already
  configured in `application-dev.yml`. This process is not a mock or a stub.
- `spring.flyway.enabled=false` — the main web application already owns and applies all
  migrations; there is no reason for a second process to also run Flyway on every stdio
  launch.
- `spring.ai.mcp.server.stdio=true` (see section 4).
- No `mcp-prod` profile exists or is planned for Phase 1 — this is what structurally
  guarantees the MCP process can never be pointed at production data.

**Why manual bean wiring (e.g. a hand-built `AnnotationConfigApplicationContext`
registering hand-picked `@Configuration` classes) was rejected:** it would achieve the
same practical outcome (no web/security beans) at higher long-term cost — every future
service addition would need a manual wiring decision instead of falling under ordinary
component-scan rules, and it departs from the idiomatic Spring Boot mechanics every
other part of this codebase already uses. `scanBasePackages` + `excludeFilters` +
`exclude` is standard, well-understood Spring Boot configuration, achieves the identical
result, and costs one class instead of a parallel bean-registration scheme.

---

## 4. MCP SDK / Dependency

**Verified decision, not an assumption:**

- `org.springframework.ai:spring-ai-bom:2.0.1` — imported in `dependencyManagement`.
- `org.springframework.ai:spring-ai-starter-mcp-server` — version inherited from the
  BOM (resolves to `2.0.1`). This is the **stdio-only** Spring AI MCP server starter
  (there is a separate `-webmvc` starter for HTTP, intentionally not used in Phase 1).

Project baseline: Spring Boot `4.1.0`, Java `21`, Maven.

**How this was verified (actually performed on this machine, not merely researched):**
- `mvn dependency:get` successfully resolved both
  `org.springframework.ai:spring-ai-starter-mcp-server:2.0.1` and
  `org.springframework.ai:spring-ai-bom:2.0.1` from Maven Central.
- A **scratch copy** of `pom.xml` (the real project `pom.xml` was never modified) was
  patched with the BOM + starter and run through `mvn dependency:tree` against this
  project's actual, existing dependency set. Result: `BUILD SUCCESS`, no version
  conflicts. The tree confirms the starter pulls in the same underlying official MCP
  Java SDK transitively (`io.modelcontextprotocol.sdk:mcp-json-jackson3:2.0.0`) and
  aligns cleanly with this project's Jackson 3.x (from `spring-boot-starter-jackson`,
  part of the Spring Boot 4.1 baseline).
- `@McpTool` and `@McpToolParam` were verified directly against the resolved JAR's
  bytecode (`javap` on the decompiled class files from
  `spring-ai-mcp-annotations-2.0.1.jar`), not from documentation alone:
  - `@McpTool(name, description, title, generateOutputSchema, annotations, metaProvider)`
  - `@McpToolParam(required, description)`
  - `spring.ai.mcp.server.stdio` was confirmed as a real
    `@ConfigurationProperties("spring.ai.mcp.server")` boolean field
    (`McpServerProperties.isStdio()/setStdio()`).
  - `AbstractMcpToolMethodCallback.convertValueToCallToolResult(Object)` confirms a tool
    method can return a **plain Java record/POJO** directly — it is converted to the
    MCP `CallToolResult` automatically. No hand-written JSON-RPC/schema code is needed
    for Phase 1's tools.

---

## 5. Phase 1 Tool Surface

Exactly five tools. All read-only. No exceptions.

### 1. `list_curriculum`
- **Purpose:** browse the full published course → category → topic tree in one call —
  the natural first call to find a topic slug.
- **Input:** `language` (`en` | `tr`).
- **Output:** nested list of courses → categories → topics (slug, title, difficulty,
  estimatedMinutes).
- **Service:** `NavigationService.buildNavigation(Language)` — **existing, unchanged**.
- **Security/data-boundary notes:** published-only scope inherited as-is from the
  existing method; no new exposure.

### 2. `get_topic`
- **Purpose:** full detail on one lesson, including its raw lesson body, so an assistant
  can ground question/quiz work in the actual content.
- **Input:** `topicSlug`, `language`.
- **Output:** title, summary, published flag, difficulty, estimatedMinutes, category/course
  slugs, and the raw markdown body.
- **Service:** `ContentQueryService.getTopicDetail(slug, language)` — **new, thin**
  (see section 6).
- **Security/data-boundary notes:** returns lesson content only — no author/internal
  metadata beyond what's already public-facing on the site.

### 3. `list_questions`
- **Purpose:** inspect the question pool for a topic, across **any** status — the core
  "what already exists / what's pending review" use case.
- **Input:** `topicSlug`, `language`, `status` (optional: `DRAFT`|`PENDING_REVIEW`|`PUBLISHED`|`REJECTED`).
- **Output:** list of questions — id, type, difficulty, status, source, question text,
  has-code flag.
- **Service:** `QuestionQueryService.listQuestions(slug, language, status?)` — **new,
  thin** (see section 6).
- **Security/data-boundary notes:** deliberately not restricted to `PUBLISHED` (unlike
  the public pool queries) — this is a trusted local authoring tool, the same posture as
  the existing admin review screen. `reviewedBy`/`reviewedAt` are excluded from output
  (section 8).

### 4. `get_question`
- **Purpose:** full detail on one question, including options and which is correct —
  needed once `list_questions` has narrowed to a specific question (e.g. duplicate/
  quality review).
- **Input:** `questionId`.
- **Output:** question text, explanation, code snippet (if any), all options with
  `correct` flags, status, source.
- **Service:** `QuestionQueryService.getQuestion(id)` — **new, thin**.
- **Security/data-boundary notes:** same as above — `reviewedBy`/`reviewedAt` excluded.

### 5. `get_fixed_quiz`
- **Purpose:** inspect a topic's curated/fixed quiz, in order, for reviewing quiz
  composition — including correct answers (an authoring view, not the student-facing
  pre-submit view).
- **Input:** `topicSlug`, `language`, `quizSlug`.
- **Output:** quiz title, pass threshold, ordered list of questions with options and
  `correct` flags.
- **Service:** `QuizService.loadQuizDetail(Long quizId)` — **existing service, one new
  additive method** (see section 7). Quiz resolution (topicSlug+language+quizSlug → id)
  reuses `QuizService.resolveQuiz`, which already exists.

### Explicitly deferred from Phase 1 (not forgotten — intentionally out of scope)

- `search_topics` — would require one new repository query method; no concrete need yet.
- Separate `list_courses` / `list_categories` / `list_topics` tools — already covered by
  `list_curriculum`.
- Code-example tools (`list_code_examples`, `get_code_example`).
- `question_pool_stats` / coverage analysis — real business logic deserving its own
  design pass, not a thin wrapper; an assistant can approximate today via
  `list_questions` client-side.
- Duplicate-question detection.
- Quiz Area / `QuizDefinition` management tools (a separate concept from the fixed
  quiz).
- Any write/update/delete/publish/reject tool.
- Any tool touching `User`/`Role`.
- Remote HTTP transport of any kind.

---

## 6. Service Layer

**Existing services reused, unchanged:**
- `NavigationService` — curriculum tree.
- `QuizService` — fixed quiz resolution/detail (one additive method, section 7).
- `ContentResolver` — raw lesson markdown lookup by slug/language.

**New services (both thin, both additive-only):**
- `ContentQueryService` — assembles topic metadata (`TopicRepository.findBySlugWithCategoryAndCourse`),
  translation (`TopicTranslationRepository.findByTopicIdAndLanguage`), and raw markdown
  (`ContentResolver.resolve`) into one read model for `get_topic`.
- `QuestionQueryService` — assembles question + options
  (`QuestionRepository.findByTopicIdAndLanguage` — already returns all statuses — plus
  `QuestionOptionRepository`) into read models for `list_questions`/`get_question`, with
  an optional in-memory status filter. No new repository query methods are required.

**Why these two live in `service/`, not under `mcp/`:** they express genuine, reusable
read logic (what "topic detail" or "question detail" means as a combined view) — the
same kind of responsibility every other class in `service/` already has. Placing them
under `mcp/` would put business logic in the adapter layer, violating the rule in
section 2, and would make them harder to reuse later (e.g. by a future admin UI) for no
benefit.

---

## 7. QuizService Adjustment

**Verified finding:** `QuizService.loadQuiz(quizId)` returns `QuizQuestionView`/
`QuizOptionView`, which **deliberately omit `correct` flags** (per the existing
Javadoc: "client'a is_correct hiçbir zaman submit öncesi gönderilmez" — this is the
student-facing pre-submit view). `findQuiz`/`resolveQuiz` return `QuizSummary(id, slug,
title)`, with no `passThreshold`. Neither existing method can serve an authoring tool
that needs to see correct answers and the pass threshold.

**Planned change — the only planned change to `QuizService`:**

Add `QuizService.loadQuizDetail(Long quizId)`:
- **Additive only** — no existing method's signature or behavior changes.
- Reuses the class's existing private `loadOptionsByQuestionId` helper and the same
  `quizRepository`/`quizQuestionRepository`/`questionOptionRepository` already injected
  into `QuizService` — no new repository methods unless implementation proves one is
  genuinely required (not expected).
- Returns a new response shape (e.g. `QuizDetailView`) carrying: quiz title,
  `passThreshold`, and the ordered question list with options **including** `correct`
  flags.
- This is the only structural change proposed to any existing class in this entire
  plan. Every other piece of reused code (`NavigationService`, `ContentResolver`, all
  repositories) is used exactly as it exists today.

---

## 8. Data and Security Boundaries

- **No `User`/`Role`/authentication data of any kind.** No Phase 1 service or tool
  references `UserRepository`, `CustomUserDetailsService`, or `UserRegistrationService`
  (the latter two are explicitly excluded from the MCP Spring context, section 3).
- **No passwords, password hashes, or session information** ever cross the MCP
  boundary — structurally impossible, since `User`/`Role` are never touched.
- **`reviewedBy` and `reviewedAt` are excluded** from `list_questions`/`get_question`
  output — the one field on `Question` that could carry a reviewer's identity.
- **No JPA entities cross the MCP boundary.** Every tool returns a plain Java record
  built by its service method — never an entity or a Hibernate proxy. This also avoids
  lazy-loading exceptions and circular-reference serialization.
- **No raw SQL, table names, or column names** appear in any tool output — only slugs
  and numeric ids that are already public-facing elsewhere in the application (topic
  slugs in URLs, question/quiz ids in the existing admin review screen).
- **Local development database only.** The `mcp` Spring profile only ever carries dev
  datasource credentials. No `mcp-prod` profile is created in this plan.

---

## 9. Error Handling

| Situation | Required behavior |
|---|---|
| Unknown topic/question/quiz (bad slug/id) | Service returns empty/`null`; tool catches this and returns an MCP error result (`isError: true`) with a plain message (e.g. `"No topic found with slug 'foo'"`) — never a stack trace |
| Invalid parameter (bad `language`/`status` value, non-positive id) | Validated at the tool boundary before calling the service; `isError: true`, naming the bad parameter and the allowed values |
| Database access failure mid-session | Caught by a shared error-handling helper used by all tool classes; full detail logged to file/stderr; client receives a generic `isError: true` ("database access failed") message. If Postgres is unavailable at process startup, the context fails fast with a clear stderr message rather than serving a half-working server |
| Any other unexpected exception | Same shared catch-all: full detail logged server-side only; generic safe message returned to the client |

**Hard rule:** no MCP-facing error message may ever contain a stack trace, SQL text, a
connection string, credentials, or internal entity field names. All such detail is
confined to stderr/file logging (see section 10).

---

## 10. STDIO and Logging Requirements

This is a **hard protocol requirement**, not a style preference:

- stdin/stdout are reserved exclusively for MCP JSON-RPC traffic.
- Application logs must **never** be written to stdout.
- All logging must go to stderr and/or a file.
- `System.out.println` (or any direct stdout write) must not be used anywhere in the
  MCP process's code path.
- The `mcp` Spring profile needs its own Logback configuration if the default
  configuration would otherwise write to stdout — this must be confirmed and, if
  necessary, overridden before any tool code is added (Phase 1 acceptance criteria,
  section 12).

A single stray console line would silently corrupt every subsequent tool call — this is
the single most important correctness requirement for the whole server, independent of
which tools exist.

---

## 11. Testing Strategy

- **Unit tests** for `ContentQueryService` and `QuestionQueryService`, mocking
  repositories — same JUnit 5 + Mockito conventions as existing `service/*Test.java`
  files.
- **Unit tests** for each `@McpTool` method, mocking the service it calls, covering both
  the success path and the error paths from section 9.
- **Spring context integration test**: `@SpringBootTest(webEnvironment = WebEnvironment.NONE)`
  booting `McpStdioServerApplication`'s actual context against `application-test.yml`,
  confirming the narrowed component scan loads cleanly and (once added) that all tools
  are registered.
- **MCP Inspector protocol verification**: `npx @modelcontextprotocol/inspector`
  launching the real stdio command and calling `tools/list`/`tools/call` interactively —
  actual protocol behavior must be verified, never assumed.
- **Live Claude Code verification**: register the server with Claude Code pointed at the
  local dev DB and manually exercise each tool against real seeded data.
- **Existing application regression tests**: confirm `LearningPlatformApplicationTests`
  (the default web app's context-load smoke test) is unaffected, since
  `McpStdioServerApplication` is a separate main class never auto-discovered by Spring
  Boot Test. `mvn clean test` in the user's own environment remains the authoritative
  check for the whole suite.

---

## 12. Phased Implementation Plan

### Phase 0 — Verification — **COMPLETE**
SDK/dependency verification, API verification (bytecode-level), and codebase inspection
(`QuizService`, `service/` package dependencies) all performed and recorded in sections
3, 4, and 7 above.

### Phase 1 — MCP Skeleton ONLY
- Add the verified BOM (`spring-ai-bom:2.0.1`) + `spring-ai-starter-mcp-server`
  dependency to `pom.xml`.
- Add the `mcp` Spring profile (stdio enabled, Flyway disabled).
- Add logging configuration ensuring stdout stays clean (section 10).
- Add `McpStdioServerApplication` with the narrowed component scan and the three
  verified exclude filters (section 3), `WebApplicationType.NONE`.
- **No MCP tools. No `ContentQueryService`. No `QuestionQueryService`. No `QuizService`
  changes.**

**Phase 1 acceptance criteria:**
- The application starts successfully under the `mcp` profile.
- The Spring context loads without error.
- MCP stdio initialization completes (a basic client can perform the MCP `initialize`
  handshake).
- stdout remains clean — verified by inspecting actual process output, not assumed.
- Zero MCP tools are registered (expected and correct at this stage).
- The existing web application (`LearningPlatformApplication`, all controllers/tests)
  remains completely unaffected.
- Relevant tests pass.

**STOP after Phase 1. Do not proceed to Phase 2 without explicit user approval.**

### Phase 2 — Content tools/services
- `ContentQueryService`.
- `list_curriculum`, `get_topic`.
- Related unit tests.
- **STOP and wait for approval.**

### Phase 3 — Question inspection
- `QuestionQueryService`.
- `list_questions`, `get_question`.
- Related unit tests.
- **STOP and wait for approval.**

### Phase 4 — Fixed quiz inspection
- `QuizService.loadQuizDetail(Long quizId)`.
- `get_fixed_quiz`.
- Related unit tests.
- **STOP and wait for approval.**

### Phase 5 — Full verification
- Spring context integration tests.
- MCP Inspector protocol verification.
- Live Claude Code verification against real local dev data.
- Full regression test run.

### Phase 6 — Documentation
- Update `CLAUDE.md` (new architecture bullet: `mcp` package, profile, logging
  requirement, milestone line).
- Keep this document (`docs/mcp-server-plan.md`) current as the implementation
  proceeds.
- Update `docs/known-constraints.md` if any new environment-specific finding surfaces
  during implementation (e.g. Maven Central availability changing again).
- Add a `docs/phase-log.md` entry after implementation, per the project's standing
  convention.

### Phase 7 — Future remote transport (explicitly separate from Phase 1)
- Streamable HTTP transport (the `-webmvc` Spring AI MCP starter).
- A real authentication/authorization design for a network-facing endpoint.
- Remote deployment considerations.
- Reassessment of which tools (if any) should be exposed remotely, and at what
  permission level.
- Write operations are considered **only after** a proper authorization model exists —
  never before, and never as part of Phase 1–6.

---

## 13. Implementation Order

1. Confirm (already done, section 4) that the BOM + starter resolve; add them to the
   real `pom.xml`.
2. Add the `mcp` profile properties and logging configuration.
3. Add `McpStdioServerApplication` (Phase 1). Verify it boots cleanly with zero tools.
   **Stop for approval.**
4. Add `ContentQueryService` + `list_curriculum`/`get_topic` (Phase 2). Test.
   **Stop for approval.**
5. Add `QuestionQueryService` + `list_questions`/`get_question` (Phase 3). Test.
   **Stop for approval.**
6. Add `QuizService.loadQuizDetail` + `get_fixed_quiz` (Phase 4). Test.
   **Stop for approval.**
7. Full verification pass: integration tests, MCP Inspector, live Claude Code session,
   regression suite (Phase 5).
8. Documentation updates (Phase 6).
9. Only after all of the above, and only on separate explicit request: begin designing
   Phase 7 (remote transport).

---

## 14. Risks and Open Questions

(Only genuinely open items remain here — SDK version, dependency resolution, and
`QuizService` compatibility have already been verified, sections 4 and 7.)

1. **Environment drift.** This session found Maven Central reachable, contradicting a
   stale note in `docs/known-constraints.md` from an earlier session. Network
   reachability should be re-checked at the start of actual Phase 1 implementation,
   since the project's own documented convention is that sandbox conditions can change
   between sessions.
2. **`@McpTool` return-type/serialization edge cases** beyond the basic record-return
   case (verified) — e.g. how `Optional`, `null`, or collections are handled exactly —
   should be confirmed against the starter's behavior during Phase 1's skeleton work,
   before Phase 2's tools depend on it.
3. **Whether `list_curriculum`'s published-only scope remains acceptable** once real
   usage begins (an authoring assistant might eventually want draft/unpublished topics
   too) — deliberately left as-is for Phase 1 (a pure passthrough of an existing
   method); revisit only if real usage shows it's a limitation.

---

## 15. Files Expected to Change

**Expected to be created (across Phases 1–4, not now):**
- `pom.xml` — dependency + BOM addition only (Phase 1).
- `src/main/java/com/cdurgun/learning/mcp/McpStdioServerApplication.java` (Phase 1)
- `src/main/java/com/cdurgun/learning/mcp/tool/*.java` (Phases 2–4)
- `src/main/java/com/cdurgun/learning/mcp/dto/*.java` (Phases 2–4)
- `src/main/java/com/cdurgun/learning/service/ContentQueryService.java` (Phase 2)
- `src/main/java/com/cdurgun/learning/service/QuestionQueryService.java` (Phase 3)
- A logging configuration file for the `mcp` profile, if the default configuration
  would otherwise log to stdout (Phase 1).
- `application-mcp.yml` or an equivalent profile-scoped configuration block (Phase 1).
- Corresponding test files under `src/test/java/...` for every class above.

**May be modified (across Phases 1–6, not now):**
- `src/main/java/com/cdurgun/learning/service/QuizService.java` — one additive method
  only (`loadQuizDetail`), Phase 4.
- `CLAUDE.md` — one new architecture bullet + milestone line, Phase 6.
- `docs/known-constraints.md` — only if a new environment finding surfaces, Phase 6.
- `docs/phase-log.md` — new phase-table row(s), Phase 6.
- `docs/mcp-server-plan.md` (this file) — kept current as implementation proceeds.

**Must NOT be modified during Phase 1 (or at all, in this plan):**
- Any existing controller, `SecurityConfig`, `WebConfig`, or any file under `web/`.
- Any existing entity, repository, or migration.
- `UserRegistrationService.java`, `CustomUserDetailsService.java`,
  `PdfExportService.java` — referenced only via exclude filters, never edited.
- Any file outside `pom.xml`/`mcp` package/the two new services/`QuizService`/the
  documentation files listed above.
- No database migration is created or planned anywhere in this document.

---

## 16. Approval Gates

Each phase in section 12 requires **separate, explicit user approval** before work on
the next phase begins. Completing a phase's acceptance criteria is not itself approval
to proceed — the user must explicitly say so. This applies in order to Phases 1 → 2 →
3 → 4 → 5 → 6, and Phase 7 additionally requires a distinct, separate planning
conversation before any implementation, since it introduces a new transport and a new
authorization model not covered by this document.
