-- Promotion-style migration linking TR path-variables-request-parameters quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'path-variables-request-parameters')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$@GetMapping("/urunler/{id}") ve getUrun(@PathVariable Long id) içinde, id değerini nasıl alır?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$@GetMapping("/urunler/{id}") ve getUrun(@PathVariable Long id) içinde, id değerini nasıl alır?$$,
           NULL, NULL,
           $${id} placeholder'ıyla isim eşleşmesi yapılarak bağlanır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'path-variables-request-parameters'
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
    ($$id adında bir query parametresi de gönderilmedikçe varsayılan olarak null olur$$, FALSE, 0),
    ($$Pozisyona göre bağlanır, her zaman ilk path segmenti olur$$, FALSE, 1),
    ($$Her zaman açıkça @PathVariable("id") yazılması gerekir$$, FALSE, 2),
    ($${id} placeholder'ıyla isim eşleşmesi yapılarak bağlanır$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'path-variables-request-parameters'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'path-variables-request-parameters')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$GET /makaleler/spring-mvc isteği gönderiliyor. Metot ne döndürür?$$
      AND code_snippet = $$@GetMapping("/makaleler/{makaleSlug}")
public String makaleGetir(@PathVariable("makaleSlug") String slug) {
    return "Makale: " + slug;
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$GET /makaleler/spring-mvc isteği gönderiliyor. Metot ne döndürür?$$,
           $$@GetMapping("/makaleler/{makaleSlug}")
public String makaleGetir(@PathVariable("makaleSlug") String slug) {
    return "Makale: " + slug;
}$$, $$java$$,
           $$@PathVariable("makaleSlug"), slug'ı {makaleSlug} placeholder'ına açıkça bağlar, bu yüzden slug "spring-mvc" değerini alır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'path-variables-request-parameters'
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
    ($$slug, makaleSlug ile eşleşmediği için 400 Bad Request$$, FALSE, 0),
    ($$Parametre adı placeholder'dan farklı olduğu için NullPointerException$$, FALSE, 1),
    ($$Makale: spring-mvc$$, TRUE, 2),
    ($$Makale: makaleSlug$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'path-variables-request-parameters'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'path-variables-request-parameters')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste öğretilen ayrıma göre, aşağıdakilerden hangisi bir query parametresi yerine path variable olmalıdır?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derste öğretilen ayrıma göre, aşağıdakilerden hangisi bir query parametresi yerine path variable olmalıdır?$$,
           NULL, NULL,
           $$Hangi belirli makalenin getirileceğini belirten bir id zorunludur -- bu istek onsuz anlamsızdır, bu yüzden path'te olmalıdır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'path-variables-request-parameters'
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
    ($$Hangi belirli makalenin getirileceğini belirten bir id -- bu istek onsuz anlamsızdır$$, TRUE, 0),
    ($$Bir ürün listesini daraltan kategori filtresi$$, FALSE, 1),
    ($$Sayfalama için bir sayfa numarası$$, FALSE, 2),
    ($$Sonuçları sıralamak için bir sirala alan adı$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'path-variables-request-parameters'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'path-variables-request-parameters')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$İstemci göndermezse, @RequestParam varsayılan olarak zorunlu mudur, opsiyonel midir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$İstemci göndermezse, @RequestParam varsayılan olarak zorunlu mudur, opsiyonel midir?$$,
           NULL, NULL,
           $$@RequestParam varsayılan olarak zorunludur -- eksikse istemci 400 Bad Request alır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'path-variables-request-parameters'
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
    ($$Kullanılan HTTP metoduna bağlıdır$$, FALSE, 0),
    ($$Açıkça required = true yazılmadıkça her zaman opsiyoneldir$$, FALSE, 1),
    ($$Varsayılan olarak zorunludur -- eksikse istemci 400 Bad Request alır$$, TRUE, 2),
    ($$@PathVariable gibi, varsayılan olarak opsiyoneldir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'path-variables-request-parameters'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'path-variables-request-parameters')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir metotta @RequestParam(required = false) List<String> etiket parametresi var. Aşağıdaki isteklerden hangisi etiket'i ["java", "spring"] ile doğru şekilde doldurur?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir metotta @RequestParam(required = false) List<String> etiket parametresi var. Aşağıdaki isteklerden hangisi etiket'i ["java", "spring"] ile doğru şekilde doldurur?$$,
           NULL, NULL,
           $$Spring'in List bağlaması, aynı key'in tekrarlanmasını bekler (?etiket=java&etiket=spring), tek bir virgülle ayrılmış değeri değil, ve hiç gönderilmemesini de değil.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'path-variables-request-parameters'
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
    ($$Spring'in 400 Bad Request ile reddettiği hatalı bir istek$$, FALSE, 0),
    ($$?etiket=java&etiket=spring$$, TRUE, 1),
    ($$?etiket=java,spring$$, FALSE, 2),
    ($$Hiç etiket parametresi göndermemek -- etiket otomatik olarak ["java", "spring"] olur$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'path-variables-request-parameters'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'path-variables-request-parameters')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$@RequestParam'ı her parametreyi ayrı ayrı tanımlamak yerine bir Map<String, String>'e bağlamanın temel dezavantajı nedir?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$@RequestParam'ı her parametreyi ayrı ayrı tanımlamak yerine bir Map<String, String>'e bağlamanın temel dezavantajı nedir?$$,
           NULL, NULL,
           $$İsimden bağımsız her parametreyi yakalar ama derleme zamanı tip güvenliğini kaybettirir -- her şey String olarak gelir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'path-variables-request-parameters'
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
    ($$Özel bir ConversionService kaydedilmesini gerektirir$$, FALSE, 0),
    ($$Her değeri otomatik olarak doğru Java tipine dönüştürür$$, FALSE, 1),
    ($$İsimden bağımsız her parametreyi yakalar ama derleme zamanı tip güvenliğini kaybettirir -- her şey String olarak gelir$$, TRUE, 2),
    ($$Yalnızca POST istekleriyle çalışır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'path-variables-request-parameters'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: CODE_OUTPUT)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'path-variables-request-parameters')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir istemci GET /urunler/abc gönderiyor. Ne olur?$$
      AND code_snippet = $$@GetMapping("/urunler/{id}")
public String urunGetir(@PathVariable Long id) {
    return "Urun: " + id;
}$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bir istemci GET /urunler/abc gönderiyor. Ne olur?$$,
           $$@GetMapping("/urunler/{id}")
public String urunGetir(@PathVariable Long id) {
    return "Urun: " + id;
}$$, $$java$$,
           $$Tip dönüşümü, controller metodu hiç çağrılmadan önce DispatcherServlet katmanında başarısız olur, sonuç 400 Bad Request olur.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'path-variables-request-parameters'
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
    ($$İstek urunGetir'e hiç ulaşmaz -- tip dönüşümü DispatcherServlet katmanında başarısız olur ve sonuç 400 Bad Request olur$$, TRUE, 0),
    ($$id, null olarak ayarlanır ve metot normal şekilde çalışır$$, FALSE, 1),
    ($$Metot çalışır ve gövdesinde bir NumberFormatException fırlatır$$, FALSE, 2),
    ($$id, varsayılan geri dönüş değeri olarak 0'a ayarlanır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'path-variables-request-parameters'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
