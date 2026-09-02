-- Promotion batch
-- Topic: path-variables-request-parameters (language: en x7, tr x7)
-- Generated: 2026-09-02 (this migration file's authoring date)
--
-- Like question-promotion/V659-V678 (Spring Core) and V631-V655
-- (Functional Interfaces & Streams), these 14 questions were NOT produced
-- by the n8n generation pipeline, NOT judged by the AI Judge, and NOT
-- ingested via /api/internal/questions/ingest -- per explicit user request,
-- they were hand-authored and independently self-reviewed directly inside a
-- Claude Code session, grounded strictly in content/en/path-variables-request-parameters.md and
-- content/tr/path-variables-request-parameters.md.
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
           $$In @GetMapping("/products/{id}") with getProduct(@PathVariable Long id), how does id get its value?$$,
           NULL, NULL,
           $$It is bound by name-matching against the {id} placeholder.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'path-variables-request-parameters'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It is bound by position, always the first path segment$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$It is bound by name-matching against the {id} placeholder$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It must always be explicitly written as @PathVariable("id")$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$It defaults to null unless a query parameter named id is also sent$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$@GetMapping("/urunler/{id}") ve getUrun(@PathVariable Long id) içinde, id değerini nasıl alır?$$,
           NULL, NULL,
           $${id} placeholder'ıyla isim eşleşmesi yapılarak bağlanır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'path-variables-request-parameters'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$id adında bir query parametresi de gönderilmedikçe varsayılan olarak null olur$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Pozisyona göre bağlanır, her zaman ilk path segmenti olur$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Her zaman açıkça @PathVariable("id") yazılması gerekir$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $${id} placeholder'ıyla isim eşleşmesi yapılarak bağlanır$$, TRUE, 3 FROM new_question_tr1;

-- Pair 2 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A GET /articles/spring-mvc request is sent. What does the method return?$$,
           $$@GetMapping("/articles/{articleSlug}")
public String getArticle(@PathVariable("articleSlug") String slug) {
    return "Article: " + slug;
}$$, $$java$$,
           $$@PathVariable("articleSlug") explicitly binds slug to the {articleSlug} placeholder, so slug receives "spring-mvc".$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'path-variables-request-parameters'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A 400 Bad Request, since slug doesn't match articleSlug$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$A NullPointerException, since the parameter name differs from the placeholder$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Article: articleSlug$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Article: spring-mvc$$, TRUE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$GET /makaleler/spring-mvc isteği gönderiliyor. Metot ne döndürür?$$,
           $$@GetMapping("/makaleler/{makaleSlug}")
public String makaleGetir(@PathVariable("makaleSlug") String slug) {
    return "Makale: " + slug;
}$$, $$java$$,
           $$@PathVariable("makaleSlug"), slug'ı {makaleSlug} placeholder'ına açıkça bağlar, bu yüzden slug "spring-mvc" değerini alır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'path-variables-request-parameters'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$slug, makaleSlug ile eşleşmediği için 400 Bad Request$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Parametre adı placeholder'dan farklı olduğu için NullPointerException$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Makale: spring-mvc$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Makale: makaleSlug$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$According to the distinction taught in this lesson, which of the following should be a path variable rather than a query parameter?$$,
           NULL, NULL,
           $$An id identifying which specific article to retrieve is required -- the request is meaningless without it, so it belongs in the path.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'path-variables-request-parameters'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A category filter narrowing a product listing$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$A page number for pagination$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$An id identifying which specific article to retrieve -- the request is meaningless without it$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$A sortBy field name for ordering results$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste öğretilen ayrıma göre, aşağıdakilerden hangisi bir query parametresi yerine path variable olmalıdır?$$,
           NULL, NULL,
           $$Hangi belirli makalenin getirileceğini belirten bir id zorunludur -- bu istek onsuz anlamsızdır, bu yüzden path'te olmalıdır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'path-variables-request-parameters'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hangi belirli makalenin getirileceğini belirten bir id -- bu istek onsuz anlamsızdır$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Bir ürün listesini daraltan kategori filtresi$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Sayfalama için bir sayfa numarası$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Sonuçları sıralamak için bir sirala alan adı$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$By default, is @RequestParam required or optional if the client doesn't send it?$$,
           NULL, NULL,
           $$@RequestParam is required by default -- the client gets a 400 Bad Request if it's missing.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'path-variables-request-parameters'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It depends on the HTTP method used$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$It is always optional unless required = true is explicitly written$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Required by default -- the client gets a 400 Bad Request if it's missing$$, TRUE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Optional by default, just like @PathVariable$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$İstemci göndermezse, @RequestParam varsayılan olarak zorunlu mudur, opsiyonel midir?$$,
           NULL, NULL,
           $$@RequestParam varsayılan olarak zorunludur -- eksikse istemci 400 Bad Request alır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'path-variables-request-parameters'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Kullanılan HTTP metoduna bağlıdır$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Açıkça required = true yazılmadıkça her zaman opsiyoneldir$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Varsayılan olarak zorunludur -- eksikse istemci 400 Bad Request alır$$, TRUE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$@PathVariable gibi, varsayılan olarak opsiyoneldir$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A method has the parameter @RequestParam(required = false) List<String> tag. Which of the following requests correctly populates tag with ["java", "spring"]?$$,
           NULL, NULL,
           $$Spring's List binding expects the same key to be repeated (?tag=java&tag=spring), not a single comma-separated value, and not omitted entirely.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'path-variables-request-parameters'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$?tag=java&tag=spring$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$?tag=java,spring$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Sending no tag parameter at all -- tag becomes ["java", "spring"] automatically$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$A malformed request that Spring rejects with 400 Bad Request$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir metotta @RequestParam(required = false) List<String> etiket parametresi var. Aşağıdaki isteklerden hangisi etiket'i ["java", "spring"] ile doğru şekilde doldurur?$$,
           NULL, NULL,
           $$Spring'in List bağlaması, aynı key'in tekrarlanmasını bekler (?etiket=java&etiket=spring), tek bir virgülle ayrılmış değeri değil, ve hiç gönderilmemesini de değil.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'path-variables-request-parameters'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Spring'in 400 Bad Request ile reddettiği hatalı bir istek$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$?etiket=java&etiket=spring$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$?etiket=java,spring$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Hiç etiket parametresi göndermemek -- etiket otomatik olarak ["java", "spring"] olur$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What is the main trade-off of binding @RequestParam to a Map<String, String> instead of declaring each parameter individually?$$,
           NULL, NULL,
           $$It captures every parameter regardless of name, but loses compile-time type safety -- everything arrives as String.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'path-variables-request-parameters'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It captures every parameter regardless of name, but loses compile-time type safety -- everything arrives as String$$, TRUE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$It automatically converts every value to its correct Java type$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$It only works with POST requests$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$It requires a custom ConversionService to be registered$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$@RequestParam'ı her parametreyi ayrı ayrı tanımlamak yerine bir Map<String, String>'e bağlamanın temel dezavantajı nedir?$$,
           NULL, NULL,
           $$İsimden bağımsız her parametreyi yakalar ama derleme zamanı tip güvenliğini kaybettirir -- her şey String olarak gelir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'path-variables-request-parameters'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Özel bir ConversionService kaydedilmesini gerektirir$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Her değeri otomatik olarak doğru Java tipine dönüştürür$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$İsimden bağımsız her parametreyi yakalar ama derleme zamanı tip güvenliğini kaybettirir -- her şey String olarak gelir$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Yalnızca POST istekleriyle çalışır$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$A client sends GET /products/abc. What happens?$$,
           $$@GetMapping("/products/{id}")
public String getProduct(@PathVariable Long id) {
    return "Product: " + id;
}$$, $$java$$,
           $$Type conversion fails at the DispatcherServlet layer, before the controller method is ever called, resulting in 400 Bad Request.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'path-variables-request-parameters'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$id is set to null and the method runs normally$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$The method runs and throws a NumberFormatException inside the method body$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$The request never reaches getProduct at all -- type conversion fails at the DispatcherServlet layer, resulting in 400 Bad Request$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$id is set to 0 as a default fallback value$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bir istemci GET /urunler/abc gönderiyor. Ne olur?$$,
           $$@GetMapping("/urunler/{id}")
public String urunGetir(@PathVariable Long id) {
    return "Urun: " + id;
}$$, $$java$$,
           $$Tip dönüşümü, controller metodu hiç çağrılmadan önce DispatcherServlet katmanında başarısız olur, sonuç 400 Bad Request olur.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'path-variables-request-parameters'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İstek urunGetir'e hiç ulaşmaz -- tip dönüşümü DispatcherServlet katmanında başarısız olur ve sonuç 400 Bad Request olur$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$id, null olarak ayarlanır ve metot normal şekilde çalışır$$, FALSE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Metot çalışır ve gövdesinde bir NumberFormatException fırlatır$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$id, varsayılan geri dönüş değeri olarak 0'a ayarlanır$$, FALSE, 3 FROM new_question_tr7;
