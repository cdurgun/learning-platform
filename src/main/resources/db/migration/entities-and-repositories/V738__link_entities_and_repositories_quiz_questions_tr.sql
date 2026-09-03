-- Promotion-style migration linking TR entities-and-repositories quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'entities-and-repositories')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$@GeneratedValue(strategy = GenerationType.IDENTITY) gerçekte ne yapar?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$@GeneratedValue(strategy = GenerationType.IDENTITY) gerçekte ne yapar?$$,
           NULL, NULL,
           $$Id üretimini veritabanının kendi auto-increment mekanizmasına devreder.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'entities-and-repositories'
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
    ($$Id üretimini tamamen devre dışı bırakır, kolonu null bırakır$$, FALSE, 0),
    ($$Id üretimini veritabanının kendi auto-increment mekanizmasına devreder$$, TRUE, 1),
    ($$Id'yi kaydetmeden önce uygulama belleğinde rastgele üretir$$, FALSE, 2),
    ($$Her save öncesinde çağıranın id'yi elle sağlamasını gerektirir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'entities-and-repositories'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'entities-and-repositories')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$@Column(nullable = false, unique = true) gerçekte neyi üretir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$@Column(nullable = false, unique = true) gerçekte neyi üretir?$$,
           NULL, NULL,
           $$Veritabanının kendisi tarafından uygulanan gerçek bir NOT NULL UNIQUE kısıtlaması, yalnızca Java'da bir yerde kontrol edilen bir şey değil.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'entities-and-repositories'
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
    ($$Üretilen SQL'de hiçbir gerçek uygulaması olmayan bir yorum$$, FALSE, 0),
    ($$Hiçbir SQL üretilmeden önce Hibernate'in fırlattığı bir çalışma zamanı istisnası$$, FALSE, 1),
    ($$Veritabanının kendisi tarafından uygulanan gerçek bir NOT NULL UNIQUE kısıtlaması$$, TRUE, 2),
    ($$Yalnızca Java uygulaması içinde çalışan, veritabanı şemasına hiç dokunmayan bir doğrulama kontrolü$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'entities-and-repositories'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'entities-and-repositories')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir entity'nin zorluk alanı hiç @Enumerated annotation'ı olmadan eşleniyor. Daha sonra enum'un mevcut sabitlerinin ORTASINA yeni bir TASLAK sabiti ekleniyor. Mevcut satırlara ne olur?$$
      AND code_snippet = $$enum Zorluk { BASLANGIC, ORTA, ILERI }
// daha sonra şu hale gelir:
enum Zorluk { BASLANGIC, TASLAK, ORTA, ILERI }

@Entity
class Konu {
    private Zorluk zorluk; // hiç @Enumerated yok
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir entity'nin zorluk alanı hiç @Enumerated annotation'ı olmadan eşleniyor. Daha sonra enum'un mevcut sabitlerinin ORTASINA yeni bir TASLAK sabiti ekleniyor. Mevcut satırlara ne olur?$$,
           $$enum Zorluk { BASLANGIC, ORTA, ILERI }
// daha sonra şu hale gelir:
enum Zorluk { BASLANGIC, TASLAK, ORTA, ILERI }

@Entity
class Konu {
    private Zorluk zorluk; // hiç @Enumerated yok
}$$, $$java$$,
           $$@Enumerated'in atlanması varsayılan olarak ORDINAL'e düşer, sabitin sayısal pozisyonunu saklar -- ortaya yeni bir sabit eklemek sonraki tüm pozisyonları kaydırır, mevcut satırların anlamını sessizce bozar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'entities-and-repositories'
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
    ($$Hiçbir şey değişmez -- Hibernate varsayılan olarak sabitin adını saklar, sıralamadan etkilenmez$$, FALSE, 0),
    ($$Uygulama bir mapping doğrulama hatasıyla başlayamaz$$, FALSE, 1),
    ($$Hibernate mevcut her satırın saklı değerini yeni ordinal pozisyonlarla otomatik olarak eşleştirir$$, FALSE, 2),
    ($$Mevcut satırların saklı ordinal değerleri artık sessizce, gerçekte kaydedildikleri sabitlerden farklı sabitleri gösterir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'entities-and-repositories'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'entities-and-repositories')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$İki tane yepyeni, hiç kaydedilmemiş Konu entity'si, tamamen `id != null && id.equals(other.id)`'e dayanan bir equals() implementasyonuyla karşılaştırılıyor. Karşılaştırmanın sonucu nedir?$$
      AND code_snippet = $$Konu a = new Konu(); // id null, henüz kaydedilmedi
Konu b = new Konu(); // id null, henüz kaydedilmedi

System.out.println(a.equals(b));$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$İki tane yepyeni, hiç kaydedilmemiş Konu entity'si, tamamen `id != null && id.equals(other.id)`'e dayanan bir equals() implementasyonuyla karşılaştırılıyor. Karşılaştırmanın sonucu nedir?$$,
           $$Konu a = new Konu(); // id null, henüz kaydedilmedi
Konu b = new Konu(); // id null, henüz kaydedilmedi

System.out.println(a.equals(b));$$, $$java$$,
           $$İkisinde de id null olduğu için, id != null kontrolü başarısız olur, bu yüzden equals() doğru şekilde false döndürür -- bu kurala göre iki kaydedilmemiş entity asla eşit sayılmaz.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'entities-and-repositories'
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
    ($$false -- id != null kontrolü ikisi için de başarısız olur, bu yüzden kaydedilmemişken asla eşit sayılmazlar$$, TRUE, 0),
    ($$true -- ikisinin de id == null'dır, bu yüzden eşit sayılırlar$$, FALSE, 1),
    ($$id null olduğu için bir NullPointerException fırlatır$$, FALSE, 2),
    ($$id dışında hangi alanların eşleştiğine bağlıdır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'entities-and-repositories'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'entities-and-repositories')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir @RestController metodundan doğrudan bir @Entity döndürmenin özel riski nedir?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir @RestController metodundan doğrudan bir @Entity döndürmenin özel riski nedir?$$,
           NULL, NULL,
           $$API'nin genel JSON şeklini veritabanı mapping'inin kendisine bağlar ve lazy bir alanı transaction dışında serileştirme riski taşır (LazyInitializationException).$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'entities-and-repositories'
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
    ($$Var olup olmadığına bakılmaksızın entity'nin şifre alanını otomatik olarak açığa çıkarır$$, FALSE, 0),
    ($$API'nin genel JSON şeklini veritabanı mapping'inin kendisine bağlar ve lazy bir alanda LazyInitializationException riski taşır$$, TRUE, 1),
    ($$Gerçek bir dezavantajı yoktur -- entity'ler ve DTO'lar bir REST API'de işlevsel olarak birbirinin yerine geçebilir$$, FALSE, 2),
    ($$Jackson, @Entity ile işaretlenmiş herhangi bir sınıfı temelde serileştiremez$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'entities-and-repositories'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'entities-and-repositories')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Repository -> CrudRepository -> PagingAndSortingRepository -> JpaRepository zincirinin her katmanının neyi kattığını aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Repository -> CrudRepository -> PagingAndSortingRepository -> JpaRepository zincirinin her katmanının neyi kattığını aşağıdakilerden hangileri doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Repository, hiçbir metot katmayan bir marker interface'tir; CrudRepository save/findById/findAll/deleteById ekler; PagingAndSortingRepository findAll(Sort)/findAll(Pageable) ekler; JpaRepository flush()/saveAndFlush() gibi JPA'ya özgü ekstralar katar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'entities-and-repositories'
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
    ($$CrudRepository, flush() ve saveAndFlush(...) ekler$$, FALSE, 0),
    ($$JpaRepository zincirin köküdür, CrudRepository onu extend eder$$, FALSE, 1),
    ($$PagingAndSortingRepository, findAll(Sort) ve findAll(Pageable) ekler$$, TRUE, 2),
    ($$Repository, hiçbir metot katmayan, yalnızca Spring Data'nın onu tanımasını sağlayan bir marker interface'tir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'entities-and-repositories'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'entities-and-repositories')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir JPA entity'sinin neden parametresiz bir constructor'a ihtiyacı vardır?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir JPA entity'sinin neden parametresiz bir constructor'a ihtiyacı vardır?$$,
           NULL, NULL,
           $$Hibernate, hiçbir alan doldurulmadan önce entity instance'larını reflection ile oluşturur, bu yüzden hiçbir argümanla çağrılabilecek bir constructor'a ihtiyaç duyar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'entities-and-repositories'
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
    ($$Çünkü Spring Boot, amacından bağımsız olarak classpath'teki her sınıfın bir tane olmasını gerektirir$$, FALSE, 0),
    ($$Çünkü JPQL sorguları nesneleri yalnızca parametresiz bir constructor kullanarak oluşturabilir$$, FALSE, 1),
    ($$Aslında gerekli değildir -- yalnızca işlevsel bir amacı olmayan stilistik bir kuraldır$$, FALSE, 2),
    ($$Çünkü Hibernate, hiçbir alan doldurulmadan önce entity instance'larını reflection ile oluşturur$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'entities-and-repositories'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
