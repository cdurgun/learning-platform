-- Promotion batch
-- Topic: dockerizing-a-spring-boot-application (language: en x6, tr x6)
-- Generated: 2026-09-05 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 12 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/dockerizing-a-spring-boot-application.md and content/tr/dockerizing-a-spring-boot-application.md -- NOT produced by n8n,
-- NOT judged by any external AI API, and NOT ingested via
-- /api/internal/questions/ingest.
--
-- Per-topic question count is FLEXIBLE (6 EN + 6 TR here), sized to this
-- lesson's actual concept density rather than a fixed target -- unlike
-- prior categories in this project, this Docker course batch deliberately
-- varies EN/TR pair count per topic (4-7) based on lesson length/depth.
--
-- Strict 50/50 EN/TR split (6+6) organized as 6 CONCEPT PAIRS -- each EN
-- question has a TR counterpart testing the exact same concept, but
-- independently authored (different framing/options/examples), not a
-- translation. Every question whose answer depends on shown code/command
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
           $$Does `mvn package` need to change in any way to work with Docker, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states `mvn package` already produces a single, self-contained, runnable JAR before Docker enters the picture at all, and nothing about that changes here -- what a Dockerfile adds is a way to package that already-built JAR together with a matching Java runtime into one image.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dockerizing-a-spring-boot-application'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$No, but only because this specific project doesn't use `spring-boot-starter-parent`$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$No -- `mvn package` already produces the same self-contained JAR either way; Docker just packages that existing JAR with a matching Java runtime$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Yes -- Docker requires a completely different Maven plugin to produce a Docker-compatible JAR format$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Yes -- `mvn package` must be replaced with `docker package` once Docker is introduced$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, Docker ile çalışmak için `mvn package` herhangi bir şekilde değişmesi gerekir mi?$$,
           NULL, NULL,
           $$Ders, `mvn package`'ın Docker hiç devreye girmeden önce zaten tek, kendi kendine yeten, çalıştırılabilir bir JAR ürettiğini, ve bunun burada hiç değişmediğini belirtir -- bir Dockerfile'ın eklediği şey, bu zaten inşa edilmiş JAR'ı eşleşen bir Java runtime'ıyla birlikte tek bir imaja paketlemenin bir yoludur.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dockerizing-a-spring-boot-application'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Evet -- Docker, Docker uyumlu bir JAR formatı üretmek için tamamen farklı bir Maven eklentisi gerektirir$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Evet -- Docker tanıtıldıktan sonra `mvn package`'ın `docker package` ile değiştirilmesi gerekir$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Hayır, ama yalnızca bu spesifik proje `spring-boot-starter-parent` kullanmadığı için$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Hayır -- `mvn package` her iki durumda da zaten aynı kendi kendine yeten JAR'ı üretir; Docker yalnızca bu var olan JAR'ı eşleşen bir Java runtime'ıyla paketler$$, TRUE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Why does this lesson choose a JRE-only base image (`eclipse-temurin:21-jre`) rather than a full JDK image for the final Spring Boot container?$$,
           NULL, NULL,
           $$The lesson states the JAR is already fully built before the Dockerfile even runs, so the final image only ever needs to run it -- a JRE image is enough, and deliberately smaller than a JDK one, since a JDK's compiler and build tooling have no use once the JAR already exists.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dockerizing-a-spring-boot-application'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`eclipse-temurin` doesn't publish a JRE variant, so JDK is the only available choice$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$A JRE image is required specifically because this project's `pom.xml` sets `<java.version>21</java.version>`$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$The JAR is already fully built before the Dockerfile runs, so the final image only needs to run it -- a JRE is enough and deliberately smaller than a JDK image$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$A JDK image is technically incompatible with running any already-compiled JAR file$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu ders, nihai Spring Boot container'ı için neden tam bir JDK imajı yerine yalnızca JRE olan bir temel imaj (`eclipse-temurin:21-jre`) seçiyor?$$,
           NULL, NULL,
           $$Ders, JAR'ın Dockerfile çalışmadan önce zaten tamamen inşa edilmiş olduğunu, bu yüzden nihai imajın yalnızca onu çalıştırması gerektiğini belirtir -- bir JRE yeterlidir ve bir JDK'dan kasıtlı olarak daha küçüktür, çünkü JAR zaten var olduğunda bir JDK'nın derleyicisinin ve build araçlarının hiçbir kullanımı yoktur.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dockerizing-a-spring-boot-application'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$JAR, Dockerfile çalışmadan önce zaten tamamen inşa edilmiştir, bu yüzden nihai imajın yalnızca onu çalıştırması gerekir -- bir JRE yeterlidir ve bir JDK imajından kasıtlı olarak daha küçüktür$$, TRUE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Bir JDK imajı, zaten derlenmiş herhangi bir JAR dosyasını çalıştırmakla teknik olarak uyumsuzdur$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$`eclipse-temurin` bir JRE varyantı yayınlamaz, bu yüzden JDK tek mevcut seçenektir$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Bir JRE imajı, özellikle bu projenin `pom.xml`'i `<java.version>21</java.version>` ayarladığı için gereklidir$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does a `.dockerignore` file do, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states .dockerignore excludes paths from the build context the same way .gitignore excludes files from a commit -- without it, the build context includes everything in the project folder (.git's full history, IDE configuration), none of which the image actually needs, and a smaller context also makes every build meaningfully faster.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dockerizing-a-spring-boot-application'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It excludes specific Java classes from being compiled by Maven before the Docker build starts$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$It lists which Docker Hub registries the build process is allowed to pull base images from$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$It permanently deletes files from the host machine's filesystem after a successful `docker build`$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$It excludes paths from the build context, the same way `.gitignore` excludes files from a commit -- making builds smaller and faster$$, TRUE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir `.dockerignore` dosyası ne yapar?$$,
           NULL, NULL,
           $$Ders, .dockerignore'un, tıpkı .gitignore'un dosyaları bir commit'ten hariç tutması gibi, yolları build context'ten hariç tuttuğunu belirtir -- bu olmadan, build context proje klasöründeki her şeyi (.git'in tam geçmişi, IDE yapılandırması) içerir, hiçbiri imajın gerçekten ihtiyaç duymadığı şeylerdir, ve daha küçük bir context her build'i anlamlı şekilde daha hızlı da yapar.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dockerizing-a-spring-boot-application'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Başarılı bir `docker build`'den sonra host makinenin dosya sisteminden dosyaları kalıcı olarak siler$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Tıpkı `.gitignore`'un dosyaları bir commit'ten hariç tutması gibi, yolları build context'ten hariç tutar -- build'leri daha küçük ve daha hızlı yapar$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Docker build'i başlamadan önce Maven'ın derleyeceği belirli Java sınıflarını hariç tutar$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Build sürecinin hangi Docker Hub registry'lerinden temel imaj çekmesine izin verildiğini listeler$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What is the key benefit of a multi-stage build, as described in this lesson?$$,
           NULL, NULL,
           $$The lesson states a multi-stage build's first stage (named `builder`) runs `mvn package` inside the container itself, with no dependency on Maven or a JDK already being installed on the host; the final stage starts fresh from a small JRE base and copies out only the finished JAR, so Maven, the JDK, pom.xml, and the full src tree never become part of the final image.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dockerizing-a-spring-boot-application'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It builds the JAR inside Docker itself (no host Maven/JDK required) while keeping the final image small, since only the finished JAR is copied into the last stage$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$It runs the application twice for redundancy, in case one running instance crashes unexpectedly$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$It allows a single Dockerfile to target two completely unrelated applications at once$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$It automatically encrypts the final image so its contents can't be inspected by anyone who pulls it$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste tanımlandığı şekliyle, bir multi-stage build'in temel faydası nedir?$$,
           NULL, NULL,
           $$Ders, bir multi-stage build'in ilk aşamasının (adı `builder`) `mvn package`'ı container'ın kendi içinde çalıştırdığını, host'ta zaten kurulu bir Maven veya JDK'ya bağımlı olmadığını belirtir; nihai aşama küçük bir JRE tabanından taze başlar ve yalnızca bitmiş JAR'ı dışarı kopyalar, bu yüzden Maven, JDK, pom.xml ve tam src ağacı hiçbir zaman nihai imajın parçası olmaz.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dockerizing-a-spring-boot-application'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Tek bir Dockerfile'ın aynı anda tamamen ilgisiz iki uygulamayı hedeflemesine izin verir$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Nihai imajı, içeriğinin onu çeken kimse tarafından incelenemeyecek şekilde otomatik olarak şifreler$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$JAR'ı Docker'ın kendi içinde inşa eder (host'ta Maven/JDK gerekmez) ve son aşamaya yalnızca bitmiş JAR kopyalandığı için nihai imajı küçük tutar$$, TRUE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Bir çalışan örnek beklenmedik şekilde çökerse diye, uygulamayı yedeklilik için iki kez çalıştırır$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A container is started with `docker run -m 512m learning-platform:0.1.0`, and its Dockerfile uses only `ENTRYPOINT ["java", "-jar", "app.jar"]` with no explicit `-XX:MaxRAMPercentage`. According to this lesson, roughly what percentage of the 512MB limit does the JVM use for its heap by default?$$,
           $$docker run -m 512m learning-platform:0.1.0

# Dockerfile ENTRYPOINT (no explicit MaxRAMPercentage set):
# ENTRYPOINT ["java", "-jar", "app.jar"]$$, $$bash$$,
           $$The lesson states that since Java 10, the JVM is container-aware and by default sizes its heap as a percentage of the container's memory limit via -XX:MaxRAMPercentage, which defaults to 25.0 -- so with no explicit override, roughly 25% of the 512MB limit is used for the heap, described in the lesson as "a fairly small heap for a real Spring Boot application."$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dockerizing-a-spring-boot-application'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$0% -- without an explicit `-XX:MaxRAMPercentage`, the JVM fails to start inside any memory-limited container$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Roughly 25% -- `-XX:MaxRAMPercentage` defaults to 25.0, described in the lesson as a fairly small heap for a real application$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Roughly 100% -- the JVM always uses the entire container memory limit for its heap by default$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Roughly 75% -- 75.0 is the JVM's actual out-of-the-box default for `-XX:MaxRAMPercentage`$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir container `docker run -m 512m ogrenme-platformu:0.1.0` ile başlatılıyor, ve Dockerfile'ı açık bir `-XX:MaxRAMPercentage` olmadan yalnızca `ENTRYPOINT ["java", "-jar", "app.jar"]` kullanıyor. Bu derse göre, JVM varsayılan olarak 512MB sınırının yaklaşık yüzde kaçını heap'i için kullanır?$$,
           $$docker run -m 512m ogrenme-platformu:0.1.0

# Dockerfile ENTRYPOINT (acik MaxRAMPercentage ayari yok):
# ENTRYPOINT ["java", "-jar", "app.jar"]$$, $$bash$$,
           $$Ders, Java 10'dan beri JVM'nin container-aware olduğunu ve varsayılan olarak heap'ini container'ın bellek sınırının bir yüzdesi olarak `-XX:MaxRAMPercentage` üzerinden boyutlandırdığını, bunun varsayılanının 25.0 olduğunu belirtir -- bu yüzden açık bir geçersiz kılma olmadan, 512MB sınırının yaklaşık %25'i heap için kullanılır, ders bunu 'gerçek bir uygulama için oldukça küçük bir heap' olarak tanımlar.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dockerizing-a-spring-boot-application'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yaklaşık %100 -- JVM varsayılan olarak heap'i için her zaman container'ın tüm bellek sınırını kullanır$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Yaklaşık %75 -- 75.0, `-XX:MaxRAMPercentage` için JVM'nin gerçek kutudan çıkma varsayılanıdır$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$%0 -- açık bir `-XX:MaxRAMPercentage` olmadan, JVM bellek sınırlı herhangi bir container içinde başlamayı başaramaz$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Yaklaşık %25 -- `-XX:MaxRAMPercentage` varsayılan olarak 25.0'dır, ders bunu gerçek bir uygulama için oldukça küçük bir heap olarak tanımlar$$, TRUE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about dockerizing this Spring Boot application, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (a single-stage Dockerfile requires `mvn package` to already have been run on the host before `docker build`, since COPY needs the JAR to already exist; `COPY --from=builder` only works because the earlier stage was explicitly named via `AS builder`); the lesson doesn't recommend hardcoding a fixed -Xmx value (it explicitly warns against this, since it silently stops matching reality when the container's memory limit changes), and `host.docker.internal` is described as reaching a service on the host machine, not the recommended way for two containers that are meant to run together to reach each other (that's the subject of the next lesson, "Docker Networking").$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dockerizing-a-spring-boot-application'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hardcoding a fixed `-Xmx` value is recommended over the JVM's default container-aware heap sizing in every case$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$`host.docker.internal` is this lesson's recommended way for two containers that are meant to run together to reach each other$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$A single-stage Dockerfile requires `mvn package` to already have been run on the host machine before `docker build`, so `COPY` can find the JAR$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$`COPY --from=builder` only works because the earlier stage was explicitly given that name via `FROM ... AS builder`$$, TRUE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, bu Spring Boot uygulamasını Docker'a taşımakla ilgili aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (tek aşamalı bir Dockerfile'ın, COPY'nin JAR'ı bulabilmesi için `docker build`'den önce host makinede `mvn package`'ın zaten çalıştırılmış olmasını gerektirmesi; `COPY --from=builder`'ın yalnızca önceki aşamaya `AS builder` ile açıkça bu adın verilmiş olması sayesinde çalışması); ders sabit bir -Xmx değerini sabit kodlamayı önermez (bunun aksine açıkça uyarır, çünkü container'ın bellek sınırı değiştiğinde sessizce gerçeği yansıtmaz hale gelir), ve `host.docker.internal`, host makinedeki bir servise ulaşmak olarak tanımlanır, birlikte çalışması amaçlanan iki container'ın birbirine ulaşması için önerilen yol değildir (bu bir sonraki dersin, 'Docker Networking'in konusudur).$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'dockerizing-a-spring-boot-application'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Tek aşamalı bir Dockerfile, COPY'nin JAR'ı bulabilmesi için `docker build`'den önce host makinede `mvn package`'ın zaten çalıştırılmış olmasını gerektirir$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$`COPY --from=builder`, yalnızca önceki aşamaya `FROM ... AS builder` ile açıkça bu adın verilmiş olması sayesinde çalışır$$, TRUE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Sabit bir `-Xmx` değerini sabit kodlamak, her durumda JVM'nin varsayılan container-aware heap boyutlandırmasına tercih edilir$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$`host.docker.internal`, birlikte çalışması amaçlanan iki container'ın birbirine ulaşması için bu dersin önerdiği yoldur$$, FALSE, 3 FROM new_question_tr6;
