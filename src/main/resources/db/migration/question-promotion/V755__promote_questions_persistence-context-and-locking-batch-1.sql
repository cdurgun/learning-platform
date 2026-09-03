-- Promotion batch
-- Topic: persistence-context-and-locking (language: en x7, tr x7)
-- Generated: 2026-09-03 (this migration file's authoring date)
--
-- Like question-promotion/V715-V730 (Advanced Spring) and V679-V714
-- (Spring MVC), these 14 questions were NOT produced by the n8n generation
-- pipeline, NOT judged by the AI Judge, and NOT ingested via
-- /api/internal/questions/ingest -- per explicit user request, they were
-- hand-authored and independently self-reviewed directly inside a Claude Code
-- session, grounded strictly in content/en/persistence-context-and-locking.md and
-- content/tr/persistence-context-and-locking.md.
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
           $$An entity's transaction has just ended, so the persistence context no longer tracks it, but its field changes had already been made while it was tracked. What state is it in now?$$,
           NULL, NULL,
           $$DETACHED -- the persistence context no longer tracks it, so further field changes are not written back automatically anymore.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'persistence-context-and-locking'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$TRANSIENT$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$MANAGED$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$DETACHED$$, TRUE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$REMOVED$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir entity'nin transaction'ı henüz sona erdi, bu yüzden persistence context artık onu takip etmiyor, ama alan değişiklikleri hâlâ takip edilirken zaten yapılmıştı. Şu an hangi durumdadır?$$,
           NULL, NULL,
           $$DETACHED -- persistence context artık onu takip etmiyor, bu yüzden sonraki alan değişiklikleri artık otomatik olarak geri yazılmıyor.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'persistence-context-and-locking'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$REMOVED$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$DETACHED$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$TRANSIENT$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$MANAGED$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Within a single transaction, both of these calls execute. How many database queries actually run?$$,
           $$Topic first = repository.findById(5L).get();
Topic second = repository.findById(5L).get();

System.out.println(first == second);$$, $$java$$,
           $$Only one query -- the first-level cache recognizes entity 5 is already being tracked and hands back the exact same instance for the second call, so first == second prints true.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'persistence-context-and-locking'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Zero queries -- Spring Data JPA never actually needs to hit the database for a findById call$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Two queries, and first == second prints false, since they're two separate object instances$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Two queries, but first == second still prints true, since Java always caches equal objects$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$One query -- the second call is answered entirely from the first-level cache, and first == second prints true$$, TRUE, 3 FROM new_question_en2;

-- Pair 2 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Tek bir transaction içinde, bu iki çağrı da çalıştırılıyor. Gerçekte kaç veritabanı sorgusu çalışır?$$,
           $$Konu birinci = repository.findById(5L).get();
Konu ikinci = repository.findById(5L).get();

System.out.println(birinci == ikinci);$$, $$java$$,
           $$Yalnızca bir sorgu -- first-level cache, 5 numaralı entity'nin zaten takip edildiğini tanır ve ikinci çağrı için tam olarak aynı instance'ı geri verir, bu yüzden birinci == ikinci true yazdırır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'persistence-context-and-locking'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İki sorgu, ama birinci == ikinci yine de true yazdırır, çünkü Java her zaman eşit nesneleri önbelleğe alır$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Sıfır sorgu -- Spring Data JPA bir findById çağrısı için hiçbir zaman gerçekten veritabanına gitmez$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Bir sorgu -- ikinci çağrı tamamen first-level cache'den yanıtlanır, ve birinci == ikinci true yazdırır$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$İki sorgu, ve birinci == ikinci false yazdırır, çünkü ikisi iki ayrı nesne instance'ıdır$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A detached entity, one that already has a real id but isn't currently tracked, needs to be re-attached and updated. Which operation is correct?$$,
           NULL, NULL,
           $$merge() -- it copies the object's field values onto a managed entity and returns THAT managed entity; persist() risks a duplicate-key error since it's meant for entities that never existed in the database.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'persistence-context-and-locking'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$remove(), followed immediately by a fresh persist() with the same field values$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$detach(), which automatically re-attaches the entity on the next query$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$persist(), since it's the general-purpose way to bring any entity under management$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$merge() -- it copies the object's field values onto a managed entity and returns that managed entity$$, TRUE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Zaten gerçek bir id'ye sahip ama şu anda takip edilmeyen, detached bir entity'nin yeniden bağlanıp güncellenmesi gerekiyor. Hangi işlem doğrudur?$$,
           NULL, NULL,
           $$merge() -- nesnenin alan değerlerini managed bir entity'ye kopyalar ve O managed entity'yi döndürür; persist(), veritabanında hiç var olmamış entity'ler için olduğundan duplicate-key hatası riski taşır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'persistence-context-and-locking'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$persist(), çünkü herhangi bir entity'yi yönetim altına almanın genel amaçlı yoludur$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Aynı alan değerleriyle hemen ardından yeni bir persist() izleyen remove()$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Entity'yi bir sonraki sorguda otomatik olarak yeniden bağlayan detach()$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$merge() -- nesnenin alan değerlerini managed bir entity'ye kopyalar ve o managed entity'yi döndürür$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A field's value is changed on a managed entity, and then a JPQL query filtering on that same field runs, without flush() ever being called explicitly. What happens?$$,
           NULL, NULL,
           $$Hibernate auto-flushes before running a query whose result could be affected by pending changes, so the query's result reflects the change.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'persistence-context-and-locking'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The query's result ignores the change entirely, since it was never explicitly flushed$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$The application throws an exception, since a pending change exists when the query runs$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$The change is silently discarded, and the field reverts to its previous value$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$The query's result reflects the change, since Hibernate auto-flushes before a query that could be affected by pending changes$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Managed bir entity'de bir alanın değeri değiştiriliyor, sonra aynı alanı filtreleyen bir JPQL sorgusu, flush() hiç açıkça çağrılmadan çalıştırılıyor. Ne olur?$$,
           NULL, NULL,
           $$Hibernate, bekleyen değişikliklerden etkilenebilecek bir sorgu çalıştırmadan önce otomatik flush yapar, bu yüzden sorgunun sonucu değişikliği yansıtır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'persistence-context-and-locking'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hibernate, bekleyen değişikliklerden etkilenebilecek bir sorgu çalıştırmadan önce otomatik flush yaptığı için, sorgunun sonucu değişikliği yansıtır$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Sorgunun sonucu değişikliği tamamen yok sayar, çünkü hiç açıkça flush edilmedi$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Sorgu çalıştığında bekleyen bir değişiklik olduğu için uygulama bir istisna fırlatır$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Değişiklik sessizce atılır ve alan önceki değerine döner$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does adding @Version to an entity's field actually do?$$,
           NULL, NULL,
           $$Hibernate manages it entirely on its own -- every UPDATE increments it, and every UPDATE's WHERE clause checks it still matches the value the entity was loaded with.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'persistence-context-and-locking'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It holds a real database lock on the row from the moment it's read until the transaction ends$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Hibernate increments it on every UPDATE, and every UPDATE's WHERE clause checks it still matches the loaded value$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$It requires the application to manually increment it before every save call$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$It prevents more than one transaction from reading the same row at the same time$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir entity'nin alanına @Version eklemek gerçekte ne yapar?$$,
           NULL, NULL,
           $$Hibernate bunu tamamen kendi başına yönetir -- her UPDATE onu artırır ve her UPDATE'in WHERE koşulu, entity'nin yüklendiği değerle hâlâ eşleştiğini kontrol eder.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'persistence-context-and-locking'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Aynı satırın aynı anda birden fazla transaction tarafından okunmasını engeller$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Hibernate her UPDATE'te onu artırır ve her UPDATE'in WHERE koşulu, yüklenen değerle hâlâ eşleştiğini kontrol eder$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Satır okunduğu andan transaction bitene kadar üzerinde gerçek bir veritabanı kilidi tutar$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Uygulamanın her save çağrısından önce onu elle artırmasını gerektirir$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, ADVANCED)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$loadedByUserA and loadedByUserB both load the same @Version-protected row at version = 3. User A saves first and succeeds, moving the row to version = 4. User B then tries to save, still believing the version is 3. What happens?$$,
           $$// Both loaded at version = 3
userA.save(loadedByUserA); // succeeds, row is now version = 4
userB.save(loadedByUserB); // User B's WHERE clause still checks version = 3$$, $$java$$,
           $$User B's UPDATE ... WHERE version = 3 now matches zero rows -- Spring Data JPA surfaces this as an OptimisticLockingFailureException rather than silently doing nothing or overwriting User A's change.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'persistence-context-and-locking'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Both saves are automatically merged field-by-field into one final row$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$User B's save silently overwrites User A's change, with the row ending at User B's values$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$User B's save throws an OptimisticLockingFailureException, since its WHERE ... AND version = 3 now matches nothing$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$User B's save succeeds normally, since @Version only checks on the very first save of a row$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, ADVANCED)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$kullaniciAYukledi ve kullaniciBYukledi, @Version korumalı aynı satırı version = 3'te yüklüyor. Kullanıcı A önce kaydediyor ve başarılı oluyor, satır version = 4'e geçiyor. Kullanıcı B sonra, hâlâ version'ın 3 olduğuna inanarak kaydetmeye çalışıyor. Ne olur?$$,
           $$// İkisi de version = 3'te yüklendi
kullaniciA.kaydet(kullaniciAYukledi); // basarili, satir simdi version = 4
kullaniciB.kaydet(kullaniciBYukledi); // Kullanici B'nin WHERE kosulu hala version = 3'u kontrol ediyor$$, $$java$$,
           $$Kullanıcı B'nin UPDATE ... WHERE version = 3'ü artık sıfır satırla eşleşir -- Spring Data JPA bunu, sessizce hiçbir şey yapmak ya da Kullanıcı A'nın değişikliğinin üzerine yazmak yerine bir OptimisticLockingFailureException olarak yüzeye çıkarır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'persistence-context-and-locking'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Kullanıcı B'nin kaydı normal şekilde başarılı olur, çünkü @Version yalnızca bir satırın ilk kaydında kontrol yapar$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Her iki kayıt da otomatik olarak alan alan tek bir son satırda birleştirilir$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Kullanıcı B'nin kaydı bir OptimisticLockingFailureException fırlatır, çünkü WHERE ... AND version = 3'ü artık hiçbir şeyle eşleşmez$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Kullanıcı B'nin kaydı, Kullanıcı A'nın değişikliğinin sessizce üzerine yazar, satır Kullanıcı B'nin değerleriyle sonuçlanır$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following correctly describe @Lock(LockModeType.PESSIMISTIC_WRITE)? (Select all that apply)$$,
           NULL, NULL,
           $$It adds a real database-level lock at read time (PostgreSQL's SELECT ... FOR UPDATE), making other transactions wait -- reach for it for genuinely high-contention operations, not as a default in place of optimistic locking.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'persistence-context-and-locking'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It should be the default locking strategy in place of @Version for every entity$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$It detects a collision after it happens, the same way @Version does$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$It adds a real database-level lock at read time, using PostgreSQL's SELECT ... FOR UPDATE$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Any other transaction trying to acquire the same lock on the same row simply waits until this one commits or rolls back$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri @Lock(LockModeType.PESSIMISTIC_WRITE)'ı doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Okuma anında, PostgreSQL'in SELECT ... FOR UPDATE'ini kullanarak gerçek bir veritabanı seviyesi kilit ekler, diğer transaction'ları bekletir -- gerçekten yüksek çekişmeli işlemler için tercih edilmeli, optimistic locking'in yerine varsayılan olarak değil.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'persistence-context-and-locking'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Okuma anında, PostgreSQL'in SELECT ... FOR UPDATE'ini kullanarak gerçek bir veritabanı seviyesi kilit ekler$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Her entity için @Version'ın yerine varsayılan kilitleme stratejisi olmalıdır$$, FALSE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$@Version'ın yaptığı gibi, bir çakışmayı gerçekleştikten sonra tespit eder$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Aynı satırda aynı kilidi almaya çalışan başka herhangi bir transaction, bu işlem commit ya da rollback olana kadar bekler$$, TRUE, 3 FROM new_question_tr7;
