-- Promotion batch
-- Topic: jpa-auditing (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V715-V730 (Advanced Spring) and V679-V714
-- (Spring MVC), these 14 questions were NOT produced by the n8n generation
-- pipeline, NOT judged by the AI Judge, and NOT ingested via
-- /api/internal/questions/ingest -- per explicit user request, they were
-- hand-authored and independently self-reviewed directly inside a Claude Code
-- session, grounded strictly in content/en/jpa-auditing.md and
-- content/tr/jpa-auditing.md.
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
           $$What problem does JPA auditing (@CreatedDate/@LastModifiedDate) solve?$$,
           NULL, NULL,
           $$It replaces manually written LocalDateTime.now() calls repeated in every service method that creates or updates an audited entity, which is easy to forget in even one place.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'jpa-auditing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It replaces manually written LocalDateTime.now() calls repeated in every place that creates or updates an entity$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$It automatically validates every entity's fields before saving$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It replaces the need for a primary key on audited entities$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$It automatically translates entity field names into a different language$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$JPA auditing (@CreatedDate/@LastModifiedDate) hangi sorunu çözer?$$,
           NULL, NULL,
           $$Bir entity oluşturan ya da güncelleyen her yerde tekrarlanan, elle yazılmış LocalDateTime.now() çağrılarının yerini alır -- bunu tek bir yerde bile unutmak kolaydır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'jpa-auditing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Entity alan adlarını otomatik olarak başka bir dile çevirir$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir entity oluşturan ya da güncelleyen her yerde tekrarlanan, elle yazılmış LocalDateTime.now() çağrılarının yerini alır$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Kaydetmeden önce her entity'nin alanlarını otomatik olarak doğrular$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Denetlenen entity'lerde primary key ihtiyacının yerini alır$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What is the timing difference between @CreatedDate and @LastModifiedDate?$$,
           NULL, NULL,
           $$@CreatedDate is populated exactly once, at first persist, and never touched again; @LastModifiedDate is populated on that same insert and re-populated on every subsequent update.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'jpa-auditing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$There is no timing difference -- both fire on every save with an identical value$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$@CreatedDate is populated exactly once at first persist and never touched again; @LastModifiedDate updates on every subsequent update too$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Both fields are populated exactly once, at first persist, and never updated afterward$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$@LastModifiedDate is populated once at first persist; @CreatedDate updates on every subsequent save$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$@CreatedDate ile @LastModifiedDate arasındaki zamanlama farkı nedir?$$,
           NULL, NULL,
           $$@CreatedDate, ilk persist'te tam olarak bir kez doldurulur ve bir daha hiç dokunulmaz; @LastModifiedDate aynı insert'te doldurulur ve sonraki her güncellemede yeniden doldurulur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'jpa-auditing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$@LastModifiedDate ilk persist'te bir kez doldurulur; @CreatedDate sonraki her save'de güncellenir$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Hiçbir zamanlama farkı yoktur -- ikisi de her save'de aynı değerle tetiklenir$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$@CreatedDate ilk persist'te tam olarak bir kez doldurulur ve bir daha dokunulmaz; @LastModifiedDate sonraki her güncellemede de güncellenir$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Her iki alan da yalnızca ilk persist'te tam olarak bir kez doldurulur ve sonrasında hiç güncellenmez$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$An entity has @CreatedDate on a field, and @EntityListeners(AuditingEntityListener.class) on the class. No @Configuration class anywhere has @EnableJpaAuditing. What happens when a new instance is saved?$$,
           $$@Entity
@EntityListeners(AuditingEntityListener.class)
class Question {
    @CreatedDate
    private LocalDateTime createdAt;
}
// No @EnableJpaAuditing anywhere in the application$$, $$java$$,
           $$Missing @EnableJpaAuditing means the field is simply never populated, silently left null -- with no error pointing at what's missing.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'jpa-auditing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$createdAt is silently left null, with no error indicating what's missing$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$createdAt is populated with the Unix epoch (1970-01-01) as a fallback default$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$createdAt is populated correctly, since @EntityListeners alone is enough$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$The application fails to start with a clear configuration error naming the missing annotation$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir entity'nin bir alanında @CreatedDate, sınıfında da @EntityListeners(AuditingEntityListener.class) var. Hiçbir @Configuration sınıfında @EnableJpaAuditing yok. Yeni bir instance kaydedildiğinde ne olur?$$,
           $$@Entity
@EntityListeners(AuditingEntityListener.class)
class Soru {
    @CreatedDate
    private LocalDateTime olusturulmaTarihi;
}
// Uygulamada hiçbir yerde @EnableJpaAuditing yok$$, $$java$$,
           $$@EnableJpaAuditing'in eksik olması, alanın hiç doldurulmadığı, hiçbir hata göstermeden sessizce null bırakıldığı anlamına gelir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'jpa-auditing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$olusturulmaTarihi doğru şekilde doldurulur, çünkü tek başına @EntityListeners yeterlidir$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Uygulama, eksik annotation'ı belirten net bir yapılandırma hatasıyla başlayamaz$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$olusturulmaTarihi, varsayılan geri dönüş olarak Unix epoch (1970-01-01) ile doldurulur$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$olusturulmaTarihi, ne eksik olduğunu belirten hiçbir hata olmadan sessizce null bırakılır$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$How do @CreatedBy and @LastModifiedBy relate to @CreatedDate and @LastModifiedDate?$$,
           NULL, NULL,
           $$They work exactly like their date counterparts -- same listener, same lifecycle timing -- but capture the identity of whoever made the change instead of a timestamp.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'jpa-auditing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$They require a completely separate listener from AuditingEntityListener$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$They only work on entities that also have a manually-set reviewedBy field$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$They replace @CreatedDate/@LastModifiedDate entirely, rather than working alongside them$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$They work exactly like their date counterparts, using the same listener and timing, but capture WHO made the change instead of WHEN$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$@CreatedBy ve @LastModifiedBy, @CreatedDate ve @LastModifiedDate ile nasıl ilişkilidir?$$,
           NULL, NULL,
           $$Tarih karşılıkları gibi tam olarak çalışırlar -- aynı listener, aynı lifecycle zamanlaması -- ama bir zaman damgası yerine değişikliği kimin yaptığının kimliğini yakalarlar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'jpa-auditing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Tarih karşılıkları gibi aynı listener ve zamanlamayı kullanarak tam olarak çalışırlar, ama NE ZAMAN yerine değişikliği KİMİN yaptığını yakalarlar$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$AuditingEntityListener'dan tamamen ayrı bir listener gerektirirler$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Yalnızca elle ayarlanmış bir reviewedBy alanına da sahip entity'lerde çalışırlar$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$@CreatedDate/@LastModifiedDate'in yanında çalışmak yerine onların tamamen yerini alırlar$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Does Spring Data JPA have a built-in notion of "the current user" that @CreatedBy/@LastModifiedBy read from automatically?$$,
           NULL, NULL,
           $$No -- AuditorAware<T> is the interface an application must implement to supply that answer; Spring Data JPA has no built-in notion of a current user.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'jpa-auditing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yes -- it reads directly from Spring Security's SecurityContextHolder with zero configuration$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$No -- AuditorAware<T> is an interface the application must implement to supply that answer$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Yes -- it always defaults to the string "system" unless explicitly overridden$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$No -- @CreatedBy/@LastModifiedBy simply don't work unless Spring Security is on the classpath$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Spring Data JPA'nın, @CreatedBy/@LastModifiedBy'ın otomatik olarak okuduğu, yerleşik bir "mevcut kullanıcı" kavramı var mıdır?$$,
           NULL, NULL,
           $$Hayır -- AuditorAware<T>, uygulamanın bu cevabı sağlamak için implemente etmesi gereken interface'tir; Spring Data JPA'nın yerleşik bir mevcut kullanıcı kavramı yoktur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'jpa-auditing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hayır -- Spring Security classpath'te olmadıkça @CreatedBy/@LastModifiedBy basitçe çalışmaz$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Hayır -- AuditorAware<T>, uygulamanın bu cevabı sağlamak için implemente etmesi gereken bir interface'tir$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Evet -- hiçbir yapılandırma olmadan doğrudan Spring Security'nin SecurityContextHolder'ından okur$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Evet -- açıkça geçersiz kılınmadıkça her zaman "system" string'ine varsayılan olarak döner$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe @MappedSuperclass? (Select all that apply)$$,
           NULL, NULL,
           $$@MappedSuperclass isn't itself an @Entity and has no table of its own -- its fields get copied into every entity extending it, avoiding repeating audit annotations on each one individually.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'jpa-auditing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Only one entity in an application is allowed to extend a given @MappedSuperclass$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$It isn't itself an @Entity and has no table of its own$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Its fields get copied into every entity that extends it, avoiding repeating them on each one$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$It requires its own @Table annotation, just like a regular entity$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri @MappedSuperclass'ı doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$@MappedSuperclass'ın kendisi bir @Entity değildir ve kendi tablosu yoktur -- alanları onu extend eden her entity'ye kopyalanır, denetim annotation'larını her birinde ayrı ayrı tekrarlamaktan kaçınır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'jpa-auditing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Sıradan bir entity gibi kendi @Table annotation'ına ihtiyaç duyar$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir uygulamada yalnızca tek bir entity'nin belirli bir @MappedSuperclass'ı extend etmesine izin verilir$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Alanları, onu extend eden her entity'ye kopyalanır, her birinde tekrarlanmasını önler$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Kendisi bir @Entity değildir ve kendi tablosu yoktur$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$An entity is loaded, one unrelated field is reassigned to the exact same value it already had, and the transaction commits (triggering a save). Does @LastModifiedDate update?$$,
           $$Question q = repository.findById(1L).get();
q.setTitle(q.getTitle()); // reassigned to the SAME value
// transaction commits, entity is saved$$, $$java$$,
           $$Yes -- @LastModifiedDate updates on every save that reaches the database, the same way dirty checking writes any tracked change; it isn't selectively smart about which saves "really" changed something meaningful.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'jpa-auditing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It throws an exception, since reassigning a field to its own value is not a valid operation$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$It depends on whether the field has its own @Column(unique = true) constraint$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Yes -- @LastModifiedDate updates on every save that reaches the database, regardless of whether the value genuinely changed$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$No -- Spring Data JPA detects the value is unchanged and skips updating @LastModifiedDate$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bir entity yükleniyor, ilgisiz bir alan zaten sahip olduğu değerin AYNISINA yeniden atanıyor, ve transaction commit oluyor (bir save tetikleniyor). @LastModifiedDate güncellenir mi?$$,
           $$Soru s = repository.findById(1L).get();
s.setBaslik(s.getBaslik()); // AYNI degere yeniden atandi
// transaction commit oluyor, entity kaydediliyor$$, $$java$$,
           $$Evet -- @LastModifiedDate, veritabanına ulaşan her save'de güncellenir, tıpkı dirty checking'in takip edilen her değişikliği yazması gibi; hangi save'lerin "gerçekten" anlamlı bir şey değiştirdiği konusunda seçici bir zekaya sahip değildir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'jpa-auditing'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hayır -- Spring Data JPA değerin değişmediğini tespit eder ve @LastModifiedDate'i güncellemeyi atlar$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir alanı kendi değerine yeniden atamak geçerli bir işlem olmadığı için bir istisna fırlatır$$, FALSE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Alanın kendi @Column(unique = true) kısıtlamasına sahip olup olmadığına bağlıdır$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Evet -- @LastModifiedDate, değerin gerçekten değişip değişmediğinden bağımsız olarak, veritabanına ulaşan her save'de güncellenir$$, TRUE, 3 FROM new_question_tr7;
