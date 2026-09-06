-- Promotion batch
-- Topic: transactions-and-concurrency-in-postgresql (language: en x7, tr x7)
-- Generated: 2026-09-06 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 14 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/transactions-and-concurrency-in-postgresql.md and content/tr/transactions-and-concurrency-in-postgresql.md -- NOT produced by n8n,
-- NOT judged by any external AI API, and NOT ingested via
-- /api/internal/questions/ingest.
--
-- Per-topic question count is FLEXIBLE (7 EN + 7 TR here, 5-7 range),
-- sized to this lesson's actual concept density rather than a fixed
-- target -- same convention established in the Docker/PostgreSQL
-- Foundations batches.
--
-- Strict 50/50 EN/TR split (7+7) organized as 7 CONCEPT PAIRS -- each EN
-- question has a TR counterpart testing the exact same concept, but
-- independently authored (different sample data/framing/options), not a
-- translation. Every question whose answer depends on shown SQL/code
-- output is typed CODE_OUTPUT (never SINGLE_CHOICE/MULTIPLE_CHOICE with a
-- code_snippet attached) -- fragments/quiz.html only renders code_snippet
-- for CODE_OUTPUT questions, per the bug found and fixed in
-- try-catch-finally/V573.
--
-- Each question's 4 options are written with the correct answer at a
-- deterministic, varied position, computed via
-- (pair_num + version + lang_shift) % 4 -- per the bug found and fixed at
-- question-promotion/V598 (always-A bias) and refined again in the Spring
-- Data JPA batch (parity-locked EN/TR offsets).
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
           $$After `BEGIN; UPDATE topic SET estimated_minutes = 999 WHERE slug = 'joins'; ROLLBACK;`, what is true of that UPDATE as far as any other session is concerned?$$,
           NULL, NULL,
           $$The lesson states ROLLBACK discards the transaction entirely, as if it never ran -- the UPDATE was real and readable within the transaction, then completely undone, with no partial trace left behind, as far as any other session is concerned.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'transactions-and-concurrency-in-postgresql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It never happened -- `ROLLBACK` discards it entirely, with no partial trace left behind$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$It is partially applied, with some but not all of its effects surviving$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It is applied immediately but flagged for cleanup by a later background process$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$It never even executed in the first place, since `BEGIN` prevents any statement from running until `COMMIT`$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$`BEGIN; UPDATE topic SET estimated_minutes = 999 WHERE slug = 'joins'; ROLLBACK;`'den sonra, başka herhangi bir oturum açısından bu UPDATE hakkında ne doğrudur?$$,
           NULL, NULL,
           $$Ders, ROLLBACK'in transaction'ı, hiç çalışmamış gibi, tamamen attığını belirtir -- UPDATE, transaction içinde gerçekti ve okunabilirdi, sonra tamamen geri alındı, başka herhangi bir oturum açısından hiçbir kısmi iz bırakmadan.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'transactions-and-concurrency-in-postgresql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hemen uygulanır ama daha sonraki bir arka plan süreci tarafından temizlenmek üzere işaretlenir$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Baştan hiç çalıştırılmaz bile, çünkü BEGIN, COMMIT'e kadar hiçbir ifadenin çalışmasını engeller$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Hiç olmadı -- `ROLLBACK` onu tamamen atar, hiçbir kısmi iz bırakmaz$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Kısmen uygulanır, bazı etkileri hayatta kalırken bazıları kalmaz$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Why did every single-statement `INSERT` in this project's real Flyway migrations never need an explicit `BEGIN`/`COMMIT`, according to this lesson?$$,
           NULL, NULL,
           $$The lesson explains PostgreSQL wraps any statement not inside an explicit transaction in an implicit one of its own, committing it immediately if it succeeds -- this is autocommit, and it's why every single-statement migration already ran as its own single-statement transaction.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'transactions-and-concurrency-in-postgresql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`INSERT` statements never require any transaction, under any relational database system$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$PostgreSQL wraps any statement outside an explicit transaction in an implicit one, committing it immediately if it succeeds$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Flyway migrations are described as being exempt from transactional behavior entirely$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Flyway itself performs the actual `COMMIT` outside of PostgreSQL, before the statement even reaches the database$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bu projenin gerçek Flyway migration'larındaki her tek ifadelik `INSERT`, neden hiçbir zaman açık bir `BEGIN`/`COMMIT`e ihtiyaç duymadı?$$,
           NULL, NULL,
           $$Ders, PostgreSQL'in açık bir transaction dışındaki herhangi bir ifadeyi kendi örtük transaction'ına sardığını, başarılı olursa hemen commit ettiğini açıklar -- bu autocommit'tir, ve her tek ifadelik migration'ın zaten kendi tek ifadelik transaction'ı olarak çalışmasının nedeni budur.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'transactions-and-concurrency-in-postgresql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Flyway migration'larının transactional davranıştan tamamen muaf olduğu tanımlanır$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Flyway'in kendisi, ifade veritabanına ulaşmadan önce gerçek COMMIT'i PostgreSQL'in dışında gerçekleştirir$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$`INSERT` ifadeleri, herhangi bir ilişkisel veritabanı sisteminde hiçbir zaman bir transaction gerektirmez$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$PostgreSQL, açık bir transaction dışındaki herhangi bir ifadeyi örtük bir transaction'a sarar, başarılı olursa hemen commit eder$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does MVCC's "PostgreSQL never overwrites a row in place when it's updated" actually mean, according to this lesson?$$,
           NULL, NULL,
           $$The lesson explains MVCC means PostgreSQL writes a new version of the row and marks the old version as superseded, keeping both around until nothing could possibly still need the old one -- tracked via hidden xmin/xmax system columns.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'transactions-and-concurrency-in-postgresql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$PostgreSQL locks the row until every currently open transaction finishes, and only then physically overwrites it$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$PostgreSQL records the update in a separate log file, leaving the actual table's row completely untouched$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$PostgreSQL writes a new version of the row and marks the old one as superseded, keeping both until nothing needs the old one$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$PostgreSQL immediately deletes the old row entirely and replaces it with a completely unrelated new row$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, MVCC'nin 'PostgreSQL bir satır güncellendiğinde onu asla yerinde üzerine yazmaz' ifadesi gerçekte ne anlama gelir?$$,
           NULL, NULL,
           $$Ders, MVCC'nin, PostgreSQL'in satırın yeni bir versiyonunu yazdığı ve eski versiyonu geçersiz kılınmış olarak işaretlediği, eski versiyona artık kimsenin ihtiyaç duyamayacağı ana kadar ikisini de sakladığı anlamına geldiğini açıklar -- gizli xmin/xmax sistem sütunları aracılığıyla takip edilir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'transactions-and-concurrency-in-postgresql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$PostgreSQL, satırın yeni bir versiyonunu yazar ve eskisini geçersiz kılınmış olarak işaretler, eskisine kimse ihtiyaç duymayana kadar ikisini de saklar$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$PostgreSQL eski satırı hemen tamamen siler ve onu tamamen ilgisiz yeni bir satırla değiştirir$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$PostgreSQL, şu anda açık olan her transaction bitene kadar satırı kilitler, ve ancak o zaman fiziksel olarak üzerine yazar$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$PostgreSQL güncellemeyi ayrı bir log dosyasına kaydeder, gerçek tablonun satırını tamamen dokunulmadan bırakır$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Session A begins a transaction and updates a row, but has not committed. Session B, concurrently, reads that same row. According to this lesson, does Session B block, and what does it see?$$,
           $$-- Session A
BEGIN;
UPDATE topic SET estimated_minutes = 999 WHERE slug = 'joins';
-- not committed yet

-- Session B, concurrently
SELECT estimated_minutes FROM topic WHERE slug = 'joins';$$, $$sql$$,
           $$The lesson explicitly states readers never block writers, and writers never block readers, in PostgreSQL -- Session B's SELECT doesn't block, and it sees the row version as it existed before Session A's uncommitted change, since a transaction only sees committed data (or its own uncommitted changes).$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'transactions-and-concurrency-in-postgresql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Session B blocks until Session A commits or rolls back, since MVCC still requires readers to wait for writers$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Session B does not block, but sees `999` immediately, even though Session A hasn't committed$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Session B's query fails outright with a "row is locked" error$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Session B does not block, and sees the original (pre-update) value, since it can't see Session A's uncommitted change$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Session A bir transaction başlatıyor ve bir satırı güncelliyor, ama henüz commit etmedi. Session B, eşzamanlı olarak, aynı satırı okuyor. Bu derse göre, Session B bloke olur mu, ve ne görür?$$,
           $$-- Session A
BEGIN;
UPDATE topic SET estimated_minutes = 500 WHERE slug = 'aggregation-and-group-by';
-- henuz commit edilmedi

-- Session B, eszamanli
SELECT estimated_minutes FROM topic WHERE slug = 'aggregation-and-group-by';$$, $$sql$$,
           $$Ders, PostgreSQL'de okuyucuların hiçbir zaman yazıcıları bloke etmediğini, yazıcıların da hiçbir zaman okuyucuları bloke etmediğini açıkça belirtir -- Session B'nin SELECT'i bloke olmaz, ve Session A'nın commit edilmemiş değişikliğinden önce var olan satır versiyonunu görür, çünkü bir transaction yalnızca commit edilmiş veriyi (ya da kendi commit edilmemiş değişikliklerini) görür.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'transactions-and-concurrency-in-postgresql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Session B'nin sorgusu doğrudan bir 'satır kilitli' hatasıyla başarısız olur$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Session B bloke olmaz, ve orijinal (güncelleme öncesi) değeri görür, çünkü Session A'nın commit edilmemiş değişikliğini göremez$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Session B, Session A commit edene ya da rollback yapana kadar bloke olur, çünkü MVCC hâlâ okuyucuların yazıcıları beklemesini gerektirir$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Session B bloke olmaz, ama Session A commit etmemiş olsa bile hemen `500`'ü görür$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$According to this lesson's "A Real FOR UPDATE Scenario," what real problem does wrapping a read-then-write in `SELECT ... FOR UPDATE` prevent?$$,
           NULL, NULL,
           $$The lesson explains without FOR UPDATE, two concurrent transactions could both read the same value, both compute the same "next" value independently, and both write it -- a lost update, since the second write silently overwrites the first without either transaction knowing the other happened.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'transactions-and-concurrency-in-postgresql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A lost update -- two concurrent transactions both computing the same "next" value, with the second write silently overwriting the first$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$A deadlock between the two concurrent transactions attempting the same operation$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$A SQL syntax error that occurs when two transactions run the identical `UPDATE` statement at the same time$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Permanent data loss from disk following an unexpected server crash$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu dersin 'A Real FOR UPDATE Scenario' bölümüne göre, bir oku-sonra-yaz işlemini `SELECT ... FOR UPDATE` içine sarmak hangi gerçek problemi önler?$$,
           NULL, NULL,
           $$Ders, FOR UPDATE olmadan, iki eşzamanlı transaction'ın ikisinin de aynı değeri okuyabileceğini, ikisinin de aynı 'sonraki' değeri bağımsız olarak hesaplayabileceğini, ve ikisinin de onu yazabileceğini açıklar -- bir lost update, çünkü ikinci yazma, hiçbiri diğerinin olduğunu bilmeden ilkinin üzerine sessizce yazar.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'transactions-and-concurrency-in-postgresql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İki transaction aynı anda birebir aynı `UPDATE` ifadesini çalıştırdığında oluşan bir SQL sözdizimi hatası$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Beklenmedik bir sunucu çökmesinin ardından diskten kalıcı veri kaybı$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Bir lost update (kayıp güncelleme) -- iki eşzamanlı transaction'ın aynı 'sonraki' değeri hesaplaması, ikinci yazmanın ilkinin üzerine sessizce yazması$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Aynı işlemi deneyen iki eşzamanlı transaction arasında bir deadlock$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this sequence producing a deadlock, what does PostgreSQL do once it detects the cyclic wait?$$,
           $$-- Session A
BEGIN;
UPDATE topic SET estimated_minutes = 1 WHERE slug = 'joins';

-- Session B, concurrently
BEGIN;
UPDATE topic SET estimated_minutes = 1 WHERE slug = 'aggregation-and-group-by';

-- Session A, next
UPDATE topic SET estimated_minutes = 2 WHERE slug = 'aggregation-and-group-by';
-- blocks, waiting for Session B's lock

-- Session B, next
UPDATE topic SET estimated_minutes = 2 WHERE slug = 'joins';
-- would also block, waiting for Session A's lock$$, $$sql$$,
           $$The lesson explains PostgreSQL actively detects this cycle rather than letting both sessions wait forever -- one transaction (the "victim," typically whichever would be cheaper to roll back) gets a real "deadlock detected" error and is automatically rolled back, freeing its locks so the other transaction can proceed.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'transactions-and-concurrency-in-postgresql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Both transactions are silently rolled back at the same time, with no error reported to either session$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$One transaction gets a "deadlock detected" error and is automatically rolled back, freeing its locks for the other$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Both transactions wait indefinitely until a database administrator manually intervenes$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$PostgreSQL automatically merges the two transactions' updates into a single, combined transaction$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir deadlock üreten bu sıralama göz önüne alındığında, PostgreSQL döngüsel beklemeyi tespit ettiğinde ne yapar?$$,
           $$-- Session A
BEGIN;
UPDATE topic SET estimated_minutes = 3 WHERE slug = 'select-and-filtering';

-- Session B, eszamanli
BEGIN;
UPDATE topic SET estimated_minutes = 3 WHERE slug = 'sorting-limiting-and-pagination';

-- Session A, sonraki
UPDATE topic SET estimated_minutes = 4 WHERE slug = 'sorting-limiting-and-pagination';
-- Session B'nin kilidini bekleyerek bloke olur

-- Session B, sonraki
UPDATE topic SET estimated_minutes = 4 WHERE slug = 'select-and-filtering';
-- Session A'nin kilidini bekleyerek o da bloke olurdu$$, $$sql$$,
           $$Ders, PostgreSQL'in her iki oturumun sonsuza kadar beklemesine izin vermek yerine bu döngüyü aktif olarak tespit ettiğini açıklar -- bir transaction (genellikle geri almanın daha ucuz olacağı 'kurban') gerçek bir 'deadlock detected' hatası alır ve kilitlerini serbest bırakarak diğer transaction'ın ilerleyebilmesi için otomatik olarak rollback yapılır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'transactions-and-concurrency-in-postgresql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Her iki transaction da bir veritabanı yöneticisi elle müdahale edene kadar süresiz olarak bekler$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$PostgreSQL, iki transaction'ın güncellemelerini otomatik olarak tek, birleşik bir transaction'a birleştirir$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Her iki transaction da, hiçbir oturuma hiçbir hata raporlanmadan aynı anda sessizce rollback yapılır$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir transaction 'deadlock detected' hatası alır ve kilitlerini diğeri için serbest bırakarak otomatik olarak rollback yapılır$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about transactions and concurrency, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (SELECT ... FOR UPDATE locks only the specific rows it returns, not the whole table -- MVCC means ordinary reads never lock anything for anyone; the fix for this lesson's deadlock example is a coding discipline -- always acquiring locks on multiple rows in the same, consistent order -- not a database configuration setting); the lesson explicitly says MVCC reduces how often locks are needed but genuine write-write conflicts on the same row still need row-level locking (MVCC doesn't eliminate the need for locks entirely), and it says a transaction a client simply disconnects from also gets rolled back automatically, not left in limbo.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'transactions-and-concurrency-in-postgresql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$MVCC means PostgreSQL never needs row-level locks for any purpose whatsoever$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$An uncommitted transaction whose client simply disconnects is left in an indeterminate state, neither committed nor rolled back$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$`SELECT ... FOR UPDATE` locks only the specific rows it returns, not the entire table$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$The fix for this lesson's deadlock example is a coding discipline -- always locking multiple rows in the same, consistent order -- not a database setting$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, transaction'lar ve concurrency hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (SELECT ... FOR UPDATE'in yalnızca döndürdüğü spesifik satırları kilitlemesi, tüm tabloyu değil -- MVCC'nin sıradan okumaların kimse için hiçbir şeyi asla kilitlememesi anlamına gelmesi; bu dersin deadlock örneğinin çözümünün bir veritabanı ayarı değil, birden fazla satırı her zaman aynı, tutarlı sırada kilitleme kodlama disiplini olması); ders, MVCC'nin kilitlere ne sıklıkla ihtiyaç duyulduğunu azalttığını ama aynı satır üzerindeki gerçek yazma-yazma çakışmalarının hâlâ row-level kilitlemeye ihtiyaç duyduğunu açıkça belirtir (MVCC kilit ihtiyacını tamamen ortadan kaldırmaz), ve client'ı basitçe bağlantısını kesen commit edilmemiş bir transaction'ın da otomatik olarak rollback yapıldığını, belirsizlikte bırakılmadığını belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'transactions-and-concurrency-in-postgresql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`SELECT ... FOR UPDATE`, yalnızca döndürdüğü spesifik satırları kilitler, tüm tabloyu değil$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Bu dersin deadlock örneğinin çözümü, bir veritabanı ayarı değil, birden fazla satırı her zaman aynı, tutarlı sırada kilitleme kodlama disiplinidir$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$MVCC, PostgreSQL'in herhangi bir amaç için asla row-level kilitlere ihtiyaç duymadığı anlamına gelir$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Client'ı basitçe bağlantısını kesen commit edilmemiş bir transaction, ne commit edilmiş ne rollback yapılmış belirsiz bir durumda bırakılır$$, FALSE, 3 FROM new_question_tr7;
