-- Promotion batch
-- Topic: docker-compose (language: en x6, tr x6)
-- Generated: 2026-09-05 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 12 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/docker-compose.md and content/tr/docker-compose.md -- NOT produced by n8n,
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
           $$What does Docker Compose fundamentally do, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states Compose reads a YAML file describing a set of related containers (services) and brings all of them up, or tears all of them down, with one command each -- nothing about the underlying mechanism changes, it just derives network/volume/container creation from one file instead of requiring each command to be typed separately.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-compose'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It's a tool exclusively for building Dockerfiles, unrelated to running containers$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$It automatically writes Java source code based on a project's dependencies$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It reads a YAML file describing a set of services and brings them all up (or down) with one command each, instead of typing each `docker` command by hand$$, TRUE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$It replaces the Docker Engine entirely with a completely different container runtime$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, Docker Compose temelde ne yapar?$$,
           NULL, NULL,
           $$Ders, Compose'un bir dizi ilişkili container'ı (servisleri) tanımlayan bir YAML dosyasını okuduğunu ve hepsini bir komutla ayağa kaldırdığını ya da hepsini bir komutla söktüğünü belirtir -- altta yatan mekanizmada hiçbir şey değişmez, yalnızca ağ/volume/container oluşturmayı, her komutun ayrı ayrı elle yazılmasını gerektirmek yerine tek bir dosyadan türetir.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-compose'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir dizi servisi tanımlayan bir YAML dosyasını okur ve her `docker` komutunu elle yazmak yerine hepsini bir komutla ayağa kaldırır (ya da indirir)$$, TRUE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Docker Engine'i tamamen farklı bir container runtime'ıyla tümüyle değiştirir$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Yalnızca Dockerfile inşa etmek için bir araçtır, container çalıştırmakla ilgisi yoktur$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir projenin bağımlılıklarına dayanarak otomatik olarak Java kaynak kodu yazar$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A `docker-compose.yml`'s `db` service lists `db-data:/var/lib/postgresql/data` under its `volumes:` key, but `db-data` is never declared anywhere else in the file. What happens, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states a named volume referenced in a service's `volumes:` list has to be declared once at the file's top level -- a service can't invent a volume name Compose hasn't been told about anywhere else in the file; this is explicitly named as a common mistake.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-compose'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Nothing -- Compose automatically infers and declares any volume name it sees referenced by a service$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Compose silently falls back to using a bind mount instead of a named volume in this situation$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$This is fine as long as the service using it is named `db` specifically$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$This is a problem -- a service can't reference a volume name that was never declared at the file's top-level `volumes:` section$$, TRUE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir `docker-compose.yml`'in `db` servisi, `volumes:` anahtarı altında `db-data:/var/lib/postgresql/data`'yı listeliyor, ama `db-data` dosyanın başka hiçbir yerinde hiç tanımlanmıyor. Bu derse göre ne olur?$$,
           NULL, NULL,
           $$Ders, bir servisin `volumes:` listesinde referans verilen bir named volume'un dosyanın en üst seviyesinde bir kez tanımlanması gerektiğini belirtir -- bir servis, Compose'a dosyanın başka hiçbir yerinde söylenmemiş bir volume adı icat edemez; bu açıkça yaygın bir hata olarak adlandırılır.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-compose'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bu, onu kullanan servis özellikle `db` olarak adlandırılmışsa sorun değildir$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Bu bir problemdir -- bir servis, dosyanın en üst seviyedeki `volumes:` bölümünde hiç tanımlanmamış bir volume adına referans veremez$$, TRUE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Hiçbir şey -- Compose, bir servis tarafından referans verildiğini gördüğü herhangi bir volume adını otomatik olarak çıkarır ve tanımlar$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Compose bu durumda sessizce bir named volume yerine bir bind mount kullanmaya geçer$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Does `depends_on: [db]` guarantee that PostgreSQL inside the `db` container is actually ready to accept connections before `app` starts, according to this lesson?$$,
           NULL, NULL,
           $$The lesson explicitly warns that `depends_on` on its own only waits for the `db` container to START, not for PostgreSQL inside it to actually be ready to accept connections -- a slow-starting database can still cause `app` to fail its first connection attempt even with `depends_on` in place.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-compose'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$No -- it only waits for the `db` container to start, not for PostgreSQL inside it to actually be ready to accept connections$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Yes -- `depends_on` always waits for the full application inside a dependency to be completely ready before starting the next service$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Yes, but only for services using the official `postgres` image specifically$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$This lesson doesn't address readiness at all -- `depends_on` is described as having no effect on startup order whatsoever$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `depends_on: [db]`, `app` başlamadan önce `db` container'ı içindeki PostgreSQL'in gerçekten bağlantı kabul etmeye hazır olduğunu garanti eder mi?$$,
           NULL, NULL,
           $$Ders, `depends_on`'un tek başına yalnızca `db` container'ının BAŞLAMASINI beklediğini, içindeki PostgreSQL'in gerçekten bağlantı kabul etmeye hazır olmasını beklemediğini açıkça uyarır -- yavaş başlayan bir veritabanı, `depends_on` yerinde olsa bile `app`'in ilk bağlantı denemesinde başarısız olmasına yol açabilir.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-compose'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Evet, ama yalnızca özellikle resmi `postgres` imajını kullanan servisler için$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Bu ders hazır olmayı hiç ele almaz -- `depends_on`'un başlangıç sırası üzerinde hiçbir etkisi olmadığı tanımlanır$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Hayır -- yalnızca `db` container'ının başlamasını bekler, içindeki PostgreSQL'in gerçekten bağlantı kabul etmeye hazır olmasını değil$$, TRUE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Evet -- `depends_on`, bir sonraki servisi başlatmadan önce her zaman bir bağımlılığın içindeki tüm uygulamanın tamamen hazır olmasını bekler$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this `docker-compose.yml` excerpt, what hostname does the `app` service use to reach PostgreSQL, and why does it work without any `docker network create` command?$$,
           $$services:
  db:
    image: postgres:16
    environment:
      POSTGRES_PASSWORD: secret
  app:
    build: .
    depends_on:
      - db
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://db:5432/postgres$$, $$yaml$$,
           $$The lesson explains every service in one docker-compose.yml is automatically placed on the same, Compose-created network, and each service's name becomes its hostname for every other service in that file -- no manual `docker network create` or `--network` required, which is exactly why `db:5432` resolves here.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-compose'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It cannot work at all without an explicit `docker network create` command run before `docker compose up`$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$`db` -- Compose automatically places every service in one file on the same network, where each service's name becomes its hostname$$, TRUE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$`localhost` -- Compose always rewrites service hostnames to `localhost` internally before starting containers$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$The service's actual container ID -- Compose has no concept of hostnames at all, only raw container IDs$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu `docker-compose.yml` alıntısı göz önüne alındığında, `app` servisi PostgreSQL'e ulaşmak için hangi hostname'i kullanır, ve neden hiçbir `docker network create` komutu olmadan çalışır?$$,
           $$services:
  veritabani:
    image: postgres:16
    environment:
      POSTGRES_PASSWORD: gizli
  uygulama:
    build: .
    depends_on:
      - veritabani
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://veritabani:5432/postgres$$, $$yaml$$,
           $$Ders, tek bir docker-compose.yml'deki her servisin otomatik olarak Compose'un oluşturduğu aynı ağa yerleştirildiğini, ve her servisin adının o dosyadaki her diğer servis için hostname'i haline geldiğini açıklar -- hiçbir elle `docker network create` ya da `--network` gerekmez, `veritabani:5432`'nin burada çözümlenmesinin tam nedeni budur.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-compose'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`localhost` -- Compose, container'ları başlatmadan önce servis hostname'lerini her zaman içsel olarak `localhost`a yeniden yazar$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Servisin gerçek container ID'si -- Compose'un hostname kavramı hiç yoktur, yalnızca ham container ID'leri vardır$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$`docker compose up`'tan önce çalıştırılan açık bir `docker network create` komutu olmadan hiç çalışamaz$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$`veritabani` -- Compose, tek bir dosyadaki her servisi otomatik olarak aynı ağa yerleştirir, burada her servisin adı onun hostname'i haline gelir$$, TRUE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Does plain `docker compose down` (no flags) remove the named volumes declared in the Compose file, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states `docker compose down` deliberately does NOT touch named volumes by default -- a volume is meant to outlive routine container lifecycle events, and down treats itself as an ordinary teardown, not a data-destroying one; `docker compose down -v` is the explicit opt-in to remove volumes too.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-compose'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yes, but only for volumes attached to a service named `db` specifically$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$This lesson doesn't specify volume behavior for `docker compose down` at all$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$No -- plain `docker compose down` deliberately leaves named volumes intact by default; `-v` is the explicit opt-in to remove them too$$, TRUE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Yes -- `docker compose down` always removes every named volume declared in the file, with no way to prevent it$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, sade `docker compose down` (bayraksız), Compose dosyasında tanımlanan named volume'ları kaldırır mı?$$,
           NULL, NULL,
           $$Ders, `docker compose down`'un varsayılan olarak named volume'lara BİLEREK dokunmadığını belirtir -- bir volume'ün sıradan container yaşam döngüsü olaylarını atlatması amaçlanmıştır, ve down kendisini veri yok eden değil sıradan bir söküm olarak ele alır; `docker compose down -v`, volume'ları da kaldırmak için açık bir tercihtir.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-compose'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hayır -- sade `docker compose down`, named volume'ları varsayılan olarak bilerek olduğu gibi bırakır; `-v` onları da kaldırmak için açık bir tercihtir$$, TRUE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Evet -- `docker compose down`, dosyada tanımlanan her named volume'u önlemenin hiçbir yolu olmadan her zaman kaldırır$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Evet, ama yalnızca özellikle `db` adlı bir servise bağlı volume'lar için$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Bu ders, `docker compose down` için volume davranışını hiç belirtmez$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about Docker Compose, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (`build: .` tells Compose to build the project's own Dockerfile instead of pulling a pre-built image, the same effect as running `docker build` by hand; Compose prefixes a volume's real name with the project's own name at creation time, visible as e.g. `learning-platform_db-data` in `docker volume ls`); the lesson doesn't say `ports:` in Compose is unrelated to `-p` on `docker run` (it's explicitly described as the same mechanism), and it doesn't recommend hardcoding a container's manually-chosen name into a Compose service (Compose's automatic networking uses service names from the same file, not names given to containers elsewhere).$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-compose'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Compose prefixes a declared volume's real name with the project's own name at creation time (e.g. `learning-platform_db-data`, not just `db-data`)$$, TRUE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$A service's `ports:` setting in Compose is an entirely different mechanism from `-p` on `docker run`, with no real equivalence between them$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$This lesson recommends hardcoding another container's manually-chosen `--name` into a Compose service's configuration, instead of using that other service's name from the same file$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$`build: .` tells Compose to build the project's own Dockerfile instead of pulling a pre-built image, the same effect as running `docker build` by hand$$, TRUE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, Docker Compose hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (`build: .`'nin, Compose'a önceden inşa edilmiş bir imajı çekmek yerine projenin kendi Dockerfile'ını inşa etmesini söylemesi, elle `docker build` çalıştırmakla aynı etki; Compose'un, oluşturma sırasında tanımlanan bir volume'un gerçek adının önüne projenin kendi adını eklemesi, örneğin `learning-platform_db-data` olarak, yalnızca `db-data` değil); ders, Compose'daki `ports:`'un `docker run` üzerindeki `-p`'den tamamen farklı bir mekanizma olduğunu söylemez (aralarında açık bir eşdeğerlik olduğu tanımlanır), ve bir Compose servisine başka bir container'ın elle seçilmiş `--name`'ini sabit kodlamayı önermez (Compose'un otomatik ağı, başka bir yerde container'lara verilen adları değil, aynı dosyadaki servis adlarını kullanır).$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-compose'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bu ders, bir Compose servisinin yapılandırmasına, aynı dosyadaki o diğer servisin adını kullanmak yerine, başka bir container'ın elle seçilmiş `--name`'ini sabit kodlamayı önerir$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$`build: .`, Compose'a önceden inşa edilmiş bir imajı çekmek yerine projenin kendi Dockerfile'ını inşa etmesini söyler, elle `docker build` çalıştırmakla aynı etki$$, TRUE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Compose, oluşturma sırasında tanımlanan bir volume'un gerçek adının önüne projenin kendi adını ekler (örn. yalnızca `db-data` değil, `learning-platform_db-data`)$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Compose'daki bir servisin `ports:` ayarı, `docker run` üzerindeki `-p`'den tamamen farklı bir mekanizmadır, aralarında gerçek bir eşdeğerlik yoktur$$, FALSE, 3 FROM new_question_tr6;
