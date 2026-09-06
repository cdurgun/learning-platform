-- Promotion-style migration linking TR microservices-fundamentals quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.

-- Question 1/7 (TR pair 1, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$microservices-fundamentals$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bir mikroservis ile bir monolit içindeki bir modül arasındaki temel yapısal fark nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir mikroservis ile bir monolit içindeki bir modül arasındaki temel yapısal fark nedir?$$,
           NULL, NULL,
           $$Ders, monolitin özelliklerini (tek kod tabanı, tek deploy birimi, doğrudan metot çağrıları, paylaşılan veritabanı) mikroservisin temel özellikleriyle (bağımsız deploy edilebilirlik ve kendi veri sahipliği) karşılaştırır.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$microservices-fundamentals$$
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
    ($$Bir mikroservis, sistemin geri kalanından farklı bir dilde yazılmak zorundadır$$, FALSE, 0),
    ($$Bir mikroservis eşdeğer bir monolit modülünden her zaman daha fazla kod içerir$$, FALSE, 1),
    ($$Bir mikroservis, kendi verisinin sahibi olan, ayrı ve bağımsız deploy edilebilen bir süreçtir; monolitin modülleri tek bir süreci ve veritabanını paylaşır$$, TRUE, 2),
    ($$Bir mikroservis asla REST API sunamaz$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$microservices-fundamentals$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (TR pair 2, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$microservices-fundamentals$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$"Neden Var? (Monolitin Sınırları)" bölümüne göre, monolitin "küçük bir değişiklik için tüm uygulamayı yeniden build etme" sorunu gerçekte ne zaman acıtmaya başlar?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$"Neden Var? (Monolitin Sınırları)" bölümüne göre, monolitin "küçük bir değişiklik için tüm uygulamayı yeniden build etme" sorunu gerçekte ne zaman acıtmaya başlar?$$,
           NULL, NULL,
           $$Ders, sorunun uygulama ve onu geliştiren ekip büyüdükçe ortaya çıktığını açıklar -- onlarca geliştirici, sık merge çakışmaları, modüller arası dengesiz trafik.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$microservices-fundamentals$$
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
    ($$Herhangi bir projenin, boyutundan bağımsız olarak, ilk gününden itibaren$$, FALSE, 0),
    ($$Yalnızca uygulama bir bulut sağlayıcısına deploy edildiğinde$$, FALSE, 1),
    ($$Uygulama ve onu geliştiren ekip büyüdükçe -- onlarca geliştirici, sık merge çakışmaları, modüller arası dengesiz trafik$$, TRUE, 2),
    ($$Yalnızca uygulama ilişkisel bir veritabanı kullanmayı bıraktığında$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$microservices-fundamentals$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (TR pair 3, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$microservices-fundamentals$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Bir ekip bir uygulamayı servislere böler ama hepsinin aynı paylaşılan veritabanı şemasını okuyup yazmasına izin verir. Bu ders bu sonucu ne olarak adlandırır?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir ekip bir uygulamayı servislere böler ama hepsinin aynı paylaşılan veritabanı şemasını okuyup yazmasına izin verir. Bu ders bu sonucu ne olarak adlandırır?$$,
           NULL, NULL,
           $$Ders bunu bir "distributed monolith" (dağıtık monolit) olarak tanımlar -- mikroservislerin tüm operasyonel maliyetini taşır, monolitin basitlik avantajının hiçbirini taşımaz.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$microservices-fundamentals$$
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
    ($$Modüler bir monolit$$, FALSE, 0),
    ($$Bir bounded context$$, FALSE, 1),
    ($$Dağıtık bir monolit (distributed monolith) -- mikroservislerin tüm operasyonel maliyetini taşır, monolitin basitlik avantajının hiçbirini taşımaz$$, TRUE, 2),
    ($$Orkestre edilmiş bir saga$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$microservices-fundamentals$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (TR pair 4, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$microservices-fundamentals$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$"A Quick Look at the CAP Theorem" bölümüne göre, bir ağ bölünmesi (network partition) yaşandığında dağıtık bir sistem gerçekte hangi seçimle karşı karşıya kalır?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$"A Quick Look at the CAP Theorem" bölümüne göre, bir ağ bölünmesi (network partition) yaşandığında dağıtık bir sistem gerçekte hangi seçimle karşı karşıya kalır?$$,
           NULL, NULL,
           $$Ders, Partition Tolerance gerçekçi olarak terk edilemeyeceği için, bir bölünme sırasındaki pratik seçimin Consistency ile Availability arasında olduğunu açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$microservices-fundamentals$$
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
    ($$Consistency ile Partition Tolerance arasında, çünkü Availability tanım gereği garantidir$$, FALSE, 0),
    ($$Consistency ile Availability arasında, çünkü Partition Tolerance gerçek dünyada terk edilemez$$, TRUE, 1),
    ($$Üç özelliğin tamamı arasında, hiçbir değiş tokuş gerekmeden$$, FALSE, 2),
    ($$REST kullanmak ile mesaj kuyruğu kullanmak arasında$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$microservices-fundamentals$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (TR pair 5, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$microservices-fundamentals$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$"Conway Yasası" bölümüne göre, gözlem, tek, büyük ve sıkı koordineli bir ekibe sahip bir şirket hakkında gerçekte neyi öngörür?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$"Conway Yasası" bölümüne göre, gözlem, tek, büyük ve sıkı koordineli bir ekibe sahip bir şirket hakkında gerçekte neyi öngörür?$$,
           NULL, NULL,
           $$Ders, tersinin de doğru olduğunu belirtir: tek, büyük, sıkı koordineli bir ekip, zaten sürekli eşzamanlı iletişim içinde olduğu için doğal olarak tek bir monolit üretme eğiliminde olur.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$microservices-fundamentals$$
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
    ($$O ekip, uyumluluk nedenleriyle her zaman mikroservis benimsemek zorunda kalır$$, FALSE, 0),
    ($$O ekip, zaten sürekli eşzamanlı iletişim içinde olduğu için doğal olarak tek bir monolit üretme eğiliminde olur$$, TRUE, 1),
    ($$O ekibin yazılımı otomatik olarak veritabanı tablolarıyla eşleşen servislere bölünür$$, FALSE, 2),
    ($$Conway Yasası yalnızca 2011'den sonra kurulan organizasyonlara uygulanır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$microservices-fundamentals$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (TR pair 6, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$microservices-fundamentals$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılan "modüler monolit" yaklaşımı, tam mikroservislere kıyasla gerçekte neyi korur?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılan "modüler monolit" yaklaşımı, tam mikroservislere kıyasla gerçekte neyi korur?$$,
           NULL, NULL,
           $$Ders, bir modüler monolitin modüller arasında tek bir süreç ve doğrudan metot çağrıları koruduğunu, bu yüzden ağ güvenilmezliği, kısmi hata veya eventual consistency problemlerini hiç yaşamadığını açıklar.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$microservices-fundamentals$$
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
    ($$Modül başına bağımsız veritabanları, ama paylaşılan bir deploy süreci$$, FALSE, 0),
    ($$Tek bir süreç ve modüller arası doğrudan metot çağrıları -- bu yüzden ağ güvenilmezliği veya eventual consistency maliyetlerinin hiçbiri geçerli olmaz$$, TRUE, 1),
    ($$Modül başına bağımsız ölçeklenebilirlik, ama tek bir paylaşılan kod tabanı$$, FALSE, 2),
    ($$Dağıtık bir sistemle birebir aynı deploy pipeline'ı$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$microservices-fundamentals$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (TR pair 7, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = $$microservices-fundamentals$$)
      AND language = $$tr$$
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri bu derste mikroservis benimsemeye yönelen gerçek sinyaller olarak sunulur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri bu derste mikroservis benimsemeye yönelen gerçek sinyaller olarak sunulur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Ders, farklı ölçeklenme ihtiyaçlarını ve ekiplerin bağımsız deploy hızı istemesini mikroservise yönelen sinyaller olarak listeler; küçük bir ekip ve oturmamış bir domain ise açıkça monolite yönelen sinyaller olarak listelenir.$$, $$claude-code@anthropic.com$$, '2026-09-07 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = $$microservices-fundamentals$$
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
    ($$Farklı modüllerin belirgin şekilde farklı trafik/ölçeklenme ihtiyaçları vardır$$, TRUE, 0),
    ($$Ekip küçüktür (bir avuç geliştirici)$$, FALSE, 1),
    ($$Farklı ekipler birbirini engellemeden kendi hızlarında deploy etmek ister$$, TRUE, 2),
    ($$Domain/iş kuralları henüz oturmamıştır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = $$microservices-fundamentals$$
  AND quiz.language = $$tr$$
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
