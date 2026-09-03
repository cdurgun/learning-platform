-- Promotion-style migration linking EN jpa-auditing quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jpa-auditing')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What problem does JPA auditing (@CreatedDate/@LastModifiedDate) solve?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What problem does JPA auditing (@CreatedDate/@LastModifiedDate) solve?$$,
           NULL, NULL,
           $$It replaces manually written LocalDateTime.now() calls repeated in every service method that creates or updates an audited entity, which is easy to forget in even one place.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'jpa-auditing'
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
    ($$It replaces manually written LocalDateTime.now() calls repeated in every place that creates or updates an entity$$, TRUE, 0),
    ($$It automatically validates every entity's fields before saving$$, FALSE, 1),
    ($$It replaces the need for a primary key on audited entities$$, FALSE, 2),
    ($$It automatically translates entity field names into a different language$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jpa-auditing'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jpa-auditing')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is the timing difference between @CreatedDate and @LastModifiedDate?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What is the timing difference between @CreatedDate and @LastModifiedDate?$$,
           NULL, NULL,
           $$@CreatedDate is populated exactly once, at first persist, and never touched again; @LastModifiedDate is populated on that same insert and re-populated on every subsequent update.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'jpa-auditing'
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
    ($$There is no timing difference -- both fire on every save with an identical value$$, FALSE, 0),
    ($$@CreatedDate is populated exactly once at first persist and never touched again; @LastModifiedDate updates on every subsequent update too$$, TRUE, 1),
    ($$Both fields are populated exactly once, at first persist, and never updated afterward$$, FALSE, 2),
    ($$@LastModifiedDate is populated once at first persist; @CreatedDate updates on every subsequent save$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jpa-auditing'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jpa-auditing')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$An entity has @CreatedDate on a field, and @EntityListeners(AuditingEntityListener.class) on the class. No @Configuration class anywhere has @EnableJpaAuditing. What happens when a new instance is saved?$$
      AND code_snippet = $$@Entity
@EntityListeners(AuditingEntityListener.class)
class Question {
    @CreatedDate
    private LocalDateTime createdAt;
}
// No @EnableJpaAuditing anywhere in the application$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$An entity has @CreatedDate on a field, and @EntityListeners(AuditingEntityListener.class) on the class. No @Configuration class anywhere has @EnableJpaAuditing. What happens when a new instance is saved?$$,
           $$@Entity
@EntityListeners(AuditingEntityListener.class)
class Question {
    @CreatedDate
    private LocalDateTime createdAt;
}
// No @EnableJpaAuditing anywhere in the application$$, $$java$$,
           $$Missing @EnableJpaAuditing means the field is simply never populated, silently left null -- with no error pointing at what's missing.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'jpa-auditing'
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
    ($$createdAt is silently left null, with no error indicating what's missing$$, TRUE, 0),
    ($$createdAt is populated with the Unix epoch (1970-01-01) as a fallback default$$, FALSE, 1),
    ($$createdAt is populated correctly, since @EntityListeners alone is enough$$, FALSE, 2),
    ($$The application fails to start with a clear configuration error naming the missing annotation$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jpa-auditing'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jpa-auditing')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$How do @CreatedBy and @LastModifiedBy relate to @CreatedDate and @LastModifiedDate?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$How do @CreatedBy and @LastModifiedBy relate to @CreatedDate and @LastModifiedDate?$$,
           NULL, NULL,
           $$They work exactly like their date counterparts -- same listener, same lifecycle timing -- but capture the identity of whoever made the change instead of a timestamp.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'jpa-auditing'
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
    ($$They require a completely separate listener from AuditingEntityListener$$, FALSE, 0),
    ($$They only work on entities that also have a manually-set reviewedBy field$$, FALSE, 1),
    ($$They replace @CreatedDate/@LastModifiedDate entirely, rather than working alongside them$$, FALSE, 2),
    ($$They work exactly like their date counterparts, using the same listener and timing, but capture WHO made the change instead of WHEN$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jpa-auditing'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jpa-auditing')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Does Spring Data JPA have a built-in notion of "the current user" that @CreatedBy/@LastModifiedBy read from automatically?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Does Spring Data JPA have a built-in notion of "the current user" that @CreatedBy/@LastModifiedBy read from automatically?$$,
           NULL, NULL,
           $$No -- AuditorAware<T> is the interface an application must implement to supply that answer; Spring Data JPA has no built-in notion of a current user.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'jpa-auditing'
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
    ($$Yes -- it reads directly from Spring Security's SecurityContextHolder with zero configuration$$, FALSE, 0),
    ($$No -- AuditorAware<T> is an interface the application must implement to supply that answer$$, TRUE, 1),
    ($$Yes -- it always defaults to the string "system" unless explicitly overridden$$, FALSE, 2),
    ($$No -- @CreatedBy/@LastModifiedBy simply don't work unless Spring Security is on the classpath$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jpa-auditing'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jpa-auditing')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following correctly describe @MappedSuperclass? (Select all that apply)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe @MappedSuperclass? (Select all that apply)$$,
           NULL, NULL,
           $$@MappedSuperclass isn't itself an @Entity and has no table of its own -- its fields get copied into every entity extending it, avoiding repeating audit annotations on each one individually.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'jpa-auditing'
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
    ($$Only one entity in an application is allowed to extend a given @MappedSuperclass$$, FALSE, 0),
    ($$It isn't itself an @Entity and has no table of its own$$, TRUE, 1),
    ($$Its fields get copied into every entity that extends it, avoiding repeating them on each one$$, TRUE, 2),
    ($$It requires its own @Table annotation, just like a regular entity$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jpa-auditing'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: CODE_OUTPUT)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jpa-auditing')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$An entity is loaded, one unrelated field is reassigned to the exact same value it already had, and the transaction commits (triggering a save). Does @LastModifiedDate update?$$
      AND code_snippet = $$Question q = repository.findById(1L).get();
q.setTitle(q.getTitle()); // reassigned to the SAME value
// transaction commits, entity is saved$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$An entity is loaded, one unrelated field is reassigned to the exact same value it already had, and the transaction commits (triggering a save). Does @LastModifiedDate update?$$,
           $$Question q = repository.findById(1L).get();
q.setTitle(q.getTitle()); // reassigned to the SAME value
// transaction commits, entity is saved$$, $$java$$,
           $$Yes -- @LastModifiedDate updates on every save that reaches the database, the same way dirty checking writes any tracked change; it isn't selectively smart about which saves "really" changed something meaningful.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'jpa-auditing'
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
    ($$It throws an exception, since reassigning a field to its own value is not a valid operation$$, FALSE, 0),
    ($$It depends on whether the field has its own @Column(unique = true) constraint$$, FALSE, 1),
    ($$Yes -- @LastModifiedDate updates on every save that reaches the database, regardless of whether the value genuinely changed$$, TRUE, 2),
    ($$No -- Spring Data JPA detects the value is unchanged and skips updating @LastModifiedDate$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jpa-auditing'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
