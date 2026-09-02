-- Promotion-style migration linking TR spring-batch quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-batch')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Job/Step zihinsel modelinde, chunk-oriented bir Step içinde ItemProcessor hangi rolü oynar?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Job/Step zihinsel modelinde, chunk-oriented bir Step içinde ItemProcessor hangi rolü oynar?$$,
           NULL, NULL,
           $$Her öğeyi opsiyonel olarak dönüştürür ya da doğrular.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-batch'
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
    ($$Her öğeyi opsiyonel olarak dönüştürür ya da doğrular$$, TRUE, 0),
    ($$Veri kaynağından öğeleri birer birer okur$$, FALSE, 1),
    ($$Bir grup öğeyi bir kerede yazar$$, FALSE, 2),
    ($$Tüm chunk için transaction sınırını yönetir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-batch'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-batch')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Chunk-oriented bir step, .chunk(100, transactionManager) ile yapılandırılmış. 1-100 ve 101-200 chunk'ları başarıyla commit edildikten sonra, 201-300 öğeleri (üçüncü chunk) yazma aşamasında başarısız oluyor. Veritabanının durumu nedir?$$
      AND code_snippet = $$.chunk(100, transactionManager)
.reader(siparisItemReader())
.processor(siparisItemProcessor())
.writer(siparisItemWriter())$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Chunk-oriented bir step, .chunk(100, transactionManager) ile yapılandırılmış. 1-100 ve 101-200 chunk'ları başarıyla commit edildikten sonra, 201-300 öğeleri (üçüncü chunk) yazma aşamasında başarısız oluyor. Veritabanının durumu nedir?$$,
           $$.chunk(100, transactionManager)
.reader(siparisItemReader())
.processor(siparisItemProcessor())
.writer(siparisItemWriter())$$, $$java$$,
           $$1-200 öğeleri commit edilmiş olarak kalır; yalnızca 201-300'ün yazmaları geri alınır, çünkü her chunk kendi transaction sınırıdır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-batch'
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
    ($$Yalnızca hataya yol açan tek öğe geri alınır, chunk 3'ün geri kalanı yazılır$$, FALSE, 0),
    ($$Tüm job, hatanın hiçbir kaydı olmadan sessizce bir sonraki chunk'a devam eder$$, FALSE, 1),
    ($$1-200 öğeleri commit edilmiş olarak kalır; yalnızca 201-300'ün yazmaları geri alınır, çünkü her chunk kendi transaction sınırıdır$$, TRUE, 2),
    ($$Tüm step tek bir transaction olduğu için şu ana kadarki 300 öğenin tamamı geri alınır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-batch'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-batch')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Negatif tutarlı bir sipariş için ne olur?$$
      AND code_snippet = $$ItemProcessor<Siparis, Siparis> processor() {
    return siparis -> siparis.tutar().signum() < 0 ? null : siparis;
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Negatif tutarlı bir sipariş için ne olur?$$,
           $$ItemProcessor<Siparis, Siparis> processor() {
    return siparis -> siparis.tutar().signum() < 0 ? null : siparis;
}$$, $$java$$,
           $$Sessizce filtrelenir -- writer'a hiç ulaşmaz ve step normal şekilde devam eder.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-batch'
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
    ($$Sessizce filtrelenir -- writer'a hiç ulaşmaz ve step normal şekilde devam eder$$, TRUE, 0),
    ($$Tüm chunk'ı başarısız kılan bir ValidationException fırlatır$$, FALSE, 1),
    ($$Negatif tutarıyla değişmeden veritabanına yazılır$$, FALSE, 2),
    ($$Atlanmadan önce yapılandırılmış retry limitine kadar yeniden denenir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-batch'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: MULTIPLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-batch')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$JobParameters, JobInstance ve JobExecution arasındaki ilişkiyi aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$JobParameters, JobInstance ve JobExecution arasındaki ilişkiyi aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Bir Job + JobParameters bir JobInstance'ı belirler; bir JobInstance yeniden denendiğinde birden fazla JobExecution'a sahip olabilir; farklı parametre değerleri farklı instance'lar demektir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-batch'
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
    ($$JobExecution ve JobInstance, tamamen aynı kavramın yalnızca iki farklı adıdır$$, FALSE, 0),
    ($$Başarısız olup yeniden başlatılırsa, tek bir JobInstance'ın birden fazla JobExecution'ı olabilir$$, TRUE, 1),
    ($$Farklı businessDate parametre değerlerine sahip iki çalışma aynı JobInstance'ı temsil eder$$, FALSE, 2),
    ($$Bir Job, belirli bir JobParameters kümesiyle birleştiğinde bir JobInstance'ı belirler$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-batch'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-batch')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$JobRepository neyden sorumludur ve restartability için neden önemlidir?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$JobRepository neyden sorumludur ve restartability için neden önemlidir?$$,
           NULL, NULL,
           $$Job/step çalıştırma durumunu ve metadata'yı kalıcı hale getirir, bu da bir restart'ın zaten başarılı olmuş işi yeniden işlemekten kaçınmasını sağlar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-batch'
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
    ($$Job/step çalıştırma durumunu ve metadata'yı kalıcı hale getirir, bu da bir restart'ın zaten başarılı olmuş işi yeniden işlemekten kaçınmasını sağlar$$, TRUE, 0),
    ($$Bir Job'un okuduğu CSV dosyalarını saklar, başka bir şey yapmaz$$, FALSE, 1),
    ($$Uygulamanın ana veritabanı bağlantı havuzunun yalnızca bir takma adıdır$$, FALSE, 2),
    ($$Yalnızca @Scheduled ile yapılandırılmış job'lar için önemlidir, elle tetiklenenler için değil$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-batch'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-batch')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Spring Batch fault tolerance'ında skip ile retry arasındaki farkı aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Spring Batch fault tolerance'ında skip ile retry arasındaki farkı aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$skip, bir limite kadar gerçekten kötü bir öğeye tolerans gösterir; retry, olası geçici bir hatayı bir limite kadar yeniden dener. İkisi de varsayılan olarak açık değildir ve retry kalıcı olarak kötü öğeler için değildir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-batch'
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
    ($$retry, vazgeçmeden önce AYNI işlemi bir limite kadar yeniden deneyerek olası geçici bir hataya tolerans gösterir$$, TRUE, 0),
    ($$skip ve retry, hiçbir yapılandırma gerekmeden her chunk-oriented step'te varsayılan olarak etkindir$$, FALSE, 1),
    ($$retry, kaç kez denenirse denensin asla başarılı olmayacak, gerçekten kötü bir öğe içindir$$, FALSE, 2),
    ($$skip, yapılandırılmış bir limite kadar, gerçekten kötü bir öğeyi hariç tutarak devam etmeye tolerans gösterir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-batch'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-batch')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Dersin "Spring Batch NE DEĞİLDİR" bölümüne göre, @Scheduled ile Spring Batch arasındaki gerçek ilişki nedir?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Dersin "Spring Batch NE DEĞİLDİR" bölümüne göre, @Scheduled ile Spring Batch arasındaki gerçek ilişki nedir?$$,
           NULL, NULL,
           $$@Scheduled, bir job'un ne zaman başlatılacağına karar verir; Spring Batch, o job'un nasıl yapılandırılıp çalıştırılacağına karar verir -- farklı sorunları çözerler.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-batch'
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
    ($$@Scheduled, bir job'un NE ZAMAN başlatılacağına karar verir; Spring Batch, o job'un NASIL yapılandırılıp çalıştırılacağına ve izleneceğine karar verir -- farklı sorunları çözerler$$, TRUE, 0),
    ($$Spring Batch, @Scheduled'ın yerini alan, yalnızca daha güçlü başka bir scheduler'dır$$, FALSE, 1),
    ($$Birbirini dışlarlar ve aynı uygulamada asla birlikte kullanılamazlar$$, FALSE, 2),
    ($$Spring Batch, her Job'u tetiklemek için dahili olarak otomatik olarak @Scheduled'ı çağırır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-batch'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
