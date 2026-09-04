-- Promotion-style migration linking TR what-is-ai quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.


-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-ai')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Yapay zeka yazılımını, geleneksel, kuralları açıkça programlanmış yazılımdan temelde ayıran nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Yapay zeka yazılımını, geleneksel, kuralları açıkça programlanmış yazılımdan temelde ayıran nedir?$$,
           NULL, NULL,
           $$Yapay zeka sistemleri, yalnızca açıkça yazılmış kuralları izlemek yerine verilerden (training) örüntüler öğrenir; hız, donanım ve "kod gerekmez" iddiaları gerçek ayrımla ilgisizdir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-ai'
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
    ($$Yapay zeka yazılımı hiçbir kod yazılmasını gerektirmez$$, FALSE, 0),
    ($$Geleneksel yazılım yalnızca özel donanımlarda çalışabilir$$, FALSE, 1),
    ($$Yapay zeka sistemleri, yalnızca açıkça yazılmış kuralları izlemek yerine verilerden örüntüler öğrenir$$, TRUE, 2),
    ($$Yapay zeka sistemleri her durumda geleneksel yazılımdan daha hızlı çalışır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-ai'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-ai')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Günümüzde üretimde çalışan neredeyse tüm yapay zeka sistemleri (LLM'ler dahil) hangi kategoriye girer?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Günümüzde üretimde çalışan neredeyse tüm yapay zeka sistemleri (LLM'ler dahil) hangi kategoriye girer?$$,
           NULL, NULL,
           $$Dar (Narrow) yapay zeka belirli görevlerde iyi performans gösterir; AGI (herhangi bir alanda insan düzeyinde genel zeka) bugün dağıtılmış sistemlerde mevcut değildir; her konuşmada Turing Testi'ni geçmek ya da her alanda akıl yürütmek günümüz sistemlerinin ulaştığı bir şey değildir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-ai'
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
    ($$Genel Yapay Zeka (AGI)$$, FALSE, 0),
    ($$Her konuşmada Turing Testi'ni geçen sistemler$$, FALSE, 1),
    ($$Her alanda insan düzeyinde akıl yürütebilen sistemler$$, FALSE, 2),
    ($$Dar (Narrow) Yapay Zeka -- belirli bir görevi veya görev kümesini iyi yapmak için tasarlanmış sistemler$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-ai'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-ai')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir ekip 'ürünümüz yapay zeka kullanıyor' ve ayrıca 'ürünümüz machine learning kullanıyor' diyor. Bu terimlerin ilişkisine göre hangi ifade en doğrudur?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir ekip 'ürünümüz yapay zeka kullanıyor' ve ayrıca 'ürünümüz machine learning kullanıyor' diyor. Bu terimlerin ilişkisine göre hangi ifade en doğrudur?$$,
           NULL, NULL,
           $$Machine Learning, yapay zekanın daha geniş alanının içindeki bir yaklaşımdır (Yapay Zeka, ML'i içerir; ML, Deep Learning'i içerir; Deep Learning de Generative AI'ı içerir) -- iki terim ne ilgisizdir, ne tersine çevrilebilir, ne de birebir aynıdır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-ai'
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
    ($$Machine Learning, yapay zekanın bir alt kümesidir -- yapay zeka inşa etmenin yaygın bir yoludur, ayrı bir alan değildir$$, TRUE, 0),
    ($$Yapay zeka ve Machine Learning birbiriyle ilgisiz, rakip yaklaşımlardır$$, FALSE, 1),
    ($$Yapay zeka, Machine Learning'in bir alt kümesidir$$, FALSE, 2),
    ($$Bu iki terim her zaman birbirinin birebir aynısı anlamına gelir, hiçbir ayrım yoktur$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-ai'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-ai')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$'Yapay zeka kışı' (AI winter) tarihsel olarak neden yaşandı?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$'Yapay zeka kışı' (AI winter) tarihsel olarak neden yaşandı?$$,
           NULL, NULL,
           $$Yapay zeka kışları, şişirilmiş beklentiler gerçekleşmeyince araştırma finansmanı ve ilgisinin azaldığı dönemlerdi; diğer seçenekler uydurma ya da tam tersini anlatıyor -- 2012 sonrası dönem deep learning ile hızlanan bir ilerlemeydi, bir kış değil.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-ai'
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
    ($$2012 sonrası deep learning atılımlarının yapay zeka ilerlemesini hızlandırdığı dönem$$, FALSE, 0),
    ($$Şişirilmiş beklentiler gerçekleşmeyince yapay zeka araştırma finansmanı ve ilgisinin keskin biçimde azaldığı bir dönem$$, TRUE, 1),
    ($$Yapay zeka konferanslarının geleneksel olarak düzenlendiği bir mevsim$$, FALSE, 2),
    ($$Hükümetlerin tüm yapay zeka araştırmalarını yasakladığı bir dönem$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-ai'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-ai')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Sabit bir yasaklı kelime listesi yerine, milyonlarca önceden etiketlenmiş e-postadan öğrenilen örüntülere dayanarak bir e-postayı spam olarak işaretleyen bir filtre en iyi nasıl tanımlanır?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Sabit bir yasaklı kelime listesi yerine, milyonlarca önceden etiketlenmiş e-postadan öğrenilen örüntülere dayanarak bir e-postayı spam olarak işaretleyen bir filtre en iyi nasıl tanımlanır?$$,
           NULL, NULL,
           $$Etiketlenmiş veriden örüntü öğrenmek yapay zekadır; sınıflandırma, var olan bir girdi için etiket tahmin eden discriminative bir görevdir, generative değildir -- bu yüzden her e-posta için bir çıktı üretmesi onu 'generative AI' yapmaz, veriden öğrenmesi de onu 'yapay zeka değil' yapmaz.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-ai'
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
    ($$Yapay zeka değildir, çünkü herhangi bir yeni içerik üretmez$$, FALSE, 0),
    ($$Generative AI'dır, çünkü her e-posta için bir çıktı üretir$$, FALSE, 1),
    ($$Bir yapay zeka sistemi, çünkü spam örüntülerini yalnızca sabit kurallar izlemek yerine verilerden öğrenmiştir$$, TRUE, 2),
    ($$Öğrenme içermeyen, kurala dayalı bir sistem$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-ai'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-ai')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Yapay Zeka, ML'i; ML, Deep Learning'i; Deep Learning de Generative AI'ı içeren iç içe ilişki göz önüne alındığında, bir sinir ağıyla eğitilmiş ama yeni içerik üretmek için eğitilmemiş bir spam sınıflandırıcısını hangi ifade doğru şekilde konumlandırır?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Yapay Zeka, ML'i; ML, Deep Learning'i; Deep Learning de Generative AI'ı içeren iç içe ilişki göz önüne alındığında, bir sinir ağıyla eğitilmiş ama yeni içerik üretmek için eğitilmemiş bir spam sınıflandırıcısını hangi ifade doğru şekilde konumlandırır?$$,
           NULL, NULL,
           $$Sinir ağı tabanlı bir sınıflandırıcı Deep Learning katmanına aittir (ki bu da ML'in, o da yapay zekanın içindedir) ama yeni içerik üretmek yerine sınıflandırma yaptığı için Generative AI'a ait değildir; diğer seçenekler iç içe ilişkiyi yanlış yerleştiriyor.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-ai'
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
    ($$Generative AI'dır ama Deep Learning değildir$$, FALSE, 0),
    ($$Yapay zekadır ama ML değildir, çünkü sinir ağları bir machine learning tekniği değildir$$, FALSE, 1),
    ($$ML'dir ama yapay zeka değildir$$, FALSE, 2),
    ($$Deep Learning'dir (dolayısıyla ML ve yapay zekadır da), ama Generative AI değildir, çünkü yeni içerik üretmek yerine sınıflandırma yapar$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-ai'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-ai')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, yapay zeka hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, yapay zeka hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derse göre doğrudur (günümüzde dar yapay zeka baskınlığı, ve AI/ML/DL/GenAI iç içe ilişkisi); Turing Testi resmi bir matematiksel ispat değil, bir düşünce deneyi/resmi olmayan bir kıstastır; yapay zeka bir alan olarak LLM'lerden çok önce, 1956'daki Dartmouth çalıştayına kadar uzanır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-ai'
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
    ($$Günümüzde üretimdeki tüm yapay zeka dar (narrow) yapay zekadır; AGI şu an dağıtılmış sistemlerde mevcut değildir$$, TRUE, 0),
    ($$Machine Learning, Deep Learning ve Generative AI, yapay zekanın daha geniş alanı içine iç içe yerleşmiştir, ayrı ve ilgisiz alanlar değildir$$, TRUE, 1),
    ($$Turing Testi, bir sistemin zeki olduğunu kanıtlayan resmi, evrensel kabul görmüş matematiksel bir ispattır$$, FALSE, 2),
    ($$Yapay zeka bir alan olarak yalnızca 2020'lerden, LLM'lerle birlikte var olmaya başlamıştır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-ai'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
