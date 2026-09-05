-- Promotion batch
-- Topic: docker-volumes (language: en x6, tr x6)
-- Generated: 2026-09-05 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 12 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/docker-volumes.md and content/tr/docker-volumes.md -- NOT produced by n8n,
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
           $$Why does removing a container with no volume configured permanently delete the data it wrote, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states everything a running container writes lives in that container's own writable layer, sitting on top of the read-only image -- that layer is part of the container itself, so `docker rm` deletes it along with everything else about that specific container instance.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-volumes'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Because `docker rm` always deletes every image and volume on the entire host machine, not just one container$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$Because containers are not actually allowed to write any data to disk in the first place$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Because the data is automatically uploaded to Docker Hub and only accessible there afterward$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$Because everything the container writes lives in its own writable layer, which `docker rm` deletes along with the rest of the container$$, TRUE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, hiçbir volume yapılandırılmamış bir container'ı kaldırmak yazdığı veriyi neden kalıcı olarak siler?$$,
           NULL, NULL,
           $$Ders, çalışan bir container'ın yazdığı her şeyin, salt-okunur imajın üzerinde oturan kendi writable katmanında yaşadığını belirtir -- bu katman container'ın kendisinin bir parçasıdır, bu yüzden `docker rm` onu o spesifik container örneğiyle ilgili diğer her şeyle birlikte siler.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-volumes'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çünkü veri otomatik olarak Docker Hub'a yüklenir ve sonrasında yalnızca orada erişilebilir olur$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Çünkü container'ın yazdığı her şey kendi writable katmanında yaşar, bunu `docker rm` container'ın geri kalanıyla birlikte siler$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Çünkü `docker rm` her zaman tüm host makinedeki her imajı ve volume'u siler, yalnızca bir container'ı değil$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Çünkü container'ların diske hiçbir veri yazmasına baştan izin verilmez$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Does a named volume created with `docker volume create` depend on any single container that will eventually use it, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states creating a named volume is a single command, independent of any container that will eventually use it -- because a volume exists independently, it survives exactly the event that destroys a container's own writable layer: `docker rm`.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-volumes'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$No -- a named volume exists independently of any single container, and survives `docker rm` for exactly that reason$$, TRUE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Yes -- a named volume is permanently deleted the moment the container using it is removed$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Yes -- a named volume can only ever be attached to exactly the one container that originally created it$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$No, but only for volumes used by the official `postgres` image specifically$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `docker volume create` ile oluşturulan bir named volume, sonunda onu kullanacak herhangi bir tek container'a bağımlı mıdır?$$,
           NULL, NULL,
           $$Ders, bir named volume oluşturmanın, sonunda onu kullanacak herhangi bir container'dan bağımsız, tek bir komut olduğunu belirtir -- bir volume bağımsız var olduğu için, tam olarak bir container'ın kendi writable katmanını yok eden olayı, yani `docker rm`'i atlatır.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-volumes'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Evet -- bir named volume yalnızca onu orijinal olarak oluşturan o tek container'a bağlanabilir$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Hayır, ama yalnızca özellikle resmi `postgres` imajı tarafından kullanılan volume'lar için$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Hayır -- bir named volume herhangi bir tek container'dan bağımsız var olur, ve tam olarak bu nedenle `docker rm`'i atlatır$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Evet -- bir named volume, onu kullanan container kaldırılır kaldırılmaz kalıcı olarak silinir$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why does the volume in `-v learning-platform-db-data:/var/lib/postgresql/data` specifically need to be mounted at `/var/lib/postgresql/data`, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states `/var/lib/postgresql/data` isn't an arbitrary path -- it's exactly where the official `postgres` image stores its actual database files by default; mounting a volume at that specific path is what separates a container whose data disappears when removed from one whose data outlives it.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-volumes'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Because `/var/lib/postgresql/data` is required by `docker volume create`'s own internal implementation$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Because that's exactly where the official `postgres` image stores its actual database files by default -- mounting anywhere else wouldn't capture that data$$, TRUE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$The path is arbitrary -- any path at all works identically for capturing PostgreSQL's data$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Because Docker itself hardcodes that exact path for every volume mount, regardless of image$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `-v ogrenme-platformu-db-verisi:/var/lib/postgresql/data`'daki volume neden özellikle `/var/lib/postgresql/data`'ya mount edilmesi gerekiyor?$$,
           NULL, NULL,
           $$Ders, `/var/lib/postgresql/data`'nın keyfi bir yol olmadığını -- resmi `postgres` imajının gerçek veritabanı dosyalarını varsayılan olarak tam olarak orada depoladığını belirtir; bir volume'u tam olarak o yola mount etmek, kaldırıldığında verisi kaybolan bir container ile verisi kalıcı olan bir container'ı birbirinden ayıran şeydir.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-volumes'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yol keyfidir -- PostgreSQL'in verisini yakalamak için herhangi bir yol tamamen aynı şekilde çalışır$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Çünkü Docker'ın kendisi, imajdan bağımsız olarak her volume mount'u için tam olarak o yolu sabit kodlar$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Çünkü `/var/lib/postgresql/data`, `docker volume create`'in kendi iç uygulaması tarafından gereklidir$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Çünkü resmi `postgres` imajı gerçek veritabanı dosyalarını varsayılan olarak tam olarak orada depolar -- başka bir yere mount etmek o veriyi yakalamaz$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this sequence, if `learning-platform-db-data` is a properly mounted named volume, what does the final `SELECT` return?$$,
           $$docker exec -it learning-platform-db psql -U postgres -c "INSERT INTO proof (note) VALUES ('still here');"

docker stop learning-platform-db
docker rm learning-platform-db

docker run --name learning-platform-db -v learning-platform-db-data:/var/lib/postgresql/data -d postgres:16

docker exec -it learning-platform-db psql -U postgres -c "SELECT * FROM proof;"$$, $$bash$$,
           $$The lesson describes this exact sequence as the real test of a volume working: because the data lived in the volume (not the removed container's writable layer), the new container mounted against the same volume picks up right where the previous one left off -- the row with "still here" is returned.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-volumes'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$An error, since a new container can never be started with the same `--name` as a removed one$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$An error, since `-v` cannot be combined with `--name` in the same `docker run` command$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$The row containing "still here" -- the volume, not the container, was where the data actually lived the whole time$$, TRUE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$An empty result -- `docker rm` also deletes any volume that was mounted into the removed container$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu sıralama göz önüne alındığında, eğer `kurs-db-verisi` düzgün mount edilmiş bir named volume ise, son `SELECT` ne döndürür?$$,
           $$docker exec -it kurs-veritabani psql -U postgres -c "INSERT INTO kanit (not) VALUES ('hala burada');"

docker stop kurs-veritabani
docker rm kurs-veritabani

docker run --name kurs-veritabani -v kurs-db-verisi:/var/lib/postgresql/data -d postgres:16

docker exec -it kurs-veritabani psql -U postgres -c "SELECT * FROM kanit;"$$, $$bash$$,
           $$Ders, bu tam sıralamayı bir volume'un gerçekten çalışıp çalışmadığının gerçek testi olarak tanımlar: veri (kaldırılan container'ın writable katmanında değil) volume'da yaşadığı için, aynı volume'a karşı mount edilen yeni container tam olarak öncekinin bıraktığı yerden devam eder -- 'hala burada' içeren satır döner.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-volumes'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$'hala burada' içeren satır -- verinin gerçekte tüm süre boyunca yaşadığı yer container değil, volume'du$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Boş bir sonuç -- `docker rm`, kaldırılan container'a mount edilmiş herhangi bir volume'u da siler$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Bir hata, çünkü yeni bir container asla kaldırılmış birininkiyle aynı `--name` ile başlatılamaz$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Bir hata, çünkü `-v`, aynı `docker run` komutunda `--name` ile birleştirilemez$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$According to "Named Volumes vs. Bind Mounts," when is a bind mount the right tool instead of a named volume?$$,
           NULL, NULL,
           $$The lesson states a bind mount is for when a specific host path matters -- like mounting a project's own source code into a container during local development -- while a named volume is for data a container manages and Docker should own the lifecycle of, exactly PostgreSQL's own data files.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-volumes'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Whenever a database's data files need to persist across container restarts -- a bind mount is always preferred there$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Never -- this lesson recommends using only named volumes for every possible use case$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Only when the container is running the official `postgres` image specifically$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$When a specific host path matters, such as mounting a project's own source code into a container during local development$$, TRUE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$'Named Volumes vs. Bind Mounts'a göre, bir named volume yerine bir bind mount ne zaman doğru araçtır?$$,
           NULL, NULL,
           $$Ders, bir bind mount'un, yerel geliştirme sırasında bir projenin kendi kaynak kodunu bir container'a mount etmek gibi, spesifik bir host yolunun önemli olduğu durumlar için olduğunu belirtir -- bir named volume ise, tam olarak PostgreSQL'in kendi veri dosyaları gibi, bir container'ın yönettiği ve Docker'ın yaşam döngüsüne sahip olması gereken veriler içindir.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-volumes'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca container özellikle resmi `postgres` imajını çalıştırıyorsa$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Yerel geliştirme sırasında bir projenin kendi kaynak kodunu bir container'a mount etmek gibi, spesifik bir host yolunun önemli olduğu durumlarda$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Bir veritabanının veri dosyalarının container yeniden başlatmaları arasında kalıcı olması gerektiğinde her zaman -- orada her zaman bir bind mount tercih edilir$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Asla -- bu ders her olası kullanım durumu için yalnızca named volume kullanılmasını önerir$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about Docker volumes, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (`docker volume rm` only succeeds if no container currently has that volume mounted, and it's the one command that genuinely, deliberately destroys persisted data; `docker stop`/`docker start` on the same container don't touch its writable layer, so data written there survives a stop/start cycle); the lesson does not claim `docker stop` deletes any data (it explicitly says stopping and restarting the same container leaves the data intact), and it explicitly recommends named volumes, not bind mounts, for a database's own data directory.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-volumes'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`docker volume rm` only succeeds if no container currently has that volume mounted, and it genuinely, permanently destroys the volume's data$$, TRUE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$`docker stop` followed by `docker start` on the same container does not touch that container's writable layer -- data written there survives the cycle$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Running `docker stop` on a container immediately and permanently deletes any data written to its writable layer$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$This lesson recommends a bind mount, not a named volume, specifically for a database's own data directory$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, Docker volume'ları hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (`docker volume rm`'in yalnızca o volume şu anda hiçbir container'a mount edilmemişse başarılı olması, ve bunun kalıcı verileri gerçekten, bilerek yok eden tek komut olması; aynı container üzerinde `docker stop`'un ardından `docker start`'ın o container'ın writable katmanına dokunmaması, orada yazılan verinin döngüyü atlatması); ders `docker stop`'un herhangi bir veriyi sildiğini iddia etmez (aynı container'ı durdurup yeniden başlatmanın veriyi olduğu gibi bıraktığını açıkça belirtir), ve özellikle bir veritabanının kendi veri dizini için bind mount değil named volume önerir.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-volumes'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir container üzerinde `docker stop` çalıştırmak, onun writable katmanına yazılan her veriyi hemen ve kalıcı olarak siler$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Bu ders, özellikle bir veritabanının kendi veri dizini için bind mount önerir, named volume değil$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$`docker volume rm`, yalnızca o volume şu anda hiçbir container'a mount edilmemişse başarılı olur, ve volume'ün verisini gerçekten, kalıcı olarak yok eder$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Aynı container üzerinde `docker stop`'un ardından `docker start` çalıştırmak, o container'ın writable katmanına dokunmaz -- orada yazılan veri döngüyü atlatır$$, TRUE, 3 FROM new_question_tr6;
