-- Promotion-style migration linking EN testing-spring-data-jpa quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'testing-spring-data-jpa')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A test writes when(repository.findBySlug("records")).thenReturn(...). If the REAL findBySlug method were misspelled or filtered on the wrong column entirely, would this test catch it?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$A test writes when(repository.findBySlug("records")).thenReturn(...). If the REAL findBySlug method were misspelled or filtered on the wrong column entirely, would this test catch it?$$,
           NULL, NULL,
           $$No -- the mock never asks Spring Data JPA to parse the real method into a real query, and never touches a database; it only verifies the mock's own configured behavior.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'testing-spring-data-jpa'
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
    ($$Yes -- Mockito always validates a mocked method's name against the real repository interface$$, FALSE, 0),
    ($$No -- the mock only verifies its own configured behavior, never asking Spring Data JPA to parse or run the real query$$, TRUE, 1),
    ($$It depends on whether the method is a derived query or a custom @Query$$, FALSE, 2),
    ($$Yes, but only if the test is also annotated with @DataJpaTest$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'testing-spring-data-jpa'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'testing-spring-data-jpa')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does @DataJpaTest load, and what happens to each test method's changes afterward?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does @DataJpaTest load, and what happens to each test method's changes afterward?$$,
           NULL, NULL,
           $$It loads only the persistence layer (entities, repositories, a real database connection), and each test method runs inside its own transaction, automatically rolled back afterward.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'testing-spring-data-jpa'
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
    ($$It loads nothing at all until @Autowired is added to a field$$, FALSE, 0),
    ($$It loads the entire application, including controllers and services; changes persist across tests$$, FALSE, 1),
    ($$It loads only the persistence layer (entities, repositories, a real database connection), with each test's transaction rolled back afterward$$, TRUE, 2),
    ($$It loads only controllers, mocking every repository automatically$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'testing-spring-data-jpa'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'testing-spring-data-jpa')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why should test data for a @DataJpaTest be set up with TestEntityManager rather than the repository method the test is actually verifying?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Why should test data for a @DataJpaTest be set up with TestEntityManager rather than the repository method the test is actually verifying?$$,
           NULL, NULL,
           $$Getting data into the database with the very repository method the test is trying to verify could hide a bug in that method behind its own setup.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'testing-spring-data-jpa'
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
    ($$Because repository methods cannot be called at all before @DataJpaTest finishes initializing$$, FALSE, 0),
    ($$Because TestEntityManager is required to make @DataJpaTest compile at all$$, FALSE, 1),
    ($$Because TestEntityManager is faster than any repository method by a significant margin$$, FALSE, 2),
    ($$Because using the method under test for its own setup could hide a bug in that method behind its own setup$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'testing-spring-data-jpa'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'testing-spring-data-jpa')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A test saves CodeExamples for two different topics, deliberately out of sort order, then calls findByTopicIdOrderBySortOrderAsc(topicId) and asserts only two results come back AND that they're in ascending order. Why is this a meaningfully stronger test than saving just one row and asserting it comes back?$$
      AND code_snippet = $$entityManager.persist(new CodeExample(topicId, 2));
entityManager.persist(new CodeExample(topicId, 1));
entityManager.persist(new CodeExample(otherTopicId, 1));

List<CodeExample> result = repository.findByTopicIdOrderBySortOrderAsc(topicId);
assertThat(result).hasSize(2);
assertThat(result.get(0).getSortOrder()).isEqualTo(1);$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A test saves CodeExamples for two different topics, deliberately out of sort order, then calls findByTopicIdOrderBySortOrderAsc(topicId) and asserts only two results come back AND that they're in ascending order. Why is this a meaningfully stronger test than saving just one row and asserting it comes back?$$,
           $$entityManager.persist(new CodeExample(topicId, 2));
entityManager.persist(new CodeExample(topicId, 1));
entityManager.persist(new CodeExample(otherTopicId, 1));

List<CodeExample> result = repository.findByTopicIdOrderBySortOrderAsc(topicId);
assertThat(result).hasSize(2);
assertThat(result.get(0).getSortOrder()).isEqualTo(1);$$, $$java$$,
           $$It actually proves both real filtering (only topicId's rows, excluding otherTopicId's) and real ordering (sortOrder 1 before 2), which a single-row test could accidentally pass without proving either.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'testing-spring-data-jpa'
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
    ($$It proves real filtering (excluding otherTopicId) AND real ordering (sortOrder 1 before 2) at once, not just "returns whatever was saved"$$, TRUE, 0),
    ($$It only proves filtering works -- ordering still requires a completely separate test method$$, FALSE, 1),
    ($$It's meaningfully weaker, since persisting three rows risks a unique-constraint violation$$, FALSE, 2),
    ($$It proves nothing more -- a single-row test would have caught the exact same bugs$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'testing-spring-data-jpa'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'testing-spring-data-jpa')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A @DataJpaTest calls a custom @Query method using join fetch, and the JPQL has a typo in the joined property path. What would the test most likely reveal?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A @DataJpaTest calls a custom @Query method using join fetch, and the JPQL has a typo in the joined property path. What would the test most likely reveal?$$,
           NULL, NULL,
           $$The test would fail immediately -- either with no result at all, or a genuine LazyInitializationException the moment the relationship is accessed outside the still-open test transaction.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'testing-spring-data-jpa'
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
    ($$Nothing -- a typo in JPQL is silently ignored by Hibernate and treated as a no-op$$, FALSE, 0),
    ($$The test fails immediately -- either with no result, or a genuine LazyInitializationException when the relationship is accessed$$, TRUE, 1),
    ($$The application fails to compile, since JPQL is checked by the Java compiler$$, FALSE, 2),
    ($$The test passes, since @DataJpaTest doesn't actually execute a query's JPQL text$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'testing-spring-data-jpa'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'testing-spring-data-jpa')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following correctly describe the trade-off of @DataJpaTest's default embedded test database? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe the trade-off of @DataJpaTest's default embedded test database? (Select all that apply)$$,
           NULL, NULL,
           $$An embedded database is fast and needs no setup, but a query relying on PostgreSQL-specific behavior (like a native RANDOM() query) can pass against the embedded substitute and still fail against the real thing.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'testing-spring-data-jpa'
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
    ($$@DataJpaTest never uses an embedded database by default -- that behavior must always be explicitly enabled$$, FALSE, 0),
    ($$It's fast and needs no setup, unlike pointing tests at a real PostgreSQL instance$$, TRUE, 1),
    ($$A query relying on PostgreSQL-specific behavior can pass against it and still fail against real PostgreSQL$$, TRUE, 2),
    ($$It behaves identically to PostgreSQL for every possible query, including native ones$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'testing-spring-data-jpa'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: CODE_OUTPUT)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'testing-spring-data-jpa')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does AutoConfigureTestDatabase.Replace.NONE accomplish in this test setup?$$
      AND code_snippet = $$@Testcontainers
@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class RealDatabaseTest {
    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16");

    @DynamicPropertySource
    static void props(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", postgres::getJdbcUrl);
    }
}$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$What does AutoConfigureTestDatabase.Replace.NONE accomplish in this test setup?$$,
           $$@Testcontainers
@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class RealDatabaseTest {
    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16");

    @DynamicPropertySource
    static void props(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", postgres::getJdbcUrl);
    }
}$$, $$java$$,
           $$It stops @DataJpaTest from overriding the DataSource with its own embedded default, so the real, disposable PostgreSQL container started by @Container/@DynamicPropertySource is actually used instead.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'testing-spring-data-jpa'
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
    ($$It forces @DataJpaTest to always use an embedded database, ignoring @DynamicPropertySource$$, FALSE, 0),
    ($$It has no actual effect -- @DataJpaTest never replaces the DataSource by default in the first place$$, FALSE, 1),
    ($$It stops @DataJpaTest from overriding the DataSource with its own embedded default, letting the real Testcontainers Postgres be used$$, TRUE, 2),
    ($$It disables Testcontainers entirely, falling back to the embedded database despite @Container being present$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'testing-spring-data-jpa'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
