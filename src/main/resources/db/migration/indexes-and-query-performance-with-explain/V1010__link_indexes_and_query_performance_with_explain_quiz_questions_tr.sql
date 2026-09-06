-- Promotion-style migration linking TR indexes-and-query-performance-with-explain quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.


-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'indexes-and-query-performance-with-explain')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, sade `EXPLAIN` (ANALYZE olmadan) gerçekte ne yapar?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, sade `EXPLAIN` (ANALYZE olmadan) gerçekte ne yapar?$$,
           NULL, NULL,
           $$Ders, EXPLAIN'in, sorguyu gerçekten çalıştırmadan, PostgreSQL'in onu nasıl çalıştırmayı amaçladığını gösterdiğini belirtir -- bu bir tahmindir (maliyet, tahmini satır, tahmini genişlik), gerçek çalıştırma verisi değil.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'indexes-and-query-performance-with-explain'
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
    ($$Yalnızca `SELECT` ifadelerinde çalışır -- `UPDATE` ya da `DELETE` üzerinde hiç kullanılamaz$$, FALSE, 0),
    ($$Sorguyu, bir sonraki çalıştırmada daha hızlı olması için içsel olarak kalıcı şekilde yeniden yazar$$, FALSE, 1),
    ($$Sorguyu gerçekten çalıştırmadan, PostgreSQL'in amaçlanan sorgu planını ve maliyet tahminini gösterir$$, TRUE, 2),
    ($$Sorguyu gerçekten çalıştırır ve aldığı gerçek geçen süreyi raporlar$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'indexes-and-query-performance-with-explain'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'indexes-and-query-performance-with-explain')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bir `Seq Scan` her zaman bir sorguda bir sorun olduğunun işareti midir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir `Seq Scan` her zaman bir sorguda bir sorun olduğunun işareti midir?$$,
           NULL, NULL,
           $$Ders, bir Seq Scan'in doğası gereği kötü olmadığını açıkça belirtir -- küçük bir tabloda, her satırı taramak genellikle gerçekten en ucuz seçenektir, bir index'e başvurmanın ek yükünden bile daha ucuzdur.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'indexes-and-query-performance-with-explain'
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
    ($$Evet -- bir `Seq Scan` her zaman tabloda gerekli bir index'in eksik olduğu anlamına gelir$$, FALSE, 0),
    ($$Evet, ama yalnızca sorgu sütunları adlandırmak yerine özellikle `SELECT *` kullandığında$$, FALSE, 1),
    ($$Hayır, ama yalnızca index'lerin foreign key sütunlarında çalışmadığı tanımlandığı için$$, FALSE, 2),
    ($$Hayır -- küçük bir tabloda, bir `Seq Scan` genellikle gerçekten en ucuz seçenektir, bir index'e başvurmaktan bile daha ucuzdur$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'indexes-and-query-performance-with-explain'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'indexes-and-query-performance-with-explain')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, `USING <yontem>` belirtilmeden, `CREATE INDEX` varsayılan olarak hangi index tipini kullanır?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `USING <yontem>` belirtilmeden, `CREATE INDEX` varsayılan olarak hangi index tipini kullanır?$$,
           NULL, NULL,
           $$Ders, CREATE INDEX'in varsayılan olarak bir B-tree kullandığını belirtir -- değerleri sıralı düzende tutan dengeli bir ağaç yapısı, eşitlik ve aralık koşulları (=, <, >, BETWEEN) için doğru varsayılan, ve pratikte açık ara en yaygın index tipi, bu projenin kendi şemasının tanımladığı her index dahil.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'indexes-and-query-performance-with-explain'
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
    ($$Bir B-tree -- eşitlik ve aralık koşulları için verimlidir, ve pratikte en yaygın index tipidir$$, TRUE, 0),
    ($$Yalnızca eşitlik karşılaştırmaları için optimize edilmiş bir hash index$$, FALSE, 1),
    ($$Uzun metin sütunları içindeki kelimeleri eşleştirmek için tasarlanmış bir full-text search index$$, FALSE, 2),
    ($$Varsayılan olarak tablonun yalnızca bir alt kümesini kapsayan bir partial index$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'indexes-and-query-performance-with-explain'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'indexes-and-query-performance-with-explain')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aynı sorgu için bu `EXPLAIN` ve `EXPLAIN ANALYZE` çıktısı göz önüne alındığında, tahmini `rows=10` ile gerçek `rows=3` arasındaki fark bu derse göre neyi gösterir?$$
      AND code_snippet = $$EXPLAIN SELECT * FROM topic WHERE category_id = 2;
-- Seq Scan on topic (cost=0.00..1.20 rows=8 width=44)

EXPLAIN ANALYZE SELECT * FROM topic WHERE category_id = 2;
-- Seq Scan on topic (cost=0.00..1.20 rows=8 width=44)
--                    (actual time=0.010..0.015 rows=2 loops=1)$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aynı sorgu için bu `EXPLAIN` ve `EXPLAIN ANALYZE` çıktısı göz önüne alındığında, tahmini `rows=10` ile gerçek `rows=3` arasındaki fark bu derse göre neyi gösterir?$$,
           $$EXPLAIN SELECT * FROM topic WHERE category_id = 2;
-- Seq Scan on topic (cost=0.00..1.20 rows=8 width=44)

EXPLAIN ANALYZE SELECT * FROM topic WHERE category_id = 2;
-- Seq Scan on topic (cost=0.00..1.20 rows=8 width=44)
--                    (actual time=0.010..0.015 rows=2 loops=1)$$, $$text$$,
           $$Ders, EXPLAIN'in tahmini satırlarını EXPLAIN ANALYZE'nin gerçek satırlarıyla karşılaştırmanın bu araç çiftinin sunduğu en yararlı şeylerden biri olduğunu belirtir -- aralarındaki büyük bir fark, PostgreSQL'in tablo hakkındaki kendi istatistiklerinin muhtemelen eski ya da yanıltıcı olduğu anlamına gelir, bu da onun daha kötü bir plan seçmesine neden olabilir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'indexes-and-query-performance-with-explain'
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
    ($$Bu fark anlamsızdır -- bunun gibi küçük farklar her zaman oluşur ve hiçbir teşhis değeri taşımaz$$, FALSE, 0),
    ($$PostgreSQL'in tablo hakkındaki kendi istatistikleri muhtemelen eski ya da yanıltıcıdır, bu da daha kötü bir plan seçmesine neden olabilir$$, TRUE, 1),
    ($$Sorgunun yalnızca `EXPLAIN ANALYZE`'nin tespit edebildiği bir sözdizimi hatası vardır$$, FALSE, 2),
    ($$`EXPLAIN ANALYZE`, sade `EXPLAIN`'e kıyasla gerçek satır sayısını her zaman olduğundan fazla gösterir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'indexes-and-query-performance-with-explain'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'indexes-and-query-performance-with-explain')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir partial index `WHERE language = 'en' AND published = true` ile oluşturuluyor. Bu derse göre, `WHERE language = 'tr'` filtreleyen bir sorgu bundan fayda sağlar mı?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir partial index `WHERE language = 'en' AND published = true` ile oluşturuluyor. Bu derse göre, `WHERE language = 'tr'` filtreleyen bir sorgu bundan fayda sağlar mı?$$,
           NULL, NULL,
           $$Ders, bir partial index'in gerçek bir ödünleşim olduğunu açıkça belirtir: yalnızca kendi koşulu index'in WHERE ifadesiyle eşleşen (ya da onun tarafından ima edilen) sorgulara yardımcı olur -- language = 'tr' üzerinde filtreleyen bir sorgu, WHERE language = 'en' ile tanımlanmış bir index'ten hiçbir fayda görmez.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'indexes-and-query-performance-with-explain'
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
    ($$Evet, ama yalnızca sorgu da açıkça `published = true` üzerinde filtreliyorsa$$, FALSE, 0),
    ($$Hayır, çünkü partial index'ler hiçbir koşulda hiçbir sorguya hiçbir fayda sağlamaz$$, FALSE, 1),
    ($$Hayır -- bir partial index, yalnızca kendi koşulu index'in kendi `WHERE` ifadesiyle eşleşen (ya da onun tarafından ima edilen) sorgulara yardımcı olur$$, TRUE, 2),
    ($$Evet -- bir partial index, kendi `WHERE` ifadesinden bağımsız olarak indexlenmiş sütunun her değerini hâlâ kapsar$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'indexes-and-query-performance-with-explain'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'indexes-and-query-performance-with-explain')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$sort_order üzerinde bir index varken, bu derse göre, bu iki yaklaşımdan hangisi sonuçlarda bir sayfa ne kadar derinde olursa olsun ölçülebilir şekilde daha pahalı hale gelir?$$
      AND code_snippet = $$-- Yaklasim A:
SELECT slug FROM topic ORDER BY sort_order LIMIT 20 OFFSET 500;

-- Yaklasim B:
SELECT slug FROM topic WHERE sort_order > 500 ORDER BY sort_order LIMIT 20;$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$sort_order üzerinde bir index varken, bu derse göre, bu iki yaklaşımdan hangisi sonuçlarda bir sayfa ne kadar derinde olursa olsun ölçülebilir şekilde daha pahalı hale gelir?$$,
           $$-- Yaklasim A:
SELECT slug FROM topic ORDER BY sort_order LIMIT 20 OFFSET 500;

-- Yaklasim B:
SELECT slug FROM topic WHERE sort_order > 500 ORDER BY sort_order LIMIT 20;$$, $$sql$$,
           $$Ders, sonuçlarda bir sayfa ne kadar derindeyse OFFSET'in maliyetinin o kadar arttığını açıklar, çünkü PostgreSQL atlanan her satırı taramak ve atmak zorundadır -- sort_order üzerinde bir index varken, Yaklaşım B'nin WHERE koşulu, derinlikten bağımsız olarak doğrudan doğru başlangıç noktasına atlayan bir Index Scan haline gelir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'indexes-and-query-performance-with-explain'
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
    ($$Yaklaşım B (`WHERE sort_order > 500`) -- keyset pagination'ın her zaman OFFSET'ten daha pahalı olduğu tanımlanır$$, FALSE, 0),
    ($$Her iki yaklaşım da sayfa numarası arttıkça birebir aynı şekilde maliyeti artar$$, FALSE, 1),
    ($$Hiçbiri maliyeti artırmaz -- ikisi de aynı `LIMIT 20` ile sınırlıdır, bu da tek ilgili maliyet faktörü olarak tanımlanır$$, FALSE, 2),
    ($$Yaklaşım A (`OFFSET`) -- atlanan her satırı taramak ve atmak zorundadır, Yaklaşım B'nin WHERE tabanlı keyset pagination'ının aksine$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'indexes-and-query-performance-with-explain'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'indexes-and-query-performance-with-explain')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, index'ler ve sorgu performansı hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, index'ler ve sorgu performansı hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (her index'in o tabloya yapılan her INSERT/UPDATE/DELETE'te bir şeye mal olması, bir SELECT üzerindeki EXPLAIN'in hiç göstermediği bir maliyet; ham bir sütun üzerine inşa edilmiş bir index'in, LOWER(sutun) gibi onun dönüştürülmüş bir versiyonu üzerinde filtreleyen bir sorguya yardımcı olmaması -- index'in sorgunun gerçekte filtrelediği aynı ifade üzerine inşa edilmesi gerekir); ders, 'daha fazla index her zaman daha iyidir'in bir yanılgı olduğunu açıkça uyarır (kullanılmayan bir index, planlayıcının bedavaya yok saydığı bir şey değil, hiçbir faydası olmayan saf bir maliyettir), ve EXPLAIN ile EXPLAIN ANALYZE AYNI ŞEYİ göstermez -- biri tahmin eder, diğeri sorguyu gerçekten çalıştırır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'indexes-and-query-performance-with-explain'
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
    ($$Bir index, yalnızca okumalara değil, indexlenmiş tabloya yapılan her `INSERT`/`UPDATE`/`DELETE`'e de ek yük ekler$$, TRUE, 0),
    ($$Ham bir sütun üzerine inşa edilmiş bir index, `LOWER(sutun)` gibi o sütunun dönüştürülmüş bir versiyonu üzerinde filtreleyen bir sorguya yardımcı olmaz$$, TRUE, 1),
    ($$Daha fazla index her zaman daha iyidir, çünkü query planner ihtiyaç duymadığı herhangi bir index'i bedavaya yok sayar$$, FALSE, 2),
    ($$`EXPLAIN` ve `EXPLAIN ANALYZE`, yalnızca biçimlendirmede farklılık göstererek, her zaman birebir aynı çıktıyı üretir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'indexes-and-query-performance-with-explain'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
