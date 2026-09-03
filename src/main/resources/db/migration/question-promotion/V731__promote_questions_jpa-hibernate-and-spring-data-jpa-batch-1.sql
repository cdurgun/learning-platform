-- Promotion batch
-- Topic: jpa-hibernate-and-spring-data-jpa (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V715-V730 (Advanced Spring) and V679-V714
-- (Spring MVC), these 14 questions were NOT produced by the n8n generation
-- pipeline, NOT judged by the AI Judge, and NOT ingested via
-- /api/internal/questions/ingest -- per explicit user request, they were
-- hand-authored and independently self-reviewed directly inside a Claude Code
-- session, grounded strictly in content/en/jpa-hibernate-and-spring-data-jpa.md and
-- content/tr/jpa-hibernate-and-spring-data-jpa.md.
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
           $$What is JPA (Jakarta Persistence API), precisely?$$,
           NULL, NULL,
           $$JPA is a specification -- a set of interfaces and annotations describing how object-relational mapping should work, with no runtime behavior of its own.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A specification -- a set of interfaces and annotations with no runtime behavior of its own$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$A library you install and run directly, like Hibernate$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Another name for Hibernate itself$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$A Spring-specific tool for generating repository implementations$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$JPA (Jakarta Persistence API) tam olarak nedir?$$,
           NULL, NULL,
           $$JPA bir spesifikasyondur -- kendi başına hiçbir çalışma zamanı davranışı olmayan, bir dizi interface ve annotation'dır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Repository implementasyonları üreten Spring'e özgü bir araç$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Kendi başına hiçbir çalışma zamanı davranışı olmayan, bir dizi interface ve annotation'dan oluşan bir spesifikasyon$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Hibernate gibi doğrudan kurup çalıştırabileceğin bir kütüphane$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Hibernate'in kendisinin başka bir adı$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What is Hibernate's relationship to JPA?$$,
           NULL, NULL,
           $$Hibernate is a concrete implementation of the JPA specification -- it's what actually generates the SQL underneath.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$JPA is built on top of Hibernate, not the other way around$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Hibernate is a concrete implementation of the JPA specification$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Hibernate and JPA are two interchangeable names for the same thing$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Hibernate is a newer specification that replaced JPA$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Hibernate'in JPA ile ilişkisi nedir?$$,
           NULL, NULL,
           $$Hibernate, JPA spesifikasyonunun somut bir implementasyonudur -- SQL'i altta gerçekte üreten odur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hibernate, JPA'nın yerini alan daha yeni bir spesifikasyondur$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$JPA, Hibernate'in üzerine kuruludur, tersi değil$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Hibernate, JPA spesifikasyonunun somut bir implementasyonudur$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Hibernate ve JPA, aynı şeyin birbirinin yerine kullanılabilen iki adıdır$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$When a Spring Data JPA repository method runs, what actually happens underneath?$$,
           NULL, NULL,
           $$It still goes through JPA's EntityManager and still gets turned into SQL by Hibernate -- Spring Data JPA only removes the repetitive boilerplate, it doesn't bypass either layer.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Spring Data JPA replaces Hibernate with its own, separate SQL generation engine$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$It depends on whether the method is a derived query or a custom @Query$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Spring Data JPA bypasses JPA and Hibernate entirely, talking to the database directly$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$It still goes through JPA's EntityManager and still gets turned into SQL by Hibernate underneath$$, TRUE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir Spring Data JPA repository metodu çalıştığında, altta gerçekte ne olur?$$,
           NULL, NULL,
           $$Yine de JPA'nın EntityManager'ından geçer ve altta Hibernate tarafından SQL'e dönüştürülür -- Spring Data JPA yalnızca tekrarlayan boilerplate'i kaldırır, hiçbir katmanı atlamaz.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Spring Data JPA, JPA ve Hibernate'i tamamen atlayarak veritabanıyla doğrudan konuşur$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Spring Data JPA, Hibernate'in yerine kendi ayrı SQL üretme motorunu koyar$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Metodun türetilmiş bir sorgu mu yoksa özel bir @Query mi olduğuna bağlıdır$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Yine de JPA'nın EntityManager'ından geçer ve altta Hibernate tarafından SQL'e dönüştürülür$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which sequence correctly reflects how a repository call flows through this project's four layers?$$,
           NULL, NULL,
           $$Repository (interface) -> Spring Data JPA (generates implementation) -> JPA (specification: EntityManager) -> Hibernate (implementation: generates SQL).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hibernate -> JPA -> Spring Data JPA -> Repository$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Repository -> Hibernate -> JPA -> Spring Data JPA$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$JPA -> Repository -> Hibernate -> Spring Data JPA$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Repository -> Spring Data JPA -> JPA -> Hibernate$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir repository çağrısının bu projenin dört katmanından nasıl geçtiğini hangi sıra doğru yansıtır?$$,
           NULL, NULL,
           $$Repository (interface) -> Spring Data JPA (implementasyon üretir) -> JPA (spesifikasyon: EntityManager) -> Hibernate (implementasyon: SQL üretir).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Repository -> Spring Data JPA -> JPA -> Hibernate$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Hibernate -> JPA -> Spring Data JPA -> Repository$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Repository -> Hibernate -> JPA -> Spring Data JPA$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$JPA -> Repository -> Hibernate -> Spring Data JPA$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why can't a Java record be used as a JPA entity?$$,
           NULL, NULL,
           $$Hibernate builds entity instances via reflection before populating their fields, which requires a no-args constructor and mutable fields -- a record has neither.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Because records are a preview feature not yet supported by any JPA provider$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Because it has no no-args constructor and no mutable fields for Hibernate to populate via reflection$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Because JPA only works with classes annotated @Service$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Because records cannot have a field named id$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir Java record'u neden bir JPA entity'si olarak kullanılamaz?$$,
           NULL, NULL,
           $$Hibernate, entity instance'larını alanları doldurmadan önce reflection ile oluşturur, bu da parametresiz bir constructor ve mutable alanlar gerektirir -- bir record'da ikisi de yoktur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çünkü record'lar id adında bir alana sahip olamaz$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Çünkü Hibernate'in reflection ile doldurabileceği ne parametresiz bir constructor'ı ne de mutable alanları vardır$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Çünkü record'lar henüz hiçbir JPA sağlayıcısı tarafından desteklenmeyen bir preview özelliğidir$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Çünkü JPA yalnızca @Service ile işaretlenmiş sınıflarla çalışır$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, BEGINNER)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe Spring Boot's role in this four-layer picture? (Select all that apply)$$,
           NULL, NULL,
           $$Spring Boot doesn't add a new layer -- it auto-configures a DataSource, EntityManagerFactory, Hibernate as the JPA provider, and repository infrastructure, all without manual configuration.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It requires manual configuration of the EntityManagerFactory before any repository can work$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$It auto-configures a DataSource, EntityManagerFactory, and Hibernate as the JPA provider$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$It wires the existing JPA/Hibernate/Spring Data JPA layers together automatically, without adding a new layer of its own$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$It replaces Hibernate with its own, Spring-specific ORM implementation$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, BEGINNER)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri Spring Boot'un bu dört katmanlı resimdeki rolünü doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Spring Boot yeni bir katman eklemez -- bir DataSource, EntityManagerFactory, JPA sağlayıcısı olarak Hibernate ve repository altyapısını, hiçbir elle yapılandırma olmadan otomatik olarak kurar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hibernate'in yerine kendi, Spring'e özgü ORM implementasyonunu koyar$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Herhangi bir repository çalışmadan önce EntityManagerFactory'nin elle yapılandırılmasını gerektirir$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Kendi yeni bir katman eklemeden, mevcut JPA/Hibernate/Spring Data JPA katmanlarını otomatik olarak birbirine bağlar$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir DataSource, EntityManagerFactory ve JPA sağlayıcısı olarak Hibernate'i otomatik olarak yapılandırır$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly assign a responsibility to the right layer? (Select all that apply)$$,
           NULL, NULL,
           $$JPA defines WHAT mapping should look like; Hibernate actually executes it as SQL; Spring Data JPA removes the boilerplate of writing an EntityManager-based class by hand for every entity.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Spring Data JPA is what actually generates the SQL sent to PostgreSQL$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$Hibernate is a repository abstraction that generates interface implementations$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$JPA defines WHAT object-relational mapping should look like, via annotations and interfaces$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Hibernate is what actually turns @Entity-annotated classes and JPA calls into real SQL$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri bir sorumluluğu doğru katmana atar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$JPA, mapping'in NASIL görünmesi gerektiğini tanımlar; Hibernate bunu gerçekten SQL olarak çalıştırır; Spring Data JPA, her entity için elle bir EntityManager tabanlı sınıf yazmanın boilerplate'ini kaldırır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$JPA, annotation'lar ve interface'ler aracılığıyla object-relational mapping'in NASIL görünmesi gerektiğini tanımlar$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Spring Data JPA, PostgreSQL'e gönderilen SQL'i gerçekte üreten şeydir$$, FALSE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Hibernate, interface implementasyonları üreten bir repository soyutlamasıdır$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Hibernate, @Entity ile işaretlenmiş sınıfları ve JPA çağrılarını gerçekten SQL'e dönüştüren şeydir$$, TRUE, 3 FROM new_question_tr7;
