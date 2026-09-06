-- Promotion batch
-- Topic: connecting-to-postgresql (language: en x6, tr x6)
-- Generated: 2026-09-06 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 12 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/connecting-to-postgresql.md and content/tr/connecting-to-postgresql.md -- NOT produced by n8n,
-- NOT judged by any external AI API, and NOT ingested via
-- /api/internal/questions/ingest.
--
-- Per-topic question count is FLEXIBLE (6 EN + 6 TR here, 5-7 range),
-- sized to this lesson's actual concept density rather than a fixed
-- target -- same convention established in the Docker course batch.
--
-- Strict 50/50 EN/TR split (6+6) organized as 6 CONCEPT PAIRS -- each EN
-- question has a TR counterpart testing the exact same concept, but
-- independently authored (different framing/options/examples), not a
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
           $$Why does this lesson's `docker run` command map port 5433 on the host to port 5432 inside the container, instead of just using 5432 on both sides?$$,
           NULL, NULL,
           $$The lesson states 5432 is PostgreSQL's real, standard port inside the container, and 5433 is specifically this project's own choice on the host side, precisely so a locally installed PostgreSQL (which would normally already claim 5432 for itself) never conflicts with this container.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'connecting-to-postgresql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$So a locally installed PostgreSQL, which would normally already be using port 5432 on the host, never conflicts with this container$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Because PostgreSQL inside a container is technically incapable of using port 5432 at all$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Because port 5433 is the actual PostgreSQL standard, and 5432 is the non-standard one$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Because Docker itself requires every container's internal port to be renumbered when published$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu dersin `docker run` komutu, her iki tarafta da 5432 kullanmak yerine, host üzerindeki 5433 portunu container içindeki 5432 portuna neden eşler?$$,
           NULL, NULL,
           $$Ders, 5432'nin container içinde PostgreSQL'in gerçek, standart portu olduğunu, 5433'ün ise özellikle bu projenin host tarafındaki kendi seçimi olduğunu belirtir, tam olarak yerel olarak kurulu bir PostgreSQL'in (normalde zaten 5432'yi kendisi için talep ediyor olacaktır) bu container ile hiç çakışmaması için.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'connecting-to-postgresql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çünkü gerçek PostgreSQL standardı 5433'tür, 5432 ise standart olmayandır$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Çünkü Docker'ın kendisi, yayınlanan her container'ın iç portunun yeniden numaralandırılmasını gerektirir$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Normalde host üzerinde zaten 5432 portunu kullanıyor olacak yerel olarak kurulu bir PostgreSQL'in bu container ile hiç çakışmaması için$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Çünkü bir container içindeki PostgreSQL, 5432 portunu hiç kullanamaz$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What is `psql`, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states psql is PostgreSQL's own command-line client -- the tool every PostgreSQL installation ships with, independent of any GUI tool or any Java code; connecting with it lands at a direct, interactive connection to the server itself, with no Spring Boot, Hibernate, or JDBC driver in between.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'connecting-to-postgresql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A Spring Boot auto-configuration class responsible for creating the DataSource bean$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$PostgreSQL's own command-line client, shipped with every installation, connecting directly with no Spring Boot/Hibernate/JDBC in between$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$A Java library this project must add as a Maven dependency to connect to PostgreSQL$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$A GUI-only database administration tool that requires a separate, paid license$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `psql` nedir?$$,
           NULL, NULL,
           $$Ders, psql'in, her PostgreSQL kurulumunun birlikte geldiği, herhangi bir GUI aracından ya da Java kodundan bağımsız olan, PostgreSQL'in kendi komut satırı istemcisi olduğunu belirtir; onunla bağlanmak, arada hiçbir Spring Boot, Hibernate ya da JDBC sürücüsü olmadan, sunucunun kendisine doğrudan, interaktif bir bağlantıya iner.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'connecting-to-postgresql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bu projenin PostgreSQL'e bağlanmak için Maven bağımlılığı olarak eklemesi gereken bir Java kütüphanesi$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Ayrı, ücretli bir lisans gerektiren, yalnızca GUI olan bir veritabanı yönetim aracı$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$DataSource bean'ini oluşturmaktan sorumlu bir Spring Boot auto-configuration sınıfı$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Her kurulumla birlikte gelen, arada Spring Boot/Hibernate/JDBC olmadan doğrudan bağlanan, PostgreSQL'in kendi komut satırı istemcisi$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$After running `\c learning` in a psql session that was previously connected to the `postgres` database, how can you confirm the switch actually happened?$$,
           NULL, NULL,
           $$The lesson shows the prompt itself changes -- from `postgres=#` to `learning=#` -- confirming the current session is now connected to the `learning` database; `\c <database>` is what performs the switch.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'connecting-to-postgresql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`\c` always prints the full list of every table in the new database automatically as confirmation$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$The terminal's background color changes to indicate a successful database switch$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$The prompt itself changes, from `postgres=#` to `learning=#`, confirming the session is now connected to `learning`$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$There's no way to confirm it within the same session -- you must disconnect and reconnect entirely$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Daha önce `postgres` veritabanına bağlı olan bir psql oturumunda `\c learning` çalıştırdıktan sonra, geçişin gerçekten olduğunu nasıl doğrulayabilirsin?$$,
           NULL, NULL,
           $$Ders, komut isteminin kendisinin değiştiğini gösterir -- `postgres=#`'ten `learning=#`'e -- bu, o anki oturumun artık `learning` veritabanına bağlı olduğunu doğrular; geçişi gerçekleştiren şey `\c <veritabani>`'dır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'connecting-to-postgresql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Komut isteminin kendisi, `postgres=#`'ten `learning=#`'e değişir, bu da oturumun artık `learning`e bağlı olduğunu doğrular$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Aynı oturum içinde doğrulamanın bir yolu yoktur -- tamamen bağlantıyı kesip yeniden bağlanmak gerekir$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$`\c`, onay olarak yeni veritabanındaki her tablonun tam listesini her zaman otomatik olarak yazdırır$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Başarılı bir veritabanı geçişini belirtmek için terminalin arka plan rengi değişir$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this psql session, what does the `learning=#` prompt (instead of `postgres=#`) confirm about the `\dt` output that follows it?$$,
           $$postgres=# \c learning
You are now connected to database "learning" as user "postgres".

learning=# \dt
           List of relations
 Schema |   Name   | Type  |  Owner
--------+----------+-------+---------
 public | topic    | table | learning
 public | category | table | learning
 public | course   | table | learning$$, $$text$$,
           $$The lesson explains the changed prompt confirms the `\c learning` switch succeeded, so the `\dt` that follows lists tables in the `learning` database specifically -- this project's own real `topic`/`category`/`course` tables, created by its Flyway migrations, not tables from the default `postgres` database.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'connecting-to-postgresql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The `\dt` output is unrelated to which database is currently connected -- it always lists every table on the whole server$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$The prompt change means the connection has switched to using a different PostgreSQL server entirely, not just a different database$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$The prompt change indicates an error occurred and `\dt` will fail to run$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$The `\dt` output lists tables in the `learning` database specifically, not the default `postgres` database$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu psql oturumu göz önüne alındığında, `learning=#` komut isteminin (postgres=# yerine) bunu izleyen `\dt` çıktısı hakkında doğruladığı şey nedir?$$,
           $$postgres=# \c kurs_db
You are now connected to database "kurs_db" as user "postgres".

kurs_db=# \dt
           List of relations
 Schema |   Name   | Type  |  Owner
--------+----------+-------+---------
 public | topic    | table | kurs_db
 public | category | table | kurs_db$$, $$text$$,
           $$Ders, değişen komut isteminin `\c kurs_db` geçişinin başarılı olduğunu doğruladığını, bu yüzden onu izleyen `\dt`'nin özellikle `kurs_db` veritabanındaki tabloları listelediğini açıklar -- varsayılan `postgres` veritabanındaki tabloları değil.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'connecting-to-postgresql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Komut istemi değişikliği bir hata oluştuğunu ve `\dt`'nin çalışmayı başaramayacağını gösterir$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$`\dt` çıktısı özellikle `kurs_db` veritabanındaki tabloları listeler, varsayılan `postgres` veritabanını değil$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$`\dt` çıktısı, o anda hangi veritabanına bağlı olunduğuyla ilgisizdir -- her zaman sunucudaki her tabloyu listeler$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Komut istemi değişikliği, bağlantının yalnızca farklı bir veritabanına değil, tamamen farklı bir PostgreSQL sunucusuna geçtiği anlamına gelir$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$In the JDBC URL `jdbc:postgresql://localhost:5433/learning`, what does `learning` correspond to in `psql`'s own flags/commands?$$,
           NULL, NULL,
           $$The lesson breaks the JDBC URL down piece by piece: `learning` is the database name, identical in meaning to psql's `\c learning` (or `-d learning` on the command line) -- the host/port (`localhost:5433`) corresponds to psql's `-h`/`-p` flags.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'connecting-to-postgresql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The database name -- identical in meaning to psql's `\c learning` or `-d learning`$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$The username to connect as -- identical in meaning to psql's `-U` flag$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$The name of the JDBC driver being used to connect$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$The password used to authenticate the connection$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$`jdbc:postgresql://localhost:5433/kurs` JDBC URL'sinde, `kurs`, `psql`'in kendi bayraklarında/komutlarında neye karşılık gelir?$$,
           NULL, NULL,
           $$Ders, JDBC URL'sini parça parça ayrıştırır: `kurs`, veritabanı adıdır, anlam olarak psql'in `\c kurs` (ya da komut satırında `-d kurs`) ile birebir aynıdır -- host/port (`localhost:5433`) ise psql'in `-h`/`-p` bayraklarına karşılık gelir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'connecting-to-postgresql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bağlanmak için kullanılan JDBC sürücüsünün adı$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Bağlantıyı kimlik doğrulamak için kullanılan şifre$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Veritabanı adı -- anlam olarak psql'in `\c kurs` ya da `-d kurs`'u ile birebir aynı$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Bağlanılacak kullanıcı adı -- anlam olarak psql'in `-U` bayrağı ile birebir aynı$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about connecting to PostgreSQL, as covered in this lesson's "Common Misconceptions," are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (Spring Boot doesn't need special setup -- spring.datasource.url/username/password are the exact same three things psql's -h/-p/-U/-d need, just carried through a JDBC driver instead of a terminal; psql and a GUI database tool both ultimately connect using the same host/port/database/credentials and speak the same PostgreSQL wire protocol); the lesson explicitly says 5433 is NOT PostgreSQL's real port (5432 is), and connecting to the exact same host/port/database/credentials with psql directly is recommended precisely to isolate whether a connection problem is in PostgreSQL itself or in the Spring/JDBC layer.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'connecting-to-postgresql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Trying to connect with `psql` directly is discouraged as a way to isolate whether a JDBC connection failure is a database problem or a Spring/JDBC-layer problem$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$`spring.datasource.url`/`username`/`password` are the exact same three things psql's `-h`/`-p`/`-U`/`-d` need, just carried through a JDBC driver instead of a terminal$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$`psql` and a GUI database tool both ultimately connect using the same host/port/database/credentials and speak the same PostgreSQL wire protocol$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Port 5433 is described in this lesson as PostgreSQL's actual, real standard port$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu dersin 'Common Misconceptions' bölümünde ele alındığı şekliyle, PostgreSQL'e bağlanma hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (Spring Boot'un özel bir kuruluma ihtiyacı olmaması -- spring.datasource.url/username/password'ün, bir terminal yerine bir JDBC sürücüsü üzerinden taşınan, psql'in -h/-p/-U/-d'sinin ihtiyaç duyduğu tam olarak aynı üç şey olması; psql ile bir GUI veritabanı aracının ikisinin de sonunda aynı host/port/veritabanı/kimlik bilgilerini kullanarak bağlanması ve aynı PostgreSQL wire protokolünü konuşması); ders, 5433'ün PostgreSQL'in gerçek portu OLMADIĞINI (5432'nin olduğunu) açıkça belirtir, ve aynı host/port/veritabanı/kimlik bilgileriyle doğrudan psql ile bağlanmayı denemenin, bir bağlantı sorununun PostgreSQL'in kendisinde mi yoksa Spring/JDBC katmanında mı olduğunu izole etmek için tam olarak önerildiğini belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'connecting-to-postgresql'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`psql` ile bir GUI veritabanı aracının ikisi de sonunda aynı host/port/veritabanı/kimlik bilgilerini kullanarak bağlanır ve aynı PostgreSQL wire protokolünü konuşur$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$5433 portu bu derste PostgreSQL'in gerçek, standart portu olarak tanımlanır$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Doğrudan `psql` ile bağlanmayı denemek, bir JDBC bağlantı hatasının veritabanı sorunu mu yoksa Spring/JDBC katmanı sorunu mu olduğunu izole etmenin bir yolu olarak caydırılır$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$`spring.datasource.url`/`username`/`password`, bir terminal yerine bir JDBC sürücüsü üzerinden taşınan, psql'in `-h`/`-p`/`-U`/`-d`'sinin ihtiyaç duyduğu tam olarak aynı üç şeydir$$, TRUE, 3 FROM new_question_tr6;
