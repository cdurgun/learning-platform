-- Promotion batch
-- Topic: exception-handling (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V679-V714 (Spring MVC) and V659-V678 (Spring
-- Core), these 14 questions were NOT produced by the n8n generation
-- pipeline, NOT judged by the AI Judge, and NOT ingested via
-- /api/internal/questions/ingest -- per explicit user request, they were
-- hand-authored and independently self-reviewed directly inside a Claude Code
-- session, grounded strictly in content/en/exception-handling.md and
-- content/tr/exception-handling.md.
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
           $$What exception does Spring throw when @Valid fails on a @RequestBody, and what does it carry?$$,
           NULL, NULL,
           $$MethodArgumentNotValidException, carrying a BindingResult with per-field errors.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'exception-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$IllegalArgumentException, carrying nothing useful$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$MethodArgumentNotValidException, carrying a BindingResult with per-field errors$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$ConstraintViolationException, carrying a raw Set<ConstraintViolation> only$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$ValidationException, carrying the original request body$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$@Valid, bir @RequestBody üzerinde başarısız olduğunda Spring hangi istisnayı fırlatır ve bu istisna neyi taşır?$$,
           NULL, NULL,
           $$Alan başına hatalar içeren bir BindingResult taşıyan MethodArgumentNotValidException.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'exception-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Alan başına hatalar içeren bir BindingResult taşıyan MethodArgumentNotValidException$$, TRUE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Yararlı hiçbir şey taşımayan bir IllegalArgumentException$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Yalnızca ham bir Set<ConstraintViolation> taşıyan bir ConstraintViolationException$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Orijinal request body'sini taşıyan bir ValidationException$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$The request body fails both @NotBlank on name and the class-level @ValidDateRange custom constraint. What does the client's errors array contain?$$,
           $$@ExceptionHandler(MethodArgumentNotValidException.class)
public ProblemDetail handle(MethodArgumentNotValidException ex) {
    List<String> errors = ex.getBindingResult().getFieldErrors().stream()
        .map(fe -> fe.getField() + ": " + fe.getDefaultMessage())
        .toList();
    ProblemDetail pd = ProblemDetail.forStatusAndDetail(HttpStatus.BAD_REQUEST, "Validation failed");
    pd.setProperty("errors", errors);
    return pd;
}$$, $$java$$,
           $$Only the name failure -- the @ValidDateRange failure surfaces as an ObjectError in getGlobalErrors(), which this handler never reads.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'exception-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Neither failure, since combining a field and a class-level failure throws a different exception$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Only the @ValidDateRange failure, since class-level constraints are checked first$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Both failures, since getFieldErrors() covers every validation failure$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Only the name failure -- the @ValidDateRange failure surfaces as an ObjectError in getGlobalErrors(), which this handler never reads$$, TRUE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Request body'si hem ad alanındaki @NotBlank'i hem de sınıf seviyesindeki @GecerliTarihAraligi özel kısıtlamasını başarısız kılıyor. İstemcinin hatalar dizisi ne içerir?$$,
           $$@ExceptionHandler(MethodArgumentNotValidException.class)
public ProblemDetail handle(MethodArgumentNotValidException ex) {
    List<String> hatalar = ex.getBindingResult().getFieldErrors().stream()
        .map(fe -> fe.getField() + ": " + fe.getDefaultMessage())
        .toList();
    ProblemDetail pd = ProblemDetail.forStatusAndDetail(HttpStatus.BAD_REQUEST, "Dogrulama basarisiz");
    pd.setProperty("hatalar", hatalar);
    return pd;
}$$, $$java$$,
           $$Yalnızca ad hatası -- @GecerliTarihAraligi hatası getGlobalErrors()'ta bir ObjectError olarak ortaya çıkar, bu handler onu hiç okumaz.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'exception-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir alan hatasıyla sınıf seviyesi bir hatayı birleştirmek farklı bir istisna fırlattığı için hiçbiri bulunmaz$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Sınıf seviyesi kısıtlamalar önce kontrol edildiği için yalnızca @GecerliTarihAraligi hatası bulunur$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Yalnızca ad hatası -- @GecerliTarihAraligi hatası getGlobalErrors()'ta bir ObjectError olarak ortaya çıkar, bu handler onu hiç okumaz$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$getFieldErrors() her doğrulama hatasını kapsadığı için her iki hata da bulunur$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are legitimate reasons to attach custom properties to a ProblemDetail beyond a single "errors" list? (Select all that apply)$$,
           NULL, NULL,
           $$A machine-readable errorCode and details like resource id/timestamp are legitimate custom properties; ProblemDetail doesn't require custom properties, and adding them doesn't break RFC 7807.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'exception-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Attaching a machine-readable errorCode a client can branch on reliably, unlike a human-readable message$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Attaching the specific resource id involved, or a timestamp$$, TRUE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$It's required -- ProblemDetail cannot be returned without at least one custom property$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$It breaks RFC 7807 compliance, since the standard only allows fixed fields$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Tek bir "errors" listesinin ötesinde bir ProblemDetail'e özel property'ler eklemenin meşru nedenleri arasında aşağıdakilerden hangileri yer alır? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Makine-okunabilir bir errorCode ve kaynak id/timestamp gibi ayrıntılar meşru özel property'lerdir; ProblemDetail özel property gerektirmez ve bunları eklemek RFC 7807'yi bozmaz.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'exception-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$RFC 7807 uyumluluğunu bozar, çünkü standart yalnızca sabit alanlara izin verir$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$İstemcinin, okunabilir bir mesajın aksine güvenilir şekilde dallanabileceği makine-okunabilir bir errorCode eklemek$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Zorunludur -- ProblemDetail, en az bir özel property olmadan döndürülemez$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$İlgili spesifik kaynak id'sini veya bir timestamp eklemek$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A client tries to register with an email address that's already taken by another account -- the request is well-formed, but conflicts with existing data. Which status code fits?$$,
           NULL, NULL,
           $$409 Conflict -- the request is well-formed but conflicts with existing state.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'exception-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$422 Unprocessable Entity$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$404 Not Found$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$400 Bad Request$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$409 Conflict$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir istemci, başka bir hesap tarafından zaten alınmış bir e-posta adresiyle kayıt olmaya çalışıyor -- istek biçimsel olarak doğru, ama mevcut veriyle çelişiyor. Hangi durum kodu uygundur?$$,
           NULL, NULL,
           $$409 Conflict -- istek biçimsel olarak doğru ama mevcut durumla çelişiyor.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'exception-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$422 Unprocessable Entity$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$404 Not Found$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$409 Conflict$$, TRUE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$400 Bad Request$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, ADVANCED)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What is the purpose of extending ResponseEntityExceptionHandler and overriding one method like handleMethodArgumentNotValid(...)?$$,
           NULL, NULL,
           $$It customizes exactly that one case while every other framework exception it already handles keeps its sensible default behavior automatically.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'exception-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It replaces @RestControllerAdvice entirely for an application's own custom exceptions$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$It customizes exactly that one case while every other framework exception it already handles keeps its sensible default behavior automatically$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$It disables Spring's default exception handling for the whole application$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$It only works for @Controllers, never @RestControllers$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, ADVANCED)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$ResponseEntityExceptionHandler'ı extend edip handleMethodArgumentNotValid(...) gibi tek bir metodu override etmenin amacı nedir?$$,
           NULL, NULL,
           $$Tam olarak o durumu özelleştirir, zaten ele aldığı diğer her framework istisnası ise otomatik olarak makul varsayılan davranışını korur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'exception-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Tam olarak o durumu özelleştirir, zaten ele aldığı diğer her framework istisnası ise otomatik olarak makul varsayılan davranışını korur$$, TRUE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Uygulamanın kendi özel istisnaları için @RestControllerAdvice'ın yerini tamamen alır$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Tüm uygulama için Spring'in varsayılan istisna işlemesini devre dışı bırakır$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Yalnızca @Controller'lar için çalışır, @RestController'lar için asla çalışmaz$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, BEGINNER)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following describe a "safe" error response? (Select all that apply)$$,
           NULL, NULL,
           $$Logging the full exception internally and returning a generic message to the client are safe; leaking stack traces or internal hostnames/paths is not.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'exception-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Returning the exception's stack trace in the response body so the client can debug the issue themselves$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Including an internal database hostname or file path in the response for transparency$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Logging the full exception (message + stack trace) where only the team can see it, such as server logs$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Returning a generic, constant message to the client instead of e.getMessage() or e.toString()$$, TRUE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, BEGINNER)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri "güvenli" bir hata yanıtını tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Tam istisnayı dahili olarak loglamak ve istemciye genel bir mesaj döndürmek güvenlidir; stack trace veya dahili host adı/yol sızdırmak değildir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'exception-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İstemcinin sorunu kendi başına debug edebilmesi için stack trace'i response body'sinde döndürmek$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Şeffaflık için response'a dahili bir veritabanı host adı ya da dosya yolu eklemek$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$İstemciye e.getMessage() veya e.toString() yerine genel, sabit bir mesaj döndürmek$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Tam istisnayı (mesaj + stack trace) yalnızca ekibin görebileceği bir yerde, örneğin sunucu loglarında loglamak$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why is returning 500 Internal Server Error for every kind of failure considered a design mistake?$$,
           NULL, NULL,
           $$It can't tell "you sent bad data" apart from "our database is down," giving the client no way to know if retrying would help.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'exception-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$500 is technically not a valid HTTP status code in modern APIs$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$It can't tell "you sent bad data" apart from "our database is down," giving the client no way to know if retrying would help$$, TRUE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$500 responses are always slower to generate than 4xx responses$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Spring MVC doesn't allow 500 to be returned manually, only automatically$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Her tür hata için 500 Internal Server Error döndürmek neden bir tasarım hatası kabul edilir?$$,
           NULL, NULL,
           $$"Kötü veri gönderdin" ile "veritabanımız çöktü"yü birbirinden ayıramaz, istemciye tekrar denemenin işe yarayıp yaramayacağını bilme imkânı vermez.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'exception-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$"Kötü veri gönderdin" ile "veritabanımız çöktü"yü birbirinden ayıramaz, istemciye tekrar denemenin işe yarayıp yaramayacağını bilme imkânı vermez$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$500, modern API'lerde teknik olarak geçerli bir HTTP durum kodu değildir$$, FALSE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$500 yanıtları üretilmesi her zaman 4xx yanıtlarından daha yavaştır$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Spring MVC, 500'ün yalnızca otomatik döndürülmesine izin verir, elle döndürülmesine izin vermez$$, FALSE, 3 FROM new_question_tr7;
