-- Promotion-style migration linking TR testing-spring-data-jpa quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'testing-spring-data-jpa')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir test, when(repository.findBySlug("records")).thenReturn(...) yazıyor. GERÇEK findBySlug metodu yanlış yazılmış ya da tamamen yanlış bir kolonda filtreleme yapıyor olsaydı, bu test bunu yakalar mıydı?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir test, when(repository.findBySlug("records")).thenReturn(...) yazıyor. GERÇEK findBySlug metodu yanlış yazılmış ya da tamamen yanlış bir kolonda filtreleme yapıyor olsaydı, bu test bunu yakalar mıydı?$$,
           NULL, NULL,
           $$Hayır -- mock, Spring Data JPA'dan gerçek metodu gerçek bir sorguya ayrıştırmasını hiç istemez ve hiçbir zaman veritabanına dokunmaz; yalnızca mock'un kendi yapılandırılmış davranışını doğrular.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'testing-spring-data-jpa'
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
    ($$Evet, ama yalnızca test @DataJpaTest ile de işaretlenmişse$$, FALSE, 0),
    ($$Hayır -- mock yalnızca kendi yapılandırılmış davranışını doğrular, Spring Data JPA'dan gerçek sorguyu hiç ayrıştırmasını ya da çalıştırmasını istemez$$, TRUE, 1),
    ($$Evet -- Mockito her zaman mock'lanmış bir metodun adını gerçek repository interface'ine karşı doğrular$$, FALSE, 2),
    ($$Metodun türetilmiş bir sorgu mu yoksa özel bir @Query mi olduğuna bağlıdır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'testing-spring-data-jpa'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'testing-spring-data-jpa')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$@DataJpaTest neyi yükler ve her test metodunun değişikliklerine sonrasında ne olur?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$@DataJpaTest neyi yükler ve her test metodunun değişikliklerine sonrasında ne olur?$$,
           NULL, NULL,
           $$Yalnızca persistence katmanını (entity'ler, repository'ler, gerçek bir veritabanı bağlantısı) yükler ve her test metodu kendi transaction'ı içinde çalışır, sonrasında otomatik olarak geri alınır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'testing-spring-data-jpa'
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
    ($$Yalnızca controller'ları yükler, her repository'yi otomatik olarak mock'lar$$, FALSE, 0),
    ($$Bir alana @Autowired eklenene kadar hiçbir şey yüklemez$$, FALSE, 1),
    ($$Yalnızca persistence katmanını (entity'ler, repository'ler, gerçek bir veritabanı bağlantısı) yükler, her testin transaction'ı sonrasında geri alınır$$, TRUE, 2),
    ($$Controller'lar ve servisler dahil tüm uygulamayı yükler; değişiklikler testler arasında kalıcı olur$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'testing-spring-data-jpa'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'testing-spring-data-jpa')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir @DataJpaTest için test verisi, testin gerçekten doğrulamaya çalıştığı repository metodu yerine neden TestEntityManager ile kurulmalıdır?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir @DataJpaTest için test verisi, testin gerçekten doğrulamaya çalıştığı repository metodu yerine neden TestEntityManager ile kurulmalıdır?$$,
           NULL, NULL,
           $$Verinin, testin doğrulamaya çalıştığı repository metodunun ta kendisiyle veritabanına konması, o metottaki bir hatayı kendi kurulumunun arkasına gizleyebilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'testing-spring-data-jpa'
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
    ($$Çünkü TestEntityManager, herhangi bir repository metodundan önemli ölçüde daha hızlıdır$$, FALSE, 0),
    ($$Çünkü repository metotları, @DataJpaTest başlatılmayı bitirmeden önce hiç çağrılamaz$$, FALSE, 1),
    ($$Çünkü TestEntityManager, @DataJpaTest'in derlenmesi için bile gereklidir$$, FALSE, 2),
    ($$Çünkü test edilen metodu kendi kurulumu için kullanmak, o metottaki bir hatayı kendi kurulumunun arkasına gizleyebilir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'testing-spring-data-jpa'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'testing-spring-data-jpa')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir test, iki farklı konu için CodeExample'ları, kasıtlı olarak sıralama dışı, kaydediyor, sonra findByTopicIdOrderBySortOrderAsc(topicId)'yi çağırıyor ve yalnızca iki sonucun geldiğini VE artan sırada olduklarını doğruluyor. Bu neden yalnızca bir satır kaydedip onun geri geldiğini doğrulamaktan anlamlı ölçüde daha güçlü bir testtir?$$
      AND code_snippet = $$entityManager.persist(new CodeExample(konuId, 2));
entityManager.persist(new CodeExample(konuId, 1));
entityManager.persist(new CodeExample(digerKonuId, 1));

List<CodeExample> sonuc = repository.findByTopicIdOrderBySortOrderAsc(konuId);
assertThat(sonuc).hasSize(2);
assertThat(sonuc.get(0).getSortOrder()).isEqualTo(1);$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir test, iki farklı konu için CodeExample'ları, kasıtlı olarak sıralama dışı, kaydediyor, sonra findByTopicIdOrderBySortOrderAsc(topicId)'yi çağırıyor ve yalnızca iki sonucun geldiğini VE artan sırada olduklarını doğruluyor. Bu neden yalnızca bir satır kaydedip onun geri geldiğini doğrulamaktan anlamlı ölçüde daha güçlü bir testtir?$$,
           $$entityManager.persist(new CodeExample(konuId, 2));
entityManager.persist(new CodeExample(konuId, 1));
entityManager.persist(new CodeExample(digerKonuId, 1));

List<CodeExample> sonuc = repository.findByTopicIdOrderBySortOrderAsc(konuId);
assertThat(sonuc).hasSize(2);
assertThat(sonuc.get(0).getSortOrder()).isEqualTo(1);$$, $$java$$,
           $$Gerçekten hem gerçek filtrelemeyi (digerKonuId hariç tutularak) HEM DE gerçek sıralamayı (sortOrder 1'in 2'den önce gelmesi) aynı anda kanıtlar, tek satırlık bir test ikisini de kanıtlamadan yanlışlıkla geçebilirdi.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'testing-spring-data-jpa'
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
    ($$Gerçekten hem gerçek filtrelemeyi (digerKonuId hariç tutularak) hem de gerçek sıralamayı (sortOrder 1'in 2'den önce gelmesi) aynı anda kanıtlar$$, TRUE, 0),
    ($$Daha fazlasını kanıtlamaz -- tek satırlık bir test de tam olarak aynı hataları yakalardı$$, FALSE, 1),
    ($$Yalnızca filtrelemenin çalıştığını kanıtlar -- sıralama hâlâ tamamen ayrı bir test metodu gerektirir$$, FALSE, 2),
    ($$Anlamlı ölçüde daha zayıftır, çünkü üç satır persist etmek bir unique-constraint ihlali riski taşır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'testing-spring-data-jpa'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'testing-spring-data-jpa')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir @DataJpaTest, join fetch kullanan özel bir @Query metodunu çağırıyor ve JPQL'deki join edilen property path'inde bir yazım hatası var. Test büyük olasılıkla neyi ortaya çıkarır?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir @DataJpaTest, join fetch kullanan özel bir @Query metodunu çağırıyor ve JPQL'deki join edilen property path'inde bir yazım hatası var. Test büyük olasılıkla neyi ortaya çıkarır?$$,
           NULL, NULL,
           $$Test hemen başarısız olurdu -- ya hiçbir sonuç olmadan, ya da ilişkiye hâlâ açık olan test transaction'ı dışında erişildiğinde gerçek bir LazyInitializationException ile.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'testing-spring-data-jpa'
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
    ($$Test geçer, çünkü @DataJpaTest gerçekte bir sorgunun JPQL metnini çalıştırmaz$$, FALSE, 0),
    ($$Test hemen başarısız olur -- ya hiçbir sonuç olmadan, ya da ilişkiye erişildiğinde gerçek bir LazyInitializationException ile$$, TRUE, 1),
    ($$Hiçbir şey -- JPQL'deki bir yazım hatası Hibernate tarafından sessizce yok sayılır ve no-op olarak ele alınır$$, FALSE, 2),
    ($$JPQL Java derleyicisi tarafından kontrol edildiği için uygulama derlenmez$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'testing-spring-data-jpa'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'testing-spring-data-jpa')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri @DataJpaTest'in varsayılan embedded test veritabanının ödünleşimini doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri @DataJpaTest'in varsayılan embedded test veritabanının ödünleşimini doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Embedded bir veritabanı hızlıdır ve kuruluma ihtiyaç duymaz, ama PostgreSQL'e özgü davranışa dayanan bir sorgu (native bir RANDOM() sorgusu gibi) embedded ikame karşısında geçebilir ve yine de gerçek şeye karşı başarısız olabilir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'testing-spring-data-jpa'
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
    ($$Her olası sorgu için, native olanlar dahil, PostgreSQL ile birebir aynı davranır$$, FALSE, 0),
    ($$@DataJpaTest varsayılan olarak asla embedded bir veritabanı kullanmaz -- bu davranış her zaman açıkça etkinleştirilmelidir$$, FALSE, 1),
    ($$PostgreSQL'e özgü davranışa dayanan bir sorgu ona karşı geçebilir ve yine de gerçek PostgreSQL'e karşı başarısız olabilir$$, TRUE, 2),
    ($$Testleri gerçek bir PostgreSQL instance'ına yönlendirmenin aksine hızlıdır ve kuruluma ihtiyaç duymaz$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'testing-spring-data-jpa'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: CODE_OUTPUT)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'testing-spring-data-jpa')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu test kurulumunda AutoConfigureTestDatabase.Replace.NONE ne başarır?$$
      AND code_snippet = $$@Testcontainers
@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class GercekVeritabaniTest {
    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16");

    @DynamicPropertySource
    static void props(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", postgres::getJdbcUrl);
    }
}$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu test kurulumunda AutoConfigureTestDatabase.Replace.NONE ne başarır?$$,
           $$@Testcontainers
@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class GercekVeritabaniTest {
    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16");

    @DynamicPropertySource
    static void props(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", postgres::getJdbcUrl);
    }
}$$, $$java$$,
           $$@DataJpaTest'in DataSource'u kendi embedded varsayılanıyla değiştirmesini durdurur, bu yüzden @Container/@DynamicPropertySource ile başlatılan gerçek, atılabilir PostgreSQL container'ı gerçekten kullanılır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'testing-spring-data-jpa'
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
    ($$Testcontainers'ı tamamen devre dışı bırakır, @Container mevcut olmasına rağmen embedded veritabanına geri döner$$, FALSE, 0),
    ($$@DataJpaTest'in her zaman embedded bir veritabanı kullanmasını zorunlu kılar, @DynamicPropertySource'u yok sayar$$, FALSE, 1),
    ($$Gerçek bir etkisi yoktur -- @DataJpaTest zaten varsayılan olarak DataSource'u hiç değiştirmez$$, FALSE, 2),
    ($$@DataJpaTest'in DataSource'u kendi embedded varsayılanıyla değiştirmesini durdurur, gerçek Testcontainers Postgres'inin kullanılmasını sağlar$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'testing-spring-data-jpa'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
