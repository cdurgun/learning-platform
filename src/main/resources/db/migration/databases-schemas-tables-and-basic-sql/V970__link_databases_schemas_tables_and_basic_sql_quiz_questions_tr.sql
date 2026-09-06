-- Promotion-style migration linking TR databases-schemas-tables-and-basic-sql quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.


-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'databases-schemas-tables-and-basic-sql')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bir PostgreSQL sunucusundan bir tabloya kadar olan tam hiyerarşi nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir PostgreSQL sunucusundan bir tabloya kadar olan tam hiyerarşi nedir?$$,
           NULL, NULL,
           $$Ders, tam hiyerarşinin sunucu -> veritabanı -> şema -> tablo olduğunu belirtir: bir sunucu birçok veritabanını barındırabilir, bir veritabanının birden fazla şeması olabilir, ve bir şemanın birçok tablosu olabilir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'databases-schemas-tables-and-basic-sql'
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
    ($$veritabanı -> sunucu -> tablo -> şema$$, FALSE, 0),
    ($$tablo -> şema -> veritabanı -> sunucu$$, FALSE, 1),
    ($$sunucu -> veritabanı -> şema -> tablo$$, TRUE, 2),
    ($$sunucu -> şema -> veritabanı -> tablo$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'databases-schemas-tables-and-basic-sql'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'databases-schemas-tables-and-basic-sql')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, `CREATE TABLE` SQL'in hangi kategorisine aittir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `CREATE TABLE` SQL'in hangi kategorisine aittir?$$,
           NULL, NULL,
           $$Ders, CREATE TABLE'ı (ALTER TABLE ve DROP TABLE ile birlikte) DDL (Data Definition Language) olarak sınıflandırır -- bir veritabanının yapısını tanımlayan ya da değiştiren ifadeler, DDL'nin zaten oluşturduğu bir yapı içindeki satırları okuyan ve yazan DML'den (INSERT/UPDATE/DELETE/SELECT) farklıdır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'databases-schemas-tables-and-basic-sql'
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
    ($$DML (Data Manipulation Language) -- var olan bir yapı içindeki satırları okur ve yazar$$, FALSE, 0),
    ($$İkisine de ait değildir -- CREATE TABLE tamamen idari bir komut olarak kabul edilir$$, FALSE, 1),
    ($$Hangi sütunların tanımlandığına bağlı olarak hem DDL'ye hem DML'ye eşit şekilde aittir$$, FALSE, 2),
    ($$DDL (Data Definition Language) -- yapıyı tanımlar ya da değiştirir, satırları değil$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'databases-schemas-tables-and-basic-sql'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'databases-schemas-tables-and-basic-sql')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$'Statement Terminators, Case Sensitivity, and Identifiers'a göre, `Kurs` gibi tırnaksız bir tablo adına PostgreSQL onu işlerken ne olur?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$'Statement Terminators, Case Sensitivity, and Identifiers'a göre, `Kurs` gibi tırnaksız bir tablo adına PostgreSQL onu işlerken ne olur?$$,
           NULL, NULL,
           $$Ders, tırnaksız tanımlayıcıların (tablo ve sütun adlarının), nasıl yazıldığından bağımsız olarak PostgreSQL tarafından otomatik olarak küçük harfe çevrildiğini belirtir -- bu yüzden `Kurs`, `KURS` ve `kurs`, biri çift tırnakla oluşturulmadığı sürece hepsi birebir aynı tabloya atıfta bulunur.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'databases-schemas-tables-and-basic-sql'
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
    ($$Otomatik olarak küçük harfe çevrilir (`kurs`), bu yüzden `Kurs`, `KURS` ve `kurs` hepsi birebir aynı tabloya atıfta bulunur$$, TRUE, 0),
    ($$Tırnaksız bir Java tanımlayıcısında olduğu gibi, tam olarak yazıldığı gibi, büyük/küçük harfe duyarlı kalır$$, FALSE, 1),
    ($$PostgreSQL bunu doğrudan reddeder, çünkü tırnaksız tanımlayıcılar baştan tamamen küçük harf olmak zorundadır$$, FALSE, 2),
    ($$Otomatik olarak büyük harfe çevrilir, PostgreSQL'in gerçek davranışının tam tersi$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'databases-schemas-tables-and-basic-sql'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'databases-schemas-tables-and-basic-sql')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu dersin 'Common Misconceptions' bölümüne göre, bir veritabanı ile bir şema aynı şey midir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu dersin 'Common Misconceptions' bölümüne göre, bir veritabanı ile bir şema aynı şey midir?$$,
           NULL, NULL,
           $$Ders, bunların aynı olmadığını açıkça belirtir -- bir veritabanı, psql'in \l'sinin listelediği ve \c'sinin arasında geçiş yaptığı en üst seviye kaptır; bir şema ise, \dn'nin listelediği, bir veritabanının İÇİNDEKİ bir isim alanıdır. Bu proje veritabanı başına tam olarak bir şemaya (public) sahip olsa da, tek bir veritabanı birçok şemayı barındırabilir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'databases-schemas-tables-and-basic-sql'
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
    ($$Evet, ve \dn ile \l'nin bu nedenle birebir aynı çıktıyı ürettiği tanımlanır$$, FALSE, 0),
    ($$Hayır -- bir veritabanı en üst seviye kaptır (\l/\c); bir şema bir veritabanının içindeki bir isim alanıdır (\dn), ve bir veritabanı birçok şemayı barındırabilir$$, TRUE, 1),
    ($$Evet -- 'veritabanı' ve 'şema', PostgreSQL'in birebir aynı kavram için birbirinin yerine kullandığı iki farklı isimdir$$, FALSE, 2),
    ($$Hayır, ama yalnızca bu spesifik proje veritabanı başına birden fazla şema tanımladığı için$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'databases-schemas-tables-and-basic-sql'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'databases-schemas-tables-and-basic-sql')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bu projenin migration'larında tek satırlık bir SQL yorumunu ne başlatır?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bu projenin migration'larında tek satırlık bir SQL yorumunu ne başlatır?$$,
           NULL, NULL,
           $$Ders, `--`'nin, o satırın sonuna kadar süren tek satırlık bir yorumu başlattığını belirtir -- kökeni itibarıyla Java'nın `//`'siyle ilgisiz olsa da, birebir aynı amaca hizmet eder; SQL ayrıca blok yorumlarını da (/* ... */) destekler, ama bu projenin migration'ları yalnızca `--` kullanır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'databases-schemas-tables-and-basic-sql'
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
    ($$`#`, bazı betik dillerinde yorumlar için kullanılan aynı karakter$$, FALSE, 0),
    ($$SQL'in yorum kavramı hiç yoktur -- her satır çalıştırılabilir olmalıdır$$, FALSE, 1),
    ($$`--` -- o satırın sonuna kadar süren tek satırlık bir yorum başlatır$$, TRUE, 2),
    ($$`//`, Java'nın tek satırlık yorum için kullandığı birebir aynı söz dizimi$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'databases-schemas-tables-and-basic-sql'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'databases-schemas-tables-and-basic-sql')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$V1__init_schema.sql'den alınan bu gerçek sütun tanımı göz önüne alındığında, bu dersin söz dizimini okuma şekline göre bu ne garanti eder?$$
      AND code_snippet = $$slug VARCHAR(255) NOT NULL UNIQUE$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$V1__init_schema.sql'den alınan bu gerçek sütun tanımı göz önüne alındığında, bu dersin söz dizimini okuma şekline göre bu ne garanti eder?$$,
           $$slug VARCHAR(255) NOT NULL UNIQUE$$, $$sql$$,
           $$Ders bunu soldan sağa okur: asla NULL olamayan bir VARCHAR(255) sütunu, artı bu tablodaki hiçbir iki satırın aynı değeri paylaşamayacağı anlamına gelen bir UNIQUE kısıtı -- bu dersin işi olduğu gibi söz dizimini akıcı okumak, tam kısıt mekaniğini değil (bu 'Constraints and Keys'e bırakılmıştır).$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'databases-schemas-tables-and-basic-sql'
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
    ($$Sütun en fazla bir satır için NULL olabilir, çünkü UNIQUE tam olarak bir NULL'a izin verir$$, FALSE, 0),
    ($$Sütun, tüm tabloda maksimum 255 satır sınırı uygular$$, FALSE, 1),
    ($$Sütunun değeri, yalnızca başka bir yerde UNIQUE olarak işaretlenmiş başka bir sütunla birleştirildiğinde benzersiz olmalıdır$$, FALSE, 2),
    ($$Sütun asla NULL olamaz, ve tablodaki hiçbir iki satır aynı `slug` değerini paylaşamaz$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'databases-schemas-tables-and-basic-sql'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'databases-schemas-tables-and-basic-sql')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, SQL söz dizimi hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, SQL söz dizimi hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (SQL anahtar kelimelerinin büyük/küçük harfe duyarsız olması -- büyük harfin bu projenin izlediği bir okunabilirlik kuralı olması, bir zorunluluk değil; bir UNIQUE sütunun, PostgreSQL bir NULL'u başka bir NULL'a hiçbir zaman eşit saymadığı için, benzersizlik kontrolleri dahil, hâlâ birden fazla NULL tutabilmesi); ders, NOT NULL'un yinelenen değerleri de otomatik olarak engellediğini iddia etmez (NOT NULL ve UNIQUE bağımsız kısıtlardır), ve PostgreSQL'in transactional DDL desteklediğini, yani bir transaction içindeki CREATE TABLE'ın geri alınamayacağını değil geri alınABİLECEĞİNİ açıkça belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'databases-schemas-tables-and-basic-sql'
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
    ($$`CREATE TABLE` ve `NOT NULL` gibi SQL anahtar kelimeleri PostgreSQL'de büyük/küçük harfe duyarsızdır -- büyük harf bir okunabilirlik kuralıdır, bir zorunluluk değil$$, TRUE, 0),
    ($$Bir `UNIQUE` sütun hâlâ birden fazla `NULL` satırı tutabilir, çünkü PostgreSQL bir `NULL`'u, benzersizlik kontrolleri dahil, başka bir `NULL`'a hiçbir zaman eşit saymaz$$, TRUE, 1),
    ($$Bir sütundaki `NOT NULL` kısıtı, o sütunun satırlar arasında yinelenen değerler tutmasını da otomatik olarak engeller$$, FALSE, 2),
    ($$PostgreSQL transactional DDL desteklemez -- bir transaction içindeki `CREATE TABLE` hiçbir zaman geri alınamaz$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'databases-schemas-tables-and-basic-sql'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
