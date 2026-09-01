-- Promotion-style migration linking TR exception-hierarchy quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-hierarchy')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`NumberFormatException`'ın hiyerarşi zinciri aşağıdakilerden hangisidir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$`NumberFormatException`'ın hiyerarşi zinciri aşağıdakilerden hangisidir?$$,
           NULL, NULL,
           $$NumberFormatException bir IllegalArgumentException'dır, o da bir RuntimeException'dır, o da bir Exception'dır, o da bir Throwable'dır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'exception-hierarchy'
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
    ($$NumberFormatException -> IllegalArgumentException -> RuntimeException -> Exception -> Throwable$$, TRUE, 0),
    ($$NumberFormatException -> Exception -> RuntimeException -> Throwable$$, FALSE, 1),
    ($$NumberFormatException -> Error -> Throwable$$, FALSE, 2),
    ($$NumberFormatException -> Throwable (doğrudan)$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-hierarchy'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-hierarchy')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`StackOverflowError`'ın hiyerarşi zinciri hangi sınıftan geçer?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$`StackOverflowError`'ın hiyerarşi zinciri hangi sınıftan geçer?$$,
           NULL, NULL,
           $$StackOverflowError'ın zinciri hiç Exception'a uğramadan doğrudan Error üzerinden Throwable'a çıkar -- iki dal yalnızca en tepede birleşir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'exception-hierarchy'
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
    ($$Exception üzerinden Throwable'a çıkar.$$, FALSE, 0),
    ($$RuntimeException üzerinden Exception'a çıkar.$$, FALSE, 1),
    ($$Error üzerinden Throwable'a çıkar, hiç Exception'a uğramaz.$$, TRUE, 2),
    ($$Doğrudan Throwable'ı genişletir, ara sınıf yoktur.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-hierarchy'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-hierarchy')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$public class Ornek {
    static void kontrol(int[] veri, int index) {
        try {
            System.out.println(veri[index]);
        } catch (RuntimeException e) {
            System.out.println("yakalandi: " + e.getClass().getSimpleName());
        }
    }
    public static void main(String[] args) {
        kontrol(new int[]{5, 10}, 7);
    }
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$public class Ornek {
    static void kontrol(int[] veri, int index) {
        try {
            System.out.println(veri[index]);
        } catch (RuntimeException e) {
            System.out.println("yakalandi: " + e.getClass().getSimpleName());
        }
    }
    public static void main(String[] args) {
        kontrol(new int[]{5, 10}, 7);
    }
}$$, $$java$$,
           $$veri dizisinin uzunluğu 2, ama index 7 istendiği için ArrayIndexOutOfBoundsException fırlatılır -- bu sınıf RuntimeException'ın bir alt sınıfı olduğu için tek bir catch (RuntimeException e) bloğuyla yakalanır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'exception-hierarchy'
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
    ($$yakalandi: ArrayIndexOutOfBoundsException$$, TRUE, 0),
    ($$yakalandi: ArithmeticException$$, FALSE, 1),
    ($$Derleme hatası.$$, FALSE, 2),
    ($$Program çöker, hiçbir şey yazdırılmaz.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-hierarchy'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-hierarchy')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$public class Ornek {
    static void bilgiVer(Throwable t) {
        if (t instanceof Exception) {
            System.out.println("exception");
        } else {
            System.out.println("exception degil");
        }
    }
    public static void main(String[] args) {
        bilgiVer(new StackOverflowError());
    }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$public class Ornek {
    static void bilgiVer(Throwable t) {
        if (t instanceof Exception) {
            System.out.println("exception");
        } else {
            System.out.println("exception degil");
        }
    }
    public static void main(String[] args) {
        bilgiVer(new StackOverflowError());
    }
}$$, $$java$$,
           $$StackOverflowError, Exception'ın değil Error'ın bir alt sınıfıdır -- bu yüzden instanceof Exception kontrolü false döner ve "exception degil" yazdırılır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'exception-hierarchy'
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
    ($$exception$$, FALSE, 0),
    ($$exception degil$$, TRUE, 1),
    ($$Derleme hatası.$$, FALSE, 2),
    ($$NullPointerException fırlatılır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-hierarchy'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-hierarchy')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`catch (Exception e)` ile `catch (Throwable t)` arasındaki temel fark nedir?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`catch (Exception e)` ile `catch (Throwable t)` arasındaki temel fark nedir?$$,
           NULL, NULL,
           $$catch (Throwable t) yazmak, Error'ı da kapsar ve neredeyse hiçbir zaman doğru bir seçim değildir -- catch (Exception e) ise Error'ı kapsamaz.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'exception-hierarchy'
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
    ($$İkisi de tamamen aynı şeyi yakalar, fark yoktur.$$, FALSE, 0),
    ($$catch (Throwable t), Error alt sınıflarını da kapsar, catch (Exception e) ise kapsamaz.$$, TRUE, 1),
    ($$catch (Exception e) yalnızca unchecked exception'ları yakalar.$$, FALSE, 2),
    ($$catch (Throwable t) yalnızca checked exception'ları yakalar.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-hierarchy'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-hierarchy')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdakilerden hangileri Java'nın exception hiyerarşisi hakkında doğrudur? (Uygun olan hepsini seçin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdakilerden hangileri Java'nın exception hiyerarşisi hakkında doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$StackOverflowError'ın zinciri hiç Exception'a uğramadan Error üzerinden Throwable'a çıkar; bir catch bloğu fırlatılan sınıfın tam kendisi yerine herhangi bir atasını da hedefleyebilir (polimorfik yakalama).$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'exception-hierarchy'
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
    ($$StackOverflowError'ın zinciri hiç Exception'a uğramadan Error üzerinden Throwable'a çıkar.$$, TRUE, 0),
    ($$Bir catch bloğu, fırlatılan sınıfın tam kendisi yerine herhangi bir atasını da hedefleyebilir.$$, TRUE, 1),
    ($$RuntimeException, Exception'ın kardeşi olan ayrı bir daldır.$$, FALSE, 2),
    ($$Error, Exception'ın bir alt sınıfıdır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-hierarchy'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'exception-hierarchy')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre aşağıdakilerden hangileri yaygın bir hatadır? (Uygun olan hepsini seçin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre aşağıdakilerden hangileri yaygın bir hatadır? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$catch (Throwable t) yazmak Error'ı da kapsar ve neredeyse hiçbir zaman doğru değildir; RuntimeException'ın Exception'dan ayrı bir dal olduğunu düşünmek de hiyerarşiyi karıştıran bir hatadır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'exception-hierarchy'
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
    ($$catch (Throwable t) yazmak -- bu Error'ı da kapsar ve neredeyse hiçbir zaman doğru bir seçim değildir.$$, TRUE, 0),
    ($$RuntimeException'ın Exception'dan AYRI bir dal olduğunu düşünmek.$$, TRUE, 1),
    ($$catch bloklarını en spesifik türden en genele doğru sıralamak.$$, FALSE, 2),
    ($$instanceof kullanarak nesnenin gerçek türünü çalışma zamanında kontrol etmek.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'exception-hierarchy'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
