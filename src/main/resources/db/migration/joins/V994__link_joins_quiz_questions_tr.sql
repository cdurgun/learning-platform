-- Promotion-style migration linking TR joins quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.


-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'joins')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bir `category`'nin adını `course`'unun adıyla birlikte almak neden bir JOIN gerektirir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir `category`'nin adını `course`'unun adıyla birlikte almak neden bir JOIN gerektirir?$$,
           NULL, NULL,
           $$Ders, bir category satırının yalnızca course_id'yi depoladığını, kursun adını tekrarlamadığını açıklar; her iki adı da tek bir sonuçta almak, bu yüzden foreign key ilişkilerinin bağlandığı her yerde iki tabloyu satır satır birleştirmek anlamına gelir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'joins'
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
    ($$Çünkü `category` ve `course` fiziksel olarak ayrı veritabanı sunucularında depolanır$$, FALSE, 0),
    ($$Çünkü `category.name` ve `course.name`'in dönüştürülmesi gereken gerçekten farklı veri tipleri vardır$$, FALSE, 1),
    ($$Bir `category` satırı yalnızca `course_id`'yi depolar, kursun adını değil -- her ikisini de birleştirmek iki tablo arasında satırları eşleştirmeyi gerektirir$$, TRUE, 2),
    ($$PostgreSQL, tek bir tablodan bile olsa, birden fazla sütun seçildiğinde her zaman bir `JOIN` gerektirir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'joins'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'joins')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bir `INNER JOIN` hangi satırları döndürür?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir `INNER JOIN` hangi satırları döndürür?$$,
           NULL, NULL,
           $$Ders, INNER JOIN'in (genellikle sadece JOIN olarak yazılır, INNER ima edilir) yalnızca her iki tarafta da eşleşmesi olan satırları döndürdüğünü belirtir -- eşleşen bir course'u olmayan bir category satırı basitçe görünmez.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'joins'
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
    ($$Sağ tarafta bir eşleşme olup olmadığından bağımsız olarak, sol tablonun her satırı$$, FALSE, 0),
    ($$Her iki tarafta da bir eşleşme olsun ya da olmasın, her iki tablonun her satırı, birleştirilmiş olarak$$, FALSE, 1),
    ($$Yalnızca join'in her iki tarafında da HİÇBİR eşleşmesi olmayan satırlar$$, FALSE, 2),
    ($$Yalnızca join'in her iki tarafında da eşleşmesi olan satırlar$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'joins'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'joins')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu gerçek üç tablolu zincir göz önüne alındığında, bu sorgu bu projenin kendi verisine karşı kaç satır döndürür?$$
      AND code_snippet = $$SELECT t.slug, cat.name AS category_name, c.name AS course_name
FROM topic t
INNER JOIN category cat ON t.category_id = cat.id
INNER JOIN course c ON cat.course_id = c.id
WHERE t.slug = 'joins';$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu gerçek üç tablolu zincir göz önüne alındığında, bu sorgu bu projenin kendi verisine karşı kaç satır döndürür?$$,
           $$SELECT t.slug, cat.name AS category_name, c.name AS course_name
FROM topic t
INNER JOIN category cat ON t.category_id = cat.id
INNER JOIN course c ON cat.course_id = c.id
WHERE t.slug = 'joins';$$, $$sql$$,
           $$Ders, bunun tam olarak bir satır döndürdüğünü belirtir: `joins`, `PostgreSQL Foundations`, `PostgreSQL` -- çünkü t.slug = 'joins' tam olarak bir topic satırıyla eşleşir, ve her INNER JOIN adımı onu bu projenin gerçek içerik hiyerarşisine göre tam olarak bir category ve bir course ile eşleştirir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'joins'
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
    ($$Tam olarak bir satır: `joins`, `PostgreSQL Foundations`, `PostgreSQL`$$, TRUE, 0),
    ($$Sıfır satır, çünkü üç tablolu `INNER JOIN` zincirleri geçerli SQL sözdizimi değildir$$, FALSE, 1),
    ($$`postgresql-foundations` kategorisindeki her topic için bir tane olmak üzere on satır$$, FALSE, 2),
    ($$Tam olarak bir satır, ama `category_name` ve `course_name` ikisi de `NULL` ile$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'joins'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'joins')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$'From JPQL join fetch to a Real SQL JOIN'a göre, bu projenin `TopicRepository.findBySlugWithCategoryAndCourse`'unun JPQL `join fetch`'i neye derlenir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$'From JPQL join fetch to a Real SQL JOIN'a göre, bu projenin `TopicRepository.findBySlugWithCategoryAndCourse`'unun JPQL `join fetch`'i neye derlenir?$$,
           NULL, NULL,
           $$Ders, join fetch'in SQL'in JOIN'inden farklı bir join türü olmadığını -- Hibernate'in, Java seviyesindeki 'bu ilişkili entity'yi de yükle' talimatını gerçek bir SQL JOIN olarak ifade etmeyi seçmesi olduğunu, elle yazılan aynı üç tablolu INNER JOIN zincirine esasen derlendiğini belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'joins'
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
    ($$JPQL'in kendisinin ne söylediğinden bağımsız olarak, özellikle bir `LEFT JOIN`$$, FALSE, 0),
    ($$Esasen aynı üç tablolu `INNER JOIN` zinciri -- `join fetch`, JPQL tarafından ifade edilen aynı ilişkisel işlemdir$$, TRUE, 1),
    ($$Özel bir Hibernate-only sorgu protokolü kullanan, bir SQL `JOIN`'den tamamen farklı bir mekanizma$$, FALSE, 2),
    ($$İlişkili entity başına bir tane olmak üzere, birbiri ardına çalışan iki veya daha fazla ayrı, takip eden `SELECT` sorgusu$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'joins'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'joins')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu gerçek sorgu göz önüne alındığında, hiç İngilizce `topic_translation` satırı olmayan bir `topic` satırı için `tt.title` ne gösterir?$$
      AND code_snippet = $$SELECT t.slug, tt.title
FROM topic t
LEFT JOIN topic_translation tt ON tt.topic_id = t.id AND tt.language = 'en';$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu gerçek sorgu göz önüne alındığında, hiç İngilizce `topic_translation` satırı olmayan bir `topic` satırı için `tt.title` ne gösterir?$$,
           $$SELECT t.slug, tt.title
FROM topic t
LEFT JOIN topic_translation tt ON tt.topic_id = t.id AND tt.language = 'en';$$, $$sql$$,
           $$Ders, LEFT JOIN'in sağda bir eşleşme bulup bulmadığından bağımsız olarak sol taraftaki tablonun (topic) her satırını tuttuğunu açıklar -- eşleşme olmadığında, sağ tarafın sütunları basitçe NULL olarak geri gelir, o topic satırının bir INNER JOIN'in yapacağı gibi sessizce kaybolması yerine.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'joins'
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
    ($$`LEFT JOIN` hiçbir zaman `NULL` değeri üretmediği için, `NULL` yerine boş bir dizge `''`$$, FALSE, 0),
    ($$`LEFT JOIN`, her satırda bir eşleşme gerektirdiği için sorgu bir hatayla başarısız olur$$, FALSE, 1),
    ($$`NULL` -- `topic` satırı hâlâ görünür, ama eşleşen bir satır olmadığı için `tt.title` `NULL` olarak geri gelir$$, TRUE, 2),
    ($$`topic` satırı, bir `INNER JOIN`'in üreteceğiyle aynı şekilde sonuçtan tamamen kaybolur$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'joins'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'joins')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir geliştirici, yayınlanmış İngilizce çevirisi olmayan topic'leri bulmayı amaçlayarak `LEFT JOIN topic_translation en ON en.topic_id = t.id AND en.language = 'en' WHERE en.published = true` yazıyor. Bu dersin 'Common Mistakes' bölümüne göre, gerçekte ne olur?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir geliştirici, yayınlanmış İngilizce çevirisi olmayan topic'leri bulmayı amaçlayarak `LEFT JOIN topic_translation en ON en.topic_id = t.id AND en.language = 'en' WHERE en.published = true` yazıyor. Bu dersin 'Common Mistakes' bölümüne göre, gerçekte ne olur?$$,
           NULL, NULL,
           $$Ders, dış birleştirilmiş bir tablonun sütununu ON yerine WHERE'de filtrelemenin, bir LEFT JOIN'i sessizce bir INNER JOIN'in eşdeğerine geri döndürdüğünü açıkça uyarır -- WHERE join'den sonra çalışır ve koşulun true olmadığı her satırı düşürür, LEFT JOIN'in korumayı amaçladığı tam olarak NULL satırlar dahil.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'joins'
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
    ($$Bu tam olarak amaçlandığı gibi çalışır -- dış birleştirilmiş bir tablo üzerindeki herhangi bir koşul için `WHERE` ve `ON` tamamen birbirinin yerine geçebilir$$, FALSE, 0),
    ($$`WHERE`, bir `LEFT JOIN` yapılmış bir tablonun sütunlarına atıfta bulunamayacağı için sorgu doğrudan bir sözdizimi hatasıyla başarısız olur$$, FALSE, 1),
    ($$PostgreSQL, amaçlanan `LEFT JOIN` davranışını korumak için `WHERE` ifadesini otomatik olarak `ON` ifadesine yeniden yazar$$, FALSE, 2),
    ($$`WHERE en.published = true`, bunu sessizce bir `INNER JOIN`'in eşdeğerine geri döndürür, bulunması amaçlanan tam olarak eşleşmeyen satırları düşürür$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'joins'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'joins')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, `RIGHT JOIN` ve `FULL JOIN` hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, `RIGHT JOIN` ve `FULL JOIN` hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (A LEFT JOIN B ile B RIGHT JOIN A'nın aynı satırları, yalnızca farklı sütun sırasıyla döndürmesi -- bu, RIGHT JOIN'in pratikte nadiren gerekli olmasının nedenidir; FULL JOIN'in eşleşme olsun olmasın her iki taraftan da her satırı tutması, eşleniği olmayan tarafa NULL doldurması); ders, bu projenin kendi kodunun RIGHT JOIN'i hiç kullanmadığını açıkça belirtir, ve LEFT JOIN'in INNER JOIN'den doğası gereği daha yavaş olmadığını -- herhangi bir performans farkının indeksler ve satır sayılarına bağlı olduğunu, join türünün kendisine değil, belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'joins'
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
    ($$`A LEFT JOIN B` ile `B RIGHT JOIN A`, aynı satırları, yalnızca farklı bir sütun sırasıyla döndürür$$, TRUE, 0),
    ($$`FULL JOIN`, eşleşme olsun olmasın her iki taraftan da her satırı tutar, eşleniği olmayan tarafa `NULL` doldurur$$, TRUE, 1),
    ($$Bu projenin kendi gerçek kodu, bu derste sorgularında `RIGHT JOIN`'i yaygın olarak kullandığı şeklinde tanımlanır$$, FALSE, 2),
    ($$`LEFT JOIN`, bu derste, indekslerden ya da satır sayılarından bağımsız olarak, doğası gereği her zaman `INNER JOIN`'den daha yavaş olarak tanımlanır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'joins'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
