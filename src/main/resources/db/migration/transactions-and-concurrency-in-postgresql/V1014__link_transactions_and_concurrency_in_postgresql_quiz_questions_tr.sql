-- Promotion-style migration linking TR transactions-and-concurrency-in-postgresql quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.


-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'transactions-and-concurrency-in-postgresql')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`BEGIN; UPDATE topic SET estimated_minutes = 999 WHERE slug = 'joins'; ROLLBACK;`'den sonra, başka herhangi bir oturum açısından bu UPDATE hakkında ne doğrudur?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$`BEGIN; UPDATE topic SET estimated_minutes = 999 WHERE slug = 'joins'; ROLLBACK;`'den sonra, başka herhangi bir oturum açısından bu UPDATE hakkında ne doğrudur?$$,
           NULL, NULL,
           $$Ders, ROLLBACK'in transaction'ı, hiç çalışmamış gibi, tamamen attığını belirtir -- UPDATE, transaction içinde gerçekti ve okunabilirdi, sonra tamamen geri alındı, başka herhangi bir oturum açısından hiçbir kısmi iz bırakmadan.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'transactions-and-concurrency-in-postgresql'
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
    ($$Hemen uygulanır ama daha sonraki bir arka plan süreci tarafından temizlenmek üzere işaretlenir$$, FALSE, 0),
    ($$Baştan hiç çalıştırılmaz bile, çünkü BEGIN, COMMIT'e kadar hiçbir ifadenin çalışmasını engeller$$, FALSE, 1),
    ($$Hiç olmadı -- `ROLLBACK` onu tamamen atar, hiçbir kısmi iz bırakmaz$$, TRUE, 2),
    ($$Kısmen uygulanır, bazı etkileri hayatta kalırken bazıları kalmaz$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'transactions-and-concurrency-in-postgresql'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'transactions-and-concurrency-in-postgresql')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bu projenin gerçek Flyway migration'larındaki her tek ifadelik `INSERT`, neden hiçbir zaman açık bir `BEGIN`/`COMMIT`e ihtiyaç duymadı?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bu projenin gerçek Flyway migration'larındaki her tek ifadelik `INSERT`, neden hiçbir zaman açık bir `BEGIN`/`COMMIT`e ihtiyaç duymadı?$$,
           NULL, NULL,
           $$Ders, PostgreSQL'in açık bir transaction dışındaki herhangi bir ifadeyi kendi örtük transaction'ına sardığını, başarılı olursa hemen commit ettiğini açıklar -- bu autocommit'tir, ve her tek ifadelik migration'ın zaten kendi tek ifadelik transaction'ı olarak çalışmasının nedeni budur.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'transactions-and-concurrency-in-postgresql'
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
    ($$Flyway migration'larının transactional davranıştan tamamen muaf olduğu tanımlanır$$, FALSE, 0),
    ($$Flyway'in kendisi, ifade veritabanına ulaşmadan önce gerçek COMMIT'i PostgreSQL'in dışında gerçekleştirir$$, FALSE, 1),
    ($$`INSERT` ifadeleri, herhangi bir ilişkisel veritabanı sisteminde hiçbir zaman bir transaction gerektirmez$$, FALSE, 2),
    ($$PostgreSQL, açık bir transaction dışındaki herhangi bir ifadeyi örtük bir transaction'a sarar, başarılı olursa hemen commit eder$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'transactions-and-concurrency-in-postgresql'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'transactions-and-concurrency-in-postgresql')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, MVCC'nin 'PostgreSQL bir satır güncellendiğinde onu asla yerinde üzerine yazmaz' ifadesi gerçekte ne anlama gelir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, MVCC'nin 'PostgreSQL bir satır güncellendiğinde onu asla yerinde üzerine yazmaz' ifadesi gerçekte ne anlama gelir?$$,
           NULL, NULL,
           $$Ders, MVCC'nin, PostgreSQL'in satırın yeni bir versiyonunu yazdığı ve eski versiyonu geçersiz kılınmış olarak işaretlediği, eski versiyona artık kimsenin ihtiyaç duyamayacağı ana kadar ikisini de sakladığı anlamına geldiğini açıklar -- gizli xmin/xmax sistem sütunları aracılığıyla takip edilir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'transactions-and-concurrency-in-postgresql'
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
    ($$PostgreSQL, satırın yeni bir versiyonunu yazar ve eskisini geçersiz kılınmış olarak işaretler, eskisine kimse ihtiyaç duymayana kadar ikisini de saklar$$, TRUE, 0),
    ($$PostgreSQL eski satırı hemen tamamen siler ve onu tamamen ilgisiz yeni bir satırla değiştirir$$, FALSE, 1),
    ($$PostgreSQL, şu anda açık olan her transaction bitene kadar satırı kilitler, ve ancak o zaman fiziksel olarak üzerine yazar$$, FALSE, 2),
    ($$PostgreSQL güncellemeyi ayrı bir log dosyasına kaydeder, gerçek tablonun satırını tamamen dokunulmadan bırakır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'transactions-and-concurrency-in-postgresql'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'transactions-and-concurrency-in-postgresql')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Session A bir transaction başlatıyor ve bir satırı güncelliyor, ama henüz commit etmedi. Session B, eşzamanlı olarak, aynı satırı okuyor. Bu derse göre, Session B bloke olur mu, ve ne görür?$$
      AND code_snippet = $$-- Session A
BEGIN;
UPDATE topic SET estimated_minutes = 500 WHERE slug = 'aggregation-and-group-by';
-- henuz commit edilmedi

-- Session B, eszamanli
SELECT estimated_minutes FROM topic WHERE slug = 'aggregation-and-group-by';$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Session A bir transaction başlatıyor ve bir satırı güncelliyor, ama henüz commit etmedi. Session B, eşzamanlı olarak, aynı satırı okuyor. Bu derse göre, Session B bloke olur mu, ve ne görür?$$,
           $$-- Session A
BEGIN;
UPDATE topic SET estimated_minutes = 500 WHERE slug = 'aggregation-and-group-by';
-- henuz commit edilmedi

-- Session B, eszamanli
SELECT estimated_minutes FROM topic WHERE slug = 'aggregation-and-group-by';$$, $$sql$$,
           $$Ders, PostgreSQL'de okuyucuların hiçbir zaman yazıcıları bloke etmediğini, yazıcıların da hiçbir zaman okuyucuları bloke etmediğini açıkça belirtir -- Session B'nin SELECT'i bloke olmaz, ve Session A'nın commit edilmemiş değişikliğinden önce var olan satır versiyonunu görür, çünkü bir transaction yalnızca commit edilmiş veriyi (ya da kendi commit edilmemiş değişikliklerini) görür.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'transactions-and-concurrency-in-postgresql'
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
    ($$Session B'nin sorgusu doğrudan bir 'satır kilitli' hatasıyla başarısız olur$$, FALSE, 0),
    ($$Session B bloke olmaz, ve orijinal (güncelleme öncesi) değeri görür, çünkü Session A'nın commit edilmemiş değişikliğini göremez$$, TRUE, 1),
    ($$Session B, Session A commit edene ya da rollback yapana kadar bloke olur, çünkü MVCC hâlâ okuyucuların yazıcıları beklemesini gerektirir$$, FALSE, 2),
    ($$Session B bloke olmaz, ama Session A commit etmemiş olsa bile hemen `500`'ü görür$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'transactions-and-concurrency-in-postgresql'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'transactions-and-concurrency-in-postgresql')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu dersin 'A Real FOR UPDATE Scenario' bölümüne göre, bir oku-sonra-yaz işlemini `SELECT ... FOR UPDATE` içine sarmak hangi gerçek problemi önler?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu dersin 'A Real FOR UPDATE Scenario' bölümüne göre, bir oku-sonra-yaz işlemini `SELECT ... FOR UPDATE` içine sarmak hangi gerçek problemi önler?$$,
           NULL, NULL,
           $$Ders, FOR UPDATE olmadan, iki eşzamanlı transaction'ın ikisinin de aynı değeri okuyabileceğini, ikisinin de aynı 'sonraki' değeri bağımsız olarak hesaplayabileceğini, ve ikisinin de onu yazabileceğini açıklar -- bir lost update, çünkü ikinci yazma, hiçbiri diğerinin olduğunu bilmeden ilkinin üzerine sessizce yazar.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'transactions-and-concurrency-in-postgresql'
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
    ($$İki transaction aynı anda birebir aynı `UPDATE` ifadesini çalıştırdığında oluşan bir SQL sözdizimi hatası$$, FALSE, 0),
    ($$Beklenmedik bir sunucu çökmesinin ardından diskten kalıcı veri kaybı$$, FALSE, 1),
    ($$Bir lost update (kayıp güncelleme) -- iki eşzamanlı transaction'ın aynı 'sonraki' değeri hesaplaması, ikinci yazmanın ilkinin üzerine sessizce yazması$$, TRUE, 2),
    ($$Aynı işlemi deneyen iki eşzamanlı transaction arasında bir deadlock$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'transactions-and-concurrency-in-postgresql'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'transactions-and-concurrency-in-postgresql')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir deadlock üreten bu sıralama göz önüne alındığında, PostgreSQL döngüsel beklemeyi tespit ettiğinde ne yapar?$$
      AND code_snippet = $$-- Session A
BEGIN;
UPDATE topic SET estimated_minutes = 3 WHERE slug = 'select-and-filtering';

-- Session B, eszamanli
BEGIN;
UPDATE topic SET estimated_minutes = 3 WHERE slug = 'sorting-limiting-and-pagination';

-- Session A, sonraki
UPDATE topic SET estimated_minutes = 4 WHERE slug = 'sorting-limiting-and-pagination';
-- Session B'nin kilidini bekleyerek bloke olur

-- Session B, sonraki
UPDATE topic SET estimated_minutes = 4 WHERE slug = 'select-and-filtering';
-- Session A'nin kilidini bekleyerek o da bloke olurdu$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir deadlock üreten bu sıralama göz önüne alındığında, PostgreSQL döngüsel beklemeyi tespit ettiğinde ne yapar?$$,
           $$-- Session A
BEGIN;
UPDATE topic SET estimated_minutes = 3 WHERE slug = 'select-and-filtering';

-- Session B, eszamanli
BEGIN;
UPDATE topic SET estimated_minutes = 3 WHERE slug = 'sorting-limiting-and-pagination';

-- Session A, sonraki
UPDATE topic SET estimated_minutes = 4 WHERE slug = 'sorting-limiting-and-pagination';
-- Session B'nin kilidini bekleyerek bloke olur

-- Session B, sonraki
UPDATE topic SET estimated_minutes = 4 WHERE slug = 'select-and-filtering';
-- Session A'nin kilidini bekleyerek o da bloke olurdu$$, $$sql$$,
           $$Ders, PostgreSQL'in her iki oturumun sonsuza kadar beklemesine izin vermek yerine bu döngüyü aktif olarak tespit ettiğini açıklar -- bir transaction (genellikle geri almanın daha ucuz olacağı 'kurban') gerçek bir 'deadlock detected' hatası alır ve kilitlerini serbest bırakarak diğer transaction'ın ilerleyebilmesi için otomatik olarak rollback yapılır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'transactions-and-concurrency-in-postgresql'
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
    ($$Her iki transaction da bir veritabanı yöneticisi elle müdahale edene kadar süresiz olarak bekler$$, FALSE, 0),
    ($$PostgreSQL, iki transaction'ın güncellemelerini otomatik olarak tek, birleşik bir transaction'a birleştirir$$, FALSE, 1),
    ($$Her iki transaction da, hiçbir oturuma hiçbir hata raporlanmadan aynı anda sessizce rollback yapılır$$, FALSE, 2),
    ($$Bir transaction 'deadlock detected' hatası alır ve kilitlerini diğeri için serbest bırakarak otomatik olarak rollback yapılır$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'transactions-and-concurrency-in-postgresql'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'transactions-and-concurrency-in-postgresql')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, transaction'lar ve concurrency hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, transaction'lar ve concurrency hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (SELECT ... FOR UPDATE'in yalnızca döndürdüğü spesifik satırları kilitlemesi, tüm tabloyu değil -- MVCC'nin sıradan okumaların kimse için hiçbir şeyi asla kilitlememesi anlamına gelmesi; bu dersin deadlock örneğinin çözümünün bir veritabanı ayarı değil, birden fazla satırı her zaman aynı, tutarlı sırada kilitleme kodlama disiplini olması); ders, MVCC'nin kilitlere ne sıklıkla ihtiyaç duyulduğunu azalttığını ama aynı satır üzerindeki gerçek yazma-yazma çakışmalarının hâlâ row-level kilitlemeye ihtiyaç duyduğunu açıkça belirtir (MVCC kilit ihtiyacını tamamen ortadan kaldırmaz), ve client'ı basitçe bağlantısını kesen commit edilmemiş bir transaction'ın da otomatik olarak rollback yapıldığını, belirsizlikte bırakılmadığını belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'transactions-and-concurrency-in-postgresql'
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
    ($$`SELECT ... FOR UPDATE`, yalnızca döndürdüğü spesifik satırları kilitler, tüm tabloyu değil$$, TRUE, 0),
    ($$Bu dersin deadlock örneğinin çözümü, bir veritabanı ayarı değil, birden fazla satırı her zaman aynı, tutarlı sırada kilitleme kodlama disiplinidir$$, TRUE, 1),
    ($$MVCC, PostgreSQL'in herhangi bir amaç için asla row-level kilitlere ihtiyaç duymadığı anlamına gelir$$, FALSE, 2),
    ($$Client'ı basitçe bağlantısını kesen commit edilmemiş bir transaction, ne commit edilmiş ne rollback yapılmış belirsiz bir durumda bırakılır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'transactions-and-concurrency-in-postgresql'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
