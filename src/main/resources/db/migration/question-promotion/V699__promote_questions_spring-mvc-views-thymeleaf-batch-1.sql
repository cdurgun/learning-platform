-- Promotion batch
-- Topic: spring-mvc-views-thymeleaf (language: en x7, tr x7)
-- Generated: 2026-09-02 (this migration file's authoring date)
--
-- Like question-promotion/V659-V678 (Spring Core) and V631-V655
-- (Functional Interfaces & Streams), these 14 questions were NOT produced
-- by the n8n generation pipeline, NOT judged by the AI Judge, and NOT
-- ingested via /api/internal/questions/ingest -- per explicit user request,
-- they were hand-authored and independently self-reviewed directly inside a
-- Claude Code session, grounded strictly in content/en/spring-mvc-views-thymeleaf.md and
-- content/tr/spring-mvc-views-thymeleaf.md.
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
           $$What makes Thymeleaf's "natural templating" philosophy distinct from engines like JSP or Mustache?$$,
           NULL, NULL,
           $$A Thymeleaf template is valid HTML that can be opened directly in a browser, since its directives are ordinary HTML attributes.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-views-thymeleaf'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It only works with Spring Boot, not plain Spring MVC$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$A Thymeleaf template is valid HTML that can be opened directly in a browser, since its directives are ordinary HTML attributes$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It compiles templates into Java bytecode ahead of time$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$It doesn't support conditionals or loops$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Thymeleaf'in "natural templating" felsefesini JSP veya Mustache gibi motorlardan ayıran nedir?$$,
           NULL, NULL,
           $$Bir Thymeleaf şablonu, direktifleri sıradan HTML attribute'ları olduğu için tarayıcıda doğrudan açılabilen geçerli bir HTML'dir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-views-thymeleaf'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir Thymeleaf şablonu, direktifleri sıradan HTML attribute'ları olduğu için tarayıcıda doğrudan açılabilen geçerli bir HTML'dir$$, TRUE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Yalnızca Spring Boot ile çalışır, sade Spring MVC ile çalışmaz$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Şablonları önceden Java bytecode'una derler$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Koşullu ifadeleri veya döngüleri desteklemez$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given that Topic is a Java record (its accessor is a real method title(), not a getTitle() bean-style getter), what is the risk with this exact Thymeleaf expression?$$,
           $$record Topic(String slug, String title) {}
// model.addAttribute("topic", new Topic("records", "Records"));

<!-- template -->
<h1 th:text="${topic.title}">placeholder</h1>$$, $$html$$,
           $$${topic.title} (without parentheses) doesn't correctly resolve a record's real accessor method the way ${topic.title()} does -- it can silently fail or return null/an error.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-views-thymeleaf'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It throws a compile-time error, since Thymeleaf expressions are checked at build time$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$It works identically to ${topic.getTitle()}, since Spring auto-generates a getter for every record$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$It works perfectly -- Thymeleaf always adds parentheses automatically for records$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$It can silently fail or return null/an error, since ${topic.title} (without parentheses) doesn't correctly resolve a record's real accessor method the way ${topic.title()} does$$, TRUE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Konu bir Java record'u olduğuna göre (erişimcisi getBaslik() tarzı bir bean getter'ı değil, gerçek bir baslik() metodudur), bu tam Thymeleaf ifadesindeki risk nedir?$$,
           $$record Konu(String slug, String baslik) {}
// model.addAttribute("konu", new Konu("kayitlar", "Kayıtlar"));

<!-- şablon -->
<h1 th:text="${konu.baslik}">placeholder</h1>$$, $$html$$,
           $$${konu.baslik} (parantezsiz), ${konu.baslik()}'in yaptığı gibi bir record'un gerçek erişimci metodunu doğru şekilde çözemez -- sessizce başarısız olabilir ya da null/hata döndürebilir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-views-thymeleaf'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Thymeleaf ifadeleri derleme zamanında kontrol edildiği için derleme zamanı hatası fırlatır$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Spring her record için otomatik bir getter ürettiğinden ${konu.getBaslik()} ile aynı şekilde çalışır$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Sessizce başarısız olabilir ya da null/hata döndürebilir, çünkü ${konu.baslik} (parantezsiz), ${konu.baslik()}'in yaptığı gibi bir record'un gerçek erişimci metodunu doğru şekilde çözemez$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Mükemmel çalışır -- Thymeleaf record'lar için parantezleri her zaman otomatik ekler$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Inside @{/topics/{slug}(slug=${slug}, lang=${lang})}, if {slug} is already a placeholder in the path, what happens to the slug=${slug} and lang=${lang} parts?$$,
           NULL, NULL,
           $$slug=${slug} fills the existing {slug} path placeholder; lang=${lang} has no matching placeholder, so it becomes a query string parameter instead.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-views-thymeleaf'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Both automatically become query string parameters$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$slug=${slug} fills the existing {slug} path placeholder; lang=${lang} has no matching placeholder, so it becomes a query string parameter instead$$, TRUE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Both are ignored since {slug} is already filled$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$It causes a build-time error since a parameter can't share a name with a path placeholder$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$@{/topics/{slug}(slug=${slug}, lang=${lang})} içinde, {slug} path'te zaten bir placeholder ise, slug=${slug} ve lang=${lang} kısımlarına ne olur?$$,
           NULL, NULL,
           $$slug=${slug}, mevcut {slug} path placeholder'ını doldurur; lang=${lang}'ın eşleşen bir placeholder'ı olmadığı için query string parametresi olur.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-views-thymeleaf'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$slug=${slug}, mevcut {slug} path placeholder'ını doldurur; lang=${lang}'ın eşleşen bir placeholder'ı olmadığı için query string parametresi olur$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$İkisi de otomatik olarak query string parametresi olur$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $${slug} zaten dolu olduğu için ikisi de yok sayılır$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Bir parametre bir path placeholder'ıyla aynı adı paylaşamayacağı için derleme zamanı hatası oluşur$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What is the key safety difference between th:text and th:utext?$$,
           NULL, NULL,
           $$th:text always escapes HTML special characters (safe against XSS); th:utext writes output verbatim, unescaped.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-views-thymeleaf'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$th:text only works with numeric values$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$th:utext is deprecated and should never be used$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$th:utext is faster to render, th:text is slower$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$th:text always escapes HTML special characters (safe against XSS); th:utext writes output verbatim, unescaped$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$th:text ile th:utext arasındaki temel güvenlik farkı nedir?$$,
           NULL, NULL,
           $$th:text her zaman HTML özel karakterlerini escape eder (XSS'e karşı güvenlidir); th:utext çıktıyı olduğu gibi, escape etmeden yazar.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-views-thymeleaf'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$th:text yalnızca sayısal değerlerle çalışır$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$th:utext kullanımdan kaldırılmıştır ve asla kullanılmamalıdır$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$th:text her zaman HTML özel karakterlerini escape eder (XSS'e karşı güvenlidir); th:utext çıktıyı olduğu gibi, escape etmeden yazar$$, TRUE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$th:utext kullanılması daha hızlıdır, th:text daha yavaştır$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What is the behavioral difference between th:if and CSS's display:none?$$,
           NULL, NULL,
           $$th:if removes the tag from the HTML output entirely when the condition is false; display:none still sends the element to the browser, just hides it visually.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-views-thymeleaf'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$There is no difference, they behave identically$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$th:if removes the tag from the HTML output entirely when the condition is false; display:none still sends the element to the browser, just hides it visually$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$display:none is evaluated on the server, th:if on the client$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$th:if can only be used on <div> tags$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$th:if ile CSS'in display:none'ı arasındaki davranış farkı nedir?$$,
           NULL, NULL,
           $$th:if, koşul yanlışsa etiketi HTML çıktısından tamamen kaldırır; display:none elementi yine tarayıcıya gönderir, yalnızca görsel olarak gizler.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-views-thymeleaf'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$th:if, koşul yanlışsa etiketi HTML çıktısından tamamen kaldırır; display:none elementi yine tarayıcıya gönderir, yalnızca görsel olarak gizler$$, TRUE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Hiçbir fark yoktur, aynı şekilde davranırlar$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$display:none sunucuda değerlendirilir, th:if istemcide değerlendirilir$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$th:if yalnızca <div> etiketlerinde kullanılabilir$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, ADVANCED)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What is the key difference between th:insert and th:replace when pulling in a fragment?$$,
           NULL, NULL,
           $$th:insert places the fragment inside the host tag (the host tag stays); th:replace swaps the host tag out entirely for the fragment's own root tag.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-views-thymeleaf'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$th:insert places the fragment inside the host tag (the host tag stays); th:replace swaps the host tag out entirely for the fragment's own root tag$$, TRUE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$th:replace is deprecated in favor of th:insert$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$th:insert only works with external files, th:replace only with the same file$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$They are functionally identical, differing only in naming convention$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, ADVANCED)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bir fragment'ı dahil ederken th:insert ile th:replace arasındaki temel fark nedir?$$,
           NULL, NULL,
           $$th:insert, fragment'ı host etiketin İÇİNE yerleştirir (host etiket kalır); th:replace, host etiketi tamamen fragment'ın kendi kök etiketiyle değiştirir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-views-thymeleaf'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İşlevsel olarak aynıdırlar, yalnızca isimlendirme kuralı bakımından farklıdırlar$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$th:replace, th:insert lehine kullanımdan kaldırılmıştır$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$th:insert, fragment'ı host etiketin İÇİNE yerleştirir (host etiket kalır); th:replace, host etiketi tamamen fragment'ın kendi kök etiketiyle değiştirir$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$th:insert yalnızca harici dosyalarla, th:replace yalnızca aynı dosyayla çalışır$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$This expression is inside a selection filter .?[...], where activeSlug is a variable from the outer scope (not a field on Topic). What is the likely result when this actually runs?$$,
           $$<li th:each="category : ${categories}"
    th:with="isActive=${category.topics().?[#this.slug() == activeSlug].size() > 0}">
    ...
</li>$$, $$html$$,
           $$Inside .?[...], #this rebinds the entire scope to the current element, so activeSlug is looked up as a field on Topic instead of the outer variable, throwing a SpelEvaluationException.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-views-thymeleaf'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It works correctly, filtering topics whose slug matches activeSlug$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$It throws a SpelEvaluationException -- inside .?[...], #this rebinds the entire scope to the current element, so activeSlug is looked up as a field on Topic instead of the outer variable$$, TRUE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$It always evaluates to false, silently, with no exception$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$It causes an infinite loop$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu ifade bir seçim filtresinin (.?[...]) içinde ve aktifSlug, dış kapsamdan gelen bir değişken (bir Konu alanı değil). Bu gerçekten çalıştığında muhtemel sonuç nedir?$$,
           $$<li th:each="kategori : ${kategoriler}"
    th:with="aktifMi=${kategori.konular().?[#this.slug() == aktifSlug].size() > 0}">
    ...
</li>$$, $$html$$,
           $$.?[...] içinde #this, tüm kapsamı geçerli elemana yeniden bağlar, bu yüzden aktifSlug, dış değişken yerine Konu üzerinde bir alan olarak aranır ve bir SpelEvaluationException fırlatır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'spring-mvc-views-thymeleaf'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir SpelEvaluationException fırlatır -- .?[...] içinde #this, tüm kapsamı geçerli elemana yeniden bağlar, bu yüzden aktifSlug, dış değişken yerine Konu üzerinde bir alan olarak aranır$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Doğru şekilde çalışır, slug'ı aktifSlug ile eşleşen konuları filtreler$$, FALSE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Her zaman sessizce false olarak değerlendirilir, istisna fırlatmaz$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Sonsuz bir döngüye yol açar$$, FALSE, 3 FROM new_question_tr7;
