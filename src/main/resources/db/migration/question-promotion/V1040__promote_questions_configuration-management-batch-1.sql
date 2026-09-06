-- Promotion batch
-- Topic: configuration-management (language: en x5, tr x5)
-- Generated: 2026-09-07 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 10 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/configuration-management.md and content/tr/configuration-management.md -- NOT produced by n8n,
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
           $$What problem does centralizing configuration in a Config Server solve, per this lesson?$$,
           NULL, NULL,
           $$The lesson explains centralizing avoids copy-pasting and manually updating the same shared configuration value across many services' own files.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$configuration-management$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It eliminates the need for any application.yml file whatsoever$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$It avoids copy-pasting and manually updating the same shared configuration value across many services' own files$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It automatically encrypts every HTTP request between services$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$It removes the need for a database connection string entirely$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, yapılandırmayı bir Config Server'da merkezileştirmek hangi problemi çözer?$$,
           NULL, NULL,
           $$Ders, merkezileştirmenin, aynı paylaşılan yapılandırma değerini birçok servisin kendi dosyasında kopyalayıp elle güncellemekten kaçındığını açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$configuration-management$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Herhangi bir application.yml dosyasına olan ihtiyacı tamamen ortadan kaldırır$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Aynı paylaşılan yapılandırma değerini birçok servisin kendi dosyasında kopyalayıp elle güncellemekten kaçınır$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Servisler arasındaki her HTTP isteğini otomatik olarak şifreler$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir veritabanı bağlantı dizesine olan ihtiyacı tamamen ortadan kaldırır$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Per "The Config Repository: Where Configuration Actually Lives," why do server.port and spring.application.name stay in order-service's own local application.yml, instead of being centralized?$$,
           NULL, NULL,
           $$The lesson explains a service needs to know its own identity and port before it can even ask Config Server for anything else.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$configuration-management$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Because Config Server technically cannot store integer values like ports$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Because a service needs to know its own identity and port before it can even ask Config Server for anything else$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Because server.port and spring.application.name are deprecated properties$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Because centralizing them would require a separate database$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$"The Config Repository: Where Configuration Actually Lives" bölümüne göre, server.port ve spring.application.name neden merkezileştirilmek yerine order-service'in kendi yerel application.yml'inde kalır?$$,
           NULL, NULL,
           $$Ders, bir servisin, Config Server'a başka bir şey sormadan önce bile kendi kimliğini ve portunu bilmesi gerektiğini açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$configuration-management$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çünkü Config Server teknik olarak port gibi tamsayı değerleri saklayamaz$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Çünkü bir servisin, Config Server'a başka bir şey sormadan önce bile kendi kimliğini ve portunu bilmesi gerekir$$, TRUE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Çünkü server.port ve spring.application.name kullanımdan kaldırılmış özelliklerdir$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Çünkü bunları merkezileştirmek ayrı bir veritabanı gerektirir$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A @RefreshScope-annotated bean reads greeting.message via @Value. A developer edits that value in the Config Repository, but never calls /actuator/refresh. What does the running service see?$$,
           $$@RestController
@RefreshScope
class RefreshableGreetingController {
    @Value("${greeting.message}")
    private String greetingMessage;
}$$, $$java$$,
           $$The lesson explains @RefreshScope only re-reads @Value-injected properties when a refresh is actually triggered -- without it, nothing changes until the next restart.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$configuration-management$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The new value, automatically, on the very next request$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$The old value -- @RefreshScope only re-reads @Value's when a refresh is actually triggered$$, TRUE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$A NoSuchBeanDefinitionException, since the bean's configuration no longer matches$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$null, since editing a Config Repository file always invalidates the property immediately$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$@RefreshScope ile annotate edilmiş bir bean, greeting.message'ı @Value aracılığıyla okuyor. Bir geliştirici bu değeri Config Repository'de düzenliyor, ama hiçbir zaman /actuator/refresh'i çağırmıyor. Çalışan servis ne görür?$$,
           $$@RestController
@RefreshScope
class RefreshableGreetingController {
    @Value("${greeting.message}")
    private String greetingMessage;
}$$, $$java$$,
           $$Ders, @RefreshScope'un, @Value ile inject edilen özellikleri yalnızca bir refresh gerçekten tetiklendiğinde yeniden okuduğunu -- olmadan hiçbir şeyin bir sonraki yeniden başlatmaya kadar değişmediğini açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$configuration-management$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yeni değeri, otomatik olarak, bir sonraki istekte$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Eski değeri -- @RefreshScope, @Value'ları yalnızca bir refresh gerçekten tetiklendiğinde yeniden okur$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Bir NoSuchBeanDefinitionException, çünkü bean'in yapılandırması artık eşleşmiyor$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$null, çünkü bir Config Repository dosyasını düzenlemek özelliği her zaman anında geçersiz kılar$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, ADVANCED)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Per "Secrets: What Config Server Should NOT Store in Plain Text," how does this lesson recommend handling order-service's database password, even with Config Server available?$$,
           NULL, NULL,
           $$The lesson explains the password stays an environment variable, and only configuration that isn't genuinely a secret gets centralized.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$configuration-management$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Move it into the Config Repository as plain text, since the repository is private$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Keep it as an environment variable (${ORDERS_DB_PASSWORD}), and only centralize configuration that isn't genuinely a secret$$, TRUE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Store it inside order-service's own compiled .jar file$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Email it manually to every team member who needs it$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, ADVANCED)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$"Secrets: What Config Server Should NOT Store in Plain Text" bölümüne göre, bu ders, Config Server mevcut olsa bile, order-service'in veritabanı şifresini nasıl ele almayı önerir?$$,
           NULL, NULL,
           $$Ders, şifrenin bir ortam değişkeni olarak kaldığını, ve yalnızca gerçekten bir sır olmayan yapılandırmanın merkezileştirildiğini açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$configuration-management$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Repository özel olduğu için onu düz metin olarak Config Repository'ye taşımak$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Onu bir ortam değişkeni (${ORDERS_DB_PASSWORD}) olarak tutmak, ve yalnızca gerçekten bir sır olmayan yapılandırmayı merkezileştirmek$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Onu order-service'in kendi derlenmiş .jar dosyasının içinde saklamak$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Onu ihtiyacı olan her ekip üyesine elle e-posta ile göndermek$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are presented in this lesson as genuine mistakes when using Spring Cloud Config? (Select all that apply)$$,
           NULL, NULL,
           $$The lesson's Common Mistakes list centralizing identity/port and over-applying @RefreshScope as mistakes; using profiles and keeping secrets as environment variables are the recommended approaches.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$configuration-management$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Centralizing server.port or spring.application.name in the Config Repository$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Using profiles for environment-specific configuration overrides$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Applying @RefreshScope to every single bean "just in case"$$, TRUE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Keeping a database password as an environment variable instead of a Config Repository file$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri, bu derste Spring Cloud Config kullanırken yapılan gerçek hatalar olarak sunulur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Dersin Common Mistakes listesi kimlik/portu merkezileştirmeyi ve @RefreshScope'u aşırı uygulamayı hata olarak sayar; profilleri kullanmak ve sırları ortam değişkeni olarak tutmak ise önerilen yaklaşımlardır.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$configuration-management$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$server.port veya spring.application.name'i Config Repository'de merkezileştirmek$$, TRUE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Ortama özgü yapılandırma override'ları için profilleri kullanmak$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$@RefreshScope'u "ihtiyaç olur diye" her tek bean'e uygulamak$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Bir veritabanı şifresini bir Config Repository dosyası yerine bir ortam değişkeni olarak tutmak$$, FALSE, 3 FROM new_question_tr5;
