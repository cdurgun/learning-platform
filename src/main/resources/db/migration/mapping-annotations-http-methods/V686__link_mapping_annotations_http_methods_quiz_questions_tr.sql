-- Promotion-style migration linking TR mapping-annotations-http-methods quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'mapping-annotations-http-methods')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$@RequestMapping("/urunler") bir method attribute'u belirtilmeden yazılırsa ne olur?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$@RequestMapping("/urunler") bir method attribute'u belirtilmeden yazılırsa ne olur?$$,
           NULL, NULL,
           $$method attribute'u olmadan, @RequestMapping her HTTP metoduna (GET, POST, DELETE vb.) yanıt verir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'mapping-annotations-http-methods'
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
    ($$Uygulama başlatılırken hata oluşur$$, FALSE, 0),
    ($$Hiçbir HTTP metoduna yanıt vermez$$, FALSE, 1),
    ($$Güvenlik varsayılanı olarak yalnızca GET'e yanıt verir$$, FALSE, 2),
    ($$Her HTTP metoduna (GET, POST, DELETE vb.) yanıt verir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'mapping-annotations-http-methods'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'mapping-annotations-http-methods')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$@GetMapping("/kullanicilar"), @RequestMapping ile ilişkili olarak nedir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$@GetMapping("/kullanicilar"), @RequestMapping ile ilişkili olarak nedir?$$,
           NULL, NULL,
           $$@GetMapping, @RequestMapping(path="/kullanicilar", method=RequestMethod.GET)'e eşdeğer bir meta-annotation'dır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'mapping-annotations-http-methods'
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
    ($$Yalnızca geriye dönük uyumluluk için tutulan, kullanımdan kaldırılmış bir annotation$$, FALSE, 0),
    ($$Yalnızca sınıf seviyesinde kullanılabilen bir annotation$$, FALSE, 1),
    ($$@RequestMapping(path="/kullanicilar", method=RequestMethod.GET)'e eşdeğer bir meta-annotation$$, TRUE, 2),
    ($$Kendi ayrı mekanizmasına sahip, tamamen bağımsız bir annotation$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'mapping-annotations-http-methods'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'mapping-annotations-http-methods')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$GET /kitaplar/ara?q=deneme isteği gönderiliyor. ara metodu {id}'den sonra tanımlanmış olsa bile, isteği hangi metot karşılar?$$
      AND code_snippet = $$@RestController
@RequestMapping("/kitaplar")
public class KitapController {
    @GetMapping("/{id}")
    public String tekKitap(@PathVariable Long id) { return "tek:" + id; }

    @GetMapping("/ara")
    public String ara(@RequestParam String q) { return "ara:" + q; }
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$GET /kitaplar/ara?q=deneme isteği gönderiliyor. ara metodu {id}'den sonra tanımlanmış olsa bile, isteği hangi metot karşılar?$$,
           $$@RestController
@RequestMapping("/kitaplar")
public class KitapController {
    @GetMapping("/{id}")
    public String tekKitap(@PathVariable Long id) { return "tek:" + id; }

    @GetMapping("/ara")
    public String ara(@RequestParam String q) { return "ara:" + q; }
}$$, $$java$$,
           $$Spring, tanımlanma sırasından bağımsız olarak literal path segmentini her zaman değişken segmentten daha spesifik kabul eder -- bu yüzden /ara, tekKitap değil ara ile eşleşir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'mapping-annotations-http-methods'
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
    ($$ara, çünkü Spring, tanımlanma sırasından bağımsız olarak literal path segmentini her zaman değişken segmentten daha spesifik kabul eder$$, TRUE, 0),
    ($$tekKitap, çünkü önce tanımlanmıştır$$, FALSE, 1),
    ($$Hiçbiri -- bu, başlangıçta belirsiz mapping hatasına yol açar$$, FALSE, 2),
    ($$Deterministik değildir -- iki metottan biri çağrılabilir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'mapping-annotations-http-methods'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'mapping-annotations-http-methods')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$İki metot da POST /siparisler'i eşliyor; biri consumes = "application/json", diğeri consumes = "application/xml". Spring, gelen bir isteği hangi metodun karşılayacağına nasıl karar verir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$İki metot da POST /siparisler'i eşliyor; biri consumes = "application/json", diğeri consumes = "application/xml". Spring, gelen bir isteği hangi metodun karşılayacağına nasıl karar verir?$$,
           NULL, NULL,
           $$Spring, isteğin Content-Type başlığını inceleyip eşleşen consumes değerine yönlendirir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'mapping-annotations-http-methods'
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
    ($$İkisini tek bir handler'da birleştirir$$, FALSE, 0),
    ($$Aynı path iki kez eşlendiği için bir istisna fırlatır$$, FALSE, 1),
    ($$İsteğin Content-Type başlığını inceleyip eşleşen consumes değerine yönlendirir$$, TRUE, 2),
    ($$Her zaman önce tanımlanan metodu seçer$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'mapping-annotations-http-methods'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'mapping-annotations-http-methods')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$HTTP metotlarının güvenlik (safe) ve idempotency özellikleriyle ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$HTTP metotlarının güvenlik (safe) ve idempotency özellikleriyle ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$GET hem safe hem idempotent olmalı; POST ikisi de değil; DELETE safe olmasa bile idempotent'tir. PUT durum değiştirdiği için safe değildir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'mapping-annotations-http-methods'
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
    ($$DELETE, safe olmasa bile idempotent'tir$$, TRUE, 0),
    ($$GET, hem safe (durum değiştirmemeli) hem de idempotent olmak zorundadır$$, TRUE, 1),
    ($$PUT, yalnızca mevcut veriyi güncellediği için safe'tir$$, FALSE, 2),
    ($$POST ne safe'tir ne de idempotent'tir -- her çağrı genellikle yeni bir kaynak oluşturur$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'mapping-annotations-http-methods'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'mapping-annotations-http-methods')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Mevcut profil {"ad": "Ayşe", "sehir": "İzmir"}. Bir istemci PUT /profiller/1'e {"sehir": "Ankara"} gövdesiyle istek gönderiyor. profil'in sonuç durumu nedir?$$
      AND code_snippet = $$@PatchMapping("/profiller/{id}")
public void guncelle(@PathVariable Long id, @RequestBody Map<String, Object> alanlar) {
    profil.putAll(alanlar); // yalnızca alanlar içindeki key'leri değiştirir
}

@PutMapping("/profiller/{id}")
public void degistir(@PathVariable Long id, @RequestBody Map<String, Object> alanlar) {
    profil.clear();
    profil.putAll(alanlar);
}$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Mevcut profil {"ad": "Ayşe", "sehir": "İzmir"}. Bir istemci PUT /profiller/1'e {"sehir": "Ankara"} gövdesiyle istek gönderiyor. profil'in sonuç durumu nedir?$$,
           $$@PatchMapping("/profiller/{id}")
public void guncelle(@PathVariable Long id, @RequestBody Map<String, Object> alanlar) {
    profil.putAll(alanlar); // yalnızca alanlar içindeki key'leri değiştirir
}

@PutMapping("/profiller/{id}")
public void degistir(@PathVariable Long id, @RequestBody Map<String, Object> alanlar) {
    profil.clear();
    profil.putAll(alanlar);
}$$, $$java$$,
           $$PUT, kaynağın tamamını değiştirir -- degistir(), önce profili temizler, bu yüzden ad kaybolur, yalnızca {"sehir": "Ankara"} kalır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'mapping-annotations-http-methods'
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
    ($${"ad": "Ayşe", "sehir": "İzmir"} -- değişmedi$$, FALSE, 0),
    ($${"sehir": "Ankara"} -- ad kayboldu, çünkü PUT kaynağın tamamını değiştirir$$, TRUE, 1),
    ($$ad eksik olduğu için 409 Conflict döndürülür$$, FALSE, 2),
    ($${"ad": "Ayşe", "sehir": "Ankara"}$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'mapping-annotations-http-methods'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'mapping-annotations-http-methods')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$/kitaplar/{id} yolunda yalnızca GET ve PUT için mapping var. Bir istemci DELETE /kitaplar/5 gönderiyor. Spring ne döndürür ve neden?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$/kitaplar/{id} yolunda yalnızca GET ve PUT için mapping var. Bir istemci DELETE /kitaplar/5 gönderiyor. Spring ne döndürür ve neden?$$,
           NULL, NULL,
           $$405 Method Not Allowed -- path mevcut ama DELETE için bir mapping yok. Path bulunduğu için 404 yanlış olurdu.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'mapping-annotations-http-methods'
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
    ($$500 Internal Server Error, çünkü hiçbir handler eşleşmedi$$, FALSE, 0),
    ($$404 Not Found, çünkü path segmenti mevcut değil$$, FALSE, 1),
    ($$200 OK, çünkü DELETE sessizce GET'e düşer$$, FALSE, 2),
    ($$405 Method Not Allowed, çünkü path mevcut ama DELETE için bir mapping yok$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'mapping-annotations-http-methods'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
