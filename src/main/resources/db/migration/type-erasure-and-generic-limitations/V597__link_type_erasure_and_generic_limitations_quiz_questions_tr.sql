-- Promotion-style migration linking TR type-erasure-and-generic-limitations quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: CODE_OUTPUT)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'type-erasure-and-generic-limitations')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$List<String> metinler = new ArrayList<>();
List<Double> ondaliklar = new ArrayList<>();
System.out.println(metinler.getClass() == ondaliklar.getClass());$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$List<String> metinler = new ArrayList<>();
List<Double> ondaliklar = new ArrayList<>();
System.out.println(metinler.getClass() == ondaliklar.getClass());$$, $$java$$,
           $$Tür argümanı derlemeyi atlatamadığı için (type erasure), farklı tür argümanlarıyla inşa edilmiş iki koleksiyon çalışma zamanında birbirinden ayırt edilemez -- metinler.getClass() ve ondaliklar.getClass() tam olarak aynı Class nesnesini döndürür.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'type-erasure-and-generic-limitations'
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
    ($$true$$, TRUE, 0),
    ($$false$$, FALSE, 1),
    ($$Derleme hatası -- getClass(), == ile karşılaştırılamaz.$$, FALSE, 2),
    ($$NullPointerException.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'type-erasure-and-generic-limitations'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'type-erasure-and-generic-limitations')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Kod, `if (nesne instanceof List<Integer>) { ... }` yazmaya çalışıyor. Ne olur?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Kod, `if (nesne instanceof List<Integer>) { ... }` yazmaya çalışıyor. Ne olur?$$,
           NULL, NULL,
           $$instanceof List<Integer> aynı nedenle derlenmez bile -- type erasure yüzünden karşılaştırılacak "bir Integer List'i" gibi bir çalışma zamanı bilgisi yoktur. Yalnızca raw instanceof List<?> geçerlidir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'type-erasure-and-generic-limitations'
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
    ($$Derlenmez -- instanceof List<Integer> geçerli değildir; yalnızca instanceof List<?> geçerlidir.$$, TRUE, 0),
    ($$Derlenir ve nesne herhangi bir List türü olduğunda true değerlendirilir.$$, FALSE, 1),
    ($$Derlenir ve yalnızca nesne özellikle bir List<Integer> olduğunda true değerlendirilir.$$, FALSE, 2),
    ($$Derlenir ve instanceof kontrolünde ClassCastException fırlatır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'type-erasure-and-generic-limitations'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'type-erasure-and-generic-limitations')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$static <T> T varsayilanUret(Supplier<T> uretici) {
    return uretici.get();
}

public class Ornek {
    public static void main(String[] args) {
        ArrayList<Integer> liste = varsayilanUret(ArrayList::new);
        System.out.println(liste.size());
    }
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$static <T> T varsayilanUret(Supplier<T> uretici) {
    return uretici.get();
}

public class Ornek {
    public static void main(String[] args) {
        ArrayList<Integer> liste = varsayilanUret(ArrayList::new);
        System.out.println(liste.size());
    }
}$$, $$java$$,
           $$Erasure yüzünden JVM'in çalışma zamanında new T() yapacağı gerçek bir sınıfı yoktur. Standart geçici çözüm: yalnızca ÇAĞIRAN o noktada T'nin ne olduğunu bildiği için, çağıranın bir Supplier<T> sağlamasıdır -- burada ArrayList::new, metodun kendisi T inşa etmeye çalışmak yerine. ArrayList::new boş bir liste üretir, size() 0 döner.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'type-erasure-and-generic-limitations'
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
    ($$0$$, TRUE, 0),
    ($$Derleme hatası -- generic metotlar bir Supplier<T> parametresi kabul edemez.$$, FALSE, 1),
    ($$Derlenmez -- ArrayList::new, ArrayList<Integer> için geçerli bir Supplier değildir.$$, FALSE, 2),
    ($$NullPointerException.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'type-erasure-and-generic-limitations'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'type-erasure-and-generic-limitations')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod derlendiğinde ne olur?$$
      AND code_snippet = $$class Yigin<T> {
    void diziOlustur() {
        T[] elemanlar = new T[5];
    }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu kod derlendiğinde ne olur?$$,
           $$class Yigin<T> {
    void diziOlustur() {
        T[] elemanlar = new T[5];
    }
}$$, $$java$$,
           $$Bir List'ten farklı olarak, bir Java array'i eleman türünü çalışma zamanında hatırlar -- ama erasure, bir array'e çalışma zamanında verilecek gerçek bir T de olmadığı anlamına gelir, bu yüzden new T[5] derlenmez. Generic bir sınıfın içindeki geçici çözüm, düz bir Object[] inşa edip onu T[]'e cast etmektir (bir "unchecked" uyarısıyla), doğrudan new T[5] yazmak değil.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'type-erasure-and-generic-limitations'
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
    ($$Derlenmez -- new T[5], doğrudan generic bir array oluşturamaz.$$, TRUE, 0),
    ($$Derlenir ve 5 tane null referanstan oluşan bir array oluşturur.$$, FALSE, 1),
    ($$Derlenir ama çalışma zamanında NegativeArraySizeException fırlatır.$$, FALSE, 2),
    ($$Derlenir, çünkü T[], otomatik olarak Object[5] olarak ele alınır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'type-erasure-and-generic-limitations'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'type-erasure-and-generic-limitations')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod derlendiğinde ne olur?$$
      AND code_snippet = $$class Kap<T> {
    private T deger;
    static void degeriYazdir(T deger) {
        System.out.println(deger);
    }
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod derlendiğinde ne olur?$$,
           $$class Kap<T> {
    private T deger;
    static void degeriYazdir(T deger) {
        System.out.println(deger);
    }
}$$, $$java$$,
           $$static bir metot, her instance arasında paylaşılan SINIFIN kendisine aittir -- ama bir sınıfın tür parametresi yalnızca instance başına bilinir (Kap<String> ve Kap<Integer> bir arada var olabilir), bu yüzden statik bir üyenin başvurabileceği tek, tutarlı bir T yoktur. Bu derlenmez.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'type-erasure-and-generic-limitations'
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
    ($$Derlenmez -- static bir metot, sınıfın kendi tür parametresi T'ye başvuramaz.$$, TRUE, 0),
    ($$Derlenir, ve degeriYazdir, T'den bağımsız olarak tüm Kap<T> instance'ları arasında paylaşılır.$$, FALSE, 1),
    ($$Derlenir, deger her T için varsayılan olarak null olur.$$, FALSE, 2),
    ($$Derlenir, yalnızca Kap tüm program boyunca tam olarak bir instance bildirirse.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'type-erasure-and-generic-limitations'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'type-erasure-and-generic-limitations')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod çalıştığında ne olur?$$
      AND code_snippet = $$static void kirlet(List liste) {
    liste.add("hata");
}

public class Ornek {
    public static void main(String[] args) {
        List<Double> degerler = new ArrayList<>();
        degerler.add(3.5);
        kirlet(degerler);
        for (Double d : degerler) {
            System.out.println(d);
        }
    }
}$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu kod çalıştığında ne olur?$$,
           $$static void kirlet(List liste) {
    liste.add("hata");
}

public class Ornek {
    public static void main(String[] args) {
        List<Double> degerler = new ArrayList<>();
        degerler.add(3.5);
        kirlet(degerler);
        for (Double d : degerler) {
            System.out.println(d);
        }
    }
}$$, $$java$$,
           $$kirlet(...), raw bir List alır, bu yüzden derleyici generics'in normalde sağladığı tür kontrolünün hiçbirini uygulamaz -- gerçekte bir List<Double> olan bir şeye bir String eklemek sorunsuz derlenir. Ama hata eklemede gerçekleşmez; daha sonra, okumada, derleyicinin eklediği Double'a cast sonunda çalışıp ClassCastException fırlattığında gerçekleşir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'type-erasure-and-generic-limitations'
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
    ($$3.5 yazdırır, sonra ikinci elemanda ClassCastException fırlatır.$$, TRUE, 0),
    ($$Derlenmez -- kirlet(liste), bir List<Double> argümanını kabul edemez.$$, FALSE, 1),
    ($$Hiçbir hata olmadan 3.5 sonra "hata" yazdırır.$$, FALSE, 2),
    ($$kirlet(...) içinde hemen ClassCastException fırlatır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'type-erasure-and-generic-limitations'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'type-erasure-and-generic-limitations')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Java'nın tasarımcıları, generics Java 5'te tanıtıldığında neden type erasure'ı seçti?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Java'nın tasarımcıları, generics Java 5'te tanıtıldığında neden type erasure'ı seçti?$$,
           NULL, NULL,
           $$Mevcut Java kodunun ve zaten derlenmiş .class dosyalarının muazzam bir kısmı List gibi raw type'lar kullanıyordu. Erasure, generic kodun bu önceden var olan, generic olmayan kod ve bytecode ile onu bozmadan birlikte çalışmasına izin veren tasarım kararıydı.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'type-erasure-and-generic-limitations'
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
    ($$Yeni generic kodun, önceden var olan generic olmayan kod ve zaten derlenmiş bytecode ile birlikte çalışmasına izin vermek için.$$, TRUE, 0),
    ($$Çünkü tür bilgisini çalışma zamanında saklamak JVM için teknik olarak imkânsızdı.$$, FALSE, 1),
    ($$Generic kodu eşdeğer generic olmayan koddan daha hızlı çalıştırmak için.$$, FALSE, 2),
    ($$Çünkü erasure, <int> gibi primitif tür parametrelerini desteklemek için gerekliydi.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'type-erasure-and-generic-limitations'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
