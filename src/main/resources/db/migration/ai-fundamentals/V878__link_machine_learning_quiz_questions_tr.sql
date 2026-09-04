-- Promotion-style migration linking TR machine-learning quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.


-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'machine-learning')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir 'öğrenme algoritması' ile ortaya çıkan 'model' arasındaki doğru ilişki nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir 'öğrenme algoritması' ile ortaya çıkan 'model' arasındaki doğru ilişki nedir?$$,
           NULL, NULL,
           $$Model (mimari + öğrenilmiş parametreler), eğitim verisini işleyen bir öğrenme algoritması TARAFINDAN üretilir -- algoritma ve model aynı şey değildir, ilişki tersine çevrilemez ve bir öğrenme algoritması yalnızca devreye almadan sonra değil, eğitim sırasında/öncesinde de vardır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'machine-learning'
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
    ($$Model, öğrenme algoritmasını oluşturmak için kullanılır$$, FALSE, 0),
    ($$Bir öğrenme algoritması yalnızca model devreye alındıktan sonra var olur$$, FALSE, 1),
    ($$Öğrenme algoritması eğitim verisini işler ve çıktısı olarak modeli (mimari + öğrenilmiş parametreler) üretir$$, TRUE, 2),
    ($$İkisi tamamen aynı şeydir, sadece farklı isimlerdir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'machine-learning'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'machine-learning')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir ekip, bir modeli birkaç saat boyunca geçmiş veriler üzerinde eğitiyor, ardından bitmiş modeli yeni, canlı veriler üzerinde milisaniyeler içinde tahmin yapmak için kullanıyor. Bu iki aşama ne olarak adlandırılır?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir ekip, bir modeli birkaç saat boyunca geçmiş veriler üzerinde eğitiyor, ardından bitmiş modeli yeni, canlı veriler üzerinde milisaniyeler içinde tahmin yapmak için kullanıyor. Bu iki aşama ne olarak adlandırılır?$$,
           NULL, NULL,
           $$Training verilerden öğrenmedir; inference ise eğitilmiş, dondurulmuş bir modeli yeni girdiler üzerinde tahmin üretmek için kullanmaktır -- diğer çiftler tamamen ilgisiz ya da farklı kavramları adlandırır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'machine-learning'
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
    ($$Derleme ve çalıştırma$$, FALSE, 0),
    ($$Validation ve test$$, FALSE, 1),
    ($$Supervised ve unsupervised learning$$, FALSE, 2),
    ($$Training ve inference$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'machine-learning'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'machine-learning')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir veri kümesi binlerce evi, her biri özellikleriyle (metrekare, konum, oda sayısı) VE bilinen bir satış fiyatıyla birlikte içeriyor. Bir model bu özelliklerden fiyatı tahmin etmek için eğitiliyor. Bu neyin örneğidir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir veri kümesi binlerce evi, her biri özellikleriyle (metrekare, konum, oda sayısı) VE bilinen bir satış fiyatıyla birlikte içeriyor. Bir model bu özelliklerden fiyatı tahmin etmek için eğitiliyor. Bu neyin örneğidir?$$,
           NULL, NULL,
           $$Etiketlenmiş veri (özellikler artı bilinen doğru etiket, yani satış fiyatı) supervised learning'in tanımlayıcı özelliğidir; unsupervised değildir (orada etikete gerek yoktur), reinforcement learning değildir (bir ödül/deneme-yanılma sinyali tarif edilmemiştir) ve 'inference' de değildir (o ayrı bir aşamadır, bir öğrenme türü değil).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'machine-learning'
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
    ($$Supervised learning, çünkü eğitim verisi etiketlenmiş doğru cevapları (bilinen satış fiyatlarını) içerir$$, TRUE, 0),
    ($$Unsupervised learning, çünkü model fiyat örüntülerini kendi başına keşfeder$$, FALSE, 1),
    ($$Reinforcement learning, çünkü model doğru tahminler için ödüllendirilir$$, FALSE, 2),
    ($$Inference, çünkü model tahmin yapmak için kullanılıyor$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'machine-learning'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'machine-learning')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir perakendeci, önceden tanımlanmış hiçbir segment etiketi olmadan, müşterilerini satın alma davranışına göre gruplara ayırmak istiyor. Bu görev için hangi öğrenme türü uygundur ve neden?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir perakendeci, önceden tanımlanmış hiçbir segment etiketi olmadan, müşterilerini satın alma davranışına göre gruplara ayırmak istiyor. Bu görev için hangi öğrenme türü uygundur ve neden?$$,
           NULL, NULL,
           $$Hiçbir etiket yoktur, bu yüzden model etiketlenmemiş veride yapıyı kendi başına bulmalıdır -- bu unsupervised learning'in tanımlayıcı özelliğidir; supervised değildir (etiket yoktur), reinforcement learning değildir (bir ödül/eylem döngüsü tarif edilmemiştir) ve 'inference' de değildir (bu farklı bir kavramdır, bir öğrenme türü değil bir aşamadır).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'machine-learning'
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
    ($$Inference, çünkü gruplama eğitimden sonra gerçekleşir$$, FALSE, 0),
    ($$Unsupervised learning, çünkü model etiketlenmemiş veride yapıyı/örüntüleri kendi başına bulur$$, TRUE, 1),
    ($$Supervised learning, çünkü müşterilerin zaten bilinen doğru segment etiketleri vardır$$, FALSE, 2),
    ($$Reinforcement learning, çünkü model her doğru gruplama için bir ödül alır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'machine-learning'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'machine-learning')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir model, eğitim verisinde %99 doğruluk elde ediyor ama daha önce görmediği yeni verilerde yalnızca %60 doğruluk gösteriyor. Bu klasik olarak neyin belirtisidir?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir model, eğitim verisinde %99 doğruluk elde ediyor ama daha önce görmediği yeni verilerde yalnızca %60 doğruluk gösteriyor. Bu klasik olarak neyin belirtisidir?$$,
           NULL, NULL,
           $$Eğitim ile görülmemiş veri performansı arasındaki büyük fark, overfitting'in klasik belirtisidir (genelleştirilebilir örüntüler öğrenmek yerine eğitim verisinin ayrıntılarını ezberlemek); underfitting olsaydı her iki kümede de kötü performans görülürdü, bu 'mükemmel eğitim' değildir ve reinforcement learning'e özgü bir durum da değildir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'machine-learning'
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
    ($$Mükemmel eğitim -- model görevi tamamen öğrendi$$, FALSE, 0),
    ($$Reinforcement learning hatası$$, FALSE, 1),
    ($$Overfitting -- model, genelleştirilebilir örüntüler öğrenmek yerine eğitim verisinin ayrıntılarını ezberledi$$, TRUE, 2),
    ($$Underfitting -- model, altta yatan örüntüyü yakalamak için çok basit$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'machine-learning'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'machine-learning')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Ekipler neden veriyi genellikle sadece iki kümeye (training ve test) değil, üç kümeye (training, validation ve test) ayırır?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Ekipler neden veriyi genellikle sadece iki kümeye (training ve test) değil, üç kümeye (training, validation ve test) ayırır?$$,
           NULL, NULL,
           $$Validation kümesi, geliştirme sırasında iteratif ayarlama/model seçimini destekler, test kümesi ise nihai değerlendirmeye kadar dokunulmadan kalır ve gerçek dünya performansına dair yansız bir tahmin verir; diğer seçenekler uydurmadır ve üç kümenin gerçekte nasıl kullanıldığıyla örtüşmez.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'machine-learning'
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
    ($$Machine learning projelerinde üç küme yasal bir zorunluluktur$$, FALSE, 0),
    ($$Üç küme olması eğitimi daha hızlı çalıştırır$$, FALSE, 1),
    ($$Test kümesi yalnızca eğitim sırasında, validation ise yalnızca devreye almadan sonra kullanılır$$, FALSE, 2),
    ($$Validation kümesi, geliştirme sırasında modeli ayarlamak için kullanılır, böylece nihai değerlendirme için dokunulmamış kalan test kümesi kirlenmez$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'machine-learning'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'machine-learning')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bir machine learning modelini değerlendirmekle ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir machine learning modelini değerlendirmekle ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve C derse göre doğrudur (eğitim kümesi skoru gerçek performansa dair güvenilir bir kanıt değildir; underfitting hem eğitim hem görülmemiş veri performansını kötü etkiler); reinforcement learning, supervised learning'in aksine etiketlenmiş bir doğru-cevap veri kümesi yerine ödül sinyalleri kullanır, ve üç öğrenme türü her göreve birbirinin yerine geçebilecek şekilde değil, farklı problem yapılarına uygun şekilde kullanılır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'machine-learning'
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
    ($$Bir modelin kendi eğitim kümesindeki skoru, yeni verilerde ne kadar iyi performans göstereceğine dair güvenilir bir kanıt değildir$$, TRUE, 0),
    ($$Underfit olan bir model, örüntüyü yakalamak için çok basit olduğundan hem eğitim hem de görülmemiş verilerde kötü performans gösterir$$, TRUE, 1),
    ($$Reinforcement learning, tıpkı supervised learning gibi, her zaman etiketlenmiş doğru cevaplardan oluşan bir veri kümesi gerektirir$$, FALSE, 2),
    ($$Üç öğrenme türü (supervised, unsupervised, reinforcement) herhangi bir görev için her zaman birbirinin yerine kullanılabilir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'machine-learning'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
