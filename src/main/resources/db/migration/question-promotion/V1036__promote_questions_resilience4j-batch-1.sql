-- Promotion batch
-- Topic: resilience4j (language: en x6, tr x6)
-- Generated: 2026-09-07 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 12 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/resilience4j.md and content/tr/resilience4j.md -- NOT produced by n8n,
-- NOT judged by any external AI API, and NOT ingested via
-- /api/internal/questions/ingest.
--
-- Per-topic question count is FLEXIBLE (6 EN + 6 TR here), sized to
-- this lesson's actual concept density -- same convention established in the
-- Docker/PostgreSQL Foundations/git-github batches.
--
-- Strict 50/50 EN/TR split organized as 6 CONCEPT PAIRS -- each EN question
-- has a TR counterpart testing the exact same concept, but independently
-- authored (different framing/distractors), not a translation. Every
-- question whose answer depends on shown code/config output is typed
-- CODE_OUTPUT (never SINGLE_CHOICE/MULTIPLE_CHOICE with a code_snippet
-- attached).
--
-- source = 'CLAUDE' / reviewed_by = 'claude-code@anthropic.com' / status =
-- 'PUBLISHED' directly. topic_id resolved by Topic.slug; question_option
-- rows reference the newly generated id via a WITH ... RETURNING id CTE.
--
-- Duplicate-promotion safety: N/A -- this batch was never ingested into
-- development, so no dev ids exist for these questions at all.

-- Pair 1 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What real gap in order-service's existing error handling does this lesson's Resilience4j introduction address?$$,
           NULL, NULL,
           $$The lesson explains even with 404-vs-unreachable handling in place, order-service still hammered a struggling inventory-service with every request instead of backing off.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$resilience4j$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$order-service had no way to serialize JSON responses before this lesson$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Even with 404-vs-unreachable handling in place, order-service still hammered a struggling inventory-service with every request instead of backing off$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$order-service couldn't connect to any database before this lesson$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$RestClient didn't exist as an API before Resilience4j was introduced$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu dersin Resilience4j tanıtımı, order-service'in mevcut hata yönetimindeki hangi gerçek boşluğu ele alır?$$,
           NULL, NULL,
           $$Ders, 404-vs-erişilemez ayrımı zaten var olsa bile, order-service'in her istekte geri çekilmek yerine zorlanan inventory-service'e yüklenmeye devam ettiğini açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$resilience4j$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$order-service'in bu dersten önce JSON yanıtlarını serialize etmenin bir yolu yoktu$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$404-vs-erişilemez ayrımı zaten var olsa bile, order-service her istekte geri çekilmek yerine zorlanan inventory-service'e yüklenmeye devam ediyordu$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$order-service'in bu dersten önce hiçbir veritabanına bağlanamıyordu$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$RestClient, Resilience4j tanıtılmadan önce bir API olarak var olmuyordu$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Per "Circuit Breaker: States and Configuration," what happens once the circuit breaker trips to the OPEN state?$$,
           NULL, NULL,
           $$The lesson explains every call fails immediately, without even attempting the real call, for a configured wait duration once the circuit is OPEN.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$resilience4j$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The real call is still attempted, but with a longer timeout$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Every call fails immediately, without even attempting the real call, for a configured wait duration$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$The application immediately shuts down$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$All future calls are automatically retried three times before failing$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$"Circuit Breaker: States and Configuration" bölümüne göre, circuit breaker OPEN durumuna geçtiğinde ne olur?$$,
           NULL, NULL,
           $$Ders, circuit OPEN olduğunda, yapılandırılmış bir bekleme süresi boyunca, gerçek çağrı hiç denenmeden her çağrının hemen başarısız olduğunu açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$resilience4j$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Gerçek çağrı yine de denenir, ama daha uzun bir zaman aşımıyla$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Yapılandırılmış bir bekleme süresi boyunca, gerçek çağrı hiç denenmeden, her çağrı hemen başarısız olur$$, TRUE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Uygulama hemen kapanır$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Tüm gelecekteki çağrılar, başarısız olmadan önce otomatik olarak üç kez yeniden denenir$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, ADVANCED)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Per the warning under "Wrapping StockClient with a Circuit Breaker," what happens if a method on the same class calls this.checkStock(...) directly instead of going through the injected bean?$$,
           NULL, NULL,
           $$The lesson explains this bypasses Spring's proxy entirely, exactly like @Transactional, so neither @CircuitBreaker nor @Retry ever runs.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$resilience4j$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Nothing changes -- annotations apply regardless of how a method is invoked$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$The call bypasses Spring's proxy entirely, so neither @CircuitBreaker nor @Retry ever runs$$, TRUE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$The application fails to start, throwing a BeanCreationException$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$The circuit breaker immediately trips to OPEN as a safety measure$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, ADVANCED)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$"Wrapping StockClient with a Circuit Breaker" bölümündeki uyarıya göre, aynı sınıftaki bir metot, inject edilmiş bean üzerinden gitmek yerine doğrudan this.checkStock(...) çağırırsa ne olur?$$,
           NULL, NULL,
           $$Ders, bunun tam olarak @Transactional gibi, Spring'in proxy mekanizmasını tamamen atladığını, bu yüzden ne @CircuitBreaker ne de @Retry'ın hiçbir zaman çalışmadığını açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$resilience4j$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hiçbir şey değişmez -- annotation'lar bir metodun nasıl çağrıldığından bağımsız olarak uygulanır$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Çağrı, Spring'in proxy mekanizmasını tamamen atlar, bu yüzden ne @CircuitBreaker ne de @Retry hiçbir zaman çalışmaz$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Uygulama başlatılamaz, bir BeanCreationException fırlatır$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Circuit breaker, bir güvenlik önlemi olarak hemen OPEN durumuna geçer$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Per "Retry: Trying Again Before Giving Up," in what order do @Retry and @CircuitBreaker actually interact on the same annotated method?$$,
           NULL, NULL,
           $$The lesson explains @Retry retries a failed call the configured number of times before the circuit breaker ever records that failure.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$resilience4j$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The circuit breaker always runs first, and retry only applies to genuinely open circuits$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$@Retry retries a failed call the configured number of times before the circuit breaker ever records that failure$$, TRUE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$They cannot be combined on the same method at all$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$@Retry and @CircuitBreaker run in two completely separate threads simultaneously$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$"Retry: Trying Again Before Giving Up" bölümüne göre, @Retry ve @CircuitBreaker, aynı annotate edilmiş metotta gerçekte hangi sırayla etkileşir?$$,
           NULL, NULL,
           $$Ders, @Retry'ın, circuit breaker o başarısızlığı hiç kaydetmeden önce, başarısız bir çağrıyı yapılandırılan sayıda yeniden denediğini açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$resilience4j$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Circuit breaker her zaman önce çalışır, ve retry yalnızca gerçekten açık devrelere uygulanır$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$@Retry, circuit breaker o başarısızlığı hiç kaydetmeden önce, başarısız bir çağrıyı yapılandırılan sayıda yeniden dener$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$İkisi aynı metotta hiçbir şekilde birleştirilemez$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$@Retry ve @CircuitBreaker, aynı anda tamamen ayrı iki thread'de çalışır$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this Resilience4j configuration, if 6 of the last 10 calls to inventoryService have failed, what state does the circuit breaker move to?$$,
           $$resilience4j:
  circuitbreaker:
    instances:
      inventoryService:
        sliding-window-type: COUNT_BASED
        sliding-window-size: 10
        failure-rate-threshold: 50
        wait-duration-in-open-state: 10s$$, $$yaml$$,
           $$The lesson explains a failure rate crossing the configured threshold trips the circuit to OPEN -- 60% exceeds the 50% failure-rate-threshold here.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$resilience4j$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It stays CLOSED, since 6 failures is below the sliding window size of 10$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$It trips to OPEN, since 60% exceeds the configured 50% failure-rate-threshold$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$It moves directly to HALF_OPEN, skipping OPEN entirely$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$It stays CLOSED forever, since wait-duration-in-open-state prevents any state change$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdaki Resilience4j yapılandırması göz önüne alındığında, inventoryService'e yapılan son 10 çağrının 6'sı başarısız olduysa, circuit breaker hangi duruma geçer?$$,
           $$resilience4j:
  circuitbreaker:
    instances:
      inventoryService:
        sliding-window-type: COUNT_BASED
        sliding-window-size: 10
        failure-rate-threshold: 50
        wait-duration-in-open-state: 10s$$, $$yaml$$,
           $$Ders, yapılandırılmış eşiği aşan bir başarısızlık oranının circuit'i OPEN'a geçirdiğini açıklar -- burada %60, %50'lik failure-rate-threshold'u aşar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$resilience4j$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$CLOSED kalır, çünkü 6 başarısızlık, 10'luk sliding window boyutunun altındadır$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$OPEN'a geçer, çünkü %60, yapılandırılmış %50'lik failure-rate-threshold'u aşar$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$OPEN'ı tamamen atlayarak doğrudan HALF_OPEN'a geçer$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$wait-duration-in-open-state herhangi bir durum değişikliğini engellediği için sonsuza kadar CLOSED kalır$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about Resilience4j's guards, per this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$The lesson explains rate limiters/bulkheads guard against overload even when healthy, and a fallback method's signature must match plus a trailing Throwable; bulkhead-as-substitute and retry-vs-circuit-breaker-as-competing are explicitly called out as misconceptions.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$resilience4j$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A rate limiter and a bulkhead guard against overload, even when the target service is completely healthy$$, TRUE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$A bulkhead is a substitute for a circuit breaker when a service is genuinely down$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$A fallback method's signature must match the original method's parameters plus a trailing Throwable$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$@Retry and @CircuitBreaker are competing choices that can never be applied together$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdaki ifadelerden hangileri, bu derse göre, Resilience4j'nin koruyucuları hakkında doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Ders, rate limiter/bulkhead'in sağlıklıyken bile aşırı yüklenmeye karşı koruduğunu, fallback metot imzasının orijinal parametreler artı sondaki bir Throwable ile eşleşmesi gerektiğini açıklar; bulkhead'in yerine geçme ve retry-vs-circuit-breaker'ın rakip olması ise açıkça yanlış anlama olarak sayılır.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$resilience4j$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir rate limiter ve bir bulkhead, hedef servis tamamen sağlıklı olsa bile aşırı yüklenmeye karşı korur$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir bulkhead, bir servis gerçekten çökmüşken bir circuit breaker'ın yerine geçebilir$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir fallback metodunun imzası, orijinal metodun parametreleri artı sondaki bir Throwable ile eşleşmelidir$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$@Retry ve @CircuitBreaker, hiçbir zaman birlikte uygulanamayan rakip seçeneklerdir$$, FALSE, 3 FROM new_question_tr6;
