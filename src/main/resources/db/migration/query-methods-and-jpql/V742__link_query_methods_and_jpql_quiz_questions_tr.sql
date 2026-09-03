-- Promotion-style migration linking TR query-methods-and-jpql quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'query-methods-and-jpql')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Spring Data JPA, findBySlug(String slug) gibi türetilmiş bir sorgu metodunun hangi SQL'i çalıştıracağını nasıl belirler?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Spring Data JPA, findBySlug(String slug) gibi türetilmiş bir sorgu metodunun hangi SQL'i çalıştıracağını nasıl belirler?$$,
           NULL, NULL,
           $$Uygulama başlangıcında metodun adını ayrıştırır ve parçaları entity'nin kendi özellikleriyle eşleştirerek ondan bir sorgu oluşturur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'query-methods-and-jpql'
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
    ($$Classpath'e yerleştirilmiş, aynı adı taşıyan eşleşen bir SQL dosyası gerektirir$$, FALSE, 0),
    ($$Uygulama başlangıcında metodun adını ayrıştırır ve ondan bir sorgu oluşturur$$, TRUE, 1),
    ($$Spring Data JPA'nın otomatik ürettiği gizli bir @Query annotation'ını okur$$, FALSE, 2),
    ($$Ne döndürdüğünü gözlemlemek için metodu başlangıçta bir kez çalıştırır, sonra bunu önbelleğe alır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'query-methods-and-jpql'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'query-methods-and-jpql')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu türetilmiş sorgu metodu kaç metot parametresi gerektirir?$$
      AND code_snippet = $$Optional<Quiz> findFirstByTopicIdAndLanguageAndActiveTrueOrderByIdAsc(
        Long topicId, String language);$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu türetilmiş sorgu metodu kaç metot parametresi gerektirir?$$,
           $$Optional<Quiz> findFirstByTopicIdAndLanguageAndActiveTrueOrderByIdAsc(
        Long topicId, String language);$$, $$java$$,
           $$Üç koşul var (TopicId, Language, ActiveTrue) ama yalnızca iki parametre var -- ActiveTrue kendi literal boolean değerini sağlar ve TopicId ile Language'dan farklı olarak hiçbir parametre tüketmez.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'query-methods-and-jpql'
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
    ($$Bir -- yalnızca TopicId gerçekten bir WHERE koşuluna dönüşür$$, FALSE, 0),
    ($$Dört -- OrderByIdAsc de sıralama yönünü belirten bir parametre gerektirir$$, FALSE, 1),
    ($$İki -- ActiveTrue kendi literal değerini sağlar ve TopicId ile Language'ın aksine hiçbir parametre tüketmez$$, TRUE, 2),
    ($$Üç -- metot adındaki her koşul için bir tane$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'query-methods-and-jpql'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'query-methods-and-jpql')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Yalnızca varlık kontrolüne ihtiyaç duyulduğunda, existsByTopicIdAndLanguage(...) neden findByTopicIdAndLanguage(...).isPresent()'e tercih edilir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Yalnızca varlık kontrolüne ihtiyaç duyulduğunda, existsByTopicIdAndLanguage(...) neden findByTopicIdAndLanguage(...).isPresent()'e tercih edilir?$$,
           NULL, NULL,
           $$existsBy, bütün bir entity'yi yüklemeden, tek bir SELECT EXISTS(...) sorgusundan sade bir boolean döndürür.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'query-methods-and-jpql'
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
    ($$Gerçek bir fark yoktur -- ikisi de tam olarak aynı sorguyu çalıştırır$$, FALSE, 0),
    ($$Modern Spring Data JPA'da existsBy, findBy lehine kullanımdan kaldırılmıştır$$, FALSE, 1),
    ($$existsBy yalnızca primary-key alanlarında çalışır, diğer kolonlarda asla çalışmaz$$, FALSE, 2),
    ($$Bütün bir entity'yi yüklemeden, tek bir SELECT EXISTS(...) sorgusundan sade bir boolean döndürür$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'query-methods-and-jpql'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: MULTIPLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'query-methods-and-jpql')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri @Query ve varsayılan JPQL'i doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri @Query ve varsayılan JPQL'i doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$JPQL, tabloları ve kolonları değil, entity'leri ve alanlarını sorgular; proje parametre adlarını koruyorsa, bir metot parametresinin kendi adı, ayrı bir annotation olmadan bir :placeholder ile isimle eşleşebilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'query-methods-and-jpql'
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
    ($$Bir metot parametresinin kendi adı, ayrı bir annotation gerekmeden isim eşleşmesiyle bir :placeholder'a bağlanabilir$$, TRUE, 0),
    ($$JPQL, doğrudan tabloları ve kolonları değil, Quiz ve q.topic gibi entity'leri ve alanlarını sorgular$$, TRUE, 1),
    ($$@Query her zaman gerçek şemaya karşı gerçek SQL yazmak anlamına gelir$$, FALSE, 2),
    ($$JPQL, hiçbir dönüştürme adımı olmadan doğrudan veritabanına karşı çalıştırılır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'query-methods-and-jpql'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'query-methods-and-jpql')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$JPQL'deki join fetch, özellikle hangi sorunun önüne geçmeye yardımcı olur?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$JPQL'deki join fetch, özellikle hangi sorunun önüne geçmeye yardımcı olur?$$,
           NULL, NULL,
           $$İlişkili veriyi AYNI sorguda geri getirir, bir ilişkiye transaction dışında erişilirse oluşabilecek bir LazyInitializationException'ı önler.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'query-methods-and-jpql'
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
    ($$Yeni bir entity kaydedilirken oluşan bir duplicate-key kısıtlama ihlali$$, FALSE, 0),
    ($$Bir ilişkiye transaction dışında erişmekten kaynaklanan bir LazyInitializationException$$, TRUE, 1),
    ($$Eşlenmemiş bir entity alanından kaynaklanan bir derleme zamanı hatası$$, FALSE, 2),
    ($$İki eşzamanlı güncellemeden kaynaklanan bir OptimisticLockingFailureException$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'query-methods-and-jpql'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'query-methods-and-jpql')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu repository metodu çağrıldığında ne olur?$$
      AND code_snippet = $$@Query("update Soru s set s.durum = 'REDDEDILDI' where s.durum = 'INCELEME_BEKLIYOR'")
int tumBekleyenleriReddet();
// @Modifying tamamen eksik$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu repository metodu çağrıldığında ne olur?$$,
           $$@Query("update Soru s set s.durum = 'REDDEDILDI' where s.durum = 'INCELEME_BEKLIYOR'")
int tumBekleyenleriReddet();
// @Modifying tamamen eksik$$, $$java$$,
           $$@Modifying olmadan, Spring Data JPA bunu bir bulk update olarak ele alması gerektiğini bilmez -- sonucu entity'lere eşlemeye çalışır ve başarısız olur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'query-methods-and-jpql'
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
    ($$Sessizce hiçbir şey yapmaz, hiç hata vermeden 0 döndürür$$, FALSE, 0),
    ($$Spring Data JPA, sorgu metnindeki UPDATE anahtar kelimesinden @Modifying'i otomatik olarak çıkarır$$, FALSE, 1),
    ($$Spring Data JPA, bunun bir bulk update olduğunu bilmediği için sonucu entity'lere eşlemeye çalışır ve başarısız olur$$, TRUE, 2),
    ($$Başarıyla çalışır, tam olarak amaçlandığı gibi her eşleşen satırı günceller$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'query-methods-and-jpql'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'query-methods-and-jpql')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri native query'leri (nativeQuery = true) doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri native query'leri (nativeQuery = true) doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Bir native query, entity modeli yerine gerçek tablolara/kolonlara karşı yazılır ve kodu gerçek şemaya ve belirli veritabanının SQL dialect'ine bağlar -- yalnızca JPQL'in gerçekten bir şeyi ifade edemediği durumlarda tercih edilmelidir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'query-methods-and-jpql'
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
    ($$Entity modeli yerine, gerçek tabloya ve onun gerçek kolonlarına karşı sorgulanır$$, TRUE, 0),
    ($$Kodu gerçek şemaya ve belirli veritabanının kendi SQL dialect'ine bağlar$$, TRUE, 1),
    ($$Her zaman JPQL'den daha hızlı olduğu için her @Query için varsayılan seçim olmalıdır$$, FALSE, 2),
    ($$JPQL ile tamamen aynı şekilde farklı veritabanı sağlayıcıları arasında taşınabilirdir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'query-methods-and-jpql'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
