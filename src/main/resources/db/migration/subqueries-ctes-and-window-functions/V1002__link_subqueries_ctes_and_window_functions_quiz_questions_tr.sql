-- Promotion-style migration linking TR subqueries-ctes-and-window-functions quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.


-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'subqueries-ctes-and-window-functions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir skaler subquery'nin, `WHERE ortalama_sure > (SELECT ...)` gibi bir karşılaştırmada kullanılabilmesi için ne döndürmesi gerekir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir skaler subquery'nin, `WHERE ortalama_sure > (SELECT ...)` gibi bir karşılaştırmada kullanılabilmesi için ne döndürmesi gerekir?$$,
           NULL, NULL,
           $$Ders, bir skaler subquery'yi, tam olarak bir satır ve bir sütun döndürmesi gereken olarak tanımlar, çünkü tek bir sütun değeriyle, tıpkı bir literal sayıyla olacağı gibi > ile karşılaştırılır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'subqueries-ctes-and-window-functions'
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
    ($$Tam olarak bir satır, ama herhangi bir sayıda sütun$$, FALSE, 0),
    ($$Hiçbir şey -- bir subquery bir karşılaştırma operatörünün sağ tarafında hiçbir zaman görünemez$$, FALSE, 1),
    ($$Tam olarak bir satır ve bir sütun$$, TRUE, 2),
    ($$Tam olarak bir sütun olduğu sürece, herhangi bir sayıda satır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'subqueries-ctes-and-window-functions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'subqueries-ctes-and-window-functions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu örnek `topic` verisi ve correlated subquery göz önüne alındığında, sorgu hangi `estimated_minutes` değerlerini döndürür?$$
      AND code_snippet = $$-- topic (category_id, estimated_minutes) ornek satirlar:
-- (3, 8), (3, 16), (3, 24), (4, 6), (4, 18)

SELECT t.estimated_minutes
FROM topic t
WHERE t.estimated_minutes > (
    SELECT AVG(t2.estimated_minutes)
    FROM topic t2
    WHERE t2.category_id = t.category_id
);$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu örnek `topic` verisi ve correlated subquery göz önüne alındığında, sorgu hangi `estimated_minutes` değerlerini döndürür?$$,
           $$-- topic (category_id, estimated_minutes) ornek satirlar:
-- (3, 8), (3, 16), (3, 24), (4, 6), (4, 18)

SELECT t.estimated_minutes
FROM topic t
WHERE t.estimated_minutes > (
    SELECT AVG(t2.estimated_minutes)
    FROM topic t2
    WHERE t2.category_id = t.category_id
);$$, $$sql$$,
           $$Ders, correlated bir subquery'nin t.category_id kullanarak dış sorgunun her satırı için bir kez yeniden değerlendirildiğini açıklar: kategori 3'ün ortalaması (8+16+24)/3=16'dır, bu yüzden yalnızca 24 onu aşar; kategori 4'ün ortalaması (6+18)/2=12'dir, bu yüzden yalnızca 18 onu aşar -- subquery tek bir platform geneli ortalama DEĞİLDİR, kategori başına yeniden hesaplanır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'subqueries-ctes-and-window-functions'
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
    ($$Yalnızca 24 -- çünkü 24, tüm tabloda tek en yüksek değerdir$$, FALSE, 0),
    ($$Beş değerin tümü -- çünkü her satır en azından bir kategorinin ortalaması kadar büyüktür$$, FALSE, 1),
    ($$Hiçbiri -- correlated subquery'ler `>` ile karşılaştırılamaz$$, FALSE, 2),
    ($$24 ve 18 -- her biri, tek bir platform geneli ortalama değil, kendi kategorisinin ortalamasıyla karşılaştırılarak$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'subqueries-ctes-and-window-functions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'subqueries-ctes-and-window-functions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bir `WITH <ad> AS (...)` ifadesi (bir CTE), sorgunun geri kalanının ne yapmasına izin verir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir `WITH <ad> AS (...)` ifadesi (bir CTE), sorgunun geri kalanının ne yapmasına izin verir?$$,
           NULL, NULL,
           $$Ders, bir CTE'nin bir subquery'yi önceden adlandırdığını, ana sorgunun ona o tek ifadenin geri kalanı için gerçek bir tablo gibi başvurmasına izin verdiğini belirtir -- şemada hiçbir yerde gerçek bir tablo değildir, yalnızca o sorgu süresince var olur.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'subqueries-ctes-and-window-functions'
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
    ($$Adlandırılmış subquery'ye, aynı ifadenin geri kalanı için gerçek bir tablo gibi başvurmak$$, TRUE, 0),
    ($$Sorgu bittikten sonra da kalıcı olan, veritabanı şemasında yeni bir tablo kalıcı olarak oluşturmak$$, FALSE, 1),
    ($$Tıpkı bir correlated subquery'nin yaptığı gibi, subquery'yi dış sorgunun her satırı için bir kez çalıştırmak$$, FALSE, 2),
    ($$Aynı ifadenin başka herhangi bir yerindeki bir `FROM` ifadesine olan ihtiyacı ortadan kaldırmak$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'subqueries-ctes-and-window-functions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'subqueries-ctes-and-window-functions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, `RECURSIVE` olmadan, bir `WITH` ifadesindeki bir CTE, aynı ifadede daha sonra tanımlanan başka bir CTE'ye başvurabilir mi?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `RECURSIVE` olmadan, bir `WITH` ifadesindeki bir CTE, aynı ifadede daha sonra tanımlanan başka bir CTE'ye başvurabilir mi?$$,
           NULL, NULL,
           $$Ders bunu açıkça yaygın bir hata olarak listeler: CTE'ler (RECURSIVE olmadan) yalnızca aynı WITH ifadesinde kendilerinden önce tanımlanmış olanlara başvurabilir, sırayla -- sorgunun kendisini okumakla aynı yukarıdan aşağıya bağımlılık yönü.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'subqueries-ctes-and-window-functions'
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
    ($$Evet, ama yalnızca sonraki CTE sade bir aggregate değil bir window function olduğunda$$, FALSE, 0),
    ($$Hayır -- bir CTE, aynı `WITH` ifadesinde yalnızca kendisinden önce tanımlanmış olanlara, yukarıdan aşağıya, başvurabilir$$, TRUE, 1),
    ($$Evet -- aynı `WITH` ifadesindeki CTE'ler, konumdan bağımsız olarak herhangi bir sırada birbirine başvurabilir$$, FALSE, 2),
    ($$Evet, ama yalnızca her iki CTE de açıkça `AS` ile takma adlandırılmışsa$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'subqueries-ctes-and-window-functions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'subqueries-ctes-and-window-functions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu örnek veri ve window function sorgusu göz önüne alındığında, kaç satır döndürülür, ve `estimated_minutes = 8` olan satır için `kategori_ort` nedir?$$
      AND code_snippet = $$-- topic (slug, category_id, estimated_minutes) ornek satirlar:
-- ('x', 5, 8), ('y', 5, 12), ('z', 6, 4)

SELECT slug, category_id, estimated_minutes,
       AVG(estimated_minutes) OVER (PARTITION BY category_id) AS kategori_ort
FROM topic;$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu örnek veri ve window function sorgusu göz önüne alındığında, kaç satır döndürülür, ve `estimated_minutes = 8` olan satır için `kategori_ort` nedir?$$,
           $$-- topic (slug, category_id, estimated_minutes) ornek satirlar:
-- ('x', 5, 8), ('y', 5, 12), ('z', 6, 4)

SELECT slug, category_id, estimated_minutes,
       AVG(estimated_minutes) OVER (PARTITION BY category_id) AS kategori_ort
FROM topic;$$, $$sql$$,
           $$Ders, bir window function'ın GROUP BY'ın yaptığı gibi satırları asla çökertmediğini belirtir -- orijinal 3 satırın tamamı hayatta kalır, her biri kendi kategorisinin ortalamasını yanında taşır. Kategori 5'in ortalaması (8+12)/2=10'dur, bu yüzden 'x' slug'ı (kategori 5'te) kategori_ort=10 gösterir, platform geneli bir ortalama değil.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'subqueries-ctes-and-window-functions'
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
    ($$Bir window function her zaman tek bir özet satırına çöktüğü için toplamda 1 satır$$, FALSE, 0),
    ($$3 satır korunur, ama 'x' slug'ı için `kategori_ort`, tüm satırlar arasındaki platform geneli ortalama olan 8'dir$$, FALSE, 1),
    ($$3 satır, tümü korunur; 'x' slug'ı (kategori 5) için `kategori_ort` 10'dur$$, TRUE, 2),
    ($$Kategori başına bir tane olmak üzere 2 satır; 'x' slug'ı için `kategori_ort` 8'dir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'subqueries-ctes-and-window-functions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'subqueries-ctes-and-window-functions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir eşitlik içeren bu örnek veri göz önüne alındığında, 'p' ve 'r' satırları hangi `sn` (ROW_NUMBER) ve `sira` (RANK) değerlerini alır, ve 's' hangi `sira` değerini alır?$$
      AND code_snippet = $$-- topic (slug, category_id, estimated_minutes) ornek satirlar:
-- ('p', 2, 30), ('r', 2, 30), ('s', 2, 15)

SELECT slug,
       ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY estimated_minutes DESC) AS sn,
       RANK() OVER (PARTITION BY category_id ORDER BY estimated_minutes DESC) AS sira
FROM topic;$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bir eşitlik içeren bu örnek veri göz önüne alındığında, 'p' ve 'r' satırları hangi `sn` (ROW_NUMBER) ve `sira` (RANK) değerlerini alır, ve 's' hangi `sira` değerini alır?$$,
           $$-- topic (slug, category_id, estimated_minutes) ornek satirlar:
-- ('p', 2, 30), ('r', 2, 30), ('s', 2, 15)

SELECT slug,
       ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY estimated_minutes DESC) AS sn,
       RANK() OVER (PARTITION BY category_id ORDER BY estimated_minutes DESC) AS sira
FROM topic;$$, $$sql$$,
           $$Ders, ROW_NUMBER()'ın hiçbir zaman eşitlik vermediğini, eşit değerler için bile kesin bir 1,2,3 sırası ürettiğini ('p' ve 'r' bir sırayla sn 1 ve 2 alır) açıklarken, RANK()'ın eşit satırlara aynı sırayı verdiğini ve buna göre bir sonraki sayıyı atladığını belirtir -- 'p' ve 'r' ikisi de sira=1 alır, ve 's' (15'e sahip tek satır) sira=3 alır, 2 değil.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'subqueries-ctes-and-window-functions'
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
    ($$`p`/`r` aynı `sn`'i (1) ve aynı `sira`yı (1) alır; `s`, `sira` = 2 alır$$, FALSE, 0),
    ($$PostgreSQL window function'larında eşitlik imkansız olduğu için `p`/`r` farklı `sn` ve farklı `sira` değerleri alır$$, FALSE, 1),
    ($$`p`/`r` aynı `sira`yı (1) alır, ve `s` de `sira` = 1 alır, çünkü `RANK()` `ORDER BY` değerini tamamen yok sayar$$, FALSE, 2),
    ($$`p`/`r` farklı `sn` değerleri alır (bir sırayla 1 ve 2) ama aynı `sira`yı (1) alır; `s`, 2'yi atlayarak `sira` = 3 alır$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'subqueries-ctes-and-window-functions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'subqueries-ctes-and-window-functions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, subquery'ler, CTE'ler ve window function'lar hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, subquery'ler, CTE'ler ve window function'lar hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (bir window function'ın GROUP BY'ın aksine hiçbir zaman çıktı satır sayısını azaltmaması -- aynı aggregate'ten başlasalar bile ikisinin farklı problemleri çözmesinin tam nedeni budur; PARTITION BY'ın bir window function için satırları bağımsız gruplara bölmesi, GROUP BY'ın aggregation için gruplamasının window function eşdeğeri olması); ders, bir CTE'nin eşdeğer bir subquery'den HER ZAMAN daha hızlı olmadığını açıkça belirtir (öncelikle bir okunabilirlik/yeniden kullanılabilirlik aracıdır), ve RANK()/ROW_NUMBER()'ın yalnızca eşitlik olmadığında birbirinin yerine geçebildiğini, her zaman değil.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'subqueries-ctes-and-window-functions'
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
    ($$Bir window function, `GROUP BY`'ın aksine, çıktı satır sayısını asla azaltmaz$$, TRUE, 0),
    ($$`PARTITION BY`, bir window function için satırları bağımsız gruplara böler, bu da GROUP BY'ın aggregation için gruplamasının window function eşdeğeridir$$, TRUE, 1),
    ($$Bir CTE, mantıksal olarak eşdeğer, iç içe geçmiş bir subquery'den her zaman daha hızlıdır$$, FALSE, 2),
    ($$`RANK()` ve `ROW_NUMBER()`, `ORDER BY` sütununda eşitlik olup olmadığından bağımsız olarak, her zaman tamamen birbirinin yerine geçebilir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'subqueries-ctes-and-window-functions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
