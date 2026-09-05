-- Promotion batch
-- Topic: production-docker-for-java-applications (language: en x6, tr x6)
-- Generated: 2026-09-05 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 12 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/production-docker-for-java-applications.md and content/tr/production-docker-for-java-applications.md -- NOT produced by n8n,
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
           $$What does a Dockerfile `HEALTHCHECK` actually let Docker do, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states HEALTHCHECK tells Docker how to actually ask a running container "are you working?" -- periodically running a command inside the container and tracking whether it succeeds; `docker ps` then shows a container's health status (healthy/unhealthy/starting) instead of just whether the process hasn't crashed.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'production-docker-for-java-applications'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Automatically scale the number of running replicas of a container up or down$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Periodically run a command inside the container to check whether it's actually working, visible as a health status in `docker ps`$$, TRUE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Automatically restart the container every time its memory usage crosses a configured threshold$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Permanently prevent the container from ever being stopped once it starts$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir Dockerfile `HEALTHCHECK`'i Docker'ın gerçekte ne yapmasını sağlar?$$,
           NULL, NULL,
           $$Ders, HEALTHCHECK'in Docker'a çalışan bir container'a gerçekten 'çalışıyor musun?' diye sormanın yolunu söylediğini belirtir -- container içinde periyodik olarak bir komut çalıştırır ve başarılı olup olmadığını takip eder; `docker ps` daha sonra yalnızca sürecin çökmediğini değil, bir container'ın sağlık durumunu (healthy/unhealthy/starting) gösterir.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'production-docker-for-java-applications'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bellek kullanımı yapılandırılmış bir eşiği her aştığında container'ı otomatik olarak yeniden başlatır$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Container'ın başladıktan sonra bir daha asla durdurulamamasını kalıcı olarak sağlar$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir container'ın çalışan replika sayısını otomatik olarak yukarı ya da aşağı ölçeklendirir$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Container içinde periyodik olarak bir komut çalıştırarak gerçekten çalışıp çalışmadığını kontrol eder, `docker ps`'te bir sağlık durumu olarak görünür$$, TRUE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does adding a `USER appuser` instruction (after `groupadd`/`useradd` and `COPY --chown`) actually change, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states `USER appuser` switches every instruction after it -- including the final ENTRYPOINT's java process -- to run as that unprivileged user instead of root; this is defense in depth, since a compromise of the running Java process no longer automatically hands over root inside the container.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'production-docker-for-java-applications'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It deletes the root user from the image entirely, making root permanently inaccessible even via `docker exec`$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$It automatically encrypts all files the container writes to disk from that point forward$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$It switches every instruction after it, including the final running Java process, to run as an unprivileged user instead of root$$, TRUE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$It has no runtime effect at all -- it only changes what appears in `docker inspect` output$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, (`groupadd`/`useradd` ve `COPY --chown`'dan sonra) bir `USER appuser` talimatı eklemek gerçekte neyi değiştirir?$$,
           NULL, NULL,
           $$Ders, `USER appuser`'ın kendisinden sonraki her talimatı -- nihai ENTRYPOINT'in java süreci dahil -- root yerine o ayrıcalıksız kullanıcı olarak çalışacak şekilde değiştirdiğini belirtir; bu derinlemesine savunmadır, çünkü çalışan Java sürecinin ele geçirilmesi artık container içinde otomatik olarak root vermez.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'production-docker-for-java-applications'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Kendisinden sonraki her talimatı, nihai çalışan Java süreci dahil, root yerine ayrıcalıksız bir kullanıcı olarak çalışacak şekilde değiştirir$$, TRUE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Çalışma zamanında hiçbir etkisi yoktur -- yalnızca `docker inspect` çıktısında görüneni değiştirir$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Root kullanıcısını imajdan tamamen siler, root'u `docker exec` yoluyla bile kalıcı olarak erişilemez hale getirir$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$O andan itibaren container'ın diske yazdığı tüm dosyaları otomatik olarak şifreler$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$According to "Basic Image Security Considerations," what happens to a real secret (like a password) set with `ENV` in a Dockerfile, even if that value is later "changed"?$$,
           NULL, NULL,
           $$The lesson explicitly states a secret set with ENV or hardcoded in a Dockerfile becomes part of the image's own layers, readable by anyone who can pull or inspect it, PERMANENTLY -- it cannot be "removed later"; secrets belong in environment variables supplied at `docker run`/`docker compose up` time instead.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'production-docker-for-java-applications'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It is automatically stripped out of the image the next time `docker build` runs$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$It only becomes readable if the image is explicitly pushed to a public registry like Docker Hub$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$It is safely encrypted at rest inside the image, unreadable without a separate decryption key$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$It becomes a permanent part of the image's own layers, readable by anyone who can pull or inspect it -- it cannot be removed later$$, TRUE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$'Basic Image Security Considerations'a göre, bir Dockerfile'da `ENV` ile ayarlanan gerçek bir sır (bir şifre gibi), o değer daha sonra 'değiştirilse' bile, ona ne olur?$$,
           NULL, NULL,
           $$Ders, ENV ile ayarlanan ya da bir Dockerfile'da sabit kodlanan gerçek bir sırın, imajı çekebilen ya da inceleyebilen herkes tarafından okunabilir şekilde imajın kendi katmanlarının KALICI bir parçası olduğunu açıkça belirtir -- 'daha sonra kaldırılamaz'; sırlar bunun yerine `docker run`/`docker compose up` zamanında sağlanan ortam değişkenlerine aittir.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'production-docker-for-java-applications'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İmaj içinde, ayrı bir şifre çözme anahtarı olmadan okunamayacak şekilde güvenli bir şekilde şifrelenir$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$İmajı çekebilen ya da inceleyebilen herkes tarafından okunabilir şekilde, imajın kendi katmanlarının kalıcı bir parçası olur -- daha sonra kaldırılamaz$$, TRUE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Bir sonraki `docker build` çalıştığında imajdan otomatik olarak çıkarılır$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Yalnızca imaj açıkça Docker Hub gibi herkese açık bir registry'ye push edilirse okunabilir hale gelir$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this multi-stage Dockerfile's builder stage, if only a single Java file in `src/` changes (nothing in `pom.xml`) and the image is rebuilt, which layer(s) actually re-run?$$,
           $$COPY pom.xml .
RUN mvn -B dependency:go-offline

COPY src ./src
RUN mvn -B package -DskipTests$$, $$dockerfile$$,
           $$The lesson explains Docker caches each layer and reuses it as long as nothing that layer depends on has changed -- since only a file inside src/ changed and pom.xml didn't, the `COPY pom.xml .` and `RUN mvn dependency:go-offline` layers are reused from cache, and only `COPY src ./src` and everything after it re-run.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'production-docker-for-java-applications'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Only `COPY src ./src` and `RUN mvn -B package -DskipTests` re-run -- the `pom.xml` copy and dependency download are reused from cache$$, TRUE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$All four instructions re-run from scratch, including re-downloading every dependency `pom.xml` declares$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Nothing re-runs at all -- Docker considers the entire builder stage permanently cached once built the first time$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Only `RUN mvn -B dependency:go-offline` re-runs, since that's the layer responsible for compiling Java source files$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu multi-stage Dockerfile'ın builder aşaması göz önüne alındığında, `src/` içinde yalnızca tek bir Java dosyası değişirse (pom.xml'de hiçbir şey değişmezse) ve imaj yeniden inşa edilirse, hangi katman(lar) gerçekten yeniden çalışır?$$,
           $$COPY pom.xml .
RUN mvn -B dependency:go-offline

COPY src ./src
RUN mvn -B package -DskipTests$$, $$dockerfile$$,
           $$Ders, Docker'ın her katmanı önbelleğe aldığını ve o katmanın bağlı olduğu hiçbir şey değişmediği sürece onu yeniden kullandığını açıklar -- yalnızca src/ içindeki bir dosya değişip pom.xml değişmediği için, `COPY pom.xml .` ve `RUN mvn dependency:go-offline` katmanları önbellekten yeniden kullanılır, ve yalnızca `COPY src ./src` ve ondan sonraki her şey yeniden çalışır.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'production-docker-for-java-applications'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hiçbir şey yeniden çalışmaz -- Docker, ilk inşa edildiğinde tüm builder aşamasını kalıcı olarak önbelleğe alınmış sayar$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Yalnızca `RUN mvn -B dependency:go-offline` yeniden çalışır, çünkü Java kaynak dosyalarını derlemekten sorumlu katman odur$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Yalnızca `COPY src ./src` ve `RUN mvn -B package -DskipTests` yeniden çalışır -- pom.xml kopyalama ve bağımlılık indirme önbellekten yeniden kullanılır$$, TRUE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Dört talimatın hepsi sıfırdan yeniden çalışır, pom.xml'in bildirdiği her bağımlılığın yeniden indirilmesi dahil$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Does adding a `healthcheck:` to a Compose `db` service automatically make Compose wait for it before starting `app`, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states a HEALTHCHECK/healthcheck alone only provides visibility (docker ps status) -- it's the long-form `depends_on: db: condition: service_healthy` that actually makes Compose wait for the healthcheck to succeed before starting the dependent service; adding a healthcheck but never referencing it with `condition: service_healthy` is explicitly named as a common mistake.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'production-docker-for-java-applications'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$This lesson doesn't cover any relationship between `healthcheck:` and `depends_on` at all$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$No -- a healthcheck alone only provides visibility; `depends_on: db: condition: service_healthy` is what actually makes `app` wait for it$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Yes -- any `healthcheck:` defined on a service is automatically waited on by every other service in the same file$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Yes, but only if the service is named `db` specifically -- any other name is ignored by Compose entirely$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir Compose `db` servisine bir `healthcheck:` eklemek, Compose'un `app`'i başlatmadan önce onu otomatik olarak beklemesini sağlar mı?$$,
           NULL, NULL,
           $$Ders, tek başına bir HEALTHCHECK/healthcheck'in yalnızca görünürlük (docker ps durumu) sağladığını belirtir -- Compose'un bağımlı servisi başlatmadan önce healthcheck'in başarılı olmasını gerçekten beklemesini sağlayan şey, uzun biçimli `depends_on: db: condition: service_healthy`'dir; bir healthcheck eklemek ama onu `condition: service_healthy` ile hiç referans vermemek açıkça yaygın bir hata olarak adlandırılır.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'production-docker-for-java-applications'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Evet -- bir serviste tanımlanan herhangi bir `healthcheck:`, aynı dosyadaki her diğer servis tarafından otomatik olarak beklenir$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Evet, ama yalnızca servis özellikle `db` olarak adlandırılmışsa -- başka herhangi bir ad Compose tarafından tamamen yok sayılır$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Bu ders, `healthcheck:` ile `depends_on` arasında hiçbir ilişkiyi ele almaz$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Hayır -- tek başına bir healthcheck yalnızca görünürlük sağlar; `app`'in onu gerçekten beklemesini sağlayan `depends_on: db: condition: service_healthy`'dir$$, TRUE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about production Docker practices for Java applications, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson ("Basic Image Security Considerations" recommends pinning exact tags rather than `:latest`, applying just as much to production as it did in "Docker CLI Fundamentals"; the same section recommends keeping the base image and what's installed on top of it minimal, justifying every added package); the lesson doesn't claim reordering `COPY src ./src` before the dependency-download step improves caching (it's explicitly named as silently undoing the layer-caching benefit), and `pg_isready` is described as a real utility already installed inside the official `postgres` image, not something this lesson's authors wrote from scratch.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'production-docker-for-java-applications'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Reordering a multi-stage Dockerfile so `COPY src ./src` happens before the dependency-download step improves Docker's layer-caching behavior$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$`pg_isready`, used in the Compose `healthcheck` example, is a custom script this lesson wrote specifically for checking PostgreSQL readiness$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Pinning exact image tags (never `:latest`), a practice already covered in "Docker CLI Fundamentals," is stated to apply just as much in production$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Keeping the base image and what's installed on top of it minimal -- justifying every added package -- is one of this lesson's basic image security considerations$$, TRUE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, Java uygulamaları için production Docker pratikleri hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir ('Basic Image Security Considerations'ın, 'Docker CLI Fundamentals'ta zaten ele alınan, `:latest` değil kesin tag'leri sabitlemenin production'da da aynı derecede geçerli olduğunu önermesi; aynı bölümün, temel imajı ve üzerine kurulanları minimal tutmayı, eklenen her paketi gerekçelendirmeyi önermesi); ders, `COPY src ./src`'i bağımlılık-indirme adımından önceye almanın Docker'ın layer-caching davranışını iyileştirdiğini iddia etmez (bunun aksine, layer-caching faydasını sessizce bozduğu açıkça adlandırılır), ve `pg_isready`'nin bu dersin yazarlarının PostgreSQL hazır olma durumunu kontrol etmek için sıfırdan yazdığı özel bir betik değil, resmi `postgres` imajı içinde zaten kurulu gerçek bir araç olduğu tanımlanır.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'production-docker-for-java-applications'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$'Docker CLI Fundamentals'ta zaten ele alınan, kesin imaj tag'lerini sabitlemek (asla `:latest` değil) pratiğinin production'da da aynı derecede geçerli olduğu belirtilir$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Temel imajı ve üzerine kurulanları minimal tutmak -- eklenen her paketi gerekçelendirmek -- bu dersin temel imaj güvenliği değerlendirmelerinden biridir$$, TRUE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir multi-stage Dockerfile'ı, `COPY src ./src` bağımlılık-indirme adımından önce gerçekleşecek şekilde yeniden sıralamak Docker'ın layer-caching davranışını iyileştirir$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Compose `healthcheck` örneğinde kullanılan `pg_isready`, bu dersin PostgreSQL'in hazır olma durumunu kontrol etmek için özellikle yazdığı özel bir betiktir$$, FALSE, 3 FROM new_question_tr6;
