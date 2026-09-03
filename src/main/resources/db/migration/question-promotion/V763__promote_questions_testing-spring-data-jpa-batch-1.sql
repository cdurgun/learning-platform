-- Promotion batch
-- Topic: testing-spring-data-jpa (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V715-V730 (Advanced Spring) and V679-V714
-- (Spring MVC), these 14 questions were NOT produced by the n8n generation
-- pipeline, NOT judged by the AI Judge, and NOT ingested via
-- /api/internal/questions/ingest -- per explicit user request, they were
-- hand-authored and independently self-reviewed directly inside a Claude Code
-- session, grounded strictly in content/en/testing-spring-data-jpa.md and
-- content/tr/testing-spring-data-jpa.md.
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
           $$A test writes when(repository.findBySlug("records")).thenReturn(...). If the REAL findBySlug method were misspelled or filtered on the wrong column entirely, would this test catch it?$$,
           NULL, NULL,
           $$No -- the mock never asks Spring Data JPA to parse the real method into a real query, and never touches a database; it only verifies the mock's own configured behavior.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'testing-spring-data-jpa'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yes -- Mockito always validates a mocked method's name against the real repository interface$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$No -- the mock only verifies its own configured behavior, never asking Spring Data JPA to parse or run the real query$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It depends on whether the method is a derived query or a custom @Query$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Yes, but only if the test is also annotated with @DataJpaTest$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir test, when(repository.findBySlug("records")).thenReturn(...) yazıyor. GERÇEK findBySlug metodu yanlış yazılmış ya da tamamen yanlış bir kolonda filtreleme yapıyor olsaydı, bu test bunu yakalar mıydı?$$,
           NULL, NULL,
           $$Hayır -- mock, Spring Data JPA'dan gerçek metodu gerçek bir sorguya ayrıştırmasını hiç istemez ve hiçbir zaman veritabanına dokunmaz; yalnızca mock'un kendi yapılandırılmış davranışını doğrular.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'testing-spring-data-jpa'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Evet, ama yalnızca test @DataJpaTest ile de işaretlenmişse$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Hayır -- mock yalnızca kendi yapılandırılmış davranışını doğrular, Spring Data JPA'dan gerçek sorguyu hiç ayrıştırmasını ya da çalıştırmasını istemez$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Evet -- Mockito her zaman mock'lanmış bir metodun adını gerçek repository interface'ine karşı doğrular$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Metodun türetilmiş bir sorgu mu yoksa özel bir @Query mi olduğuna bağlıdır$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What does @DataJpaTest load, and what happens to each test method's changes afterward?$$,
           NULL, NULL,
           $$It loads only the persistence layer (entities, repositories, a real database connection), and each test method runs inside its own transaction, automatically rolled back afterward.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'testing-spring-data-jpa'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It loads nothing at all until @Autowired is added to a field$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$It loads the entire application, including controllers and services; changes persist across tests$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$It loads only the persistence layer (entities, repositories, a real database connection), with each test's transaction rolled back afterward$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$It loads only controllers, mocking every repository automatically$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$@DataJpaTest neyi yükler ve her test metodunun değişikliklerine sonrasında ne olur?$$,
           NULL, NULL,
           $$Yalnızca persistence katmanını (entity'ler, repository'ler, gerçek bir veritabanı bağlantısı) yükler ve her test metodu kendi transaction'ı içinde çalışır, sonrasında otomatik olarak geri alınır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'testing-spring-data-jpa'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca controller'ları yükler, her repository'yi otomatik olarak mock'lar$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Bir alana @Autowired eklenene kadar hiçbir şey yüklemez$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Yalnızca persistence katmanını (entity'ler, repository'ler, gerçek bir veritabanı bağlantısı) yükler, her testin transaction'ı sonrasında geri alınır$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Controller'lar ve servisler dahil tüm uygulamayı yükler; değişiklikler testler arasında kalıcı olur$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why should test data for a @DataJpaTest be set up with TestEntityManager rather than the repository method the test is actually verifying?$$,
           NULL, NULL,
           $$Getting data into the database with the very repository method the test is trying to verify could hide a bug in that method behind its own setup.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'testing-spring-data-jpa'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Because repository methods cannot be called at all before @DataJpaTest finishes initializing$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Because TestEntityManager is required to make @DataJpaTest compile at all$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Because TestEntityManager is faster than any repository method by a significant margin$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Because using the method under test for its own setup could hide a bug in that method behind its own setup$$, TRUE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir @DataJpaTest için test verisi, testin gerçekten doğrulamaya çalıştığı repository metodu yerine neden TestEntityManager ile kurulmalıdır?$$,
           NULL, NULL,
           $$Verinin, testin doğrulamaya çalıştığı repository metodunun ta kendisiyle veritabanına konması, o metottaki bir hatayı kendi kurulumunun arkasına gizleyebilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'testing-spring-data-jpa'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çünkü TestEntityManager, herhangi bir repository metodundan önemli ölçüde daha hızlıdır$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Çünkü repository metotları, @DataJpaTest başlatılmayı bitirmeden önce hiç çağrılamaz$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Çünkü TestEntityManager, @DataJpaTest'in derlenmesi için bile gereklidir$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Çünkü test edilen metodu kendi kurulumu için kullanmak, o metottaki bir hatayı kendi kurulumunun arkasına gizleyebilir$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A test saves CodeExamples for two different topics, deliberately out of sort order, then calls findByTopicIdOrderBySortOrderAsc(topicId) and asserts only two results come back AND that they're in ascending order. Why is this a meaningfully stronger test than saving just one row and asserting it comes back?$$,
           $$entityManager.persist(new CodeExample(topicId, 2));
entityManager.persist(new CodeExample(topicId, 1));
entityManager.persist(new CodeExample(otherTopicId, 1));

List<CodeExample> result = repository.findByTopicIdOrderBySortOrderAsc(topicId);
assertThat(result).hasSize(2);
assertThat(result.get(0).getSortOrder()).isEqualTo(1);$$, $$java$$,
           $$It actually proves both real filtering (only topicId's rows, excluding otherTopicId's) and real ordering (sortOrder 1 before 2), which a single-row test could accidentally pass without proving either.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'testing-spring-data-jpa'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It proves real filtering (excluding otherTopicId) AND real ordering (sortOrder 1 before 2) at once, not just "returns whatever was saved"$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$It only proves filtering works -- ordering still requires a completely separate test method$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$It's meaningfully weaker, since persisting three rows risks a unique-constraint violation$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$It proves nothing more -- a single-row test would have caught the exact same bugs$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir test, iki farklı konu için CodeExample'ları, kasıtlı olarak sıralama dışı, kaydediyor, sonra findByTopicIdOrderBySortOrderAsc(topicId)'yi çağırıyor ve yalnızca iki sonucun geldiğini VE artan sırada olduklarını doğruluyor. Bu neden yalnızca bir satır kaydedip onun geri geldiğini doğrulamaktan anlamlı ölçüde daha güçlü bir testtir?$$,
           $$entityManager.persist(new CodeExample(konuId, 2));
entityManager.persist(new CodeExample(konuId, 1));
entityManager.persist(new CodeExample(digerKonuId, 1));

List<CodeExample> sonuc = repository.findByTopicIdOrderBySortOrderAsc(konuId);
assertThat(sonuc).hasSize(2);
assertThat(sonuc.get(0).getSortOrder()).isEqualTo(1);$$, $$java$$,
           $$Gerçekten hem gerçek filtrelemeyi (digerKonuId hariç tutularak) HEM DE gerçek sıralamayı (sortOrder 1'in 2'den önce gelmesi) aynı anda kanıtlar, tek satırlık bir test ikisini de kanıtlamadan yanlışlıkla geçebilirdi.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'testing-spring-data-jpa'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Gerçekten hem gerçek filtrelemeyi (digerKonuId hariç tutularak) hem de gerçek sıralamayı (sortOrder 1'in 2'den önce gelmesi) aynı anda kanıtlar$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Daha fazlasını kanıtlamaz -- tek satırlık bir test de tam olarak aynı hataları yakalardı$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Yalnızca filtrelemenin çalıştığını kanıtlar -- sıralama hâlâ tamamen ayrı bir test metodu gerektirir$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Anlamlı ölçüde daha zayıftır, çünkü üç satır persist etmek bir unique-constraint ihlali riski taşır$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A @DataJpaTest calls a custom @Query method using join fetch, and the JPQL has a typo in the joined property path. What would the test most likely reveal?$$,
           NULL, NULL,
           $$The test would fail immediately -- either with no result at all, or a genuine LazyInitializationException the moment the relationship is accessed outside the still-open test transaction.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'testing-spring-data-jpa'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Nothing -- a typo in JPQL is silently ignored by Hibernate and treated as a no-op$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$The test fails immediately -- either with no result, or a genuine LazyInitializationException when the relationship is accessed$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$The application fails to compile, since JPQL is checked by the Java compiler$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$The test passes, since @DataJpaTest doesn't actually execute a query's JPQL text$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir @DataJpaTest, join fetch kullanan özel bir @Query metodunu çağırıyor ve JPQL'deki join edilen property path'inde bir yazım hatası var. Test büyük olasılıkla neyi ortaya çıkarır?$$,
           NULL, NULL,
           $$Test hemen başarısız olurdu -- ya hiçbir sonuç olmadan, ya da ilişkiye hâlâ açık olan test transaction'ı dışında erişildiğinde gerçek bir LazyInitializationException ile.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'testing-spring-data-jpa'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Test geçer, çünkü @DataJpaTest gerçekte bir sorgunun JPQL metnini çalıştırmaz$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Test hemen başarısız olur -- ya hiçbir sonuç olmadan, ya da ilişkiye erişildiğinde gerçek bir LazyInitializationException ile$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Hiçbir şey -- JPQL'deki bir yazım hatası Hibernate tarafından sessizce yok sayılır ve no-op olarak ele alınır$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$JPQL Java derleyicisi tarafından kontrol edildiği için uygulama derlenmez$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe the trade-off of @DataJpaTest's default embedded test database? (Select all that apply)$$,
           NULL, NULL,
           $$An embedded database is fast and needs no setup, but a query relying on PostgreSQL-specific behavior (like a native RANDOM() query) can pass against the embedded substitute and still fail against the real thing.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'testing-spring-data-jpa'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$@DataJpaTest never uses an embedded database by default -- that behavior must always be explicitly enabled$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$It's fast and needs no setup, unlike pointing tests at a real PostgreSQL instance$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$A query relying on PostgreSQL-specific behavior can pass against it and still fail against real PostgreSQL$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$It behaves identically to PostgreSQL for every possible query, including native ones$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri @DataJpaTest'in varsayılan embedded test veritabanının ödünleşimini doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Embedded bir veritabanı hızlıdır ve kuruluma ihtiyaç duymaz, ama PostgreSQL'e özgü davranışa dayanan bir sorgu (native bir RANDOM() sorgusu gibi) embedded ikame karşısında geçebilir ve yine de gerçek şeye karşı başarısız olabilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'testing-spring-data-jpa'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Her olası sorgu için, native olanlar dahil, PostgreSQL ile birebir aynı davranır$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$@DataJpaTest varsayılan olarak asla embedded bir veritabanı kullanmaz -- bu davranış her zaman açıkça etkinleştirilmelidir$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$PostgreSQL'e özgü davranışa dayanan bir sorgu ona karşı geçebilir ve yine de gerçek PostgreSQL'e karşı başarısız olabilir$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Testleri gerçek bir PostgreSQL instance'ına yönlendirmenin aksine hızlıdır ve kuruluma ihtiyaç duymaz$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$What does AutoConfigureTestDatabase.Replace.NONE accomplish in this test setup?$$,
           $$@Testcontainers
@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class RealDatabaseTest {
    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16");

    @DynamicPropertySource
    static void props(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", postgres::getJdbcUrl);
    }
}$$, $$java$$,
           $$It stops @DataJpaTest from overriding the DataSource with its own embedded default, so the real, disposable PostgreSQL container started by @Container/@DynamicPropertySource is actually used instead.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'testing-spring-data-jpa'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It forces @DataJpaTest to always use an embedded database, ignoring @DynamicPropertySource$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$It has no actual effect -- @DataJpaTest never replaces the DataSource by default in the first place$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$It stops @DataJpaTest from overriding the DataSource with its own embedded default, letting the real Testcontainers Postgres be used$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$It disables Testcontainers entirely, falling back to the embedded database despite @Container being present$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu test kurulumunda AutoConfigureTestDatabase.Replace.NONE ne başarır?$$,
           $$@Testcontainers
@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class GercekVeritabaniTest {
    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16");

    @DynamicPropertySource
    static void props(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", postgres::getJdbcUrl);
    }
}$$, $$java$$,
           $$@DataJpaTest'in DataSource'u kendi embedded varsayılanıyla değiştirmesini durdurur, bu yüzden @Container/@DynamicPropertySource ile başlatılan gerçek, atılabilir PostgreSQL container'ı gerçekten kullanılır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'testing-spring-data-jpa'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Testcontainers'ı tamamen devre dışı bırakır, @Container mevcut olmasına rağmen embedded veritabanına geri döner$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$@DataJpaTest'in her zaman embedded bir veritabanı kullanmasını zorunlu kılar, @DynamicPropertySource'u yok sayar$$, FALSE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Gerçek bir etkisi yoktur -- @DataJpaTest zaten varsayılan olarak DataSource'u hiç değiştirmez$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$@DataJpaTest'in DataSource'u kendi embedded varsayılanıyla değiştirmesini durdurur, gerçek Testcontainers Postgres'inin kullanılmasını sağlar$$, TRUE, 3 FROM new_question_tr7;
