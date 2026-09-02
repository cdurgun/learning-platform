-- Promotion-style migration linking TR validation-exception-handling quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'validation-exception-handling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Hangi annotation null, boş bir string ("") ve yalnızca boşluk içeren bir string'i ("   ") reddeder?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Hangi annotation null, boş bir string ("") ve yalnızca boşluk içeren bir string'i ("   ") reddeder?$$,
           NULL, NULL,
           $$@NotBlank, null, boş string ve yalnızca boşluk içeren string'leri aynı şekilde reddeder -- üçü arasında en katı olanıdır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'validation-exception-handling'
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
    ($$@NotEmpty$$, FALSE, 0),
    ($$@NotNull$$, FALSE, 1),
    ($$@Size(min = 1)$$, FALSE, 2),
    ($$@NotBlank$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'validation-exception-handling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: MULTIPLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'validation-exception-handling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$@Size(min = 3, max = 50) ile işaretlenmiş bir alan için aşağıdaki değerlerden hangileri doğrulamayı geçer? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$@Size(min = 3, max = 50) ile işaretlenmiş bir alan için aşağıdaki değerlerden hangileri doğrulamayı geçer? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Her iki sınır da inclusive'dir -- tam olarak 3 ve tam olarak 50 karakter ikisi de geçer; 2 ve 51 ikisi de başarısız olur.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'validation-exception-handling'
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
    ($$Tam olarak 2 karakter uzunluğunda bir string$$, FALSE, 0),
    ($$Tam olarak 51 karakter uzunluğunda bir string$$, FALSE, 1),
    ($$Tam olarak 50 karakter uzunluğunda bir string$$, TRUE, 2),
    ($$Tam olarak 3 karakter uzunluğunda bir string$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'validation-exception-handling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'validation-exception-handling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir request record'unun alanlarına yazılmış Bean Validation kurallarının gerçekten çalışmasını ne tetikler?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir request record'unun alanlarına yazılmış Bean Validation kurallarının gerçekten çalışmasını ne tetikler?$$,
           NULL, NULL,
           $$Yalnızca parametre @Valid (veya @Validated) ile işaretlendiğinde çalışırlar.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'validation-exception-handling'
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
    ($$Yalnızca parametre @Valid (veya @Validated) ile işaretlendiğinde çalışırlar$$, TRUE, 0),
    ($$Record örneklendiğinde otomatik olarak çalışırlar$$, FALSE, 1),
    ($$Sınıf ayrıca Serializable'ı da implemente ederse çalışırlar$$, FALSE, 2),
    ($$Ekstra bir annotation'a gerek kalmadan her @RequestBody parametresi için otomatik çalışırlar$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'validation-exception-handling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'validation-exception-handling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$adres.sehir boş ("") olan bir istek geliyor. Ne olur?$$
      AND code_snippet = $$record Adres(@NotBlank String sehir) {}
record KargoRequest(String alici, Adres adres) {}
// Not: adres alanında @Valid yok

@PostMapping("/kargo")
public String kargoGonder(@Valid @RequestBody KargoRequest request) {
    return "OK";
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$adres.sehir boş ("") olan bir istek geliyor. Ne olur?$$,
           $$record Adres(@NotBlank String sehir) {}
record KargoRequest(String alici, Adres adres) {}
// Not: adres alanında @Valid yok

@PostMapping("/kargo")
public String kargoGonder(@Valid @RequestBody KargoRequest request) {
    return "OK";
}$$, $$java$$,
           $$adres kendi @Valid'ine sahip olmadığı için (cascading etkinleştirilmediği için) Adres'in kendi @NotBlank kuralı hiç çalışmaz, iç içe nesnenin kısıtları sessizce atlanır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'validation-exception-handling'
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
    ($$Doğrulama sırasında bir NullPointerException fırlatılır$$, FALSE, 0),
    ($$İstek kabul edilir -- adres kendi @Valid'ine sahip olmadığı için (cascading etkinleştirilmediği için) Adres'in kendi @NotBlank kuralı hiç çalışmaz$$, TRUE, 1),
    ($$alici da yan etki olarak reddedilir$$, FALSE, 2),
    ($$İstek, adres.sehir'i belirten bir doğrulama hatasıyla reddedilir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'validation-exception-handling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'validation-exception-handling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Tek bir @Controller sınıfının içinde doğrudan bir metoda konan @ExceptionHandler, yalnızca o controller'a mı özeldir, yoksa uygulama genelinde mi uygulanır?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Tek bir @Controller sınıfının içinde doğrudan bir metoda konan @ExceptionHandler, yalnızca o controller'a mı özeldir, yoksa uygulama genelinde mi uygulanır?$$,
           NULL, NULL,
           $$Yalnızca aynı controller'a özeldir -- o sınıftaki handler metotlarının fırlattığı istisnaları yakalar.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'validation-exception-handling'
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
    ($$Yalnızca @RestController'lar için çalışır, @Controller'lar için asla çalışmaz$$, FALSE, 0),
    ($$Varsayılan olarak uygulama genelinde uygulanır$$, FALSE, 1),
    ($$Çalışması için @RestControllerAdvice'a ihtiyaç duyar$$, FALSE, 2),
    ($$Yalnızca aynı controller'a özeldir -- o sınıftaki handler metotlarının fırlattığı istisnaları yakalar$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'validation-exception-handling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'validation-exception-handling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir @RestControllerAdvice sınıfında ResourceNotFoundException, IllegalArgumentException ve Exception için @ExceptionHandler'lar var (dosyada bu sırayla, Exception ilk yazılmış). Aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir @RestControllerAdvice sınıfında ResourceNotFoundException, IllegalArgumentException ve Exception için @ExceptionHandler'lar var (dosyada bu sırayla, Exception ilk yazılmış). Aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Spring, dosyadaki sıradan bağımsız olarak en spesifik eşleşen handler'ı seçer; Exception.class, yalnızca daha spesifik hiçbir handler eşleşmediğinde tetiklenen son çare bir yakalayıcıdır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'validation-exception-handling'
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
    ($$Spring, fırlatılan istisnanın türü için dosyadaki sıradan bağımsız olarak en spesifik eşleşen handler'ı seçer$$, TRUE, 0),
    ($$Exception.class handler'ı yalnızca daha spesifik hiçbir handler eşleşmediğinde tetiklenir -- son çare bir yakalayıcıdır$$, TRUE, 1),
    ($$Bir sınıfta üç ayrı handler tanımlamak izin verilmez -- sınıf başına yalnızca bir @ExceptionHandler'a izin verilir$$, FALSE, 2),
    ($$Exception.class ilk yazıldığı için her zaman daha spesifik handler'lara karşı kazanır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'validation-exception-handling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'validation-exception-handling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$ProblemDetail.forStatusAndDetail(status, detail), sade bir String hata mesajı döndürmenin ötesinde ne sağlar?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$ProblemDetail.forStatusAndDetail(status, detail), sade bir String hata mesajı döndürmenin ötesinde ne sağlar?$$,
           NULL, NULL,
           $$Durum kodunu, otomatik türetilmiş bir title'ı ve verilen detail'i taşıyan standartlaştırılmış bir RFC 7807 gövdesi -- ayrıca setProperty(...) ile özel alanlar ekleme imkânı.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'validation-exception-handling'
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
    ($$Durum kodunu, otomatik türetilmiş bir title'ı ve verilen detail'i taşıyan standartlaştırılmış bir RFC 7807 gövdesi -- ayrıca setProperty(...) ile özel alanlar ekleme imkânı$$, TRUE, 0),
    ($$Başarısız isteği otomatik olarak yeniden dener$$, FALSE, 1),
    ($$Response'u JSON yerine XML'e dönüştürür$$, FALSE, 2),
    ($$İsteğin geri kalanı için daha fazla istisna işlemeyi devre dışı bırakır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'validation-exception-handling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
