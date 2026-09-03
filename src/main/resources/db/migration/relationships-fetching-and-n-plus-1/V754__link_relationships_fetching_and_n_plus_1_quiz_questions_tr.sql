-- Promotion-style migration linking TR relationships-fetching-and-n-plus-1 quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$@OneToMany(mappedBy = "category"), veritabanına kendi foreign-key kolonunu ekler mi?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$@OneToMany(mappedBy = "category"), veritabanına kendi foreign-key kolonunu ekler mi?$$,
           NULL, NULL,
           $$Hayır -- var olan bir @ManyToOne'un ayna görüntüsüdür; foreign key hâlâ yalnızca sahip (@ManyToOne) tarafının tablosunda yaşar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'relationships-fetching-and-n-plus-1'
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
    ($$cascade'in de belirtilip belirtilmediğine bağlıdır$$, FALSE, 0),
    ($$Hayır -- var olan bir @ManyToOne'un ayna görüntüsüdür, kendi kolonunu eklemez$$, TRUE, 1),
    ($$Evet -- "bir" tarafının kendi tablosuna bir foreign-key kolonu ekler$$, FALSE, 2),
    ($$Evet -- otomatik olarak tamamen ayrı bir join table oluşturur$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'relationships-fetching-and-n-plus-1'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Açık bir join entity'si (bu projenin gerçek QuizQuestion'ı gibi), @JoinTable ile sade bir @ManyToMany'ye ne zaman tercih edilmelidir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Açık bir join entity'si (bu projenin gerçek QuizQuestion'ı gibi), @JoinTable ile sade bir @ManyToMany'ye ne zaman tercih edilmelidir?$$,
           NULL, NULL,
           $$Sade bir @ManyToMany join table'ında ilişkinin KENDİSİ hakkında veriye yer yoktur -- ilişkinin yalnızca bağlantıdan fazlasını taşıması gerektiği anda açık bir join entity'si gerekir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'relationships-fetching-and-n-plus-1'
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
    ($$Yalnızca iki ilişkili entity tam olarak aynı sayıda alana sahip olduğunda$$, FALSE, 0),
    ($$Yalnızca performans profillemesi @ManyToMany'nin ölçülebilir şekilde daha yavaş olduğunu gösterdiğinde$$, FALSE, 1),
    ($$İlişkinin kendisinin, bir position kolonu gibi, kendi verisini taşıması gerektiği anda$$, TRUE, 2),
    ($$Asla -- @JoinTable ile @ManyToMany her senaryoda her zaman üstün seçimdir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'relationships-fetching-and-n-plus-1'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: MULTIPLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri cascade ile orphanRemoval'ı doğru şekilde ayırt eder? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri cascade ile orphanRemoval'ı doğru şekilde ayırt eder? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$cascade, parent üzerinde gerçekleştirilen açık bir save/delete işlemini çocuklarına yayar; orphanRemoval, bir çocuğu, çocuk üzerinde hiçbir açık delete olmadan, yalnızca parent'ın koleksiyonundan çıkarıldığı için siler.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'relationships-fetching-and-n-plus-1'
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
    ($$cascade, parent üzerinde gerçekleştirilen açık bir save/delete işlemini çocuklarına yayar$$, TRUE, 0),
    ($$cascade ve orphanRemoval, tamamen aynı mekanizmanın yalnızca iki farklı adıdır$$, FALSE, 1),
    ($$orphanRemoval, herhangi bir etkisi olmadan önce CascadeType.REMOVE'un da ayarlanmasını gerektirir$$, FALSE, 2),
    ($$orphanRemoval, bir çocuğu, çocuk üzerinde hiçbir açık delete olmadan, yalnızca parent'ın koleksiyonundan çıkarıldığı için siler$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'relationships-fetching-and-n-plus-1'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$7 satırlık Kategori tablosuna karşı bu kod toplam kaç sorgu çalıştırır?$$
      AND code_snippet = $$for (Kategori k : kategoriRepository.findAll()) {
    System.out.println(k.getAd() + ": " + k.getKonular().size());
    // getKonular() lazy bir @OneToMany
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$7 satırlık Kategori tablosuna karşı bu kod toplam kaç sorgu çalıştırır?$$,
           $$for (Kategori k : kategoriRepository.findAll()) {
    System.out.println(k.getAd() + ": " + k.getKonular().size());
    // getKonular() lazy bir @OneToMany
}$$, $$java$$,
           $$Kategorileri getirmek için 1 sorgu, artı döngü içinde lazy getKonular() erişildiğinde kategori başına 1 sorgu daha -- toplam 1+7=8.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'relationships-fetching-and-n-plus-1'
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
    ($$8 -- kategoriler için 1 sorgu, artı döngüde getKonular() erişildiğinde kategori başına 1 sorgu daha$$, TRUE, 0),
    ($$1 -- tek bir sorgu, her kategorinin konuları dahil ihtiyaç duyulan her şeyi getirir$$, FALSE, 1),
    ($$7 -- kategorilerin kendisi için ayrı bir sorgu olmadan, kategori başına bir sorgu$$, FALSE, 2),
    ($$14 -- kategori başına 2 sorgu, biri ad için biri konular için$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'relationships-fetching-and-n-plus-1'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$findAll()'a @EntityGraph(attributePaths = "konular") eklemek, öncekiyle aynı 7 kategorilik döngü için sorgu sayısını nasıl değiştirir?$$
      AND code_snippet = $$@EntityGraph(attributePaths = "konular")
List<Kategori> findAll();$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$findAll()'a @EntityGraph(attributePaths = "konular") eklemek, öncekiyle aynı 7 kategorilik döngü için sorgu sayısını nasıl değiştirir?$$,
           $$@EntityGraph(attributePaths = "konular")
List<Kategori> findAll();$$, $$java$$,
           $$findAll() artık, konular zaten join edilmiş halde, TEK bir sorgu çalıştırır -- düzeltilmemiş N+1 örneğinin 1+7=8 sorgusundan aşağı.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'relationships-fetching-and-n-plus-1'
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
    ($$Herhangi bir etkisi olmadan önce findAll()'un bir native query'e geçirilmesini gerektirir$$, FALSE, 0),
    ($$Konular zaten join edilmiş halde, 1+7=8 yerine tam olarak TEK bir sorgu çalıştırır$$, TRUE, 1),
    ($$Sorgu sayısı üzerinde hiçbir etkisi yoktur -- @EntityGraph yalnızca hangi alanların seçildiğini değiştirir, kaç sorgu çalıştığını değil$$, FALSE, 2),
    ($$Kategori başına bir toplu sorgu olmak üzere 7 sorgu çalıştırır, @EntityGraph tarafından gruplanmış$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'relationships-fetching-and-n-plus-1'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$7 kategori ve lazy konular koleksiyonunda @BatchSize(size = 20) ile, önceki döngü toplam kaç sorgu çalıştırır?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$7 kategori ve lazy konular koleksiyonunda @BatchSize(size = 20) ile, önceki döngü toplam kaç sorgu çalıştırır?$$,
           NULL, NULL,
           $$1+1=2: kategoriler için bir sorgu, tüm 7 kategorinin konularını birlikte kapsayan bir toplu sorgu (tek bir WHERE category_id IN (...) ile), çünkü 7, 20'lik batch boyutuna sığar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'relationships-fetching-and-n-plus-1'
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
    ($$1+20=21 -- gerçek kategori sayısından bağımsız olarak, yapılandırılmış her batch boyutu yuvası için bir sorgu$$, FALSE, 0),
    ($$1 -- @BatchSize, @EntityGraph ile aynı şekilde her ekstra sorguyu tamamen ortadan kaldırır$$, FALSE, 1),
    ($$1+1=2 -- kategoriler için bir sorgu, tüm 7 kategorinin konularını birlikte kapsayan bir toplu sorgu$$, TRUE, 2),
    ($$1+7=8 -- @BatchSize'ın sorgu sayısı üzerinde gerçek bir etkisi yoktur$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'relationships-fetching-and-n-plus-1'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'relationships-fetching-and-n-plus-1')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri bir N+1 düzeltmesini en uygun olduğu duruma doğru şekilde eşleştirir? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri bir N+1 düzeltmesini en uygun olduğu duruma doğru şekilde eşleştirir? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$@EntityGraph, ilişkiye her zaman ihtiyaç duyan tek, spesifik bir sorguya uyar. Batch fetching, birçok farklı sorgunun dokunduğu bir ilişkiye uyar. Bir projeksiyon, ilişkinin verisine hiç ihtiyaç duyulmayan bir sorguya uyan, en ucuz düzeltmedir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'relationships-fetching-and-n-plus-1'
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
    ($$@EntityGraph, ilişkiye her zaman ihtiyaç duyan tek, spesifik bir sorguya uyar$$, TRUE, 0),
    ($$Bir projeksiyon, ilişkinin verisine hiç ihtiyaç duyulmayan bir sorguya uyan, en ucuz düzeltmedir$$, TRUE, 1),
    ($$Batch fetching, ilişkiye yalnızca tek bir sorgunun dokunduğu durumlarda doğru seçimdir$$, FALSE, 2),
    ($$cascade, @EntityGraph, batch fetching ve projeksiyonların yanında N+1 için dört düzeltmeden biridir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'relationships-fetching-and-n-plus-1'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
