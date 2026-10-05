-- Links the TR threads questions to the topic's fixed quiz. Same NOT EXISTS /
-- ON CONFLICT DO NOTHING pattern as every prior quiz-link migration: each question is
-- found by its text (or created if missing) and linked at its position, so the file is
-- safe on a fresh database and on one where the promotion migration already ran.

-- Question 1/7 (pair 1 TR, quiz position 1, CODE_OUTPUT)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'threads')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$Thread isci = new Thread(() -> System.out.println("çalışıyor"));

System.out.println(isci.getState());$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$Thread isci = new Thread(() -> System.out.println("çalışıyor"));

System.out.println(isci.getState());$$, $$java$$,
           $$`Thread` nesnesi oluşturulmuş ama `start()` hiç çağrılmamıştır; bu durumda thread `NEW` durumundadır ve `run()` içindeki kod çalışmaz. Bu yüzden `çalışıyor` yazdırılmaz. `RUNNABLE` durumu ancak `start()` çağrıldıktan sonra görülür.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'threads'
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
        ($$`NEW`, sonra `çalışıyor`$$, FALSE, 0),
        ($$`çalışıyor`, sonra `TERMINATED`$$, FALSE, 1),
        ($$Yalnızca `NEW`$$, TRUE, 2),
        ($$Yalnızca `RUNNABLE`$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'threads'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (pair 2 TR, quiz position 2, CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'threads')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$public class Demo {
    public static void main(String[] args) throws InterruptedException {
        Thread isci = new Thread(() -> System.out.println("işçi bitti"));

        isci.start();
        isci.join();

        System.out.println("main bitti");
    }
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$public class Demo {
    public static void main(String[] args) throws InterruptedException {
        Thread isci = new Thread(() -> System.out.println("işçi bitti"));

        isci.start();
        isci.join();

        System.out.println("main bitti");
    }
}$$, $$java$$,
           $$`join()`, çağıran thread'i (burada main) hedef thread tamamen bitene kadar bekletir. Bu yüzden `main bitti` satırı her zaman `işçi bitti`'den sonra yazdırılır. `join()` olmasaydı sıra işletim sisteminin zamanlayıcısına kalırdı ve garanti edilemezdi.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'threads'
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
        ($$`main bitti`, sonra `işçi bitti`$$, FALSE, 0),
        ($$İki satır da yazdırılır, ama sıraları her çalıştırmada değişebilir$$, FALSE, 1),
        ($$Yalnızca `main bitti`$$, FALSE, 2),
        ($$`işçi bitti`, sonra `main bitti`$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'threads'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (pair 3 TR, quiz position 3, SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'threads')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdaki durumlardan hangisi bir race condition'a yol açar?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdaki durumlardan hangisi bir race condition'a yol açar?$$,
           NULL, NULL,
           $$Race condition, birden fazla thread aynı paylaşılan durumu korumasız değiştirdiğinde ortaya çıkar; sonuç her çalıştırmada farklı ve yanlış olabilir. Yalnızca kendi yerel değişkenleriyle çalışan thread'ler ortak bir şeyi değiştirmediği için böyle bir risk taşımaz; `join()` ve `sleep()` de tek başına paylaşılan veriyi bozmaz.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'threads'
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
        ($$İki thread'in aynı paylaşılan değişkeni korumasız biçimde değiştirmesi$$, TRUE, 0),
        ($$İki thread'in yalnızca kendi yerel değişkenleriyle çalışması$$, FALSE, 1),
        ($$Bir thread'in `join()` ile diğerinin bitmesini beklemesi$$, FALSE, 2),
        ($$Bir thread'in `sleep()` ile bir süre duraklaması$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'threads'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (pair 4 TR, quiz position 4, MULTIPLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'threads')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`volatile` hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$`volatile` hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$`volatile` yalnızca görünürlüğü garanti eder: bir thread'in yazdığı değer, örneğin bir durdurma bayrağı, diğer thread'lerce görülür. Atomiklik sağlamaz ve bir kilit de içermez; bu yüzden birden fazla adımdan oluşan işlemlerde `synchronized`'ın yerini tutmaz, okuyan thread'i de bekletmez.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'threads'
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
        ($$Yalnızca görünürlüğü garanti eder, atomikliği garanti etmez$$, TRUE, 0),
        ($$Bir thread'in yazdığı durdurma bayrağının diğer thread tarafından görülmesini sağlar$$, TRUE, 1),
        ($$Her durumda `synchronized`'ın yerine kullanılabilir$$, FALSE, 2),
        ($$Değişkeni okuyan thread'i, yazma bitene kadar kilitte bekletir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'threads'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (pair 5 TR, quiz position 5, SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'threads')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`wait()` ya da `notify()`, bir `synchronized` blok ya da metodun dışında çağrılırsa ne olur?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$`wait()` ya da `notify()`, bir `synchronized` blok ya da metodun dışında çağrılırsa ne olur?$$,
           NULL, NULL,
           $$İkisi de üzerinde çağrıldıkları nesnenin kilidine (monitor) ihtiyaç duyar; kilit tutulmadan çağrılırlarsa `IllegalMonitorStateException` fırlatılır. Bu bir derleme hatası değildir, kod derlenir ve hata çalışma anında ortaya çıkar; çağrı sessizce yok sayılmaz.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'threads'
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
        ($$Kod derlenmez$$, FALSE, 0),
        ($$Çağrı hiçbir etki yapmadan yok sayılır$$, FALSE, 1),
        ($$`IllegalMonitorStateException` fırlatılır$$, TRUE, 2),
        ($$Thread, bir `interrupt()` gelene kadar bekler$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'threads'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (pair 6 TR, quiz position 6, SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'threads')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`ReentrantLock`'un `synchronized`'a göre sunduğu ek esneklik hangisidir?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$`ReentrantLock`'un `synchronized`'a göre sunduğu ek esneklik hangisidir?$$,
           NULL, NULL,
           $$`tryLock()` ile bir thread kilidi almayı dener; kilit meşgulse sonsuza kadar beklemek yerine hemen vazgeçip başka bir iş yapabilir. `synchronized` bunu yapamaz. Buna karşılık `ReentrantLock` kilidi kendiliğinden bırakmaz; `unlock()`'un `finally` içinde elle çağrılması gerekir.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'threads'
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
        ($$Kilidin, `unlock()` çağrılmasa da kendiliğinden bırakılması$$, FALSE, 0),
        ($$Aynı anda birden fazla thread'in kilitli bölgeye girebilmesi$$, FALSE, 1),
        ($$Kilitlerin her zaman aynı sırayla alınmasını kendiliğinden sağlaması$$, FALSE, 2),
        ($$`tryLock()` ile kilidi almayı deneyip, meşgulse beklemeden vazgeçebilmek$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'threads'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (pair 7 TR, quiz position 7, SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'threads')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangisi bir deadlock'u tanımlar?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangisi bir deadlock'u tanımlar?$$,
           NULL, NULL,
           $$Deadlock'ta iki ya da daha fazla thread, her biri diğerinin tuttuğu kilidi bekleyerek birbirini sonsuza kadar engeller ve hiçbiri ilerleyemez. Bir güncellemenin kaybolması race condition'dır; `sleep()` sırasında `interrupt()` ile uyanmak ise bir iptal isteğinin normal biçimde ulaşmasıdır.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'threads'
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
        ($$İki thread'in aynı değişkeni korumasız değiştirmesi sonucu bir güncellemenin kaybolması$$, FALSE, 0),
        ($$İki thread'in, her biri diğerinin tuttuğu kilidi bekleyerek birbirini sonsuza kadar engellemesi$$, TRUE, 1),
        ($$`sleep()` içindeki bir thread'in `interrupt()` ile uyandırılması$$, FALSE, 2),
        ($$Tüm kullanıcı thread'leri bitince JVM'in daemon thread'leri beklemeden kapanması$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'threads'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
