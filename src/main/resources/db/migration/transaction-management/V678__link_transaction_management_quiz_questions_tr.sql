-- Promotion-style migration linking TR transaction-management quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'transaction-management')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Hangi ACID özelliği, bir transaction'ın etkilerinin, commit edildikten hemen sonra sunucu çökse bile kalıcı kalmasını garanti eder?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Hangi ACID özelliği, bir transaction'ın etkilerinin, commit edildikten hemen sonra sunucu çökse bile kalıcı kalmasını garanti eder?$$,
           NULL, NULL,
           $$Durability (Dayanıklılık): commit edilmiş bir transaction, sunucu hemen ardından çökse bile kalıcıdır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'transaction-management'
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
    ($$Isolation (Yalıtım)$$, FALSE, 0),
    ($$Durability (Dayanıklılık)$$, TRUE, 1),
    ($$Atomicity (Bölünmezlik)$$, FALSE, 2),
    ($$Consistency (Tutarlılık)$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'transaction-management'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'transaction-management')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu metot çağrıldığında ve sonuna kadar çalıştığında ne olur?$$
      AND code_snippet = $$class DefterServisi {
    @Transactional
    void yazSonraCheckedFirlat() throws IOException {
        defter.ekle("kayit-1");
        throw new IOException("simule edilmis hata");
    }
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu metot çağrıldığında ve sonuna kadar çalıştığında ne olur?$$,
           $$class DefterServisi {
    @Transactional
    void yazSonraCheckedFirlat() throws IOException {
        defter.ekle("kayit-1");
        throw new IOException("simule edilmis hata");
    }
}$$, $$java$$,
           $$Spring'in varsayılan rollback kuralı, unchecked exception'ları rollback tetikleyicisi sayar; checked exception'lar (IOException gibi) varsayılan olarak rollback TETİKLEMEZ -- transaction, istisnaya rağmen commit edilir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'transaction-management'
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
    ($$Transaction rollback edilir -- "kayit-1" hiç yazılmaz, çünkü varsayılan olarak her istisna rollback tetikler.$$, FALSE, 0),
    ($$Uygulama başlayamaz, çünkü @Transactional metotlar checked exception bildiremez.$$, FALSE, 1),
    ($$Transaction, manuel bir commit bekleyerek süresiz açık kalır.$$, FALSE, 2),
    ($$Transaction commit edilir -- IOException fırlatılmış olsa bile "kayit-1" defterde kalıcı hale gelir.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'transaction-management'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'transaction-management')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aynı sınıf içinden `this` üzerinden çağrılan bir metotta (self-invocation) `@Transactional` neden sessizce hiçbir etki göstermez?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aynı sınıf içinden `this` üzerinden çağrılan bir metotta (self-invocation) `@Transactional` neden sessizce hiçbir etki göstermez?$$,
           NULL, NULL,
           $$Bir proxy yalnızca dışarıdan bean üzerinden gelen çağrıları yakalayabilir; this üzerinden bir çağrı doğrudan gerçek nesneye gider, proxy'yi tamamen atlar.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'transaction-management'
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
    ($$Proxy çağrıyı doğru şekilde yakalar, ama özellikle self-call'lar için @Transactional'ı sessizce yok sayar.$$, FALSE, 0),
    ($$Bir proxy yalnızca dışarıdan bean üzerinden gelen çağrıları yakalayabilir; this üzerinden bir çağrı doğrudan gerçek nesneye gider, proxy'yi tamamen atlar.$$, TRUE, 1),
    ($$Self-invocation, Spring'de her zaman bir derleme hatası fırlatır.$$, FALSE, 2),
    ($$İki metot aynı sınıfta olduğunda @Transactional otomatik olarak devre dışı kalır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'transaction-management'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: MULTIPLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'transaction-management')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`PROPAGATION_REQUIRED` ile `PROPAGATION_REQUIRES_NEW` arasındaki farkı doğru şekilde tanımlayan ifadeler hangileridir? (Uygun olan hepsini seçin)$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$`PROPAGATION_REQUIRED` ile `PROPAGATION_REQUIRES_NEW` arasındaki farkı doğru şekilde tanımlayan ifadeler hangileridir? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$REQUIRED, zaten aktif bir transaction varsa ona katılır. REQUIRES_NEW, aktif olan her transaction'ı askıya alır ve tamamen bağımsız, kendi başına commit ya da rollback olan yeni bir tane başlatır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'transaction-management'
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
    ($$REQUIRES_NEW, aktif olan her transaction'ı askıya alır ve tamamen bağımsız, kendi başına commit ya da rollback olan yeni bir tane başlatır.$$, TRUE, 0),
    ($$REQUIRED, aktif olan bir transaction'ı yok sayarak her zaman yepyeni bir tane başlatır.$$, FALSE, 1),
    ($$Dış transaction rollback olursa, bir REQUIRES_NEW iç transaction'ında yapılan iş her zaman onunla birlikte rollback olur.$$, FALSE, 2),
    ($$REQUIRED, zaten aktif bir transaction varsa ikinci birini başlatmak yerine ona katılır.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'transaction-management'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'transaction-management')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`@Transactional(readOnly = true)` gerçekte neyi garanti eder?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`@Transactional(readOnly = true)` gerçekte neyi garanti eder?$$,
           NULL, NULL,
           $$Hiçbir şeyi zorlamaz -- performans optimizasyonu için Spring/JPA'ya bir ipucudur, yazmaları engelleyen gerçek bir kısıtlama değildir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'transaction-management'
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
    ($$Metodun kendi @Transactional annotation'ını tamamen devre dışı bırakır.$$, FALSE, 0),
    ($$Hiçbir şeyi zorlamaz -- performans optimizasyonu için Spring/JPA'ya bir ipucudur, yazmaları engelleyen gerçek bir kısıtlama değildir.$$, TRUE, 1),
    ($$Metodun veritabanına asla yazamayacağını garanti eder, herhangi bir yazma girişiminde istisna fırlatır.$$, FALSE, 2),
    ($$Transaction'ın otomatik olarak bir read replica veritabanında çalışmasını sağlar.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'transaction-management'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'transaction-management')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, `@Transactional`'ı controller yerine service katmanına koymak neden yaygın olarak kabul gören kural?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `@Transactional`'ı controller yerine service katmanına koymak neden yaygın olarak kabul gören kural?$$,
           NULL, NULL,
           $$Tek bir service metodu genellikle birden fazla repository çağrısı yapar ve bunların tek bir birim olması gerekir; controller'a koymak, transaction'ı bir view render etmek gibi ilgisiz işleri de kapsayacak şekilde gereksiz yere genişletir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'transaction-management'
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
    ($$Controller'lar asla @Transactional işaretlenemez -- bu bir derleme hatasıdır.$$, FALSE, 0),
    ($$Repository katmanı zaten tüm transaction sınırlarını halleder, bu yüzden service katmanındaki annotation tamamen dekoratiftir.$$, FALSE, 1),
    ($$@Transactional'ı controller'a koymak transaction'ı daha yavaş değil daha hızlı yapar.$$, FALSE, 2),
    ($$Tek bir service metodu genellikle birden fazla repository çağrısı yapar ve bunların tek bir birim olması gerekir; controller'a koymak, transaction'ı bir view render etmek gibi ilgisiz işleri de kapsayacak şekilde gereksiz yere genişletir.$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'transaction-management'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: CODE_OUTPUT)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'transaction-management')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`siparisOlustur(true)` çağrıldığında ne olur?$$
      AND code_snippet = $$class SiparisOlusturulduEvent { }

@Component
class KargoBildirici {
    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    void siparisOlusturulduAninda(SiparisOlusturulduEvent event) {
        System.out.println("Kargo bildirimi gonderildi");
    }
}

class SiparisServisi {
    @Transactional
    void siparisOlustur(boolean yayindanSonraHataSimuleEt) {
        eventPublisher.publishEvent(new SiparisOlusturulduEvent());
        if (yayindanSonraHataSimuleEt) {
            throw new RuntimeException("yayindan sonra hata");
        }
    }
}$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$`siparisOlustur(true)` çağrıldığında ne olur?$$,
           $$class SiparisOlusturulduEvent { }

@Component
class KargoBildirici {
    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    void siparisOlusturulduAninda(SiparisOlusturulduEvent event) {
        System.out.println("Kargo bildirimi gonderildi");
    }
}

class SiparisServisi {
    @Transactional
    void siparisOlustur(boolean yayindanSonraHataSimuleEt) {
        eventPublisher.publishEvent(new SiparisOlusturulduEvent());
        if (yayindanSonraHataSimuleEt) {
            throw new RuntimeException("yayindan sonra hata");
        }
    }
}$$, $$java$$,
           $$siparisOlustur(true), bir RuntimeException fırlatır, bu yüzden transaction rollback edilir. AFTER_COMMIT listener'ları yalnızca event'i yayınlayan transaction gerçekten commit olursa çalışır -- burada hiç commit olmadığı için, event yayınlanmış olsa bile listener hiç çalışmaz.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'transaction-management'
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
    ($$"Kargo bildirimi gonderildi" iki kez yazdırılır, biri event için biri rollback için.$$, FALSE, 0),
    ($$"Kargo bildirimi gonderildi" hiç yazdırılmaz, çünkü transaction commit olmadan rollback edildi.$$, TRUE, 1),
    ($$"Kargo bildirimi gonderildi" yazdırılır, çünkü istisna fırlatılmadan önce event zaten yayınlandı.$$, FALSE, 2),
    ($$Uygulama başlayamaz, çünkü @TransactionalEventListener açıkça @EnableTransactionManagement gerektirir.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'transaction-management'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
