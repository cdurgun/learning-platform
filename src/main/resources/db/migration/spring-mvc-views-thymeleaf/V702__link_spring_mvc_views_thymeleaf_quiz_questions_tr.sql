-- Promotion-style migration linking TR spring-mvc-views-thymeleaf quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-views-thymeleaf')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Thymeleaf'in "natural templating" felsefesini JSP veya Mustache gibi motorlardan ayıran nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Thymeleaf'in "natural templating" felsefesini JSP veya Mustache gibi motorlardan ayıran nedir?$$,
           NULL, NULL,
           $$Bir Thymeleaf şablonu, direktifleri sıradan HTML attribute'ları olduğu için tarayıcıda doğrudan açılabilen geçerli bir HTML'dir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-views-thymeleaf'
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
    ($$Bir Thymeleaf şablonu, direktifleri sıradan HTML attribute'ları olduğu için tarayıcıda doğrudan açılabilen geçerli bir HTML'dir$$, TRUE, 0),
    ($$Yalnızca Spring Boot ile çalışır, sade Spring MVC ile çalışmaz$$, FALSE, 1),
    ($$Şablonları önceden Java bytecode'una derler$$, FALSE, 2),
    ($$Koşullu ifadeleri veya döngüleri desteklemez$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-views-thymeleaf'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-views-thymeleaf')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Konu bir Java record'u olduğuna göre (erişimcisi getBaslik() tarzı bir bean getter'ı değil, gerçek bir baslik() metodudur), bu tam Thymeleaf ifadesindeki risk nedir?$$
      AND code_snippet = $$record Konu(String slug, String baslik) {}
// model.addAttribute("konu", new Konu("kayitlar", "Kayıtlar"));

<!-- şablon -->
<h1 th:text="${konu.baslik}">placeholder</h1>$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Konu bir Java record'u olduğuna göre (erişimcisi getBaslik() tarzı bir bean getter'ı değil, gerçek bir baslik() metodudur), bu tam Thymeleaf ifadesindeki risk nedir?$$,
           $$record Konu(String slug, String baslik) {}
// model.addAttribute("konu", new Konu("kayitlar", "Kayıtlar"));

<!-- şablon -->
<h1 th:text="${konu.baslik}">placeholder</h1>$$, $$html$$,
           $$${konu.baslik} (parantezsiz), ${konu.baslik()}'in yaptığı gibi bir record'un gerçek erişimci metodunu doğru şekilde çözemez -- sessizce başarısız olabilir ya da null/hata döndürebilir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-views-thymeleaf'
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
    ($$Thymeleaf ifadeleri derleme zamanında kontrol edildiği için derleme zamanı hatası fırlatır$$, FALSE, 0),
    ($$Spring her record için otomatik bir getter ürettiğinden ${konu.getBaslik()} ile aynı şekilde çalışır$$, FALSE, 1),
    ($$Sessizce başarısız olabilir ya da null/hata döndürebilir, çünkü ${konu.baslik} (parantezsiz), ${konu.baslik()}'in yaptığı gibi bir record'un gerçek erişimci metodunu doğru şekilde çözemez$$, TRUE, 2),
    ($$Mükemmel çalışır -- Thymeleaf record'lar için parantezleri her zaman otomatik ekler$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-views-thymeleaf'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-views-thymeleaf')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$@{/topics/{slug}(slug=${slug}, lang=${lang})} içinde, {slug} path'te zaten bir placeholder ise, slug=${slug} ve lang=${lang} kısımlarına ne olur?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$@{/topics/{slug}(slug=${slug}, lang=${lang})} içinde, {slug} path'te zaten bir placeholder ise, slug=${slug} ve lang=${lang} kısımlarına ne olur?$$,
           NULL, NULL,
           $$slug=${slug}, mevcut {slug} path placeholder'ını doldurur; lang=${lang}'ın eşleşen bir placeholder'ı olmadığı için query string parametresi olur.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-views-thymeleaf'
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
    ($$slug=${slug}, mevcut {slug} path placeholder'ını doldurur; lang=${lang}'ın eşleşen bir placeholder'ı olmadığı için query string parametresi olur$$, TRUE, 0),
    ($$İkisi de otomatik olarak query string parametresi olur$$, FALSE, 1),
    ($${slug} zaten dolu olduğu için ikisi de yok sayılır$$, FALSE, 2),
    ($$Bir parametre bir path placeholder'ıyla aynı adı paylaşamayacağı için derleme zamanı hatası oluşur$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-views-thymeleaf'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-views-thymeleaf')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$th:text ile th:utext arasındaki temel güvenlik farkı nedir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$th:text ile th:utext arasındaki temel güvenlik farkı nedir?$$,
           NULL, NULL,
           $$th:text her zaman HTML özel karakterlerini escape eder (XSS'e karşı güvenlidir); th:utext çıktıyı olduğu gibi, escape etmeden yazar.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-views-thymeleaf'
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
    ($$th:text yalnızca sayısal değerlerle çalışır$$, FALSE, 0),
    ($$th:utext kullanımdan kaldırılmıştır ve asla kullanılmamalıdır$$, FALSE, 1),
    ($$th:text her zaman HTML özel karakterlerini escape eder (XSS'e karşı güvenlidir); th:utext çıktıyı olduğu gibi, escape etmeden yazar$$, TRUE, 2),
    ($$th:utext kullanılması daha hızlıdır, th:text daha yavaştır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-views-thymeleaf'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-views-thymeleaf')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$th:if ile CSS'in display:none'ı arasındaki davranış farkı nedir?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$th:if ile CSS'in display:none'ı arasındaki davranış farkı nedir?$$,
           NULL, NULL,
           $$th:if, koşul yanlışsa etiketi HTML çıktısından tamamen kaldırır; display:none elementi yine tarayıcıya gönderir, yalnızca görsel olarak gizler.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-views-thymeleaf'
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
    ($$th:if, koşul yanlışsa etiketi HTML çıktısından tamamen kaldırır; display:none elementi yine tarayıcıya gönderir, yalnızca görsel olarak gizler$$, TRUE, 0),
    ($$Hiçbir fark yoktur, aynı şekilde davranırlar$$, FALSE, 1),
    ($$display:none sunucuda değerlendirilir, th:if istemcide değerlendirilir$$, FALSE, 2),
    ($$th:if yalnızca <div> etiketlerinde kullanılabilir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-views-thymeleaf'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-views-thymeleaf')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir fragment'ı dahil ederken th:insert ile th:replace arasındaki temel fark nedir?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bir fragment'ı dahil ederken th:insert ile th:replace arasındaki temel fark nedir?$$,
           NULL, NULL,
           $$th:insert, fragment'ı host etiketin İÇİNE yerleştirir (host etiket kalır); th:replace, host etiketi tamamen fragment'ın kendi kök etiketiyle değiştirir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-views-thymeleaf'
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
    ($$İşlevsel olarak aynıdırlar, yalnızca isimlendirme kuralı bakımından farklıdırlar$$, FALSE, 0),
    ($$th:replace, th:insert lehine kullanımdan kaldırılmıştır$$, FALSE, 1),
    ($$th:insert, fragment'ı host etiketin İÇİNE yerleştirir (host etiket kalır); th:replace, host etiketi tamamen fragment'ın kendi kök etiketiyle değiştirir$$, TRUE, 2),
    ($$th:insert yalnızca harici dosyalarla, th:replace yalnızca aynı dosyayla çalışır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-views-thymeleaf'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: CODE_OUTPUT)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'spring-mvc-views-thymeleaf')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu ifade bir seçim filtresinin (.?[...]) içinde ve aktifSlug, dış kapsamdan gelen bir değişken (bir Konu alanı değil). Bu gerçekten çalıştığında muhtemel sonuç nedir?$$
      AND code_snippet = $$<li th:each="kategori : ${kategoriler}"
    th:with="aktifMi=${kategori.konular().?[#this.slug() == aktifSlug].size() > 0}">
    ...
</li>$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu ifade bir seçim filtresinin (.?[...]) içinde ve aktifSlug, dış kapsamdan gelen bir değişken (bir Konu alanı değil). Bu gerçekten çalıştığında muhtemel sonuç nedir?$$,
           $$<li th:each="kategori : ${kategoriler}"
    th:with="aktifMi=${kategori.konular().?[#this.slug() == aktifSlug].size() > 0}">
    ...
</li>$$, $$html$$,
           $$.?[...] içinde #this, tüm kapsamı geçerli elemana yeniden bağlar, bu yüzden aktifSlug, dış değişken yerine Konu üzerinde bir alan olarak aranır ve bir SpelEvaluationException fırlatır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'spring-mvc-views-thymeleaf'
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
    ($$Bir SpelEvaluationException fırlatır -- .?[...] içinde #this, tüm kapsamı geçerli elemana yeniden bağlar, bu yüzden aktifSlug, dış değişken yerine Konu üzerinde bir alan olarak aranır$$, TRUE, 0),
    ($$Doğru şekilde çalışır, slug'ı aktifSlug ile eşleşen konuları filtreler$$, FALSE, 1),
    ($$Her zaman sessizce false olarak değerlendirilir, istisna fırlatmaz$$, FALSE, 2),
    ($$Sonsuz bir döngüye yol açar$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'spring-mvc-views-thymeleaf'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
