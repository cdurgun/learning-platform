-- Promotion batch
-- Topic: spring-mvc-fundamentals (language: en x7, tr x7)
-- Generated: 2026-09-02 (this migration file's authoring date)
--
-- Like question-promotion/V659-V678 (Spring Core) and V631-V655
-- (Functional Interfaces & Streams), these 14 questions were NOT produced
-- by the n8n generation pipeline, NOT judged by the AI Judge, and NOT
-- ingested via /api/internal/questions/ingest -- per explicit user request,
-- they were hand-authored and independently self-reviewed directly inside a
-- Claude Code session, grounded strictly in content/en/spring-mvc-fundamentals.md and
-- content/tr/spring-mvc-fundamentals.md.
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
           $$Which component in Spring MVC receives every incoming HTTP request first and routes it to the appropriate controller method?$$,
           NULL, NULL,
           $$DispatcherServlet is the front controller -- every request passes through it first, and it routes to the right controller method via HandlerMapping/HandlerAdapter.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$DispatcherServlet$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$HandlerAdapter$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$ViewResolver$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$ConversionService$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Spring MVC'de gelen her HTTP isteğini ilk karşılayıp uygun controller metoduna yönlendiren bileşen hangisidir?$$,
           NULL, NULL,
           $$DispatcherServlet, front controller'dır -- her istek önce ondan geçer ve HandlerMapping/HandlerAdapter aracılığıyla doğru controller metoduna yönlendirilir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$ConversionService$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$DispatcherServlet$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$ViewResolver$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$HandlerAdapter$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$In a class annotated with @Controller, what does the String value returned by a handler method represent?$$,
           NULL, NULL,
           $$The returned String is the logical view name, handed to ViewResolver -- it is not the raw HTML or the response body directly.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The response body directly$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$The HTTP status message$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$The raw HTML sent to the browser$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$The logical view name, handed to ViewResolver$$, TRUE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$@Controller ile işaretlenmiş bir sınıfta, bir handler metodunun döndürdüğü String değeri neyi temsil eder?$$,
           NULL, NULL,
           $$Döndürülen String, ViewResolver'a iletilen mantıksal view adıdır -- ham HTML ya da doğrudan response body değildir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$HTTP durum mesajı$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Doğrudan response body$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$ViewResolver'a iletilen mantıksal view adı$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Tarayıcıya gönderilen ham HTML$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about @RestController are correct? (Select all that apply)$$,
           NULL, NULL,
           $$@RestController is a meta-annotation combining @Controller and @ResponseBody -- the return value becomes the response body directly, with no ViewResolver involved.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It is a meta-annotation combining @Controller and @ResponseBody$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$A method's return value becomes the response body directly, with no ViewResolver involved$$, TRUE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$It disables JSON serialization by default$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Combining @Controller-style and @RestController-style methods in one class is technically impossible$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$@RestController ile ilgili aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$@RestController, @Controller ile @ResponseBody'yi birleştiren bir meta-annotation'dır -- dönüş değeri, ViewResolver hiç devreye girmeden doğrudan response body olur.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir metodun dönüş değeri, ViewResolver hiç devreye girmeden doğrudan response body olur$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$@Controller ile @ResponseBody'yi birleştiren bir meta-annotation'dır$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$JSON serileştirmeyi varsayılan olarak devre dışı bırakır$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Aynı sınıfta @Controller tarzı ve @RestController tarzı metotları birleştirmek teknik olarak imkânsızdır$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$When is a Model object created and populated for a request in Spring MVC?$$,
           NULL, NULL,
           $$A fresh Model is created by DispatcherServlet for each request and passed to the handler method -- it is never a shared singleton.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It is created only when a @RestController is used$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$It must be manually instantiated inside every controller method$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$It is a singleton shared across all requests$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$A fresh one is created by DispatcherServlet for each request and passed to the handler method$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Spring MVC'de bir Model nesnesi ne zaman oluşturulup doldurulur?$$,
           NULL, NULL,
           $$DispatcherServlet, her istek için yeni bir Model oluşturup handler metoduna geçirir -- asla paylaşılan bir singleton değildir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca bir @RestController kullanıldığında oluşturulur$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Her controller metodunun içinde elle örneklenmelidir$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$DispatcherServlet her istek için yeni bir tane oluşturup handler metoduna geçirir$$, TRUE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Tüm istekler arasında paylaşılan bir singleton'dır$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What is the division of labor between HandlerMapping and HandlerAdapter?$$,
           NULL, NULL,
           $$HandlerMapping finds which method should handle the request; HandlerAdapter calls it with the right parameters.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$HandlerMapping calls the method, HandlerAdapter finds it$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$HandlerMapping finds which method should handle the request, HandlerAdapter calls it with the right parameters$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$They perform the exact same job redundantly$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$HandlerAdapter only runs for @RestControllers, HandlerMapping only for @Controllers$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$HandlerMapping ile HandlerAdapter arasındaki iş bölümü nedir?$$,
           NULL, NULL,
           $$HandlerMapping isteği hangi metodun karşılayacağını bulur; HandlerAdapter doğru parametrelerle onu çağırır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$HandlerMapping isteği hangi metodun karşılayacağını bulur, HandlerAdapter doğru parametrelerle onu çağırır$$, TRUE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$HandlerMapping metodu çağırır, HandlerAdapter onu bulur$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$İkisi de tam olarak aynı işi tekrar yapar$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$HandlerAdapter yalnızca @RestController'lar için, HandlerMapping yalnızca @Controller'lar için çalışır$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What happens when GET /greet is requested?$$,
           $$@Controller
public class GreetingController {
    @GetMapping("/greet")
    public String greet(Model model) {
        model.addAttribute("name", "World");
        return "Greeting";
    }
}
// A template file exists at templates/greeting.html (lowercase 'g'),
// on a case-sensitive filesystem.$$, $$java$$,
           $$ViewResolver looks for an exact string match ("Greeting" -> Greeting.html), not a case-insensitive one, so it fails to find templates/greeting.html.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The response body becomes the literal string "Greeting"$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$A NullPointerException is thrown because model was never initialized$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$It renders greeting.html successfully, since Spring lowercases view names$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$ViewResolver fails to find a matching template, because it looks for an exact string match (Greeting.html), not greeting.html$$, TRUE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$GET /urun isteği yapıldığında ne olur?$$,
           $$@Controller
public class UrunController {
    @GetMapping("/urun")
    public String urun(Model model) {
        model.addAttribute("ad", "Klavye");
        return "UrunDetay";
    }
}
// templates/urundetay.html (küçük harflerle) diye bir dosya var,
// case-sensitive bir dosya sisteminde.$$, $$java$$,
           $$ViewResolver, büyük/küçük harfe duyarsız değil tam string eşleşmesi arar ("UrunDetay" -> UrunDetay.html), bu yüzden templates/urundetay.html'i bulamaz.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Response body'si doğrudan "UrunDetay" metni olur$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$model hiç başlatılmadığı için NullPointerException fırlatılır$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$ViewResolver eşleşen bir şablon bulamaz, çünkü tam string eşleşmesi arar (UrunDetay.html değil urundetay.html)$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Spring view adlarını küçük harfe çevirdiği için urundetay.html başarıyla render edilir$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about Spring MVC vs. Spring WebFlux are correct? (Select all that apply)$$,
           NULL, NULL,
           $$Spring MVC is blocking (Servlet API based); Spring WebFlux is reactive/non-blocking, by default on Reactor+Netty. This project uses spring-boot-starter-web since its requests are classic short-lived cycles.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Spring MVC is built on the Servlet API and is blocking -- every request occupies a thread until it completes$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Spring WebFlux is built by default on Project Reactor and Netty, designed for many concurrent long-lived connections with few threads$$, TRUE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Spring MVC and Spring WebFlux always run together automatically, since they share the same starter$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$This project uses spring-boot-starter-web because its requests are classic short-lived request/response cycles (DB query + render)$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Spring MVC ile Spring WebFlux karşılaştırmasıyla ilgili aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Spring MVC bloklayıcıdır (Servlet API tabanlı); Spring WebFlux, varsayılan olarak Reactor+Netty üzerinde reaktif/bloklayıcı olmayandır. Bu proje, istekleri klasik kısa ömürlü döngüler olduğu için -web kullanır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Spring WebFlux, Servlet API'nin bloklayıcı olmayan bir uzantısıdır, farklı bir alt yapı kullanmaz$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Spring MVC, Servlet API üzerine kuruludur ve bloklayıcıdır -- her istek tamamlanana kadar bir thread'i işgal eder$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Spring MVC ile Spring WebFlux, aynı starter'ı paylaştığı için her zaman birlikte otomatik çalışır$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Bu proje, istekleri klasik kısa ömürlü request/response döngüleri (DB sorgusu + render) olduğu için spring-boot-starter-web kullanır$$, TRUE, 3 FROM new_question_tr7;
