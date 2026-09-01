-- Promotion-style migration linking TR checked-vs-unchecked-exceptions quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'checked-vs-unchecked-exceptions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Unchecked exception aşağıdakilerden hangisidir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Unchecked exception aşağıdakilerden hangisidir?$$,
           NULL, NULL,
           $$Unchecked exception, RuntimeException'ın (ve Error'ın) kendisi ve tüm alt sınıflarıdır -- bunlar için ne throws bildirmek ne de catch etmek zorunludur.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'checked-vs-unchecked-exceptions'
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
    ($$Exception'ın altında olup RuntimeException DIŞINDA kalan her sınıf.$$, FALSE, 0),
    ($$RuntimeException (ve Error) ile bunların tüm alt sınıfları.$$, TRUE, 1),
    ($$Yalnızca IOException ve SQLException.$$, FALSE, 2),
    ($$throws ile bildirilmesi zorunlu olan her sınıf.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'checked-vs-unchecked-exceptions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'checked-vs-unchecked-exceptions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kodu derleyip çalıştırmayla ilgili ne söylenebilir?$$
      AND code_snippet = $$public class Ornek {
    static int bol(int a, int b) {
        return a / b;
    }
    public static void main(String[] args) {
        System.out.println(bol(10, 0));
    }
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kodu derleyip çalıştırmayla ilgili ne söylenebilir?$$,
           $$public class Ornek {
    static int bol(int a, int b) {
        return a / b;
    }
    public static void main(String[] args) {
        System.out.println(bol(10, 0));
    }
}$$, $$java$$,
           $$ArithmeticException unchecked bir exception'dır, bu yüzden hiçbir throws bildirimi ya da catch bloğu olmadan derlenir; ama çalışırken yakalanmamış bir ArithmeticException ile sonlanır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'checked-vs-unchecked-exceptions'
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
    ($$Derlenmez, çünkü throws ArithmeticException bildirilmedi.$$, FALSE, 0),
    ($$Derlenir, ama çalışırken yakalanmamış bir ArithmeticException ile sonlanır.$$, TRUE, 1),
    ($$Derlenir ve "0" yazdırır.$$, FALSE, 2),
    ($$Derlenir ve sessizce hiçbir şey yazdırmaz.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'checked-vs-unchecked-exceptions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'checked-vs-unchecked-exceptions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir checked exception'ı unchecked bir exception'a sararken `cause` parametresini geçmemenin sonucu nedir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir checked exception'ı unchecked bir exception'a sararken `cause` parametresini geçmemenin sonucu nedir?$$,
           NULL, NULL,
           $$Bir checked exception'ı sarmalarken orijinal exception'ı cause olarak geçmezsen, asıl hatanın stack trace'i kaybolur ve hata ayıklamak çok zorlaşır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'checked-vs-unchecked-exceptions'
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
    ($$Program derlenmez.$$, FALSE, 0),
    ($$Orijinal hatanın mesajı ve stack trace'i kaybolur, hata ayıklamak zorlaşır.$$, TRUE, 1),
    ($$RuntimeException otomatik olarak checked exception'a dönüşür.$$, FALSE, 2),
    ($$Hiçbir etkisi olmaz, cause yalnızca kozmetiktir.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'checked-vs-unchecked-exceptions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'checked-vs-unchecked-exceptions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod hakkında ne söylenebilir?$$
      AND code_snippet = $$import java.io.FileNotFoundException;
import java.io.IOException;

interface Kaynak {
    String oku() throws FileNotFoundException;
}

class GenisKaynak implements Kaynak {
    public String oku() throws IOException {
        return "veri";
    }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu kod hakkında ne söylenebilir?$$,
           $$import java.io.FileNotFoundException;
import java.io.IOException;

interface Kaynak {
    String oku() throws FileNotFoundException;
}

class GenisKaynak implements Kaynak {
    public String oku() throws IOException {
        return "veri";
    }
}$$, $$java$$,
           $$Bir metodu override ederken üst sınıfın/interface'in bildirdiği checked exception'dan DAHA GENİŞ bir tip bildiremezsin -- burada interface FileNotFoundException bildirirken override eden metot daha geniş olan IOException'ı bildiriyor, bu yasak bir genişletmedir ve derleyici reddeder.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'checked-vs-unchecked-exceptions'
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
    ($$Derlenir ve "veri" yazdırır.$$, FALSE, 0),
    ($$Derlenmez, çünkü override eden metot daha GENİŞ bir checked exception bildiriyor.$$, TRUE, 1),
    ($$Derlenir ama çalışma zamanında hata verir.$$, FALSE, 2),
    ($$Derlenmez çünkü interface metotları override edilemez.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'checked-vs-unchecked-exceptions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'checked-vs-unchecked-exceptions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri unchecked exception kullanmak için iyi bir gerekçedir? (Uygun olan hepsini seçin)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri unchecked exception kullanmak için iyi bir gerekçedir? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Durum bir programlama hatasını temsil ediyorsa, ya da çağıranın durumdan gerçekte hiçbir şey yapamayacağı bir durum söz konusuysa, unchecked exception daha uygundur.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'checked-vs-unchecked-exceptions'
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
    ($$Durum bir programlama hatasını temsil ediyor, örneğin geçersiz bir argüman.$$, TRUE, 0),
    ($$Çağıranın durumdan gerçekte hiçbir şey yapamayacağı bir durum söz konusu.$$, TRUE, 1),
    ($$Çağıranın makul biçimde kurtarabileceği, dış kaynaklı bir durum (dosya bulunamaması gibi).$$, FALSE, 2),
    ($$API'nin her sınırında zorunlu bir catch/throws zinciri istiyorsunuz.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'checked-vs-unchecked-exceptions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'checked-vs-unchecked-exceptions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Checked exception'ları `catch (Exception e)` gibi aşırı geniş bir tiple yakalamanın sakıncası nedir?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Checked exception'ları `catch (Exception e)` gibi aşırı geniş bir tiple yakalamanın sakıncası nedir?$$,
           NULL, NULL,
           $$Checked exception'ları hiç düşünmeden catch (Exception e) gibi aşırı geniş bir tipe yakalamak, hem checked hem unchecked her şeyi (isteyerek ya da istemeyerek) aynı bloğa toplar.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'checked-vs-unchecked-exceptions'
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
    ($$Program derlenmez.$$, FALSE, 0),
    ($$Hem checked hem unchecked exception'ları, isteyerek ya da istemeyerek, aynı bloğa toplar.$$, TRUE, 1),
    ($$Yalnızca unchecked exception'ları yakalar, checked olanları kaçırır.$$, FALSE, 2),
    ($$Error alt sınıflarını da otomatik olarak yakalar.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'checked-vs-unchecked-exceptions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'checked-vs-unchecked-exceptions')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre aşağıdaki davranışlardan hangisi bir checked exception'ı sarmalarken (wrap) doğru kabul edilir?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre aşağıdaki davranışlardan hangisi bir checked exception'ı sarmalarken (wrap) doğru kabul edilir?$$,
           NULL, NULL,
           $$Checked exception'ı unchecked bir exception'a sararken orijinal exception'ı her zaman cause olarak geçmek yaygın ve güvenli bir tekniktir; bunu unutmak yaygın bir hatadır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'checked-vs-unchecked-exceptions'
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
    ($$Orijinal exception'ı cause parametresi olarak yeni exception'a geçirmek.$$, TRUE, 0),
    ($$Orijinal exception'ın mesajını yeni bir String'e kopyalayıp orijinali tamamen atmak.$$, FALSE, 1),
    ($$Sarmalama sırasında orijinal exception'ı asla cause olarak geçmemek, yalnızca mesajını kullanmak.$$, FALSE, 2),
    ($$Checked exception'ı doğrudan Error'a sarmalamak.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'checked-vs-unchecked-exceptions'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
