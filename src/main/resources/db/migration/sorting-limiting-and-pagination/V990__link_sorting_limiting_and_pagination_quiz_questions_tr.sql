-- Promotion-style migration linking TR sorting-limiting-and-pagination quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 6 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.


-- Question 1/6 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'sorting-limiting-and-pagination')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bir `ORDER BY` olmadan, PostgreSQL döndürülen satırların sırası hakkında ne garanti eder?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir `ORDER BY` olmadan, PostgreSQL döndürülen satırların sırası hakkında ne garanti eder?$$,
           NULL, NULL,
           $$Ders açıktır: ORDER BY olmadan, PostgreSQL satır sırası hakkında hiçbir söz vermez -- ne ekleme sırası, ne primary key sırası, gerçekten belirsizdir, ve birebir aynı sorgunun çalıştırmaları arasında değişebilir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'sorting-limiting-and-pagination'
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
    ($$Satırlar her zaman primary key'lerinin artan sırasında döndürülür$$, FALSE, 0),
    ($$Satırlar her zaman SELECT ifadesinde listelendikleri sütun sırasında döndürülür$$, FALSE, 1),
    ($$Hiçbir şey -- satır sırası gerçekten belirsizdir ve birebir aynı sorgunun çalıştırmaları arasında değişebilir$$, TRUE, 2),
    ($$Satırlar her zaman orijinal olarak eklendikleri sırada döndürülür$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'sorting-limiting-and-pagination'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'sorting-limiting-and-pagination')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`ORDER BY difficulty ASC, sort_order DESC` içinde, ikinci sıralama anahtarı bu derse göre gerçekte nasıl uygulanır?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`ORDER BY difficulty ASC, sort_order DESC` içinde, ikinci sıralama anahtarı bu derse göre gerçekte nasıl uygulanır?$$,
           NULL, NULL,
           $$Ders, sıralamanın soldan sağa uygulandığını belirtir: satırlar önce difficulty'ye göre gruplanır, ve yalnızca aynı difficulty değerini paylaşan satırlar İÇİNDE sort_order'a göre sıralanır -- ikinci sütun yalnızca ilkinin bıraktığı beraberlikleri bozar, tüm sonucu bağımsız olarak yeniden sıralamaz.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'sorting-limiting-and-pagination'
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
    ($$Her iki sütun da tamamen bağımsız olarak uygulanır, her biri tüm sonuç kümesini ayrı ayrı yeniden sıralar$$, FALSE, 0),
    ($$Yalnızca `difficulty`'nin gerçek bir etkisi vardır -- ondan sonra ikinci bir ORDER BY sütunu listelemek sessizce yok sayılır$$, FALSE, 1),
    ($$`sort_order` önce uygulanır, ve `difficulty` yalnızca kalan beraberlikleri bozar$$, FALSE, 2),
    ($$`sort_order`, yalnızca zaten aynı `difficulty` değerini paylaşan satırlar içindeki beraberlikleri bozar -- her şeyi bağımsız olarak yeniden sıralamaz$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'sorting-limiting-and-pagination'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'sorting-limiting-and-pagination')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$3'lük bir sayfa boyutu göz önüne alındığında, bu dersin sayfalama kalıbına göre bu sorgu ne döndürür?$$
      AND code_snippet = $$SELECT slug FROM topic
ORDER BY sort_order
LIMIT 3 OFFSET 3;$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$3'lük bir sayfa boyutu göz önüne alındığında, bu dersin sayfalama kalıbına göre bu sorgu ne döndürür?$$,
           $$SELECT slug FROM topic
ORDER BY sort_order
LIMIT 3 OFFSET 3;$$, $$sql$$,
           $$Ders, s sayfa boyutuyla n (sıfır indeksli) sayfası için OFFSET'in n * s olduğunu açıklar -- LIMIT 3 ile OFFSET 3, sayfa 2'dir (3'lük satırların ikinci grubu), ilk 3 satırı (sayfa 1) atlar ve sonraki 3'ü döndürür.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'sorting-limiting-and-pagination'
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
    ($$Sayfa 2 -- `sort_order`'daki 4., 5. ve 6. satırlar, ilk 3'ü atlayarak$$, TRUE, 0),
    ($$Sayfa 1 -- `sort_order`'daki en ilk 3 satır$$, FALSE, 1),
    ($$Sayfa 4 -- `sort_order`'daki 10., 11. ve 12. satırlar$$, FALSE, 2),
    ($$Satır 3'ten tablonun sonuna kadar, üst sınır olmadan tüm satırlar$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'sorting-limiting-and-pagination'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'sorting-limiting-and-pagination')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$PostgreSQL'in varsayılan sıralama davranışına göre, bu sorguda `estimated_minutes`'taki `NULL` değerleri nerede sona erer?$$
      AND code_snippet = $$SELECT slug, estimated_minutes FROM topic
ORDER BY estimated_minutes ASC;$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$PostgreSQL'in varsayılan sıralama davranışına göre, bu sorguda `estimated_minutes`'taki `NULL` değerleri nerede sona erer?$$,
           $$SELECT slug, estimated_minutes FROM topic
ORDER BY estimated_minutes ASC;$$, $$sql$$,
           $$Ders, PostgreSQL'in varsayılan olarak NULL değerlerini herhangi bir gerçek değerden daha büyük sıraladığını belirtir, bu da sade bir ORDER BY'ın artan sırada her NULL'u SONA yerleştirdiği anlamına gelir -- azalan sırada tam tersi doğru olurdu, NULL'lar önce sıralanırdı.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'sorting-limiting-and-pagination'
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
    ($$PostgreSQL, açıkça NULLS LAST belirtilmeden nullable bir sütunu ORDER BY yapmaya çalışırken bir hata verir$$, FALSE, 0),
    ($$Sonuçun sonunda -- PostgreSQL, artan sırada NULL'u varsayılan olarak herhangi bir gerçek değerden daha büyük sıralar$$, TRUE, 1),
    ($$Sonuçun başında -- NULL, ASC ya da DESC'ten bağımsız olarak her zaman önce sıralanır$$, FALSE, 2),
    ($$Artan sırada sıralarken NULL satırları sonuçtan tamamen sessizce hariç tutulur$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'sorting-limiting-and-pagination'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'sorting-limiting-and-pagination')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$'The Cost of OFFSET on Large Tables'a göre, `OFFSET 100000` o satırları bedavaya mı atlar?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$'The Cost of OFFSET on Large Tables'a göre, `OFFSET 100000` o satırları bedavaya mı atlar?$$,
           NULL, NULL,
           $$Ders, OFFSET'in satırları bedavaya atlamadığını açıkça belirtir -- PostgreSQL, gerçekten istenen satırları döndürmeye başlamadan önce hâlâ her birini taramak ve atmak zorundadır, bu yüzden OFFSET 100000, ikisi de aynı sayıda satır döndürse bile, OFFSET 10'dan anlamlı derecede daha fazla iş yapar.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'sorting-limiting-and-pagination'
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
    ($$Evet, ama yalnızca belirli sabit bir satır-sayısı eşiğinden küçük tablolar için$$, FALSE, 0),
    ($$Bu ders, OFFSET'in herhangi bir performans maliyeti olup olmadığını hiç ele almaz$$, FALSE, 1),
    ($$Hayır -- PostgreSQL önce atlanan her satırı taramak ve atmak zorundadır, bu yüzden daha büyük bir offset anlamlı derecede daha fazla iş yapar$$, TRUE, 2),
    ($$Evet -- PostgreSQL'in, sıfır ekstra maliyetle herhangi bir offset'e doğrudan atlamasını sağlayan içsel bir indexi vardır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'sorting-limiting-and-pagination'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'sorting-limiting-and-pagination')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, pagination hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, pagination hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (Pageable'ın LIMIT/OFFSET'ten hiçbir zaman ayrı bir mekanizma olmaması -- PageRequest.of(page, size, sort)'un doğrudan LIMIT size OFFSET page*size artı bir ORDER BY hesaplaması, ve Spring Data JPA'nın Page<T>'nin toplamları için arka planda ikinci bir SELECT count(*) de çalıştırması; LIMIT/OFFSET'in yalnızca açık bir ORDER BY ile eşleştirildiğinde anlamlı olması, çünkü biri olmadan 'ilk N' ve 'sonraki N' iyi tanımlanmış kavramlar değildir); ders, ORDER BY olmadan sade bir LIMIT'i tekrarlanan çalıştırmalar arasında deterministik olmayan olarak açıkça adlandırır (güvenilir şekilde 'ilk N' satır değil), ve keyset pagination'ı -- bu derste derinlemesine ele alınmayan bir şey -- daha sonra 'Indexes and Query Performance with EXPLAIN'de düzgünce ele alınan daha hızlı alternatif olarak adlandırır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'sorting-limiting-and-pagination'
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
    ($$`LIMIT`/`OFFSET` yalnızca açık bir `ORDER BY` ile eşleştirildiğinde anlamlıdır, çünkü biri olmadan satır sırası (ve dolayısıyla 'ilk N') tanımsızdır$$, TRUE, 0),
    ($$ORDER BY olmadan sade bir `LIMIT`, tekrarlanan çalıştırmalar arasında güvenilir şekilde deterministik olarak, her zaman aynı 'ilk N' satırları döndürerek tanımlanır$$, FALSE, 1),
    ($$Bu ders, `OFFSET` tabanlı sayfalama yerine, birincil pagination tekniği olarak keyset pagination'ı tam derinlikte ele alır$$, FALSE, 2),
    ($$`Pageable`'ın `PageRequest.of(page, size, sort)`'u doğrudan `LIMIT size OFFSET page * size` artı bir `ORDER BY` hesaplar -- ham SQL pagination'dan ayrı bir mekanizma değildir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'sorting-limiting-and-pagination'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
