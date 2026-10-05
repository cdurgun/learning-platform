-- Links the TR developing-with-claude-code questions to the topic's fixed quiz. Same NOT EXISTS /
-- ON CONFLICT DO NOTHING pattern as every prior quiz-link migration: each question is
-- found by its text (or created if missing) and linked at its position, so the file is
-- safe on a fresh database and on one where the promotion migration already ran.

-- Question 1/7 (pair 1 TR, quiz position 1, SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'developing-with-claude-code')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Claude Code dosyaları gerçekten değiştirebildiği için hangi alışkanlıklar isteğe bağlı olmaktan çıkar?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Claude Code dosyaları gerçekten değiştirebildiği için hangi alışkanlıklar isteğe bağlı olmaktan çıkar?$$,
           NULL, NULL,
           $$Bir araç dosyalarını gerçekten değiştirebiliyor ve komut çalıştırabiliyorsa, izin vermek ve yapılanı gözden geçirmek artık aracı kullanmanın bir parçasıdır. Kod parçalarını elle kopyalayıp yapıştırmak ise tam tersine, bu araçla birlikte ortadan kalkan eski çalışma biçimidir.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'developing-with-claude-code'
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
        ($$Kod parçalarını elle kopyalayıp yapıştırma$$, FALSE, 0),
        ($$Proje yapısını her görevde baştan anlatma$$, FALSE, 1),
        ($$İzin verme ve gözden geçirme$$, TRUE, 2),
        ($$Komutları terminalde kendi başına çalıştırma$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'developing-with-claude-code'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (pair 2 TR, quiz position 2, SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'developing-with-claude-code')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Proje kökünde bir `CLAUDE.md` dosyası olmasaydı Claude Code ne yapmak zorunda kalırdı?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Proje kökünde bir `CLAUDE.md` dosyası olmasaydı Claude Code ne yapmak zorunda kalırdı?$$,
           NULL, NULL,
           $$Bu dosya olmadan Claude Code, projenin kurallarını ve konvansiyonlarını her görevde baştan tahmin etmek zorunda kalırdı; bazen doğru, bazen yanlış tahmin ederdi. `CLAUDE.md`, yeni bir ekip arkadaşına "önce şu dokümanı oku" demenin karşılığıdır.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'developing-with-claude-code'
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
        ($$Her dosya değişikliği için iki ayrı onay istemek$$, FALSE, 0),
        ($$Aynı anda yalnızca tek bir dosya üzerinde çalışmak$$, FALSE, 1),
        ($$Her görevden önce projeyi yeniden kurmak$$, FALSE, 2),
        ($$Projenin kurallarını ve konvansiyonlarını her görevde baştan tahmin etmek$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'developing-with-claude-code'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (pair 3 TR, quiz position 3, SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'developing-with-claude-code')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$"Bir quiz sistemi yap" gibi belirsiz bir görev genellikle nasıl sonuçlanır?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$"Bir quiz sistemi yap" gibi belirsiz bir görev genellikle nasıl sonuçlanır?$$,
           NULL, NULL,
           $$Belirsiz bir görev, Claude Code'u hangi konu, kaç soru, hangi diller ve hangi kısıtlar gibi her şeyi tahmin etmeye zorlar. Sonuç çoğunlukla kapsamın kendiliğinden büyümesidir: deneme geçmişi, liderlik tablosu, zamanlayıcı gibi kimsenin istemediği özellikler eklenir.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'developing-with-claude-code'
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
        ($$Kapsam kendiliğinden büyür; kimsenin istemediği özellikler eklenir$$, TRUE, 0),
        ($$Claude Code görevi yeterince açık olmadığı için reddeder$$, FALSE, 1),
        ($$Yalnızca veritabanı şeması yazılır, gerisi atlanır$$, FALSE, 2),
        ($$Plan, onay beklenmeden kendiliğinden uygulanır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'developing-with-claude-code'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (pair 4 TR, quiz position 4, SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'developing-with-claude-code')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Derste, yeni bir görevde neden auto mode yerine "manually approve edits" seçildi?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Derste, yeni bir görevde neden auto mode yerine "manually approve edits" seçildi?$$,
           NULL, NULL,
           $$Manuel onay, henüz tanıdık olmayan bir görevde daha güvenli varsayılandır: kalan her dosyayı bilinen mimari kararlara karşı tek tek doğrulama fırsatı verir. Görevi hızlandırmaz; planı okumak ise hangi mod seçilirse seçilsin onaydan önce yapılır.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'developing-with-claude-code'
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
        ($$Auto mode'da plan onaydan önce okunamadığı için$$, FALSE, 0),
        ($$Henüz tanıdık olmayan bir görevde daha güvenli varsayılan olduğu için$$, TRUE, 1),
        ($$Manuel onay görevi daha kısa sürede bitirdiği için$$, FALSE, 2),
        ($$Auto mode dosya oluşturmaya izin vermediği için$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'developing-with-claude-code'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (pair 5 TR, quiz position 5, SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'developing-with-claude-code')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir planı onaylamadan önce yapılabilecek ucuz ve etkili doğrulama adımı hangisidir?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir planı onaylamadan önce yapılabilecek ucuz ve etkili doğrulama adımı hangisidir?$$,
           NULL, NULL,
           $$Planın öne sürdüğü dosya adlarını ve numaralarını `ls`, `find`, `grep` gibi komutlarla gerçek proje durumuyla karşılaştırmak, planın geri kalanını okumaktan çok daha ucuz ve etkilidir. "(Recommended)" etiketi ise bir doğrulama değildir; körü körüne güvenilmemelidir.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'developing-with-claude-code'
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
        ($$"(Recommended)" etiketi taşıyan seçeneği işaretlemek$$, FALSE, 0),
        ($$Planı onaylayıp olası hataları test aşamasına bırakmak$$, FALSE, 1),
        ($$Planın öne sürdüğü dosya adlarını ve numaralarını gerçek proje durumuyla karşılaştırmak$$, TRUE, 2),
        ($$Claude Code'dan aynı planı bir kez daha üretmesini istemek$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'developing-with-claude-code'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (pair 6 TR, quiz position 6, SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'developing-with-claude-code')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Auto mode hangi tür görevlerde zaman kazandırır?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Auto mode hangi tür görevlerde zaman kazandırır?$$,
           NULL, NULL,
           $$Auto mode, defalarca çalıştırdığın ve sonucunu bildiğin düşük riskli görevlerde zaman kazandırır. Yeni bir dizinde ya da veritabanı şeması, silme işlemleri ve dış servislere istek gibi riskli işlerde ise "manually approve edits" ile başlamak daha güvenlidir.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'developing-with-claude-code'
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
        ($$Veritabanı şemasını değiştiren görevlerde$$, FALSE, 0),
        ($$Dosya silen ya da dış servislere istek atan görevlerde$$, FALSE, 1),
        ($$İlk kez çalışılan bir dizindeki görevlerde$$, FALSE, 2),
        ($$Defalarca çalıştırılmış, sonucu bilinen düşük riskli görevlerde$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'developing-with-claude-code'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (pair 7 TR, quiz position 7, MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'developing-with-claude-code')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri dersin uyardığı hatalardır? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri dersin uyardığı hatalardır? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Diff okumak ile uygulamayı gerçekten çalıştırıp test etmek farklı hata türlerini yakalar; biri diğerinin yerini tutmaz. Makul görünen bir plana ya da "(Recommended)" etiketine körü körüne güvenmek de derste uygulamayı açılışta çökertecek bir hatayı kaçırmak üzereydi. Riskli bir görevde manuel onayla başlamak ve ayrı bir "doğru mu" incelemesi yapmak ise önerilen pratiklerdir.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'developing-with-claude-code'
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
        ($$Bir dosya diff'ini onaylamayı, uygulamayı çalıştırıp test etmenin yerine koymak$$, TRUE, 0),
        ($$Makul görünen bir plana ya da "(Recommended)" etiketine körü körüne güvenmek$$, TRUE, 1),
        ($$Yeni ya da riskli bir görevde "manually approve edits" ile başlamak$$, FALSE, 2),
        ($$"Çalışıyor mu" testinden sonra ayrı bir "doğru mu" incelemesi yapmak$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'developing-with-claude-code'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
