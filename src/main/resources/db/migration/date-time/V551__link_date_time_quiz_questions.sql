-- Promotion-style migration linking EN Date & Time API quiz questions to the
-- topic's fixed quiz created in date-time/V550 -- same NOT EXISTS/ON
-- CONFLICT DO NOTHING pattern used by every prior quiz-link migration in
-- this project. All 7 EN questions from question-promotion/V549
-- (hand-authored and self-reviewed -- no n8n, no OpenAI, no AI Judge). No
-- selection/omission -- the entire EN batch is linked.

-- Question 1/7 (Pair 1 EN, quiz position 1)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'date-time')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$A LocalDateTime instance holds the value '2026-03-15T15:00'. What time zone does this represent?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$A LocalDateTime instance holds the value '2026-03-15T15:00'. What time zone does this represent?$$, NULL, NULL,
           $$LocalDateTime carries no time zone information at all -- a LocalDateTime that says '15:00' has no idea whether that's Istanbul or New York. To tie a moment to a time zone, ZonedDateTime or Instant is needed instead.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'date-time'
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
    ($$None -- LocalDateTime carries no time zone information at all.$$, TRUE, 0),
    ($$The JVM's default system time zone.$$, FALSE, 1),
    ($$UTC.$$, FALSE, 2),
    ($$It depends on where LocalDateTime.now() was called from.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'date-time'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 EN, quiz position 2)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'date-time')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$According to the lesson, which type is the best fit for storing a timestamp (like "when did this event happen") in a database?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$According to the lesson, which type is the best fit for storing a timestamp (like "when did this event happen") in a database?$$, NULL, NULL,
           $$Storing a timestamp in a database usually means reaching for Instant (or a fixed-offset OffsetDateTime) -- it represents one unambiguous universal moment, independent of any time zone. The user's time zone is applied only when displaying that moment.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'date-time'
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
    ($$Instant (or a fixed-offset OffsetDateTime) -- it represents one unambiguous universal moment, independent of any time zone.$$, TRUE, 0),
    ($$LocalDateTime, since it's the most commonly used java.time class.$$, FALSE, 1),
    ($$ZonedDateTime, since it already carries a time zone.$$, FALSE, 2),
    ($$Date, since it's guaranteed to be timezone-agnostic.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'date-time'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 EN, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'date-time')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What will this code print?$$
      AND code_snippet = $$ZonedDateTime istanbul = ZonedDateTime.of(2026, 6, 1, 15, 0, 0, 0, ZoneId.of("Europe/Istanbul"));
ZonedDateTime newYork = istanbul.withZoneSameInstant(ZoneId.of("America/New_York"));
System.out.println(istanbul.equals(newYork));$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$What will this code print?$$,
           $$ZonedDateTime istanbul = ZonedDateTime.of(2026, 6, 1, 15, 0, 0, 0, ZoneId.of("Europe/Istanbul"));
ZonedDateTime newYork = istanbul.withZoneSameInstant(ZoneId.of("America/New_York"));
System.out.println(istanbul.equals(newYork));$$, $$java$$,
           $$Calling equals() on a ZonedDateTime compares both the instant and the time zone. withZoneSameInstant preserves the instant but changes the zone, so even though istanbul and newYork represent the exact same universal moment, equals() returns false -- isEqual(...) would be needed to check only the instant.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'date-time'
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
    ($$true$$, FALSE, 0),
    ($$false$$, TRUE, 1),
    ($$It throws an exception.$$, FALSE, 2),
    ($$It depends on the current system default time zone.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'date-time'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 EN, quiz position 4, type: MULTIPLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'date-time')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Which of the following statements about Duration, Period, and ChronoUnit are true?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about Duration, Period, and ChronoUnit are true?$$, NULL, NULL,
           $$Duration is time-based (hours/minutes/seconds, usable with Instant/LocalTime/LocalDateTime); Period is calendar-based (years/months/days, only between LocalDate values); ChronoUnit.DAYS.between(...) returns the total gap as a single raw number, unlike Period which breaks it into separate pieces. Period cannot express hour/minute precision -- that's what Duration is for.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'date-time'
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
    ($$Duration represents a time-based amount (hours/minutes/seconds) and can be used between Instant or LocalDateTime values.$$, TRUE, 0),
    ($$Period represents a calendar-based amount (years/months/days) and can only be used between LocalDate values.$$, TRUE, 1),
    ($$ChronoUnit.DAYS.between(...) returns the total day gap as a single number, unlike Period which breaks it into separate year/month/day pieces.$$, TRUE, 2),
    ($$Period can express an hour/minute-precision gap just as accurately as Duration.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'date-time'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 EN, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'date-time')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What will this code print?$$
      AND code_snippet = $$LocalDate date = LocalDate.of(2026, 1, 31);
LocalDate result = date.plusMonths(1);
System.out.println(result);$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$What will this code print?$$,
           $$LocalDate date = LocalDate.of(2026, 1, 31);
LocalDate result = date.plusMonths(1);
System.out.println(result);$$, $$java$$,
           $$plusMonths(1) handles month-overflow intelligently -- January 31 plus one month doesn't land on the nonexistent "February 31," it clamps to that month's last valid day. 2026 is not a leap year, so February has 28 days, giving 2026-02-28.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'date-time'
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
    ($$2026-02-28$$, TRUE, 0),
    ($$2026-03-03$$, FALSE, 1),
    ($$2026-02-31$$, FALSE, 2),
    ($$It throws a DateTimeException.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'date-time'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 EN, quiz position 6)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'date-time')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$Why should a single SimpleDateFormat instance not be shared across multiple threads?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Why should a single SimpleDateFormat instance not be shared across multiple threads?$$, NULL, NULL,
           $$SimpleDateFormat is not thread-safe -- multiple threads sharing the same instance can produce corrupted results. DateTimeFormatter is immutable and can be safely shared across threads instead.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'date-time'
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
    ($$SimpleDateFormat is not thread-safe -- concurrent use by multiple threads can produce corrupted results.$$, TRUE, 0),
    ($$It's deprecated and throws UnsupportedOperationException when called from more than one thread.$$, FALSE, 1),
    ($$Each thread needs its own time zone, and SimpleDateFormat can only hold one.$$, FALSE, 2),
    ($$SimpleDateFormat objects are immutable, so sharing one wastes memory unnecessarily.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'date-time'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 EN, quiz position 7, type: CODE_OUTPUT)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'date-time')
      AND language = 'en'
      AND status = 'PUBLISHED'
      AND question = $$What will this code print?$$
      AND code_snippet = $$LocalDate d1 = LocalDate.of(2026, 1, 31);
LocalDate d2 = d1.plusDays(1);
System.out.println(d1);$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$What will this code print?$$,
           $$LocalDate d1 = LocalDate.of(2026, 1, 31);
LocalDate d2 = d1.plusDays(1);
System.out.println(d1);$$, $$java$$,
           $$Every plus/minus call in java.time preserves immutability and returns a new object -- it never mutates the original. So d1 is unchanged after plusDays(1) is called, and still prints 2026-01-31.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'date-time'
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
    ($$2026-01-31$$, TRUE, 0),
    ($$2026-02-01$$, FALSE, 1),
    ($$null$$, FALSE, 2),
    ($$It throws an exception.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'date-time'
  AND quiz.language = 'en'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
