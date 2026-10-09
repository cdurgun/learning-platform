-- seo_description yeniden yazımının ikinci turu (bkz. docs/google-seo-adsense-plan.md,
-- Aşama 4; ilk tur: V1135). 24 dersin EN ve TR açıklamaları (48 kayıt): ziyaretçiye anlamsız
-- "this project's own..." / "bu projenin kendi..." ifadesi taşıyanlar, Markdown ters tırnağı
-- içerenler ve dersi anlatmayacak kadar kısa olanlar. Yalnızca seo_description değişir; title,
-- seo_title ve içerik dosyalarına dokunulmaz. Slug + dil ile eşleştiği için ortamdan
-- bağımsızdır ve tekrar çalıştırılması aynı sonucu verir.
UPDATE topic_translation tt
SET seo_description = v.seo_description
FROM (VALUES
    ('scanner', 'en', 'Read console and file input with Java''s Scanner, fix the classic nextLine after nextInt trap, use custom delimiters, and see why Scanner is slower than BufferedReader.'),
    ('scanner', 'tr', 'Java''da Scanner ile konsoldan ve dosyadan okuma, nextInt''ten sonra nextLine tuzağı ve çözümü, özel ayırıcılar ve Scanner''ın BufferedReader''dan neden daha yavaş olduğu.'),
    ('file-reading', 'en', 'Two ways to read a file in Java: the Files class with readAllLines, readString and lines, and the classic BufferedReader, plus NoSuchFileException vs FileNotFoundException.'),
    ('file-reading', 'tr', 'Java''da dosya okumanın iki yolu: readAllLines, readString ve lines ile Files sınıfı ve klasik BufferedReader; ayrıca NoSuchFileException ile FileNotFoundException farkı.'),
    ('file-writing', 'en', 'Two ways to write a file in Java: the Files class with writeString, write and copy, and the classic BufferedWriter, plus appending to a file and writing a CSV file.'),
    ('file-writing', 'tr', 'Java''da dosyaya yazmanın iki yolu: writeString, write ve copy ile Files sınıfı ve klasik BufferedWriter; ayrıca dosyaya ekleme (append) ve CSV dosyası yazma.'),
    ('switch', 'en', 'Java switch explained: classic case and break syntax, the fall-through trap, the modern arrow syntax, switch expressions with yield, and exhaustiveness checks for enums.'),
    ('switch', 'tr', 'Java''da switch: klasik case ve break sözdizimi, fall-through tuzağı, modern ok sözdizimi, yield ile switch ifadeleri ve enum''larda kapsayıcılık kontrolü.'),
    ('if-else', 'en', 'Java if and else explained: else if chains, nested conditions, comparison and logical operators with short-circuit evaluation, and the ternary operator.'),
    ('if-else', 'tr', 'Java''da if ve else: else if zincirleri, iç içe koşullar, karşılaştırma ve mantıksal operatörler, kısa devre değerlendirme ve üçlü operatör.'),
    ('for-loop', 'en', 'The Java for loop explained: classic syntax, controlling flow with break and continue, infinite loops, and index-based array iteration.'),
    ('for-loop', 'tr', 'Java''da for döngüsü: klasik sözdizimi, break ve continue ile akış kontrolü, sonsuz döngüler ve index tabanlı dizi gezinme.'),
    ('enhanced-for-loop', 'en', 'Java''s enhanced for (for-each) loop: basic syntax with arrays and collections, its three real limitations, and when to use it instead of a classic for loop.'),
    ('enhanced-for-loop', 'tr', 'Java''da enhanced for (for-each) döngüsü: dizi ve koleksiyonlarla temel sözdizimi, üç gerçek sınırı ve klasik for yerine ne zaman kullanılacağı.'),
    ('while-do-while', 'en', 'Java while and do-while loops: syntax, the difference between them, input validation with Scanner, and a worked Number Guessing Game example.'),
    ('while-do-while', 'tr', 'Java''da while ve do-while döngüleri: sözdizimi, aralarındaki fark, Scanner ile girdi doğrulama ve uygulamalı bir Sayı Tahmin Oyunu örneği.'),
    ('docker-networking', 'en', 'How Docker networking works: the default bridge network, user-defined networks, container-to-container communication by name, and what localhost means inside a container.'),
    ('docker-networking', 'tr', 'Docker ağları nasıl çalışır: varsayılan bridge network, user-defined network''ler, container''lar arasında isimle iletişim ve localhost''un container içinde ne anlama geldiği.'),
    ('docker-compose', 'en', 'Learn to write a docker-compose.yml: services, depends_on, automatic service-name networking, and volumes, using a Spring Boot and PostgreSQL setup as the example.'),
    ('docker-compose', 'tr', 'docker-compose.yml nasıl yazılır: service''ler, depends_on, servis adıyla otomatik networking ve volume''lar; örnek olarak bir Spring Boot ve PostgreSQL kurulumu.'),
    ('production-docker-for-java-applications', 'en', 'Make a Docker image for a Java application production-ready: layer caching, running as a non-root user, HEALTHCHECK, Compose health conditions, and keeping secrets out of the image.'),
    ('production-docker-for-java-applications', 'tr', 'Java uygulamanızın Docker image''ını production''a hazırlayın: layer caching, root olmayan kullanıcı, HEALTHCHECK, Compose sağlık koşulları ve sırları image''ın dışında tutmak.'),
    ('postgresql-data-types', 'en', 'PostgreSQL''s core data types (numeric, text, boolean, date and time) and how each one maps to a Java field type through JPA and Hibernate, shown on a real schema.'),
    ('postgresql-data-types', 'tr', 'PostgreSQL''in temel veri türleri (sayısal, metin, boolean, tarih ve saat) ve bunların JPA ve Hibernate ile Java alan türlerine nasıl eşlendiği, gerçek bir şema üzerinde.'),
    ('indexes-and-query-performance-with-explain', 'en', 'Read PostgreSQL query plans with EXPLAIN and EXPLAIN ANALYZE: Seq Scan vs Index Scan, B-tree, partial and expression indexes, and keyset pagination.'),
    ('indexes-and-query-performance-with-explain', 'tr', 'PostgreSQL sorgu planlarını EXPLAIN ve EXPLAIN ANALYZE ile okuyun: Seq Scan ve Index Scan farkı, B-tree, partial ve expression index''ler ve keyset pagination.'),
    ('sorting-limiting-and-pagination', 'en', 'Sorting and pagination in PostgreSQL: ORDER BY, LIMIT and OFFSET, NULLS FIRST and NULLS LAST, the cost of OFFSET on large tables, and the SQL behind Spring Data''s Pageable.'),
    ('sorting-limiting-and-pagination', 'tr', 'PostgreSQL''de sıralama ve sayfalama: ORDER BY, LIMIT ve OFFSET, NULLS FIRST ve NULLS LAST, büyük tablolarda OFFSET''in maliyeti ve Spring Data Pageable''ın altındaki SQL.'),
    ('subqueries-ctes-and-window-functions', 'en', 'PostgreSQL subqueries, CTEs and window functions: scalar and correlated subqueries, WITH queries, and ROW_NUMBER, RANK and PARTITION BY, with examples on real data.'),
    ('subqueries-ctes-and-window-functions', 'tr', 'PostgreSQL''de subquery, CTE ve window fonksiyonları: scalar ve korelasyonlu subquery''ler, WITH sorguları, ROW_NUMBER, RANK ve PARTITION BY; gerçek veriyle örnekler.'),
    ('select-and-filtering', 'en', 'SELECT and WHERE in PostgreSQL: comparison and logical operators, LIKE pattern matching, IN and BETWEEN, and why = NULL does not work, with examples on real data.'),
    ('select-and-filtering', 'tr', 'PostgreSQL''de SELECT ve WHERE: karşılaştırma ve mantıksal operatörler, LIKE ile desen eşleştirme, IN ve BETWEEN ve = NULL''ın neden çalışmadığı; gerçek veriyle örnekler.'),
    ('databases-schemas-tables-and-basic-sql', 'en', 'The database, schema and table hierarchy in PostgreSQL, CREATE TABLE syntax, column definitions and the DDL vs DML distinction, explained on a real application schema.'),
    ('databases-schemas-tables-and-basic-sql', 'tr', 'PostgreSQL''de veritabanı, şema ve tablo hiyerarşisi; CREATE TABLE sözdizimi, sütun tanımları ve DDL ile DML ayrımı, gerçek bir uygulamanın şeması üzerinden.'),
    ('constraints-and-keys', 'en', 'PostgreSQL constraints and keys: PRIMARY KEY, FOREIGN KEY, ON DELETE CASCADE vs RESTRICT, NOT NULL, UNIQUE and CHECK, with examples from a real application schema.'),
    ('constraints-and-keys', 'tr', 'PostgreSQL''de kısıtlar ve anahtarlar: PRIMARY KEY, FOREIGN KEY, ON DELETE CASCADE ve RESTRICT farkı, NOT NULL, UNIQUE ve CHECK; gerçek bir uygulama şemasından örneklerle.'),
    ('transactions-and-concurrency-in-postgresql', 'en', 'Transactions and concurrency in PostgreSQL: BEGIN, COMMIT and ROLLBACK, how MVCC keeps readers and writers from blocking each other, SELECT ... FOR UPDATE row locking, and deadlocks.'),
    ('transactions-and-concurrency-in-postgresql', 'tr', 'PostgreSQL''de transaction ve eşzamanlılık: BEGIN, COMMIT ve ROLLBACK, MVCC ile okuma ve yazmanın birbirini bloklamaması, SELECT ... FOR UPDATE ile satır kilitleme ve deadlock''lar.'),
    ('joins', 'en', 'PostgreSQL JOINs explained: INNER JOIN, LEFT JOIN, RIGHT JOIN and FULL JOIN on a real schema, and how a JPQL join fetch turns into a SQL JOIN.'),
    ('joins', 'tr', 'PostgreSQL''de JOIN''ler: gerçek bir şema üzerinde INNER JOIN, LEFT JOIN, RIGHT JOIN ve FULL JOIN ve bir JPQL join fetch''in SQL JOIN''e nasıl dönüştüğü.'),
    ('inserting-updating-and-deleting-data', 'en', 'Inserting, updating and deleting rows in PostgreSQL: INSERT, INSERT ... SELECT, UPDATE, DELETE, the RETURNING clause, and upserts with ON CONFLICT.'),
    ('inserting-updating-and-deleting-data', 'tr', 'PostgreSQL''de satır ekleme, güncelleme ve silme: INSERT, INSERT ... SELECT, UPDATE, DELETE, RETURNING ve ON CONFLICT ile upsert.'),
    ('aggregation-and-group-by', 'en', 'Aggregation in PostgreSQL: COUNT, SUM, AVG, MIN and MAX, grouping rows with GROUP BY, filtering groups with HAVING, and the difference between WHERE and HAVING.'),
    ('aggregation-and-group-by', 'tr', 'PostgreSQL''de aggregation: COUNT, SUM, AVG, MIN ve MAX, GROUP BY ile gruplama, HAVING ile grupları filtreleme ve WHERE ile HAVING arasındaki fark.'),
    ('enum', 'en', 'Learn Java enums: constructors, fields and methods, values and valueOf, enums in switch, EnumSet and EnumMap, and the Singleton and Strategy patterns with enums.'),
    ('enum', 'tr', 'Java''da enum: constructor, alan ve metotlar, values ve valueOf, switch ile kullanım, EnumSet ve EnumMap, enum ile Singleton ve Strategy desenleri.'),
    ('records', 'en', 'Learn Java records: components and generated members, immutability, canonical and compact constructors, record vs class, nested records, and record patterns in Java 21.'),
    ('records', 'tr', 'Java''da record: bileşenler ve üretilen üyeler, immutability, canonical ve compact constructor''lar, record ile class farkı, iç içe record''lar ve Java 21 record pattern''leri.')
) AS v(slug, language, seo_description)
JOIN topic t ON t.slug = v.slug
WHERE tt.topic_id = t.id
  AND tt.language = v.language;
