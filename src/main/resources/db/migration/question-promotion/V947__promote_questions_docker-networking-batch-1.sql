-- Promotion batch
-- Topic: docker-networking (language: en x6, tr x6)
-- Generated: 2026-09-05 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 12 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/docker-networking.md and content/tr/docker-networking.md -- NOT produced by n8n,
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
           $$Can two containers on Docker's default bridge network reach each other by container name, according to this lesson?$$,
           NULL, NULL,
           $$The lesson is explicit with a warning: containers on Docker's default bridge network CANNOT reach each other by container name -- only by IP address, which changes every time a container restarts. This is a genuine, documented Docker limitation; the fix is a user-defined network.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-networking'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$No -- they can only reach each other by IP address on the default bridge network, and that IP changes on every restart$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Yes -- name-based resolution works automatically on every network Docker creates, including the default bridge$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Yes, but only if `EXPOSE` is set in both containers' Dockerfiles$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$No -- containers on the default bridge network cannot communicate with each other at all, by any means$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, Docker'ın default bridge network'ündeki iki container birbirine container adıyla ulaşabilir mi?$$,
           NULL, NULL,
           $$Ders bir uyarıyla açıktır: Docker'ın default bridge network'ündeki container'lar birbirine container adıyla ULAŞAMAZ -- yalnızca her yeniden başlatmada değişen bir IP adresiyle ulaşabilirler. Bu gerçek, belgelenmiş bir Docker kısıtlamasıdır; çözüm bir user-defined network'tür.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-networking'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Evet, ama yalnızca her iki container'ın Dockerfile'ında da `EXPOSE` ayarlanmışsa$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Hayır -- default bridge network'teki container'lar birbiriyle hiçbir şekilde iletişim kuramaz$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Hayır -- default bridge network'te birbirlerine yalnızca her yeniden başlatmada değişen bir IP adresiyle ulaşabilirler$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Evet -- ada dayalı çözümleme, default bridge dahil Docker'ın oluşturduğu her ağda otomatik olarak çalışır$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What does `-p <host-port>:<container-port>` actually solve, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states `-p` is specifically a host-to-container bridge -- it maps a port on the host machine to a port inside a container's own isolated network namespace; it has nothing to do with how two containers reach each other, which is a completely separate concern.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-networking'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It automatically creates a user-defined network for every container it's applied to$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$It bridges the host machine to a container's port -- it has nothing to do with how two containers reach each other$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$It's exactly how two containers on the same network resolve each other by name$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$It permanently disables a container's access to the outside internet$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `-p <host-port>:<container-port>` gerçekte neyi çözer?$$,
           NULL, NULL,
           $$Ders, `-p`'nin özellikle bir host-to-container köprüsü olduğunu belirtir -- host makinedeki bir portu, bir container'ın kendi izole ağ namespace'i içindeki bir porta eşler; iki container'ın birbirine nasıl ulaştığıyla hiçbir ilgisi yoktur, bu tamamen ayrı bir konudur.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-networking'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Aynı ağdaki iki container'ın birbirini ada göre çözümlemesinin tam olarak yoludur$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Bir container'ın dış internete erişimini kalıcı olarak devre dışı bırakır$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Uygulandığı her container için otomatik olarak bir user-defined network oluşturur$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Host makineyi bir container'ın portuna köprüler -- iki container'ın birbirine nasıl ulaştığıyla hiçbir ilgisi yoktur$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does creating a user-defined network with `docker network create` provide that the default bridge network doesn't, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states a user-defined bridge network comes with automatic DNS-based name resolution between the containers attached to it -- Docker runs an embedded DNS server specifically so one container can reach another using the other container's `--name` as a hostname.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-networking'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Automatic encryption of all traffic between every container attached to it$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$The ability to run containers without needing Docker itself installed on the host machine$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Automatic DNS-based name resolution between attached containers -- one container can reach another using its `--name` as a hostname$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Automatically faster network throughput compared to any container on the default bridge network$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `docker network create` ile bir user-defined network oluşturmak, default bridge network'ün sağlamadığı neyi sağlar?$$,
           NULL, NULL,
           $$Ders, bir user-defined bridge network'ün, ona bağlı container'lar arasında otomatik DNS tabanlı ad çözümlemesiyle geldiğini belirtir -- Docker, özellikle bir container'ın diğerine `--name`'ini bir hostname olarak kullanarak ulaşabilmesi için gömülü bir DNS sunucusu çalıştırır.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-networking'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bağlı container'lar arasında otomatik DNS tabanlı ad çözümlemesi -- bir container diğerine `--name`'ini bir hostname olarak kullanarak ulaşabilir$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Default bridge network'teki herhangi bir container'a kıyasla otomatik olarak daha hızlı ağ verimi$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Ona bağlı her container arasındaki tüm trafiğin otomatik şifrelenmesi$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Host makinede Docker'ın kendisi kurulu olmadan container çalıştırabilme yeteneği$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this JDBC URL, running inside an `app` container that is attached to the same user-defined network as a `db` container, what does `learning-platform-db` resolve to?$$,
           $$docker run --name learning-platform-app \
  --network learning-platform-net \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://learning-platform-db:5432/postgres \
  -d learning-platform:0.1.0$$, $$bash$$,
           $$The lesson explains that `learning-platform-db` in this JDBC URL isn't a real internet DNS hostname -- it resolves only inside `learning-platform-net`, to whatever container is currently running with that `--name` on that same user-defined network, thanks to Docker's embedded DNS server.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-networking'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The host machine's own loopback interface, exactly the same as `localhost` would inside this container$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$A real, public internet hostname that any machine outside Docker could also resolve$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Nothing -- this URL will always fail to resolve unless `-p` is also used to publish a port$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Whatever container is currently running with the `--name` `learning-platform-db` on the same `learning-platform-net` network$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu JDBC URL'si, bir `db` container'ıyla aynı user-defined network'e bağlı bir `app` container'ının içinde çalıştırıldığında, `kurs-veritabani` neyi çözümler?$$,
           $$docker run --name kurs-uygulamasi \
  --network kurs-net \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://kurs-veritabani:5432/postgres \
  -d kurs-platformu:1.0$$, $$bash$$,
           $$Ders, bu JDBC URL'sindeki `kurs-veritabani`nın gerçek bir internet DNS hostname'i olmadığını açıklar -- yalnızca `kurs-net` içinde, Docker'ın gömülü DNS sunucusu sayesinde, aynı user-defined network üzerinde şu anda o `--name` ile çalışan hangi container'sa ona çözümlenir.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-networking'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hiçbir şey -- bir port yayınlamak için `-p` de kullanılmadıkça bu URL her zaman çözümlenmeyi başaramaz$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Aynı `kurs-net` ağı üzerinde şu anda `kurs-veritabani` `--name`'iyle çalışan hangi container'sa o$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Host makinenin kendi loopback arayüzü, tıpkı bu container içinde `localhost`un olacağı gibi$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Docker dışındaki herhangi bir makinenin de çözümleyebileceği gerçek, herkese açık bir internet hostname'i$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Inside a container, what does `localhost` (or `127.0.0.1`) refer to, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states every container gets its own, isolated network namespace, so `localhost` inside a container refers to that container's own loopback interface -- not the host machine's, and not any other container's; this is exactly why reaching another container requires using its `--name`, not `localhost`.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-networking'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$That container's own loopback interface -- never the host machine's, and never another container's$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$The host machine's loopback interface, exactly the same as it would on a non-containerized process$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Whichever other container was most recently started on the same network$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$A dynamically chosen container, selected by Docker's embedded DNS server at random$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir container içinde `localhost` (ya da `127.0.0.1`) neyi ifade eder?$$,
           NULL, NULL,
           $$Ders, her container'ın kendi izole ağ namespace'ini aldığını, bu yüzden bir container içindeki `localhost`un o container'ın kendi loopback arayüzünü ifade ettiğini belirtir -- host makinenin değil, başka herhangi bir container'ın da değil; başka bir container'a ulaşmanın `localhost` değil, onun `--name`'ini kullanmayı gerektirmesinin tam nedeni budur.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-networking'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Aynı ağda en son başlatılan hangi diğer container'sa o$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Docker'ın gömülü DNS sunucusu tarafından rastgele seçilen, dinamik olarak belirlenen bir container$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$O container'ın kendi loopback arayüzü -- asla host makinenin değil, asla başka bir container'ın değil$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Konteynerize edilmemiş bir süreçte olacağı gibi, tam olarak host makinenin loopback arayüzü$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about Docker networking, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (`docker network inspect <name>` shows exactly which containers are currently attached to a given network, the fastest way to confirm two containers are on the same one; `host.docker.internal` reaches a service on the host machine, a fundamentally different situation from two containers reaching each other by name); the lesson explicitly frames `-p` and `--network` as solving different problems, not as interchangeable, and it names the user-defined network -- not the default bridge -- as what every real multi-container setup, including Docker Compose, actually uses.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-networking'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Every real multi-container setup, including Docker Compose, is described in this lesson as relying on Docker's default bridge network$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$`docker network inspect <name>` shows exactly which containers are currently attached to a given network$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$`host.docker.internal` (reaching the host machine) and a container's `--name` on a user-defined network (reaching another container) solve two different problems$$, TRUE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$`-p` and `--network` solve the exact same problem and can always be used interchangeably$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, Docker networking hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (`docker network inspect <ad>`'ın belirli bir ağa şu anda hangi container'ların bağlı olduğunu tam olarak göstermesi, iki container'ın aynı ağda olup olmadığını doğrulamanın en hızlı yolu olması; `host.docker.internal`'in host makinedeki bir servise ulaşmasının, iki container'ın birbirine adla ulaşmasından temelde farklı bir durum olması); ders `-p` ile `--network`'ü birbirinin yerine geçebilir değil, farklı problemleri çözen şeyler olarak açıkça çerçeveler, ve Docker Compose dahil her gerçek çoklu-container kurulumunun aslında default bridge'i değil user-defined network'ü kullandığını adlandırır.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-networking'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`host.docker.internal` (host makineye ulaşmak) ve bir container'ın user-defined network üzerindeki `--name`'i (başka bir container'a ulaşmak) iki farklı problemi çözer$$, TRUE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$`-p` ve `--network` tamamen aynı problemi çözer ve her zaman birbirinin yerine kullanılabilir$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Docker Compose dahil her gerçek çoklu-container kurulumu, bu derste Docker'ın default bridge network'üne güvendiği şeklinde tanımlanır$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$`docker network inspect <ad>`, belirli bir ağa şu anda hangi container'ların bağlı olduğunu tam olarak gösterir$$, TRUE, 3 FROM new_question_tr6;
