-- Promotion-style migration linking TR postgresql-and-the-relational-model quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 5 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.


-- Question 1/5 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-and-the-relational-model')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bir veritabanını özellikle 'ilişkisel' (relational) yapan nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir veritabanını özellikle 'ilişkisel' (relational) yapan nedir?$$,
           NULL, NULL,
           $$Ders, 'ilişkisel'i, verinin bir dev yapı içinde tekrarlanması ya da iç içe yerleştirilmesi yerine, paylaşılan değerler aracılığıyla birbirine atıfta bulunan ayrı tablolar olarak organize edilmesi olarak tanımlar (topic.category_id'nin category'deki bir satırı işaret etmesi gibi) -- gündelik, gevşek anlamda 'ilişkili' değil.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-and-the-relational-model'
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
    ($$Her tablonun fiziksel olarak sunucudaki her diğer tabloyla aynı diskte yaşamak zorunda olması$$, FALSE, 0),
    ($$Tek bir tablo içindeki satırların birbiriyle ekleme sırasına göre ilişkili olması$$, FALSE, 1),
    ($$Tabloların, veriyi bir yapı içinde tekrarlamak ya da iç içe yerleştirmek yerine, paylaşılan sütun değerleri aracılığıyla birbirine atıfta bulunması$$, TRUE, 2),
    ($$Verinin, herhangi iki bilginin bağlantılı sayılabileceği gündelik, gevşek anlamda ilişkili olması$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-and-the-relational-model'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/5 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-and-the-relational-model')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, SQL ile PostgreSQL arasındaki ilişki nedir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, SQL ile PostgreSQL arasındaki ilişki nedir?$$,
           NULL, NULL,
           $$Ders bunu, JPA ve Hibernate için zaten ele alınan aynı spesifikasyon-uygulama ilişkisinin bir katman aşağısı olarak tanımlar: SQL geniş çapta standartlaştırılmış bir dildir, PostgreSQL ise onu uygulayan (MySQL, Oracle Database, SQL Server gibi diğerleriyle birlikte) gerçek, çalışan bir yazılım parçasıdır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-and-the-relational-model'
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
    ($$SQL ve PostgreSQL, anlamlı bir ayrım olmadan tamamen aynı şeyin iki adıdır$$, FALSE, 0),
    ($$PostgreSQL standartlaştırılmış bir dildir, SQL ise onun belirli bir uygulamasıdır$$, FALSE, 1),
    ($$SQL yalnızca PostgreSQL ile çalışır ve başka hiçbir veritabanı sistemiyle kullanılamaz$$, FALSE, 2),
    ($$SQL standartlaştırılmış bir dildir; PostgreSQL onun etrafında kurulu, ilişkisel bir veritabanının belirli, gerçek bir uygulamasıdır -- JPA ve Hibernate ile aynı spesifikasyon-uygulama ilişkisi$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-and-the-relational-model'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/5 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-and-the-relational-model')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$'Tables, Rows, and Columns: The Core Mental Model'a göre, bir sütun, tablosundaki her satır için neyi garanti eder?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$'Tables, Rows, and Columns: The Core Mental Model'a göre, bir sütun, tablosundaki her satır için neyi garanti eder?$$,
           NULL, NULL,
           $$Ders, bir sütunu, o tablodaki her satırın bir değere sahip olduğu -- ya da sütun buna izin veriyorsa (yani NULL'a izin veriyorsa) açıkça hiçbir değere sahip olmadığı, adlandırılmış, tipli bir yuva olarak tanımlar; bazı satırların sahip olduğu, diğerlerinin ise tamamen yoksun olduğu opsiyonel bir alan değildir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-and-the-relational-model'
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
    ($$Her satırın bir değere sahip olduğu, ya da sütun NULL'a izin veriyorsa açıkça hiçbir değere sahip olmadığı, adlandırılmış, tipli bir yuva$$, TRUE, 0),
    ($$Tablodaki yalnızca bazı satırların, ne zaman eklendiklerine bağlı olarak sahip olması gereken bir yuva$$, FALSE, 1),
    ($$Tablodaki her satırda her zaman birebir aynı olan bir değer$$, FALSE, 2),
    ($$Her zaman farklı bir tablodaki bir satıra işaret eden bir referans$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-and-the-relational-model'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/5 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-and-the-relational-model')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu dersin, bir Java metot çağrısından gerçekten depolanmış satıra kadar olan beş katmanlı yığınını doğru sıraya koyun.$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu dersin, bir Java metot çağrısından gerçekten depolanmış satıra kadar olan beş katmanlı yığınını doğru sıraya koyun.$$,
           NULL, NULL,
           $$Ders, yığını şöyle sıralar: Spring Boot -> Spring Data JPA -> Hibernate -> SQL -> PostgreSQL -> tablolar/indeksler/kısıtlar/transaction'lar -- her katman, adlandırılabilir belirli bir sonrakine devreder.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-and-the-relational-model'
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
    ($$PostgreSQL -> SQL -> Hibernate -> Spring Data JPA -> Spring Boot$$, FALSE, 0),
    ($$Spring Boot -> Spring Data JPA -> Hibernate -> SQL -> PostgreSQL$$, TRUE, 1),
    ($$Spring Boot -> Hibernate -> Spring Data JPA -> PostgreSQL -> SQL$$, FALSE, 2),
    ($$SQL -> Spring Boot -> Hibernate -> Spring Data JPA -> PostgreSQL$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-and-the-relational-model'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/5 (Pair 5 TR, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-and-the-relational-model')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu dersin 'ACID: A First Look' bölümünde tanıtıldığı şekliyle, ACID hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu dersin 'ACID: A First Look' bölümünde tanıtıldığı şekliyle, ACID hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (Atomicity'nin, bir grup değişikliğin ya hepsinin olması ya da hiçbirinin olmaması anlamına gelmesi; Isolation'ın, bir transaction'ın başka bir transaction'ın bitmemiş, commit edilmemiş işini görmemesi anlamına gelmesi); ders, PostgreSQL'in dört ACID garantisinin hepsini (yalnızca bazılarını değil) sağladığını belirtir, ve tam mekaniğin bilerek bu derste değil, kursun sonraki bir dersi olan 'Transactions and Concurrency in PostgreSQL'de öğretildiğini açıkça belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-and-the-relational-model'
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
    ($$Bu derste PostgreSQL'in dört ACID garantisinden yalnızca bazılarını sağladığı, hepsini değil, tanımlanır$$, FALSE, 0),
    ($$Bu ders, ACID'in, transaction'ların ve kilitlemenin tam mekaniğini derinlemesine öğretir, sonraki bir ders için hiçbir şey bırakmaz$$, FALSE, 1),
    ($$Atomicity, bir grup değişikliğin ya hepsinin olması ya da hiçbirinin olmaması anlamına gelir$$, TRUE, 2),
    ($$Isolation, bir transaction'ın başka bir transaction'ın bitmemiş, commit edilmemiş işini görmemesi anlamına gelir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-and-the-relational-model'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
