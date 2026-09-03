-- Promotion-style migration linking TR dynamic-queries-with-specifications quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dynamic-queries-with-specifications')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir Specification<T> tam olarak nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir Specification<T> tam olarak nedir?$$,
           NULL, NULL,
           $$Bir WHERE koşulunun nasıl oluşturulacağının bir tanımı -- bir repository'ye teslim edilene kadar hiçbir şey çalışmaz.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dynamic-queries-with-specifications'
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
    ($$Tüm JpaRepository interface'inin yerini alan bir şey$$, FALSE, 0),
    ($$Bir WHERE koşulunun nasıl oluşturulacağının bir tanımı -- bir repository'ye teslim edilene kadar hiçbir şey çalışmaz$$, TRUE, 1),
    ($$Oluşturulduğu anda sonuç döndüren, tamamlanmış, zaten çalıştırılmış bir sorgu$$, FALSE, 2),
    ($$Doğrudan şemaya karşı yazılmış bir native SQL string'i$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dynamic-queries-with-specifications'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dynamic-queries-with-specifications')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Specification ile JPA'nın Criteria API'si (Root, CriteriaBuilder, Predicate) arasındaki ilişki nedir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Specification ile JPA'nın Criteria API'si (Root, CriteriaBuilder, Predicate) arasındaki ilişki nedir?$$,
           NULL, NULL,
           $$Specification, Criteria API'nin etrafındaki ince, kullanışlı bir sarmalayıcıdır -- onun yerini almaz.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dynamic-queries-with-specifications'
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
    ($$Criteria API, Specification'ın üzerine kuruludur, tersi değil$$, FALSE, 0),
    ($$Specification, modern Spring Data JPA'da Criteria API'nin yerini tamamen almıştır$$, FALSE, 1),
    ($$Specification, Criteria API'nin etrafındaki ince, kullanışlı bir sarmalayıcıdır -- onun yerini almaz$$, TRUE, 2),
    ($$Specification, Criteria API ile hiç ilgisi olmayan tamamen ayrı bir mekanizmadır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dynamic-queries-with-specifications'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dynamic-queries-with-specifications')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir repository interface'inin bir Specification'ı kabul edebilmesi için ne yapması gerekir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir repository interface'inin bir Specification'ı kabul edebilmesi için ne yapması gerekir?$$,
           NULL, NULL,
           $$JpaRepository<T, ID> ile birlikte JpaSpecificationExecutor<T>'yi de extend etmelidir -- bu olmadan, interface'te findAll(Specification) hiç mevcut değildir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dynamic-queries-with-specifications'
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
    ($$Hiçbir şey -- her JpaRepository varsayılan olarak otomatik olarak bir Specification kabul eder$$, FALSE, 0),
    ($$Sınıf seviyesinde @EnableSpecifications ile işaretlenmelidir$$, FALSE, 1),
    ($$Elle özel bir findAll(Specification) metodu implemente etmelidir$$, FALSE, 2),
    ($$JpaRepository<T, ID> ile birlikte JpaSpecificationExecutor<T>'yi de extend etmelidir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dynamic-queries-with-specifications'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dynamic-queries-with-specifications')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu Specification zinciri ne üretir?$$
      AND code_snippet = $$Specification<Konu> spec = Specification
        .where(kategoriyeSahip("spring-mvc"))
        .and(zorluguSahip("ILERI"));

repository.findAll(spec);$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu Specification zinciri ne üretir?$$,
           $$Specification<Konu> spec = Specification
        .where(kategoriyeSahip("spring-mvc"))
        .and(zorluguSahip("ILERI"));

repository.findAll(spec);$$, $$java$$,
           $$Aynı anda hem kategori = 'spring-mvc' HEM DE zorluk = 'ILERI' gerektiren, tek bir gerçek SQL sorgusu olarak çalıştırılan birleşik bir WHERE koşulu.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dynamic-queries-with-specifications'
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
    ($$Aynı anda hem kategori = 'spring-mvc' HEM DE zorluk = 'ILERI' gerektiren tek bir WHERE koşulu$$, TRUE, 0),
    ($$Her koşul için bir tane olmak üzere iki ayrı sorgu, sonuçlar daha sonra Java'da birleştirilir$$, FALSE, 1),
    ($$Burada .and(...) OR gibi davrandığı için, İKİ koşuldan birine uyan bir WHERE koşulu$$, FALSE, 2),
    ($$.or(...) zincire de eklenmeden hiçbir şey çalışmaz$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dynamic-queries-with-specifications'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dynamic-queries-with-specifications')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Ne kategori ne de zorluk sağlanmadan bir istek geliyor. Bu kod hangi sorguyu çalıştırır?$$
      AND code_snippet = $$Specification<Konu> spec = Specification.where(null);
if (kategori != null) spec = spec.and(kategoriyeSahip(kategori));
if (zorluk != null)   spec = spec.and(zorluguSahip(zorluk));

Page<Konu> sayfa = repository.findAll(spec, pageable);$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Ne kategori ne de zorluk sağlanmadan bir istek geliyor. Bu kod hangi sorguyu çalıştırır?$$,
           $$Specification<Konu> spec = Specification.where(null);
if (kategori != null) spec = spec.and(kategoriyeSahip(kategori));
if (zorluk != null)   spec = spec.and(zorluguSahip(zorluk));

Page<Konu> sayfa = repository.findAll(spec, pageable);$$, $$java$$,
           $$Hem kategori hem zorluk null olduğu için, hiç .and(...) eklenmez -- sorgu hiçbir şey filtrelemez, her satırı döndürür (sayfalanmış).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dynamic-queries-with-specifications'
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
    ($$kategori = null VE zorluk = null'ı literal SQL koşulları olarak filtreleyen bir sorgu$$, FALSE, 0),
    ($$Hiçbir şey filtrelemeyen, her satırı döndüren bir sorgu (sayfalanmış)$$, TRUE, 1),
    ($$Specification.where(null) geçersiz olduğu için bir NullPointerException fırlatan bir sorgu$$, FALSE, 2),
    ($$Hiçbir şeyle eşleşmeyen, boş bir sayfa döndüren bir sorgu$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dynamic-queries-with-specifications'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dynamic-queries-with-specifications')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$repository.findAll(spec, pageable) hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$repository.findAll(spec, pageable) hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Filtrelenmiş, sayfalanmış bir sorgu artı ayrı bir filtrelenmiş sayım sorgusu üretir -- Page<T> ile aynı iki-sorgu şekli, şimdi dinamik bir WHERE koşuluyla.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dynamic-queries-with-specifications'
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
    ($$Dinamik filtreleme ve gerçek sayfalama, iki ayrı adım yerine tek bir repository çağrısında birleşir$$, TRUE, 0),
    ($$Bir Pageable de sağlandığında Specification'ı tamamen yok sayar$$, FALSE, 1),
    ($$Her olası filtre kombinasyonu için tamamen ayrı bir repository metodu gerektirir$$, FALSE, 2),
    ($$Filtrelenmiş, sayfalanmış bir sorgu artı ayrı bir filtrelenmiş sayım sorgusu üretir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dynamic-queries-with-specifications'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'dynamic-queries-with-specifications')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir Specification'a mı yoksa türetilmiş bir sorgu metoduna/@Query'ye mi başvurulacağını aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bir Specification'a mı yoksa türetilmiş bir sorgu metoduna/@Query'ye mi başvurulacağını aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Türetilmiş metotlar ve @Query derleme zamanında sabittir; Specification, aktif koşullar kümesi bir istek gelene kadar gerçekten bilinmediğinde yerini kazanır. Küçük, sabit bir opsiyonel koşul kümesi bazen tek bir JPQL :param IS NULL OR ... sorgusuyla ifade edilebilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'dynamic-queries-with-specifications'
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
    ($$Türetilmiş bir sorgu metodunun koşulları derleme zamanında sabittir -- "yalnızca sağlanmışsa kategoriye göre filtrele"yi ifade edemez$$, TRUE, 0),
    ($$Specification, aktif filtre koşulları KÜMESİ bir istek gelene kadar gerçekten bilinmediğinde yerini kazanır$$, TRUE, 1),
    ($$Dinamik filtreleme her zaman bir Specification gerektirir -- opsiyonel bir koşulu ifade etmenin başka bir yolu yoktur$$, FALSE, 2),
    ($$Filtrelemenin dinamik olup olmadığından bağımsız olarak, bir Specification her repository sorgusu için varsayılan seçim olmalıdır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'dynamic-queries-with-specifications'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
