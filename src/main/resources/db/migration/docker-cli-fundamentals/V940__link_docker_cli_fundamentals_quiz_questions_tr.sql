-- Promotion-style migration linking TR docker-cli-fundamentals quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.


-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-cli-fundamentals')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, hiçbir tag belirtilmeden `docker pull redis` çalıştırmak örtük olarak hangi sürümü çeker?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, hiçbir tag belirtilmeden `docker pull redis` çalıştırmak örtük olarak hangi sürümü çeker?$$,
           NULL, NULL,
           $$Ders, bir tag'i tamamen atlamanın örtük olarak `:latest` anlamına geldiğini belirtir, ve buna güvenmek yerine açıkça adlandırmanın değerli olduğunu ekler -- 'Best Practices' bölümünün her zaman örtük latest yerine belirli bir tag'i çekip çalıştırmayı önermesinin tam nedeni budur.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-cli-fundamentals'
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
    ($$Başka bir yerel imajın bağımlılığı olarak şu anda kurulu olan hangi sürümse o$$, FALSE, 0),
    ($$`:latest` -- bir tag'i tamamen atlamak örtük olarak `latest` tag'i anlamına gelir$$, TRUE, 1),
    ($$Maksimum kararlılığı garanti etmek için, imajın mevcut en eski sürümü$$, FALSE, 2),
    ($$Bir tag `docker pull` için her zaman zorunlu olduğu için doğrudan bir hatayla başarısız olur$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-cli-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-cli-fundamentals')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, `docker images` daha yeni sürümleri kontrol etmek için Docker Hub'a bağlanır mı?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `docker images` daha yeni sürümleri kontrol etmek için Docker Hub'a bağlanır mı?$$,
           NULL, NULL,
           $$Ders, `docker images`'in tamamen yerel, çevrimdışı bir listeleme olduğunu, Docker Hub'a hiç bağlanmadığını açıkça belirtir; yalnızca zaten çekilmiş veya inşa edilmiş ve yerel depolamada duran imajları listeler.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-cli-fundamentals'
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
    ($$Evet, ama yalnızca ona `-a` bayrağı verilirse$$, FALSE, 0),
    ($$Bu, imajın orijinal olarak çekilip çekilmediğine ya da yerel olarak inşa edilip edilmediğine bağlıdır$$, FALSE, 1),
    ($$Hayır -- `docker images`, zaten yerel olarak depolanmış olanların tamamen yerel, çevrimdışı bir listesidir$$, TRUE, 2),
    ($$Evet -- yerel imajları en son mevcut sürümlerle karşılaştırmak için her zaman önce Docker Hub'a bağlanır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-cli-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-cli-fundamentals')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, `docker run` üzerindeki `-d` bayrağı ne yapar?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `docker run` üzerindeki `-d` bayrağı ne yapar?$$,
           NULL, NULL,
           $$Ders, `-d`'nin ('detached') container'ı arka planda çalıştırdığını ve terminal komut istemini hemen geri döndürdüğünü belirtir -- bu olmadan, `docker run` bunun yerine terminalinizi doğrudan container'ın çıktısına bağlar, bu da container durana kadar terminali bloke eder.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-cli-fundamentals'
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
    ($$Container durur durmaz onu otomatik olarak siler$$, FALSE, 0),
    ($$İmajı indirir ama ondan hiçbir zaman bir container başlatmaz$$, FALSE, 1),
    ($$Başlatılan container için tüm ağ bağlantısını devre dışı bırakır$$, FALSE, 2),
    ($$Container'ı arka planda ('detached') çalıştırır ve terminal komut istemini hemen geri döndürür$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-cli-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-cli-fundamentals')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu `docker ps` çıktısı (bayrak yok) ve beş dakika önce durdurulmuş `eski-onbellek` adlı ikinci bir container göz önüne alındığında, `eski-onbellek` bu listede görünür mü?$$
      AND code_snippet = $$CONTAINER ID   IMAGE         COMMAND                  STATUS         PORTS                    NAMES
a1b2c3d4e5f6   postgres:16   "docker-entrypoint.s…"   Up 5 minutes   0.0.0.0:5433->5432/tcp   kurs-veritabani$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu `docker ps` çıktısı (bayrak yok) ve beş dakika önce durdurulmuş `eski-onbellek` adlı ikinci bir container göz önüne alındığında, `eski-onbellek` bu listede görünür mü?$$,
           $$CONTAINER ID   IMAGE         COMMAND                  STATUS         PORTS                    NAMES
a1b2c3d4e5f6   postgres:16   "docker-entrypoint.s…"   Up 5 minutes   0.0.0.0:5433->5432/tcp   kurs-veritabani$$, $$text$$,
           $$Hayır -- sade `docker ps` varsayılan olarak yalnızca çalışan container'ları gösterir; `eski-onbellek` gibi durdurulmuş bir container, her duruma bakılmaksızın tüm container'ları gösteren `-a` eklenmedikçe (`docker ps -a`) görünmez.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-cli-fundamentals'
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
    ($$Hayır -- sade `docker ps` varsayılan olarak yalnızca çalışan container'ları gösterir; `eski-onbellek`in görünmesi için `docker ps -a` gerekir$$, TRUE, 0),
    ($$Evet -- `docker ps` her zaman var olmuş her container'ı, çalışıyor olsun olmasın gösterir$$, FALSE, 1),
    ($$Evet, ama yalnızca adı alfabede 'kurs-veritabani'ndan daha önce gelen bir harfle başladığı için$$, FALSE, 2),
    ($$Hayır -- durdurulmuş container'lar kalıcı olarak silinir ve bir daha hiçbir `docker ps` çıktısında görünemez$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-cli-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-cli-fundamentals')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, `docker logs -f`'nin amacı nedir?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `docker logs -f`'nin amacı nedir?$$,
           NULL, NULL,
           $$Ders, `-f`'nin, tıpkı `tail -f`'nin büyüyen bir dosyayı takip etmesi gibi, container'ın log akışını sürekli olarak takip ettiğini belirtir -- bu, bir container beklendiği gibi davranmadığında, daha karmaşık herhangi bir şeyden önce başvurulacak ilk şeydir.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-cli-fundamentals'
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
    ($$Container'ı yeniden başlatmaya zorlar ve ardından yeniden başlangıçtan itibaren logları gösterir$$, FALSE, 0),
    ($$Container'ın log akışını, tıpkı `tail -f`'nin büyüyen bir dosyayı takip etmesi gibi, sürekli olarak takip eder$$, TRUE, 1),
    ($$Container'ın log geçmişini bir kez görüntüledikten sonra kalıcı olarak siler$$, FALSE, 2),
    ($$Log çıktısını yalnızca hata seviyesindeki mesajları gösterecek şekilde filtreler$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-cli-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-cli-fundamentals')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Zaten çalışan bir PostgreSQL container'ına bağlanan bu komut göz önüne alındığında, `-i` ve `-t` bayrakları birlikte özellikle neyi sağlar?$$
      AND code_snippet = $$docker exec -it kurs-veritabani psql -U postgres$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Zaten çalışan bir PostgreSQL container'ına bağlanan bu komut göz önüne alındığında, `-i` ve `-t` bayrakları birlikte özellikle neyi sağlar?$$,
           $$docker exec -it kurs-veritabani psql -U postgres$$, $$bash$$,
           $$Ders, `-i`'nin standart girdiyi açık tuttuğunu ve `-t`'nin bir terminal ayırdığını belirtir -- birlikte (`-it`) tek bir komutu çalıştırıp hemen çıkmak yerine oturumu interaktif hale getirirler, bu yüzden bu komut tek bir sorgu çalıştırıp dönmek yerine interaktif bir `psql` istemine düşer.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-cli-fundamentals'
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
    ($$Burada gerçek bir etkileri yoktur -- `psql`, ikisi de olmadan aynı şekilde davranırdı$$, FALSE, 0),
    ($$`-it`, Docker'a zaten çalışan container'ı kullanmak yerine yepyeni bir container oluşturmasını söyler$$, FALSE, 1),
    ($$Birlikte oturumu interaktif hale getirirler -- `-i` stdin'i açık tutar, `-t` bir terminal ayırır, tek bir komutu çalıştırıp hemen çıkmak yerine$$, TRUE, 2),
    ($$`-i`, `psql` istemcisini kurar ve `-t` komut için bir zaman aşımı ayarlar$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-cli-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-cli-fundamentals')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, Docker CLI komutları hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, Docker CLI komutları hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (`docker stop`'un önce nazik bir kapatma sinyali göndermesi, ancak bir zaman aşımından sonra zorla sonlandırması; `docker rm`'in hâlâ çalışan bir container'ı kaldırmayı reddetmesi, önce `docker stop` gerektirmesi ya da zorlamak için `-f`); `docker rm`'in bir container'ın oluşturulduğu imaja hiç dokunmadığı (o, `docker images`'te değişmeden kalır) ve `docker exec`'in yalnızca zaten çalışan bir container'a karşı işlediği, yepyeni bir tane başlatmak için değil (bu `docker run`'ın işi) açıkça belirtilir.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-cli-fundamentals'
      AND NOT EXISTS (SELECT 1 FROM existing_q7)
    RETURNING id
),
target_q7 AS (
    SELECT id, TRUE AS newly_inserted FROM inserted_q7
    UNION ALL
    SELECT id, FALSE AS newly_inserted FROM existing_q7
),
option_ins_q7 AS (
    INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT target_q7.id, v.option_text, v.is_correct, v.sort_order
    FROM target_q7
             CROSS JOIN (VALUES
    ($$`docker rm`, `-f` ile zorlanmadıkça hâlâ çalışan bir container'ı kaldırmayı reddeder$$, TRUE, 0),
    ($$Bir container üzerinde `docker rm` çalıştırmak, o container'ın oluşturulduğu imajı da siler$$, FALSE, 1),
    ($$`docker exec`, tıpkı `docker run`'ın yaptığı gibi, bir imajdan yepyeni bir container başlatmak için kullanılabilir$$, FALSE, 2),
    ($$`docker stop`, yalnızca bir zaman aşımından sonra sonlandırmayı zorlamadan önce, önce nazik bir kapatma sinyali gönderir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-cli-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
