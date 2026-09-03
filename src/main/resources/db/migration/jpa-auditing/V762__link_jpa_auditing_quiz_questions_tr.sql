-- Promotion-style migration linking TR jpa-auditing quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jpa-auditing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$JPA auditing (@CreatedDate/@LastModifiedDate) hangi sorunu çözer?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$JPA auditing (@CreatedDate/@LastModifiedDate) hangi sorunu çözer?$$,
           NULL, NULL,
           $$Bir entity oluşturan ya da güncelleyen her yerde tekrarlanan, elle yazılmış LocalDateTime.now() çağrılarının yerini alır -- bunu tek bir yerde bile unutmak kolaydır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'jpa-auditing'
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
    ($$Entity alan adlarını otomatik olarak başka bir dile çevirir$$, FALSE, 0),
    ($$Bir entity oluşturan ya da güncelleyen her yerde tekrarlanan, elle yazılmış LocalDateTime.now() çağrılarının yerini alır$$, TRUE, 1),
    ($$Kaydetmeden önce her entity'nin alanlarını otomatik olarak doğrular$$, FALSE, 2),
    ($$Denetlenen entity'lerde primary key ihtiyacının yerini alır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jpa-auditing'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jpa-auditing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$@CreatedDate ile @LastModifiedDate arasındaki zamanlama farkı nedir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$@CreatedDate ile @LastModifiedDate arasındaki zamanlama farkı nedir?$$,
           NULL, NULL,
           $$@CreatedDate, ilk persist'te tam olarak bir kez doldurulur ve bir daha hiç dokunulmaz; @LastModifiedDate aynı insert'te doldurulur ve sonraki her güncellemede yeniden doldurulur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'jpa-auditing'
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
    ($$@LastModifiedDate ilk persist'te bir kez doldurulur; @CreatedDate sonraki her save'de güncellenir$$, FALSE, 0),
    ($$Hiçbir zamanlama farkı yoktur -- ikisi de her save'de aynı değerle tetiklenir$$, FALSE, 1),
    ($$@CreatedDate ilk persist'te tam olarak bir kez doldurulur ve bir daha dokunulmaz; @LastModifiedDate sonraki her güncellemede de güncellenir$$, TRUE, 2),
    ($$Her iki alan da yalnızca ilk persist'te tam olarak bir kez doldurulur ve sonrasında hiç güncellenmez$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jpa-auditing'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jpa-auditing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir entity'nin bir alanında @CreatedDate, sınıfında da @EntityListeners(AuditingEntityListener.class) var. Hiçbir @Configuration sınıfında @EnableJpaAuditing yok. Yeni bir instance kaydedildiğinde ne olur?$$
      AND code_snippet = $$@Entity
@EntityListeners(AuditingEntityListener.class)
class Soru {
    @CreatedDate
    private LocalDateTime olusturulmaTarihi;
}
// Uygulamada hiçbir yerde @EnableJpaAuditing yok$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir entity'nin bir alanında @CreatedDate, sınıfında da @EntityListeners(AuditingEntityListener.class) var. Hiçbir @Configuration sınıfında @EnableJpaAuditing yok. Yeni bir instance kaydedildiğinde ne olur?$$,
           $$@Entity
@EntityListeners(AuditingEntityListener.class)
class Soru {
    @CreatedDate
    private LocalDateTime olusturulmaTarihi;
}
// Uygulamada hiçbir yerde @EnableJpaAuditing yok$$, $$java$$,
           $$@EnableJpaAuditing'in eksik olması, alanın hiç doldurulmadığı, hiçbir hata göstermeden sessizce null bırakıldığı anlamına gelir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'jpa-auditing'
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
    ($$olusturulmaTarihi doğru şekilde doldurulur, çünkü tek başına @EntityListeners yeterlidir$$, FALSE, 0),
    ($$Uygulama, eksik annotation'ı belirten net bir yapılandırma hatasıyla başlayamaz$$, FALSE, 1),
    ($$olusturulmaTarihi, varsayılan geri dönüş olarak Unix epoch (1970-01-01) ile doldurulur$$, FALSE, 2),
    ($$olusturulmaTarihi, ne eksik olduğunu belirten hiçbir hata olmadan sessizce null bırakılır$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jpa-auditing'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jpa-auditing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$@CreatedBy ve @LastModifiedBy, @CreatedDate ve @LastModifiedDate ile nasıl ilişkilidir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$@CreatedBy ve @LastModifiedBy, @CreatedDate ve @LastModifiedDate ile nasıl ilişkilidir?$$,
           NULL, NULL,
           $$Tarih karşılıkları gibi tam olarak çalışırlar -- aynı listener, aynı lifecycle zamanlaması -- ama bir zaman damgası yerine değişikliği kimin yaptığının kimliğini yakalarlar.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'jpa-auditing'
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
    ($$Tarih karşılıkları gibi aynı listener ve zamanlamayı kullanarak tam olarak çalışırlar, ama NE ZAMAN yerine değişikliği KİMİN yaptığını yakalarlar$$, TRUE, 0),
    ($$AuditingEntityListener'dan tamamen ayrı bir listener gerektirirler$$, FALSE, 1),
    ($$Yalnızca elle ayarlanmış bir reviewedBy alanına da sahip entity'lerde çalışırlar$$, FALSE, 2),
    ($$@CreatedDate/@LastModifiedDate'in yanında çalışmak yerine onların tamamen yerini alırlar$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jpa-auditing'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jpa-auditing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Spring Data JPA'nın, @CreatedBy/@LastModifiedBy'ın otomatik olarak okuduğu, yerleşik bir "mevcut kullanıcı" kavramı var mıdır?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Spring Data JPA'nın, @CreatedBy/@LastModifiedBy'ın otomatik olarak okuduğu, yerleşik bir "mevcut kullanıcı" kavramı var mıdır?$$,
           NULL, NULL,
           $$Hayır -- AuditorAware<T>, uygulamanın bu cevabı sağlamak için implemente etmesi gereken interface'tir; Spring Data JPA'nın yerleşik bir mevcut kullanıcı kavramı yoktur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'jpa-auditing'
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
    ($$Hayır -- Spring Security classpath'te olmadıkça @CreatedBy/@LastModifiedBy basitçe çalışmaz$$, FALSE, 0),
    ($$Hayır -- AuditorAware<T>, uygulamanın bu cevabı sağlamak için implemente etmesi gereken bir interface'tir$$, TRUE, 1),
    ($$Evet -- hiçbir yapılandırma olmadan doğrudan Spring Security'nin SecurityContextHolder'ından okur$$, FALSE, 2),
    ($$Evet -- açıkça geçersiz kılınmadıkça her zaman "system" string'ine varsayılan olarak döner$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jpa-auditing'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jpa-auditing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri @MappedSuperclass'ı doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri @MappedSuperclass'ı doğru şekilde tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$@MappedSuperclass'ın kendisi bir @Entity değildir ve kendi tablosu yoktur -- alanları onu extend eden her entity'ye kopyalanır, denetim annotation'larını her birinde ayrı ayrı tekrarlamaktan kaçınır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'jpa-auditing'
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
    ($$Sıradan bir entity gibi kendi @Table annotation'ına ihtiyaç duyar$$, FALSE, 0),
    ($$Bir uygulamada yalnızca tek bir entity'nin belirli bir @MappedSuperclass'ı extend etmesine izin verilir$$, FALSE, 1),
    ($$Alanları, onu extend eden her entity'ye kopyalanır, her birinde tekrarlanmasını önler$$, TRUE, 2),
    ($$Kendisi bir @Entity değildir ve kendi tablosu yoktur$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jpa-auditing'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: CODE_OUTPUT)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'jpa-auditing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir entity yükleniyor, ilgisiz bir alan zaten sahip olduğu değerin AYNISINA yeniden atanıyor, ve transaction commit oluyor (bir save tetikleniyor). @LastModifiedDate güncellenir mi?$$
      AND code_snippet = $$Soru s = repository.findById(1L).get();
s.setBaslik(s.getBaslik()); // AYNI degere yeniden atandi
// transaction commit oluyor, entity kaydediliyor$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bir entity yükleniyor, ilgisiz bir alan zaten sahip olduğu değerin AYNISINA yeniden atanıyor, ve transaction commit oluyor (bir save tetikleniyor). @LastModifiedDate güncellenir mi?$$,
           $$Soru s = repository.findById(1L).get();
s.setBaslik(s.getBaslik()); // AYNI degere yeniden atandi
// transaction commit oluyor, entity kaydediliyor$$, $$java$$,
           $$Evet -- @LastModifiedDate, veritabanına ulaşan her save'de güncellenir, tıpkı dirty checking'in takip edilen her değişikliği yazması gibi; hangi save'lerin "gerçekten" anlamlı bir şey değiştirdiği konusunda seçici bir zekaya sahip değildir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'jpa-auditing'
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
    ($$Hayır -- Spring Data JPA değerin değişmediğini tespit eder ve @LastModifiedDate'i güncellemeyi atlar$$, FALSE, 0),
    ($$Bir alanı kendi değerine yeniden atamak geçerli bir işlem olmadığı için bir istisna fırlatır$$, FALSE, 1),
    ($$Alanın kendi @Column(unique = true) kısıtlamasına sahip olup olmadığına bağlıdır$$, FALSE, 2),
    ($$Evet -- @LastModifiedDate, değerin gerçekten değişip değişmediğinden bağımsız olarak, veritabanına ulaşan her save'de güncellenir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'jpa-auditing'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
