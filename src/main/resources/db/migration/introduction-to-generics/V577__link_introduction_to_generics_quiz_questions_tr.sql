-- Promotion-style migration linking TR introduction-to-generics quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: CODE_OUTPUT)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-generics')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod çalıştığında ne olur?$$
      AND code_snippet = $$List veriler = new ArrayList();
veriler.add("elma");
veriler.add(7);

for (Object o : veriler) {
    String s = (String) o;
    System.out.println(s);
}$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod çalıştığında ne olur?$$,
           $$List veriler = new ArrayList();
veriler.add("elma");
veriler.add(7);

for (Object o : veriler) {
    String s = (String) o;
    System.out.println(s);
}$$, $$java$$,
           $$Raw (generic olmayan) bir List, ekleme sırasında hem bir String hem bir Integer'ı hiçbir itiraz etmeden kabul eder -- hata ancak daha sonra, döngü yanlış konumlandırılmış Integer elemanına ulaştığında cast noktasında ClassCastException olarak ortaya çıkar.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'introduction-to-generics'
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
    ($$"elma" yazdırır, sonra ikinci elemanda ClassCastException fırlatır.$$, TRUE, 0),
    ($$veriler bir eleman türü bildirmediği için derlenmez.$$, FALSE, 1),
    ($$Hiçbir hata olmadan "elma" sonra "7" yazdırır.$$, FALSE, 2),
    ($$veriler.add(7) satırında hemen ClassCastException fırlatır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-generics'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-generics')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`Pair<String, Integer>` içindeki `String` ve `Integer` için ne söylenebilir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$`Pair<String, Integer>` içindeki `String` ve `Integer` için ne söylenebilir?$$,
           NULL, NULL,
           $$String ve Integer, Pair<K, V> gerçekten kullanıldığında K ve V tür parametreleri için sağlanan gerçek, somut türlerdir -- bunlar tür argümanlarıdır. K ve V'nin kendisi ise tür parametreleridir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'introduction-to-generics'
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
    ($$Tür argümanlarıdır -- Pair kullanıldığında sağlanan gerçek türler.$$, TRUE, 0),
    ($$Tür parametreleridir -- sınıf üzerinde bildirilen yer tutucular.$$, FALSE, 1),
    ($$Raw type'lardır.$$, FALSE, 2),
    ($$Wildcard'lardır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-generics'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-generics')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod derlendiğinde ne olur?$$
      AND code_snippet = $$class Kutu<T> {
    private T icerik;
    void koy(T icerik) { this.icerik = icerik; }
    T al() { return icerik; }
}

Kutu<Integer> sayiKutusu = new Kutu<>();
sayiKutusu.koy(10);
sayiKutusu.koy("on");$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu kod derlendiğinde ne olur?$$,
           $$class Kutu<T> {
    private T icerik;
    void koy(T icerik) { this.icerik = icerik; }
    T al() { return icerik; }
}

Kutu<Integer> sayiKutusu = new Kutu<>();
sayiKutusu.koy(10);
sayiKutusu.koy("on");$$, $$java$$,
           $$Kutu<Integer>, o instance için T'yi Integer olarak sabitler -- koy(T icerik), koy(Integer icerik) hâline gelir, bu yüzden koy("on") bir String ile çağırmak derlenmez; hata çalışma zamanına ertelenmez.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'introduction-to-generics'
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
    ($$Derlenmez -- koy("on"), koy(Integer icerik) ile eşleşmez.$$, TRUE, 0),
    ($$Derlenir ve icerik'i sessizce "on" ile değiştirir.$$, FALSE, 1),
    ($$Derlenir ama çalışma zamanında ClassCastException fırlatır.$$, FALSE, 2),
    ($$Derlenir çünkü Kutu<T> varsayılan olarak her türü kabul eder.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-generics'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-generics')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`class Sozluk<Anahtar, Deger> { ... }` şeklinde bir sınıf bildirildi. Aşağıdakilerden hangisi doğrudur?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$`class Sozluk<Anahtar, Deger> { ... }` şeklinde bir sınıf bildirildi. Aşağıdakilerden hangisi doğrudur?$$,
           NULL, NULL,
           $$Bir sınıf tek bir tür parametresiyle sınırlı değildir -- tasarımın ihtiyaç duyduğu kadarı virgülle ayrılarak bildirilebilir. Sozluk<String, Integer> ve Sozluk<Integer, String>, ikisi de aynı sınıfın geçerli, birbirinden bağımsız kullanımlarıdır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'introduction-to-generics'
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
    ($$Sozluk<String, Integer> ve Sozluk<Integer, String>, ikisi de aynı sınıfın geçerli, bağımsız olarak kontrol edilen kullanımlarıdır.$$, TRUE, 0),
    ($$Bir sınıf yalnızca Sozluk<Anahtar> gibi tek bir tür parametresi bildirebilir.$$, FALSE, 1),
    ($$Sozluk kullanıldığında Anahtar ve Deger her zaman aynı tür olmak zorundadır.$$, FALSE, 2),
    ($$Sozluk<Integer, String>, Anahtar alfabetik olarak önce gelmediği için derleme hatasıdır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-generics'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-generics')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$interface Depo<T> {
    void kaydet(T eleman);
    T sonEklenen();
}

class BellekteUrunDeposu implements Depo<String> {
    private String son;
    public void kaydet(String eleman) { this.son = eleman; }
    public String sonEklenen() { return son; }
}

public class Ornek {
    public static void main(String[] args) {
        Depo<String> depo = new BellekteUrunDeposu();
        depo.kaydet("laptop");
        System.out.println(depo.sonEklenen().toUpperCase());
    }
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$interface Depo<T> {
    void kaydet(T eleman);
    T sonEklenen();
}

class BellekteUrunDeposu implements Depo<String> {
    private String son;
    public void kaydet(String eleman) { this.son = eleman; }
    public String sonEklenen() { return son; }
}

public class Ornek {
    public static void main(String[] args) {
        Depo<String> depo = new BellekteUrunDeposu();
        depo.kaydet("laptop");
        System.out.println(depo.sonEklenen().toUpperCase());
    }
}$$, $$java$$,
           $$BellekteUrunDeposu implements Depo<String> gerçek tür argümanını sağlar -- sonEklenen() doğrudan bir String döner, hiçbir cast gerekmez, bu yüzden üzerinde toUpperCase() çağırmak normal şekilde derlenir ve çalışır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'introduction-to-generics'
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
    ($$LAPTOP$$, TRUE, 0),
    ($$laptop$$, FALSE, 1),
    ($$Derleme hatası -- sonEklenen() String değil Object döner.$$, FALSE, 2),
    ($$NullPointerException.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-generics'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: MULTIPLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-generics')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Raw type'lar (örneğin `List<String>` yerine düz `List`) hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Raw type'lar (örneğin `List<String>` yerine düz `List`) hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Bir raw type kullanmak, derleyicinin o kullanım için generics-öncesi davranışa geri düşmesine yol açar, tür-güvenliği faydalarının tamamını sessizce kaybettirir -- tam olarak generics'in önlemek için var olduğu hata sınıfı.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'introduction-to-generics'
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
    ($$Derleyici, o belirli kullanım için generics-öncesi davranışa geri döner.$$, TRUE, 0),
    ($$Generics'in normalde sağladığı tür-güvenliği faydalarını sessizce kaybeder.$$, TRUE, 1),
    ($$Her açıdan List<Object> ile işlevsel olarak birebir aynıdır.$$, FALSE, 2),
    ($$Derleyici, raw bir List'e uyuşmayan bir eleman türü eklemeyi yine de reddeder.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-generics'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-generics')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir `List<Integer>` bildiriliyor ve kod üzerinde `.add("seksen")` çağırmaya çalışıyor. Aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir `List<Integer>` bildiriliyor ve kod üzerinde `.add("seksen")` çağırmaya çalışıyor. Aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Bir List<Integer>'a add("seksen") yapmaya çalışmak basitçe derlenmiyor -- unutulacak bir cast, sonradan gerçekleşmeyi bekleyen bir ClassCastException yok. Bu, generics'in verdiği temel sözdür: pre-generics kodun çektiği hata sınıfı baştan yazılamaz hâle gelir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'introduction-to-generics'
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
    ($$Çağrı derlenmez, çünkü "seksen" eleman türü olan Integer ile eşleşmez.$$, TRUE, 0),
    ($$Bu, tam olarak generics'in derleme zamanında yakalamak için tasarlandığı türden bir hatadır.$$, TRUE, 1),
    ($$Çağrı derlenir, ve hata ancak daha sonra bir ClassCastException olarak ortaya çıkar.$$, FALSE, 2),
    ($$Herhangi bir generic koleksiyonda add(), bildirilen tür argümanından bağımsız olarak her zaman düz bir Object kabul eder.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-generics'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
