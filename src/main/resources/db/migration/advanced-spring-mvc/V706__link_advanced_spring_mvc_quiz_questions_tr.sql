-- Promotion-style migration linking TR advanced-spring-mvc quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'advanced-spring-mvc')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir Filter ile bir HandlerInterceptor arasındaki temel mimari fark nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir Filter ile bir HandlerInterceptor arasındaki temel mimari fark nedir?$$,
           NULL, NULL,
           $$Filter, Servlet API'nin bir parçasıdır ve DispatcherServlet'ten önce her isteği görür; HandlerInterceptor yalnızca DispatcherServlet'in bir handler'a eşlediği istekleri görür.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'advanced-spring-mvc'
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
    ($$Filter, Servlet API'nin bir parçasıdır ve DispatcherServlet'ten önce her isteği görür (statik dosyalar veya 404'ler dahil); HandlerInterceptor yalnızca DispatcherServlet'in bir handler'a eşlediği istekleri görür$$, TRUE, 0),
    ($$Tamamen aynı katmanda, hiçbir fark olmadan çalışırlar$$, FALSE, 1),
    ($$HandlerInterceptor, DispatcherServlet'ten önce çalışır, Filter sonra çalışır$$, FALSE, 2),
    ($$Filter yalnızca @RestController'larla çalışır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'advanced-spring-mvc'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: MULTIPLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'advanced-spring-mvc')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$HandlerInterceptor'ın üç callback'iyle ilgili aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$HandlerInterceptor'ın üç callback'iyle ilgili aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$preHandle, handler'dan önce çalışır, false döndürmek zinciri durdurur; afterCompletion istisna olsa bile çalışır; postHandle, handler başarılı olduktan sonra ama view render edilmeden önce çalışır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'advanced-spring-mvc'
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
    ($$postHandle, handler metodu çağrılmadan önce çalışır$$, FALSE, 0),
    ($$afterCompletion, handler bir istisna fırlatmış olsa bile, view render edildikten sonra çalışır$$, TRUE, 1),
    ($$postHandle, handler başarıyla tamamlandıktan sonra ama view render edilmeden önce çalışır$$, TRUE, 2),
    ($$preHandle, handler metodundan önce çalışır; false döndürmek zinciri hemen durdurur$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'advanced-spring-mvc'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'advanced-spring-mvc')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$DispatcherServlet'in tüm çağrısını saran bir Filter ve eşleşen handler'a kayıtlı bir HandlerInterceptor verildiğinde, bir isteğin "sonra" fazı için doğru iç içe geçme sırası nedir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$DispatcherServlet'in tüm çağrısını saran bir Filter ve eşleşen handler'a kayıtlı bir HandlerInterceptor verildiğinde, bir isteğin "sonra" fazı için doğru iç içe geçme sırası nedir?$$,
           NULL, NULL,
           $$Interceptor'ın afterCompletion'ı, view render edildikten sonra ama yine de filter'ın kendi "sonra" kodundan önce çalışır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'advanced-spring-mvc'
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
    ($$Interceptor'ın afterCompletion'ı, view render edildikten sonra ama yine de filter'ın kendi "sonra" kodundan önce çalışır$$, TRUE, 0),
    ($$Önce filter'ın sonra-kodu çalışır, sonra interceptor'ın afterCompletion'ı$$, FALSE, 1),
    ($$İkisi de aynı anda, paralel olarak çalışır$$, FALSE, 2),
    ($$Bir Filter de kayıtlıysa afterCompletion hiç çalışmaz$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'advanced-spring-mvc'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'advanced-spring-mvc')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Her iki interceptor'ın da preHandle'ı true döndürüyor. postHandle çağrıları hangi sırada çalışır?$$
      AND code_snippet = $$// Şu sırayla kayıtlı: önce AuthInterceptor, sonra LoggingInterceptor
registry.addInterceptor(authInterceptor);
registry.addInterceptor(loggingInterceptor);$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Her iki interceptor'ın da preHandle'ı true döndürüyor. postHandle çağrıları hangi sırada çalışır?$$,
           $$// Şu sırayla kayıtlı: önce AuthInterceptor, sonra LoggingInterceptor
registry.addInterceptor(authInterceptor);
registry.addInterceptor(loggingInterceptor);$$, $$java$$,
           $$preHandle kayıt sırasıyla çalışır; postHandle/afterCompletion ters sırayla çalışır -- bu yüzden önce LoggingInterceptor'ın postHandle'ı, sonra AuthInterceptor'ınki çalışır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'advanced-spring-mvc'
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
    ($$Spring herhangi bir sıra garanti etmediği için rastgele bir sıra$$, FALSE, 0),
    ($$İkisi de aynı anda çalışır$$, FALSE, 1),
    ($$LoggingInterceptor, sonra AuthInterceptor (kayıt sırasının tersi)$$, TRUE, 2),
    ($$AuthInterceptor, sonra LoggingInterceptor (kayıt sırasıyla aynı)$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'advanced-spring-mvc'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'advanced-spring-mvc')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$X-Api-Key header'ı olmayan bir istek gönderiliyor. İstemci gerçekte hangi durum kodunu alır?$$
      AND code_snippet = $$@Override
public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
    if (request.getHeader("X-Api-Key") == null) {
        return false; // durum kodu ayarlanmadı!
    }
    return true;
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$X-Api-Key header'ı olmayan bir istek gönderiliyor. İstemci gerçekte hangi durum kodunu alır?$$,
           $$@Override
public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
    if (request.getHeader("X-Api-Key") == null) {
        return false; // durum kodu ayarlanmadı!
    }
    return true;
}$$, $$java$$,
           $$Zincir durur, ama response.setStatus(...) hiç çağrılmadığı için istemci varsayılan durum olan 200'ü alır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'advanced-spring-mvc'
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
    ($$200 OK -- zincir durur, ama response.setStatus(...) hiç çağrılmadığı için istemci varsayılan durumu alır$$, TRUE, 0),
    ($$Semantik olarak doğru kod olduğu için 401 Unauthorized$$, FALSE, 1),
    ($$403 Forbidden$$, FALSE, 2),
    ($$İstek yanıt almadan süresiz olarak askıda kalır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'advanced-spring-mvc'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'advanced-spring-mvc')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$"Basit olmayan" (örneğin özel bir header taşıyan) bir cross-origin istek için, tarayıcı gerçek isteği göndermeden önce ne yapar?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$"Basit olmayan" (örneğin özel bir header taşıyan) bir cross-origin istek için, tarayıcı gerçek isteği göndermeden önce ne yapar?$$,
           NULL, NULL,
           $$Önce, sunucudan Access-Control-Allow-* header'ları aracılığıyla izin isteyen bir preflight OPTIONS isteği gönderir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'advanced-spring-mvc'
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
    ($$Herhangi bir ağ etkinliği olmadan isteği sessizce engeller$$, FALSE, 0),
    ($$İsteği otomatik olarak "basit" bir GET'e düşürür$$, FALSE, 1),
    ($$Önce, sunucudan Access-Control-Allow-* header'ları aracılığıyla izin isteyen bir preflight OPTIONS isteği gönderir$$, TRUE, 2),
    ($$Gerçek isteği doğrudan gönderir, header'ları yalnızca response'ta kontrol eder$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'advanced-spring-mvc'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'advanced-spring-mvc')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir istek, her biri 2MB olan üç dosya yüklüyor; max-file-size 5MB, max-request-size de 5MB olarak ayarlanmış. Ne olur?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bir istek, her biri 2MB olan üç dosya yüklüyor; max-file-size 5MB, max-request-size de 5MB olarak ayarlanmış. Ne olur?$$,
           NULL, NULL,
           $$İstek reddedilir, çünkü toplam (6MB) max-request-size'ı aşıyor, her bir dosya tek tek max-file-size'ın altında olsa bile -- bunlar iki ayrı sınırdır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'advanced-spring-mvc'
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
    ($$İstek reddedilir, çünkü toplam (6MB) max-request-size'ı aşıyor, her bir dosya tek tek max-file-size'ın altında olsa bile$$, TRUE, 0),
    ($$Her biri tek tek max-file-size'ın altında olduğu için üç dosya da kabul edilir$$, FALSE, 1),
    ($$Yalnızca ilk iki dosya kabul edilir, üçüncüsü sessizce düşürülür$$, FALSE, 2),
    ($$max-file-size zaten ayarlıysa max-request-size yok sayılır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'advanced-spring-mvc'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
