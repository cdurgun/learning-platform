-- Promotion-style migration linking TR spring-mvc-fundamentals quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-fundamentals')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Spring MVC'de gelen her HTTP isteğini ilk karşılayıp uygun controller metoduna yönlendiren bileşen hangisidir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Spring MVC'de gelen her HTTP isteğini ilk karşılayıp uygun controller metoduna yönlendiren bileşen hangisidir?$$,
           NULL, NULL,
           $$DispatcherServlet, front controller'dır -- her istek önce ondan geçer ve HandlerMapping/HandlerAdapter aracılığıyla doğru controller metoduna yönlendirilir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-fundamentals'
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
    ($$ConversionService$$, FALSE, 0),
    ($$DispatcherServlet$$, TRUE, 1),
    ($$ViewResolver$$, FALSE, 2),
    ($$HandlerAdapter$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-fundamentals')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$@Controller ile işaretlenmiş bir sınıfta, bir handler metodunun döndürdüğü String değeri neyi temsil eder?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$@Controller ile işaretlenmiş bir sınıfta, bir handler metodunun döndürdüğü String değeri neyi temsil eder?$$,
           NULL, NULL,
           $$Döndürülen String, ViewResolver'a iletilen mantıksal view adıdır -- ham HTML ya da doğrudan response body değildir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-fundamentals'
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
    ($$HTTP durum mesajı$$, FALSE, 0),
    ($$Doğrudan response body$$, FALSE, 1),
    ($$ViewResolver'a iletilen mantıksal view adı$$, TRUE, 2),
    ($$Tarayıcıya gönderilen ham HTML$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: MULTIPLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-fundamentals')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$@RestController ile ilgili aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$@RestController ile ilgili aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$@RestController, @Controller ile @ResponseBody'yi birleştiren bir meta-annotation'dır -- dönüş değeri, ViewResolver hiç devreye girmeden doğrudan response body olur.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-fundamentals'
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
    ($$Bir metodun dönüş değeri, ViewResolver hiç devreye girmeden doğrudan response body olur$$, TRUE, 0),
    ($$@Controller ile @ResponseBody'yi birleştiren bir meta-annotation'dır$$, TRUE, 1),
    ($$JSON serileştirmeyi varsayılan olarak devre dışı bırakır$$, FALSE, 2),
    ($$Aynı sınıfta @Controller tarzı ve @RestController tarzı metotları birleştirmek teknik olarak imkânsızdır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-fundamentals')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Spring MVC'de bir Model nesnesi ne zaman oluşturulup doldurulur?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Spring MVC'de bir Model nesnesi ne zaman oluşturulup doldurulur?$$,
           NULL, NULL,
           $$DispatcherServlet, her istek için yeni bir Model oluşturup handler metoduna geçirir -- asla paylaşılan bir singleton değildir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-fundamentals'
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
    ($$Yalnızca bir @RestController kullanıldığında oluşturulur$$, FALSE, 0),
    ($$Her controller metodunun içinde elle örneklenmelidir$$, FALSE, 1),
    ($$DispatcherServlet her istek için yeni bir tane oluşturup handler metoduna geçirir$$, TRUE, 2),
    ($$Tüm istekler arasında paylaşılan bir singleton'dır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-fundamentals')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$HandlerMapping ile HandlerAdapter arasındaki iş bölümü nedir?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$HandlerMapping ile HandlerAdapter arasındaki iş bölümü nedir?$$,
           NULL, NULL,
           $$HandlerMapping isteği hangi metodun karşılayacağını bulur; HandlerAdapter doğru parametrelerle onu çağırır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-fundamentals'
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
    ($$HandlerMapping isteği hangi metodun karşılayacağını bulur, HandlerAdapter doğru parametrelerle onu çağırır$$, TRUE, 0),
    ($$HandlerMapping metodu çağırır, HandlerAdapter onu bulur$$, FALSE, 1),
    ($$İkisi de tam olarak aynı işi tekrar yapar$$, FALSE, 2),
    ($$HandlerAdapter yalnızca @RestController'lar için, HandlerMapping yalnızca @Controller'lar için çalışır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-fundamentals')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$GET /urun isteği yapıldığında ne olur?$$
      AND code_snippet = $$@Controller
public class UrunController {
    @GetMapping("/urun")
    public String urun(Model model) {
        model.addAttribute("ad", "Klavye");
        return "UrunDetay";
    }
}
// templates/urundetay.html (küçük harflerle) diye bir dosya var,
// case-sensitive bir dosya sisteminde.$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$GET /urun isteği yapıldığında ne olur?$$,
           $$@Controller
public class UrunController {
    @GetMapping("/urun")
    public String urun(Model model) {
        model.addAttribute("ad", "Klavye");
        return "UrunDetay";
    }
}
// templates/urundetay.html (küçük harflerle) diye bir dosya var,
// case-sensitive bir dosya sisteminde.$$, $$java$$,
           $$ViewResolver, büyük/küçük harfe duyarsız değil tam string eşleşmesi arar ("UrunDetay" -> UrunDetay.html), bu yüzden templates/urundetay.html'i bulamaz.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-fundamentals'
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
    ($$Response body'si doğrudan "UrunDetay" metni olur$$, FALSE, 0),
    ($$model hiç başlatılmadığı için NullPointerException fırlatılır$$, FALSE, 1),
    ($$ViewResolver eşleşen bir şablon bulamaz, çünkü tam string eşleşmesi arar (UrunDetay.html değil urundetay.html)$$, TRUE, 2),
    ($$Spring view adlarını küçük harfe çevirdiği için urundetay.html başarıyla render edilir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-fundamentals')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Spring MVC ile Spring WebFlux karşılaştırmasıyla ilgili aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Spring MVC ile Spring WebFlux karşılaştırmasıyla ilgili aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Spring MVC bloklayıcıdır (Servlet API tabanlı); Spring WebFlux, varsayılan olarak Reactor+Netty üzerinde reaktif/bloklayıcı olmayandır. Bu proje, istekleri klasik kısa ömürlü döngüler olduğu için -web kullanır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-fundamentals'
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
    ($$Spring WebFlux, Servlet API'nin bloklayıcı olmayan bir uzantısıdır, farklı bir alt yapı kullanmaz$$, FALSE, 0),
    ($$Spring MVC, Servlet API üzerine kuruludur ve bloklayıcıdır -- her istek tamamlanana kadar bir thread'i işgal eder$$, TRUE, 1),
    ($$Spring MVC ile Spring WebFlux, aynı starter'ı paylaştığı için her zaman birlikte otomatik çalışır$$, FALSE, 2),
    ($$Bu proje, istekleri klasik kısa ömürlü request/response döngüleri (DB sorgusu + render) olduğu için spring-boot-starter-web kullanır$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-fundamentals'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
