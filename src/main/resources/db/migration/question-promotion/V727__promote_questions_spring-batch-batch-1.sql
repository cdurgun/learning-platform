-- Promotion batch
-- Topic: spring-batch (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V679-V714 (Spring MVC) and V659-V678 (Spring
-- Core), these 14 questions were NOT produced by the n8n generation
-- pipeline, NOT judged by the AI Judge, and NOT ingested via
-- /api/internal/questions/ingest -- per explicit user request, they were
-- hand-authored and independently self-reviewed directly inside a Claude Code
-- session, grounded strictly in content/en/spring-batch.md and
-- content/tr/spring-batch.md.
--
-- Strict 50/50 EN/TR split (7+7) organized as 7 CONCEPT PAIRS -- each EN
-- question has a TR counterpart testing the exact same concept, but
-- independently authored (different code/variable names, different question
-- framing) rather than a translation. Every question whose answer depends on
-- shown code is typed CODE_OUTPUT (never SINGLE_CHOICE/MULTIPLE_CHOICE with a
-- code_snippet attached) -- fragments/quiz.html only renders code_snippet for
-- CODE_OUTPUT questions, per the bug found and fixed in try-catch-finally/V573.
--
-- Each question's 4 options are written with the correct answer at a VARIED
-- position (not always first), applied directly during authoring via a
-- deterministic per-question rotation -- per the bug found and fixed in
-- question-promotion/V598 (Exceptions/Generics batches were 100% "always A").
--
-- source = 'CLAUDE' / reviewed_by = 'claude-code@anthropic.com' / status =
-- 'PUBLISHED' directly -- same documentation convention as prior manual
-- batches. topic_id resolved by Topic.slug; question_option rows reference
-- the newly generated id via a WITH ... RETURNING id CTE.
--
-- Duplicate-promotion safety: N/A -- this batch was never ingested into
-- development, so no dev ids exist for these 14 questions at all.

-- Pair 1 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$In the Job/Step mental model, what role does an ItemProcessor play in a chunk-oriented Step?$$,
           NULL, NULL,
           $$It optionally transforms or validates each item.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-batch'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It reads items one at a time from the data source$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$It optionally transforms or validates each item$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It writes a whole group of items at once$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$It manages the transaction boundary for the entire chunk$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Job/Step zihinsel modelinde, chunk-oriented bir Step içinde ItemProcessor hangi rolü oynar?$$,
           NULL, NULL,
           $$Her öğeyi opsiyonel olarak dönüştürür ya da doğrular.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-batch'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Her öğeyi opsiyonel olarak dönüştürür ya da doğrular$$, TRUE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Veri kaynağından öğeleri birer birer okur$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir grup öğeyi bir kerede yazar$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Tüm chunk için transaction sınırını yönetir$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A chunk-oriented step is configured with .chunk(100, transactionManager). Items 201-300 (the third chunk) fail during the write phase, after chunks 1-100 and 101-200 already committed successfully. What is the state of the database?$$,
           $$.chunk(100, transactionManager)
.reader(orderItemReader())
.processor(orderItemProcessor())
.writer(orderItemWriter())$$, $$java$$,
           $$Items 1-200 remain committed; only items 201-300's writes are rolled back, since each chunk is its own transaction boundary.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-batch'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Only the single item that caused the failure is rolled back, the rest of chunk 3 is written$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$The entire job silently continues to the next chunk with no record of the failure$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$All 300 items so far are rolled back, since the whole step is one transaction$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Items 1-200 remain committed; only items 201-300's writes are rolled back, since each chunk is its own transaction boundary$$, TRUE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Chunk-oriented bir step, .chunk(100, transactionManager) ile yapılandırılmış. 1-100 ve 101-200 chunk'ları başarıyla commit edildikten sonra, 201-300 öğeleri (üçüncü chunk) yazma aşamasında başarısız oluyor. Veritabanının durumu nedir?$$,
           $$.chunk(100, transactionManager)
.reader(siparisItemReader())
.processor(siparisItemProcessor())
.writer(siparisItemWriter())$$, $$java$$,
           $$1-200 öğeleri commit edilmiş olarak kalır; yalnızca 201-300'ün yazmaları geri alınır, çünkü her chunk kendi transaction sınırıdır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-batch'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca hataya yol açan tek öğe geri alınır, chunk 3'ün geri kalanı yazılır$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Tüm job, hatanın hiçbir kaydı olmadan sessizce bir sonraki chunk'a devam eder$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$1-200 öğeleri commit edilmiş olarak kalır; yalnızca 201-300'ün yazmaları geri alınır, çünkü her chunk kendi transaction sınırıdır$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Tüm step tek bir transaction olduğu için şu ana kadarki 300 öğenin tamamı geri alınır$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$For an order with a negative amount, what happens to it?$$,
           $$ItemProcessor<Order, Order> processor() {
    return order -> order.amount().signum() < 0 ? null : order;
}$$, $$java$$,
           $$It is silently filtered out -- never reaches the writer, and the step continues normally.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-batch'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It throws a ValidationException, failing the entire chunk$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$It is written to the database with a negative amount unchanged$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$It is silently filtered out -- never reaches the writer, and the step continues normally$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$It is retried up to the configured retry limit before being skipped$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Negatif tutarlı bir sipariş için ne olur?$$,
           $$ItemProcessor<Siparis, Siparis> processor() {
    return siparis -> siparis.tutar().signum() < 0 ? null : siparis;
}$$, $$java$$,
           $$Sessizce filtrelenir -- writer'a hiç ulaşmaz ve step normal şekilde devam eder.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-batch'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Sessizce filtrelenir -- writer'a hiç ulaşmaz ve step normal şekilde devam eder$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Tüm chunk'ı başarısız kılan bir ValidationException fırlatır$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Negatif tutarıyla değişmeden veritabanına yazılır$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Atlanmadan önce yapılandırılmış retry limitine kadar yeniden denenir$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe the relationship between JobParameters, JobInstance, and JobExecution? (Select all that apply)$$,
           NULL, NULL,
           $$A Job + JobParameters identifies a JobInstance; a JobInstance can have multiple JobExecutions on retry; different parameter values mean different instances, not the same one.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-batch'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$JobExecution and JobInstance are simply two different names for the exact same concept$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Two runs with different businessDate parameter values represent the same JobInstance$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$A Job combined with a specific set of JobParameters identifies a JobInstance$$, TRUE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$A single JobInstance can have multiple JobExecutions if it fails and is restarted$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$JobParameters, JobInstance ve JobExecution arasındaki ilişkiyi aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Bir Job + JobParameters bir JobInstance'ı belirler; bir JobInstance yeniden denendiğinde birden fazla JobExecution'a sahip olabilir; farklı parametre değerleri farklı instance'lar demektir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-batch'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$JobExecution ve JobInstance, tamamen aynı kavramın yalnızca iki farklı adıdır$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Başarısız olup yeniden başlatılırsa, tek bir JobInstance'ın birden fazla JobExecution'ı olabilir$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Farklı businessDate parametre değerlerine sahip iki çalışma aynı JobInstance'ı temsil eder$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Bir Job, belirli bir JobParameters kümesiyle birleştiğinde bir JobInstance'ı belirler$$, TRUE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, ADVANCED)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What is the JobRepository responsible for, and why does it matter for restartability?$$,
           NULL, NULL,
           $$It persists job/step execution status and metadata, which is what lets a restart avoid reprocessing already-succeeded work.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-batch'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It stores the CSV files a Job reads from, nothing more$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$It persists job/step execution status and metadata, which is what lets a restart avoid reprocessing already-succeeded work$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$It is simply an alias for the application's main database connection pool$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$It only matters for jobs configured with @Scheduled, not manually triggered ones$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, ADVANCED)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$JobRepository neyden sorumludur ve restartability için neden önemlidir?$$,
           NULL, NULL,
           $$Job/step çalıştırma durumunu ve metadata'yı kalıcı hale getirir, bu da bir restart'ın zaten başarılı olmuş işi yeniden işlemekten kaçınmasını sağlar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-batch'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Job/step çalıştırma durumunu ve metadata'yı kalıcı hale getirir, bu da bir restart'ın zaten başarılı olmuş işi yeniden işlemekten kaçınmasını sağlar$$, TRUE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Bir Job'un okuduğu CSV dosyalarını saklar, başka bir şey yapmaz$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Uygulamanın ana veritabanı bağlantı havuzunun yalnızca bir takma adıdır$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Yalnızca @Scheduled ile yapılandırılmış job'lar için önemlidir, elle tetiklenenler için değil$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe the difference between skip and retry in Spring Batch fault tolerance? (Select all that apply)$$,
           NULL, NULL,
           $$skip tolerates a genuinely bad item up to a limit; retry retries a possibly-temporary failure up to a limit. Neither is on by default, and retry is not for permanently-bad items.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-batch'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$skip and retry are enabled by default on every chunk-oriented step, with no configuration needed$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$retry is meant for a genuinely bad item that will never succeed, no matter how many attempts$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$skip tolerates a genuinely bad item, excluding it and continuing, up to a configured limit$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$retry tolerates a possibly-temporary failure by retrying the SAME operation up to a limit before giving up$$, TRUE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Spring Batch fault tolerance'ında skip ile retry arasındaki farkı aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$skip, bir limite kadar gerçekten kötü bir öğeye tolerans gösterir; retry, olası geçici bir hatayı bir limite kadar yeniden dener. İkisi de varsayılan olarak açık değildir ve retry kalıcı olarak kötü öğeler için değildir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-batch'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$retry, vazgeçmeden önce AYNI işlemi bir limite kadar yeniden deneyerek olası geçici bir hataya tolerans gösterir$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$skip ve retry, hiçbir yapılandırma gerekmeden her chunk-oriented step'te varsayılan olarak etkindir$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$retry, kaç kez denenirse denensin asla başarılı olmayacak, gerçekten kötü bir öğe içindir$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$skip, yapılandırılmış bir limite kadar, gerçekten kötü bir öğeyi hariç tutarak devam etmeye tolerans gösterir$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$According to the lesson's "What Spring Batch Is NOT" section, what is the actual relationship between @Scheduled and Spring Batch?$$,
           NULL, NULL,
           $$@Scheduled decides WHEN to launch a job; Spring Batch decides HOW that job is structured, executed, and tracked -- they solve different problems.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-batch'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Spring Batch is simply another, more powerful scheduler that replaces @Scheduled$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$@Scheduled decides WHEN to launch a job; Spring Batch decides HOW that job is structured, executed, and tracked -- they solve different problems$$, TRUE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$They are mutually exclusive and can never be used in the same application$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Spring Batch automatically calls @Scheduled internally to trigger every Job$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Dersin "Spring Batch NE DEĞİLDİR" bölümüne göre, @Scheduled ile Spring Batch arasındaki gerçek ilişki nedir?$$,
           NULL, NULL,
           $$@Scheduled, bir job'un ne zaman başlatılacağına karar verir; Spring Batch, o job'un nasıl yapılandırılıp çalıştırılacağına karar verir -- farklı sorunları çözerler.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-batch'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$@Scheduled, bir job'un NE ZAMAN başlatılacağına karar verir; Spring Batch, o job'un NASIL yapılandırılıp çalıştırılacağına ve izleneceğine karar verir -- farklı sorunları çözerler$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Spring Batch, @Scheduled'ın yerini alan, yalnızca daha güçlü başka bir scheduler'dır$$, FALSE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Birbirini dışlarlar ve aynı uygulamada asla birlikte kullanılamazlar$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Spring Batch, her Job'u tetiklemek için dahili olarak otomatik olarak @Scheduled'ı çağırır$$, FALSE, 3 FROM new_question_tr7;
