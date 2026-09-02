-- Promotion batch
-- Topic: task-execution-and-scheduling (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V679-V714 (Spring MVC) and V659-V678 (Spring
-- Core), these 14 questions were NOT produced by the n8n generation
-- pipeline, NOT judged by the AI Judge, and NOT ingested via
-- /api/internal/questions/ingest -- per explicit user request, they were
-- hand-authored and independently self-reviewed directly inside a Claude Code
-- session, grounded strictly in content/en/task-execution-and-scheduling.md and
-- content/tr/task-execution-and-scheduling.md.
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
           $$In a ThreadPoolTaskExecutor configuration, what does corePoolSize control?$$,
           NULL, NULL,
           $$corePoolSize is how many threads stay alive even when idle.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'task-execution-and-scheduling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The maximum number of tasks that can be queued$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$How many threads stay alive even when idle$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$The absolute ceiling the pool can grow to under load$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$How often the pool checks for new work$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir ThreadPoolTaskExecutor yapılandırmasında, corePoolSize neyi kontrol eder?$$,
           NULL, NULL,
           $$corePoolSize, boşta bile olsa canlı kalan thread sayısıdır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'task-execution-and-scheduling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Boşta bile olsa canlı kalan thread sayısını$$, TRUE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Kuyruğa alınabilecek maksimum görev sayısını$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Yükte havuzun büyüyebileceği kesin tavanı$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Havuzun yeni işleri ne sıklıkla kontrol ettiğini$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Without @EnableAsync on a @Configuration class, what happens to a method annotated @Async?$$,
           NULL, NULL,
           $$It is silently ignored -- the method just runs synchronously, as if the annotation weren't there.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'task-execution-and-scheduling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It throws a RuntimeException the first time it's called$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$It runs asynchronously anyway, using the default ForkJoinPool$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$The application fails to start with a compile error$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$It is silently ignored -- the method just runs synchronously, as if the annotation weren't there$$, TRUE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir @Configuration sınıfında @EnableAsync olmadan, @Async ile işaretlenmiş bir metoda ne olur?$$,
           NULL, NULL,
           $$Sessizce yok sayılır -- metot, annotation hiç yokmuş gibi senkron çalışır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'task-execution-and-scheduling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İlk çağrıldığında bir RuntimeException fırlatır$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Yine de varsayılan ForkJoinPool kullanılarak asenkron çalışır$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Sessizce yok sayılır -- metot, annotation hiç yokmuş gibi senkron çalışır$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Uygulama bir derleme hatasıyla başlayamaz$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Does CompletableFuture.completedFuture(...) on the last line make anything asynchronous?$$,
           $$@Async
public CompletableFuture<String> generateReport(String id) {
    // Slow work already happened synchronously on THIS thread before this line,
    // because @Async's proxy already dispatched the whole method body here.
    return CompletableFuture.completedFuture("Report " + id + " ready");
}$$, $$java$$,
           $$No -- it only wraps an already-known value; @Async already made the method body run on a separate thread before this line.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'task-execution-and-scheduling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yes -- it's what dispatches the work onto a separate thread$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$No -- it only wraps an already-known value; @Async already made the method body run on a separate thread before this line$$, TRUE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Yes, but only for the first call to this method$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$No, and this means @Async on this method has no effect at all$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
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
    FROM topic WHERE slug = 'task-execution-and-scheduling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hayır -- yalnızca zaten bilinen bir değeri sarmalar; @Async metot gövdesini bu satırdan önce zaten ayrı bir thread'de çalıştırmıştı$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Evet -- işi ayrı bir thread'e dağıtan budur$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Evet, ama yalnızca bu metoda yapılan ilk çağrı için$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Hayır, ve bu, bu metottaki @Async'in hiçbir etkisi olmadığı anlamına gelir$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$processOrder_broken(...) is called from another bean. What happens to sendPushNotification(...)?$$,
           $$@Service
public class OrderService {
    public void processOrder_broken(Order order) {
        // ...
        this.sendPushNotification(order); // called via "this"
    }

    @Async
    public void sendPushNotification(Order order) {
        // slow notification work
    }
}$$, $$java$$,
           $$It runs synchronously -- calling through this bypasses the Spring proxy entirely, so @Async has no effect.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'task-execution-and-scheduling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It throws an exception because self-invocation is forbidden by Spring$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$It runs asynchronously, but only the first time the class is loaded$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$It runs asynchronously as expected, since @Async is on the method itself$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$It runs synchronously -- calling through this bypasses the Spring proxy entirely, so @Async has no effect$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
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
    FROM topic WHERE slug = 'task-execution-and-scheduling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Self-invocation Spring tarafından yasaklandığı için bir istisna fırlatır$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Asenkron çalışır, ama yalnızca sınıf ilk yüklendiğinde$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Senkron çalışır -- this üzerinden çağırmak Spring proxy'sini tamamen atlar, bu yüzden @Async'in hiçbir etkisi olmaz$$, TRUE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$@Async, metodun kendisinde olduğu için beklendiği gibi asenkron çalışır$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe the difference between fixedRate and fixedDelay? (Select all that apply)$$,
           NULL, NULL,
           $$fixedRate measures from the previous run's start; fixedDelay measures from the previous run's finish, guaranteeing a real gap.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'task-execution-and-scheduling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$fixedRate measures the interval from the previous run's START$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$fixedDelay measures the interval from the previous run's FINISH, guaranteeing a real gap$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$fixedRate always guarantees a gap between runs, regardless of how long each run takes$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$fixedDelay and fixedRate are simply two different names for the exact same behavior$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$fixedRate ile fixedDelay arasındaki farkı aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$fixedRate, aralığı önceki çalışmanın başlangıcından itibaren ölçer; fixedDelay bitişinden itibaren ölçer ve gerçek bir boşluk garanti eder.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'task-execution-and-scheduling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$fixedDelay, aralığı önceki çalışmanın BİTİŞİNDEN itibaren ölçer ve gerçek bir boşluk garanti eder$$, TRUE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$fixedRate, aralığı önceki çalışmanın BAŞLANGICINDAN itibaren ölçer$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$fixedRate, her çalışmanın ne kadar sürdüğünden bağımsız olarak her zaman çalışmalar arasında bir boşluk garanti eder$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$fixedDelay ve fixedRate, tamamen aynı davranışın yalnızca iki farklı adıdır$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, ADVANCED)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$By default, on how many threads does Spring run @Scheduled methods, and what's the consequence?$$,
           NULL, NULL,
           $$A single shared thread -- a slow scheduled task can delay every other scheduled task behind it.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'task-execution-and-scheduling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A single shared thread -- a slow scheduled task can delay every other scheduled task behind it$$, TRUE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$The same TaskExecutor configured for @Async, so both share load evenly$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$One thread per @Scheduled method, so they never interfere with each other$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$A thread pool sized automatically to the number of CPU cores$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, ADVANCED)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Varsayılan olarak, Spring @Scheduled metotlarını kaç thread üzerinde çalıştırır ve bunun sonucu nedir?$$,
           NULL, NULL,
           $$Tek, paylaşılan bir thread -- yavaş bir zamanlanmış görev, arkasındaki her diğer zamanlanmış görevi geciktirebilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'task-execution-and-scheduling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$CPU çekirdek sayısına göre otomatik boyutlandırılmış bir thread havuzu$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$@Async için yapılandırılan aynı TaskExecutor, bu yüzden ikisi de yükü eşit paylaşır$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Tek, paylaşılan bir thread -- yavaş bir zamanlanmış görev, arkasındaki her diğer zamanlanmış görevi geciktirebilir$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$@Scheduled metodu başına bir thread, bu yüzden asla birbirlerine müdahale etmezler$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly distinguish @Async from @Scheduled? (Select all that apply)$$,
           NULL, NULL,
           $$@Async runs in response to something, now; @Scheduled runs on its own on a timer. They use separate pools (TaskExecutor vs TaskScheduler) despite sharing conceptual thread-pool machinery.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'task-execution-and-scheduling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$@Async means "run this asynchronously, right now, in response to something"; @Scheduled means "run this at a specific time or interval, on its own"$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$They share the same underlying thread-pool machinery conceptually, but use separate, independently configured pools (TaskExecutor vs TaskScheduler)$$, TRUE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$@Async and @Scheduled are interchangeable and solve the exact same problem$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$@Scheduled cannot return a CompletableFuture, while @Async always must$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri @Async'i @Scheduled'dan doğru şekilde ayırt eder? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$@Async bir şeye tepki olarak şimdi çalışır; @Scheduled kendi başına bir zamanlayıcıyla çalışır. Kavramsal olarak aynı altyapıyı paylaşsalar da ayrı havuzlar (TaskExecutor/TaskScheduler) kullanırlar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'task-execution-and-scheduling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$@Scheduled bir CompletableFuture döndüremez, @Async ise her zaman döndürmek zorundadır$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$@Async, "bunu şimdi, bir şeye tepki olarak asenkron çalıştır" anlamına gelir; @Scheduled, "bunu belirli bir zamanda ya da aralıkla, kendi başına çalıştır" anlamına gelir$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$@Async ile @Scheduled birbirinin yerine kullanılabilir ve tam olarak aynı sorunu çözer$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Kavramsal olarak aynı temel thread-pool altyapısını paylaşırlar, ama ayrı, bağımsız yapılandırılan havuzlar (TaskExecutor ile TaskScheduler) kullanırlar$$, TRUE, 3 FROM new_question_tr7;
