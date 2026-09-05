-- Promotion batch
-- Topic: docker-cli-fundamentals (language: en x7, tr x7)
-- Generated: 2026-09-05 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 14 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/docker-cli-fundamentals.md and content/tr/docker-cli-fundamentals.md -- NOT produced by n8n,
-- NOT judged by any external AI API, and NOT ingested via
-- /api/internal/questions/ingest.
--
-- Per-topic question count is FLEXIBLE (7 EN + 7 TR here), sized to this
-- lesson's actual concept density rather than a fixed target -- unlike
-- prior categories in this project, this Docker course batch deliberately
-- varies EN/TR pair count per topic (4-7) based on lesson length/depth.
--
-- Strict 50/50 EN/TR split (7+7) organized as 7 CONCEPT PAIRS -- each EN
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
           $$Running `docker pull redis` with no tag specified implicitly pulls which version, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states that omitting a tag entirely implicitly means `:latest`, which is worth naming explicitly instead of relying on -- this is exactly why "Best Practices" recommends always pulling and running a specific tag rather than the implicit latest.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-cli-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The oldest available version of the image, to guarantee maximum stability$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$It fails outright with an error, since a tag is always mandatory for `docker pull`$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Whatever version is currently installed as a dependency of another local image$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$`:latest` -- omitting a tag entirely implicitly means the `latest` tag$$, TRUE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, hiçbir tag belirtilmeden `docker pull redis` çalıştırmak örtük olarak hangi sürümü çeker?$$,
           NULL, NULL,
           $$Ders, bir tag'i tamamen atlamanın örtük olarak `:latest` anlamına geldiğini belirtir, ve buna güvenmek yerine açıkça adlandırmanın değerli olduğunu ekler -- 'Best Practices' bölümünün her zaman örtük latest yerine belirli bir tag'i çekip çalıştırmayı önermesinin tam nedeni budur.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-cli-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Başka bir yerel imajın bağımlılığı olarak şu anda kurulu olan hangi sürümse o$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$`:latest` -- bir tag'i tamamen atlamak örtük olarak `latest` tag'i anlamına gelir$$, TRUE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Maksimum kararlılığı garanti etmek için, imajın mevcut en eski sürümü$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir tag `docker pull` için her zaman zorunlu olduğu için doğrudan bir hatayla başarısız olur$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Does `docker images` reach out to Docker Hub to check for newer versions, according to this lesson?$$,
           NULL, NULL,
           $$The lesson explicitly states `docker images` is a purely local, offline listing -- it does not reach out to Docker Hub; it only lists images already pulled or built and sitting in local storage.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-cli-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$No -- `docker images` is a purely local, offline listing of what's already stored locally$$, TRUE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Yes -- it always contacts Docker Hub first to compare local images against the latest available versions$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Yes, but only if the `-a` flag is passed to it$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$It depends on whether the image was originally pulled or built locally$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `docker images` daha yeni sürümleri kontrol etmek için Docker Hub'a bağlanır mı?$$,
           NULL, NULL,
           $$Ders, `docker images`'in tamamen yerel, çevrimdışı bir listeleme olduğunu, Docker Hub'a hiç bağlanmadığını açıkça belirtir; yalnızca zaten çekilmiş veya inşa edilmiş ve yerel depolamada duran imajları listeler.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-cli-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Evet, ama yalnızca ona `-a` bayrağı verilirse$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Bu, imajın orijinal olarak çekilip çekilmediğine ya da yerel olarak inşa edilip edilmediğine bağlıdır$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Hayır -- `docker images`, zaten yerel olarak depolanmış olanların tamamen yerel, çevrimdışı bir listesidir$$, TRUE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Evet -- yerel imajları en son mevcut sürümlerle karşılaştırmak için her zaman önce Docker Hub'a bağlanır$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does the `-d` flag do on `docker run`, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states `-d` ("detached") runs the container in the background and returns the prompt immediately -- without it, `docker run` instead attaches your terminal directly to the container's output, which blocks the terminal until the container stops.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-cli-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Disables all networking for the container being started$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Runs the container in the background ("detached") and returns the terminal prompt immediately$$, TRUE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Deletes the container automatically as soon as it stops running$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Downloads the image without ever starting a container from it$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `docker run` üzerindeki `-d` bayrağı ne yapar?$$,
           NULL, NULL,
           $$Ders, `-d`'nin ('detached') container'ı arka planda çalıştırdığını ve terminal komut istemini hemen geri döndürdüğünü belirtir -- bu olmadan, `docker run` bunun yerine terminalinizi doğrudan container'ın çıktısına bağlar, bu da container durana kadar terminali bloke eder.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-cli-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Container durur durmaz onu otomatik olarak siler$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$İmajı indirir ama ondan hiçbir zaman bir container başlatmaz$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Başlatılan container için tüm ağ bağlantısını devre dışı bırakır$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Container'ı arka planda ('detached') çalıştırır ve terminal komut istemini hemen geri döndürür$$, TRUE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this `docker ps` output (no flags), and a second container named `old-cache` that was stopped five minutes ago, would `old-cache` appear in this listing?$$,
           $$CONTAINER ID   IMAGE         COMMAND                  STATUS         PORTS                    NAMES
7f8e9a0b1c2d   postgres:16   "docker-entrypoint.s…"   Up 2 minutes   0.0.0.0:5432->5432/tcp   learning-platform-db$$, $$text$$,
           $$No -- plain `docker ps` only shows running containers by default; a stopped container like `old-cache` would not appear unless `-a` is added (`docker ps -a`), which shows every container regardless of status.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-cli-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yes, but only because its name starts with a letter earlier in the alphabet than "learning-platform-db"$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$No -- stopped containers are permanently deleted and can never appear in any `docker ps` output again$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$No -- plain `docker ps` only shows running containers by default; `old-cache` would need `docker ps -a` to appear$$, TRUE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Yes -- `docker ps` always shows every container that has ever existed, running or not$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu `docker ps` çıktısı (bayrak yok) ve beş dakika önce durdurulmuş `eski-onbellek` adlı ikinci bir container göz önüne alındığında, `eski-onbellek` bu listede görünür mü?$$,
           $$CONTAINER ID   IMAGE         COMMAND                  STATUS         PORTS                    NAMES
a1b2c3d4e5f6   postgres:16   "docker-entrypoint.s…"   Up 5 minutes   0.0.0.0:5433->5432/tcp   kurs-veritabani$$, $$text$$,
           $$Hayır -- sade `docker ps` varsayılan olarak yalnızca çalışan container'ları gösterir; `eski-onbellek` gibi durdurulmuş bir container, her duruma bakılmaksızın tüm container'ları gösteren `-a` eklenmedikçe (`docker ps -a`) görünmez.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-cli-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hayır -- sade `docker ps` varsayılan olarak yalnızca çalışan container'ları gösterir; `eski-onbellek`in görünmesi için `docker ps -a` gerekir$$, TRUE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Evet -- `docker ps` her zaman var olmuş her container'ı, çalışıyor olsun olmasın gösterir$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Evet, ama yalnızca adı alfabede 'kurs-veritabani'ndan daha önce gelen bir harfle başladığı için$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Hayır -- durdurulmuş container'lar kalıcı olarak silinir ve bir daha hiçbir `docker ps` çıktısında görünemez$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What is the purpose of `docker logs -f`, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states `-f` follows the log stream continuously, the same way `tail -f` follows a growing file -- this is usually the very first thing to reach for when a container isn't behaving as expected, before anything more involved.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-cli-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It permanently deletes the container's log history after displaying it once$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$It filters the log output to show only error-level messages$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$It forces the container to restart and then shows the logs from the fresh start$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$It follows the container's log stream continuously, the same way `tail -f` follows a growing file$$, TRUE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `docker logs -f`'nin amacı nedir?$$,
           NULL, NULL,
           $$Ders, `-f`'nin, tıpkı `tail -f`'nin büyüyen bir dosyayı takip etmesi gibi, container'ın log akışını sürekli olarak takip ettiğini belirtir -- bu, bir container beklendiği gibi davranmadığında, daha karmaşık herhangi bir şeyden önce başvurulacak ilk şeydir.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-cli-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Container'ı yeniden başlatmaya zorlar ve ardından yeniden başlangıçtan itibaren logları gösterir$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Container'ın log akışını, tıpkı `tail -f`'nin büyüyen bir dosyayı takip etmesi gibi, sürekli olarak takip eder$$, TRUE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Container'ın log geçmişini bir kez görüntüledikten sonra kalıcı olarak siler$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Log çıktısını yalnızca hata seviyesindeki mesajları gösterecek şekilde filtreler$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this command connecting to an already-running PostgreSQL container, what specifically do the `-i` and `-t` flags together achieve?$$,
           $$docker exec -it learning-platform-db psql -U postgres$$, $$bash$$,
           $$The lesson states `-i` keeps standard input open and `-t` allocates a terminal -- together (`-it`) they make the session interactive instead of running one command and immediately exiting, which is why this command drops into an interactive `psql` prompt rather than running a single query and returning.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-cli-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Together they make the session interactive -- `-i` keeps stdin open, `-t` allocates a terminal, instead of running one command and immediately exiting$$, TRUE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$`-i` installs the `psql` client and `-t` sets a timeout for the command$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$They have no real effect here -- `psql` would behave identically without either flag$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$`-it` tells Docker to create a brand-new container instead of using the already-running one$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Zaten çalışan bir PostgreSQL container'ına bağlanan bu komut göz önüne alındığında, `-i` ve `-t` bayrakları birlikte özellikle neyi sağlar?$$,
           $$docker exec -it kurs-veritabani psql -U postgres$$, $$bash$$,
           $$Ders, `-i`'nin standart girdiyi açık tuttuğunu ve `-t`'nin bir terminal ayırdığını belirtir -- birlikte (`-it`) tek bir komutu çalıştırıp hemen çıkmak yerine oturumu interaktif hale getirirler, bu yüzden bu komut tek bir sorgu çalıştırıp dönmek yerine interaktif bir `psql` istemine düşer.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-cli-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Burada gerçek bir etkileri yoktur -- `psql`, ikisi de olmadan aynı şekilde davranırdı$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$`-it`, Docker'a zaten çalışan container'ı kullanmak yerine yepyeni bir container oluşturmasını söyler$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Birlikte oturumu interaktif hale getirirler -- `-i` stdin'i açık tutar, `-t` bir terminal ayırır, tek bir komutu çalıştırıp hemen çıkmak yerine$$, TRUE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$`-i`, `psql` istemcisini kurar ve `-t` komut için bir zaman aşımı ayarlar$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about Docker CLI commands, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (`docker stop` sends a graceful shutdown signal first and only forces termination after a timeout; `docker rm` refuses to remove a still-running container, requiring `docker stop` first or `-f` to force it); `docker rm` explicitly does not touch the image a container was created from (it stays in `docker images` untouched), and `docker exec` only works against a container that's already running, not for starting a brand-new one (that's `docker run`'s job).$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-cli-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`docker exec` can be used to start a brand-new container from an image, the same way `docker run` does$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$`docker stop` sends a graceful shutdown signal first, only forcing termination after a timeout$$, TRUE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$`docker rm` refuses to remove a container that's still running, unless `-f` is used to force it$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$`docker rm` on a container also deletes the image that container was created from$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, Docker CLI komutları hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (`docker stop`'un önce nazik bir kapatma sinyali göndermesi, ancak bir zaman aşımından sonra zorla sonlandırması; `docker rm`'in hâlâ çalışan bir container'ı kaldırmayı reddetmesi, önce `docker stop` gerektirmesi ya da zorlamak için `-f`); `docker rm`'in bir container'ın oluşturulduğu imaja hiç dokunmadığı (o, `docker images`'te değişmeden kalır) ve `docker exec`'in yalnızca zaten çalışan bir container'a karşı işlediği, yepyeni bir tane başlatmak için değil (bu `docker run`'ın işi) açıkça belirtilir.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-cli-fundamentals'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`docker rm`, `-f` ile zorlanmadıkça hâlâ çalışan bir container'ı kaldırmayı reddeder$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir container üzerinde `docker rm` çalıştırmak, o container'ın oluşturulduğu imajı da siler$$, FALSE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$`docker exec`, tıpkı `docker run`'ın yaptığı gibi, bir imajdan yepyeni bir container başlatmak için kullanılabilir$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$`docker stop`, yalnızca bir zaman aşımından sonra sonlandırmayı zorlamadan önce, önce nazik bir kapatma sinyali gönderir$$, TRUE, 3 FROM new_question_tr7;
