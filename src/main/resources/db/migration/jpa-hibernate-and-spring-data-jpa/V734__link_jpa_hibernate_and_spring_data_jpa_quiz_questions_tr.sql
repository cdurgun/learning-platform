-- Promotion-style migration linking TR jpa-hibernate-and-spring-data-jpa quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$JPA (Jakarta Persistence API) tam olarak nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$JPA (Jakarta Persistence API) tam olarak nedir?$$,
           NULL, NULL,
           $$JPA bir spesifikasyondur -- kendi başına hiçbir çalışma zamanı davranışı olmayan, bir dizi interface ve annotation'dır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'jpa-hibernate-and-spring-data-jpa'
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
    ($$Repository implementasyonları üreten Spring'e özgü bir araç$$, FALSE, 0),
    ($$Kendi başına hiçbir çalışma zamanı davranışı olmayan, bir dizi interface ve annotation'dan oluşan bir spesifikasyon$$, TRUE, 1),
    ($$Hibernate gibi doğrudan kurup çalıştırabileceğin bir kütüphane$$, FALSE, 2),
    ($$Hibernate'in kendisinin başka bir adı$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jpa-hibernate-and-spring-data-jpa'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Hibernate'in JPA ile ilişkisi nedir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Hibernate'in JPA ile ilişkisi nedir?$$,
           NULL, NULL,
           $$Hibernate, JPA spesifikasyonunun somut bir implementasyonudur -- SQL'i altta gerçekte üreten odur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'jpa-hibernate-and-spring-data-jpa'
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
    ($$Hibernate, JPA'nın yerini alan daha yeni bir spesifikasyondur$$, FALSE, 0),
    ($$JPA, Hibernate'in üzerine kuruludur, tersi değil$$, FALSE, 1),
    ($$Hibernate, JPA spesifikasyonunun somut bir implementasyonudur$$, TRUE, 2),
    ($$Hibernate ve JPA, aynı şeyin birbirinin yerine kullanılabilen iki adıdır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jpa-hibernate-and-spring-data-jpa'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir Spring Data JPA repository metodu çalıştığında, altta gerçekte ne olur?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir Spring Data JPA repository metodu çalıştığında, altta gerçekte ne olur?$$,
           NULL, NULL,
           $$Yine de JPA'nın EntityManager'ından geçer ve altta Hibernate tarafından SQL'e dönüştürülür -- Spring Data JPA yalnızca tekrarlayan boilerplate'i kaldırır, hiçbir katmanı atlamaz.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'jpa-hibernate-and-spring-data-jpa'
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
    ($$Spring Data JPA, JPA ve Hibernate'i tamamen atlayarak veritabanıyla doğrudan konuşur$$, FALSE, 0),
    ($$Spring Data JPA, Hibernate'in yerine kendi ayrı SQL üretme motorunu koyar$$, FALSE, 1),
    ($$Metodun türetilmiş bir sorgu mu yoksa özel bir @Query mi olduğuna bağlıdır$$, FALSE, 2),
    ($$Yine de JPA'nın EntityManager'ından geçer ve altta Hibernate tarafından SQL'e dönüştürülür$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jpa-hibernate-and-spring-data-jpa'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir repository çağrısının bu projenin dört katmanından nasıl geçtiğini hangi sıra doğru yansıtır?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir repository çağrısının bu projenin dört katmanından nasıl geçtiğini hangi sıra doğru yansıtır?$$,
           NULL, NULL,
           $$Repository (interface) -> Spring Data JPA (implementasyon üretir) -> JPA (spesifikasyon: EntityManager) -> Hibernate (implementasyon: SQL üretir).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'jpa-hibernate-and-spring-data-jpa'
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
    ($$Repository -> Spring Data JPA -> JPA -> Hibernate$$, TRUE, 0),
    ($$Hibernate -> JPA -> Spring Data JPA -> Repository$$, FALSE, 1),
    ($$Repository -> Hibernate -> JPA -> Spring Data JPA$$, FALSE, 2),
    ($$JPA -> Repository -> Hibernate -> Spring Data JPA$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jpa-hibernate-and-spring-data-jpa'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir Java record'u neden bir JPA entity'si olarak kullanılamaz?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir Java record'u neden bir JPA entity'si olarak kullanılamaz?$$,
           NULL, NULL,
           $$Hibernate, entity instance'larını alanları doldurmadan önce reflection ile oluşturur, bu da parametresiz bir constructor ve mutable alanlar gerektirir -- bir record'da ikisi de yoktur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'jpa-hibernate-and-spring-data-jpa'
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
    ($$Çünkü record'lar id adında bir alana sahip olamaz$$, FALSE, 0),
    ($$Çünkü Hibernate'in reflection ile doldurabileceği ne parametresiz bir constructor'ı ne de mutable alanları vardır$$, TRUE, 1),
    ($$Çünkü record'lar henüz hiçbir JPA sağlayıcısı tarafından desteklenmeyen bir preview özelliğidir$$, FALSE, 2),
    ($$Çünkü JPA yalnızca @Service ile işaretlenmiş sınıflarla çalışır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jpa-hibernate-and-spring-data-jpa'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri Spring Boot'un bu dört katmanlı resimdeki rolünü doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri Spring Boot'un bu dört katmanlı resimdeki rolünü doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Spring Boot yeni bir katman eklemez -- bir DataSource, EntityManagerFactory, JPA sağlayıcısı olarak Hibernate ve repository altyapısını, hiçbir elle yapılandırma olmadan otomatik olarak kurar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'jpa-hibernate-and-spring-data-jpa'
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
    ($$Hibernate'in yerine kendi, Spring'e özgü ORM implementasyonunu koyar$$, FALSE, 0),
    ($$Herhangi bir repository çalışmadan önce EntityManagerFactory'nin elle yapılandırılmasını gerektirir$$, FALSE, 1),
    ($$Kendi yeni bir katman eklemeden, mevcut JPA/Hibernate/Spring Data JPA katmanlarını otomatik olarak birbirine bağlar$$, TRUE, 2),
    ($$Bir DataSource, EntityManagerFactory ve JPA sağlayıcısı olarak Hibernate'i otomatik olarak yapılandırır$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jpa-hibernate-and-spring-data-jpa'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jpa-hibernate-and-spring-data-jpa')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri bir sorumluluğu doğru katmana atar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri bir sorumluluğu doğru katmana atar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$JPA, mapping'in NASIL görünmesi gerektiğini tanımlar; Hibernate bunu gerçekten SQL olarak çalıştırır; Spring Data JPA, her entity için elle bir EntityManager tabanlı sınıf yazmanın boilerplate'ini kaldırır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'jpa-hibernate-and-spring-data-jpa'
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
    ($$JPA, annotation'lar ve interface'ler aracılığıyla object-relational mapping'in NASIL görünmesi gerektiğini tanımlar$$, TRUE, 0),
    ($$Spring Data JPA, PostgreSQL'e gönderilen SQL'i gerçekte üreten şeydir$$, FALSE, 1),
    ($$Hibernate, interface implementasyonları üreten bir repository soyutlamasıdır$$, FALSE, 2),
    ($$Hibernate, @Entity ile işaretlenmiş sınıfları ve JPA çağrılarını gerçekten SQL'e dönüştüren şeydir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jpa-hibernate-and-spring-data-jpa'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
