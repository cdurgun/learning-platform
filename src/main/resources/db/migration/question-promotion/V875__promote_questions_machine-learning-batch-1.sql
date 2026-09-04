-- Promotion batch
-- Topic: machine-learning (language: en x7, tr x7)
-- Generated: 2026-09-04 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project (React/Java/
-- Spring/Postgres/Git categories), these 14 questions were hand-authored
-- and independently self-reviewed directly inside a Claude Code session,
-- grounded strictly in content/en/machine-learning.md and content/tr/machine-learning.md --
-- NOT produced by the n8n generation pipeline, NOT judged by the AI Judge,
-- and NOT ingested via /api/internal/questions/ingest.
--
-- Strict 50/50 EN/TR split (7+7) organized as 7 CONCEPT PAIRS -- each EN
-- question has a TR counterpart testing the exact same concept, but
-- independently authored (different framing/options), not a translation.
-- Every question whose answer depends on shown code is typed CODE_OUTPUT
-- (never SINGLE_CHOICE/MULTIPLE_CHOICE with a code_snippet attached) --
-- fragments/quiz.html only renders code_snippet for CODE_OUTPUT questions,
-- per the bug found and fixed in try-catch-finally/V573.
--
-- Each question's 4 options are written with the correct answer at a
-- deterministic, varied position, computed via
-- (pair_num + version + lang_shift) % 4 -- per the bug found and fixed at
-- question-promotion/V598 (always-A bias) and refined again in the Spring
-- Data JPA batch (parity-locked EN/TR offsets).
--
-- source = 'CLAUDE' / reviewed_by = 'claude-code@anthropic.com' / status =
-- 'PUBLISHED' directly -- same documentation convention as every prior
-- manual batch. topic_id resolved by Topic.slug; question_option rows
-- reference the newly generated id via a WITH ... RETURNING id CTE.
--
-- Duplicate-promotion safety: N/A -- this batch was never ingested into
-- development, so no dev ids exist for these 14 questions at all.


-- Pair 1 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$What is the correct relationship between a "learning algorithm" and the resulting "model"?$$,
           NULL, NULL,
           $$The model (architecture + learned parameters) is produced BY a learning algorithm processing training data -- algorithm and model are not the same thing, the relationship isn't reversed, and a learning algorithm exists before/during training, not only after deployment.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'machine-learning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The learning algorithm processes training data and produces the model (architecture + learned parameters) as its output$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$They are exactly the same thing, just different names$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$The model is used to create the learning algorithm$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$A learning algorithm only exists after the model is deployed$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir 'öğrenme algoritması' ile ortaya çıkan 'model' arasındaki doğru ilişki nedir?$$,
           NULL, NULL,
           $$Model (mimari + öğrenilmiş parametreler), eğitim verisini işleyen bir öğrenme algoritması TARAFINDAN üretilir -- algoritma ve model aynı şey değildir, ilişki tersine çevrilemez ve bir öğrenme algoritması yalnızca devreye almadan sonra değil, eğitim sırasında/öncesinde de vardır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'machine-learning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Model, öğrenme algoritmasını oluşturmak için kullanılır$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Bir öğrenme algoritması yalnızca model devreye alındıktan sonra var olur$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Öğrenme algoritması eğitim verisini işler ve çıktısı olarak modeli (mimari + öğrenilmiş parametreler) üretir$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$İkisi tamamen aynı şeydir, sadece farklı isimlerdir$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$A team trains a model on historical data over several hours, then later uses the finished model to make predictions on new, live data in milliseconds. What are these two phases called?$$,
           NULL, NULL,
           $$Training is learning from data; inference is using a trained, frozen model to produce predictions on new input -- the other pairs name unrelated or different concepts entirely.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'machine-learning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Supervised and unsupervised learning$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$Training and inference$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$Compilation and execution$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$Validation and testing$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bir ekip, bir modeli birkaç saat boyunca geçmiş veriler üzerinde eğitiyor, ardından bitmiş modeli yeni, canlı veriler üzerinde milisaniyeler içinde tahmin yapmak için kullanıyor. Bu iki aşama ne olarak adlandırılır?$$,
           NULL, NULL,
           $$Training verilerden öğrenmedir; inference ise eğitilmiş, dondurulmuş bir modeli yeni girdiler üzerinde tahmin üretmek için kullanmaktır -- diğer çiftler tamamen ilgisiz ya da farklı kavramları adlandırır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'machine-learning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Derleme ve çalıştırma$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Validation ve test$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Supervised ve unsupervised learning$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Training ve inference$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A dataset contains thousands of houses, each with features (square footage, location, number of rooms) AND a known sale price. A model is trained to predict price from these features. This is an example of:$$,
           NULL, NULL,
           $$Labeled data (features plus a known correct label, the sale price) is the defining trait of supervised learning; it isn't unsupervised (no labels are needed there), isn't reinforcement learning (no reward/trial-and-error signal is described), and isn't "inference" (that's a separate phase, not a learning type).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'machine-learning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Reinforcement learning, since the model is rewarded for correct predictions$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$Inference, since the model is being used to make predictions$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$Supervised learning, since the training data includes labeled correct answers (the known sale prices)$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$Unsupervised learning, since the model discovers price patterns on its own$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir veri kümesi binlerce evi, her biri özellikleriyle (metrekare, konum, oda sayısı) VE bilinen bir satış fiyatıyla birlikte içeriyor. Bir model bu özelliklerden fiyatı tahmin etmek için eğitiliyor. Bu neyin örneğidir?$$,
           NULL, NULL,
           $$Etiketlenmiş veri (özellikler artı bilinen doğru etiket, yani satış fiyatı) supervised learning'in tanımlayıcı özelliğidir; unsupervised değildir (orada etikete gerek yoktur), reinforcement learning değildir (bir ödül/deneme-yanılma sinyali tarif edilmemiştir) ve 'inference' de değildir (o ayrı bir aşamadır, bir öğrenme türü değil).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'machine-learning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Supervised learning, çünkü eğitim verisi etiketlenmiş doğru cevapları (bilinen satış fiyatlarını) içerir$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Unsupervised learning, çünkü model fiyat örüntülerini kendi başına keşfeder$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Reinforcement learning, çünkü model doğru tahminler için ödüllendirilir$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Inference, çünkü model tahmin yapmak için kullanılıyor$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A retailer wants to group its customers into segments based on purchasing behavior, without having any predefined labels for what each segment should be. Which type of learning fits this task, and why?$$,
           NULL, NULL,
           $$No labels are present, so the model must find structure in unlabeled data on its own -- the defining trait of unsupervised learning; it isn't supervised (there are no labels), isn't reinforcement learning (no reward/action loop is described), and isn't "inference" (a different concept, a phase not a learning type).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'machine-learning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Supervised learning, because customers already have known correct segment labels$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Reinforcement learning, because the model receives a reward for each correct grouping$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Inference, because grouping happens after training$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Unsupervised learning, because the model finds structure/patterns in unlabeled data on its own$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir perakendeci, önceden tanımlanmış hiçbir segment etiketi olmadan, müşterilerini satın alma davranışına göre gruplara ayırmak istiyor. Bu görev için hangi öğrenme türü uygundur ve neden?$$,
           NULL, NULL,
           $$Hiçbir etiket yoktur, bu yüzden model etiketlenmemiş veride yapıyı kendi başına bulmalıdır -- bu unsupervised learning'in tanımlayıcı özelliğidir; supervised değildir (etiket yoktur), reinforcement learning değildir (bir ödül/eylem döngüsü tarif edilmemiştir) ve 'inference' de değildir (bu farklı bir kavramdır, bir öğrenme türü değil bir aşamadır).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'machine-learning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Inference, çünkü gruplama eğitimden sonra gerçekleşir$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Unsupervised learning, çünkü model etiketlenmemiş veride yapıyı/örüntüleri kendi başına bulur$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Supervised learning, çünkü müşterilerin zaten bilinen doğru segment etiketleri vardır$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Reinforcement learning, çünkü model her doğru gruplama için bir ödül alır$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$A model achieves 99% accuracy on its training data but only 60% accuracy on new, unseen data. This is a classic sign of:$$,
           NULL, NULL,
           $$A large gap between training and unseen performance is the classic sign of overfitting (memorizing the training data's specifics instead of learning generalizable patterns); underfitting would instead show poor performance on both sets, this isn't "perfect training," and it isn't specific to reinforcement learning.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'machine-learning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Overfitting -- the model memorized the training data's specifics instead of learning generalizable patterns$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Underfitting -- the model is too simple to capture the underlying pattern$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Perfect training -- the model has fully learned the task$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Reinforcement learning failure$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bir model, eğitim verisinde %99 doğruluk elde ediyor ama daha önce görmediği yeni verilerde yalnızca %60 doğruluk gösteriyor. Bu klasik olarak neyin belirtisidir?$$,
           NULL, NULL,
           $$Eğitim ile görülmemiş veri performansı arasındaki büyük fark, overfitting'in klasik belirtisidir (genelleştirilebilir örüntüler öğrenmek yerine eğitim verisinin ayrıntılarını ezberlemek); underfitting olsaydı her iki kümede de kötü performans görülürdü, bu 'mükemmel eğitim' değildir ve reinforcement learning'e özgü bir durum da değildir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'machine-learning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Mükemmel eğitim -- model görevi tamamen öğrendi$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Reinforcement learning hatası$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Overfitting -- model, genelleştirilebilir örüntüler öğrenmek yerine eğitim verisinin ayrıntılarını ezberledi$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Underfitting -- model, altta yatan örüntüyü yakalamak için çok basit$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why do teams typically split data into three sets (training, validation, and test) instead of just two (training and test)?$$,
           NULL, NULL,
           $$The validation set supports iterative tuning/model selection during development, while the test set stays untouched until the final evaluation, giving an unbiased estimate of real-world performance; the other options are fabricated and don't match how the three sets are actually used.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'machine-learning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The test set is only used during training, and validation is only used after deployment$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$The validation set is used to tune the model during development without contaminating the final, untouched test set used for the true final evaluation$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Three sets are required by law in machine learning projects$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Having three sets makes training run faster$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Ekipler neden veriyi genellikle sadece iki kümeye (training ve test) değil, üç kümeye (training, validation ve test) ayırır?$$,
           NULL, NULL,
           $$Validation kümesi, geliştirme sırasında iteratif ayarlama/model seçimini destekler, test kümesi ise nihai değerlendirmeye kadar dokunulmadan kalır ve gerçek dünya performansına dair yansız bir tahmin verir; diğer seçenekler uydurmadır ve üç kümenin gerçekte nasıl kullanıldığıyla örtüşmez.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'machine-learning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Machine learning projelerinde üç küme yasal bir zorunluluktur$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Üç küme olması eğitimi daha hızlı çalıştırır$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Test kümesi yalnızca eğitim sırasında, validation ise yalnızca devreye almadan sonra kullanılır$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Validation kümesi, geliştirme sırasında modeli ayarlamak için kullanılır, böylece nihai değerlendirme için dokunulmamış kalan test kümesi kirlenmez$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following are true about evaluating a machine learning model, according to this lesson? (Select all that apply)$$,
           NULL, NULL,
           $$A and C are correct per the lesson (training-set score isn't trustworthy evidence of real performance; underfitting hurts both training and unseen performance); reinforcement learning uses reward signals rather than a labeled dataset of correct answers like supervised learning does, and the three learning types suit different problem shapes rather than being universally interchangeable.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'machine-learning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Reinforcement learning always requires a labeled dataset of correct answers, just like supervised learning$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$The three types of learning (supervised, unsupervised, reinforcement) are always interchangeable for any given task$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$A model's score on its own training set is not trustworthy evidence of how well it will perform on new data$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$A model that underfits performs poorly on both training and unseen data because it's too simple to capture the pattern$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir machine learning modelini değerlendirmekle ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve C derse göre doğrudur (eğitim kümesi skoru gerçek performansa dair güvenilir bir kanıt değildir; underfitting hem eğitim hem görülmemiş veri performansını kötü etkiler); reinforcement learning, supervised learning'in aksine etiketlenmiş bir doğru-cevap veri kümesi yerine ödül sinyalleri kullanır, ve üç öğrenme türü her göreve birbirinin yerine geçebilecek şekilde değil, farklı problem yapılarına uygun şekilde kullanılır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'machine-learning'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir modelin kendi eğitim kümesindeki skoru, yeni verilerde ne kadar iyi performans göstereceğine dair güvenilir bir kanıt değildir$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Underfit olan bir model, örüntüyü yakalamak için çok basit olduğundan hem eğitim hem de görülmemiş verilerde kötü performans gösterir$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Reinforcement learning, tıpkı supervised learning gibi, her zaman etiketlenmiş doğru cevaplardan oluşan bir veri kümesi gerektirir$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Üç öğrenme türü (supervised, unsupervised, reinforcement) herhangi bir görev için her zaman birbirinin yerine kullanılabilir$$, FALSE, 3 FROM new_question_tr7;
