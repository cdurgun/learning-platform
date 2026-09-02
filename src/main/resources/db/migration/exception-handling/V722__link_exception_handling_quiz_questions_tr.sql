-- Promotion-style migration linking TR exception-handling quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-handling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$@Valid, bir @RequestBody üzerinde başarısız olduğunda Spring hangi istisnayı fırlatır ve bu istisna neyi taşır?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$@Valid, bir @RequestBody üzerinde başarısız olduğunda Spring hangi istisnayı fırlatır ve bu istisna neyi taşır?$$,
           NULL, NULL,
           $$Alan başına hatalar içeren bir BindingResult taşıyan MethodArgumentNotValidException.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'exception-handling'
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
    ($$Alan başına hatalar içeren bir BindingResult taşıyan MethodArgumentNotValidException$$, TRUE, 0),
    ($$Yararlı hiçbir şey taşımayan bir IllegalArgumentException$$, FALSE, 1),
    ($$Yalnızca ham bir Set<ConstraintViolation> taşıyan bir ConstraintViolationException$$, FALSE, 2),
    ($$Orijinal request body'sini taşıyan bir ValidationException$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-handling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-handling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Request body'si hem ad alanındaki @NotBlank'i hem de sınıf seviyesindeki @GecerliTarihAraligi özel kısıtlamasını başarısız kılıyor. İstemcinin hatalar dizisi ne içerir?$$
      AND code_snippet = $$@ExceptionHandler(MethodArgumentNotValidException.class)
public ProblemDetail handle(MethodArgumentNotValidException ex) {
    List<String> hatalar = ex.getBindingResult().getFieldErrors().stream()
        .map(fe -> fe.getField() + ": " + fe.getDefaultMessage())
        .toList();
    ProblemDetail pd = ProblemDetail.forStatusAndDetail(HttpStatus.BAD_REQUEST, "Dogrulama basarisiz");
    pd.setProperty("hatalar", hatalar);
    return pd;
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Request body'si hem ad alanındaki @NotBlank'i hem de sınıf seviyesindeki @GecerliTarihAraligi özel kısıtlamasını başarısız kılıyor. İstemcinin hatalar dizisi ne içerir?$$,
           $$@ExceptionHandler(MethodArgumentNotValidException.class)
public ProblemDetail handle(MethodArgumentNotValidException ex) {
    List<String> hatalar = ex.getBindingResult().getFieldErrors().stream()
        .map(fe -> fe.getField() + ": " + fe.getDefaultMessage())
        .toList();
    ProblemDetail pd = ProblemDetail.forStatusAndDetail(HttpStatus.BAD_REQUEST, "Dogrulama basarisiz");
    pd.setProperty("hatalar", hatalar);
    return pd;
}$$, $$java$$,
           $$Yalnızca ad hatası -- @GecerliTarihAraligi hatası getGlobalErrors()'ta bir ObjectError olarak ortaya çıkar, bu handler onu hiç okumaz.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'exception-handling'
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
    ($$Bir alan hatasıyla sınıf seviyesi bir hatayı birleştirmek farklı bir istisna fırlattığı için hiçbiri bulunmaz$$, FALSE, 0),
    ($$Sınıf seviyesi kısıtlamalar önce kontrol edildiği için yalnızca @GecerliTarihAraligi hatası bulunur$$, FALSE, 1),
    ($$Yalnızca ad hatası -- @GecerliTarihAraligi hatası getGlobalErrors()'ta bir ObjectError olarak ortaya çıkar, bu handler onu hiç okumaz$$, TRUE, 2),
    ($$getFieldErrors() her doğrulama hatasını kapsadığı için her iki hata da bulunur$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-handling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: MULTIPLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-handling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Tek bir "errors" listesinin ötesinde bir ProblemDetail'e özel property'ler eklemenin meşru nedenleri arasında aşağıdakilerden hangileri yer alır? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Tek bir "errors" listesinin ötesinde bir ProblemDetail'e özel property'ler eklemenin meşru nedenleri arasında aşağıdakilerden hangileri yer alır? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Makine-okunabilir bir errorCode ve kaynak id/timestamp gibi ayrıntılar meşru özel property'lerdir; ProblemDetail özel property gerektirmez ve bunları eklemek RFC 7807'yi bozmaz.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'exception-handling'
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
    ($$RFC 7807 uyumluluğunu bozar, çünkü standart yalnızca sabit alanlara izin verir$$, FALSE, 0),
    ($$İstemcinin, okunabilir bir mesajın aksine güvenilir şekilde dallanabileceği makine-okunabilir bir errorCode eklemek$$, TRUE, 1),
    ($$Zorunludur -- ProblemDetail, en az bir özel property olmadan döndürülemez$$, FALSE, 2),
    ($$İlgili spesifik kaynak id'sini veya bir timestamp eklemek$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-handling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-handling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir istemci, başka bir hesap tarafından zaten alınmış bir e-posta adresiyle kayıt olmaya çalışıyor -- istek biçimsel olarak doğru, ama mevcut veriyle çelişiyor. Hangi durum kodu uygundur?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir istemci, başka bir hesap tarafından zaten alınmış bir e-posta adresiyle kayıt olmaya çalışıyor -- istek biçimsel olarak doğru, ama mevcut veriyle çelişiyor. Hangi durum kodu uygundur?$$,
           NULL, NULL,
           $$409 Conflict -- istek biçimsel olarak doğru ama mevcut durumla çelişiyor.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'exception-handling'
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
    ($$422 Unprocessable Entity$$, FALSE, 0),
    ($$404 Not Found$$, FALSE, 1),
    ($$409 Conflict$$, TRUE, 2),
    ($$400 Bad Request$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-handling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-handling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$ResponseEntityExceptionHandler'ı extend edip handleMethodArgumentNotValid(...) gibi tek bir metodu override etmenin amacı nedir?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$ResponseEntityExceptionHandler'ı extend edip handleMethodArgumentNotValid(...) gibi tek bir metodu override etmenin amacı nedir?$$,
           NULL, NULL,
           $$Tam olarak o durumu özelleştirir, zaten ele aldığı diğer her framework istisnası ise otomatik olarak makul varsayılan davranışını korur.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'exception-handling'
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
    ($$Tam olarak o durumu özelleştirir, zaten ele aldığı diğer her framework istisnası ise otomatik olarak makul varsayılan davranışını korur$$, TRUE, 0),
    ($$Uygulamanın kendi özel istisnaları için @RestControllerAdvice'ın yerini tamamen alır$$, FALSE, 1),
    ($$Tüm uygulama için Spring'in varsayılan istisna işlemesini devre dışı bırakır$$, FALSE, 2),
    ($$Yalnızca @Controller'lar için çalışır, @RestController'lar için asla çalışmaz$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-handling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-handling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri "güvenli" bir hata yanıtını tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri "güvenli" bir hata yanıtını tanımlar? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Tam istisnayı dahili olarak loglamak ve istemciye genel bir mesaj döndürmek güvenlidir; stack trace veya dahili host adı/yol sızdırmak değildir.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'exception-handling'
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
    ($$İstemcinin sorunu kendi başına debug edebilmesi için stack trace'i response body'sinde döndürmek$$, FALSE, 0),
    ($$Şeffaflık için response'a dahili bir veritabanı host adı ya da dosya yolu eklemek$$, FALSE, 1),
    ($$İstemciye e.getMessage() veya e.toString() yerine genel, sabit bir mesaj döndürmek$$, TRUE, 2),
    ($$Tam istisnayı (mesaj + stack trace) yalnızca ekibin görebileceği bir yerde, örneğin sunucu loglarında loglamak$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-handling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-handling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Her tür hata için 500 Internal Server Error döndürmek neden bir tasarım hatası kabul edilir?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Her tür hata için 500 Internal Server Error döndürmek neden bir tasarım hatası kabul edilir?$$,
           NULL, NULL,
           $$"Kötü veri gönderdin" ile "veritabanımız çöktü"yü birbirinden ayıramaz, istemciye tekrar denemenin işe yarayıp yaramayacağını bilme imkânı vermez.$$, $$claude-code@anthropic.com$$, '2026-09-03 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'exception-handling'
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
    ($$"Kötü veri gönderdin" ile "veritabanımız çöktü"yü birbirinden ayıramaz, istemciye tekrar denemenin işe yarayıp yaramayacağını bilme imkânı vermez$$, TRUE, 0),
    ($$500, modern API'lerde teknik olarak geçerli bir HTTP durum kodu değildir$$, FALSE, 1),
    ($$500 yanıtları üretilmesi her zaman 4xx yanıtlarından daha yavaştır$$, FALSE, 2),
    ($$Spring MVC, 500'ün yalnızca otomatik döndürülmesine izin verir, elle döndürülmesine izin vermez$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-handling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
