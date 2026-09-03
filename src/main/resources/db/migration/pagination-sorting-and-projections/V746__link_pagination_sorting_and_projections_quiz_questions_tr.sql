-- Promotion-style migration linking TR pagination-sorting-and-projections quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'pagination-sorting-and-projections')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir repository metodunun dönüş tipi List<Topic>'ten Page<Topic>'e değiştiriliyor. Altta gerçekte ne olur?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir repository metodunun dönüş tipi List<Topic>'ten Page<Topic>'e değiştiriliyor. Altta gerçekte ne olur?$$,
           NULL, NULL,
           $$Spring Data JPA, gerçek bir LIMIT/OFFSET'e sahip bir sorgu artı toplam eşleşen satır sayısını sayan ayrı bir sorgu üretir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'pagination-sorting-and-projections'
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
    ($$Metot artık derlenmeden önce elle eklenmesi gereken bir Pageable parametresi gerektirir$$, FALSE, 0),
    ($$Spring Data JPA, gerçek bir LIMIT/OFFSET'e sahip bir sorgu artı toplam eşleşen satır sayısını sayan ayrı bir sorgu üretir$$, TRUE, 1),
    ($$Altta hiçbir şey değişmez -- Page yalnızca tam olarak aynı tek sorgu etrafında bir sarmalayıcı sınıftır$$, FALSE, 2),
    ($$Spring Data JPA her satırı getirir ve sonra istenen sayfa dışındakileri Java'da atar$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'pagination-sorting-and-projections'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'pagination-sorting-and-projections')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir repository'nin findAll(Sort sort) metodu gerçekte nereden gelir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir repository'nin findAll(Sort sort) metodu gerçekte nereden gelir?$$,
           NULL, NULL,
           $$Doğrudan PagingAndSortingRepository'den miras alınır -- interface'te hiç deklare edilmesine gerek yoktur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'pagination-sorting-and-projections'
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
    ($$Her repository için, entity'sinin alanlarına göre sıfırdan, yeniden üretilir$$, FALSE, 0),
    ($$Temel repository hiyerarşisinden değil, JpaSpecificationExecutor'dan gelir$$, FALSE, 1),
    ($$Doğrudan PagingAndSortingRepository'den miras alınır, interface'te deklarasyon gerektirmez$$, TRUE, 2),
    ($$Sıralamaya ihtiyaç duyan her repository interface'inde açıkça deklare edilmelidir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'pagination-sorting-and-projections'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'pagination-sorting-and-projections')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu Pageable oluşturmasına göre, kendisine geçirildiği repository metodunun ayrıca bir Sort parametresine de ihtiyacı var mı?$$
      AND code_snippet = $$Pageable pageable = PageRequest.of(1, 5, Sort.by("slug"));
Page<Topic> result = repository.findByDifficulty("ADVANCED", pageable);$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu Pageable oluşturmasına göre, kendisine geçirildiği repository metodunun ayrıca bir Sort parametresine de ihtiyacı var mı?$$,
           $$Pageable pageable = PageRequest.of(1, 5, Sort.by("slug"));
Page<Topic> result = repository.findByDifficulty("ADVANCED", pageable);$$, $$java$$,
           $$Hayır -- bir Pageable zaten kendi gömülü Sort'unu taşır; PageRequest.of(page, size, sort) sıralamayı zaten içine paketler.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'pagination-sorting-and-projections'
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
    ($$Evet -- Pageable ve Sort her zaman ikisi de sağlanması gereken iki ayrı argümandır$$, FALSE, 0),
    ($$Metodun türetilmiş bir sorgu mu yoksa @Query ile mi yazıldığına bağlıdır$$, FALSE, 1),
    ($$Evet, ama yalnızca entity'nin birden fazla sıralanabilir alanı varsa$$, FALSE, 2),
    ($$Hayır -- bir Pageable zaten kendi gömülü Sort'unu taşır, bu yüzden ayrı bir Sort parametresine gerek yoktur$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'pagination-sorting-and-projections'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'pagination-sorting-and-projections')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$TopicSummary gibi (getSlug()/getDifficulty() ile) bir interface projeksiyonu deklare etmek, üretilen SQL hakkında gerçekte neyi değiştirir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$TopicSummary gibi (getSlug()/getDifficulty() ile) bir interface projeksiyonu deklare etmek, üretilen SQL hakkında gerçekte neyi değiştirir?$$,
           NULL, NULL,
           $$Spring Data JPA, yalnızca o özel kolonları adlandıran bir SQL SELECT üretir, tam entity'nin gerektireceği her kolonu değil.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'pagination-sorting-and-projections'
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
    ($$Yalnızca interface'in getter'larının karşılık geldiği kolonları adlandıran bir SQL SELECT üretir$$, TRUE, 0),
    ($$SQL seviyesinde hiçbir şeyi değiştirmez -- yalnızca ne kadar Java kodu yazılması gerektiğini azaltır$$, FALSE, 1),
    ($$Sorgunun JPQL yerine bir native query olarak çalışmasını zorlar$$, FALSE, 2),
    ($$Altta yatan entity'nin her alanı için lazy loading'i tamamen devre dışı bırakır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'pagination-sorting-and-projections'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'pagination-sorting-and-projections')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu projeksiyon neden sade bir interface projeksiyonu yerine bir constructor-expression'a (select new ...) ihtiyaç duyar?$$
      AND code_snippet = $$record KonuBaslikView(String slug, String baslik) {}

@Query("select new com.example.KonuBaslikView(kc.konu.slug, kc.baslik) " +
       "from KonuCevirisi kc where kc.dil = :dil")
List<KonuBaslikView> tumBasliklariGetir(String dil);$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu projeksiyon neden sade bir interface projeksiyonu yerine bir constructor-expression'a (select new ...) ihtiyaç duyar?$$,
           $$record KonuBaslikView(String slug, String baslik) {}

@Query("select new com.example.KonuBaslikView(kc.konu.slug, kc.baslik) " +
       "from KonuCevirisi kc where kc.dil = :dil")
List<KonuBaslikView> tumBasliklariGetir(String dil);$$, $$java$$,
           $$Alanlar bir ilişkiye yayılıyor -- slug Konu'dan, baslik KonuCevirisi'nden geliyor -- bunu sade bir interface projeksiyonu ifade edemez.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'pagination-sorting-and-projections'
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
    ($$Çünkü sorgu birden fazla satır döndürür$$, FALSE, 0),
    ($$Çünkü alanlar bir ilişkiye yayılıyor -- slug Konu'dan, baslik KonuCevirisi'nden geliyor -- bunu sade bir interface projeksiyonu ifade edemez$$, TRUE, 1),
    ($$Çünkü interface projeksiyonları modern Spring Data JPA'da tamamen kullanımdan kaldırılmıştır$$, FALSE, 2),
    ($$Çünkü record'lar hiçbir tür projeksiyon olarak asla kullanılamaz$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'pagination-sorting-and-projections'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'pagination-sorting-and-projections')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri bir projeksiyonun gerçek faydasını doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri bir projeksiyonun gerçek faydasını doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Bir projeksiyon, üretilen SQL SELECT'in kendisini daraltır, veritabanından daha az kolon getirir -- yalnızca daha küçük bir Java tipi üretmekten ibaret değildir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'pagination-sorting-and-projections'
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
    ($$Yalnızca okunacak veri için tam bir entity'yi yönetmenin ek yükünden kaçınır$$, TRUE, 0),
    ($$Tek gerçek faydası daha az Java kodu yazmaktır, üretilen SQL üzerinde hiçbir etkisi yoktur$$, FALSE, 1),
    ($$Sorguyu her zaman nativeQuery = true'ya geçirmeyi gerektirir$$, FALSE, 2),
    ($$Veritabanından daha az kolon getirerek SQL SELECT'in kendisini daraltır$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'pagination-sorting-and-projections'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'pagination-sorting-and-projections')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$PageRequest.of(page, size, sort) ile oluşturulan bir Pageable ile tek bir findByDifficulty(String difficulty, Pageable pageable) metodu çağrılıyor. Bu TEK metot çağrısı aynı anda kaç ayrı kaygıyı ele alıyor?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$PageRequest.of(page, size, sort) ile oluşturulan bir Pageable ile tek bir findByDifficulty(String difficulty, Pageable pageable) metodu çağrılıyor. Bu TEK metot çağrısı aynı anda kaç ayrı kaygıyı ele alıyor?$$,
           NULL, NULL,
           $$Üç: filtreleme (difficulty), sayfalama ve sıralama -- hepsi tek, sıradan bir metot imzasında paketlenmiş.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'pagination-sorting-and-projections'
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
    ($$Bir -- yalnızca filtreleme, çünkü Pageable sıralamayla ilgisizdir$$, FALSE, 0),
    ($$İki -- yalnızca filtreleme ve sayfalama, sıralama ayrı bir çağrı gerektirir$$, FALSE, 1),
    ($$Dört -- filtreleme, sayfalama, sıralama ve projeksiyon, hepsi tek çağrıda$$, FALSE, 2),
    ($$Üç -- filtreleme, sayfalama ve sıralama, hepsi bu tek metot çağrısı tarafından ele alınır$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'pagination-sorting-and-projections'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
