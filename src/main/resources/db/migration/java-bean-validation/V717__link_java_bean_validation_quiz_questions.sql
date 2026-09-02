-- Promotion-style migration linking EN java-bean-validation quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 EN questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'java-bean-validation')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which statement correctly describes the difference between @Positive and @PositiveOrZero?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Which statement correctly describes the difference between @Positive and @PositiveOrZero?$$,
           NULL, NULL,
           $$@Positive is strict and rejects zero; @PositiveOrZero accepts zero.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'java-bean-validation'
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
    ($$They are functionally identical$$, FALSE, 0),
    ($$@Positive rejects zero (strict); @PositiveOrZero accepts zero$$, TRUE, 1),
    ($$@PositiveOrZero is stricter than @Positive$$, FALSE, 2),
    ($$@Positive only works on BigDecimal, @PositiveOrZero only on int$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'java-bean-validation'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'java-bean-validation')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Does @Future accept the exact current moment ("now") as valid?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Does @Future accept the exact current moment ("now") as valid?$$,
           NULL, NULL,
           $$@Future is strict -- "now" itself fails it; @FutureOrPresent would be needed to allow it.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'java-bean-validation'
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
    ($$Yes, because @Future only checks the date part, not the time$$, FALSE, 0),
    ($$It depends on which date/time type is used$$, FALSE, 1),
    ($$No -- @Future is strict, "now" itself fails it; @FutureOrPresent would be needed for that$$, TRUE, 2),
    ($$Yes, "now" is always considered in the future by a few milliseconds$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'java-bean-validation'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'java-bean-validation')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A developer writes the following constraint on a BigDecimal field. What happens?$$
      AND code_snippet = $$record Price(@DecimalMin(0.01) BigDecimal amount) {}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$A developer writes the following constraint on a BigDecimal field. What happens?$$,
           $$record Price(@DecimalMin(0.01) BigDecimal amount) {}$$, $$java$$,
           $$@DecimalMin's value must be a String, not a numeric literal -- this fails to compile.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'java-bean-validation'
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
    ($$It compiles and works exactly like @DecimalMin("0.01")$$, FALSE, 0),
    ($$It fails to compile -- @DecimalMin's value must be a String, not a numeric literal$$, TRUE, 1),
    ($$It compiles but always rejects every value due to floating-point rounding$$, FALSE, 2),
    ($$It compiles and silently ignores the bound entirely$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'java-bean-validation'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'java-bean-validation')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What is the purpose of writing message = "{user.age.tooYoung}" instead of a literal string on a constraint?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What is the purpose of writing message = "{user.age.tooYoung}" instead of a literal string on a constraint?$$,
           NULL, NULL,
           $$It resolves the message from a messages.properties file for the active locale, instead of a single hardcoded string.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'java-bean-validation'
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
    ($$It disables the constraint entirely, only logging the key$$, FALSE, 0),
    ($$It forces the constraint to run twice, once per locale$$, FALSE, 1),
    ($$It has no effect -- both forms behave identically$$, FALSE, 2),
    ($$It resolves the message from a messages.properties file for the active locale, instead of a single hardcoded string$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'java-bean-validation'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'java-bean-validation')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why is @ValidDateRange placed on the record itself (class/type level) rather than on checkIn or checkOut individually?$$
      AND code_snippet = $$@Target(ElementType.TYPE)
@Constraint(validatedBy = DateRangeValidator.class)
@interface ValidDateRange { String message() default "Invalid date range"; }

class DateRangeValidator implements ConstraintValidator<ValidDateRange, BookingRequest> {
    public boolean isValid(BookingRequest b, ConstraintValidatorContext ctx) {
        return b.checkOut().isAfter(b.checkIn());
    }
}

@ValidDateRange
record BookingRequest(LocalDate checkIn, LocalDate checkOut) {}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Why is @ValidDateRange placed on the record itself (class/type level) rather than on checkIn or checkOut individually?$$,
           $$@Target(ElementType.TYPE)
@Constraint(validatedBy = DateRangeValidator.class)
@interface ValidDateRange { String message() default "Invalid date range"; }

class DateRangeValidator implements ConstraintValidator<ValidDateRange, BookingRequest> {
    public boolean isValid(BookingRequest b, ConstraintValidatorContext ctx) {
        return b.checkOut().isAfter(b.checkIn());
    }
}

@ValidDateRange
record BookingRequest(LocalDate checkIn, LocalDate checkOut) {}$$, $$java$$,
           $$The rule needs to see both fields at once -- no single-field annotation could express "checkOut must be after checkIn".$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'java-bean-validation'
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
    ($$Because Bean Validation doesn't allow annotations on record components at all$$, FALSE, 0),
    ($$Because the rule needs to see both fields at once -- no single-field annotation could express "checkOut must be after checkIn"$$, TRUE, 1),
    ($$Because class-level annotations run before field-level ones, which is required here$$, FALSE, 2),
    ($$It's an arbitrary style choice with no functional reason$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'java-bean-validation'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'java-bean-validation')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$By convention, what should a custom ConstraintValidator's isValid(...) method return when the value being validated is null?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$By convention, what should a custom ConstraintValidator's isValid(...) method return when the value being validated is null?$$,
           NULL, NULL,
           $$true -- it lets a separate @NotNull constraint be the one responsible for reporting a missing value.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'java-bean-validation'
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
    ($$It should throw a NullPointerException to fail fast$$, FALSE, 0),
    ($$It doesn't matter, since Bean Validation never calls a validator with a null value$$, FALSE, 1),
    ($$false, so no field is ever accidentally left unvalidated$$, FALSE, 2),
    ($$true -- it lets a separate @NotNull constraint be the one responsible for reporting a missing value$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'java-bean-validation'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'java-bean-validation')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following are true about validation groups? (Select all that apply)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about validation groups? (Select all that apply)$$,
           NULL, NULL,
           $$A group-tagged constraint only runs for that group; an untagged constraint is silently skipped when validating against a specific group; the same DTO can enforce different constraints per group. Groups are NOT a general-purpose recommended mechanism for every DTO.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'java-bean-validation'
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
    ($$A constraint tagged groups = OnUpdate.class only runs when validating against that specific group$$, TRUE, 0),
    ($$A constraint with no groups attribute at all is silently skipped when validating against a specific group$$, TRUE, 1),
    ($$Validation groups are the general-purpose, recommended way to validate every DTO in the application$$, FALSE, 2),
    ($$The same DTO can enforce different constraints depending on which group it's validated against$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'java-bean-validation'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
