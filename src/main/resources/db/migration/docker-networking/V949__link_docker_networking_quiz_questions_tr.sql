-- Promotion-style migration linking TR docker-networking quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 6 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.


-- Question 1/6 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-networking')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, Docker'ın default bridge network'ündeki iki container birbirine container adıyla ulaşabilir mi?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, Docker'ın default bridge network'ündeki iki container birbirine container adıyla ulaşabilir mi?$$,
           NULL, NULL,
           $$Ders bir uyarıyla açıktır: Docker'ın default bridge network'ündeki container'lar birbirine container adıyla ULAŞAMAZ -- yalnızca her yeniden başlatmada değişen bir IP adresiyle ulaşabilirler. Bu gerçek, belgelenmiş bir Docker kısıtlamasıdır; çözüm bir user-defined network'tür.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-networking'
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
    ($$Evet, ama yalnızca her iki container'ın Dockerfile'ında da `EXPOSE` ayarlanmışsa$$, FALSE, 0),
    ($$Hayır -- default bridge network'teki container'lar birbiriyle hiçbir şekilde iletişim kuramaz$$, FALSE, 1),
    ($$Hayır -- default bridge network'te birbirlerine yalnızca her yeniden başlatmada değişen bir IP adresiyle ulaşabilirler$$, TRUE, 2),
    ($$Evet -- ada dayalı çözümleme, default bridge dahil Docker'ın oluşturduğu her ağda otomatik olarak çalışır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-networking'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-networking')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, `-p <host-port>:<container-port>` gerçekte neyi çözer?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `-p <host-port>:<container-port>` gerçekte neyi çözer?$$,
           NULL, NULL,
           $$Ders, `-p`'nin özellikle bir host-to-container köprüsü olduğunu belirtir -- host makinedeki bir portu, bir container'ın kendi izole ağ namespace'i içindeki bir porta eşler; iki container'ın birbirine nasıl ulaştığıyla hiçbir ilgisi yoktur, bu tamamen ayrı bir konudur.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-networking'
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
    ($$Aynı ağdaki iki container'ın birbirini ada göre çözümlemesinin tam olarak yoludur$$, FALSE, 0),
    ($$Bir container'ın dış internete erişimini kalıcı olarak devre dışı bırakır$$, FALSE, 1),
    ($$Uygulandığı her container için otomatik olarak bir user-defined network oluşturur$$, FALSE, 2),
    ($$Host makineyi bir container'ın portuna köprüler -- iki container'ın birbirine nasıl ulaştığıyla hiçbir ilgisi yoktur$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-networking'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-networking')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, `docker network create` ile bir user-defined network oluşturmak, default bridge network'ün sağlamadığı neyi sağlar?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, `docker network create` ile bir user-defined network oluşturmak, default bridge network'ün sağlamadığı neyi sağlar?$$,
           NULL, NULL,
           $$Ders, bir user-defined bridge network'ün, ona bağlı container'lar arasında otomatik DNS tabanlı ad çözümlemesiyle geldiğini belirtir -- Docker, özellikle bir container'ın diğerine `--name`'ini bir hostname olarak kullanarak ulaşabilmesi için gömülü bir DNS sunucusu çalıştırır.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-networking'
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
    ($$Bağlı container'lar arasında otomatik DNS tabanlı ad çözümlemesi -- bir container diğerine `--name`'ini bir hostname olarak kullanarak ulaşabilir$$, TRUE, 0),
    ($$Default bridge network'teki herhangi bir container'a kıyasla otomatik olarak daha hızlı ağ verimi$$, FALSE, 1),
    ($$Ona bağlı her container arasındaki tüm trafiğin otomatik şifrelenmesi$$, FALSE, 2),
    ($$Host makinede Docker'ın kendisi kurulu olmadan container çalıştırabilme yeteneği$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-networking'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-networking')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu JDBC URL'si, bir `db` container'ıyla aynı user-defined network'e bağlı bir `app` container'ının içinde çalıştırıldığında, `kurs-veritabani` neyi çözümler?$$
      AND code_snippet = $$docker run --name kurs-uygulamasi \
  --network kurs-net \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://kurs-veritabani:5432/postgres \
  -d kurs-platformu:1.0$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu JDBC URL'si, bir `db` container'ıyla aynı user-defined network'e bağlı bir `app` container'ının içinde çalıştırıldığında, `kurs-veritabani` neyi çözümler?$$,
           $$docker run --name kurs-uygulamasi \
  --network kurs-net \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://kurs-veritabani:5432/postgres \
  -d kurs-platformu:1.0$$, $$bash$$,
           $$Ders, bu JDBC URL'sindeki `kurs-veritabani`nın gerçek bir internet DNS hostname'i olmadığını açıklar -- yalnızca `kurs-net` içinde, Docker'ın gömülü DNS sunucusu sayesinde, aynı user-defined network üzerinde şu anda o `--name` ile çalışan hangi container'sa ona çözümlenir.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-networking'
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
    ($$Hiçbir şey -- bir port yayınlamak için `-p` de kullanılmadıkça bu URL her zaman çözümlenmeyi başaramaz$$, FALSE, 0),
    ($$Aynı `kurs-net` ağı üzerinde şu anda `kurs-veritabani` `--name`'iyle çalışan hangi container'sa o$$, TRUE, 1),
    ($$Host makinenin kendi loopback arayüzü, tıpkı bu container içinde `localhost`un olacağı gibi$$, FALSE, 2),
    ($$Docker dışındaki herhangi bir makinenin de çözümleyebileceği gerçek, herkese açık bir internet hostname'i$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-networking'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-networking')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bir container içinde `localhost` (ya da `127.0.0.1`) neyi ifade eder?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir container içinde `localhost` (ya da `127.0.0.1`) neyi ifade eder?$$,
           NULL, NULL,
           $$Ders, her container'ın kendi izole ağ namespace'ini aldığını, bu yüzden bir container içindeki `localhost`un o container'ın kendi loopback arayüzünü ifade ettiğini belirtir -- host makinenin değil, başka herhangi bir container'ın da değil; başka bir container'a ulaşmanın `localhost` değil, onun `--name`'ini kullanmayı gerektirmesinin tam nedeni budur.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-networking'
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
    ($$Aynı ağda en son başlatılan hangi diğer container'sa o$$, FALSE, 0),
    ($$Docker'ın gömülü DNS sunucusu tarafından rastgele seçilen, dinamik olarak belirlenen bir container$$, FALSE, 1),
    ($$O container'ın kendi loopback arayüzü -- asla host makinenin değil, asla başka bir container'ın değil$$, TRUE, 2),
    ($$Konteynerize edilmemiş bir süreçte olacağı gibi, tam olarak host makinenin loopback arayüzü$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-networking'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'docker-networking')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, Docker networking hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, Docker networking hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (`docker network inspect <ad>`'ın belirli bir ağa şu anda hangi container'ların bağlı olduğunu tam olarak göstermesi, iki container'ın aynı ağda olup olmadığını doğrulamanın en hızlı yolu olması; `host.docker.internal`'in host makinedeki bir servise ulaşmasının, iki container'ın birbirine adla ulaşmasından temelde farklı bir durum olması); ders `-p` ile `--network`'ü birbirinin yerine geçebilir değil, farklı problemleri çözen şeyler olarak açıkça çerçeveler, ve Docker Compose dahil her gerçek çoklu-container kurulumunun aslında default bridge'i değil user-defined network'ü kullandığını adlandırır.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'docker-networking'
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
    ($$`host.docker.internal` (host makineye ulaşmak) ve bir container'ın user-defined network üzerindeki `--name`'i (başka bir container'a ulaşmak) iki farklı problemi çözer$$, TRUE, 0),
    ($$`-p` ve `--network` tamamen aynı problemi çözer ve her zaman birbirinin yerine kullanılabilir$$, FALSE, 1),
    ($$Docker Compose dahil her gerçek çoklu-container kurulumu, bu derste Docker'ın default bridge network'üne güvendiği şeklinde tanımlanır$$, FALSE, 2),
    ($$`docker network inspect <ad>`, belirli bir ağa şu anda hangi container'ların bağlı olduğunu tam olarak gösterir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'docker-networking'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
