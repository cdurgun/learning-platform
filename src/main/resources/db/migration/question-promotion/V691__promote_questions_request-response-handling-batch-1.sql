-- Promotion batch
-- Topic: request-response-handling (language: en x7, tr x7)
-- Generated: 2026-09-02 (this migration file's authoring date)
--
-- Like question-promotion/V659-V678 (Spring Core) and V631-V655
-- (Functional Interfaces & Streams), these 14 questions were NOT produced
-- by the n8n generation pipeline, NOT judged by the AI Judge, and NOT
-- ingested via /api/internal/questions/ingest -- per explicit user request,
-- they were hand-authored and independently self-reviewed directly inside a
-- Claude Code session, grounded strictly in content/en/request-response-handling.md and
-- content/tr/request-response-handling.md.
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
           $$What does @RequestBody do?$$,
           NULL, NULL,
           $$@RequestBody reads the entire HTTP request body and converts it into a Java object.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'request-response-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It reads a single named value from the query string$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$It reads the entire HTTP request body and converts it into a Java object$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It reads a single HTTP header$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$It only works with XML payloads, never JSON$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$@RequestBody ne yapar?$$,
           NULL, NULL,
           $$@RequestBody, HTTP isteğinin tüm gövdesini okuyup bir Java nesnesine dönüştürür.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'request-response-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca XML payload'larla çalışır, JSON ile asla çalışmaz$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Query string'den tek bir isimlendirilmiş değeri okur$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Yalnızca tek bir HTTP header'ı okur$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$HTTP isteğinin tüm gövdesini okuyup bir Java nesnesine dönüştürür$$, TRUE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What actually performs the conversion between a JSON request body and a Java object behind @RequestBody?$$,
           NULL, NULL,
           $$An HttpMessageConverter -- for JSON, this is backed by Jackson's ObjectMapper.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'request-response-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The ConversionService, the same component used for @PathVariable/@RequestParam$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$The ViewResolver$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$@RequestBody has its own built-in parser, independent of any other component$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$An HttpMessageConverter -- for JSON, this is backed by Jackson's ObjectMapper$$, TRUE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$@RequestBody'nin arkasında, bir JSON request body'sini bir Java nesnesine dönüştürmeyi gerçekte kim yapar?$$,
           NULL, NULL,
           $$Bir HttpMessageConverter -- JSON için bu, Jackson'ın ObjectMapper'ına dayanır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'request-response-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$@PathVariable/@RequestParam için kullanılan aynı bileşen olan ConversionService$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$ViewResolver$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Bir HttpMessageConverter -- JSON için bu, Jackson'ın ObjectMapper'ına dayanır$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$@RequestBody'nin, başka hiçbir bileşene bağlı olmayan kendi yerleşik parser'ı vardır$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Two separate requests are sent to a @RequestBody CreateUserRequest endpoint: (1) {"name": "Alice"} (email missing), (2) {"name": "Bob", "email": "b@x.com", "age": 30} (extra unknown field age). What happens in each case?$$,
           $$record CreateUserRequest(String name, String email) {}
// Jackson uses default settings (no @JsonIgnoreProperties etc.)$$, $$java$$,
           $$A missing field is silently assigned null, no error at all. An unknown field throws an UnrecognizedPropertyException, since Jackson's default is to reject fields it doesn't recognize.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'request-response-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Both requests are accepted without error$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Request 1 is accepted with email set to null; request 2 is rejected with an UnrecognizedPropertyException$$, TRUE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Both requests are rejected$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Request 1 is rejected for a missing field; request 2 is accepted, ignoring age$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$@RequestBody KullaniciOlusturRequest uç noktasına iki ayrı istek gönderiliyor: (1) {"ad": "Ayşe"} (eposta eksik), (2) {"ad": "Mehmet", "eposta": "m@x.com", "yas": 30} (bilinmeyen ekstra alan yas). Her durumda ne olur?$$,
           $$record KullaniciOlusturRequest(String ad, String eposta) {}
// Jackson varsayılan ayarlarla kullanılıyor (@JsonIgnoreProperties yok)$$, $$java$$,
           $$Eksik bir alan sessizce null olarak atanır, hiç hata olmaz. Bilinmeyen bir alan, Jackson'ın varsayılanı tanımadığı alanları reddetmek olduğu için bir UnrecognizedPropertyException fırlatır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'request-response-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İstek 1, eposta null olarak ayarlanarak kabul edilir; istek 2, bir UnrecognizedPropertyException ile reddedilir$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Her iki istek de hatasız kabul edilir$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Her iki istek de reddedilir$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$İstek 1, eksik alan yüzünden reddedilir; istek 2 yas'ı yok sayarak kabul edilir$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are capabilities ResponseEntity gives a controller method, beyond what a plain return value offers? (Select all that apply)$$,
           NULL, NULL,
           $$ResponseEntity gives full control over the status code and lets you add custom headers like Location.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'request-response-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Automatically validating the request body before it arrives$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Choosing between JSON and XML output without any other configuration$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Setting an arbitrary HTTP status code, like 404 or 201$$, TRUE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Adding custom response headers, like Location$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$ResponseEntity, sade bir dönüş değerinin sunduğunun ötesinde bir controller metoduna hangi yetenekleri kazandırır? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$ResponseEntity, durum kodu üzerinde tam kontrol verir ve Location gibi özel header'lar eklemeye izin verir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'request-response-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Request body'yi ulaşmadan önce otomatik olarak doğrulamak$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Başka hiçbir yapılandırma olmadan JSON ile XML çıktısı arasında seçim yapmak$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Location gibi özel response header'ları eklemek$$, TRUE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$404 veya 201 gibi keyfi bir HTTP durum kodu ayarlamak$$, TRUE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A client tries to close an account that still has a positive balance -- the request is well-formed, but conflicts with the server's current state. Which status code fits best?$$,
           NULL, NULL,
           $$409 Conflict -- the request is well-formed but conflicts with the current server state.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'request-response-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$400 Bad Request$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$403 Forbidden$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$409 Conflict$$, TRUE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$422 Unprocessable Entity$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir istemci, hâlâ pozitif bakiyesi olan bir hesabı kapatmaya çalışıyor -- istek biçimsel olarak doğru, ama sunucunun mevcut durumuyla çelişiyor. Hangi durum kodu en uygunudur?$$,
           NULL, NULL,
           $$409 Conflict -- istek biçimsel olarak doğru ama mevcut sunucu durumuyla çelişiyor.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'request-response-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$409 Conflict$$, TRUE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$400 Bad Request$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$403 Forbidden$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$422 Unprocessable Entity$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, ADVANCED)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Inside a controller method, an ArithmeticException is thrown that is caught by neither a ResponseStatusException nor any @ExceptionHandler. What does the client receive?$$,
           NULL, NULL,
           $$A generic 500 Internal Server Error, with exception details staying only in server logs, never leaking to the client.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'request-response-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$400 Bad Request, since Spring treats any uncaught exception as a client error$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$The request simply hangs with no response$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$The raw stack trace as plain text$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$A generic 500 Internal Server Error, with exception details staying only in server logs$$, TRUE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, ADVANCED)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bir controller metodunda, ne bir ResponseStatusException ne de herhangi bir @ExceptionHandler tarafından yakalanan bir ArithmeticException fırlatılıyor. İstemci ne alır?$$,
           NULL, NULL,
           $$İstisna ayrıntıları yalnızca sunucu loglarında kalarak genel bir 500 Internal Server Error döner, istemciye hiç sızmaz.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'request-response-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Spring, yakalanmamış her istisnayı bir istemci hatası olarak ele aldığı için 400 Bad Request$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$İstek yanıt almadan askıda kalır$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$İstisna ayrıntıları yalnızca sunucu loglarında kalarak genel bir 500 Internal Server Error$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Ham stack trace'i düz metin olarak$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$A client sends GET /products/1 with header Accept: text/csv. What is the result?$$,
           $$@GetMapping(path = "/products/1", produces = "application/json")
public String asJson() { return "{...}"; }

@GetMapping(path = "/products/1", produces = "application/xml")
public String asXml() { return "<product>...</product>"; }$$, $$java$$,
           $$406 Not Acceptable, since the path exists but no produces value matches the requested Accept header.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'request-response-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$asJson() runs, since JSON is the default fallback$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$404 Not Found, since the path is treated as missing$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$406 Not Acceptable, since the path exists but no produces value matches the requested Accept$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$415 Unsupported Media Type$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bir istemci GET /urunler/1 isteğini Accept: text/csv header'ıyla gönderiyor. Sonuç nedir?$$,
           $$@GetMapping(path = "/urunler/1", produces = "application/json")
public String jsonOlarak() { return "{...}"; }

@GetMapping(path = "/urunler/1", produces = "application/xml")
public String xmlOlarak() { return "<urun>...</urun>"; }$$, $$java$$,
           $$Path mevcut ama istenen Accept ile eşleşen bir produces değeri olmadığı için 406 Not Acceptable döner.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'request-response-handling'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Path mevcut ama istenen Accept ile eşleşen bir produces değeri olmadığı için 406 Not Acceptable$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$JSON varsayılan geri dönüş olduğu için jsonOlarak() çalışır$$, FALSE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Path eksik kabul edildiği için 404 Not Found$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$415 Unsupported Media Type$$, FALSE, 3 FROM new_question_tr7;
