-- Promotion-style migration linking TR persistence-context-and-locking quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'persistence-context-and-locking')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir entity'nin transaction'ı henüz sona erdi, bu yüzden persistence context artık onu takip etmiyor, ama alan değişiklikleri hâlâ takip edilirken zaten yapılmıştı. Şu an hangi durumdadır?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir entity'nin transaction'ı henüz sona erdi, bu yüzden persistence context artık onu takip etmiyor, ama alan değişiklikleri hâlâ takip edilirken zaten yapılmıştı. Şu an hangi durumdadır?$$,
           NULL, NULL,
           $$DETACHED -- persistence context artık onu takip etmiyor, bu yüzden sonraki alan değişiklikleri artık otomatik olarak geri yazılmıyor.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'persistence-context-and-locking'
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
    ($$REMOVED$$, FALSE, 0),
    ($$DETACHED$$, TRUE, 1),
    ($$TRANSIENT$$, FALSE, 2),
    ($$MANAGED$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'persistence-context-and-locking'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'persistence-context-and-locking')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Tek bir transaction içinde, bu iki çağrı da çalıştırılıyor. Gerçekte kaç veritabanı sorgusu çalışır?$$
      AND code_snippet = $$Konu birinci = repository.findById(5L).get();
Konu ikinci = repository.findById(5L).get();

System.out.println(birinci == ikinci);$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Tek bir transaction içinde, bu iki çağrı da çalıştırılıyor. Gerçekte kaç veritabanı sorgusu çalışır?$$,
           $$Konu birinci = repository.findById(5L).get();
Konu ikinci = repository.findById(5L).get();

System.out.println(birinci == ikinci);$$, $$java$$,
           $$Yalnızca bir sorgu -- first-level cache, 5 numaralı entity'nin zaten takip edildiğini tanır ve ikinci çağrı için tam olarak aynı instance'ı geri verir, bu yüzden birinci == ikinci true yazdırır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'persistence-context-and-locking'
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
    ($$İki sorgu, ama birinci == ikinci yine de true yazdırır, çünkü Java her zaman eşit nesneleri önbelleğe alır$$, FALSE, 0),
    ($$Sıfır sorgu -- Spring Data JPA bir findById çağrısı için hiçbir zaman gerçekten veritabanına gitmez$$, FALSE, 1),
    ($$Bir sorgu -- ikinci çağrı tamamen first-level cache'den yanıtlanır, ve birinci == ikinci true yazdırır$$, TRUE, 2),
    ($$İki sorgu, ve birinci == ikinci false yazdırır, çünkü ikisi iki ayrı nesne instance'ıdır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'persistence-context-and-locking'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'persistence-context-and-locking')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Zaten gerçek bir id'ye sahip ama şu anda takip edilmeyen, detached bir entity'nin yeniden bağlanıp güncellenmesi gerekiyor. Hangi işlem doğrudur?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Zaten gerçek bir id'ye sahip ama şu anda takip edilmeyen, detached bir entity'nin yeniden bağlanıp güncellenmesi gerekiyor. Hangi işlem doğrudur?$$,
           NULL, NULL,
           $$merge() -- nesnenin alan değerlerini managed bir entity'ye kopyalar ve O managed entity'yi döndürür; persist(), veritabanında hiç var olmamış entity'ler için olduğundan duplicate-key hatası riski taşır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'persistence-context-and-locking'
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
    ($$persist(), çünkü herhangi bir entity'yi yönetim altına almanın genel amaçlı yoludur$$, FALSE, 0),
    ($$Aynı alan değerleriyle hemen ardından yeni bir persist() izleyen remove()$$, FALSE, 1),
    ($$Entity'yi bir sonraki sorguda otomatik olarak yeniden bağlayan detach()$$, FALSE, 2),
    ($$merge() -- nesnenin alan değerlerini managed bir entity'ye kopyalar ve o managed entity'yi döndürür$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'persistence-context-and-locking'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'persistence-context-and-locking')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Managed bir entity'de bir alanın değeri değiştiriliyor, sonra aynı alanı filtreleyen bir JPQL sorgusu, flush() hiç açıkça çağrılmadan çalıştırılıyor. Ne olur?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Managed bir entity'de bir alanın değeri değiştiriliyor, sonra aynı alanı filtreleyen bir JPQL sorgusu, flush() hiç açıkça çağrılmadan çalıştırılıyor. Ne olur?$$,
           NULL, NULL,
           $$Hibernate, bekleyen değişikliklerden etkilenebilecek bir sorgu çalıştırmadan önce otomatik flush yapar, bu yüzden sorgunun sonucu değişikliği yansıtır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'persistence-context-and-locking'
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
    ($$Hibernate, bekleyen değişikliklerden etkilenebilecek bir sorgu çalıştırmadan önce otomatik flush yaptığı için, sorgunun sonucu değişikliği yansıtır$$, TRUE, 0),
    ($$Sorgunun sonucu değişikliği tamamen yok sayar, çünkü hiç açıkça flush edilmedi$$, FALSE, 1),
    ($$Sorgu çalıştığında bekleyen bir değişiklik olduğu için uygulama bir istisna fırlatır$$, FALSE, 2),
    ($$Değişiklik sessizce atılır ve alan önceki değerine döner$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'persistence-context-and-locking'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'persistence-context-and-locking')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir entity'nin alanına @Version eklemek gerçekte ne yapar?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir entity'nin alanına @Version eklemek gerçekte ne yapar?$$,
           NULL, NULL,
           $$Hibernate bunu tamamen kendi başına yönetir -- her UPDATE onu artırır ve her UPDATE'in WHERE koşulu, entity'nin yüklendiği değerle hâlâ eşleştiğini kontrol eder.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'persistence-context-and-locking'
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
    ($$Aynı satırın aynı anda birden fazla transaction tarafından okunmasını engeller$$, FALSE, 0),
    ($$Hibernate her UPDATE'te onu artırır ve her UPDATE'in WHERE koşulu, yüklenen değerle hâlâ eşleştiğini kontrol eder$$, TRUE, 1),
    ($$Satır okunduğu andan transaction bitene kadar üzerinde gerçek bir veritabanı kilidi tutar$$, FALSE, 2),
    ($$Uygulamanın her save çağrısından önce onu elle artırmasını gerektirir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'persistence-context-and-locking'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'persistence-context-and-locking')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$kullaniciAYukledi ve kullaniciBYukledi, @Version korumalı aynı satırı version = 3'te yüklüyor. Kullanıcı A önce kaydediyor ve başarılı oluyor, satır version = 4'e geçiyor. Kullanıcı B sonra, hâlâ version'ın 3 olduğuna inanarak kaydetmeye çalışıyor. Ne olur?$$
      AND code_snippet = $$// İkisi de version = 3'te yüklendi
kullaniciA.kaydet(kullaniciAYukledi); // basarili, satir simdi version = 4
kullaniciB.kaydet(kullaniciBYukledi); // Kullanici B'nin WHERE kosulu hala version = 3'u kontrol ediyor$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$kullaniciAYukledi ve kullaniciBYukledi, @Version korumalı aynı satırı version = 3'te yüklüyor. Kullanıcı A önce kaydediyor ve başarılı oluyor, satır version = 4'e geçiyor. Kullanıcı B sonra, hâlâ version'ın 3 olduğuna inanarak kaydetmeye çalışıyor. Ne olur?$$,
           $$// İkisi de version = 3'te yüklendi
kullaniciA.kaydet(kullaniciAYukledi); // basarili, satir simdi version = 4
kullaniciB.kaydet(kullaniciBYukledi); // Kullanici B'nin WHERE kosulu hala version = 3'u kontrol ediyor$$, $$java$$,
           $$Kullanıcı B'nin UPDATE ... WHERE version = 3'ü artık sıfır satırla eşleşir -- Spring Data JPA bunu, sessizce hiçbir şey yapmak ya da Kullanıcı A'nın değişikliğinin üzerine yazmak yerine bir OptimisticLockingFailureException olarak yüzeye çıkarır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'persistence-context-and-locking'
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
    ($$Kullanıcı B'nin kaydı normal şekilde başarılı olur, çünkü @Version yalnızca bir satırın ilk kaydında kontrol yapar$$, FALSE, 0),
    ($$Her iki kayıt da otomatik olarak alan alan tek bir son satırda birleştirilir$$, FALSE, 1),
    ($$Kullanıcı B'nin kaydı bir OptimisticLockingFailureException fırlatır, çünkü WHERE ... AND version = 3'ü artık hiçbir şeyle eşleşmez$$, TRUE, 2),
    ($$Kullanıcı B'nin kaydı, Kullanıcı A'nın değişikliğinin sessizce üzerine yazar, satır Kullanıcı B'nin değerleriyle sonuçlanır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'persistence-context-and-locking'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'persistence-context-and-locking')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri @Lock(LockModeType.PESSIMISTIC_WRITE)'ı doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri @Lock(LockModeType.PESSIMISTIC_WRITE)'ı doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Okuma anında, PostgreSQL'in SELECT ... FOR UPDATE'ini kullanarak gerçek bir veritabanı seviyesi kilit ekler, diğer transaction'ları bekletir -- gerçekten yüksek çekişmeli işlemler için tercih edilmeli, optimistic locking'in yerine varsayılan olarak değil.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'persistence-context-and-locking'
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
    ($$Okuma anında, PostgreSQL'in SELECT ... FOR UPDATE'ini kullanarak gerçek bir veritabanı seviyesi kilit ekler$$, TRUE, 0),
    ($$Her entity için @Version'ın yerine varsayılan kilitleme stratejisi olmalıdır$$, FALSE, 1),
    ($$@Version'ın yaptığı gibi, bir çakışmayı gerçekleştikten sonra tespit eder$$, FALSE, 2),
    ($$Aynı satırda aynı kilidi almaya çalışan başka herhangi bir transaction, bu işlem commit ya da rollback olana kadar bekler$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'persistence-context-and-locking'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
