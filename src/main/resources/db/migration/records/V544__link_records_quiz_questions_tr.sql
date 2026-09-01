-- Promotion-style migration linking TR Record quiz questions to the topic's
-- fixed quiz created in records/V542 -- same pattern as arrays/V524,
-- scanner/V528, wrapper-classes/V532, file-reading/V536, and file-writing/
-- V540 (WITH ... RETURNING id + NOT EXISTS dedup + ON CONFLICT DO NOTHING
-- on the link insert).
--
-- All 6 TR questions from question-promotion/V541 (hand-authored and
-- self-reviewed directly in a Claude Code session -- no n8n, no OpenAI, no
-- AI Judge, and NOT translations of the EN set -- each TR question was
-- independently authored to test the SAME concept as its EN counterpart,
-- per an explicit 50/50 EN/TR parity request, using different record/
-- variable names, different question framing, or different option
-- polarity rather than a mechanical translation). No selection/omission --
-- the entire TR batch is linked.
--
-- Duplicate-safety: same NOT EXISTS + ON CONFLICT DO NOTHING pattern as
-- V543 -- see that file's header for the full rationale.

-- Question 1/6 (Pair 1 TR, quiz position 1)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'records')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir compact constructor içinde this.isim = isim; şeklinde alana doğrudan atama yapmaya çalışırsanız ne olur?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir compact constructor içinde this.isim = isim; şeklinde alana doğrudan atama yapmaya çalışırsanız ne olur?$$, NULL, NULL,
           $$Derleyici, alana yapılan bu doğrudan atamayı hata olarak reddeder -- çünkü örtük atama zaten blok sonunda derleyici tarafından otomatik olarak yapılacaktır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'records'
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
    ($$Derleyici bunu hata olarak reddeder, çünkü örtük atama zaten blok sonunda otomatik yapılacaktır.$$, TRUE, 0),
    ($$Kod normal şekilde derlenir ve çalışır.$$, FALSE, 1),
    ($$Yalnızca bir uyarı (warning) verir, hata vermez.$$, FALSE, 2),
    ($$Yalnızca final olmayan bileşenler için bu atama yasaktır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'records'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/6 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'records')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$record Boyut(int genislik, int yukseklik) {}
record Dikdortgen(int genislik, int yukseklik) {}
Boyut b = new Boyut(5, 10);
Dikdortgen d = new Dikdortgen(5, 10);
System.out.println(b.equals(d));$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$record Boyut(int genislik, int yukseklik) {}
record Dikdortgen(int genislik, int yukseklik) {}
Boyut b = new Boyut(5, 10);
Dikdortgen d = new Dikdortgen(5, 10);
System.out.println(b.equals(d));$$, $$java$$,
           $$Bir record'un ürettiği equals() metodu, önce iki örneğin tam olarak aynı sınıftan olup olmadığını kontrol eder. Boyut ve Dikdortgen farklı record tipleri olduğu için, bileşenleri aynı olsa bile b.equals(d) false döner.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'records'
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
    ($$true$$, FALSE, 0),
    ($$false$$, TRUE, 1),
    ($$ClassCastException fırlatır.$$, FALSE, 2),
    ($$Derleme hatası verir.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'records'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/6 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'records')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$record Deger(double d) {}
Deger a = new Deger(Double.NaN);
Deger b = new Deger(Double.NaN);
System.out.println(a.equals(b));$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$record Deger(double d) {}
Deger a = new Deger(Double.NaN);
Deger b = new Deger(Double.NaN);
System.out.println(a.equals(b));$$, $$java$$,
           $$Bir record'un ürettiği equals() metodu, double/float bileşenlerini çıplak == yerine Double.compare()/Float.compare() semantiğiyle karşılaştırır. Double.compare() semantiğinde NaN kendisine eşittir, bu yüzden çıktı true olur -- oysa primitive == ile Double.NaN == Double.NaN false döner.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'records'
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
    ($$true$$, TRUE, 0),
    ($$false$$, FALSE, 1),
    ($$Bir istisna (exception) fırlatır.$$, FALSE, 2),
    ($$Sonuç her çalıştırmada farklı olabilir.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'records'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/6 (Pair 4 TR, quiz position 4)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'records')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$record Point(int x, int y) {} için new Point(3, 4).toString() çağrısının çıktısı ne olur?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$record Point(int x, int y) {} için new Point(3, 4).toString() çağrısının çıktısı ne olur?$$, NULL, NULL,
           $$Bir record'un ürettiği toString() metodu, sınıfın basit adını ve tüm bileşenleri sırayla, RecordAdi[bileşen1=değer1, bileşen2=değer2] biçiminde listeler.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'records'
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
    ($$Point[x=3, y=4]$$, TRUE, 0),
    ($$Point(x=3, y=4)$$, FALSE, 1),
    ($${x=3, y=4}$$, FALSE, 2),
    ($$Point@<hashcode>$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'records'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/6 (Pair 5 TR, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'records')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Record'lar hakkında aşağıdaki ifadelerden hangileri doğrudur?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Record'lar hakkında aşağıdaki ifadelerden hangileri doğrudur?$$, NULL, NULL,
           $$Bir record istediği kadar arayüz implement edebilir ve ek constructor'lar this(...) ile canonical constructor'ı çağırmak zorundadır. Bileşen listesinde yer almayan ekstra bir instance alanı eklenemez -- bir record'un durumu tamamen bileşen listesinden oluşur. Ancak static alan ve metotlar bu kısıtlamaya tabi değildir, tanımlanabilirler.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'records'
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
    ($$Bir record, istediği kadar arayüz (interface) implement edebilir.$$, TRUE, 0),
    ($$Canonical constructor dışında tanımlanan ek constructor'lar, ilk satırda mutlaka this(...) ile canonical constructor'ı çağırmalıdır.$$, TRUE, 1),
    ($$Bileşen listesinde yer almayan ekstra bir instance alanı record'un gövdesine eklenebilir.$$, FALSE, 2),
    ($$Static alan ve metotlar bir record'un gövdesinde tanımlanamaz.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'records'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/6 (Pair 6 TR, quiz position 6)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'records')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$record Kullanici(String isim, int yas) {} tanımına göre, bir Kullanici örneğinin isim bileşenine erişmenin doğru yolu nedir?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$record Kullanici(String isim, int yas) {} tanımına göre, bir Kullanici örneğinin isim bileşenine erişmenin doğru yolu nedir?$$, NULL, NULL,
           $$Record accessor'ları, Java Bean get önekiyle değil, doğrudan bileşenin adıyla üretilir -- bu yüzden doğru çağrı kullanici.isim()'dir. Alanın kendisi private olduğu için kullanici.isim doğrudan derlenmez.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'records'
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
    ($$kullanici.getIsim()$$, FALSE, 0),
    ($$kullanici.isim()$$, TRUE, 1),
    ($$kullanici.isim$$, FALSE, 2),
    ($$Kullanici.isim(kullanici)$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'records'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
