-- Promotion batch
-- Topic: observability (language: en x5, tr x5)
-- Generated: 2026-09-07 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 10 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/observability.md and content/tr/observability.md -- NOT produced by n8n,
-- NOT judged by any external AI API, and NOT ingested via
-- /api/internal/questions/ingest.
--
-- Per-topic question count is FLEXIBLE (5 EN + 5 TR here), sized to
-- this lesson's actual concept density -- same convention established in the
-- Docker/PostgreSQL Foundations/git-github batches.
--
-- Strict 50/50 EN/TR split organized as 5 CONCEPT PAIRS -- each EN question
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
           $$Per "The Three Pillars: Logs, Metrics, and Traces," which of the three is best suited to answering "where did THIS particular request spend its time, and which service did it fail in"?$$,
           NULL, NULL,
           $$The lesson explains traces follow a single request as it moves across multiple services, answering exactly this question.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$observability$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Logs$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Metrics$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Traces$$, TRUE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$None of the three -- that question can't be answered by observability tooling$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$"The Three Pillars: Logs, Metrics, and Traces" bölümüne göre, üçünden hangisi "BU belirli istek zamanını nerede harcadı, ve hangi serviste başarısız oldu" sorusunu yanıtlamaya en uygundur?$$,
           NULL, NULL,
           $$Ders, trace'lerin tek bir isteği birden fazla servis boyunca hareket ederken takip ettiğini, tam olarak bu soruyu yanıtladığını açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$observability$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Log'lar$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Metrikler$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Trace'ler$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Üçünden hiçbiri -- bu soru observability araçlarıyla yanıtlanamaz$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Per "Common Mistakes," what real bug does forgetting to clear MDC in a finally block cause?$$,
           NULL, NULL,
           $$The lesson explains a servlet container reuses threads across requests, so one request's correlation id leaks into a completely unrelated later request's logs.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$observability$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The application immediately crashes with an OutOfMemoryError$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$A servlet container reuses threads across requests, so one request's correlation id leaks into a completely unrelated later request's logs$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$MDC values are automatically encrypted and become unreadable$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$The correlation id is duplicated across every service simultaneously$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$"Common Mistakes" bölümüne göre, bir finally bloğunda MDC'yi temizlemeyi unutmak hangi gerçek hataya yol açar?$$,
           NULL, NULL,
           $$Ders, bir servlet container'ın thread'leri istekler arasında yeniden kullandığını, bu yüzden bir isteğin correlation id'sinin tamamen ilgisiz, sonraki bir isteğin log'larına sızdığını açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$observability$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Uygulama hemen bir OutOfMemoryError ile çöker$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Bir servlet container, thread'leri istekler arasında yeniden kullanır, bu yüzden bir isteğin correlation id'si tamamen ilgisiz, sonraki bir isteğin log'larına sızar$$, TRUE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$MDC değerleri otomatik olarak şifrelenir ve okunamaz hâle gelir$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Correlation id, tüm servislerde aynı anda çoğaltılır$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this custom metric code, what does this actually do, in the context of this lesson's observability pillars?$$,
           $$Counter.builder("orders.placed")
    .register(meterRegistry)
    .increment();$$, $$java$$,
           $$The lesson's quick-reference explains this increments a numeric counter metric, tracked over time via Micrometer/Actuator.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$observability$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It writes a structured JSON log line about the order$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$It increments a numeric counter metric, tracked over time via Micrometer/Actuator$$, TRUE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$It starts a new distributed trace span for this request$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$It sends the order data to inventory-service over Kafka$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdaki özel metrik kodu göz önüne alındığında, bu, bu dersin observability sütunları bağlamında gerçekte ne yapar?$$,
           $$Counter.builder("orders.placed")
    .register(meterRegistry)
    .increment();$$, $$java$$,
           $$Dersin hızlı referansı, bunun Micrometer/Actuator aracılığıyla zaman içinde izlenen sayısal bir counter metriğini artırdığını açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$observability$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Sipariş hakkında yapılandırılmış bir JSON log satırı yazar$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Micrometer/Actuator aracılığıyla zaman içinde izlenen sayısal bir counter metriğini artırır$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Bu istek için yeni bir distributed trace span'i başlatır$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Sipariş verisini Kafka üzerinden inventory-service'e gönderir$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, ADVANCED)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Per "Exposing What Resilience4j Was Already Tracking," why does this lesson say the manual CircuitBreakerEventListener from the Resilience4j lesson is still useful, even though Micrometer already integrates automatically?$$,
           NULL, NULL,
           $$The lesson explains the manual listener gives immediate, human-readable log lines during development, while Micrometer's integration is what a real dashboard/alert watches in production.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$observability$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Because Micrometer cannot track circuit breaker states under any configuration$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Because the manual listener gives immediate, human-readable log lines during development, while Micrometer's integration is what a real dashboard/alert watches in production$$, TRUE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Because CircuitBreakerEventListener is required for the circuit breaker to function at all$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Because Micrometer integration only works for @Retry, not @CircuitBreaker$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, ADVANCED)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$"Exposing What Resilience4j Was Already Tracking" bölümüne göre, Micrometer zaten otomatik olarak entegre olsa bile, bu ders Resilience4j dersindeki elle yazılmış CircuitBreakerEventListener'ın hâlâ neden yararlı olduğunu söyler?$$,
           NULL, NULL,
           $$Ders, elle yazılmış listener'ın geliştirme sırasında anında, insan tarafından okunabilir log satırları verdiğini, Micrometer entegrasyonunun ise production'da gerçek bir dashboard/alert'in izlediği şey olduğunu açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$observability$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çünkü Micrometer, hiçbir yapılandırma altında circuit breaker durumlarını izleyemez$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Çünkü elle yazılmış listener geliştirme sırasında anında, insan tarafından okunabilir log satırları verirken, Micrometer entegrasyonu production'da gerçek bir dashboard/alert'in izlediği şeydir$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Çünkü CircuitBreakerEventListener, circuit breaker'ın hiç çalışması için gereklidir$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Çünkü Micrometer entegrasyonu yalnızca @Retry için çalışır, @CircuitBreaker için değil$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are presented in this lesson as genuine mistakes in observability practice? (Select all that apply)$$,
           NULL, NULL,
           $$The lesson's Common Mistakes list treating metrics/logs as replacements and not propagating the correlation id past the first service as mistakes; tagging metrics with the producing service and consistent propagation are the recommended best practices.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$observability$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Treating metrics as a full replacement for logs, or vice versa$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Tagging every metric with the service that produced it$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Assigning a correlation id at the gateway but never propagating it past the first service$$, TRUE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Propagating the correlation id across every service boundary consistently$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri, bu derste observability pratiğinde yapılan gerçek hatalar olarak sunulur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Dersin Common Mistakes listesi metrikleri/log'ları birbirinin yerine geçeni olarak ele almayı ve correlation id'yi ilk servisten sonra yaymamayı hata olarak sayar; her metriği üreten servisle etiketlemek ve tutarlı yayma ise önerilen en iyi pratiklerdir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$observability$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Metrikleri log'ların tam bir yerine geçeni olarak ele almak, ya da tam tersi$$, TRUE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Her metriği onu üreten servisle etiketlemek$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Correlation id'yi gateway'de atamak ama onu ilk servisten sonra hiç yaymamak$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Correlation id'yi her servis sınırında tutarlı bir şekilde yaymak$$, FALSE, 3 FROM new_question_tr5;
