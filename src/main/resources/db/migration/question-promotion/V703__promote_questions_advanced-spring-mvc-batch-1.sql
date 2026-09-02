-- Promotion batch
-- Topic: advanced-spring-mvc (language: en x7, tr x7)
-- Generated: 2026-09-02 (this migration file's authoring date)
--
-- Like question-promotion/V659-V678 (Spring Core) and V631-V655
-- (Functional Interfaces & Streams), these 14 questions were NOT produced
-- by the n8n generation pipeline, NOT judged by the AI Judge, and NOT
-- ingested via /api/internal/questions/ingest -- per explicit user request,
-- they were hand-authored and independently self-reviewed directly inside a
-- Claude Code session, grounded strictly in content/en/advanced-spring-mvc.md and
-- content/tr/advanced-spring-mvc.md.
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
           $$What is the key architectural difference between a Filter and a HandlerInterceptor?$$,
           NULL, NULL,
           $$Filter is part of the Servlet API and sees every request, before DispatcherServlet; HandlerInterceptor only sees requests DispatcherServlet has matched to a handler.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'advanced-spring-mvc'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$They operate at exactly the same layer with no difference$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Filter is part of the Servlet API and sees every request (even static files or 404s), before DispatcherServlet; HandlerInterceptor only sees requests DispatcherServlet has matched to a handler$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$HandlerInterceptor runs before DispatcherServlet, Filter runs after$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Filter only works with @RestControllers$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir Filter ile bir HandlerInterceptor arasındaki temel mimari fark nedir?$$,
           NULL, NULL,
           $$Filter, Servlet API'nin bir parçasıdır ve DispatcherServlet'ten önce her isteği görür; HandlerInterceptor yalnızca DispatcherServlet'in bir handler'a eşlediği istekleri görür.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'advanced-spring-mvc'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Filter, Servlet API'nin bir parçasıdır ve DispatcherServlet'ten önce her isteği görür (statik dosyalar veya 404'ler dahil); HandlerInterceptor yalnızca DispatcherServlet'in bir handler'a eşlediği istekleri görür$$, TRUE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Tamamen aynı katmanda, hiçbir fark olmadan çalışırlar$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$HandlerInterceptor, DispatcherServlet'ten önce çalışır, Filter sonra çalışır$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Filter yalnızca @RestController'larla çalışır$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about HandlerInterceptor's three callbacks are correct? (Select all that apply)$$,
           NULL, NULL,
           $$preHandle runs before the handler, returning false stops the chain; afterCompletion runs even on exception; postHandle runs after the handler succeeds but before the view renders.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'advanced-spring-mvc'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$postHandle runs before the handler method is called$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$postHandle runs after the handler completes successfully, but before the view is rendered$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$preHandle runs before the handler method; returning false stops the chain immediately$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$afterCompletion runs after the view is rendered, even if the handler threw an exception$$, TRUE, 3 FROM new_question_en2;

-- Pair 2 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$HandlerInterceptor'ın üç callback'iyle ilgili aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$preHandle, handler'dan önce çalışır, false döndürmek zinciri durdurur; afterCompletion istisna olsa bile çalışır; postHandle, handler başarılı olduktan sonra ama view render edilmeden önce çalışır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'advanced-spring-mvc'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$postHandle, handler metodu çağrılmadan önce çalışır$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$afterCompletion, handler bir istisna fırlatmış olsa bile, view render edildikten sonra çalışır$$, TRUE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$postHandle, handler başarıyla tamamlandıktan sonra ama view render edilmeden önce çalışır$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$preHandle, handler metodundan önce çalışır; false döndürmek zinciri hemen durdurur$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, ADVANCED)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Given a Filter wrapping DispatcherServlet's entire call, and a HandlerInterceptor registered on the matched handler, what is the correct nesting order for the "after" phase of a request?$$,
           NULL, NULL,
           $$The interceptor's afterCompletion runs after the view is rendered, but still before the filter's own "after" code runs.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'advanced-spring-mvc'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Filter's after-code runs, then the interceptor's afterCompletion$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$The interceptor's afterCompletion runs after the view is rendered, but still before the filter's own "after" code runs$$, TRUE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Both run simultaneously, in parallel$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$afterCompletion never runs if a Filter is also registered$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, ADVANCED)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$DispatcherServlet'in tüm çağrısını saran bir Filter ve eşleşen handler'a kayıtlı bir HandlerInterceptor verildiğinde, bir isteğin "sonra" fazı için doğru iç içe geçme sırası nedir?$$,
           NULL, NULL,
           $$Interceptor'ın afterCompletion'ı, view render edildikten sonra ama yine de filter'ın kendi "sonra" kodundan önce çalışır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'advanced-spring-mvc'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Interceptor'ın afterCompletion'ı, view render edildikten sonra ama yine de filter'ın kendi "sonra" kodundan önce çalışır$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Önce filter'ın sonra-kodu çalışır, sonra interceptor'ın afterCompletion'ı$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$İkisi de aynı anda, paralel olarak çalışır$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Bir Filter de kayıtlıysa afterCompletion hiç çalışmaz$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Both interceptors' preHandle return true. In what order do postHandle calls run?$$,
           $$// Registered in order: AuthInterceptor, then LoggingInterceptor
registry.addInterceptor(authInterceptor);
registry.addInterceptor(loggingInterceptor);$$, $$java$$,
           $$preHandle runs in registration order; postHandle/afterCompletion run in reverse order -- so LoggingInterceptor's postHandle runs first, then AuthInterceptor's.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'advanced-spring-mvc'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A random order, since Spring doesn't guarantee any sequence$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Both run simultaneously$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$AuthInterceptor, then LoggingInterceptor (same as registration order)$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$LoggingInterceptor, then AuthInterceptor (reverse of registration order)$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Her iki interceptor'ın da preHandle'ı true döndürüyor. postHandle çağrıları hangi sırada çalışır?$$,
           $$// Şu sırayla kayıtlı: önce AuthInterceptor, sonra LoggingInterceptor
registry.addInterceptor(authInterceptor);
registry.addInterceptor(loggingInterceptor);$$, $$java$$,
           $$preHandle kayıt sırasıyla çalışır; postHandle/afterCompletion ters sırayla çalışır -- bu yüzden önce LoggingInterceptor'ın postHandle'ı, sonra AuthInterceptor'ınki çalışır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'advanced-spring-mvc'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Spring herhangi bir sıra garanti etmediği için rastgele bir sıra$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$İkisi de aynı anda çalışır$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$LoggingInterceptor, sonra AuthInterceptor (kayıt sırasının tersi)$$, TRUE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$AuthInterceptor, sonra LoggingInterceptor (kayıt sırasıyla aynı)$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A request without the X-Api-Key header is sent. What status code does the client actually receive?$$,
           $$@Override
public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
    if (request.getHeader("X-Api-Key") == null) {
        return false; // status code not set!
    }
    return true;
}$$, $$java$$,
           $$The chain stops, but since response.setStatus(...) was never called, the client gets the default 200 status.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'advanced-spring-mvc'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$401 Unauthorized, since that's the semantically correct code$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$403 Forbidden$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$200 OK -- the chain stops, but since response.setStatus(...) was never called, the client gets the default status$$, TRUE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$The request hangs indefinitely with no response$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$X-Api-Key header'ı olmayan bir istek gönderiliyor. İstemci gerçekte hangi durum kodunu alır?$$,
           $$@Override
public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
    if (request.getHeader("X-Api-Key") == null) {
        return false; // durum kodu ayarlanmadı!
    }
    return true;
}$$, $$java$$,
           $$Zincir durur, ama response.setStatus(...) hiç çağrılmadığı için istemci varsayılan durum olan 200'ü alır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'advanced-spring-mvc'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$200 OK -- zincir durur, ama response.setStatus(...) hiç çağrılmadığı için istemci varsayılan durumu alır$$, TRUE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Semantik olarak doğru kod olduğu için 401 Unauthorized$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$403 Forbidden$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$İstek yanıt almadan süresiz olarak askıda kalır$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$For a "non-simple" cross-origin request (e.g., one carrying a custom header), what does the browser do before sending the actual request?$$,
           NULL, NULL,
           $$It sends a preflight OPTIONS request first, asking the server for permission via Access-Control-Allow-* headers.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'advanced-spring-mvc'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It silently blocks the request without any network activity$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$It downgrades the request to a "simple" GET automatically$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$It sends the real request directly, checking headers only in the response$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$It sends a preflight OPTIONS request first, asking the server for permission via Access-Control-Allow-* headers$$, TRUE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$"Basit olmayan" (örneğin özel bir header taşıyan) bir cross-origin istek için, tarayıcı gerçek isteği göndermeden önce ne yapar?$$,
           NULL, NULL,
           $$Önce, sunucudan Access-Control-Allow-* header'ları aracılığıyla izin isteyen bir preflight OPTIONS isteği gönderir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'advanced-spring-mvc'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Herhangi bir ağ etkinliği olmadan isteği sessizce engeller$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$İsteği otomatik olarak "basit" bir GET'e düşürür$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Önce, sunucudan Access-Control-Allow-* header'ları aracılığıyla izin isteyen bir preflight OPTIONS isteği gönderir$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Gerçek isteği doğrudan gönderir, header'ları yalnızca response'ta kontrol eder$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (SINGLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$A request uploads three files, each 2MB, with max-file-size set to 5MB but max-request-size set to 5MB as well. What happens?$$,
           NULL, NULL,
           $$The request is rejected, since the total (6MB) exceeds max-request-size, even though every individual file is under max-file-size -- they're two separate limits.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'advanced-spring-mvc'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$All three files are accepted, since each is under max-file-size individually$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$The request is rejected, since the total (6MB) exceeds max-request-size, even though every individual file is under max-file-size$$, TRUE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Only the first two files are accepted, the third silently dropped$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$max-request-size is ignored when max-file-size is already set$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (SINGLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bir istek, her biri 2MB olan üç dosya yüklüyor; max-file-size 5MB, max-request-size de 5MB olarak ayarlanmış. Ne olur?$$,
           NULL, NULL,
           $$İstek reddedilir, çünkü toplam (6MB) max-request-size'ı aşıyor, her bir dosya tek tek max-file-size'ın altında olsa bile -- bunlar iki ayrı sınırdır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'advanced-spring-mvc'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İstek reddedilir, çünkü toplam (6MB) max-request-size'ı aşıyor, her bir dosya tek tek max-file-size'ın altında olsa bile$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Her biri tek tek max-file-size'ın altında olduğu için üç dosya da kabul edilir$$, FALSE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Yalnızca ilk iki dosya kabul edilir, üçüncüsü sessizce düşürülür$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$max-file-size zaten ayarlıysa max-request-size yok sayılır$$, FALSE, 3 FROM new_question_tr7;
