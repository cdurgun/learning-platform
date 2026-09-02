-- Promotion-style migration linking TR java-bean-validation quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'java-bean-validation')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$@Positive ile @PositiveOrZero arasındaki fark için hangi ifade doğrudur?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$@Positive ile @PositiveOrZero arasındaki fark için hangi ifade doğrudur?$$,
           NULL, NULL,
           $$@Positive katıdır ve sıfırı reddeder; @PositiveOrZero sıfırı kabul eder.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'java-bean-validation'
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
    ($$@Positive yalnızca BigDecimal ile, @PositiveOrZero yalnızca int ile çalışır$$, FALSE, 0),
    ($$İşlevsel olarak birebir aynıdırlar$$, FALSE, 1),
    ($$@PositiveOrZero, @Positive'den daha katıdır$$, FALSE, 2),
    ($$@Positive sıfırı reddeder (katı); @PositiveOrZero sıfırı kabul eder$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'java-bean-validation'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'java-bean-validation')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$@Future, tam olarak şu anki anı ("şimdi") geçerli olarak kabul eder mi?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$@Future, tam olarak şu anki anı ("şimdi") geçerli olarak kabul eder mi?$$,
           NULL, NULL,
           $$@Future katıdır -- "şimdi"nin kendisi bu kontrolü geçemez; buna izin vermek için @FutureOrPresent gerekir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'java-bean-validation'
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
    ($$Evet, çünkü @Future yalnızca tarih kısmını kontrol eder, saati değil$$, FALSE, 0),
    ($$Hangi tarih/saat tipinin kullanıldığına bağlıdır$$, FALSE, 1),
    ($$Hayır -- @Future katıdır, "şimdi"nin kendisi bu kontrolü geçemez; bunun için @FutureOrPresent gerekir$$, TRUE, 2),
    ($$Evet, "şimdi" her zaman birkaç milisaniye ileride sayılır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'java-bean-validation'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'java-bean-validation')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir geliştirici bir BigDecimal alanına şu kısıtlamayı yazıyor. Ne olur?$$
      AND code_snippet = $$record Fiyat(@DecimalMin(0.01) BigDecimal tutar) {}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir geliştirici bir BigDecimal alanına şu kısıtlamayı yazıyor. Ne olur?$$,
           $$record Fiyat(@DecimalMin(0.01) BigDecimal tutar) {}$$, $$java$$,
           $$@DecimalMin'in değeri bir String olmalıdır, sayısal bir literal değil -- bu derlenmez.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'java-bean-validation'
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
    ($$Derlenmez -- @DecimalMin'in değeri sayısal bir literal değil, bir String olmalıdır$$, TRUE, 0),
    ($$Derlenir ve tam olarak @DecimalMin("0.01") gibi çalışır$$, FALSE, 1),
    ($$Derlenir ama floating-point yuvarlaması yüzünden her değeri reddeder$$, FALSE, 2),
    ($$Derlenir ama sınırı tamamen sessizce yok sayar$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'java-bean-validation'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'java-bean-validation')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir kısıtlamada düz bir string yerine message = "{user.age.tooYoung}" yazmanın amacı nedir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir kısıtlamada düz bir string yerine message = "{user.age.tooYoung}" yazmanın amacı nedir?$$,
           NULL, NULL,
           $$Mesajı, tek bir sabit-kodlanmış string yerine, aktif locale için bir messages.properties dosyasından çözer.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'java-bean-validation'
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
    ($$Kısıtlamayı tamamen devre dışı bırakır, yalnızca key'i loglar$$, FALSE, 0),
    ($$Kısıtlamanın her locale için iki kez çalışmasını zorunlu kılar$$, FALSE, 1),
    ($$Mesajı, tek bir sabit-kodlanmış string yerine, aktif locale için bir messages.properties dosyasından çözer$$, TRUE, 2),
    ($$Hiçbir etkisi yoktur -- iki biçim de aynı şekilde davranır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'java-bean-validation'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'java-bean-validation')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$@GecerliTarihAraligi, neden giris veya cikis'in kendisine değil de record'un tamamına (sınıf/tip seviyesine) konur?$$
      AND code_snippet = $$@Target(ElementType.TYPE)
@Constraint(validatedBy = TarihAraligiValidator.class)
@interface GecerliTarihAraligi { String message() default "Gecersiz tarih araligi"; }

class TarihAraligiValidator implements ConstraintValidator<GecerliTarihAraligi, RezervasyonRequest> {
    public boolean isValid(RezervasyonRequest r, ConstraintValidatorContext ctx) {
        return r.cikis().isAfter(r.giris());
    }
}

@GecerliTarihAraligi
record RezervasyonRequest(LocalDate giris, LocalDate cikis) {}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$@GecerliTarihAraligi, neden giris veya cikis'in kendisine değil de record'un tamamına (sınıf/tip seviyesine) konur?$$,
           $$@Target(ElementType.TYPE)
@Constraint(validatedBy = TarihAraligiValidator.class)
@interface GecerliTarihAraligi { String message() default "Gecersiz tarih araligi"; }

class TarihAraligiValidator implements ConstraintValidator<GecerliTarihAraligi, RezervasyonRequest> {
    public boolean isValid(RezervasyonRequest r, ConstraintValidatorContext ctx) {
        return r.cikis().isAfter(r.giris());
    }
}

@GecerliTarihAraligi
record RezervasyonRequest(LocalDate giris, LocalDate cikis) {}$$, $$java$$,
           $$Kural aynı anda iki alanı görmesi gerektiği için -- hiçbir tek-alan annotation'ı "cikis, giris'ten sonra olmalı" kuralını ifade edemez.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'java-bean-validation'
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
    ($$Kural aynı anda iki alanı görmesi gerektiği için -- hiçbir tek-alan annotation'ı "cikis, giris'ten sonra olmalı" kuralını ifade edemez$$, TRUE, 0),
    ($$Bean Validation, record bileşenlerinde annotation kullanımına hiç izin vermediği için$$, FALSE, 1),
    ($$Sınıf seviyesi annotation'lar alan seviyesindekilerden önce çalışır ve burada bu gereklidir$$, FALSE, 2),
    ($$Hiçbir işlevsel nedeni olmayan, keyfi bir stil tercihidir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'java-bean-validation'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'java-bean-validation')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Kural olarak, özel bir ConstraintValidator'ın isValid(...) metodu, doğrulanan değer null olduğunda ne döndürmelidir?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Kural olarak, özel bir ConstraintValidator'ın isValid(...) metodu, doğrulanan değer null olduğunda ne döndürmelidir?$$,
           NULL, NULL,
           $$true -- bu, eksik bir değeri raporlama sorumluluğunu ayrı bir @NotNull kısıtlamasına bırakır.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'java-bean-validation'
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
    ($$Hızlı başarısız olmak için bir NullPointerException fırlatmalıdır$$, FALSE, 0),
    ($$Bean Validation bir validator'ı asla null bir değerle çağırmadığı için önemli değildir$$, FALSE, 1),
    ($$true -- bu, eksik bir değeri raporlama sorumluluğunu ayrı bir @NotNull kısıtlamasına bırakır$$, TRUE, 2),
    ($$Hiçbir alanın yanlışlıkla doğrulanmadan kalmaması için false$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'java-bean-validation'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'java-bean-validation')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Validation group'ları ile ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Validation group'ları ile ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Grup etiketli bir kısıtlama yalnızca o grup için çalışır; etiketlenmemiş bir kısıtlama belirli bir gruba karşı doğrulanırken atlanır; aynı DTO gruba göre farklı kısıtlamalar uygulayabilir. Group'lar her DTO için genel amaçlı önerilen bir mekanizma DEĞİLDİR.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'java-bean-validation'
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
    ($$Aynı DTO, hangi gruba karşı doğrulandığına bağlı olarak farklı kısıtlamalar uygulayabilir$$, TRUE, 0),
    ($$groups = OnUpdate.class ile etiketlenmiş bir kısıtlama yalnızca o belirli grup için doğrulama yapılırken çalışır$$, TRUE, 1),
    ($$Validation group'ları, uygulamadaki her DTO'yu doğrulamak için önerilen, genel amaçlı bir yoldur$$, FALSE, 2),
    ($$Hiç groups attribute'u olmayan bir kısıtlama, belirli bir gruba karşı doğrulama yapılırken sessizce atlanır$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'java-bean-validation'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
