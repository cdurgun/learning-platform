-- Promotion-style migration linking TR docker-compose quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 6 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.


-- Question 1/6 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-compose')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, Docker Compose temelde ne yapar?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, Docker Compose temelde ne yapar?$$,
           NULL, NULL,
           $$Ders, Compose'un bir dizi ilişkili container'ı (servisleri) tanımlayan bir YAML dosyasını okuduğunu ve hepsini bir komutla ayağa kaldırdığını ya da hepsini bir komutla söktüğünü belirtir -- altta yatan mekanizmada hiçbir şey değişmez, yalnızca ağ/volume/container oluşturmayı, her komutun ayrı ayrı elle yazılmasını gerektirmek yerine tek bir dosyadan türetir.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-compose'
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
    ($$Bir dizi servisi tanımlayan bir YAML dosyasını okur ve her `docker` komutunu elle yazmak yerine hepsini bir komutla ayağa kaldırır (ya da indirir)$$, TRUE, 0),
    ($$Docker Engine'i tamamen farklı bir container runtime'ıyla tümüyle değiştirir$$, FALSE, 1),
    ($$Yalnızca Dockerfile inşa etmek için bir araçtır, container çalıştırmakla ilgisi yoktur$$, FALSE, 2),
    ($$Bir projenin bağımlılıklarına dayanarak otomatik olarak Java kaynak kodu yazar$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-compose'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-compose')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir `docker-compose.yml`'in `db` servisi, `volumes:` anahtarı altında `db-data:/var/lib/postgresql/data`'yı listeliyor, ama `db-data` dosyanın başka hiçbir yerinde hiç tanımlanmıyor. Bu derse göre ne olur?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir `docker-compose.yml`'in `db` servisi, `volumes:` anahtarı altında `db-data:/var/lib/postgresql/data`'yı listeliyor, ama `db-data` dosyanın başka hiçbir yerinde hiç tanımlanmıyor. Bu derse göre ne olur?$$,
           NULL, NULL,
           $$Ders, bir servisin `volumes:` listesinde referans verilen bir named volume'un dosyanın en üst seviyesinde bir kez tanımlanması gerektiğini belirtir -- bir servis, Compose'a dosyanın başka hiçbir yerinde söylenmemiş bir volume adı icat edemez; bu açıkça yaygın bir hata olarak adlandırılır.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-compose'
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
    ($$Bu, onu kullanan servis özellikle `db` olarak adlandırılmışsa sorun değildir$$, FALSE, 0),
    ($$Bu bir problemdir -- bir servis, dosyanın en üst seviyedeki `volumes:` bölümünde hiç tanımlanmamış bir volume adına referans veremez$$, TRUE, 1),
    ($$Hiçbir şey -- Compose, bir servis tarafından referans verildiğini gördüğü herhangi bir volume adını otomatik olarak çıkarır ve tanımlar$$, FALSE, 2),
    ($$Compose bu durumda sessizce bir named volume yerine bir bind mount kullanmaya geçer$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-compose'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-compose')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, `depends_on: [db]`, `app` başlamadan önce `db` container'ı içindeki PostgreSQL'in gerçekten bağlantı kabul etmeye hazır olduğunu garanti eder mi?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `depends_on: [db]`, `app` başlamadan önce `db` container'ı içindeki PostgreSQL'in gerçekten bağlantı kabul etmeye hazır olduğunu garanti eder mi?$$,
           NULL, NULL,
           $$Ders, `depends_on`'un tek başına yalnızca `db` container'ının BAŞLAMASINI beklediğini, içindeki PostgreSQL'in gerçekten bağlantı kabul etmeye hazır olmasını beklemediğini açıkça uyarır -- yavaş başlayan bir veritabanı, `depends_on` yerinde olsa bile `app`'in ilk bağlantı denemesinde başarısız olmasına yol açabilir.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-compose'
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
    ($$Evet, ama yalnızca özellikle resmi `postgres` imajını kullanan servisler için$$, FALSE, 0),
    ($$Bu ders hazır olmayı hiç ele almaz -- `depends_on`'un başlangıç sırası üzerinde hiçbir etkisi olmadığı tanımlanır$$, FALSE, 1),
    ($$Hayır -- yalnızca `db` container'ının başlamasını bekler, içindeki PostgreSQL'in gerçekten bağlantı kabul etmeye hazır olmasını değil$$, TRUE, 2),
    ($$Evet -- `depends_on`, bir sonraki servisi başlatmadan önce her zaman bir bağımlılığın içindeki tüm uygulamanın tamamen hazır olmasını bekler$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-compose'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-compose')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu `docker-compose.yml` alıntısı göz önüne alındığında, `app` servisi PostgreSQL'e ulaşmak için hangi hostname'i kullanır, ve neden hiçbir `docker network create` komutu olmadan çalışır?$$
      AND code_snippet = $$services:
  veritabani:
    image: postgres:16
    environment:
      POSTGRES_PASSWORD: gizli
  uygulama:
    build: .
    depends_on:
      - veritabani
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://veritabani:5432/postgres$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
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
    FROM topic
    WHERE slug = 'docker-compose'
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
    ($$`localhost` -- Compose, container'ları başlatmadan önce servis hostname'lerini her zaman içsel olarak `localhost`a yeniden yazar$$, FALSE, 0),
    ($$Servisin gerçek container ID'si -- Compose'un hostname kavramı hiç yoktur, yalnızca ham container ID'leri vardır$$, FALSE, 1),
    ($$`docker compose up`'tan önce çalıştırılan açık bir `docker network create` komutu olmadan hiç çalışamaz$$, FALSE, 2),
    ($$`veritabani` -- Compose, tek bir dosyadaki her servisi otomatik olarak aynı ağa yerleştirir, burada her servisin adı onun hostname'i haline gelir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-compose'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-compose')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, sade `docker compose down` (bayraksız), Compose dosyasında tanımlanan named volume'ları kaldırır mı?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, sade `docker compose down` (bayraksız), Compose dosyasında tanımlanan named volume'ları kaldırır mı?$$,
           NULL, NULL,
           $$Ders, `docker compose down`'un varsayılan olarak named volume'lara BİLEREK dokunmadığını belirtir -- bir volume'ün sıradan container yaşam döngüsü olaylarını atlatması amaçlanmıştır, ve down kendisini veri yok eden değil sıradan bir söküm olarak ele alır; `docker compose down -v`, volume'ları da kaldırmak için açık bir tercihtir.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-compose'
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
    ($$Hayır -- sade `docker compose down`, named volume'ları varsayılan olarak bilerek olduğu gibi bırakır; `-v` onları da kaldırmak için açık bir tercihtir$$, TRUE, 0),
    ($$Evet -- `docker compose down`, dosyada tanımlanan her named volume'u önlemenin hiçbir yolu olmadan her zaman kaldırır$$, FALSE, 1),
    ($$Evet, ama yalnızca özellikle `db` adlı bir servise bağlı volume'lar için$$, FALSE, 2),
    ($$Bu ders, `docker compose down` için volume davranışını hiç belirtmez$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-compose'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-compose')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, Docker Compose hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, Docker Compose hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (`build: .`'nin, Compose'a önceden inşa edilmiş bir imajı çekmek yerine projenin kendi Dockerfile'ını inşa etmesini söylemesi, elle `docker build` çalıştırmakla aynı etki; Compose'un, oluşturma sırasında tanımlanan bir volume'un gerçek adının önüne projenin kendi adını eklemesi, örneğin `learning-platform_db-data` olarak, yalnızca `db-data` değil); ders, Compose'daki `ports:`'un `docker run` üzerindeki `-p`'den tamamen farklı bir mekanizma olduğunu söylemez (aralarında açık bir eşdeğerlik olduğu tanımlanır), ve bir Compose servisine başka bir container'ın elle seçilmiş `--name`'ini sabit kodlamayı önermez (Compose'un otomatik ağı, başka bir yerde container'lara verilen adları değil, aynı dosyadaki servis adlarını kullanır).$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-compose'
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
    ($$Bu ders, bir Compose servisinin yapılandırmasına, aynı dosyadaki o diğer servisin adını kullanmak yerine, başka bir container'ın elle seçilmiş `--name`'ini sabit kodlamayı önerir$$, FALSE, 0),
    ($$`build: .`, Compose'a önceden inşa edilmiş bir imajı çekmek yerine projenin kendi Dockerfile'ını inşa etmesini söyler, elle `docker build` çalıştırmakla aynı etki$$, TRUE, 1),
    ($$Compose, oluşturma sırasında tanımlanan bir volume'un gerçek adının önüne projenin kendi adını ekler (örn. yalnızca `db-data` değil, `learning-platform_db-data`)$$, TRUE, 2),
    ($$Compose'daki bir servisin `ports:` ayarı, `docker run` üzerindeki `-p`'den tamamen farklı bir mekanizmadır, aralarında gerçek bir eşdeğerlik yoktur$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-compose'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
