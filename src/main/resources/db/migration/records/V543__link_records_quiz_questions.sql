-- Promotion-style migration linking EN Record quiz questions to the topic's
-- fixed quiz created in records/V542 -- same pattern as arrays/V523,
-- scanner/V527, wrapper-classes/V531, file-reading/V535, and file-writing/
-- V539 (WITH ... RETURNING id + NOT EXISTS dedup + ON CONFLICT DO NOTHING
-- on the link insert).
--
-- All 6 EN questions from question-promotion/V541 (hand-authored and
-- self-reviewed directly in a Claude Code session -- no n8n, no OpenAI, no
-- AI Judge). No selection/omission -- the entire EN batch is linked.
--
-- Duplicate-safety: each block first checks whether an equivalent question
-- row (same topic_id + language + exact question text) already exists, and
-- only INSERTs when it doesn't -- portable to a fresh database (V541 will
-- already have created these rows, so this migration's own fallback INSERT
-- branch is a safe no-op that only supplies the quiz_question_link). The
-- quiz_question_link insert carries ON CONFLICT DO NOTHING as a second
-- safety net (UNIQUE(quiz_id, question_id), UNIQUE(quiz_id, position) from
-- V290).

-- Question 1/6 (Pair 1 EN, quiz position 1)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'records')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Inside a compact constructor, which of the following is true?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Inside a compact constructor, which of the following is true?$$, NULL, NULL,
           $$You can reassign a parameter inside a compact constructor (e.g. name = name.trim();) -- the compiler uses the updated value in its implicit field assignment. You cannot assign directly to the field itself (this.name = ...); the compiler rejects this because the implicit assignment will already happen for you.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'records'
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
    ($$You can reassign a parameter (e.g. name = name.trim();), but you cannot assign directly to the field (this.name = ...).$$, TRUE, 0),
    ($$You must repeat the full parameter list, just like in the explicit canonical constructor.$$, FALSE, 1),
    ($$You can assign directly to the field (this.name = ...) as usual.$$, FALSE, 2),
    ($$Parameter reassignment inside a compact constructor is not allowed.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'records'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (Pair 2 EN, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'records')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What will this code print?$$
      AND code_snippet = $$record Point(int x, int y) {}
record Coordinate(int x, int y) {}
Point p = new Point(1, 2);
Coordinate c = new Coordinate(1, 2);
System.out.println(p.equals(c));$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What will this code print?$$,
           $$record Point(int x, int y) {}
record Coordinate(int x, int y) {}
Point p = new Point(1, 2);
Coordinate c = new Coordinate(1, 2);
System.out.println(p.equals(c));$$, $$java$$,
           $$A record's generated equals() first checks whether both instances are of exactly the same class. Point and Coordinate are different record types, so p.equals(c) returns false even though their components are identical.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'records'
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
    ($$true$$, FALSE, 0),
    ($$false$$, TRUE, 1),
    ($$It throws a ClassCastException.$$, FALSE, 2),
    ($$It throws an exception because Point and Coordinate can't be compared.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'records'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'records')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What will this code print?$$
      AND code_snippet = $$record Measurement(double reading) {}
Measurement m1 = new Measurement(Double.NaN);
Measurement m2 = new Measurement(Double.NaN);
System.out.println(m1.equals(m2));$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$What will this code print?$$,
           $$record Measurement(double reading) {}
Measurement m1 = new Measurement(Double.NaN);
Measurement m2 = new Measurement(Double.NaN);
System.out.println(m1.equals(m2));$$, $$java$$,
           $$A record's generated equals() compares double/float components using Double.compare()/Float.compare() semantics, not bare ==. Under Double.compare() semantics, NaN is equal to itself, so this prints true -- even though Double.NaN == Double.NaN with primitive == would be false.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'records'
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
    ($$true$$, TRUE, 0),
    ($$false$$, FALSE, 1),
    ($$It throws an exception.$$, FALSE, 2),
    ($$The result is not guaranteed to be consistent across runs.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'records'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (Pair 4 EN, quiz position 4)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'records')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$For record Range(int min, int max) {}, what does new Range(1, 10).toString() return?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$For record Range(int min, int max) {}, what does new Range(1, 10).toString() return?$$, NULL, NULL,
           $$A record's generated toString() lists the simple class name and all components in order, in the form RecordName[component1=value1, component2=value2].$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'records'
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
    ($$Range[min=1, max=10]$$, TRUE, 0),
    ($$Range(min=1, max=10)$$, FALSE, 1),
    ($${min=1, max=10}$$, FALSE, 2),
    ($$Range@<hashcode>$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'records'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (Pair 5 EN, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'records')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about records are true?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about records are true?$$, NULL, NULL,
           $$A record can implement any number of interfaces, and additional constructors must delegate to the canonical constructor via this(...). Static fields and methods are allowed. However, an extra instance field outside the component list is a compile error -- a record's state consists entirely of its component list.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'records'
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
    ($$A record can implement interfaces.$$, TRUE, 0),
    ($$A record can declare additional constructors, as long as they call the canonical constructor via this(...).$$, TRUE, 1),
    ($$You can add an extra instance field to a record's body that is not part of the component list.$$, FALSE, 2),
    ($$Static fields and methods are allowed in a record's body.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'records'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (Pair 6 EN, quiz position 6)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'records')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following correctly accesses the x component of a Point record instance p, where record Point(int x, int y) {}?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly accesses the x component of a Point record instance p, where record Point(int x, int y) {}?$$, NULL, NULL,
           $$Record accessors use the component name directly rather than the Java Bean get prefix, so the correct call is p.x(). The field itself is private, so p.x does not compile from outside the record.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'records'
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
    ($$p.getX()$$, FALSE, 0),
    ($$p.x()$$, TRUE, 1),
    ($$p.x$$, FALSE, 2),
    ($$It cannot be accessed from outside the record; x is only usable inside the record's own methods.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'records'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
