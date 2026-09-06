-- Promotion batch
-- Topic: security (language: en x6, tr x6)
-- Generated: 2026-09-07 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 12 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/security.md and content/tr/security.md -- NOT produced by n8n,
-- NOT judged by any external AI API, and NOT ingested via
-- /api/internal/questions/ingest.
--
-- Per-topic question count is FLEXIBLE (6 EN + 6 TR here), sized to
-- this lesson's actual concept density -- same convention established in the
-- Docker/PostgreSQL Foundations/git-github batches.
--
-- Strict 50/50 EN/TR split organized as 6 CONCEPT PAIRS -- each EN question
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
           $$Per "Authentication vs. Authorization: Two Different Questions," what is the key difference between the two?$$,
           NULL, NULL,
           $$The lesson explains authentication asks who is this, while authorization asks whether this identity is allowed to do this specific thing -- a separate decision that happens after.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$security$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$They're two names for the exact same check, used interchangeably$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Authentication asks "who is this?", while authorization asks "is this identity allowed to do this specific thing?" -- a separate decision that happens after$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Authorization always happens before authentication in every system$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Authentication only applies to POST requests, authorization only to GET requests$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$"Authentication vs. Authorization: Two Different Questions" bölümüne göre, ikisi arasındaki temel fark nedir?$$,
           NULL, NULL,
           $$Ders, authentication'ın "bu kim?" sorusunu sorduğunu, authorization'ın ise bu kimliğin bu belirli şeyi yapmaya izinli olup olmadığını sorduğunu -- sonrasında gerçekleşen ayrı bir karar olduğunu açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$security$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İkisi, birbirinin yerine kullanılan, birebir aynı kontrolün iki adıdır$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Authentication "bu kim?" sorusunu sorar, authorization ise "bu kimlik bu belirli şeyi yapmaya izinli mi?" sorusunu sorar -- sonrasında gerçekleşen ayrı bir karar$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Authorization her sistemde her zaman authentication'dan önce gerçekleşir$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Authentication yalnızca POST isteklerine, authorization yalnızca GET isteklerine uygulanır$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Per "JWT: A Self-Contained, Verifiable Identity," what lets api-gateway and order-service both verify the same token independently, without calling back to a central store?$$,
           NULL, NULL,
           $$The lesson explains a JWT's cryptographic signature can be verified by anyone holding the issuer's public key.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$security$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Both services share the exact same in-memory session cache$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$A JWT's cryptographic signature can be verified by anyone holding the issuer's public key$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$order-service always trusts whatever api-gateway already checked, without re-verifying$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$JWTs are stored in a shared database both services query on every request$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$"JWT: A Self-Contained, Verifiable Identity" bölümüne göre, api-gateway ve order-service'in ikisinin de, merkezi bir depoya geri çağrı yapmadan, aynı token'ı bağımsız olarak doğrulamasını sağlayan nedir?$$,
           NULL, NULL,
           $$Ders, bir JWT'nin kriptografik imzasının, issuer'ın public key'ine sahip herkes tarafından doğrulanabileceğini açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$security$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İki servis de birebir aynı bellek içi session cache'ini paylaşır$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Bir JWT'nin kriptografik imzası, issuer'ın public key'ine sahip herkes tarafından doğrulanabilir$$, TRUE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$order-service, yeniden doğrulamadan, api-gateway'in zaten kontrol ettiği her şeye her zaman güvenir$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$JWT'ler, her iki servisin de her istekte sorguladığı paylaşılan bir veritabanında saklanır$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Per "Why the Gateway Alone Isn't Enough: Zero Trust Between Services," why does order-service verify the JWT itself, instead of trusting that api-gateway already checked it?$$,
           NULL, NULL,
           $$The lesson explains any path that bypasses api-gateway -- a misconfigured route, a direct internal call -- would otherwise have no protection at all.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$security$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Because api-gateway technically cannot verify JWTs at all$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Because any path that bypasses api-gateway (a misconfigured route, a direct internal call) would otherwise have no protection at all$$, TRUE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Because verifying a JWT twice is required by the JWT specification itself$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Because order-service and api-gateway use incompatible JWT formats$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$"Why the Gateway Alone Isn't Enough: Zero Trust Between Services" bölümüne göre, order-service, api-gateway'in onu zaten kontrol ettiğine güvenmek yerine JWT'yi neden kendisi doğrular?$$,
           NULL, NULL,
           $$Ders, api-gateway'i atlayan herhangi bir yolun -- yanlış yapılandırılmış bir route, doğrudan bir dahili çağrı -- aksi halde hiçbir korumaya sahip olmayacağını açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$security$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çünkü api-gateway teknik olarak JWT'leri hiç doğrulayamaz$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Çünkü api-gateway'i atlayan herhangi bir yol (yanlış yapılandırılmış bir route, doğrudan bir dahili çağrı) aksi halde hiçbir korumaya sahip olmazdı$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Çünkü bir JWT'yi iki kez doğrulamak, JWT spesifikasyonunun kendisi tarafından zorunlu kılınır$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Çünkü order-service ve api-gateway uyumsuz JWT formatları kullanır$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Given OrderServiceSecurityConfig below, a request arrives at POST /orders carrying a valid, correctly-signed JWT -- but that JWT's identity has no customer role. What HTTP status is returned?$$,
           $$.authorizeHttpRequests(requests -> requests
        .requestMatchers("/actuator/health").permitAll()
        .requestMatchers(HttpMethod.POST, "/orders").hasRole("customer")
        .anyRequest().authenticated())$$, $$java$$,
           $$The real OrderServiceSecurityConfig.java requires hasRole("customer") for POST /orders specifically -- an authenticated but unauthorized identity gets 403 Forbidden, not 401.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$security$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$200 OK, since a valid JWT is enough regardless of role$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$401 Unauthorized, since the token itself is considered invalid$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$403 Forbidden, since authentication succeeded but this identity isn't authorized for this specific action$$, TRUE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$404 Not Found, since /orders is hidden from unauthorized identities$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdaki OrderServiceSecurityConfig göz önüne alındığında, POST /orders'a, geçerli ve doğru şekilde imzalanmış bir JWT taşıyan bir istek geliyor -- ama bu JWT'nin kimliğinin customer rolü yok. Hangi HTTP durumu döner?$$,
           $$.authorizeHttpRequests(requests -> requests
        .requestMatchers("/actuator/health").permitAll()
        .requestMatchers(HttpMethod.POST, "/orders").hasRole("customer")
        .anyRequest().authenticated())$$, $$java$$,
           $$Gerçek OrderServiceSecurityConfig.java, özellikle POST /orders için hasRole("customer") gerektirir -- authenticate edilmiş ama yetkisiz bir kimlik 401 değil, 403 Forbidden alır.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$security$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$200 OK, çünkü rolden bağımsız olarak geçerli bir JWT yeterlidir$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$401 Unauthorized, çünkü token'ın kendisi geçersiz sayılır$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$403 Forbidden, çünkü authentication başarılı oldu ama bu kimlik bu belirli eylem için yetkili değil$$, TRUE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$404 Not Found, çünkü /orders, yetkisiz kimliklerden gizlenir$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Per "Propagating Identity: The Correlation Id's Security Counterpart," what happens if RestClientBearerTokenInterceptor is missing when order-service calls inventory-service?$$,
           NULL, NULL,
           $$The lesson explains inventory-service would receive a completely unauthenticated request, even though the original external request was properly authenticated.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$security$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The call fails immediately with a compilation error$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$inventory-service receives a completely unauthenticated request, even though the original external request was properly authenticated$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$order-service's own JWT is automatically regenerated for the outgoing call$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$inventory-service falls back to trusting order-service unconditionally$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$"Propagating Identity: The Correlation Id's Security Counterpart" bölümüne göre, order-service, inventory-service'i çağırırken RestClientBearerTokenInterceptor eksikse ne olur?$$,
           NULL, NULL,
           $$Ders, orijinal harici istek düzgün şekilde authenticate edilmiş olsa bile, inventory-service'in tamamen authenticate edilmemiş bir istek alacağını açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$security$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çağrı hemen bir compilation hatasıyla başarısız olur$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Orijinal harici istek düzgün şekilde authenticate edilmiş olsa bile, inventory-service tamamen authenticate edilmemiş bir istek alır$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$order-service'in kendi JWT'si, giden çağrı için otomatik olarak yeniden üretilir$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$inventory-service, order-service'e koşulsuz olarak güvenmeye geri döner$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about this lesson's security design are correct? (Select all that apply)$$,
           NULL, NULL,
           $$The lesson's real examples show api-gateway using @EnableWebFluxSecurity (reactive) and order-service using @EnableWebSecurity (servlet), and health check endpoints are deliberately kept public.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$security$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$api-gateway uses the reactive security config style (@EnableWebFluxSecurity), while order-service uses the servlet-based style (@EnableWebSecurity)$$, TRUE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$A 401 Unauthorized and a 403 Forbidden mean exactly the same thing and can be used interchangeably$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Health check endpoints (/actuator/health) are deliberately kept public, since load balancers need to reach them without a token$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Once api-gateway verifies a JWT, no other service in this course ever needs to verify it again$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu dersin güvenlik tasarımı hakkındaki aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Dersin gerçek örnekleri, api-gateway'in reaktif @EnableWebFluxSecurity'yi, order-service'in ise servlet tabanlı @EnableWebSecurity'yi kullandığını gösterir, ve sağlık kontrolü endpoint'leri bilinçli olarak açık tutulur.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic WHERE slug = $$security$$
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$api-gateway, reaktif güvenlik yapılandırma tarzını (@EnableWebFluxSecurity) kullanırken, order-service servlet tabanlı tarzı (@EnableWebSecurity) kullanır$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$401 Unauthorized ve 403 Forbidden birebir aynı anlama gelir ve birbirinin yerine kullanılabilir$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Sağlık kontrolü endpoint'leri (/actuator/health), yük dengeleyicilerin onlara token olmadan ulaşması gerektiği için bilinçli olarak açık tutulur$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$api-gateway bir JWT'yi doğruladıktan sonra, bu kurstaki başka hiçbir servisin onu tekrar doğrulamasına gerek yoktur$$, FALSE, 3 FROM new_question_tr6;
