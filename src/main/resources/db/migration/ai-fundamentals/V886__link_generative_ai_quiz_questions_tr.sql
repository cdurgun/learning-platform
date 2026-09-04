-- Promotion-style migration linking TR generative-ai quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.


-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generative-ai')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Generative AI, deep learning'den ayrı bir teknik midir yoksa onun bir uygulaması mıdır?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Generative AI, deep learning'den ayrı bir teknik midir yoksa onun bir uygulaması mıdır?$$,
           NULL, NULL,
           $$Ders, Generative AI'ın (deep learning gibi) var olan tekniklerin bir uygulaması olduğunu, ayrı bir teknik olmadığını açıkça belirtir -- yeni içerik üretmek için özellikle eğitilmiştir; deep learning/sinir ağları üzerine inşa edilir, salt unsupervised learning ile tanımlanmaz ve machine learning'den daha eski değildir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generative-ai'
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
    ($$Sinir ağlarıyla hiçbir ilgisi olmayan, unsupervised learning'in bir alt kümesidir$$, FALSE, 0),
    ($$Machine learning'den bile önce var olan, daha eski bir tekniktir$$, FALSE, 1),
    ($$Var olan tekniklerin (deep learning gibi) bir uygulamasıdır, özellikle yeni içerik üretmek için eğitilmiştir$$, TRUE, 2),
    ($$Kendi ilgisiz mimarisine sahip, tamamen ayrı bir tekniktir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generative-ai'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generative-ai')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Model A bir e-postayı alıp 'spam' veya 'spam değil' etiketini çıktı olarak veriyor. Model B ise bir konuyu alıp o konu hakkında yepyeni bir paragraf metin üretiyor. Hangisi generative'dir ve neden?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Model A bir e-postayı alıp 'spam' veya 'spam değil' etiketini çıktı olarak veriyor. Model B ise bir konuyu alıp o konu hakkında yepyeni bir paragraf metin üretiyor. Hangisi generative'dir ve neden?$$,
           NULL, NULL,
           $$Generative modeller yeni içerik yaratır (Model B); discriminative modeller ise var olan bir girdi için kategori sınıflandırır/tahmin eder (Model A) -- yalnızca 'çıktı üretmek' bir şeyi generative yapmaz, ve sınıflandırma ile metin üretimi açıkça farklı görevlerdir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generative-ai'
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
    ($$Model A, çünkü bir karar veriyor$$, FALSE, 0),
    ($$İkisi de, çünkü ikisi de girdi işleyip çıktı üretiyor$$, FALSE, 1),
    ($$Hiçbiri, çünkü sınıflandırma ve metin üretimi aynı görevdir$$, FALSE, 2),
    ($$Model B, çünkü var olan girdiyi sınıflandırmak/kategori tahmin etmek yerine yeni içerik yaratıyor$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generative-ai'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generative-ai')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Mekanik düzeyde, bir generative metin modeli çok cümlelik bir yanıtı nasıl üretir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Mekanik düzeyde, bir generative metin modeli çok cümlelik bir yanıtı nasıl üretir?$$,
           NULL, NULL,
           $$Metin üretimi, o ana kadar üretilenlere dayanarak, tek seferde bir token olacak şekilde, tekrar tekrar en olası bir sonraki token'ı tahmin ederek çalışır -- bir veritabanından arama/getirme değildir, tüm yanıtı aynı anda üretme değildir ve sabit özetle-sonra-genişlet prosedürü değildir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generative-ai'
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
    ($$O ana kadar üretilenlere dayanarak, tek seferde bir token olacak şekilde, tekrar tekrar en olası bir sonraki token'ı tahmin eder$$, TRUE, 0),
    ($$Büyük bir arama veritabanından önceden yazılmış, eşleşen bir yanıtı getirir$$, FALSE, 1),
    ($$Tüm yanıtı, sıra kavramı olmadan tek, bölünemez bir adımda aynı anda üretir$$, FALSE, 2),
    ($$Önce bir özet üretir, sonra bunu her zaman bu sabit sırayla bir paragrafa genişletir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generative-ai'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generative-ai')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Görüntü üretimi için yaygın bir yaklaşım olan diffusion modelleri genellikle nasıl çalışır?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Görüntü üretimi için yaygın bir yaklaşım olan diffusion modelleri genellikle nasıl çalışır?$$,
           NULL, NULL,
           $$Diffusion modelleri rastgele gürültüden başlar ve bunu adım adım tutarlı bir görüntüye dönüştürecek şekilde kademeli olarak iyileştirir -- var olan eğitim görüntülerini kopyalamazlar, sabit soldan-sağa piksel taraması kullanmazlar ve önce bir insan taslağı gerektirmezler.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generative-ai'
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
    ($$Önce bir insanın elle taslak çizmesini gerektirirler$$, FALSE, 0),
    ($$Rastgele gürültüden başlayıp bunu adım adım tutarlı bir görüntüye dönüştürecek şekilde kademeli olarak iyileştirirler$$, TRUE, 1),
    ($$Eğitim verisinden var olan bir görüntüyü kopyalayıp üzerine bir filtre uygularlar$$, FALSE, 2),
    ($$Görüntüleri, sonsuza kadar tek seferde bir piksel olacak şekilde, sabit soldan-sağa bir tarama sırasıyla bir sonraki pikseli tahmin ederek üretirler$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generative-ai'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generative-ai')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Geleneksel bir yapay zeka sistemi, bir kredi başvurusunda bulunanın temerrüde düşüp düşmeyeceğini (evet/hayır) tahmin ediyor. Aynı başvuru sahibinin verileri verildiğinde, bir generative AI sistemi ise kredi kararını açıklayan tam bir paragraf yazıyor. Her sistemin ne yapmak için eğitildiği arasındaki temel fark nedir?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Geleneksel bir yapay zeka sistemi, bir kredi başvurusunda bulunanın temerrüde düşüp düşmeyeceğini (evet/hayır) tahmin ediyor. Aynı başvuru sahibinin verileri verildiğinde, bir generative AI sistemi ise kredi kararını açıklayan tam bir paragraf yazıyor. Her sistemin ne yapmak için eğitildiği arasındaki temel fark nedir?$$,
           NULL, NULL,
           $$Temel ayrım, discriminative/tahmin edici eğitim (var olan örüntülerden sabit bir sonucu sınıflandırmak) ile generative/yaratıcı eğitim (yeni, özgün içerik yaratmak) arasındadır; doğruluk karşılaştırmaları ve 'hangisi sinir ağı kullanır' iddiaları dersin yapmadığı desteksiz genellemelerdir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generative-ai'
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
    ($$Generative sistem her görevde geleneksel sistemden kesinlikle daha doğrudur$$, FALSE, 0),
    ($$Geleneksel yapay zeka sistemleri her zaman sinir ağı kullanır, generative yapay zeka sistemleri ise asla kullanmaz$$, FALSE, 1),
    ($$Geleneksel sistem, var olan örüntülerden sabit bir sonucu tahmin etmek/sınıflandırmak için eğitilir; generative sistem ise yeni, özgün içerik yaratmak için eğitilir$$, TRUE, 2),
    ($$Gerçek bir fark yoktur -- ikisi de aynı işi yapan 'yapay zeka'dır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generative-ai'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generative-ai')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu dersin 'Generative AI Ne Değildir' bölümüne göre, aşağıdakilerden hangisi Generative AI hakkında açıkça doğrudur?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu dersin 'Generative AI Ne Değildir' bölümüne göre, aşağıdakilerden hangisi Generative AI hakkında açıkça doğrudur?$$,
           NULL, NULL,
           $$Ders, 'generative' olmayı açıkça 'agentic' olmaktan ve 'AGI'dan ayırır ve akıcı çıktının otomatik olarak doğru olmadığını belirtir (hallucination burada tanıtılır) -- diğer seçenekler dersin söylediğiyle doğrudan çelişir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generative-ai'
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
    ($$Generative AI, insansı metin üretebildiği için bir AGI türüdür$$, FALSE, 0),
    ($$Bir generative modelin akıcı çıktısı her zaman gerçek doğruluğu garanti eder$$, FALSE, 1),
    ($$Generative AI sistemleri yanlış bilgi üretmekten aciz sistemlerdir$$, FALSE, 2),
    ($$Generative AI otomatik olarak agentic değildir -- içerik üretebilmek, bir sistemin dünyada bağımsız olarak eylemler gerçekleştirebileceği anlamına gelmez$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generative-ai'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generative-ai')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, Generative AI hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, Generative AI hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (akıcılık ve doğruluğun ayrı özellikler olması; metin/görüntü/ses/video/kod arasında dallanma); LLM'ler generative AI'ın yalnızca bir dalıdır (metin), tüm kategori değildir, ve discriminative ile generative modellerin açıkça farklı eğitim hedefleri vardır (sınıflandırma/tahmin vs. yaratma).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generative-ai'
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
    ($$Akıcılık ve gerçek doğruluk ayrı özelliklerdir -- akıcı bir yanıt otomatik olarak doğru bir yanıt değildir$$, TRUE, 0),
    ($$Generative AI, metin, görüntü, ses, video ve kod dahil olmak üzere birden çok içerik türüne dallanır$$, TRUE, 1),
    ($$Her generative AI modeli, tanım gereği aynı zamanda bir LLM'dir$$, FALSE, 2),
    ($$Discriminative bir model ile generative bir model tam olarak aynı hedefe yönelik eğitilir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generative-ai'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
