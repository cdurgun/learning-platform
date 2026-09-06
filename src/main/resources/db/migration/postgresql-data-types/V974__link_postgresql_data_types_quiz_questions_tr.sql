-- Promotion-style migration linking TR postgresql-data-types quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.


-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-data-types')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, `BIGSERIAL` nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `BIGSERIAL` nedir?$$,
           NULL, NULL,
           $$Ders, BIGSERIAL'in ayrı bir depolama tipi olmadığını -- BIGINT artı bir sonraki değeri üreten otomatik olarak oluşturulmuş bir sequence olduğunu belirtir, bu tam olarak bu projenin kendi primary key'lerindeki GenerationType.IDENTITY'nin arkasındaki mekanizmadır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-data-types'
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
    ($$Büyük serileştirilmiş JSON nesnelerini depolamak için özellikle kullanılan bir string tipi$$, FALSE, 0),
    ($$Yalnızca foreign key sütunları için kullanılabilen, primary key'ler için asla kullanılamayan bir tip$$, FALSE, 1),
    ($$BIGINT artı bir sonraki değeri üreten otomatik olarak oluşturulmuş bir sequence -- kendi başına ayrı bir depolama tipi değil$$, TRUE, 2),
    ($$BIGINT'ten tamamen ayrı, kendi ayrı ikili gösterimine sahip bir depolama tipi$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-data-types'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-data-types')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, PostgreSQL'de `TEXT`, uzunluğu sınırlı bir `VARCHAR(n)`'den daha mı yavaştır?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, PostgreSQL'de `TEXT`, uzunluğu sınırlı bir `VARCHAR(n)`'den daha mı yavaştır?$$,
           NULL, NULL,
           $$Ders, PostgreSQL'in VARCHAR(n)'i, sınırsız VARCHAR'ı ve TEXT'i içsel olarak hepsini aynı şekilde depoladığını, TEXT'e uzunluğu sınırlı bir VARCHAR'a kıyasla hiçbir performans cezası uygulamadığını açıkça belirtir -- TEXT'in daha yavaş, ayrı depolanan bir tip olduğu bazı diğer veritabanlarının aksine.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-data-types'
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
    ($$Evet -- TEXT, özellikle PostgreSQL'de her zaman VARCHAR(n)'den önemli ölçüde daha yavaştır$$, FALSE, 0),
    ($$Evet, ama yalnızca 255 karakterden uzun sütunlar için$$, FALSE, 1),
    ($$Bu ders, VARCHAR ile TEXT arasındaki performans farklarını hiç ele almaz$$, FALSE, 2),
    ($$Hayır -- PostgreSQL üçünü de içsel olarak aynı şekilde depolar, TEXT için hiçbir performans cezası yoktur$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-data-types'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-data-types')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, PostgreSQL'de bir `BOOLEAN` sütunu hangi değerleri depolayabilir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, PostgreSQL'de bir `BOOLEAN` sütunu hangi değerleri depolayabilir?$$,
           NULL, NULL,
           $$Ders, BOOLEAN'ın tam olarak true, false ya da NULL depoladığını belirtir -- bazı veritabanlarının aksine, 0/1 tamsayı ikamesi yoktur; 0/1 tamsayıdır, bazı istemci kütüphaneleri onları gevşek girdi olarak kabul etse de, gerçekten farklı bir tiptir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-data-types'
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
    ($$Tam olarak `true`, `false` ya da `NULL` -- `0`/`1` tamsayı ikamesi yoktur$$, TRUE, 0),
    ($$Yalnızca `0` ya da `1`, birçok diğer veritabanı sistemindeki bir tamsayı bayrağıyla aynı$$, FALSE, 1),
    ($$`true`, `false`, `0`, `1` ve `NULL`, hepsi eşit derecede geçerli beş değer olarak ele alınır$$, FALSE, 2),
    ($$Yalnızca `true` ya da `false` -- bir BOOLEAN sütunu hiçbir koşulda NULL tutamaz$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-data-types'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-data-types')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, `TIMESTAMP` ile `TIMESTAMPTZ` arasındaki temel fark nedir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `TIMESTAMP` ile `TIMESTAMPTZ` arasındaki temel fark nedir?$$,
           NULL, NULL,
           $$Ders, sade TIMESTAMP'in hiçbir zaman dilimi bilgisi eklenmemiş bir tarih ve saat depoladığını -- yazıldığı gibi saf bir an olduğunu -- belirtirken, TIMESTAMPTZ'nin PostgreSQL'in içsel olarak her zaman UTC'ye normalleştirdiği, bağlanan client'ın hangi zaman diliminde olduğuna göre dönüştürdüğü bir anı depoladığını belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-data-types'
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
    ($$TIMESTAMPTZ, TIMESTAMP'in aksine yalnızca tarihleri depolayabilir, hiçbir zaman saatleri değil$$, FALSE, 0),
    ($$TIMESTAMP'e hiç zaman dilimi eklenmez; TIMESTAMPTZ içsel olarak UTC'ye normalleştirir ve client'ın zaman dilimine göre dönüştürür$$, TRUE, 1),
    ($$Her açıdan işlevsel olarak aynıdırlar, TIMESTAMPTZ yalnızca TIMESTAMP'in daha uzun bir takma adıdır$$, FALSE, 2),
    ($$TIMESTAMP zaman dilimi işlemeyi içerir, TIMESTAMPTZ ise açıkça içermez$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-data-types'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-data-types')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu gerçek `\d topic_translation` çıktısı göz önüne alındığında, `summary` sütununu tanımlamak için gerçekte hangi SQL tipi kullanılmıştı?$$
      AND code_snippet = $$learning=# \d topic_translation
                 Table "public.topic_translation"
      Column      |          Type          | Collation | Nullable | Default
-------------------+------------------------+-----------+----------+---------
 id                | bigint                 |           | not null |
 topic_id          | bigint                 |           | not null |
 language          | character varying(5)   |           | not null |
 title             | character varying(255) |           | not null |
 summary           | text                   |           |          |
 published         | boolean                |           | not null |$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu gerçek `\d topic_translation` çıktısı göz önüne alındığında, `summary` sütununu tanımlamak için gerçekte hangi SQL tipi kullanılmıştı?$$,
           $$learning=# \d topic_translation
                 Table "public.topic_translation"
      Column      |          Type          | Collation | Nullable | Default
-------------------+------------------------+-----------+----------+---------
 id                | bigint                 |           | not null |
 topic_id          | bigint                 |           | not null |
 language          | character varying(5)   |           | not null |
 title             | character varying(255) |           | not null |
 summary           | text                   |           |          |
 published         | boolean                |           | not null |$$, $$text$$,
           $$Ders, psql'in PostgreSQL'in içsel tip adlarını raporladığını, bunların küçük harfli olduğunu ve bazen onları tanımlamak için kullanılan SQL anahtar kelimesinden farklı olduğunu açıklar -- burada gösterilen `text`, doğrudan TEXT SQL tipidir (character varying'in VARCHAR'a göre olduğu gibi TEXT için ayrı bir 'içsel' yazım yoktur), ve TEXT tam olarak bu projenin `topic_translation.summary`'yi açık bir `columnDefinition` aracılığıyla eşlediği tiptir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-data-types'
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
    ($$`BIGINT`, `id` ve `topic_id` sütunlarıyla aynı tip$$, FALSE, 0),
    ($$`BOOLEAN`, hemen altında gösterilen `published` sütunuyla aynı tip$$, FALSE, 1),
    ($$`TEXT` -- psql çıktısında `text` olarak gösterilir, bu projenin `TopicTranslation.summary` üzerindeki açık `columnDefinition = "TEXT"`ine uyar$$, TRUE, 2),
    ($$`VARCHAR(255)`, hemen üstünde gösterilen `title` sütunuyla aynı tip$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-data-types'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-data-types')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bu projenin `topic_translation.published` sütununun `BOOLEAN NOT NULL` olması, onun ilkel bir `boolean`a Java eşlemesi için neden önemlidir?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bu projenin `topic_translation.published` sütununun `BOOLEAN NOT NULL` olması, onun ilkel bir `boolean`a Java eşlemesi için neden önemlidir?$$,
           NULL, NULL,
           $$Ders, Java'da ilkel bir boolean alanının asla null tutamayacağını, bu yüzden sütun NULL'a izin verseydi, veritabanından okunan bir NULL değerinin gidecek geçerli bir yeri olmayacağını belirtir -- bir NOT NULL sütunu ile null olamayan bir Java tipinin uyuşması gerekir, aksi halde bir satırı okumak uygulama mantığıyla hiç ilgisi olmayan şekillerde başarısız olabilir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-data-types'
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
    ($$Hiç önemli değildir -- Java'nın ilkel `boolean`'ı hiçbir sorun olmadan bir veritabanı NULL'unu temsil edebilir$$, FALSE, 0),
    ($$`NOT NULL` burada Java'nın değeri nasıl eşlediğiyle hiçbir ilişkisi olmayan, tamamen bir performans optimizasyonudur$$, FALSE, 1),
    ($$Hibernate, Java alanının bildirilen tipinden bağımsız olarak, herhangi bir NULL boolean değerini otomatik olarak kutulanmış bir `Boolean`a dönüştürür$$, FALSE, 2),
    ($$Java'da ilkel bir `boolean` asla `null` tutamaz -- sütun NULL'a izin verseydi, geri okunan bir NULL değerinin gidecek geçerli bir yeri olmazdı$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-data-types'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'postgresql-data-types')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, PostgreSQL veri tipleri hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, PostgreSQL veri tipleri hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (INTEGER/BIGINT'in Java'nın Integer/Long'una eşlenmesi; küçük kalacak bir tabloda bile her primary key için BIGINT/BIGSERIAL seçmenin, foreign key'ler ona referans verdikten sonra bir primary key'in tipini daha sonra değiştirmenin ekstra bayt maliyetinden çok daha yıkıcı olduğu için savunmacı bir varsayılan olarak adlandırılması); bir TIMESTAMPTZ sütununu LocalDateTime'a eşlemenin, zaman dilimi bilgisini sessizce kaybeden yaygın bir hata olarak açıkça adlandırılması (güvenli, kayıpsız bir seçim değil), ve bu dersin kendi örneklerinin, her SQL-Java eşlemesinin (TEXT columnDefinition durumu hariç) hiçbir açık tip dönüştürme anotasyonu OLMADAN Hibernate tarafından otomatik olarak ele alındığını göstermesi -- her tek eşleme için birine ihtiyaç duyulmaması.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'postgresql-data-types'
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
    ($$Küçük kalacak bir tabloda bile her primary key için `BIGINT`/`BIGSERIAL` seçmek, korunmaya değer savunmacı bir varsayılan olarak tanımlanır$$, TRUE, 0),
    ($$`INTEGER`/`BIGINT`, bu projenin kendi `topic.estimated_minutes` (`INTEGER`) ve `id` (`BIGSERIAL`) sütunlarına uyacak şekilde, Java'nın `Integer`/`Long`'una eşlenir$$, TRUE, 1),
    ($$Bu derse göre, bir `TIMESTAMPTZ` sütununu `LocalDateTime`a eşlemek, hiçbir dezavantajı olmayan güvenli, kayıpsız bir seçimdir$$, FALSE, 2),
    ($$Bu projenin entity'leri, bu derste gösterilen her tek SQL-Java tip eşlemesi için, istisnasız açık bir tip dönüştürme anotasyonu gerektirir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'postgresql-data-types'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
