-- Promotion-style migration linking EN entities-and-repositories quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'entities-and-repositories')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does @GeneratedValue(strategy = GenerationType.IDENTITY) actually do?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does @GeneratedValue(strategy = GenerationType.IDENTITY) actually do?$$,
           NULL, NULL,
           $$It delegates id generation to the database's own auto-increment mechanism.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'entities-and-repositories'
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
    ($$It delegates id generation to the database's own auto-increment mechanism$$, TRUE, 0),
    ($$It generates the id randomly in application memory before saving$$, FALSE, 1),
    ($$It requires the caller to supply the id manually before every save$$, FALSE, 2),
    ($$It disables id generation entirely, leaving the column null$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'entities-and-repositories'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'entities-and-repositories')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What does @Column(nullable = false, unique = true) actually produce?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What does @Column(nullable = false, unique = true) actually produce?$$,
           NULL, NULL,
           $$A real NOT NULL UNIQUE constraint enforced by the database itself, not just checked somewhere in Java.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'entities-and-repositories'
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
    ($$A runtime exception thrown by Hibernate before any SQL is generated at all$$, FALSE, 0),
    ($$A real NOT NULL UNIQUE constraint enforced by the database itself$$, TRUE, 1),
    ($$A validation check that only runs inside the Java application, never touching the database schema$$, FALSE, 2),
    ($$A comment in the generated SQL with no actual enforcement$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'entities-and-repositories'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'entities-and-repositories')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$An entity's difficulty field is mapped without any @Enumerated annotation at all. A new constant DRAFT is later inserted in the MIDDLE of the enum's existing constants. What happens to existing rows?$$
      AND code_snippet = $$enum Difficulty { BEGINNER, INTERMEDIATE, ADVANCED }
// later becomes:
enum Difficulty { BEGINNER, DRAFT, INTERMEDIATE, ADVANCED }

@Entity
class Topic {
    private Difficulty difficulty; // no @Enumerated at all
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$An entity's difficulty field is mapped without any @Enumerated annotation at all. A new constant DRAFT is later inserted in the MIDDLE of the enum's existing constants. What happens to existing rows?$$,
           $$enum Difficulty { BEGINNER, INTERMEDIATE, ADVANCED }
// later becomes:
enum Difficulty { BEGINNER, DRAFT, INTERMEDIATE, ADVANCED }

@Entity
class Topic {
    private Difficulty difficulty; // no @Enumerated at all
}$$, $$java$$,
           $$Omitting @Enumerated defaults to ORDINAL, storing the constant's numeric position -- inserting a new constant in the middle shifts every subsequent position, silently corrupting existing rows' meaning.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'entities-and-repositories'
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
    ($$Existing rows' stored ordinal values now silently point at different constants than the ones they were actually saved with$$, TRUE, 0),
    ($$Hibernate automatically migrates every existing row's stored value to match the new ordinal positions$$, FALSE, 1),
    ($$Nothing changes -- Hibernate stores the constant's name by default, unaffected by reordering$$, FALSE, 2),
    ($$The application fails to start with a mapping validation error$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'entities-and-repositories'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'entities-and-repositories')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Two brand-new, unsaved Topic entities are compared with an equals() implementation based purely on `id != null && id.equals(other.id)`. What is the result of comparing them?$$
      AND code_snippet = $$Topic a = new Topic(); // id is null, not yet saved
Topic b = new Topic(); // id is null, not yet saved

System.out.println(a.equals(b));$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Two brand-new, unsaved Topic entities are compared with an equals() implementation based purely on `id != null && id.equals(other.id)`. What is the result of comparing them?$$,
           $$Topic a = new Topic(); // id is null, not yet saved
Topic b = new Topic(); // id is null, not yet saved

System.out.println(a.equals(b));$$, $$java$$,
           $$Since id is null on both, the id != null check fails, so equals() correctly returns false -- two unsaved entities are never considered equal under this convention.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'entities-and-repositories'
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
    ($$false -- the id != null check fails for both, so they're never considered equal while unsaved$$, TRUE, 0),
    ($$It throws a NullPointerException, since id is null$$, FALSE, 1),
    ($$It depends on which fields besides id happen to match$$, FALSE, 2),
    ($$true -- both have id == null, so they're considered equal$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'entities-and-repositories'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'entities-and-repositories')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is the specific risk of returning a @Entity directly from a @RestController method?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What is the specific risk of returning a @Entity directly from a @RestController method?$$,
           NULL, NULL,
           $$It couples the API's public JSON shape to the database mapping itself, and risks serializing a lazy field outside a transaction (LazyInitializationException).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'entities-and-repositories'
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
    ($$It couples the API's public JSON shape to the database mapping, and risks a LazyInitializationException on a lazy field$$, TRUE, 0),
    ($$It has no real downside -- entities and DTOs are functionally interchangeable in a REST API$$, FALSE, 1),
    ($$Jackson is fundamentally unable to serialize any @Entity-annotated class$$, FALSE, 2),
    ($$It automatically exposes the entity's password field, regardless of whether one exists$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'entities-and-repositories'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'entities-and-repositories')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following correctly describe what each tier of Repository -> CrudRepository -> PagingAndSortingRepository -> JpaRepository contributes? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe what each tier of Repository -> CrudRepository -> PagingAndSortingRepository -> JpaRepository contributes? (Select all that apply)$$,
           NULL, NULL,
           $$Repository is a marker interface with no methods; CrudRepository adds save/findById/findAll/deleteById; PagingAndSortingRepository adds findAll(Sort)/findAll(Pageable); JpaRepository adds JPA-specific extras like flush()/saveAndFlush().$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'entities-and-repositories'
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
    ($$JpaRepository is the root of the chain, with CrudRepository extending it$$, FALSE, 0),
    ($$Repository is a marker interface contributing no methods at all, just letting Spring Data recognize it$$, TRUE, 1),
    ($$PagingAndSortingRepository adds findAll(Sort) and findAll(Pageable)$$, TRUE, 2),
    ($$CrudRepository adds flush() and saveAndFlush(...)$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'entities-and-repositories'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'entities-and-repositories')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why does a JPA entity need a no-args constructor?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Why does a JPA entity need a no-args constructor?$$,
           NULL, NULL,
           $$Hibernate builds entity instances via reflection, before any field is populated, so it needs a constructor callable with nothing.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'entities-and-repositories'
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
    ($$Because JPQL queries can only construct objects using a no-args constructor$$, FALSE, 0),
    ($$It isn't actually required -- it's only a stylistic convention with no functional purpose$$, FALSE, 1),
    ($$Because Hibernate builds entity instances via reflection, before any field is populated$$, TRUE, 2),
    ($$Because Spring Boot requires every class on the classpath to have one, regardless of purpose$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'entities-and-repositories'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
