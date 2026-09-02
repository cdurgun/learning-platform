-- Promotion batch
-- Topic: spring-mvc-testing (language: en x7, tr x7)
-- Generated: 2026-09-02 (this migration file's authoring date)
--
-- Like question-promotion/V659-V678 (Spring Core) and V631-V655
-- (Functional Interfaces & Streams), these 14 questions were NOT produced
-- by the n8n generation pipeline, NOT judged by the AI Judge, and NOT
-- ingested via /api/internal/questions/ingest -- per explicit user request,
-- they were hand-authored and independently self-reviewed directly inside a
-- Claude Code session, grounded strictly in content/en/spring-mvc-testing.md and
-- content/tr/spring-mvc-testing.md.
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
           $$What does @WebMvcTest load, and what does it deliberately exclude?$$,
           NULL, NULL,
           $$It loads DispatcherServlet, message converters, and the given controller(s) -- but excludes @Service/@Repository beans.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It loads the entire application, including a real database connection$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$It loads DispatcherServlet, message converters, and the given controller(s) -- but excludes @Service/@Repository beans$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It loads only the @Service layer, excluding all web components$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$It loads nothing at all until @MockitoBean is added$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$@WebMvcTest neyi yükler ve bilinçli olarak neyi hariç tutar?$$,
           NULL, NULL,
           $$DispatcherServlet'i, message converter'ları ve verilen controller'ları yükler -- ama @Service/@Repository bean'lerini hariç tutar.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$DispatcherServlet'i, message converter'ları ve verilen controller'ları yükler -- ama @Service/@Repository bean'lerini hariç tutar$$, TRUE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Gerçek bir veritabanı bağlantısı dahil, tüm uygulamayı yükler$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Yalnızca @Service katmanını yükler, tüm web bileşenlerini hariç tutar$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$@MockitoBean eklenene kadar hiçbir şey yüklemez$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What is the key difference between MockMvcBuilders.standaloneSetup(...) and @WebMvcTest combined with an autowired MockMvc?$$,
           NULL, NULL,
           $$standaloneSetup(...) wires controllers by hand without a Spring ApplicationContext, while @WebMvcTest loads a real (narrowed) Spring context.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$standaloneSetup(...) requires a real database connection, @WebMvcTest does not$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$@WebMvcTest cannot be combined with @MockitoBean$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$They are functionally identical in every respect$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$standaloneSetup(...) wires controllers by hand without a Spring ApplicationContext, while @WebMvcTest loads a real (narrowed) Spring context$$, TRUE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$MockMvcBuilders.standaloneSetup(...) ile autowired bir MockMvc içeren @WebMvcTest arasındaki temel fark nedir?$$,
           NULL, NULL,
           $$standaloneSetup(...), controller'ları bir Spring ApplicationContext'i olmadan elle bağlar; @WebMvcTest ise gerçek (daraltılmış) bir Spring context'i yükler.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$standaloneSetup(...) gerçek bir veritabanı bağlantısı gerektirir, @WebMvcTest gerektirmez$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$@WebMvcTest, @MockitoBean ile birlikte kullanılamaz$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$standaloneSetup(...), controller'ları bir Spring ApplicationContext'i olmadan elle bağlar; @WebMvcTest ise gerçek (daraltılmış) bir Spring context'i yükler$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Her açıdan işlevsel olarak birebir aynıdırlar$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What does @MockitoBean do, and why did this project's lesson stop using @MockBean?$$,
           NULL, NULL,
           $$@MockitoBean adds a Mockito mock to the test context (or replaces a real bean); @MockBean was deprecated in Spring Boot 3.4 and removed in the 4.1.0 this project runs.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$@MockitoBean adds a Mockito mock to the test context (or replaces a real bean); @MockBean was deprecated in Spring Boot 3.4 and removed in the 4.1.0 this project runs$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$@MockitoBean is a stricter, compile-time-only version of @MockBean with no runtime behavior$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$@MockBean is still the recommended annotation; @MockitoBean is only for @SpringBootTest$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$@MockitoBean requires manual bean registration in a separate configuration class$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$@MockitoBean ne yapar ve bu projenin dersi @MockBean kullanmayı neden bıraktı?$$,
           NULL, NULL,
           $$@MockitoBean, test context'ine bir Mockito mock ekler (veya gerçek bir bean'i değiştirir); @MockBean Spring Boot 3.4'te kullanımdan kaldırıldı ve bu projenin çalıştırdığı 4.1.0'da kaldırıldı.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$@MockitoBean, @MockBean'in yalnızca derleme zamanı için daha katı bir sürümüdür, çalışma zamanı davranışı yoktur$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$@MockBean hâlâ önerilen annotation'dır; @MockitoBean yalnızca @SpringBootTest içindir$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$@MockitoBean, ayrı bir yapılandırma sınıfında elle bean kaydı gerektirir$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$@MockitoBean, test context'ine bir Mockito mock ekler (veya gerçek bir bean'i değiştirir); @MockBean Spring Boot 3.4'te kullanımdan kaldırıldı ve bu projenin çalıştırdığı 4.1.0'da kaldırıldı$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What happens when this test runs?$$,
           $$mockMvc.perform(get("/api/topics"))
    .andExpect(status().isOk())
    .andExpect(jsonPath("$.title").value("Records"));
// The actual response body is: [{"title": "Records"}, {"title": "Generics"}]$$, $$java$$,
           $$It fails, because the response is a JSON array -- the correct expression would be $[0].title, not $.title.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It throws a NullPointerException before the assertion runs$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$It passes only if the array has exactly one element$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$It passes, since "Records" is indeed present in the response$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$It fails, because the response is a JSON array -- the correct expression would be $[0].title, not $.title$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu test çalıştığında ne olur?$$,
           $$mockMvc.perform(get("/api/konular"))
    .andExpect(status().isOk())
    .andExpect(jsonPath("$.baslik").value("Kayıtlar"));
// Gerçek response body'si: [{"baslik": "Kayıtlar"}, {"baslik": "Generics"}]$$, $$java$$,
           $$Başarısız olur, çünkü response bir JSON dizisidir -- doğru ifade $.baslik değil, $[0].baslik olmalıdır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Assertion çalışmadan önce bir NullPointerException fırlatır$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Yalnızca dizi tam olarak bir eleman içeriyorsa geçer$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Başarısız olur, çünkü response bir JSON dizisidir -- doğru ifade $.baslik değil, $[0].baslik olmalıdır$$, TRUE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$"Kayıtlar" response'ta gerçekten mevcut olduğu için geçer$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A test sends mockMvc.perform(post("/users").content(requestJson)) -- without calling .contentType(...). Which of the following are consequences? (Select all that apply)$$,
           NULL, NULL,
           $$Without contentType(...), Spring may not know which HttpMessageConverter to use, and the request can be rejected with 415 Unsupported Media Type.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Spring may not be able to determine which HttpMessageConverter to use to parse the body$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$The request can be rejected with 415 Unsupported Media Type$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$The test always passes regardless, since content() alone is sufficient$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$contentType(...) is only needed for GET requests, never for POST$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir test, .contentType(...) çağırmadan mockMvc.perform(post("/kullanicilar").content(requestJson)) gönderiyor. Aşağıdakilerden hangileri bunun sonuçlarıdır? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$contentType(...) olmadan, Spring hangi HttpMessageConverter'ın kullanılacağını bilemeyebilir ve istek 415 Unsupported Media Type ile reddedilebilir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İstek, 415 Unsupported Media Type ile reddedilebilir$$, TRUE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Spring, gövdeyi ayrıştırmak için hangi HttpMessageConverter'ın kullanılacağını belirleyemeyebilir$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Tek başına content() yeterli olduğu için test her koşulda geçer$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$contentType(...) yalnızca GET istekleri için gereklidir, POST için asla gerekmez$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What actually happens when this test runs?$$,
           $$mockMvc = MockMvcBuilders.standaloneSetup(new ProductController()).build();
// No .setControllerAdvice(...) call

// Test sends an invalid @Valid @RequestBody that fails validation
mockMvc.perform(post("/products").content(invalidJson).contentType(APPLICATION_JSON))
    .andExpect(status().isBadRequest());$$, $$java$$,
           $$The validator IS set up by default and does throw MethodArgumentNotValidException, but since no advice converts it, the test hits an unexpected 500 instead of the expected 400.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The validator IS set up by default and does throw MethodArgumentNotValidException, but since no advice converts it, the test hits an unexpected 500 instead of the expected 400$$, TRUE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$It throws a compile-time error, since standaloneSetup requires an advice to be passed$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$It passes, since standaloneSetup automatically adds a ProblemDetail-producing advice$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$@Valid is silently skipped entirely since no advice was registered, so the test always fails with 200 OK$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu test çalıştığında gerçekte ne olur?$$,
           $$mockMvc = MockMvcBuilders.standaloneSetup(new UrunController()).build();
// .setControllerAdvice(...) çağrısı yok

// Test, doğrulamayı başarısız kılan geçersiz bir @Valid @RequestBody gönderiyor
mockMvc.perform(post("/urunler").content(gecersizJson).contentType(APPLICATION_JSON))
    .andExpect(status().isBadRequest());$$, $$java$$,
           $$Validator varsayılan olarak kuruludur ve gerçekten bir MethodArgumentNotValidException fırlatır, ama hiçbir advice bunu dönüştürmediği için test, beklenen 400 yerine beklenmeyen bir 500 ile karşılaşır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hiçbir advice kaydedilmediği için @Valid tamamen sessizce atlanır, bu yüzden test her zaman 200 OK ile başarısız olur$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$standaloneSetup'ın bir advice geçirilmesini gerektirdiği için bir derleme zamanı hatası fırlatır$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Validator varsayılan olarak kuruludur ve gerçekten bir MethodArgumentNotValidException fırlatır, ama hiçbir advice bunu dönüştürmediği için test, beklenen 400 yerine beklenmeyen bir 500 ile karşılaşır$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$standaloneSetup, otomatik olarak bir ProblemDetail üreten advice eklediği için geçer$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What is MockMultipartFile, and when is it used?$$,
           NULL, NULL,
           $$A real spring-test (test-scope) class used to build a fake file for testing multipart/form-data endpoints, paired with the multipart(...) request builder.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A production-scope class used to simulate slow network uploads$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$A real spring-test (test-scope) class used to build a fake file for testing multipart/form-data endpoints, paired with the multipart(...) request builder$$, TRUE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$A deprecated class replaced by @MockitoBean$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$A class that can only be used together with @SpringBootTest, never with standaloneSetup(...)$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$MockMultipartFile nedir ve ne zaman kullanılır?$$,
           NULL, NULL,
           $$multipart/form-data uç noktalarını test etmek için sahte bir dosya oluşturmakta kullanılan, multipart(...) request builder'ıyla eşleştirilen gerçek bir spring-test (test-scope) sınıfı.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-testing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$multipart/form-data uç noktalarını test etmek için sahte bir dosya oluşturmakta kullanılan, multipart(...) request builder'ıyla eşleştirilen gerçek bir spring-test (test-scope) sınıfı$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Yavaş ağ yüklemelerini simüle etmek için kullanılan bir production-scope sınıfı$$, FALSE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$@MockitoBean ile değiştirilmiş, kullanımdan kaldırılmış bir sınıf$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Yalnızca @SpringBootTest ile birlikte kullanılabilen, standaloneSetup(...) ile asla kullanılamayan bir sınıf$$, FALSE, 3 FROM new_question_tr7;
