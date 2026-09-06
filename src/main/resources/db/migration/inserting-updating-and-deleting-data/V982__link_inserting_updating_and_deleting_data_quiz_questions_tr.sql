-- Promotion-style migration linking TR inserting-updating-and-deleting-data quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.


-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'inserting-updating-and-deleting-data')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`INSERT INTO course (name, slug, sort_order) VALUES ('PostgreSQL', 'postgresql', 5);` içinde, hangi değerin hangi sütuna atanacağını ne belirler?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$`INSERT INTO course (name, slug, sort_order) VALUES ('PostgreSQL', 'postgresql', 5);` içinde, hangi değerin hangi sütuna atanacağını ne belirler?$$,
           NULL, NULL,
           $$Ders, parantezlerdeki sütun sırasının, onu izleyen değer sırasıyla eşleşmesi gerektiğini belirtir -- ilk adlandırılan sütun ilk değeri alır, ve böyle devam eder; tamamen atlanan herhangi bir sütun (id gibi) varsayılanını alır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'inserting-updating-and-deleting-data'
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
    ($$Sütunların, INSERT'in kendi sütun listesini yok sayarak, tablonun `CREATE TABLE` ifadesinde orijinal olarak tanımlandığı sıra$$, FALSE, 0),
    ($$PostgreSQL, değerleri sütunlara konuma göre değil, otomatik olarak veri tipine göre eşler$$, FALSE, 1),
    ($$Konum -- parantezlerdeki sütunların sırası, onu izleyen değerlerin sırasıyla eşleşmelidir$$, TRUE, 2),
    ($$İfadede nasıl listelendiklerinden bağımsız olarak, sütun adlarının alfabetik sırası$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'inserting-updating-and-deleting-data'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'inserting-updating-and-deleting-data')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, `UPDATE`/`DELETE` neden bir `WHERE` ifadesine ihtiyaç duyar?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `UPDATE`/`DELETE` neden bir `WHERE` ifadesine ihtiyaç duyar?$$,
           NULL, NULL,
           $$Ders, SQL'de yalnızca 'mevcut satırı' etkilemek diye bir kavram olmadığını belirtir -- WHERE'i atlamak, hiçbir onay istemi olmadan, tablodaki her satırı hemen hedefler; bir WHERE ifadesi, hangi spesifik satırların etkilendiğini daraltan şeydir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'inserting-updating-and-deleting-data'
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
    ($$Opsiyoneldir ve tamamen biçimseldir -- atlamak yalnızca tek, belirsiz bir 'mevcut' satırı etkiler$$, FALSE, 0),
    ($$PostgreSQL sözdizimsel olarak `WHERE` gerektirir -- onsuz bir ifade basitçe ayrıştırılamaz$$, FALSE, 1),
    ($$`WHERE` yalnızca `DELETE` için gereklidir, `UPDATE` için değil$$, FALSE, 2),
    ($$Bu olmadan, hiçbir onay istemi olmadan tablodaki her satır hemen etkilenir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'inserting-updating-and-deleting-data'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'inserting-updating-and-deleting-data')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu gerçek migration kalıbı göz önüne alındığında, `slug = 'postgresql-foundations'` olan hiçbir `category` satırı yoksa `INSERT`'e ne olur?$$
      AND code_snippet = $$INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'aggregation-and-group-by', 'INTERMEDIATE', 20, 10
FROM category
WHERE slug = 'olmayan-kategori';$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu gerçek migration kalıbı göz önüne alındığında, `slug = 'postgresql-foundations'` olan hiçbir `category` satırı yoksa `INSERT`'e ne olur?$$,
           $$INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'aggregation-and-group-by', 'INTERMEDIATE', 20, 10
FROM category
WHERE slug = 'olmayan-kategori';$$, $$sql$$,
           $$Ders, INSERT ... SELECT'in SELECT'inin sıfır satır döndürebileceğini (hiçbir şeyle eşleşmeyen bir slug) açıkça uyarır -- INSERT o zaman hiçbir hata olmadan sessizce sıfır satır ekler, bu bir VALUES literalindeki bir yazım hatasından çok daha sessiz bir başarısızlıktır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'inserting-updating-and-deleting-data'
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
    ($$`INSERT`, hiçbir hata olmadan sessizce sıfır satır ekler$$, TRUE, 0),
    ($$`INSERT`, spesifik bir 'eşleşen kategori yok' hatasıyla başarısız olur$$, FALSE, 1),
    ($$`INSERT` yine de bir satır ekler, `category_id`'yi `NULL` olarak ayarlar$$, FALSE, 2),
    ($$PostgreSQL, `INSERT`'i tamamlamadan önce o slug'a sahip yeni bir `category` satırı otomatik olarak oluşturur$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'inserting-updating-and-deleting-data'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'inserting-updating-and-deleting-data')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu ifade göz önüne alındığında, PostgreSQL'in yeni satırın üretilen `id`'sini elde etmek için ayrı, takip eden bir `SELECT`'e ihtiyacı var mı?$$
      AND code_snippet = $$INSERT INTO course (name, slug, sort_order)
VALUES ('PostgreSQL', 'postgresql', 5)
RETURNING id;$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu ifade göz önüne alındığında, PostgreSQL'in yeni satırın üretilen `id`'sini elde etmek için ayrı, takip eden bir `SELECT`'e ihtiyacı var mı?$$,
           $$INSERT INTO course (name, slug, sort_order)
VALUES ('PostgreSQL', 'postgresql', 5)
RETURNING id;$$, $$sql$$,
           $$Ders, RETURNING'in ikinci bir sorgu çalıştırmadığını açıkça belirtir -- aynı tek ifadedir, yazmayı gerçekleştirirken zaten hesapladığı veriyi döndürür, PostgreSQL'in BIGSERIAL aracılığıyla az önce ürettiği id'yi, onu ayrı sorgulamak için bir gidiş-dönüş olmadan hemen geri verir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'inserting-updating-and-deleting-data'
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
    ($$`RETURNING id`, bir `INSERT` ifadesinde geçersiz sözdizimidir -- yalnızca `UPDATE`/`DELETE` üzerinde çalışır$$, FALSE, 0),
    ($$Hayır -- `RETURNING id`, üretilen id'yi aynı tek ifadenin parçası olarak, ekstra bir gidiş-dönüş olmadan geri verir$$, TRUE, 1),
    ($$Evet -- `RETURNING`, PostgreSQL'in hemen ardından otomatik olarak gizli bir `SELECT` çalıştırmasını tetikler$$, FALSE, 2),
    ($$Evet -- `RETURNING`, yalnızca hemen ardından ayrı bir `SELECT id FROM course WHERE ...` verilirse çalışır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'inserting-updating-and-deleting-data'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'inserting-updating-and-deleting-data')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bu projenin kendi Flyway migration'ları neden hiçbir zaman `ON CONFLICT` kullanmaz?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bu projenin kendi Flyway migration'ları neden hiçbir zaman `ON CONFLICT` kullanmaz?$$,
           NULL, NULL,
           $$Ders, Flyway'in her numaralı migration'ın veritabanı başına tam olarak bir kez, sırayla çalışmasını garanti ettiğini, ve değişikliğe karşı checksum'landığını açıklar -- bu yüzden bir satır ekleyen bir migration, onun henüz var olmadığını güvenle varsayabilir; ele alınacak bir çakışma yoktur çünkü Flyway'in kendisi bunu önleyen mekanizmadır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'inserting-updating-and-deleting-data'
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
    ($$Bu projenin migration'larının, `ON CONFLICT`e ihtiyaç duymamayı tesadüfen sağlayan gerçek bir hata içerdiği tanımlanır$$, FALSE, 0),
    ($$`ON CONFLICT` yalnızca `UPDATE` ifadeleriyle çalışır, `INSERT` ile asla çalışmaz$$, FALSE, 1),
    ($$Flyway, her migration'ın veritabanı başına tam olarak bir kez çalışmasını garanti eder, bu yüzden zaten ele alınacak bir çakışma yoktur$$, TRUE, 2),
    ($$`ON CONFLICT`, bu spesifik PostgreSQL sürümünün desteklemediği bir özelliktir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'inserting-updating-and-deleting-data'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'inserting-updating-and-deleting-data')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu ifade göz önüne alındığında, `(kurs_id=5, slug='pg-temelleri')` olan bir `category` satırı zaten `ad = 'Eski Ad'` ile mevcutsa, `EXCLUDED.ad` neye atıfta bulunur?$$
      AND code_snippet = $$INSERT INTO category (kurs_id, ad, slug, sira)
VALUES (5, 'PostgreSQL Temelleri', 'pg-temelleri', 1)
ON CONFLICT (kurs_id, slug)
DO UPDATE SET ad = EXCLUDED.ad;$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu ifade göz önüne alındığında, `(kurs_id=5, slug='pg-temelleri')` olan bir `category` satırı zaten `ad = 'Eski Ad'` ile mevcutsa, `EXCLUDED.ad` neye atıfta bulunur?$$,
           $$INSERT INTO category (kurs_id, ad, slug, sira)
VALUES (5, 'PostgreSQL Temelleri', 'pg-temelleri', 1)
ON CONFLICT (kurs_id, slug)
DO UPDATE SET ad = EXCLUDED.ad;$$, $$sql$$,
           $$Ders, EXCLUDED'in mevcut satıra değil, eklenmek üzere olan satıra atıfta bulunduğunu açıklar -- bu yüzden EXCLUDED.ad, VALUES ifadesinden gelen yeni 'PostgreSQL Temelleri' değeridir, ve bu ifade çalıştıktan sonra, mevcut satırın adı 'Eski Ad'dan 'PostgreSQL Temelleri'ne güncellenir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'inserting-updating-and-deleting-data'
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
    ($$Mevcut satırın şu anki değeri, `'Eski Ad'` -- `EXCLUDED`, tabloda zaten var olan satıra atıfta bulunur$$, FALSE, 0),
    ($$Hiçbir şey -- `EXCLUDED` yalnızca bir `DO NOTHING` ifadesi içinde geçerlidir, `DO UPDATE` içinde değil$$, FALSE, 1),
    ($$Her iki değerin tek bir birleştirilmiş dizgede birleşimi$$, FALSE, 2),
    ($$VALUES ifadesinden gelen yeni değer, `'PostgreSQL Temelleri'` -- `EXCLUDED`, eklenmek üzere olan satıra atıfta bulunur$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'inserting-updating-and-deleting-data'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'inserting-updating-and-deleting-data')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, INSERT/UPDATE/DELETE hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, INSERT/UPDATE/DELETE hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (`ON CONFLICT`'in yalnızca adı geçen spesifik sütun(lar) üzerindeki bir UNIQUE/PRIMARY KEY/EXCLUDE ihlalini yakalaması -- bir NOT NULL ya da foreign key ihlalinin ifadeyi hâlâ doğrudan başarısız kılması; WHERE'siz `DELETE FROM table`'ın satırları teker teker kaldırması ve trigger'ları tetiklemesi, TRUNCATE TABLE'ın daha hızlı, tamamen yapısal işleminin aksine); ders açıkça bir foreign key'in sayısal id'sini sabit kodlamak yerine INSERT...SELECT'i önerir (tersini değil), ve RETURNING'in yalnızca INSERT'te değil, UPDATE ve DELETE'te de birebir aynı şekilde çalıştığını belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'inserting-updating-and-deleting-data'
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
    ($$`ON CONFLICT`, yalnızca adı geçen spesifik sütun(lar) üzerindeki bir `UNIQUE`/`PRIMARY KEY`/`EXCLUDE` ihlalini yakalar -- bir `NOT NULL` ihlali ifadeyi hâlâ doğrudan başarısız kılar$$, TRUE, 0),
    ($$WHERE'siz `DELETE FROM table`, satırları teker teker kaldırır ve trigger'ları tetikler, daha hızlı, tamamen yapısal `TRUNCATE TABLE`'ın aksine$$, TRUE, 1),
    ($$Bu ders, `INSERT ... SELECT` kalıbını kullanmak yerine, bir foreign key'in sayısal id'sini doğrudan sabit kodlamayı önerir$$, FALSE, 2),
    ($$`RETURNING` yalnızca `INSERT` ifadelerinde çalışır, `UPDATE` ya da `DELETE`'te çalışmaz$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'inserting-updating-and-deleting-data'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
