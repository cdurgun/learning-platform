-- Promotion batch
-- Topic: validation-exception-handling (language: en x7, tr x7)
-- Generated: 2026-09-02 (this migration file's authoring date)
--
-- Like question-promotion/V659-V678 (Spring Core) and V631-V655
-- (Functional Interfaces & Streams), these 14 questions were NOT produced
-- by the n8n generation pipeline, NOT judged by the AI Judge, and NOT
-- ingested via /api/internal/questions/ingest -- per explicit user request,
-- they were hand-authored and independently self-reviewed directly inside a
-- Claude Code session, grounded strictly in content/en/validation-exception-handling.md and
-- content/tr/validation-exception-handling.md.
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
           $$Which annotation rejects null, an empty string (""), and a whitespace-only string ("   ")?$$,
           NULL, NULL,
           $$@NotBlank rejects null, empty string, and whitespace-only strings alike -- the strictest of the three.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'validation-exception-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$@NotNull$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$@NotEmpty$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$@NotBlank$$, TRUE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$@Size(min = 1)$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Hangi annotation null, boş bir string ("") ve yalnızca boşluk içeren bir string'i ("   ") reddeder?$$,
           NULL, NULL,
           $$@NotBlank, null, boş string ve yalnızca boşluk içeren string'leri aynı şekilde reddeder -- üçü arasında en katı olanıdır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'validation-exception-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$@NotEmpty$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$@NotNull$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$@Size(min = 1)$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$@NotBlank$$, TRUE, 3 FROM new_question_tr1;

-- Pair 2 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following values pass validation for a field annotated @Size(min = 3, max = 50)? (Select all that apply)$$,
           NULL, NULL,
           $$Both bounds are inclusive -- exactly 3 and exactly 50 characters both pass; 2 and 51 both fail.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'validation-exception-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A string with exactly 2 characters$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$A string with exactly 51 characters$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$A string with exactly 3 characters$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$A string with exactly 50 characters$$, TRUE, 3 FROM new_question_en2;

-- Pair 2 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$@Size(min = 3, max = 50) ile işaretlenmiş bir alan için aşağıdaki değerlerden hangileri doğrulamayı geçer? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Her iki sınır da inclusive'dir -- tam olarak 3 ve tam olarak 50 karakter ikisi de geçer; 2 ve 51 ikisi de başarısız olur.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'validation-exception-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Tam olarak 2 karakter uzunluğunda bir string$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Tam olarak 51 karakter uzunluğunda bir string$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Tam olarak 50 karakter uzunluğunda bir string$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Tam olarak 3 karakter uzunluğunda bir string$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What triggers Bean Validation rules written on a request record's fields to actually run?$$,
           NULL, NULL,
           $$They only run when the parameter is annotated with @Valid (or @Validated).$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'validation-exception-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$They run automatically whenever the record is instantiated$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$They run only if the class also implements Serializable$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$They run only when the parameter is annotated with @Valid (or @Validated)$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$They run automatically for every @RequestBody parameter, with no extra annotation needed$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir request record'unun alanlarına yazılmış Bean Validation kurallarının gerçekten çalışmasını ne tetikler?$$,
           NULL, NULL,
           $$Yalnızca parametre @Valid (veya @Validated) ile işaretlendiğinde çalışırlar.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'validation-exception-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca parametre @Valid (veya @Validated) ile işaretlendiğinde çalışırlar$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Record örneklendiğinde otomatik olarak çalışırlar$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Sınıf ayrıca Serializable'ı da implemente ederse çalışırlar$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Ekstra bir annotation'a gerek kalmadan her @RequestBody parametresi için otomatik çalışırlar$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$A request arrives with address.city blank (""). What happens?$$,
           $$record Address(@NotBlank String city) {}
record ShippingRequest(String recipient, Address address) {}
// Note: no @Valid on the address field

@PostMapping("/ship")
public String ship(@Valid @RequestBody ShippingRequest request) {
    return "OK";
}$$, $$java$$,
           $$Address's own @NotBlank rule never runs because address lacks its own @Valid -- cascading wasn't enabled, so the nested object's constraints are silently skipped.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'validation-exception-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A NullPointerException is thrown while validating$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$recipient is also rejected as a side effect$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$The request is rejected with a validation error mentioning address.city$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$The request is accepted -- Address's own @NotBlank rule never runs because address lacks its own @Valid (cascading wasn't enabled)$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$adres.sehir boş ("") olan bir istek geliyor. Ne olur?$$,
           $$record Adres(@NotBlank String sehir) {}
record KargoRequest(String alici, Adres adres) {}
// Not: adres alanında @Valid yok

@PostMapping("/kargo")
public String kargoGonder(@Valid @RequestBody KargoRequest request) {
    return "OK";
}$$, $$java$$,
           $$adres kendi @Valid'ine sahip olmadığı için (cascading etkinleştirilmediği için) Adres'in kendi @NotBlank kuralı hiç çalışmaz, iç içe nesnenin kısıtları sessizce atlanır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'validation-exception-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Doğrulama sırasında bir NullPointerException fırlatılır$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$İstek kabul edilir -- adres kendi @Valid'ine sahip olmadığı için (cascading etkinleştirilmediği için) Adres'in kendi @NotBlank kuralı hiç çalışmaz$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$alici da yan etki olarak reddedilir$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$İstek, adres.sehir'i belirten bir doğrulama hatasıyla reddedilir$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Is @ExceptionHandler, placed directly on a method inside a single @Controller class, scoped to that controller only, or applied application-wide?$$,
           NULL, NULL,
           $$Scoped to that same controller only -- it catches exceptions thrown by handler methods in that same class.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'validation-exception-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Scoped to that same controller only -- it catches exceptions thrown by handler methods in that same class$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Applied application-wide by default$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$It requires @RestControllerAdvice to function at all$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$It only works for @RestControllers, never @Controllers$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Tek bir @Controller sınıfının içinde doğrudan bir metoda konan @ExceptionHandler, yalnızca o controller'a mı özeldir, yoksa uygulama genelinde mi uygulanır?$$,
           NULL, NULL,
           $$Yalnızca aynı controller'a özeldir -- o sınıftaki handler metotlarının fırlattığı istisnaları yakalar.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'validation-exception-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca @RestController'lar için çalışır, @Controller'lar için asla çalışmaz$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Varsayılan olarak uygulama genelinde uygulanır$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Çalışması için @RestControllerAdvice'a ihtiyaç duyar$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Yalnızca aynı controller'a özeldir -- o sınıftaki handler metotlarının fırlattığı istisnaları yakalar$$, TRUE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A @RestControllerAdvice class has @ExceptionHandlers for ResourceNotFoundException, IllegalArgumentException, and Exception (in that file order, Exception written first). Which statements are correct? (Select all that apply)$$,
           NULL, NULL,
           $$Spring picks the most specific matching handler regardless of file order; Exception.class is a last-resort catch-all that only fires when nothing more specific matches.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'validation-exception-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The Exception.class handler only fires when no more specific handler matches -- it's a last-resort catch-all$$, TRUE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Declaring three separate handlers in one class is not allowed -- only one @ExceptionHandler per class is permitted$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Spring picks the most specific matching handler for the thrown exception's type, regardless of the order they appear in the file$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Since Exception.class is written first, it always wins over the more specific handlers$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir @RestControllerAdvice sınıfında ResourceNotFoundException, IllegalArgumentException ve Exception için @ExceptionHandler'lar var (dosyada bu sırayla, Exception ilk yazılmış). Aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Spring, dosyadaki sıradan bağımsız olarak en spesifik eşleşen handler'ı seçer; Exception.class, yalnızca daha spesifik hiçbir handler eşleşmediğinde tetiklenen son çare bir yakalayıcıdır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'validation-exception-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Spring, fırlatılan istisnanın türü için dosyadaki sıradan bağımsız olarak en spesifik eşleşen handler'ı seçer$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Exception.class handler'ı yalnızca daha spesifik hiçbir handler eşleşmediğinde tetiklenir -- son çare bir yakalayıcıdır$$, TRUE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir sınıfta üç ayrı handler tanımlamak izin verilmez -- sınıf başına yalnızca bir @ExceptionHandler'a izin verilir$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Exception.class ilk yazıldığı için her zaman daha spesifik handler'lara karşı kazanır$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does ProblemDetail.forStatusAndDetail(status, detail) provide beyond just returning a plain String error message?$$,
           NULL, NULL,
           $$A standardized RFC 7807 body carrying the status code, an automatically-derived title, and the given detail -- plus the ability to attach custom fields via setProperty(...).$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'validation-exception-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It automatically retries the failed request$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$A standardized RFC 7807 body carrying the status code, an automatically-derived title, and the given detail -- plus the ability to attach custom fields via setProperty(...)$$, TRUE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$It disables further exception handling for the rest of the request$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$It converts the response to XML instead of JSON$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$ProblemDetail.forStatusAndDetail(status, detail), sade bir String hata mesajı döndürmenin ötesinde ne sağlar?$$,
           NULL, NULL,
           $$Durum kodunu, otomatik türetilmiş bir title'ı ve verilen detail'i taşıyan standartlaştırılmış bir RFC 7807 gövdesi -- ayrıca setProperty(...) ile özel alanlar ekleme imkânı.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'validation-exception-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Durum kodunu, otomatik türetilmiş bir title'ı ve verilen detail'i taşıyan standartlaştırılmış bir RFC 7807 gövdesi -- ayrıca setProperty(...) ile özel alanlar ekleme imkânı$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Başarısız isteği otomatik olarak yeniden dener$$, FALSE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Response'u JSON yerine XML'e dönüştürür$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$İsteğin geri kalanı için daha fazla istisna işlemeyi devre dışı bırakır$$, FALSE, 3 FROM new_question_tr7;
