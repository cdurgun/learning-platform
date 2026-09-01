-- Promotion batch
-- Topic: date-time (language: en x7, tr x7)
-- Generated: 2026-09-01 (this migration file's authoring date)
--
-- Like question-promotion/V545 (reflection), V541 (records), these 14
-- questions were NOT produced by the n8n generation pipeline, NOT judged by
-- the AI Judge, and NOT ingested via /api/internal/questions/ingest -- per
-- explicit user request, they were hand-authored and independently
-- self-reviewed directly inside a Claude Code session, grounded strictly in
-- content/en/date-time.md and content/tr/date-time.md.
--
-- Strict 50/50 EN/TR split (7+7) organized as 7 CONCEPT PAIRS -- each EN
-- question has a TR counterpart testing the exact same Date & Time API
-- concept, independently authored (different values/scenarios/regions,
-- different question framing) rather than a translation. The 7 concepts:
-- LocalDateTime carries no time zone information, Instant as the right
-- type for database timestamp storage, ZonedDateTime.equals() comparing the
-- time zone too, the Duration/Period/ChronoUnit triad, plusMonths()
-- overflow clamping, SimpleDateFormat's lack of thread-safety, and
-- immutability (plus/minus never mutates the original).
--
-- source = 'CLAUDE' / reviewed_by = 'claude-code@anthropic.com' / status =
-- 'PUBLISHED' directly -- same documentation convention as prior manual
-- batches. topic_id resolved by Topic.slug; question_option rows reference
-- the newly generated id via a WITH ... RETURNING id CTE.
--
-- Duplicate-promotion safety: N/A -- this batch was never ingested into
-- development, so no dev ids exist for these 14 questions at all.

-- Pair 1 / EN (SINGLE_CHOICE, BEGINNER) -- LocalDateTime carries no time zone
WITH new_question_en1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$A LocalDateTime instance holds the value '2026-03-15T15:00'. What time zone does this represent?$$, NULL, NULL,
           $$LocalDateTime carries no time zone information at all -- a LocalDateTime that says '15:00' has no idea whether that's Istanbul or New York. To tie a moment to a time zone, ZonedDateTime or Instant is needed instead.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'date-time'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$None -- LocalDateTime carries no time zone information at all.$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$The JVM's default system time zone.$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$UTC.$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$It depends on where LocalDateTime.now() was called from.$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER) -- same concept, independent value/phrasing
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir LocalDateTime nesnesi '2026-03-15T15:00' değerini tutuyor. Bu değer hangi zaman diliminde ifade edilmiştir?$$, NULL, NULL,
           $$LocalDateTime hiçbir zaman dilimi bilgisi taşımaz -- '15:00' diyen bir LocalDateTime'ın bu değerin İstanbul mu yoksa New York mu olduğuna dair hiçbir fikri yoktur. Bir anı bir zaman dilimine bağlamak için ZonedDateTime veya Instant kullanılmalıdır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'date-time'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hiçbiri -- LocalDateTime hiçbir zaman dilimi bilgisi taşımaz.$$, TRUE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$JVM'in varsayılan sistem zaman dilimi.$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$UTC.$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$LocalDateTime.now() çağrıldığı yere bağlıdır.$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, INTERMEDIATE) -- Instant for database timestamp storage
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$According to the lesson, which type is the best fit for storing a timestamp (like "when did this event happen") in a database?$$, NULL, NULL,
           $$Storing a timestamp in a database usually means reaching for Instant (or a fixed-offset OffsetDateTime) -- it represents one unambiguous universal moment, independent of any time zone. The user's time zone is applied only when displaying that moment.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'date-time'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Instant (or a fixed-offset OffsetDateTime) -- it represents one unambiguous universal moment, independent of any time zone.$$, TRUE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$LocalDateTime, since it's the most commonly used java.time class.$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$ZonedDateTime, since it already carries a time zone.$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Date, since it's guaranteed to be timezone-agnostic.$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, INTERMEDIATE) -- same guidance, log-entry scenario
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Derse göre, bir log kaydının "gerçekte ne zaman gerçekleştiği" bilgisini veritabanında saklamak için en uygun tip hangisidir?$$, NULL, NULL,
           $$Bir zaman damgasını veritabanında saklamak genellikle Instant (ya da sabit offsetli bir OffsetDateTime) kullanmak anlamına gelir -- herhangi bir zaman diliminden bağımsız, tek ve belirsizliğe yer bırakmayan evrensel bir anı temsil eder. Kullanıcının zaman dilimi yalnızca bu an gösterilirken uygulanır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'date-time'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Instant (ya da sabit offsetli bir OffsetDateTime) -- herhangi bir zaman diliminden bağımsız, tek ve belirsizliğe yer bırakmayan evrensel bir anı temsil eder.$$, TRUE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$LocalDateTime, çünkü en sık kullanılan java.time sınıfıdır.$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$ZonedDateTime, çünkü zaten bir zaman dilimi taşır.$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Date, çünkü zaman diliminden bağımsız olduğu garantidir.$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, ADVANCED) -- ZonedDateTime.equals() compares zone too
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What will this code print?$$,
           $$ZonedDateTime istanbul = ZonedDateTime.of(2026, 6, 1, 15, 0, 0, 0, ZoneId.of("Europe/Istanbul"));
ZonedDateTime newYork = istanbul.withZoneSameInstant(ZoneId.of("America/New_York"));
System.out.println(istanbul.equals(newYork));$$, $$java$$,
           $$Calling equals() on a ZonedDateTime compares both the instant and the time zone. withZoneSameInstant preserves the instant but changes the zone, so even though istanbul and newYork represent the exact same universal moment, equals() returns false -- isEqual(...) would be needed to check only the instant.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'date-time'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$true$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$false$$, TRUE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$It throws an exception.$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$It depends on the current system default time zone.$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, ADVANCED) -- same mechanic, Tokyo/Istanbul instead of Istanbul/New York
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$ZonedDateTime tokyo = ZonedDateTime.of(2026, 6, 1, 9, 0, 0, 0, ZoneId.of("Asia/Tokyo"));
ZonedDateTime istanbul = tokyo.withZoneSameInstant(ZoneId.of("Europe/Istanbul"));
System.out.println(tokyo.equals(istanbul));$$, $$java$$,
           $$ZonedDateTime üzerinde equals() çağırmak hem anı hem de zaman dilimini karşılaştırır. withZoneSameInstant, anı korur ama zaman dilimini değiştirir -- tokyo ve istanbul aynı evrensel anı temsil etse bile equals() false döner; yalnızca anı karşılaştırmak için isEqual(...) kullanılmalıdır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'date-time'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$true$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$false$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Bir istisna fırlatır.$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Sistemin varsayılan zaman dilimine bağlıdır.$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (MULTIPLE_CHOICE, INTERMEDIATE) -- Duration/Period/ChronoUnit triad
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about Duration, Period, and ChronoUnit are true?$$, NULL, NULL,
           $$Duration is time-based (hours/minutes/seconds, usable with Instant/LocalTime/LocalDateTime); Period is calendar-based (years/months/days, only between LocalDate values); ChronoUnit.DAYS.between(...) returns the total gap as a single raw number, unlike Period which breaks it into separate pieces. Period cannot express hour/minute precision -- that's what Duration is for.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'date-time'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Duration represents a time-based amount (hours/minutes/seconds) and can be used between Instant or LocalDateTime values.$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Period represents a calendar-based amount (years/months/days) and can only be used between LocalDate values.$$, TRUE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$ChronoUnit.DAYS.between(...) returns the total day gap as a single number, unlike Period which breaks it into separate year/month/day pieces.$$, TRUE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Period can express an hour/minute-precision gap just as accurately as Duration.$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (MULTIPLE_CHOICE, INTERMEDIATE) -- same facts reordered, false option inverted-subject
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Duration, Period ve ChronoUnit hakkında aşağıdaki ifadelerden hangileri doğrudur?$$, NULL, NULL,
           $$Period, yalnızca LocalDate değerleri arasında kullanılabilen takvim tabanlı (yıl/ay/gün) bir miktarı temsil eder; Duration, Instant veya LocalDateTime değerleri arasında kullanılabilen zaman tabanlı (saat/dakika/saniye) bir miktarı temsil eder; ChronoUnit.DAYS.between(...), Period'un aksine toplam gün farkını tek bir sayı olarak döner. Saat/dakika hassasiyeti gerektiren bir hesaplama için Period değil Duration kullanılmalıdır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'date-time'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Period, yalnızca LocalDate değerleri arasında kullanılabilen, takvim tabanlı (yıl/ay/gün) bir miktarı temsil eder.$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$ChronoUnit.DAYS.between(...), Period'un aksine, toplam gün farkını tek bir sayı olarak döner.$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Duration, Instant veya LocalDateTime değerleri arasında kullanılabilen zaman tabanlı (saat/dakika/saniye) bir miktarı temsil eder.$$, TRUE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Duration, saat/dakika hassasiyetinde bir farkı Period kadar doğru ifade edemez.$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE) -- plusMonths() overflow clamping
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What will this code print?$$,
           $$LocalDate date = LocalDate.of(2026, 1, 31);
LocalDate result = date.plusMonths(1);
System.out.println(result);$$, $$java$$,
           $$plusMonths(1) handles month-overflow intelligently -- January 31 plus one month doesn't land on the nonexistent "February 31," it clamps to that month's last valid day. 2026 is not a leap year, so February has 28 days, giving 2026-02-28.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'date-time'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$2026-02-28$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$2026-03-03$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$2026-02-31$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$It throws a DateTimeException.$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE) -- same clamping mechanic, March 31 + 1 month
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$LocalDate tarih = LocalDate.of(2026, 3, 31);
LocalDate sonuc = tarih.plusMonths(1);
System.out.println(sonuc);$$, $$java$$,
           $$plusMonths(1), ay taşmasını akıllıca yönetir -- 31 Mart artı bir ay, var olmayan "31 Nisan"a düşmez, o ayın son geçerli gününe (30) sabitlenir. Nisan ayı 30 gün çektiği için sonuç 2026-04-30 olur.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'date-time'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$2026-04-30$$, TRUE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$2026-05-01$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$2026-04-31$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Bir DateTimeException fırlatır.$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE) -- SimpleDateFormat not thread-safe
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why should a single SimpleDateFormat instance not be shared across multiple threads?$$, NULL, NULL,
           $$SimpleDateFormat is not thread-safe -- multiple threads sharing the same instance can produce corrupted results. DateTimeFormatter is immutable and can be safely shared across threads instead.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'date-time'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$SimpleDateFormat is not thread-safe -- concurrent use by multiple threads can produce corrupted results.$$, TRUE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$It's deprecated and throws UnsupportedOperationException when called from more than one thread.$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Each thread needs its own time zone, and SimpleDateFormat can only hold one.$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$SimpleDateFormat objects are immutable, so sharing one wastes memory unnecessarily.$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE) -- same fact, independently phrased stem
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$SimpleDateFormat'ın tek bir örneğinin birden fazla thread arasında paylaşılması neden önerilmez?$$, NULL, NULL,
           $$SimpleDateFormat thread-safe değildir -- aynı örneğin birden fazla thread tarafından eşzamanlı kullanılması bozuk (corrupted) sonuçlar üretebilir. DateTimeFormatter ise immutable olduğu için thread'ler arasında güvenle paylaşılabilir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'date-time'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$SimpleDateFormat thread-safe değildir -- eşzamanlı kullanım bozuk (corrupted) sonuçlar üretebilir.$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Deprecated olduğu için birden fazla thread'den çağrıldığında UnsupportedOperationException fırlatır.$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Her thread'in kendi zaman dilimine ihtiyacı vardır ve SimpleDateFormat yalnızca birini tutabilir.$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$SimpleDateFormat nesneleri immutable olduğu için paylaşmak gereksiz bellek harcar.$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (CODE_OUTPUT, BEGINNER) -- immutability (plus/minus never mutates the original)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What will this code print?$$,
           $$LocalDate d1 = LocalDate.of(2026, 1, 31);
LocalDate d2 = d1.plusDays(1);
System.out.println(d1);$$, $$java$$,
           $$Every plus/minus call in java.time preserves immutability and returns a new object -- it never mutates the original. So d1 is unchanged after plusDays(1) is called, and still prints 2026-01-31.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'date-time'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$2026-01-31$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$2026-02-01$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$null$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$It throws an exception.$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (CODE_OUTPUT, BEGINNER) -- same immutability fact, minusDays variant
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$LocalDate tarih1 = LocalDate.of(2026, 5, 10);
LocalDate tarih2 = tarih1.minusDays(5);
System.out.println(tarih1);$$, $$java$$,
           $$java.time'daki her plus/minus çağrısı immutability'yi korur ve yeni bir nesne döner -- orijinali asla değiştirmez. Bu yüzden tarih1, minusDays(5) çağrısından sonra da değişmez ve 2026-05-10 yazdırır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'date-time'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$2026-05-10$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$2026-05-05$$, FALSE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$null$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir istisna fırlatır.$$, FALSE, 3 FROM new_question_tr7;
