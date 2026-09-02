-- Promotion-style migration linking TR task-execution-and-scheduling quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'task-execution-and-scheduling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir ThreadPoolTaskExecutor yapılandırmasında, corePoolSize neyi kontrol eder?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir ThreadPoolTaskExecutor yapılandırmasında, corePoolSize neyi kontrol eder?$$,
           NULL, NULL,
           $$corePoolSize, boşta bile olsa canlı kalan thread sayısıdır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'task-execution-and-scheduling'
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
    ($$Boşta bile olsa canlı kalan thread sayısını$$, TRUE, 0),
    ($$Kuyruğa alınabilecek maksimum görev sayısını$$, FALSE, 1),
    ($$Yükte havuzun büyüyebileceği kesin tavanı$$, FALSE, 2),
    ($$Havuzun yeni işleri ne sıklıkla kontrol ettiğini$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'task-execution-and-scheduling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'task-execution-and-scheduling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir @Configuration sınıfında @EnableAsync olmadan, @Async ile işaretlenmiş bir metoda ne olur?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir @Configuration sınıfında @EnableAsync olmadan, @Async ile işaretlenmiş bir metoda ne olur?$$,
           NULL, NULL,
           $$Sessizce yok sayılır -- metot, annotation hiç yokmuş gibi senkron çalışır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'task-execution-and-scheduling'
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
    ($$İlk çağrıldığında bir RuntimeException fırlatır$$, FALSE, 0),
    ($$Yine de varsayılan ForkJoinPool kullanılarak asenkron çalışır$$, FALSE, 1),
    ($$Sessizce yok sayılır -- metot, annotation hiç yokmuş gibi senkron çalışır$$, TRUE, 2),
    ($$Uygulama bir derleme hatasıyla başlayamaz$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'task-execution-and-scheduling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'task-execution-and-scheduling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Son satırdaki CompletableFuture.completedFuture(...) herhangi bir şeyi asenkron hale mi getirir?$$
      AND code_snippet = $$@Async
public CompletableFuture<String> raporUret(String id) {
    // Yavas is, bu satirdan once ZATEN bu thread uzerinde senkron olarak
    // gerceklesti, cunku @Async'in proxy'si tum metot govdesini buraya
    // dagitti zaten.
    return CompletableFuture.completedFuture("Rapor " + id + " hazir");
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Son satırdaki CompletableFuture.completedFuture(...) herhangi bir şeyi asenkron hale mi getirir?$$,
           $$@Async
public CompletableFuture<String> raporUret(String id) {
    // Yavas is, bu satirdan once ZATEN bu thread uzerinde senkron olarak
    // gerceklesti, cunku @Async'in proxy'si tum metot govdesini buraya
    // dagitti zaten.
    return CompletableFuture.completedFuture("Rapor " + id + " hazir");
}$$, $$java$$,
           $$Hayır -- yalnızca zaten bilinen bir değeri sarmalar; @Async metot gövdesini bu satırdan önce zaten ayrı bir thread'de çalıştırmıştı.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'task-execution-and-scheduling'
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
    ($$Hayır -- yalnızca zaten bilinen bir değeri sarmalar; @Async metot gövdesini bu satırdan önce zaten ayrı bir thread'de çalıştırmıştı$$, TRUE, 0),
    ($$Evet -- işi ayrı bir thread'e dağıtan budur$$, FALSE, 1),
    ($$Evet, ama yalnızca bu metoda yapılan ilk çağrı için$$, FALSE, 2),
    ($$Hayır, ve bu, bu metottaki @Async'in hiçbir etkisi olmadığı anlamına gelir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'task-execution-and-scheduling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'task-execution-and-scheduling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$siparisIsle_bozuk(...), başka bir bean'den çağrılıyor. pushBildirimiGonder(...)'a ne olur?$$
      AND code_snippet = $$@Service
public class SiparisServisi {
    public void siparisIsle_bozuk(Siparis siparis) {
        // ...
        this.pushBildirimiGonder(siparis); // "this" uzerinden cagriliyor
    }

    @Async
    public void pushBildirimiGonder(Siparis siparis) {
        // yavas bildirim isi
    }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$siparisIsle_bozuk(...), başka bir bean'den çağrılıyor. pushBildirimiGonder(...)'a ne olur?$$,
           $$@Service
public class SiparisServisi {
    public void siparisIsle_bozuk(Siparis siparis) {
        // ...
        this.pushBildirimiGonder(siparis); // "this" uzerinden cagriliyor
    }

    @Async
    public void pushBildirimiGonder(Siparis siparis) {
        // yavas bildirim isi
    }
}$$, $$java$$,
           $$Senkron çalışır -- this üzerinden çağırmak Spring proxy'sini tamamen atlar, bu yüzden @Async'in hiçbir etkisi olmaz.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'task-execution-and-scheduling'
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
    ($$Self-invocation Spring tarafından yasaklandığı için bir istisna fırlatır$$, FALSE, 0),
    ($$Asenkron çalışır, ama yalnızca sınıf ilk yüklendiğinde$$, FALSE, 1),
    ($$Senkron çalışır -- this üzerinden çağırmak Spring proxy'sini tamamen atlar, bu yüzden @Async'in hiçbir etkisi olmaz$$, TRUE, 2),
    ($$@Async, metodun kendisinde olduğu için beklendiği gibi asenkron çalışır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'task-execution-and-scheduling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'task-execution-and-scheduling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$fixedRate ile fixedDelay arasındaki farkı aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$fixedRate ile fixedDelay arasındaki farkı aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$fixedRate, aralığı önceki çalışmanın başlangıcından itibaren ölçer; fixedDelay bitişinden itibaren ölçer ve gerçek bir boşluk garanti eder.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'task-execution-and-scheduling'
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
    ($$fixedDelay, aralığı önceki çalışmanın BİTİŞİNDEN itibaren ölçer ve gerçek bir boşluk garanti eder$$, TRUE, 0),
    ($$fixedRate, aralığı önceki çalışmanın BAŞLANGICINDAN itibaren ölçer$$, TRUE, 1),
    ($$fixedRate, her çalışmanın ne kadar sürdüğünden bağımsız olarak her zaman çalışmalar arasında bir boşluk garanti eder$$, FALSE, 2),
    ($$fixedDelay ve fixedRate, tamamen aynı davranışın yalnızca iki farklı adıdır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'task-execution-and-scheduling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'task-execution-and-scheduling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Varsayılan olarak, Spring @Scheduled metotlarını kaç thread üzerinde çalıştırır ve bunun sonucu nedir?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Varsayılan olarak, Spring @Scheduled metotlarını kaç thread üzerinde çalıştırır ve bunun sonucu nedir?$$,
           NULL, NULL,
           $$Tek, paylaşılan bir thread -- yavaş bir zamanlanmış görev, arkasındaki her diğer zamanlanmış görevi geciktirebilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'task-execution-and-scheduling'
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
    ($$CPU çekirdek sayısına göre otomatik boyutlandırılmış bir thread havuzu$$, FALSE, 0),
    ($$@Async için yapılandırılan aynı TaskExecutor, bu yüzden ikisi de yükü eşit paylaşır$$, FALSE, 1),
    ($$Tek, paylaşılan bir thread -- yavaş bir zamanlanmış görev, arkasındaki her diğer zamanlanmış görevi geciktirebilir$$, TRUE, 2),
    ($$@Scheduled metodu başına bir thread, bu yüzden asla birbirlerine müdahale etmezler$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'task-execution-and-scheduling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'task-execution-and-scheduling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri @Async'i @Scheduled'dan doğru şekilde ayırt eder? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri @Async'i @Scheduled'dan doğru şekilde ayırt eder? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$@Async bir şeye tepki olarak şimdi çalışır; @Scheduled kendi başına bir zamanlayıcıyla çalışır. Kavramsal olarak aynı altyapıyı paylaşsalar da ayrı havuzlar (TaskExecutor/TaskScheduler) kullanırlar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'task-execution-and-scheduling'
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
    ($$@Scheduled bir CompletableFuture döndüremez, @Async ise her zaman döndürmek zorundadır$$, FALSE, 0),
    ($$@Async, "bunu şimdi, bir şeye tepki olarak asenkron çalıştır" anlamına gelir; @Scheduled, "bunu belirli bir zamanda ya da aralıkla, kendi başına çalıştır" anlamına gelir$$, TRUE, 1),
    ($$@Async ile @Scheduled birbirinin yerine kullanılabilir ve tam olarak aynı sorunu çözer$$, FALSE, 2),
    ($$Kavramsal olarak aynı temel thread-pool altyapısını paylaşırlar, ama ayrı, bağımsız yapılandırılan havuzlar (TaskExecutor ile TaskScheduler) kullanırlar$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'task-execution-and-scheduling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
