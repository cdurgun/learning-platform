-- Promotion-style migration linking TR docker-volumes quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 6 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.


-- Question 1/6 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-volumes')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, hiçbir volume yapılandırılmamış bir container'ı kaldırmak yazdığı veriyi neden kalıcı olarak siler?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, hiçbir volume yapılandırılmamış bir container'ı kaldırmak yazdığı veriyi neden kalıcı olarak siler?$$,
           NULL, NULL,
           $$Ders, çalışan bir container'ın yazdığı her şeyin, salt-okunur imajın üzerinde oturan kendi writable katmanında yaşadığını belirtir -- bu katman container'ın kendisinin bir parçasıdır, bu yüzden `docker rm` onu o spesifik container örneğiyle ilgili diğer her şeyle birlikte siler.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-volumes'
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
    ($$Çünkü veri otomatik olarak Docker Hub'a yüklenir ve sonrasında yalnızca orada erişilebilir olur$$, FALSE, 0),
    ($$Çünkü container'ın yazdığı her şey kendi writable katmanında yaşar, bunu `docker rm` container'ın geri kalanıyla birlikte siler$$, TRUE, 1),
    ($$Çünkü `docker rm` her zaman tüm host makinedeki her imajı ve volume'u siler, yalnızca bir container'ı değil$$, FALSE, 2),
    ($$Çünkü container'ların diske hiçbir veri yazmasına baştan izin verilmez$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-volumes'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-volumes')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, `docker volume create` ile oluşturulan bir named volume, sonunda onu kullanacak herhangi bir tek container'a bağımlı mıdır?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `docker volume create` ile oluşturulan bir named volume, sonunda onu kullanacak herhangi bir tek container'a bağımlı mıdır?$$,
           NULL, NULL,
           $$Ders, bir named volume oluşturmanın, sonunda onu kullanacak herhangi bir container'dan bağımsız, tek bir komut olduğunu belirtir -- bir volume bağımsız var olduğu için, tam olarak bir container'ın kendi writable katmanını yok eden olayı, yani `docker rm`'i atlatır.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-volumes'
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
    ($$Evet -- bir named volume yalnızca onu orijinal olarak oluşturan o tek container'a bağlanabilir$$, FALSE, 0),
    ($$Hayır, ama yalnızca özellikle resmi `postgres` imajı tarafından kullanılan volume'lar için$$, FALSE, 1),
    ($$Hayır -- bir named volume herhangi bir tek container'dan bağımsız var olur, ve tam olarak bu nedenle `docker rm`'i atlatır$$, TRUE, 2),
    ($$Evet -- bir named volume, onu kullanan container kaldırılır kaldırılmaz kalıcı olarak silinir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-volumes'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-volumes')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, `-v ogrenme-platformu-db-verisi:/var/lib/postgresql/data`'daki volume neden özellikle `/var/lib/postgresql/data`'ya mount edilmesi gerekiyor?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `-v ogrenme-platformu-db-verisi:/var/lib/postgresql/data`'daki volume neden özellikle `/var/lib/postgresql/data`'ya mount edilmesi gerekiyor?$$,
           NULL, NULL,
           $$Ders, `/var/lib/postgresql/data`'nın keyfi bir yol olmadığını -- resmi `postgres` imajının gerçek veritabanı dosyalarını varsayılan olarak tam olarak orada depoladığını belirtir; bir volume'u tam olarak o yola mount etmek, kaldırıldığında verisi kaybolan bir container ile verisi kalıcı olan bir container'ı birbirinden ayıran şeydir.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-volumes'
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
    ($$Yol keyfidir -- PostgreSQL'in verisini yakalamak için herhangi bir yol tamamen aynı şekilde çalışır$$, FALSE, 0),
    ($$Çünkü Docker'ın kendisi, imajdan bağımsız olarak her volume mount'u için tam olarak o yolu sabit kodlar$$, FALSE, 1),
    ($$Çünkü `/var/lib/postgresql/data`, `docker volume create`'in kendi iç uygulaması tarafından gereklidir$$, FALSE, 2),
    ($$Çünkü resmi `postgres` imajı gerçek veritabanı dosyalarını varsayılan olarak tam olarak orada depolar -- başka bir yere mount etmek o veriyi yakalamaz$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-volumes'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-volumes')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu sıralama göz önüne alındığında, eğer `kurs-db-verisi` düzgün mount edilmiş bir named volume ise, son `SELECT` ne döndürür?$$
      AND code_snippet = $$docker exec -it kurs-veritabani psql -U postgres -c "INSERT INTO kanit (not) VALUES ('hala burada');"

docker stop kurs-veritabani
docker rm kurs-veritabani

docker run --name kurs-veritabani -v kurs-db-verisi:/var/lib/postgresql/data -d postgres:16

docker exec -it kurs-veritabani psql -U postgres -c "SELECT * FROM kanit;"$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu sıralama göz önüne alındığında, eğer `kurs-db-verisi` düzgün mount edilmiş bir named volume ise, son `SELECT` ne döndürür?$$,
           $$docker exec -it kurs-veritabani psql -U postgres -c "INSERT INTO kanit (not) VALUES ('hala burada');"

docker stop kurs-veritabani
docker rm kurs-veritabani

docker run --name kurs-veritabani -v kurs-db-verisi:/var/lib/postgresql/data -d postgres:16

docker exec -it kurs-veritabani psql -U postgres -c "SELECT * FROM kanit;"$$, $$bash$$,
           $$Ders, bu tam sıralamayı bir volume'un gerçekten çalışıp çalışmadığının gerçek testi olarak tanımlar: veri (kaldırılan container'ın writable katmanında değil) volume'da yaşadığı için, aynı volume'a karşı mount edilen yeni container tam olarak öncekinin bıraktığı yerden devam eder -- 'hala burada' içeren satır döner.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-volumes'
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
    ($$'hala burada' içeren satır -- verinin gerçekte tüm süre boyunca yaşadığı yer container değil, volume'du$$, TRUE, 0),
    ($$Boş bir sonuç -- `docker rm`, kaldırılan container'a mount edilmiş herhangi bir volume'u da siler$$, FALSE, 1),
    ($$Bir hata, çünkü yeni bir container asla kaldırılmış birininkiyle aynı `--name` ile başlatılamaz$$, FALSE, 2),
    ($$Bir hata, çünkü `-v`, aynı `docker run` komutunda `--name` ile birleştirilemez$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-volumes'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-volumes')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$'Named Volumes vs. Bind Mounts'a göre, bir named volume yerine bir bind mount ne zaman doğru araçtır?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$'Named Volumes vs. Bind Mounts'a göre, bir named volume yerine bir bind mount ne zaman doğru araçtır?$$,
           NULL, NULL,
           $$Ders, bir bind mount'un, yerel geliştirme sırasında bir projenin kendi kaynak kodunu bir container'a mount etmek gibi, spesifik bir host yolunun önemli olduğu durumlar için olduğunu belirtir -- bir named volume ise, tam olarak PostgreSQL'in kendi veri dosyaları gibi, bir container'ın yönettiği ve Docker'ın yaşam döngüsüne sahip olması gereken veriler içindir.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-volumes'
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
    ($$Yalnızca container özellikle resmi `postgres` imajını çalıştırıyorsa$$, FALSE, 0),
    ($$Yerel geliştirme sırasında bir projenin kendi kaynak kodunu bir container'a mount etmek gibi, spesifik bir host yolunun önemli olduğu durumlarda$$, TRUE, 1),
    ($$Bir veritabanının veri dosyalarının container yeniden başlatmaları arasında kalıcı olması gerektiğinde her zaman -- orada her zaman bir bind mount tercih edilir$$, FALSE, 2),
    ($$Asla -- bu ders her olası kullanım durumu için yalnızca named volume kullanılmasını önerir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-volumes'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-volumes')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, Docker volume'ları hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, Docker volume'ları hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (`docker volume rm`'in yalnızca o volume şu anda hiçbir container'a mount edilmemişse başarılı olması, ve bunun kalıcı verileri gerçekten, bilerek yok eden tek komut olması; aynı container üzerinde `docker stop`'un ardından `docker start`'ın o container'ın writable katmanına dokunmaması, orada yazılan verinin döngüyü atlatması); ders `docker stop`'un herhangi bir veriyi sildiğini iddia etmez (aynı container'ı durdurup yeniden başlatmanın veriyi olduğu gibi bıraktığını açıkça belirtir), ve özellikle bir veritabanının kendi veri dizini için bind mount değil named volume önerir.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-volumes'
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
    ($$Bir container üzerinde `docker stop` çalıştırmak, onun writable katmanına yazılan her veriyi hemen ve kalıcı olarak siler$$, FALSE, 0),
    ($$Bu ders, özellikle bir veritabanının kendi veri dizini için bind mount önerir, named volume değil$$, FALSE, 1),
    ($$`docker volume rm`, yalnızca o volume şu anda hiçbir container'a mount edilmemişse başarılı olur, ve volume'ün verisini gerçekten, kalıcı olarak yok eder$$, TRUE, 2),
    ($$Aynı container üzerinde `docker stop`'un ardından `docker start` çalıştırmak, o container'ın writable katmanına dokunmaz -- orada yazılan veri döngüyü atlatır$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-volumes'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
