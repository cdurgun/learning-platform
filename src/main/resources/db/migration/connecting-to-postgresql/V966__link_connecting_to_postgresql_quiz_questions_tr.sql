-- Promotion-style migration linking TR connecting-to-postgresql quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 6 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.


-- Question 1/6 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'connecting-to-postgresql')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu dersin `docker run` komutu, her iki tarafta da 5432 kullanmak yerine, host üzerindeki 5433 portunu container içindeki 5432 portuna neden eşler?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu dersin `docker run` komutu, her iki tarafta da 5432 kullanmak yerine, host üzerindeki 5433 portunu container içindeki 5432 portuna neden eşler?$$,
           NULL, NULL,
           $$Ders, 5432'nin container içinde PostgreSQL'in gerçek, standart portu olduğunu, 5433'ün ise özellikle bu projenin host tarafındaki kendi seçimi olduğunu belirtir, tam olarak yerel olarak kurulu bir PostgreSQL'in (normalde zaten 5432'yi kendisi için talep ediyor olacaktır) bu container ile hiç çakışmaması için.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'connecting-to-postgresql'
      AND NOT EXISTS (SELECT 1 FROM existing_q1)
    RETURNING id
),
target_q1 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q1
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q1
),
option_ins_q1 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q1.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q1
             CROSS JOIN (VALUES
    ($$Çünkü gerçek PostgreSQL standardı 5433'tür, 5432 ise standart olmayandır$$, FALSE, 0),
    ($$Çünkü Docker'ın kendisi, yayınlanan her container'ın iç portunun yeniden numaralandırılmasını gerektirir$$, FALSE, 1),
    ($$Normalde host üzerinde zaten 5432 portunu kullanıyor olacak yerel olarak kurulu bir PostgreSQL'in bu container ile hiç çakışmaması için$$, TRUE, 2),
    ($$Çünkü bir container içindeki PostgreSQL, 5432 portunu hiç kullanamaz$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'connecting-to-postgresql'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'connecting-to-postgresql')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, `psql` nedir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `psql` nedir?$$,
           NULL, NULL,
           $$Ders, psql'in, her PostgreSQL kurulumunun birlikte geldiği, herhangi bir GUI aracından ya da Java kodundan bağımsız olan, PostgreSQL'in kendi komut satırı istemcisi olduğunu belirtir; onunla bağlanmak, arada hiçbir Spring Boot, Hibernate ya da JDBC sürücüsü olmadan, sunucunun kendisine doğrudan, interaktif bir bağlantıya iner.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'connecting-to-postgresql'
      AND NOT EXISTS (SELECT 1 FROM existing_q2)
    RETURNING id
),
target_q2 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q2
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q2
),
option_ins_q2 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q2.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q2
             CROSS JOIN (VALUES
    ($$Bu projenin PostgreSQL'e bağlanmak için Maven bağımlılığı olarak eklemesi gereken bir Java kütüphanesi$$, FALSE, 0),
    ($$Ayrı, ücretli bir lisans gerektiren, yalnızca GUI olan bir veritabanı yönetim aracı$$, FALSE, 1),
    ($$DataSource bean'ini oluşturmaktan sorumlu bir Spring Boot auto-configuration sınıfı$$, FALSE, 2),
    ($$Her kurulumla birlikte gelen, arada Spring Boot/Hibernate/JDBC olmadan doğrudan bağlanan, PostgreSQL'in kendi komut satırı istemcisi$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'connecting-to-postgresql'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'connecting-to-postgresql')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Daha önce `postgres` veritabanına bağlı olan bir psql oturumunda `\c learning` çalıştırdıktan sonra, geçişin gerçekten olduğunu nasıl doğrulayabilirsin?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Daha önce `postgres` veritabanına bağlı olan bir psql oturumunda `\c learning` çalıştırdıktan sonra, geçişin gerçekten olduğunu nasıl doğrulayabilirsin?$$,
           NULL, NULL,
           $$Ders, komut isteminin kendisinin değiştiğini gösterir -- `postgres=#`'ten `learning=#`'e -- bu, o anki oturumun artık `learning` veritabanına bağlı olduğunu doğrular; geçişi gerçekleştiren şey `\c <veritabani>`'dır.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'connecting-to-postgresql'
      AND NOT EXISTS (SELECT 1 FROM existing_q3)
    RETURNING id
),
target_q3 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q3
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q3
),
option_ins_q3 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q3.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q3
             CROSS JOIN (VALUES
    ($$Komut isteminin kendisi, `postgres=#`'ten `learning=#`'e değişir, bu da oturumun artık `learning`e bağlı olduğunu doğrular$$, TRUE, 0),
    ($$Aynı oturum içinde doğrulamanın bir yolu yoktur -- tamamen bağlantıyı kesip yeniden bağlanmak gerekir$$, FALSE, 1),
    ($$`\c`, onay olarak yeni veritabanındaki her tablonun tam listesini her zaman otomatik olarak yazdırır$$, FALSE, 2),
    ($$Başarılı bir veritabanı geçişini belirtmek için terminalin arka plan rengi değişir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'connecting-to-postgresql'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'connecting-to-postgresql')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu psql oturumu göz önüne alındığında, `learning=#` komut isteminin (postgres=# yerine) bunu izleyen `\dt` çıktısı hakkında doğruladığı şey nedir?$$
      AND code_snippet = $$postgres=# \c kurs_db
You are now connected to database "kurs_db" as user "postgres".

kurs_db=# \dt
           List of relations
 Schema |   Name   | Type  |  Owner
--------+----------+-------+---------
 public | topic    | table | kurs_db
 public | category | table | kurs_db$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
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
    FROM topic
    WHERE slug = 'connecting-to-postgresql'
      AND NOT EXISTS (SELECT 1 FROM existing_q4)
    RETURNING id
),
target_q4 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q4
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q4
),
option_ins_q4 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q4.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q4
             CROSS JOIN (VALUES
    ($$Komut istemi değişikliği bir hata oluştuğunu ve `\dt`'nin çalışmayı başaramayacağını gösterir$$, FALSE, 0),
    ($$`\dt` çıktısı özellikle `kurs_db` veritabanındaki tabloları listeler, varsayılan `postgres` veritabanını değil$$, TRUE, 1),
    ($$`\dt` çıktısı, o anda hangi veritabanına bağlı olunduğuyla ilgisizdir -- her zaman sunucudaki her tabloyu listeler$$, FALSE, 2),
    ($$Komut istemi değişikliği, bağlantının yalnızca farklı bir veritabanına değil, tamamen farklı bir PostgreSQL sunucusuna geçtiği anlamına gelir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'connecting-to-postgresql'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'connecting-to-postgresql')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`jdbc:postgresql://localhost:5433/kurs` JDBC URL'sinde, `kurs`, `psql`'in kendi bayraklarında/komutlarında neye karşılık gelir?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`jdbc:postgresql://localhost:5433/kurs` JDBC URL'sinde, `kurs`, `psql`'in kendi bayraklarında/komutlarında neye karşılık gelir?$$,
           NULL, NULL,
           $$Ders, JDBC URL'sini parça parça ayrıştırır: `kurs`, veritabanı adıdır, anlam olarak psql'in `\c kurs` (ya da komut satırında `-d kurs`) ile birebir aynıdır -- host/port (`localhost:5433`) ise psql'in `-h`/`-p` bayraklarına karşılık gelir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'connecting-to-postgresql'
      AND NOT EXISTS (SELECT 1 FROM existing_q5)
    RETURNING id
),
target_q5 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q5
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q5
),
option_ins_q5 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q5.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q5
             CROSS JOIN (VALUES
    ($$Bağlanmak için kullanılan JDBC sürücüsünün adı$$, FALSE, 0),
    ($$Bağlantıyı kimlik doğrulamak için kullanılan şifre$$, FALSE, 1),
    ($$Veritabanı adı -- anlam olarak psql'in `\c kurs` ya da `-d kurs`'u ile birebir aynı$$, TRUE, 2),
    ($$Bağlanılacak kullanıcı adı -- anlam olarak psql'in `-U` bayrağı ile birebir aynı$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'connecting-to-postgresql'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'connecting-to-postgresql')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu dersin 'Common Misconceptions' bölümünde ele alındığı şekliyle, PostgreSQL'e bağlanma hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu dersin 'Common Misconceptions' bölümünde ele alındığı şekliyle, PostgreSQL'e bağlanma hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (Spring Boot'un özel bir kuruluma ihtiyacı olmaması -- spring.datasource.url/username/password'ün, bir terminal yerine bir JDBC sürücüsü üzerinden taşınan, psql'in -h/-p/-U/-d'sinin ihtiyaç duyduğu tam olarak aynı üç şey olması; psql ile bir GUI veritabanı aracının ikisinin de sonunda aynı host/port/veritabanı/kimlik bilgilerini kullanarak bağlanması ve aynı PostgreSQL wire protokolünü konuşması); ders, 5433'ün PostgreSQL'in gerçek portu OLMADIĞINI (5432'nin olduğunu) açıkça belirtir, ve aynı host/port/veritabanı/kimlik bilgileriyle doğrudan psql ile bağlanmayı denemenin, bir bağlantı sorununun PostgreSQL'in kendisinde mi yoksa Spring/JDBC katmanında mı olduğunu izole etmek için tam olarak önerildiğini belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-06 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'connecting-to-postgresql'
      AND NOT EXISTS (SELECT 1 FROM existing_q6)
    RETURNING id
),
target_q6 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q6
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q6
),
option_ins_q6 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q6.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q6
             CROSS JOIN (VALUES
    ($$`psql` ile bir GUI veritabanı aracının ikisi de sonunda aynı host/port/veritabanı/kimlik bilgilerini kullanarak bağlanır ve aynı PostgreSQL wire protokolünü konuşur$$, TRUE, 0),
    ($$5433 portu bu derste PostgreSQL'in gerçek, standart portu olarak tanımlanır$$, FALSE, 1),
    ($$Doğrudan `psql` ile bağlanmayı denemek, bir JDBC bağlantı hatasının veritabanı sorunu mu yoksa Spring/JDBC katmanı sorunu mu olduğunu izole etmenin bir yolu olarak caydırılır$$, FALSE, 2),
    ($$`spring.datasource.url`/`username`/`password`, bir terminal yerine bir JDBC sürücüsü üzerinden taşınan, psql'in `-h`/`-p`/`-U`/`-d`'sinin ihtiyaç duyduğu tam olarak aynı üç şeydir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'connecting-to-postgresql'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
