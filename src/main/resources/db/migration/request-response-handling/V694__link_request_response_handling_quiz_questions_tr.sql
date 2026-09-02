-- Promotion-style migration linking TR request-response-handling quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'request-response-handling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$@RequestBody ne yapar?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$@RequestBody ne yapar?$$,
           NULL, NULL,
           $$@RequestBody, HTTP isteğinin tüm gövdesini okuyup bir Java nesnesine dönüştürür.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'request-response-handling'
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
    ($$Yalnızca XML payload'larla çalışır, JSON ile asla çalışmaz$$, FALSE, 0),
    ($$Query string'den tek bir isimlendirilmiş değeri okur$$, FALSE, 1),
    ($$Yalnızca tek bir HTTP header'ı okur$$, FALSE, 2),
    ($$HTTP isteğinin tüm gövdesini okuyup bir Java nesnesine dönüştürür$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'request-response-handling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'request-response-handling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$@RequestBody'nin arkasında, bir JSON request body'sini bir Java nesnesine dönüştürmeyi gerçekte kim yapar?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$@RequestBody'nin arkasında, bir JSON request body'sini bir Java nesnesine dönüştürmeyi gerçekte kim yapar?$$,
           NULL, NULL,
           $$Bir HttpMessageConverter -- JSON için bu, Jackson'ın ObjectMapper'ına dayanır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'request-response-handling'
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
    ($$@PathVariable/@RequestParam için kullanılan aynı bileşen olan ConversionService$$, FALSE, 0),
    ($$ViewResolver$$, FALSE, 1),
    ($$Bir HttpMessageConverter -- JSON için bu, Jackson'ın ObjectMapper'ına dayanır$$, TRUE, 2),
    ($$@RequestBody'nin, başka hiçbir bileşene bağlı olmayan kendi yerleşik parser'ı vardır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'request-response-handling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'request-response-handling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$@RequestBody KullaniciOlusturRequest uç noktasına iki ayrı istek gönderiliyor: (1) {"ad": "Ayşe"} (eposta eksik), (2) {"ad": "Mehmet", "eposta": "m@x.com", "yas": 30} (bilinmeyen ekstra alan yas). Her durumda ne olur?$$
      AND code_snippet = $$record KullaniciOlusturRequest(String ad, String eposta) {}
// Jackson varsayılan ayarlarla kullanılıyor (@JsonIgnoreProperties yok)$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$@RequestBody KullaniciOlusturRequest uç noktasına iki ayrı istek gönderiliyor: (1) {"ad": "Ayşe"} (eposta eksik), (2) {"ad": "Mehmet", "eposta": "m@x.com", "yas": 30} (bilinmeyen ekstra alan yas). Her durumda ne olur?$$,
           $$record KullaniciOlusturRequest(String ad, String eposta) {}
// Jackson varsayılan ayarlarla kullanılıyor (@JsonIgnoreProperties yok)$$, $$java$$,
           $$Eksik bir alan sessizce null olarak atanır, hiç hata olmaz. Bilinmeyen bir alan, Jackson'ın varsayılanı tanımadığı alanları reddetmek olduğu için bir UnrecognizedPropertyException fırlatır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'request-response-handling'
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
    ($$İstek 1, eposta null olarak ayarlanarak kabul edilir; istek 2, bir UnrecognizedPropertyException ile reddedilir$$, TRUE, 0),
    ($$Her iki istek de hatasız kabul edilir$$, FALSE, 1),
    ($$Her iki istek de reddedilir$$, FALSE, 2),
    ($$İstek 1, eksik alan yüzünden reddedilir; istek 2 yas'ı yok sayarak kabul edilir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'request-response-handling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: MULTIPLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'request-response-handling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$ResponseEntity, sade bir dönüş değerinin sunduğunun ötesinde bir controller metoduna hangi yetenekleri kazandırır? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$ResponseEntity, sade bir dönüş değerinin sunduğunun ötesinde bir controller metoduna hangi yetenekleri kazandırır? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$ResponseEntity, durum kodu üzerinde tam kontrol verir ve Location gibi özel header'lar eklemeye izin verir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'request-response-handling'
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
    ($$Request body'yi ulaşmadan önce otomatik olarak doğrulamak$$, FALSE, 0),
    ($$Başka hiçbir yapılandırma olmadan JSON ile XML çıktısı arasında seçim yapmak$$, FALSE, 1),
    ($$Location gibi özel response header'ları eklemek$$, TRUE, 2),
    ($$404 veya 201 gibi keyfi bir HTTP durum kodu ayarlamak$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'request-response-handling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'request-response-handling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir istemci, hâlâ pozitif bakiyesi olan bir hesabı kapatmaya çalışıyor -- istek biçimsel olarak doğru, ama sunucunun mevcut durumuyla çelişiyor. Hangi durum kodu en uygunudur?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir istemci, hâlâ pozitif bakiyesi olan bir hesabı kapatmaya çalışıyor -- istek biçimsel olarak doğru, ama sunucunun mevcut durumuyla çelişiyor. Hangi durum kodu en uygunudur?$$,
           NULL, NULL,
           $$409 Conflict -- istek biçimsel olarak doğru ama mevcut sunucu durumuyla çelişiyor.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'request-response-handling'
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
    ($$409 Conflict$$, TRUE, 0),
    ($$400 Bad Request$$, FALSE, 1),
    ($$403 Forbidden$$, FALSE, 2),
    ($$422 Unprocessable Entity$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'request-response-handling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'request-response-handling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir controller metodunda, ne bir ResponseStatusException ne de herhangi bir @ExceptionHandler tarafından yakalanan bir ArithmeticException fırlatılıyor. İstemci ne alır?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bir controller metodunda, ne bir ResponseStatusException ne de herhangi bir @ExceptionHandler tarafından yakalanan bir ArithmeticException fırlatılıyor. İstemci ne alır?$$,
           NULL, NULL,
           $$İstisna ayrıntıları yalnızca sunucu loglarında kalarak genel bir 500 Internal Server Error döner, istemciye hiç sızmaz.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'request-response-handling'
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
    ($$Spring, yakalanmamış her istisnayı bir istemci hatası olarak ele aldığı için 400 Bad Request$$, FALSE, 0),
    ($$İstek yanıt almadan askıda kalır$$, FALSE, 1),
    ($$İstisna ayrıntıları yalnızca sunucu loglarında kalarak genel bir 500 Internal Server Error$$, TRUE, 2),
    ($$Ham stack trace'i düz metin olarak$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'request-response-handling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: CODE_OUTPUT)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'request-response-handling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir istemci GET /urunler/1 isteğini Accept: text/csv header'ıyla gönderiyor. Sonuç nedir?$$
      AND code_snippet = $$@GetMapping(path = "/urunler/1", produces = "application/json")
public String jsonOlarak() { return "{...}"; }

@GetMapping(path = "/urunler/1", produces = "application/xml")
public String xmlOlarak() { return "<urun>...</urun>"; }$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bir istemci GET /urunler/1 isteğini Accept: text/csv header'ıyla gönderiyor. Sonuç nedir?$$,
           $$@GetMapping(path = "/urunler/1", produces = "application/json")
public String jsonOlarak() { return "{...}"; }

@GetMapping(path = "/urunler/1", produces = "application/xml")
public String xmlOlarak() { return "<urun>...</urun>"; }$$, $$java$$,
           $$Path mevcut ama istenen Accept ile eşleşen bir produces değeri olmadığı için 406 Not Acceptable döner.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'request-response-handling'
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
    ($$Path mevcut ama istenen Accept ile eşleşen bir produces değeri olmadığı için 406 Not Acceptable$$, TRUE, 0),
    ($$JSON varsayılan geri dönüş olduğu için jsonOlarak() çalışır$$, FALSE, 1),
    ($$Path eksik kabul edildiği için 404 Not Found$$, FALSE, 2),
    ($$415 Unsupported Media Type$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'request-response-handling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
