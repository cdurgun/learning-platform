-- Promotion-style migration linking TR rest-api-design quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: MULTIPLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'rest-api-design')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir JPA entity'sini doğrudan bir @RestController'dan döndürmenin riskleri nelerdir? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir JPA entity'sini doğrudan bir @RestController'dan döndürmenin riskleri nelerdir? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$Bir entity, şifre hash'i gibi hiçbir istemcinin görmemesi gereken alanları açığa çıkarabilir, ve lazy-loaded bir alan serileştirme sırasında bir LazyInitializationException fırlatabilir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'rest-api-design'
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
    ($$Serileştirme sırasında dokunulursa, lazy-loaded bir alan bir LazyInitializationException fırlatabilir$$, TRUE, 0),
    ($$Hiçbir istemcinin görmemesi gereken, şifre hash'i gibi dahili alanları açığa çıkarabilir$$, TRUE, 1),
    ($$DTO kullanmaktan her zaman önemli ölçüde daha yavaştır$$, FALSE, 2),
    ($$Jackson, temelde herhangi bir JPA entity'sini serileştiremez$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'rest-api-design'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'rest-api-design')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir @RestController metodunun parametresi Pageable tipindeyse, Spring bunu nasıl doldurur?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir @RestController metodunun parametresi Pageable tipindeyse, Spring bunu nasıl doldurur?$$,
           NULL, NULL,
           $$?page=/?size=/?sort= query parametrelerinden otomatik olarak çözülür, elle ayrıştırmaya gerek kalmaz.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'rest-api-design'
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
    ($$Her zaman sayfa 0, boyut 20'ye varsayılan olarak döner, üzerine yazma imkânı yoktur$$, FALSE, 0),
    ($$Geliştiricinin özel bir HandlerMethodArgumentResolver yazmasını gerektirir$$, FALSE, 1),
    ($$?page=/?size=/?sort= query parametrelerinden otomatik olarak çözülür$$, TRUE, 2),
    ($$Metot gövdesinin içinde elle oluşturulmalıdır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'rest-api-design'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'rest-api-design')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu Sort nesnesinin istek tarafındaki eşdeğer temsili hangi istemci-taraflı query string'dir?$$
      AND code_snippet = $$Sort sort = Sort.by(Sort.Direction.ASC, "zorluk")
                 .and(Sort.by(Sort.Direction.DESC, "baslik"));$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu Sort nesnesinin istek tarafındaki eşdeğer temsili hangi istemci-taraflı query string'dir?$$,
           $$Sort sort = Sort.by(Sort.Direction.ASC, "zorluk")
                 .and(Sort.by(Sort.Direction.DESC, "baslik"));$$, $$java$$,
           $$?sort=zorluk,asc&sort=baslik,desc, Spring'in tam olarak bu tür bir Sort nesnesine çözdüğü istek tarafı eşdeğerdir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'rest-api-design'
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
    ($$?sort=zorluk,asc&sort=baslik,desc$$, TRUE, 0),
    ($$?sort=zorluk&sort=baslik$$, FALSE, 1),
    ($$?sortAsc=zorluk&sortDesc=baslik$$, FALSE, 2),
    ($$?orderBy=zorluk+baslik$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'rest-api-design'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'rest-api-design')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$kategori parametresi olmadan GET /konular isteği gönderiliyor. Ne olur?$$
      AND code_snippet = $$@GetMapping("/konular")
public List<Konu> listele(@RequestParam(required = false) String kategori) {
    return tumKonular.stream()
        .filter(k -> kategori.equals(k.getKategori()))
        .toList();
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$kategori parametresi olmadan GET /konular isteği gönderiliyor. Ne olur?$$,
           $$@GetMapping("/konular")
public List<Konu> listele(@RequestParam(required = false) String kategori) {
    return tumKonular.stream()
        .filter(k -> kategori.equals(k.getKategori()))
        .toList();
}$$, $$java$$,
           $$Bir NullPointerException fırlatılır, çünkü kategori null'dır ve .equals(...) doğrudan onun üzerinde çağrılıyor -- her opsiyonel filtre "sağlanmadığında etkisi yok" durumunu açıkça ifade etmelidir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'rest-api-design'
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
    ($$Boş bir liste döndürür$$, FALSE, 0),
    ($$kategori teknik olarak zorunlu olduğu için 400 Bad Request döner$$, FALSE, 1),
    ($$Bir NullPointerException fırlatılır, çünkü kategori null'dır ve .equals(...) doğrudan onun üzerinde çağrılıyor$$, TRUE, 2),
    ($$kategori yokken filtrenin hiçbir etkisi olmadığı için tüm konuları döndürür$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'rest-api-design'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'rest-api-design')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Spring Data'nın kendisi, bir controller metodundan doğrudan Page<T> döndürmeyi neden tavsiye etmiyor?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Spring Data'nın kendisi, bir controller metodundan doğrudan Page<T> döndürmeyi neden tavsiye etmiyor?$$,
           NULL, NULL,
           $$PageImpl'in dahili alanları belgelenmiş, stabil bir sözleşme değildir ve varsayılan JSON şekli Spring Data sürümleri arasında değişmiştir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'rest-api-design'
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
    ($$PageImpl'in dahili alanları belgelenmiş, stabil bir sözleşme değildir ve varsayılan JSON şekli Spring Data sürümleri arasında değişmiştir$$, TRUE, 0),
    ($$Page<T> hiçbir şekilde JSON'a serileştirilemez$$, FALSE, 1),
    ($$Her zaman dahili veritabanı ID'lerini açığa çıkararak bir güvenlik riski oluşturur$$, FALSE, 2),
    ($$Response'un JSON yerine XML kullanmasını zorunlu kılar$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'rest-api-design'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'rest-api-design')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste ele alınan API versiyonlama stratejileriyle ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derste ele alınan API versiyonlama stratejileriyle ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$URI versiyonlama fark edilmemesi imkânsızdır ama kalıcı olarak her istemci URL'sine sızar; header versiyonlama URL'yi sabit tutar ama versiyonu dokümantasyon olmadan görünmez kılar.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'rest-api-design'
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
    ($$İki stratejiyi aynı API'de karıştırmak önerilen en iyi uygulamadır$$, FALSE, 0),
    ($$Header versiyonlama (Api-Version: 2) URL'yi sabit tutar, ama versiyonu dokümantasyon olmadan görünmez hale getirir$$, TRUE, 1),
    ($$Hangi stratejinin objektif olarak en iyi olduğuna dair evrensel olarak kabul edilmiş tek bir cevap vardır$$, FALSE, 2),
    ($$URI versiyonlama (/api/v1/...) fark edilmemesi imkânsızdır ama kalıcı olarak her istemci URL'sine sızar$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'rest-api-design'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'rest-api-design')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir istemcinin POST /orders isteği zaman aşımına uğruyor, bu yüzden aynı Idempotency-Key header'ıyla tekrar deniyor. Sunucu orijinal isteği zaten işlediyse, tekrar denemede ne yapar?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bir istemcinin POST /orders isteği zaman aşımına uğruyor, bu yüzden aynı Idempotency-Key header'ıyla tekrar deniyor. Sunucu orijinal isteği zaten işlediyse, tekrar denemede ne yapar?$$,
           NULL, NULL,
           $$Yeni bir kaynak oluşturmadan orijinal sonucu tekrar döndürür -- ikinci çağrının etkisi birincisiyle tamamen aynıdır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'rest-api-design'
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
    ($$Yeni bir kaynak oluşturmadan orijinal sonucu tekrar döndürür$$, TRUE, 0),
    ($$İkinci, yinelenen bir sipariş oluşturur$$, FALSE, 1),
    ($$Tekrar denemeyi 409 Conflict ile reddeder$$, FALSE, 2),
    ($$POST isteklerinde Idempotency-Key header'ını tamamen yok sayar$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'rest-api-design'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
