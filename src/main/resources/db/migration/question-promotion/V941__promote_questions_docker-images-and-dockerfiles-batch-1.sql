-- Promotion batch
-- Topic: docker-images-and-dockerfiles (language: en x7, tr x7)
-- Generated: 2026-09-05 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these
-- 14 questions were hand-authored and independently self-reviewed
-- directly inside a Claude Code session, grounded strictly in
-- content/en/docker-images-and-dockerfiles.md and content/tr/docker-images-and-dockerfiles.md -- NOT produced by n8n,
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
           $$What is a Dockerfile, according to this lesson?$$,
           NULL, NULL,
           $$The lesson defines a Dockerfile as a plain-text file, conventionally named exactly "Dockerfile" with no extension, containing a sequence of instructions Docker executes in order to produce an image -- each instruction adds one new, cached layer on top of the previous one.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-images-and-dockerfiles'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A configuration file exclusively for setting a container's network settings after it starts$$, FALSE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$A JSON file listing which Maven dependencies a Spring Boot application needs$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$A plain-text file containing a sequence of instructions Docker executes in order to produce an image, each adding a new cached layer$$, TRUE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$A compiled binary file that Docker runs directly as a container without any build step$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir Dockerfile nedir?$$,
           NULL, NULL,
           $$Ders, bir Dockerfile'ı, geleneksel olarak uzantısız tam olarak 'Dockerfile' adlandırılan, Docker'ın bir imaj üretmek için sırayla çalıştırdığı bir dizi talimat içeren düz metin dosyası olarak tanımlar -- her talimat, öncekinin üzerine yeni, önbelleğe alınmış bir katman ekler.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-images-and-dockerfiles'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Docker'ın bir imaj üretmek için sırayla çalıştırdığı, her biri yeni önbelleğe alınmış bir katman ekleyen bir dizi talimat içeren düz metin dosyası$$, TRUE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Docker'ın herhangi bir build adımı olmadan doğrudan bir container olarak çalıştırdığı derlenmiş bir ikili dosya$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Yalnızca bir container başladıktan sonra ağ ayarlarını belirlemek için kullanılan bir yapılandırma dosyası$$, FALSE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir Spring Boot uygulamasının ihtiyaç duyduğu Maven bağımlılıklarını listeleyen bir JSON dosyası$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why does this lesson choose `alpine:3.20` as the `FROM` base image for its minimal web server example?$$,
           NULL, NULL,
           $$The lesson states Alpine Linux is a common base specifically because it's a real, minimal Linux distribution, only a few megabytes, with a package manager (`apk`) for anything more it needs -- a deliberately small starting point instead of a general-purpose OS image with unused tools.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-images-and-dockerfiles'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It's the only base image Docker officially supports for the `FROM` instruction$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$It comes with a full JDK and Maven already preinstalled, unlike any other base image$$, FALSE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$It's required specifically because the example server is written in Java$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$It's a real, minimal Linux distribution (only a few megabytes) with a package manager for anything else needed -- a deliberately small starting point$$, TRUE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu ders, minimal web server örneği için `FROM` temel imajı olarak neden `alpine:3.20`'yi seçiyor?$$,
           NULL, NULL,
           $$Ders, Alpine Linux'un özellikle yaygın bir temel olmasının nedeninin, gerçek, minimal bir Linux dağıtımı olması (yalnızca birkaç megabayt), ve ihtiyaç duyulan başka her şey için bir paket yöneticisine (`apk`) sahip olması olduğunu belirtir -- kullanılmayan araçları olan genel amaçlı bir OS imajı yerine kasıtlı olarak küçük bir başlangıç noktası.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-images-and-dockerfiles'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Özellikle örnek sunucu Java ile yazıldığı için gereklidir$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Gerçek, minimal bir Linux dağıtımıdır (yalnızca birkaç megabayt), ihtiyaç duyulan başka her şey için bir paket yöneticisine sahiptir -- kasıtlı olarak küçük bir başlangıç noktası$$, TRUE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$`FROM` talimatı için Docker'ın resmi olarak desteklediği tek temel imajdır$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Diğer hiçbir temel imajın aksine, zaten tam bir JDK ve Maven ile önceden kurulmuş gelir$$, FALSE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$What does `WORKDIR /app` do, and what happens to later instructions like `COPY` if it's never set?$$,
           NULL, NULL,
           $$The lesson states WORKDIR sets the directory every subsequent instruction runs relative to (creating it if needed); without it, later instructions like COPY and RUN operate relative to the image's filesystem root -- technically valid, but it mixes an application's files in with the base image's own system directories.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-images-and-dockerfiles'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It sets the directory later instructions run relative to; without it, COPY/RUN operate relative to the filesystem root, mixing app files with system directories$$, TRUE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$It has no functional effect at all -- it exists purely as a comment for human readers of the Dockerfile$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$It permanently deletes any files already present at the given path inside the base image$$, FALSE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$It sets an environment variable that the running container's application code can read at runtime$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$`WORKDIR /app` ne yapar, ve hiç ayarlanmazsa `COPY` gibi sonraki talimatlara ne olur?$$,
           NULL, NULL,
           $$Ders, WORKDIR'ın (gerekirse oluşturarak) sonraki her talimatın göreceli olarak çalışacağı dizini ayarladığını belirtir; bu olmadan, COPY ve RUN gibi sonraki talimatlar imajın dosya sistemi kökünde göreceli olarak çalışır -- teknik olarak geçerlidir, ama uygulamanın dosyalarını temel imajın kendi sistem dizinleriyle karıştırır.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-images-and-dockerfiles'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Temel imaj içindeki verilen yolda zaten mevcut olan dosyaları kalıcı olarak siler$$, FALSE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Çalışan container'ın uygulama kodunun çalışma zamanında okuyabileceği bir ortam değişkeni ayarlar$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Sonraki talimatların göreceli olarak çalışacağı dizini ayarlar; bu olmadan, COPY/RUN dosya sistemi kökünde çalışır, uygulama dosyalarını sistem dizinleriyle karıştırır$$, TRUE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Hiçbir işlevsel etkisi yoktur -- yalnızca Dockerfile'ı okuyan insanlar için bir yorum olarak var olur$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Where can a `COPY` instruction in a Dockerfile read files from, according to this lesson?$$,
           NULL, NULL,
           $$The lesson states COPY brings a file or directory from the build context -- the folder `docker build` is run from -- into the image; it only ever reads from the build context on the host machine, and cannot reach outside it, which is exactly why `docker build` must be run from the folder containing everything the image needs.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-images-and-dockerfiles'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Directly from a remote Git repository URL, without needing any local files at all$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Only from the build context -- the folder `docker build` is run from -- and cannot reach outside it$$, TRUE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$From anywhere on the host machine's filesystem, regardless of where `docker build` is run from$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Only from files already present inside the base image specified by `FROM`$$, FALSE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir Dockerfile'daki `COPY` talimatı dosyaları nereden okuyabilir?$$,
           NULL, NULL,
           $$Ders, COPY'nin build context'ten -- `docker build`'un çalıştırıldığı klasörden -- bir dosyayı ya da dizini imaja getirdiğini belirtir; yalnızca host makinedeki build context'ten okur ve onun dışına asla ulaşamaz, bu da tam olarak `docker build`'un imajın ihtiyaç duyduğu her şeyi içeren klasörden çalıştırılması gerekmesinin nedenidir.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-images-and-dockerfiles'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`docker build`'un nereden çalıştırıldığından bağımsız olarak, host makinenin dosya sisteminde herhangi bir yerden$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Yalnızca `FROM` ile belirtilen temel imaj içinde zaten mevcut olan dosyalardan$$, FALSE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Herhangi bir yerel dosyaya ihtiyaç duymadan, doğrudan uzak bir Git repository URL'inden$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Yalnızca build context'ten -- `docker build`'un çalıştırıldığı klasörden -- ve onun dışına asla ulaşamaz$$, TRUE, 3 FROM new_question_tr4;

-- Pair 5 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given a Dockerfile that only sets `CMD ["echo", "Hello from CMD"]` (no ENTRYPOINT), what does running `docker run my-image echo "Overridden"` print?$$,
           $$docker run my-image
# Output: Hello from CMD

docker run my-image echo "Overridden"
# Output: Overridden$$, $$bash$$,
           $$The lesson states that with only CMD, any command given to docker run REPLACES it entirely -- so supplying `echo "Overridden"` as extra arguments replaces the whole CMD, and the container prints "Overridden", exactly as shown.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-images-and-dockerfiles'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hello from CMD
Overridden  (both lines print, one after the other)$$, FALSE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$An error, since `docker run` cannot accept extra arguments when only CMD is set$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Overridden$$, TRUE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Hello from CMD$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Yalnızca `CMD ["echo", "Merhaba CMD'den"]` ayarlayan (ENTRYPOINT olmayan) bir Dockerfile göz önüne alındığında, `docker run benim-imajim echo "Gecersiz Kilindi"` çalıştırmak ne yazdırır?$$,
           $$docker run benim-imajim
# Cikti: Merhaba CMD'den

docker run benim-imajim echo "Gecersiz Kilindi"
# Cikti: Gecersiz Kilindi$$, $$bash$$,
           $$Ders, yalnızca CMD varken, docker run'a verilen herhangi bir komutun onu TAMAMEN DEĞİŞTİRDİĞİNİ belirtir -- bu yüzden ekstra argüman olarak `echo "Gecersiz Kilindi"` vermek tüm CMD'yi değiştirir, ve container tam olarak gösterildiği gibi "Gecersiz Kilindi" yazdırır.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-images-and-dockerfiles'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Gecersiz Kilindi$$, TRUE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Merhaba CMD'den$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Merhaba CMD'den
Gecersiz Kilindi  (her iki satır da, biri diğerinden sonra yazdırılır)$$, FALSE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Bir hata, çünkü yalnızca CMD ayarlıyken `docker run` ekstra argüman kabul edemez$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given a Dockerfile with `ENTRYPOINT ["echo"]` and `CMD ["Hello from CMD"]`, what does running `docker run my-image "Overridden"` print?$$,
           $$docker run my-image
# Output: Hello from CMD

docker run my-image "Overridden"
# Output: Overridden$$, $$bash$$,
           $$The lesson explains that with ENTRYPOINT set, it always runs -- CMD supplies its default arguments, which docker run can override without touching the entrypoint itself. So `"Overridden"` only replaces the default CMD argument, producing `echo "Overridden"`, which prints "Overridden" -- not a completely different command.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-images-and-dockerfiles'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Hello from CMD -- ENTRYPOINT arguments can never be overridden by docker run under any circumstances$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$An error, since ENTRYPOINT and CMD cannot both be present in the same Dockerfile$$, FALSE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Overridden is printed twice, once for ENTRYPOINT and once for the overriding argument$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Overridden -- the entrypoint (`echo`) still always runs, only its default CMD argument is replaced$$, TRUE, 3 FROM new_question_en6;

-- Pair 6 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$`ENTRYPOINT ["echo"]` ve `CMD ["Merhaba CMD'den"]` olan bir Dockerfile göz önüne alındığında, `docker run benim-imajim "Gecersiz Kilindi"` çalıştırmak ne yazdırır?$$,
           $$docker run benim-imajim
# Cikti: Merhaba CMD'den

docker run benim-imajim "Gecersiz Kilindi"
# Cikti: Gecersiz Kilindi$$, $$bash$$,
           $$Ders, ENTRYPOINT ayarlıyken her zaman çalıştığını açıklar -- CMD, docker run'ın entrypoint'in kendisine dokunmadan geçersiz kılabileceği varsayılan argümanlarını sağlar. Bu yüzden `"Gecersiz Kilindi"` yalnızca varsayılan CMD argümanını değiştirir, `echo "Gecersiz Kilindi"` üretir, bu da tamamen farklı bir komut değil, "Gecersiz Kilindi" yazdırır.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-images-and-dockerfiles'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Gecersiz Kilindi iki kez yazdırılır, biri ENTRYPOINT için biri geçersiz kılan argüman için$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Gecersiz Kilindi -- entrypoint (`echo`) hâlâ her zaman çalışır, yalnızca varsayılan CMD argümanı değiştirilir$$, TRUE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Merhaba CMD'den -- ENTRYPOINT argümanları hiçbir koşulda docker run tarafından geçersiz kılınamaz$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir hata, çünkü ENTRYPOINT ve CMD aynı Dockerfile'da birlikte bulunamaz$$, FALSE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about Dockerfile instructions and `docker build`, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (RUN executes a command at build time and its filesystem changes become a permanent part of the resulting image; EXPOSE is documentation, not configuration -- it does not publish a port on its own, `-p` on docker run does); `docker build -t` tags the image with a repository name and tag, it doesn't need to run detached in the background (that's a `docker run` concept, not a build one), and the build context is the directory passed to `docker build`, not automatically the directory the Dockerfile itself happens to be saved in if they differ.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-images-and-dockerfiles'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`RUN` executes a command while the image is being built, and whatever it changes on disk becomes a permanent part of the resulting image$$, TRUE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$`EXPOSE` is documentation, not configuration -- it does not actually publish a port to the host machine on its own$$, TRUE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$`docker build -t <name>:<tag> .` must always be run with a `-d` flag to run the build process in the background$$, FALSE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$The build context `docker build` uses is automatically the directory containing the Dockerfile, even if a different directory is explicitly passed as the build command's argument$$, FALSE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, Dockerfile talimatları ve `docker build` hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (RUN'ın imaj inşa edilirken bir komut çalıştırması ve diskte değiştirdiği her şeyin ortaya çıkan imajın kalıcı bir parçası olması; EXPOSE'un yapılandırma değil dokümantasyon olması -- kendi başına bir portu yayınlamaması, bunu docker run üzerindeki `-p`'nin yapması); `docker build -t`'nin imajı bir repository adı ve tag ile etiketlemesi, arka planda çalışmak için `-d` bayrağına ihtiyaç duymaması (bu bir `docker run` kavramıdır, build değil), ve build context'in `docker build`'a geçirilen dizin olması, farklıysa Dockerfile'ın kendisinin bulunduğu dizin otomatik olarak değil.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'docker-images-and-dockerfiles'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$`docker build -t <ad>:<tag> .`, build sürecini arka planda çalıştırmak için her zaman bir `-d` bayrağıyla çalıştırılmalıdır$$, FALSE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$`docker build`'un kullandığı build context, build komutunun argümanı olarak açıkça farklı bir dizin geçirilse bile otomatik olarak Dockerfile'ı içeren dizindir$$, FALSE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$`RUN`, imaj inşa edilirken bir komut çalıştırır, ve diskte değiştirdiği her şey ortaya çıkan imajın kalıcı bir parçası olur$$, TRUE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$`EXPOSE` yapılandırma değil dokümantasyondur -- kendi başına bir portu host makineye gerçekten yayınlamaz$$, TRUE, 3 FROM new_question_tr7;
