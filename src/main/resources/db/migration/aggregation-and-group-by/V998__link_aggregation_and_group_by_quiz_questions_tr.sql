-- Promotion-style migration linking TR aggregation-and-group-by quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.


-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'aggregation-and-group-by')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu projenin nullable `estimated_minutes` sütununda, bu derse göre `COUNT(*)` ile `COUNT(estimated_minutes)` farklı sayılar döndürebilir mi?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu projenin nullable `estimated_minutes` sütununda, bu derse göre `COUNT(*)` ile `COUNT(estimated_minutes)` farklı sayılar döndürebilir mi?$$,
           NULL, NULL,
           $$Ders, COUNT(*)'ın herhangi bir sütunun değerinden bağımsız olarak her satırı saydığını, COUNT(sutun)'un ise yalnızca o sütunun NULL olmadığı satırları saydığını belirtir -- bu, herhangi bir satırda ayarlanmamışsa ikisinin gerçekten farklı olabileceği, bu projenin kendi nullable estimated_minutes sütununda gerçek bir ayrımdır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'aggregation-and-group-by'
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
    ($$Hayır, ama yalnızca `estimated_minutes` bir `BIGSERIAL` sütunu olduğu için, COUNT'un çalışma şeklinden dolayı değil$$, FALSE, 0),
    ($$Evet, ama yalnızca `COUNT(*)` her zaman tam olarak `COUNT(sutun)`'un iki katı olduğu için$$, FALSE, 1),
    ($$Evet -- `COUNT(*)` her satırı sayar, `COUNT(estimated_minutes)` ise yalnızca NULL olmadığı satırları sayar$$, TRUE, 2),
    ($$Hayır -- `COUNT(*)` ve `COUNT(sutun)`, nullable olsun olmasın herhangi bir sütun için her zaman birebir aynı sonucu döndürür$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'aggregation-and-group-by'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'aggregation-and-group-by')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`SELECT COUNT(*) FROM topic;` (GROUP BY yok), `topic`'in kaç satırı olursa olsun tam olarak bir satır döndürür. Bu derse göre, neden?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`SELECT COUNT(*) FROM topic;` (GROUP BY yok), `topic`'in kaç satırı olursa olsun tam olarak bir satır döndürür. Bu derse göre, neden?$$,
           NULL, NULL,
           $$Ders, GROUP BY olmayan bir aggregate fonksiyonun, FROM/WHERE ifadelerinin tüm sonucunu tek bir grup olarak ele aldığını açıklar -- tüm filtrelenmiş tablo tek bir gruptur, bu yüzden aggregate onun tamamı üzerinde bir özet değer hesaplar.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'aggregation-and-group-by'
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
    ($$PostgreSQL, bir aggregate fonksiyon kullanan her sorguya sessizce `LIMIT 1` uygular$$, FALSE, 0),
    ($$`COUNT(*)`, diğer her aggregate fonksiyonun aksine, GROUP BY'dan bağımsız olarak her zaman tam olarak bir satır döndüren özel bir durumdur$$, FALSE, 1),
    ($$`topic` tablosunun, bu spesifik örnek amacıyla tam olarak bir satıra sahip olduğu tanımlanır$$, FALSE, 2),
    ($$GROUP BY olmayan bir aggregate fonksiyon, tüm filtrelenmiş sonucu tek bir grup olarak ele alır, bir özet satır üretir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'aggregation-and-group-by'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'aggregation-and-group-by')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, `SELECT slug, difficulty, COUNT(*) FROM topic GROUP BY difficulty` neden PostgreSQL tarafından reddedilir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `SELECT slug, difficulty, COUNT(*) FROM topic GROUP BY difficulty` neden PostgreSQL tarafından reddedilir?$$,
           NULL, NULL,
           $$Ders, SELECT listesindeki her sütunun ya bir aggregate fonksiyon ya da GROUP BY'da adı geçen sütunlardan biri olması gerektiğini belirtir -- belirli bir difficulty grubu için, PostgreSQL'in raporlayacak tek bir slug'ı yoktur, çünkü birçok olabilir, bu yüzden rastgele birini seçmek yerine sorguyu reddeder.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'aggregation-and-group-by'
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
    ($$`slug`, ne bir aggregate fonksiyon ne de bir `GROUP BY` sütunudur -- belirli bir `difficulty` grubu için birçok farklı `slug` değeri olabilir, raporlanacak tek biri yoktur$$, TRUE, 0),
    ($$PostgreSQL bu sorguyu aslında reddetmez -- hiçbir hata olmadan grup başına rastgele bir `slug` seçer$$, FALSE, 1),
    ($$`GROUP BY`, toplamda yalnızca tam olarak bir sütuna göre gruplamayı destekler, ve bu sorgu iki sütuna göre gruplamaya çalışır$$, FALSE, 2),
    ($$`COUNT(*)`, hiçbir koşulda aynı `SELECT` listesindeki başka herhangi bir sütunla birleştirilemez$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'aggregation-and-group-by'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'aggregation-and-group-by')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`HAVING`, gruplamadan sonraki grupları filtreler; `WHERE`, gruplamadan önceki satırları filtreler. Bu derse göre, `HAVING COUNT(*) >= 5` yerine neden `WHERE COUNT(*) >= 5` kullanılamaz?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`HAVING`, gruplamadan sonraki grupları filtreler; `WHERE`, gruplamadan önceki satırları filtreler. Bu derse göre, `HAVING COUNT(*) >= 5` yerine neden `WHERE COUNT(*) >= 5` kullanılamaz?$$,
           NULL, NULL,
           $$Ders, WHERE'in aggregation hiç var olmadan önce çalıştığını açıklar -- filtrelenen herhangi bir tek satır için COUNT(*)'ın henüz bir değeri yoktur, yalnızca gruplama zaten gerçekleştikten sonra var olur; HAVING'in WHERE'e eklenen ekstra bir koşul değil ayrı bir ifade olmasının tam nedeni budur.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'aggregation-and-group-by'
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
    ($$`HAVING`, yalnızca sorgunun hiç `GROUP BY` ifadesi olmadığında gereklidir$$, FALSE, 0),
    ($$`WHERE`, aggregation var olmadan önce çalışır -- `WHERE`'in onu değerlendirmesi gereken noktada `COUNT(*)`'ın henüz bir değeri yoktur$$, TRUE, 1),
    ($$`WHERE COUNT(*) >= 5` geçerlidir ve eşdeğerdir -- `HAVING`, hiçbir işlevsel farkı olmayan tamamen biçimsel bir alternatiftir$$, FALSE, 2),
    ($$`WHERE`, aggregate'lere atıfta bulunabilir, ama yalnızca `COUNT` için, `SUM`, `AVG`, `MIN` ya da `MAX` için asla$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'aggregation-and-group-by'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'aggregation-and-group-by')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu gerçek sorgu göz önüne alındığında, hiç topic'i olmayan bir kategori için doğru şekilde `0` raporlamak için neden `COUNT(*)` yerine `COUNT(t.id)` kullanılır?$$
      AND code_snippet = $$SELECT cat.name AS category_name, COUNT(t.id) AS topic_count
FROM category cat
LEFT JOIN topic t ON t.category_id = cat.id
GROUP BY cat.name;$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu gerçek sorgu göz önüne alındığında, hiç topic'i olmayan bir kategori için doğru şekilde `0` raporlamak için neden `COUNT(*)` yerine `COUNT(t.id)` kullanılır?$$,
           $$SELECT cat.name AS category_name, COUNT(t.id) AS topic_count
FROM category cat
LEFT JOIN topic t ON t.category_id = cat.id
GROUP BY cat.name;$$, $$sql$$,
           $$Ders, LEFT JOIN ile, eşleşen topic'i olmayan bir kategorinin hâlâ her t.* sütununun NULL olduğu bir çıktı satırı ürettiğini açıklar -- COUNT(*) bu tamamen-NULL satırı 1 olarak sayardı, COUNT(t.id) ise t.id'nin kendisi onun için NULL olduğundan bunu doğru şekilde 0 olarak sayar.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'aggregation-and-group-by'
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
    ($$Burada gerçek bir fark yoktur -- `COUNT(t.id)` ve `COUNT(*)`, herhangi bir `LEFT JOIN`'den sonra her zaman birebir aynı sonuçları üretir$$, FALSE, 0),
    ($$Çünkü `COUNT(t.id)`, `COUNT(*)`'tan daha hızlı çalışır, seçimin tek nedeni budur$$, FALSE, 1),
    ($$Çünkü hiç eşleşen topic'i olmayan bir kategori, LEFT JOIN aracılığıyla hâlâ tamamen-NULL bir satır üretir; `COUNT(t.id)`, `t.id`'yi doğru şekilde `NULL` olarak görüp saymaz, `COUNT(*)` ise onu 1 olarak sayardı$$, TRUE, 2),
    ($$Çünkü `COUNT(*)`, bir `LEFT JOIN` ile birlikte kullanıldığında geçersiz sözdizimidir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'aggregation-and-group-by'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'aggregation-and-group-by')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu gerçek sorgu göz önüne alındığında, `WHERE`, `GROUP BY` ve `HAVING` gerçekte hangi sırayla çalışır?$$
      AND code_snippet = $$SELECT category_id, COUNT(*) AS topic_count
FROM topic
WHERE difficulty = 'ADVANCED'
GROUP BY category_id
HAVING COUNT(*) >= 2;$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu gerçek sorgu göz önüne alındığında, `WHERE`, `GROUP BY` ve `HAVING` gerçekte hangi sırayla çalışır?$$,
           $$SELECT category_id, COUNT(*) AS topic_count
FROM topic
WHERE difficulty = 'ADVANCED'
GROUP BY category_id
HAVING COUNT(*) >= 2;$$, $$sql$$,
           $$Ders tam sırayı ortaya koyar: WHERE difficulty = 'ADVANCED' önce çalışır, hiçbir gruplama gerçekleşmeden önce ADVANCED olmayan satırları tamamen atar; GROUP BY category_id daha sonra hayatta kalan satırları gruplar; HAVING COUNT(*) >= 2 son çalışır, yalnızca (zaten filtrelenmiş satırların) sayısı eşiği karşılayan ortaya çıkan grupları tutar.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'aggregation-and-group-by'
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
    ($$Önce `HAVING`, sonra `GROUP BY`, sonra son olarak `WHERE`$$, FALSE, 0),
    ($$Önce `GROUP BY`, sonra `HAVING`, sonra son olarak `WHERE`$$, FALSE, 1),
    ($$Üçü de tabloda tek, sırasız bir geçişte aynı anda çalışır$$, FALSE, 2),
    ($$Önce `WHERE` (ADVANCED olmayan satırları atarak), sonra `GROUP BY` (hayatta kalanları gruplayarak), sonra son olarak `HAVING` (ortaya çıkan grupları filtreleyerek)$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'aggregation-and-group-by'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'aggregation-and-group-by')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, aggregation ve GROUP BY hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, aggregation ve GROUP BY hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (AVG/SUM/MIN/MAX'ın hepsinin, tek bir NULL'un tüm hesaplamayı zehirlemesine izin vermek yerine NULL'ları otomatik olarak yok sayması; GROUP BY ile DISTINCT'in AYNI İŞİ YAPMADIĞININ açıkça belirtilmesi -- DISTINCT yalnızca birebir aynı satır yinelemelerini kaldırır, GROUP BY'ın gerçekten yapabildiği gibi grup başına sayım/toplam/ortalama hesaplayamaz); ders, aggregate olmayan, gruplanmamış bir SELECT sütununun yalnızca bir stil uyarısı olduğunu söylemez (PostgreSQL sorguyu doğrudan reddeder), ve birden fazla aggregate fonksiyonunun tek bir sorguda birlikte görünmesi, her biri grup başına hesaplanarak açıkça gösterilir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'aggregation-and-group-by'
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
    ($$`AVG`/`SUM`/`MIN`/`MAX`'ın hepsi, tek bir `NULL`'un tüm hesaplamayı zehirlemesine izin vermek yerine `NULL`ları otomatik olarak yok sayar$$, TRUE, 0),
    ($$`GROUP BY` ile `DISTINCT` aynı işi yapmaz -- `DISTINCT` yalnızca birebir aynı satır yinelemelerini kaldırır, `GROUP BY`'ın gerçekten yapabildiği gibi grup başına sayım, toplam ya da ortalama hesaplayamaz$$, TRUE, 1),
    ($$GROUP BY yanında aggregate olmayan, gruplanmamış bir sütun seçmek, PostgreSQL'de yalnızca bir stil uyarısıdır, sorgunun reddedilmesine neden olan bir şey değildir$$, FALSE, 2),
    ($$Bu ders, tek bir SELECT listesinde yalnızca bir aggregate fonksiyonun görünebileceğini belirtir -- tek bir sorguda birden fazla aggregate birlikte mümkün değildir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'aggregation-and-group-by'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
