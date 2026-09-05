-- Promotion batch
-- Topic: what-is-docker (language: en x5, tr x5)
-- Generated: 2026-09-05 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 10 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/what-is-docker.md and content/tr/what-is-docker.md -- NOT produced by n8n,
-- NOT judged by any external AI API, and NOT ingested via
-- /api/internal/questions/ingest.
--
-- Per-topic question count is FLEXIBLE (5 EN + 5 TR here), sized to this
-- lesson's actual concept density rather than a fixed target -- unlike
-- prior categories in this project, this Docker course batch deliberately
-- varies EN/TR pair count per topic (4-7) based on lesson length/depth.
--
-- Strict 50/50 EN/TR split (5+5) organized as 5 CONCEPT PAIRS -- each EN
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
           $$According to this lesson, what is Docker?$$,
           NULL, NULL,
           $$The lesson defines Docker as a platform for packaging an application together with everything it needs to run (dependencies, runtime, configuration) into a portable container, then running that unit consistently on any machine that has Docker installed.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-docker'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A platform for packaging an application with everything it needs to run into a portable container, run consistently on any machine with Docker installed$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$A full virtual machine hypervisor that emulates hardware for running any operating system$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$A cloud hosting provider that runs applications on Docker's own remote servers$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$A build tool that replaces Maven for compiling and packaging Java source code$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, Docker nedir?$$,
           NULL, NULL,
           $$Ders, Docker'ı, bir uygulamayı çalışması için ihtiyaç duyduğu her şeyle (bağımlılıklar, runtime, yapılandırma) birlikte taşınabilir bir container'a paketleyen, ve bu birimi Docker kurulu herhangi bir makinede tutarlı şekilde çalıştıran bir platform olarak tanımlar.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-docker'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Uygulamaları Docker'ın kendi uzak sunucularında çalıştıran bir bulut barındırma sağlayıcısı$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Java kaynak kodunu derleyip paketlemek için Maven'ın yerini alan bir build aracı$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir uygulamayı çalışması için ihtiyaç duyduğu her şeyle birlikte taşınabilir bir container'a paketleyen, ve Docker kurulu herhangi bir makinede tutarlı şekilde çalıştıran bir platform$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Herhangi bir işletim sistemini çalıştırmak için donanımı emüle eden tam bir sanal makine hipervizörü$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What specific, recurring problem does this lesson say Docker exists to solve?$$,
           NULL, NULL,
           $$The lesson names "it works on my machine" as the specific problem -- before containers, deploying meant relying on the target machine already having the right JDK version, environment variables, and no conflicting dependencies, so mismatches between a developer's machine, test, and production could cause bugs that only reproduce in one place.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-docker'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The problem of relational databases not supporting enough concurrent connections$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$The "it works on my machine" problem -- mismatches between a developer's machine, test, and production environments causing bugs that only reproduce in one place$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$The problem of Java code running too slowly compared to other programming languages$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$The problem of Maven Central being unreachable from certain corporate networks$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, Docker hangi spesifik, tekrarlayan problemi çözmek için var?$$,
           NULL, NULL,
           $$Ders, spesifik problem olarak 'benim makinemde çalışıyor'u adlandırır -- container'lardan önce, dağıtım, hedef makinede doğru JDK sürümünün, ortam değişkenlerinin ve çakışan bağımlılık olmamasının zaten bulunmasına güvenmek anlamına geliyordu, bu yüzden bir geliştiricinin makinesi, test ve production arasındaki uyumsuzluklar yalnızca birinde ortaya çıkan hatalara yol açabiliyordu.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-docker'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Java kodunun diğer programlama dillerine kıyasla çok yavaş çalışması problemi$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Maven Central'ın belirli kurumsal ağlardan erişilemez olması problemi$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$İlişkisel veritabanlarının yeterli sayıda eşzamanlı bağlantıyı desteklememesi problemi$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$'Benim makinemde çalışıyor' problemi -- bir geliştiricinin makinesi, test ve production ortamları arasındaki uyumsuzlukların yalnızca birinde ortaya çıkan hatalara yol açması$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$According to "Containers vs. Virtual Machines," what is the fundamental architectural difference that explains why a container starts dramatically faster than a virtual machine?$$,
           NULL, NULL,
           $$A container runs directly on the host machine's existing kernel (isolated by Linux namespaces/cgroups), with no second operating system underneath it, while a VM runs a complete guest OS on top of a hypervisor -- the practical consequence is that a container has no OS to boot, only the application process starting directly.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-docker'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A container is always run on more powerful hardware than a virtual machine$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$A container skips loading application dependencies entirely, unlike a virtual machine$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$A container shares the host machine's existing kernel directly, with no guest OS to boot; a VM runs a full guest OS on top of a hypervisor$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$A container uses a faster programming language internally than a virtual machine does$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$'Containers vs. Virtual Machines'a göre, bir container'ın bir sanal makineden çok daha hızlı başlamasını açıklayan temel mimari fark nedir?$$,
           NULL, NULL,
           $$Bir container, host makinenin var olan çekirdeğinde doğrudan çalışır (Linux namespace/cgroup'larla izole edilir), altında ikinci bir işletim sistemi yoktur; bir VM ise bir hipervizörün üzerinde tam bir guest OS çalıştırır -- pratik sonuç, bir container'ın önyükleyecek bir işletim sistemi olmaması, yalnızca uygulama sürecinin doğrudan başlamasıdır.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-docker'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir container, host makinenin var olan çekirdeğini doğrudan paylaşır, önyüklenecek bir guest OS yoktur; bir VM ise bir hipervizörün üzerinde tam bir guest OS çalıştırır$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Bir container, bir sanal makineden içsel olarak daha hızlı bir programlama dili kullanır$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Bir container her zaman bir sanal makineden daha güçlü donanımda çalıştırılır$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Bir container, bir sanal makinenin aksine uygulama bağımlılıklarını hiç yüklemez$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A team builds one Spring Boot image and starts three separate containers from it, all running at the same time. According to "Images vs. Containers," what happens to the original image?$$,
           NULL, NULL,
           $$The lesson states starting a container from an image doesn't consume or modify that image -- the same image can be used to start any number of containers independently, and the image itself stays exactly as it was built; an image is a read-only, frozen template, and a container is a running instance created from it (like a class and its instances).$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-docker'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The image is deleted automatically once the third container starts from it$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$The image is split into three separate copies, one dedicated to each container$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$The image is locked and cannot be used to start any further containers until all three stop$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$The image stays exactly as it was built -- it is not consumed or modified by starting containers from it, and can back any number of independent containers$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir ekip bir Spring Boot imajı inşa ediyor ve ondan aynı anda çalışan üç ayrı container başlatıyor. 'Images vs. Containers'a göre, orijinal imaja ne olur?$$,
           NULL, NULL,
           $$Ders, bir imajdan bir container başlatmanın o imajı tüketmediğini ya da değiştirmediğini belirtir -- aynı imaj, birbirinden bağımsız olarak istenildiği kadar container başlatmak için kullanılabilir, ve imajın kendisi inşa edildiği haliyle tam olarak kalır; bir imaj salt-okunur, dondurulmuş bir şablondur, bir container ise ondan oluşturulan çalışan bir örnektir (bir sınıf ve örnekleri gibi).$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-docker'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İmaj kilitlenir ve üçü de durana kadar başka hiçbir container başlatmak için kullanılamaz$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$İmaj, inşa edildiği haliyle tam olarak kalır -- ondan container başlatmak onu tüketmez ya da değiştirmez, ve istenildiği kadar bağımsız container'ı destekleyebilir$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Üçüncü container ondan başlar başlamaz imaj otomatik olarak silinir$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$İmaj, her container'a bir tane ayrılmış olmak üzere üç ayrı kopyaya bölünür$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about Docker's core mechanics, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (the Docker Engine/dockerd is the daemon that actually does the work, with the CLI as a thin client talking to it; a registry stores images by name and tag, the same way Maven Central stores JAR artifacts by coordinate); the lesson does not claim `docker pull` always builds an image locally from scratch (that's the opposite of what a registry pull does), and it explicitly says Docker Hub is the default registry, not the only possible one.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-docker'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The Docker Engine (`dockerd`) is the background daemon that actually builds images and runs containers; the `docker` CLI is a thin client that talks to it$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$An image registry stores images under a name and tag, the same way Maven Central stores JAR artifacts under a group, artifact, and version$$, TRUE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$`docker pull` always builds a new image locally from scratch rather than fetching an already-built one from a registry$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Docker Hub is the only registry a Docker installation can ever pull images from -- private or self-hosted registries are not possible$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, Docker'ın temel mekaniği hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (Docker Engine/dockerd'in gerçek işi yapan arka plan daemon'ı olması, CLI'ın ona konuşan ince bir client olması; bir registry'nin imajları, Maven Central'ın JAR artifact'lerini group/artifact/version ile depoladığı gibi ad ve tag ile depolaması); ders, `docker pull`'un her zaman yerel olarak sıfırdan bir imaj inşa ettiğini iddia etmez (bu bir registry'den çekmenin tam tersidir), ve Docker Hub'ın yalnızca varsayılan registry olduğunu, tek mümkün registry olmadığını açıkça belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'what-is-docker'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`docker pull`, bir registry'den zaten inşa edilmiş bir imajı getirmek yerine her zaman yerel olarak sıfırdan yeni bir imaj inşa eder$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Docker Hub, bir Docker kurulumunun imaj çekebileceği tek registry'dir -- özel ya da kendi barındırılan registry'ler mümkün değildir$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Docker Engine (`dockerd`), imajları gerçekten inşa eden ve container'ları çalıştıran arka plan daemon'ıdır; `docker` CLI'ı ona konuşan ince bir client'tır$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Bir image registry, imajları, Maven Central'ın JAR artifact'lerini group, artifact ve version ile depoladığı gibi, ad ve tag altında depolar$$, TRUE, 3 FROM new_question_tr5;
