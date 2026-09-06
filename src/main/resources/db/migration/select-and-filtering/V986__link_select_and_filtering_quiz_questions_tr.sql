-- Promotion-style migration linking TR select-and-filtering quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.


-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'select-and-filtering')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, temel bir `SELECT` ifadesinin tam şekli nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, temel bir `SELECT` ifadesinin tam şekli nedir?$$,
           NULL, NULL,
           $$Ders, şeklin `SELECT <sutunlar> FROM <tablo> WHERE <kosul>;` olduğunu belirtir -- önce sütunlar, sonra tablo, sonra opsiyonel bir filtre.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'select-and-filtering'
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
    ($$`WHERE <kosul> SELECT <sutunlar> FROM <tablo>;`$$, FALSE, 0),
    ($$`SELECT <tablo> FROM <sutunlar> WHERE <kosul>;`$$, FALSE, 1),
    ($$`SELECT <sutunlar> FROM <tablo> WHERE <kosul>;`$$, TRUE, 2),
    ($$`FROM <tablo> SELECT <sutunlar> WHERE <kosul>;`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'select-and-filtering'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'select-and-filtering')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, `SELECT *`, kalıcı olması amaçlanan herhangi bir şeyde neden kaçınılmaya değerdir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `SELECT *`, kalıcı olması amaçlanan herhangi bir şeyde neden kaçınılmaya değerdir?$$,
           NULL, NULL,
           $$Ders, SELECT *'in, bir migration bir sütun eklediği anda sonuç şeklini sessizce değiştirdiğini, ve sonrasında hiçbir şeyin ihtiyaç duymadığı sütunları getirdiğini belirtir -- sütunları açıkça adlandırmak, tablo daha sonra ne olursa olsun bir sorgunun çıktı şeklini sabit tutar.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'select-and-filtering'
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
    ($$PostgreSQL'de sözdizimsel olarak geçersizdir ve her zaman bir hata üretir$$, FALSE, 0),
    ($$Yalnızca tam olarak bir sütunu olan tablolarda doğru çalışır$$, FALSE, 1),
    ($$Her tek durumda, her sütunu açıkça adlandırmaktan ölçülebilir şekilde daha yavaş çalışır$$, FALSE, 2),
    ($$Bir migration bir sütun eklediği anda sonuç şeklini sessizce değiştirir, ve sonrasında hiçbir şeyin ihtiyaç duymadığı sütunları getirir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'select-and-filtering'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'select-and-filtering')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`WHERE difficulty = 'ADVANCED' OR difficulty = 'BEGINNER' AND category_id = 5` (parantez yok) ifadesi, bu derse göre gerçekte nasıl değerlendirilir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`WHERE difficulty = 'ADVANCED' OR difficulty = 'BEGINNER' AND category_id = 5` (parantez yok) ifadesi, bu derse göre gerçekte nasıl değerlendirilir?$$,
           NULL, NULL,
           $$Ders, AND'in OR'dan daha sıkı bağlandığını, aritmetikte *'ın +'ya göre olduğu aynı önceliği belirtir -- bu yüzden bu, "difficulty = 'ADVANCED'" OR ("difficulty = 'BEGINNER' AND category_id = 5") olarak okunur, gruplamayı açıkça yapan parantezler olmadan bu neredeyse kesinlikle amaçlanan şey değildir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'select-and-filtering'
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
    ($$`difficulty = 'ADVANCED'` OR (`difficulty = 'BEGINNER' AND category_id = 5`) olarak -- `AND`, `OR`'dan daha sıkı bağlanır$$, TRUE, 0),
    ($$(`difficulty = 'ADVANCED'` OR `difficulty = 'BEGINNER'`) AND `category_id = 5` olarak -- `OR`, `AND`'den daha sıkı bağlanır$$, FALSE, 1),
    ($$PostgreSQL bu ifadeyi belirsiz olduğu için doğrudan reddeder, çalışması için açık parantez gerektirir$$, FALSE, 2),
    ($$Hiçbir öncelik kuralı olmadan soldan sağa, her koşulu tam olarak yazıldığı sırada değerlendirerek$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'select-and-filtering'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'select-and-filtering')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu projenin gerçek `topic` slug'ları `postgresql-and-the-relational-model`, `postgresql-data-types` ve `connecting-to-postgresql` göz önüne alındığında, `WHERE slug LIKE 'postgresql%'` hangilerini eşleştirir?$$
      AND code_snippet = $$SELECT slug FROM topic WHERE slug LIKE 'postgresql%';$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu projenin gerçek `topic` slug'ları `postgresql-and-the-relational-model`, `postgresql-data-types` ve `connecting-to-postgresql` göz önüne alındığında, `WHERE slug LIKE 'postgresql%'` hangilerini eşleştirir?$$,
           $$SELECT slug FROM topic WHERE slug LIKE 'postgresql%';$$, $$sql$$,
           $$Ders, sondaki %'nin yalnızca postgresql İLE BAŞLAYAN slug'ları eşleştirdiğini açıklar -- connecting-to-postgresql eşleşmez (postgresql başta değil sonda görünür), postgresql-and-the-relational-model ve postgresql-data-types'ın ikisi de eşleşir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'select-and-filtering'
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
    ($$Üçünden hiçbiri -- `LIKE`'ın herhangi bir şeyi eşleştirmesi için her iki tarafta da joker karakter gerekir$$, FALSE, 0),
    ($$`postgresql-and-the-relational-model` ve `postgresql-data-types` -- `connecting-to-postgresql`, `postgresql` ile başlamaz$$, TRUE, 1),
    ($$Her üç slug da, çünkü `postgresql` her birinde bir yerde görünür$$, FALSE, 2),
    ($$Yalnızca `connecting-to-postgresql`, çünkü `postgresql` ile biter$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'select-and-filtering'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'select-and-filtering')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, `estimated_minutes BETWEEN 15 AND 20`, sınırlarını dahil eder mi yoksa hariç mi tutar?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `estimated_minutes BETWEEN 15 AND 20`, sınırlarını dahil eder mi yoksa hariç mi tutar?$$,
           NULL, NULL,
           $$Ders, BETWEEN'in tek bir koşulda dahil edici bir aralığı kontrol ettiğini belirtir -- estimated_minutes >= 15 AND estimated_minutes <= 20 ile eşdeğerdir, her iki sınır da dahildir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'select-and-filtering'
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
    ($$Yalnızca alt sınırı dahil eder -- `>= 15 AND < 20` ile eşdeğerdir$$, FALSE, 0),
    ($$Yalnızca üst sınırı dahil eder -- `> 15 AND <= 20` ile eşdeğerdir$$, FALSE, 1),
    ($$Her iki sınırı da dahil eder -- `>= 15 AND <= 20` ile eşdeğerdir$$, TRUE, 2),
    ($$Her iki sınırı da hariç tutar -- `> 15 AND < 20` ile eşdeğerdir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'select-and-filtering'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'select-and-filtering')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu projenin `topic.estimated_minutes` sütunu nullable'dır, ve bazı satırlarda `NULL` olarak ayarlanmıştır. `SELECT slug FROM topic WHERE estimated_minutes = NULL;` ne döndürür?$$
      AND code_snippet = $$SELECT slug FROM topic WHERE estimated_minutes = NULL;$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu projenin `topic.estimated_minutes` sütunu nullable'dır, ve bazı satırlarda `NULL` olarak ayarlanmıştır. `SELECT slug FROM topic WHERE estimated_minutes = NULL;` ne döndürür?$$,
           $$SELECT slug FROM topic WHERE estimated_minutes = NULL;$$, $$sql$$,
           $$Ders, bunun her zaman SIFIR satır döndürdüğünü açıkça belirtir -- 'estimated_minutes'ın NULL olduğu satırlar' değil. PostgreSQL'in üç değerli mantığında herhangi bir şeyi NULL ile = ile karşılaştırmak unknown'a değerlenir, ve WHERE yalnızca koşulun true olduğu satırları tutar, bu yüzden bir unknown satır sessizce düşürülür. NULL için test etmenin tek doğru yolu IS NULL'dır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'select-and-filtering'
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
    ($$`estimated_minutes`'ın gerçekten `NULL` olduğu her satır -- `IS NULL`'ın vereceği aynı sonuç$$, FALSE, 0),
    ($$Bir sözdizimi hatası -- PostgreSQL, `=`'in sağ tarafında `NULL`'a bir literal olarak izin vermez$$, FALSE, 1),
    ($$Tablodaki her satır, çünkü `NULL` herhangi bir değerle eşleşen bir joker karakter olarak ele alınır$$, FALSE, 2),
    ($$Her zaman sıfır satır -- `= NULL`, gerçekten `NULL` olan satırlar için bile asla true'ya değerlenmez$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'select-and-filtering'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'select-and-filtering')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, SELECT ve filtreleme hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, SELECT ve filtreleme hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (!= ve <>'nin ikisinin de 'eşit değil' anlamına gelmesi, <>'nin SQL standardı yazımı, !='in yaygın desteklenen bir takma ad olması -- bu projenin aralarında güçlü bir tercihi yok; ILIKE'ın PostgreSQL'e özgü olması, standart SQL'in parçası olmaması, ve LIKE'ın büyük/küçük harfe duyarsız eşdeğeri olması); ders, LIKE '%text%' ile gerçek full-text search'ün AYNI ŞEY OLMADIĞINI açıkça belirtir (LIKE'ın kelime sınırları, alaka sıralaması ya da kök bulma kavramı yoktur), ve IN (...)'in tek bir = karşılaştırmasının zaten yapacağının ötesinde hiçbir otomatik yineleme giderme ya da tip zorlaması sunmadığını belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'select-and-filtering'
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
    ($$`!=` ve `<>`'nin ikisi de 'eşit değil' anlamına gelir -- `<>` SQL standardı yazımdır, `!=` yaygın desteklenen bir takma addır$$, TRUE, 0),
    ($$`ILIKE`, PostgreSQL'e özgüdür (standart SQL değildir) ve `LIKE`'ın büyük/küçük harfe duyarsız eşdeğeridir$$, TRUE, 1),
    ($$`LIKE '%text%'` ile PostgreSQL'in gerçek full-text search özelliği bu derste aynı şey olarak tanımlanır$$, FALSE, 2),
    ($$`IN (...)`, tek bir `=` karşılaştırmasının zaten yapacağının ötesinde, değer listesini otomatik olarak yinelemesizleştirir ve tip zorlaması yapar$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'select-and-filtering'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
