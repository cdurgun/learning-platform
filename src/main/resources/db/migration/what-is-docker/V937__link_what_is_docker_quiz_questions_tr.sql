-- Promotion-style migration linking TR what-is-docker quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 5 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.


-- Question 1/5 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-docker')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, Docker nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, Docker nedir?$$,
           NULL, NULL,
           $$Ders, Docker'ı, bir uygulamayı çalışması için ihtiyaç duyduğu her şeyle (bağımlılıklar, runtime, yapılandırma) birlikte taşınabilir bir container'a paketleyen, ve bu birimi Docker kurulu herhangi bir makinede tutarlı şekilde çalıştıran bir platform olarak tanımlar.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-docker'
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
    ($$Uygulamaları Docker'ın kendi uzak sunucularında çalıştıran bir bulut barındırma sağlayıcısı$$, FALSE, 0),
    ($$Java kaynak kodunu derleyip paketlemek için Maven'ın yerini alan bir build aracı$$, FALSE, 1),
    ($$Bir uygulamayı çalışması için ihtiyaç duyduğu her şeyle birlikte taşınabilir bir container'a paketleyen, ve Docker kurulu herhangi bir makinede tutarlı şekilde çalıştıran bir platform$$, TRUE, 2),
    ($$Herhangi bir işletim sistemini çalıştırmak için donanımı emüle eden tam bir sanal makine hipervizörü$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-docker'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/5 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-docker')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, Docker hangi spesifik, tekrarlayan problemi çözmek için var?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, Docker hangi spesifik, tekrarlayan problemi çözmek için var?$$,
           NULL, NULL,
           $$Ders, spesifik problem olarak 'benim makinemde çalışıyor'u adlandırır -- container'lardan önce, dağıtım, hedef makinede doğru JDK sürümünün, ortam değişkenlerinin ve çakışan bağımlılık olmamasının zaten bulunmasına güvenmek anlamına geliyordu, bu yüzden bir geliştiricinin makinesi, test ve production arasındaki uyumsuzluklar yalnızca birinde ortaya çıkan hatalara yol açabiliyordu.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-docker'
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
    ($$Java kodunun diğer programlama dillerine kıyasla çok yavaş çalışması problemi$$, FALSE, 0),
    ($$Maven Central'ın belirli kurumsal ağlardan erişilemez olması problemi$$, FALSE, 1),
    ($$İlişkisel veritabanlarının yeterli sayıda eşzamanlı bağlantıyı desteklememesi problemi$$, FALSE, 2),
    ($$'Benim makinemde çalışıyor' problemi -- bir geliştiricinin makinesi, test ve production ortamları arasındaki uyumsuzlukların yalnızca birinde ortaya çıkan hatalara yol açması$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-docker'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/5 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-docker')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$'Containers vs. Virtual Machines'a göre, bir container'ın bir sanal makineden çok daha hızlı başlamasını açıklayan temel mimari fark nedir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$'Containers vs. Virtual Machines'a göre, bir container'ın bir sanal makineden çok daha hızlı başlamasını açıklayan temel mimari fark nedir?$$,
           NULL, NULL,
           $$Bir container, host makinenin var olan çekirdeğinde doğrudan çalışır (Linux namespace/cgroup'larla izole edilir), altında ikinci bir işletim sistemi yoktur; bir VM ise bir hipervizörün üzerinde tam bir guest OS çalıştırır -- pratik sonuç, bir container'ın önyükleyecek bir işletim sistemi olmaması, yalnızca uygulama sürecinin doğrudan başlamasıdır.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-docker'
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
    ($$Bir container, host makinenin var olan çekirdeğini doğrudan paylaşır, önyüklenecek bir guest OS yoktur; bir VM ise bir hipervizörün üzerinde tam bir guest OS çalıştırır$$, TRUE, 0),
    ($$Bir container, bir sanal makineden içsel olarak daha hızlı bir programlama dili kullanır$$, FALSE, 1),
    ($$Bir container her zaman bir sanal makineden daha güçlü donanımda çalıştırılır$$, FALSE, 2),
    ($$Bir container, bir sanal makinenin aksine uygulama bağımlılıklarını hiç yüklemez$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-docker'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/5 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-docker')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir ekip bir Spring Boot imajı inşa ediyor ve ondan aynı anda çalışan üç ayrı container başlatıyor. 'Images vs. Containers'a göre, orijinal imaja ne olur?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir ekip bir Spring Boot imajı inşa ediyor ve ondan aynı anda çalışan üç ayrı container başlatıyor. 'Images vs. Containers'a göre, orijinal imaja ne olur?$$,
           NULL, NULL,
           $$Ders, bir imajdan bir container başlatmanın o imajı tüketmediğini ya da değiştirmediğini belirtir -- aynı imaj, birbirinden bağımsız olarak istenildiği kadar container başlatmak için kullanılabilir, ve imajın kendisi inşa edildiği haliyle tam olarak kalır; bir imaj salt-okunur, dondurulmuş bir şablondur, bir container ise ondan oluşturulan çalışan bir örnektir (bir sınıf ve örnekleri gibi).$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-docker'
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
    ($$İmaj kilitlenir ve üçü de durana kadar başka hiçbir container başlatmak için kullanılamaz$$, FALSE, 0),
    ($$İmaj, inşa edildiği haliyle tam olarak kalır -- ondan container başlatmak onu tüketmez ya da değiştirmez, ve istenildiği kadar bağımsız container'ı destekleyebilir$$, TRUE, 1),
    ($$Üçüncü container ondan başlar başlamaz imaj otomatik olarak silinir$$, FALSE, 2),
    ($$İmaj, her container'a bir tane ayrılmış olmak üzere üç ayrı kopyaya bölünür$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-docker'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/5 (Pair 5 TR, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-docker')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, Docker'ın temel mekaniği hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, Docker'ın temel mekaniği hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (Docker Engine/dockerd'in gerçek işi yapan arka plan daemon'ı olması, CLI'ın ona konuşan ince bir client olması; bir registry'nin imajları, Maven Central'ın JAR artifact'lerini group/artifact/version ile depoladığı gibi ad ve tag ile depolaması); ders, `docker pull`'un her zaman yerel olarak sıfırdan bir imaj inşa ettiğini iddia etmez (bu bir registry'den çekmenin tam tersidir), ve Docker Hub'ın yalnızca varsayılan registry olduğunu, tek mümkün registry olmadığını açıkça belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-05 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-docker'
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
    ($$`docker pull`, bir registry'den zaten inşa edilmiş bir imajı getirmek yerine her zaman yerel olarak sıfırdan yeni bir imaj inşa eder$$, FALSE, 0),
    ($$Docker Hub, bir Docker kurulumunun imaj çekebileceği tek registry'dir -- özel ya da kendi barındırılan registry'ler mümkün değildir$$, FALSE, 1),
    ($$Docker Engine (`dockerd`), imajları gerçekten inşa eden ve container'ları çalıştıran arka plan daemon'ıdır; `docker` CLI'ı ona konuşan ince bir client'tır$$, TRUE, 2),
    ($$Bir image registry, imajları, Maven Central'ın JAR artifact'lerini group, artifact ve version ile depoladığı gibi, ad ve tag altında depolar$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-docker'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
