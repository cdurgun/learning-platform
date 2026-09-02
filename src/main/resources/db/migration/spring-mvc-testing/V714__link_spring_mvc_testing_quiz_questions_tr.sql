-- Promotion-style migration linking TR spring-mvc-testing quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-testing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$@WebMvcTest neyi yükler ve bilinçli olarak neyi hariç tutar?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$@WebMvcTest neyi yükler ve bilinçli olarak neyi hariç tutar?$$,
           NULL, NULL,
           $$DispatcherServlet'i, message converter'ları ve verilen controller'ları yükler -- ama @Service/@Repository bean'lerini hariç tutar.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-testing'
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
    ($$DispatcherServlet'i, message converter'ları ve verilen controller'ları yükler -- ama @Service/@Repository bean'lerini hariç tutar$$, TRUE, 0),
    ($$Gerçek bir veritabanı bağlantısı dahil, tüm uygulamayı yükler$$, FALSE, 1),
    ($$Yalnızca @Service katmanını yükler, tüm web bileşenlerini hariç tutar$$, FALSE, 2),
    ($$@MockitoBean eklenene kadar hiçbir şey yüklemez$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-testing'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-testing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$MockMvcBuilders.standaloneSetup(...) ile autowired bir MockMvc içeren @WebMvcTest arasındaki temel fark nedir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$MockMvcBuilders.standaloneSetup(...) ile autowired bir MockMvc içeren @WebMvcTest arasındaki temel fark nedir?$$,
           NULL, NULL,
           $$standaloneSetup(...), controller'ları bir Spring ApplicationContext'i olmadan elle bağlar; @WebMvcTest ise gerçek (daraltılmış) bir Spring context'i yükler.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-testing'
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
    ($$standaloneSetup(...) gerçek bir veritabanı bağlantısı gerektirir, @WebMvcTest gerektirmez$$, FALSE, 0),
    ($$@WebMvcTest, @MockitoBean ile birlikte kullanılamaz$$, FALSE, 1),
    ($$standaloneSetup(...), controller'ları bir Spring ApplicationContext'i olmadan elle bağlar; @WebMvcTest ise gerçek (daraltılmış) bir Spring context'i yükler$$, TRUE, 2),
    ($$Her açıdan işlevsel olarak birebir aynıdırlar$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-testing'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-testing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$@MockitoBean ne yapar ve bu projenin dersi @MockBean kullanmayı neden bıraktı?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$@MockitoBean ne yapar ve bu projenin dersi @MockBean kullanmayı neden bıraktı?$$,
           NULL, NULL,
           $$@MockitoBean, test context'ine bir Mockito mock ekler (veya gerçek bir bean'i değiştirir); @MockBean Spring Boot 3.4'te kullanımdan kaldırıldı ve bu projenin çalıştırdığı 4.1.0'da kaldırıldı.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-testing'
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
    ($$@MockitoBean, @MockBean'in yalnızca derleme zamanı için daha katı bir sürümüdür, çalışma zamanı davranışı yoktur$$, FALSE, 0),
    ($$@MockBean hâlâ önerilen annotation'dır; @MockitoBean yalnızca @SpringBootTest içindir$$, FALSE, 1),
    ($$@MockitoBean, ayrı bir yapılandırma sınıfında elle bean kaydı gerektirir$$, FALSE, 2),
    ($$@MockitoBean, test context'ine bir Mockito mock ekler (veya gerçek bir bean'i değiştirir); @MockBean Spring Boot 3.4'te kullanımdan kaldırıldı ve bu projenin çalıştırdığı 4.1.0'da kaldırıldı$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-testing'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-testing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu test çalıştığında ne olur?$$
      AND code_snippet = $$mockMvc.perform(get("/api/konular"))
    .andExpect(status().isOk())
    .andExpect(jsonPath("$.baslik").value("Kayıtlar"));
// Gerçek response body'si: [{"baslik": "Kayıtlar"}, {"baslik": "Generics"}]$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu test çalıştığında ne olur?$$,
           $$mockMvc.perform(get("/api/konular"))
    .andExpect(status().isOk())
    .andExpect(jsonPath("$.baslik").value("Kayıtlar"));
// Gerçek response body'si: [{"baslik": "Kayıtlar"}, {"baslik": "Generics"}]$$, $$java$$,
           $$Başarısız olur, çünkü response bir JSON dizisidir -- doğru ifade $.baslik değil, $[0].baslik olmalıdır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-testing'
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
    ($$Assertion çalışmadan önce bir NullPointerException fırlatır$$, FALSE, 0),
    ($$Yalnızca dizi tam olarak bir eleman içeriyorsa geçer$$, FALSE, 1),
    ($$Başarısız olur, çünkü response bir JSON dizisidir -- doğru ifade $.baslik değil, $[0].baslik olmalıdır$$, TRUE, 2),
    ($$"Kayıtlar" response'ta gerçekten mevcut olduğu için geçer$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-testing'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-testing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir test, .contentType(...) çağırmadan mockMvc.perform(post("/kullanicilar").content(requestJson)) gönderiyor. Aşağıdakilerden hangileri bunun sonuçlarıdır? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir test, .contentType(...) çağırmadan mockMvc.perform(post("/kullanicilar").content(requestJson)) gönderiyor. Aşağıdakilerden hangileri bunun sonuçlarıdır? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$contentType(...) olmadan, Spring hangi HttpMessageConverter'ın kullanılacağını bilemeyebilir ve istek 415 Unsupported Media Type ile reddedilebilir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-testing'
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
    ($$İstek, 415 Unsupported Media Type ile reddedilebilir$$, TRUE, 0),
    ($$Spring, gövdeyi ayrıştırmak için hangi HttpMessageConverter'ın kullanılacağını belirleyemeyebilir$$, TRUE, 1),
    ($$Tek başına content() yeterli olduğu için test her koşulda geçer$$, FALSE, 2),
    ($$contentType(...) yalnızca GET istekleri için gereklidir, POST için asla gerekmez$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-testing'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-testing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu test çalıştığında gerçekte ne olur?$$
      AND code_snippet = $$mockMvc = MockMvcBuilders.standaloneSetup(new UrunController()).build();
// .setControllerAdvice(...) çağrısı yok

// Test, doğrulamayı başarısız kılan geçersiz bir @Valid @RequestBody gönderiyor
mockMvc.perform(post("/urunler").content(gecersizJson).contentType(APPLICATION_JSON))
    .andExpect(status().isBadRequest());$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu test çalıştığında gerçekte ne olur?$$,
           $$mockMvc = MockMvcBuilders.standaloneSetup(new UrunController()).build();
// .setControllerAdvice(...) çağrısı yok

// Test, doğrulamayı başarısız kılan geçersiz bir @Valid @RequestBody gönderiyor
mockMvc.perform(post("/urunler").content(gecersizJson).contentType(APPLICATION_JSON))
    .andExpect(status().isBadRequest());$$, $$java$$,
           $$Validator varsayılan olarak kuruludur ve gerçekten bir MethodArgumentNotValidException fırlatır, ama hiçbir advice bunu dönüştürmediği için test, beklenen 400 yerine beklenmeyen bir 500 ile karşılaşır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-testing'
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
    ($$Hiçbir advice kaydedilmediği için @Valid tamamen sessizce atlanır, bu yüzden test her zaman 200 OK ile başarısız olur$$, FALSE, 0),
    ($$standaloneSetup'ın bir advice geçirilmesini gerektirdiği için bir derleme zamanı hatası fırlatır$$, FALSE, 1),
    ($$Validator varsayılan olarak kuruludur ve gerçekten bir MethodArgumentNotValidException fırlatır, ama hiçbir advice bunu dönüştürmediği için test, beklenen 400 yerine beklenmeyen bir 500 ile karşılaşır$$, TRUE, 2),
    ($$standaloneSetup, otomatik olarak bir ProblemDetail üreten advice eklediği için geçer$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-testing'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-testing')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$MockMultipartFile nedir ve ne zaman kullanılır?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$MockMultipartFile nedir ve ne zaman kullanılır?$$,
           NULL, NULL,
           $$multipart/form-data uç noktalarını test etmek için sahte bir dosya oluşturmakta kullanılan, multipart(...) request builder'ıyla eşleştirilen gerçek bir spring-test (test-scope) sınıfı.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-testing'
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
    ($$multipart/form-data uç noktalarını test etmek için sahte bir dosya oluşturmakta kullanılan, multipart(...) request builder'ıyla eşleştirilen gerçek bir spring-test (test-scope) sınıfı$$, TRUE, 0),
    ($$Yavaş ağ yüklemelerini simüle etmek için kullanılan bir production-scope sınıfı$$, FALSE, 1),
    ($$@MockitoBean ile değiştirilmiş, kullanımdan kaldırılmış bir sınıf$$, FALSE, 2),
    ($$Yalnızca @SpringBootTest ile birlikte kullanılabilen, standaloneSetup(...) ile asla kullanılamayan bir sınıf$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-testing'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
