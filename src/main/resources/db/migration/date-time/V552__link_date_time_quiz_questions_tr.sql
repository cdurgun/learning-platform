-- Promotion-style migration linking TR Date & Time API quiz questions to
-- the topic's fixed quiz created in date-time/V550 -- same pattern as V551.
-- All 7 TR questions from question-promotion/V549 (hand-authored and
-- self-reviewed -- no n8n, no OpenAI, no AI Judge, and NOT translations of
-- the EN set -- each independently authored to test the same concept as
-- its EN counterpart with different values/scenarios/regions or framing).

-- Question 1/7 (Pair 1 TR, quiz position 1)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'date-time')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir LocalDateTime nesnesi '2026-03-15T15:00' değerini tutuyor. Bu değer hangi zaman diliminde ifade edilmiştir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir LocalDateTime nesnesi '2026-03-15T15:00' değerini tutuyor. Bu değer hangi zaman diliminde ifade edilmiştir?$$, NULL, NULL,
           $$LocalDateTime hiçbir zaman dilimi bilgisi taşımaz -- '15:00' diyen bir LocalDateTime'ın bu değerin İstanbul mu yoksa New York mu olduğuna dair hiçbir fikri yoktur. Bir anı bir zaman dilimine bağlamak için ZonedDateTime veya Instant kullanılmalıdır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
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
    ($$Hiçbiri -- LocalDateTime hiçbir zaman dilimi bilgisi taşımaz.$$, TRUE, 0),
    ($$JVM'in varsayılan sistem zaman dilimi.$$, FALSE, 1),
    ($$UTC.$$, FALSE, 2),
    ($$LocalDateTime.now() çağrıldığı yere bağlıdır.$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'date-time')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Derse göre, bir log kaydının "gerçekte ne zaman gerçekleştiği" bilgisini veritabanında saklamak için en uygun tip hangisidir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Derse göre, bir log kaydının "gerçekte ne zaman gerçekleştiği" bilgisini veritabanında saklamak için en uygun tip hangisidir?$$, NULL, NULL,
           $$Bir zaman damgasını veritabanında saklamak genellikle Instant (ya da sabit offsetli bir OffsetDateTime) kullanmak anlamına gelir -- herhangi bir zaman diliminden bağımsız, tek ve belirsizliğe yer bırakmayan evrensel bir anı temsil eder. Kullanıcının zaman dilimi yalnızca bu an gösterilirken uygulanır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
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
    ($$Instant (ya da sabit offsetli bir OffsetDateTime) -- herhangi bir zaman diliminden bağımsız, tek ve belirsizliğe yer bırakmayan evrensel bir anı temsil eder.$$, TRUE, 0),
    ($$LocalDateTime, çünkü en sık kullanılan java.time sınıfıdır.$$, FALSE, 1),
    ($$ZonedDateTime, çünkü zaten bir zaman dilimi taşır.$$, FALSE, 2),
    ($$Date, çünkü zaman diliminden bağımsız olduğu garantidir.$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'date-time')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$ZonedDateTime tokyo = ZonedDateTime.of(2026, 6, 1, 9, 0, 0, 0, ZoneId.of("Asia/Tokyo"));
ZonedDateTime istanbul = tokyo.withZoneSameInstant(ZoneId.of("Europe/Istanbul"));
System.out.println(tokyo.equals(istanbul));$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$ZonedDateTime tokyo = ZonedDateTime.of(2026, 6, 1, 9, 0, 0, 0, ZoneId.of("Asia/Tokyo"));
ZonedDateTime istanbul = tokyo.withZoneSameInstant(ZoneId.of("Europe/Istanbul"));
System.out.println(tokyo.equals(istanbul));$$, $$java$$,
           $$ZonedDateTime üzerinde equals() çağırmak hem anı hem de zaman dilimini karşılaştırır. withZoneSameInstant, anı korur ama zaman dilimini değiştirir -- tokyo ve istanbul aynı evrensel anı temsil etse bile equals() false döner; yalnızca anı karşılaştırmak için isEqual(...) kullanılmalıdır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
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
    ($$Bir istisna fırlatır.$$, FALSE, 2),
    ($$Sistemin varsayılan zaman dilimine bağlıdır.$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: MULTIPLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'date-time')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Duration, Period ve ChronoUnit hakkında aşağıdaki ifadelerden hangileri doğrudur?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Duration, Period ve ChronoUnit hakkında aşağıdaki ifadelerden hangileri doğrudur?$$, NULL, NULL,
           $$Period, yalnızca LocalDate değerleri arasında kullanılabilen takvim tabanlı (yıl/ay/gün) bir miktarı temsil eder; Duration, Instant veya LocalDateTime değerleri arasında kullanılabilen zaman tabanlı (saat/dakika/saniye) bir miktarı temsil eder; ChronoUnit.DAYS.between(...), Period'un aksine toplam gün farkını tek bir sayı olarak döner. Saat/dakika hassasiyeti gerektiren bir hesaplama için Period değil Duration kullanılmalıdır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
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
    ($$Period, yalnızca LocalDate değerleri arasında kullanılabilen, takvim tabanlı (yıl/ay/gün) bir miktarı temsil eder.$$, TRUE, 0),
    ($$ChronoUnit.DAYS.between(...), Period'un aksine, toplam gün farkını tek bir sayı olarak döner.$$, TRUE, 1),
    ($$Duration, Instant veya LocalDateTime değerleri arasında kullanılabilen zaman tabanlı (saat/dakika/saniye) bir miktarı temsil eder.$$, TRUE, 2),
    ($$Duration, saat/dakika hassasiyetinde bir farkı Period kadar doğru ifade edemez.$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'date-time')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$LocalDate tarih = LocalDate.of(2026, 3, 31);
LocalDate sonuc = tarih.plusMonths(1);
System.out.println(sonuc);$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$LocalDate tarih = LocalDate.of(2026, 3, 31);
LocalDate sonuc = tarih.plusMonths(1);
System.out.println(sonuc);$$, $$java$$,
           $$plusMonths(1), ay taşmasını akıllıca yönetir -- 31 Mart artı bir ay, var olmayan "31 Nisan"a düşmez, o ayın son geçerli gününe (30) sabitlenir. Nisan ayı 30 gün çektiği için sonuç 2026-04-30 olur.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
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
    ($$2026-04-30$$, TRUE, 0),
    ($$2026-05-01$$, FALSE, 1),
    ($$2026-04-31$$, FALSE, 2),
    ($$Bir DateTimeException fırlatır.$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'date-time')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$SimpleDateFormat'ın tek bir örneğinin birden fazla thread arasında paylaşılması neden önerilmez?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$SimpleDateFormat'ın tek bir örneğinin birden fazla thread arasında paylaşılması neden önerilmez?$$, NULL, NULL,
           $$SimpleDateFormat thread-safe değildir -- aynı örneğin birden fazla thread tarafından eşzamanlı kullanılması bozuk (corrupted) sonuçlar üretebilir. DateTimeFormatter ise immutable olduğu için thread'ler arasında güvenle paylaşılabilir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
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
    ($$SimpleDateFormat thread-safe değildir -- eşzamanlı kullanım bozuk (corrupted) sonuçlar üretebilir.$$, TRUE, 0),
    ($$Deprecated olduğu için birden fazla thread'den çağrıldığında UnsupportedOperationException fırlatır.$$, FALSE, 1),
    ($$Her thread'in kendi zaman dilimine ihtiyacı vardır ve SimpleDateFormat yalnızca birini tutabilir.$$, FALSE, 2),
    ($$SimpleDateFormat nesneleri immutable olduğu için paylaşmak gereksiz bellek harcar.$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: CODE_OUTPUT)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'date-time')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$LocalDate tarih1 = LocalDate.of(2026, 5, 10);
LocalDate tarih2 = tarih1.minusDays(5);
System.out.println(tarih1);$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$LocalDate tarih1 = LocalDate.of(2026, 5, 10);
LocalDate tarih2 = tarih1.minusDays(5);
System.out.println(tarih1);$$, $$java$$,
           $$java.time'daki her plus/minus çağrısı immutability'yi korur ve yeni bir nesne döner -- orijinali asla değiştirmez. Bu yüzden tarih1, minusDays(5) çağrısından sonra da değişmez ve 2026-05-10 yazdırır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
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
    ($$2026-05-10$$, TRUE, 0),
    ($$2026-05-05$$, FALSE, 1),
    ($$null$$, FALSE, 2),
    ($$Bir istisna fırlatır.$$, FALSE, 3)
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
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
