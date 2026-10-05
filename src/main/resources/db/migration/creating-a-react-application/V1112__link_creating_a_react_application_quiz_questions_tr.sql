-- Links the TR creating-a-react-application questions to the topic's fixed quiz. Same NOT EXISTS /
-- ON CONFLICT DO NOTHING pattern as every prior quiz-link migration: each question is
-- found by its text (or created if missing) and linked at its position, so the file is
-- safe on a fresh database and on one where the promotion migration already ran.

-- Question 1/5 (pair 1 TR, quiz position 1, SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'creating-a-react-application')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$React geliştirirken Node.js neden gerekir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$React geliştirirken Node.js neden gerekir?$$,
           NULL, NULL,
           $$React projeleri geliştirme sırasında önce kendi bilgisayarında çalışır; bunun için JavaScript'i tarayıcı dışında çalıştırabilen bir programa, yani Node.js'e ihtiyaç vardır. Projeye hazır paketleri eklemek ise Node.js ile birlikte gelen npm'in işidir.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'creating-a-react-application'
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
        ($$Projeye başkalarının yazdığı hazır paketleri ekleyebilmek için$$, FALSE, 0),
        ($$Uygulamayı gerçek kullanıcılar için küçültebilmek için$$, FALSE, 1),
        ($$JavaScript'i tarayıcı dışında, kendi bilgisayarında çalıştırabilmek için$$, TRUE, 2),
        ($$Tarayıcının sayfayı elle yenilemeden güncelleyebilmesi için$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'creating-a-react-application'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/5 (pair 2 TR, quiz position 2, SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'creating-a-react-application')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bugün yeni bir React projesi başlatmak için doğru araç hangisidir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bugün yeni bir React projesi başlatmak için doğru araç hangisidir?$$,
           NULL, NULL,
           $$Yeni bir React projesi başlatmanın en kolay yolu Vite'tır; projeyi kurar ve geliştirme sırasında hızlı çalışır. Create React App eskiden standarttı ama artık bakımı yapılmıyor.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'creating-a-react-application'
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
        ($$Create React App (CRA)$$, FALSE, 0),
        ($$React Router$$, FALSE, 1),
        ($$Electron$$, FALSE, 2),
        ($$Vite$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'creating-a-react-application'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/5 (pair 3 TR, quiz position 3, SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'creating-a-react-application')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir Vite projesindeki `node_modules/` klasörü ne içerir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir Vite projesindeki `node_modules/` klasörü ne içerir?$$,
           NULL, NULL,
           $$`node_modules/` indirilen tüm paketlerin bulunduğu klasördür ve ona elle dokunulmaz. Kendi component'lerin `src/` altında yazılır; favicon gibi olduğu gibi kopyalanan dosyalar ise `public/` klasöründedir.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'creating-a-react-application'
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
        ($$İndirilen tüm paketleri; bu klasöre elle dokunulmaz$$, TRUE, 0),
        ($$Kendi yazdığın component'leri$$, FALSE, 1),
        ($$Olduğu gibi kopyalanan favicon gibi dosyaları$$, FALSE, 2),
        ($$Projenin adını ve çalıştırabileceği komutları$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'creating-a-react-application'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/5 (pair 4 TR, quiz position 4, MULTIPLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'creating-a-react-application')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`package.json` hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$`package.json` hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$`dependencies` bölümü projenin ihtiyaç duyduğu paketleri, örneğin `react` ve `react-dom`'u listeler; `scripts` bölümü ise `dev` ve `build` gibi komutlar için kısayollar tanımlar. Paketlerin kendisi bu dosyada değil `node_modules/` klasöründedir; dosya uygulamanın açılacağı adresi de belirlemez.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'creating-a-react-application'
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
        ($$`dependencies`, `react` ve `react-dom` gibi gereken paketleri listeler$$, TRUE, 0),
        ($$`scripts`, `dev` ve `build` gibi komutlar için kısayollar tanımlar$$, TRUE, 1),
        ($$`scripts`, indirilen paketlerin kaynak kodunu içerir$$, FALSE, 2),
        ($$`dependencies`, uygulamanın tarayıcıda açılacağı adresi belirler$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'creating-a-react-application'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/5 (pair 5 TR, quiz position 5, SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'creating-a-react-application')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`npm run dev` ile çalışan sürüm neden gerçek kullanıcılar için uygun değildir?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$`npm run dev` ile çalışan sürüm neden gerçek kullanıcılar için uygun değildir?$$,
           NULL, NULL,
           $$Geliştirme sürümü, anında yeniden yükleme gibi geliştirmeyi kolaylaştıran özellikler içerir; bu yüzden daha büyük ve daha yavaştır. Gerçek kullanıcılar için `npm run build` ile küçültülmüş, hızlı yüklenen dosyalar üretilir.$$,
           'claude-code@anthropic.com', now(), now(), now()
    FROM topic
    WHERE slug = 'creating-a-react-application'
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
        ($$`src/` klasöründeki değişiklikleri tarayıcıya yansıtmadığı için$$, FALSE, 0),
        ($$`react` ve `react-dom` paketlerini içermediği için$$, FALSE, 1),
        ($$Geliştirmeyi kolaylaştıran özellikler içerdiği için daha büyük ve daha yavaştır$$, TRUE, 2),
        ($$Yalnızca `dist/` klasöründeki dosyaları gösterebildiği için$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'creating-a-react-application'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
