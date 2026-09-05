-- Promotion-style migration linking TR dockerizing-a-spring-boot-application quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 6 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.


-- Question 1/6 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dockerizing-a-spring-boot-application')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, Docker ile çalışmak için `mvn package` herhangi bir şekilde değişmesi gerekir mi?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, Docker ile çalışmak için `mvn package` herhangi bir şekilde değişmesi gerekir mi?$$,
           NULL, NULL,
           $$Ders, `mvn package`'ın Docker hiç devreye girmeden önce zaten tek, kendi kendine yeten, çalıştırılabilir bir JAR ürettiğini, ve bunun burada hiç değişmediğini belirtir -- bir Dockerfile'ın eklediği şey, bu zaten inşa edilmiş JAR'ı eşleşen bir Java runtime'ıyla birlikte tek bir imaja paketlemenin bir yoludur.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dockerizing-a-spring-boot-application'
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
    ($$Evet -- Docker, Docker uyumlu bir JAR formatı üretmek için tamamen farklı bir Maven eklentisi gerektirir$$, FALSE, 0),
    ($$Evet -- Docker tanıtıldıktan sonra `mvn package`'ın `docker package` ile değiştirilmesi gerekir$$, FALSE, 1),
    ($$Hayır, ama yalnızca bu spesifik proje `spring-boot-starter-parent` kullanmadığı için$$, FALSE, 2),
    ($$Hayır -- `mvn package` her iki durumda da zaten aynı kendi kendine yeten JAR'ı üretir; Docker yalnızca bu var olan JAR'ı eşleşen bir Java runtime'ıyla paketler$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dockerizing-a-spring-boot-application'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dockerizing-a-spring-boot-application')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu ders, nihai Spring Boot container'ı için neden tam bir JDK imajı yerine yalnızca JRE olan bir temel imaj (`eclipse-temurin:21-jre`) seçiyor?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu ders, nihai Spring Boot container'ı için neden tam bir JDK imajı yerine yalnızca JRE olan bir temel imaj (`eclipse-temurin:21-jre`) seçiyor?$$,
           NULL, NULL,
           $$Ders, JAR'ın Dockerfile çalışmadan önce zaten tamamen inşa edilmiş olduğunu, bu yüzden nihai imajın yalnızca onu çalıştırması gerektiğini belirtir -- bir JRE yeterlidir ve bir JDK'dan kasıtlı olarak daha küçüktür, çünkü JAR zaten var olduğunda bir JDK'nın derleyicisinin ve build araçlarının hiçbir kullanımı yoktur.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dockerizing-a-spring-boot-application'
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
    ($$JAR, Dockerfile çalışmadan önce zaten tamamen inşa edilmiştir, bu yüzden nihai imajın yalnızca onu çalıştırması gerekir -- bir JRE yeterlidir ve bir JDK imajından kasıtlı olarak daha küçüktür$$, TRUE, 0),
    ($$Bir JDK imajı, zaten derlenmiş herhangi bir JAR dosyasını çalıştırmakla teknik olarak uyumsuzdur$$, FALSE, 1),
    ($$`eclipse-temurin` bir JRE varyantı yayınlamaz, bu yüzden JDK tek mevcut seçenektir$$, FALSE, 2),
    ($$Bir JRE imajı, özellikle bu projenin `pom.xml`'i `<java.version>21</java.version>` ayarladığı için gereklidir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dockerizing-a-spring-boot-application'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dockerizing-a-spring-boot-application')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bir `.dockerignore` dosyası ne yapar?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir `.dockerignore` dosyası ne yapar?$$,
           NULL, NULL,
           $$Ders, .dockerignore'un, tıpkı .gitignore'un dosyaları bir commit'ten hariç tutması gibi, yolları build context'ten hariç tuttuğunu belirtir -- bu olmadan, build context proje klasöründeki her şeyi (.git'in tam geçmişi, IDE yapılandırması) içerir, hiçbiri imajın gerçekten ihtiyaç duymadığı şeylerdir, ve daha küçük bir context her build'i anlamlı şekilde daha hızlı da yapar.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dockerizing-a-spring-boot-application'
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
    ($$Başarılı bir `docker build`'den sonra host makinenin dosya sisteminden dosyaları kalıcı olarak siler$$, FALSE, 0),
    ($$Tıpkı `.gitignore`'un dosyaları bir commit'ten hariç tutması gibi, yolları build context'ten hariç tutar -- build'leri daha küçük ve daha hızlı yapar$$, TRUE, 1),
    ($$Docker build'i başlamadan önce Maven'ın derleyeceği belirli Java sınıflarını hariç tutar$$, FALSE, 2),
    ($$Build sürecinin hangi Docker Hub registry'lerinden temel imaj çekmesine izin verildiğini listeler$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dockerizing-a-spring-boot-application'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dockerizing-a-spring-boot-application')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste tanımlandığı şekliyle, bir multi-stage build'in temel faydası nedir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derste tanımlandığı şekliyle, bir multi-stage build'in temel faydası nedir?$$,
           NULL, NULL,
           $$Ders, bir multi-stage build'in ilk aşamasının (adı `builder`) `mvn package`'ı container'ın kendi içinde çalıştırdığını, host'ta zaten kurulu bir Maven veya JDK'ya bağımlı olmadığını belirtir; nihai aşama küçük bir JRE tabanından taze başlar ve yalnızca bitmiş JAR'ı dışarı kopyalar, bu yüzden Maven, JDK, pom.xml ve tam src ağacı hiçbir zaman nihai imajın parçası olmaz.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dockerizing-a-spring-boot-application'
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
    ($$Tek bir Dockerfile'ın aynı anda tamamen ilgisiz iki uygulamayı hedeflemesine izin verir$$, FALSE, 0),
    ($$Nihai imajı, içeriğinin onu çeken kimse tarafından incelenemeyecek şekilde otomatik olarak şifreler$$, FALSE, 1),
    ($$JAR'ı Docker'ın kendi içinde inşa eder (host'ta Maven/JDK gerekmez) ve son aşamaya yalnızca bitmiş JAR kopyalandığı için nihai imajı küçük tutar$$, TRUE, 2),
    ($$Bir çalışan örnek beklenmedik şekilde çökerse diye, uygulamayı yedeklilik için iki kez çalıştırır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dockerizing-a-spring-boot-application'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dockerizing-a-spring-boot-application')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir container `docker run -m 512m ogrenme-platformu:0.1.0` ile başlatılıyor, ve Dockerfile'ı açık bir `-XX:MaxRAMPercentage` olmadan yalnızca `ENTRYPOINT ["java", "-jar", "app.jar"]` kullanıyor. Bu derse göre, JVM varsayılan olarak 512MB sınırının yaklaşık yüzde kaçını heap'i için kullanır?$$
      AND code_snippet = $$docker run -m 512m ogrenme-platformu:0.1.0

# Dockerfile ENTRYPOINT (acik MaxRAMPercentage ayari yok):
# ENTRYPOINT ["java", "-jar", "app.jar"]$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir container `docker run -m 512m ogrenme-platformu:0.1.0` ile başlatılıyor, ve Dockerfile'ı açık bir `-XX:MaxRAMPercentage` olmadan yalnızca `ENTRYPOINT ["java", "-jar", "app.jar"]` kullanıyor. Bu derse göre, JVM varsayılan olarak 512MB sınırının yaklaşık yüzde kaçını heap'i için kullanır?$$,
           $$docker run -m 512m ogrenme-platformu:0.1.0

# Dockerfile ENTRYPOINT (acik MaxRAMPercentage ayari yok):
# ENTRYPOINT ["java", "-jar", "app.jar"]$$, $$bash$$,
           $$Ders, Java 10'dan beri JVM'nin container-aware olduğunu ve varsayılan olarak heap'ini container'ın bellek sınırının bir yüzdesi olarak `-XX:MaxRAMPercentage` üzerinden boyutlandırdığını, bunun varsayılanının 25.0 olduğunu belirtir -- bu yüzden açık bir geçersiz kılma olmadan, 512MB sınırının yaklaşık %25'i heap için kullanılır, ders bunu 'gerçek bir uygulama için oldukça küçük bir heap' olarak tanımlar.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dockerizing-a-spring-boot-application'
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
    ($$Yaklaşık %100 -- JVM varsayılan olarak heap'i için her zaman container'ın tüm bellek sınırını kullanır$$, FALSE, 0),
    ($$Yaklaşık %75 -- 75.0, `-XX:MaxRAMPercentage` için JVM'nin gerçek kutudan çıkma varsayılanıdır$$, FALSE, 1),
    ($$%0 -- açık bir `-XX:MaxRAMPercentage` olmadan, JVM bellek sınırlı herhangi bir container içinde başlamayı başaramaz$$, FALSE, 2),
    ($$Yaklaşık %25 -- `-XX:MaxRAMPercentage` varsayılan olarak 25.0'dır, ders bunu gerçek bir uygulama için oldukça küçük bir heap olarak tanımlar$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dockerizing-a-spring-boot-application'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dockerizing-a-spring-boot-application')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, bu Spring Boot uygulamasını Docker'a taşımakla ilgili aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, bu Spring Boot uygulamasını Docker'a taşımakla ilgili aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (tek aşamalı bir Dockerfile'ın, COPY'nin JAR'ı bulabilmesi için `docker build`'den önce host makinede `mvn package`'ın zaten çalıştırılmış olmasını gerektirmesi; `COPY --from=builder`'ın yalnızca önceki aşamaya `AS builder` ile açıkça bu adın verilmiş olması sayesinde çalışması); ders sabit bir -Xmx değerini sabit kodlamayı önermez (bunun aksine açıkça uyarır, çünkü container'ın bellek sınırı değiştiğinde sessizce gerçeği yansıtmaz hale gelir), ve `host.docker.internal`, host makinedeki bir servise ulaşmak olarak tanımlanır, birlikte çalışması amaçlanan iki container'ın birbirine ulaşması için önerilen yol değildir (bu bir sonraki dersin, 'Docker Networking'in konusudur).$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dockerizing-a-spring-boot-application'
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
    ($$Tek aşamalı bir Dockerfile, COPY'nin JAR'ı bulabilmesi için `docker build`'den önce host makinede `mvn package`'ın zaten çalıştırılmış olmasını gerektirir$$, TRUE, 0),
    ($$`COPY --from=builder`, yalnızca önceki aşamaya `FROM ... AS builder` ile açıkça bu adın verilmiş olması sayesinde çalışır$$, TRUE, 1),
    ($$Sabit bir `-Xmx` değerini sabit kodlamak, her durumda JVM'nin varsayılan container-aware heap boyutlandırmasına tercih edilir$$, FALSE, 2),
    ($$`host.docker.internal`, birlikte çalışması amaçlanan iki container'ın birbirine ulaşması için bu dersin önerdiği yoldur$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dockerizing-a-spring-boot-application'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
