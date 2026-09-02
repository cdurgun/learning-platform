-- Promotion-style migration linking TR optional quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: CODE_OUTPUT)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'optional')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod çalıştığında ne olur?$$
      AND code_snippet = $$import java.util.Optional;

public class Ornek {
    public static void main(String[] args) {
        String deger = null;
        Optional<String> opt = Optional.ofNullable(deger);
        System.out.println(opt.isEmpty());
        Optional<String> opt2 = Optional.of(deger);
    }
}$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu kod çalıştığında ne olur?$$,
           $$import java.util.Optional;

public class Ornek {
    public static void main(String[] args) {
        String deger = null;
        Optional<String> opt = Optional.ofNullable(deger);
        System.out.println(opt.isEmpty());
        Optional<String> opt2 = Optional.of(deger);
    }
}$$, $$java$$,
           $$Optional.ofNullable(deger), null olabilecek bir değeri güvenle sarmalar, null ise boş bir Optional üretir -- bu yüzden isEmpty() true yazdırır. Optional.of(deger) ise değerin asla null olmayacağını varsayar -- null verildiğinde hemen NullPointerException fırlatır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'optional'
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
    ($$false yazdırır, sonra NullPointerException fırlatır.$$, FALSE, 0),
    ($$true yazdırır, sonra Optional.of(deger)'de NullPointerException fırlatır.$$, TRUE, 1),
    ($$true, sonra false yazdırır.$$, FALSE, 2),
    ($$ofNullable'da hemen NullPointerException fırlatır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'optional'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'optional')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$import java.util.Optional;

public class Ornek {
    static String hesapla() {
        System.out.println("hesaplaniyor");
        return "varsayilan";
    }
    public static void main(String[] args) {
        Optional<String> dolu = Optional.of("deger");
        System.out.println(dolu.orElseGet(Ornek::hesapla));
    }
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.Optional;

public class Ornek {
    static String hesapla() {
        System.out.println("hesaplaniyor");
        return "varsayilan";
    }
    public static void main(String[] args) {
        Optional<String> dolu = Optional.of("deger");
        System.out.println(dolu.orElseGet(Ornek::hesapla));
    }
}$$, $$java$$,
           $$orElseGet()'in Supplier'ı yalnızca Optional boş çıkarsa çağrılır. dolu zaten bir değere sahip olduğu için hesapla() hiç çalışmaz.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'optional'
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
    ($$hesaplaniyor
deger$$, FALSE, 0),
    ($$hesaplaniyor
varsayilan$$, FALSE, 1),
    ($$varsayilan$$, FALSE, 2),
    ($$deger$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'optional'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'optional')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Zaten bir değere sahip bir Optional üzerinde `orElseThrow(Supplier<X>)` çağrıldığında, verilen Supplier'a ne olur?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Zaten bir değere sahip bir Optional üzerinde `orElseThrow(Supplier<X>)` çağrıldığında, verilen Supplier'a ne olur?$$,
           NULL, NULL,
           $$Optional bir değere sahipse, Supplier hiç çağrılmaz -- tıpkı orElseGet()'in lazy-evaluation mantığı gibi.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'optional'
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
    ($$orElseThrow()'un ne zaman çağrıldığından bağımsız olarak, her Optional instance'ı için tam olarak bir kez çağrılır.$$, FALSE, 0),
    ($$Hiç çağrılmaz -- tıpkı orElseGet()'in lazy-evaluation mantığı gibi.$$, TRUE, 1),
    ($$Her zaman çağrılır, ama sonucu göz ardı edilir.$$, FALSE, 2),
    ($$Değer olsun ya da olmasın istisnayı hemen fırlatır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'optional'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'optional')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$import java.util.Optional;

public class Ornek {
    static Optional<Integer> ayristir(String s) {
        try {
            return Optional.of(Integer.parseInt(s));
        } catch (NumberFormatException e) {
            return Optional.empty();
        }
    }
    public static void main(String[] args) {
        Optional<String> girdi = Optional.of("17");
        Optional<Integer> sonuc = girdi.flatMap(Ornek::ayristir);
        System.out.println(sonuc.get());
    }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.Optional;

public class Ornek {
    static Optional<Integer> ayristir(String s) {
        try {
            return Optional.of(Integer.parseInt(s));
        } catch (NumberFormatException e) {
            return Optional.empty();
        }
    }
    public static void main(String[] args) {
        Optional<String> girdi = Optional.of("17");
        Optional<Integer> sonuc = girdi.flatMap(Ornek::ayristir);
        System.out.println(sonuc.get());
    }
}$$, $$java$$,
           $$flatMap(), ayristir()'in döndürdüğü iç Optional'ı, garip bir Optional<Optional<Integer>> üretmek yerine doğrudan dış Optional'a birleştirir.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'optional'
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
    ($$Optional[17]$$, FALSE, 0),
    ($$Derleme hatası -- flatMap, Optional değil düz bir değer döndüren bir Function gerektirir.$$, FALSE, 1),
    ($$NoSuchElementException fırlatır.$$, FALSE, 2),
    ($$17$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'optional'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: MULTIPLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'optional')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`ifPresent()` ve `ifPresentOrElse()` hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`ifPresent()` ve `ifPresentOrElse()` hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$ifPresent(Consumer), açık bir null kontrolüne gerek kalmadan, yalnızca bir değer varsa bir yan etki çalıştırır. ifPresentOrElse(Consumer, Runnable), ifPresent()'in tek başına ifade edemediği, boş durum için bir dal ekler.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'optional'
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
    ($$ifPresentOrElse(), her iki dalın da aynı türü döndürmesini gerektirir.$$, FALSE, 0),
    ($$ifPresent(Consumer), açık bir null kontrolüne gerek kalmadan, yalnızca bir değer varsa bir yan etki çalıştırır.$$, TRUE, 1),
    ($$ifPresentOrElse(Consumer, Runnable), ifPresent()'in tek başına ifade edemediği, boş durum için bir dal ekler.$$, TRUE, 2),
    ($$ifPresent(), Optional boş olsa bile Consumer'ını null geçirerek çalıştırır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'optional'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'optional')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$import java.util.Optional;

public class Ornek {
    public static void main(String[] args) {
        Optional<Integer> sayi = Optional.of(20);
        Optional<Integer> filtrelenmis = sayi.filter(n -> n > 10);
        System.out.println(filtrelenmis.isPresent());
    }
}$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$import java.util.Optional;

public class Ornek {
    public static void main(String[] args) {
        Optional<Integer> sayi = Optional.of(20);
        Optional<Integer> filtrelenmis = sayi.filter(n -> n > 10);
        System.out.println(filtrelenmis.isPresent());
    }
}$$, $$java$$,
           $$filter(Predicate), değeri yalnızca koşulu sağlıyorsa tutar -- aksi halde dolu bir Optional'ı boşa çevirir. 20, 10'dan büyük olduğu için filtrelenmis dolu kalır.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'optional'
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
    ($$false$$, FALSE, 0),
    ($$NoSuchElementException fırlatır.$$, FALSE, 1),
    ($$Derleme hatası.$$, FALSE, 2),
    ($$true$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'optional'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: SINGLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'optional')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu dersin Best Practices bölümüne göre, `Optional` nerede kullanılmalıdır?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu dersin Best Practices bölümüne göre, `Optional` nerede kullanılmalıdır?$$,
           NULL, NULL,
           $$Optional'ın tasarım amacı yalnızca "bu metot bir değer döndürmeyebilir" mesajını iletmektir -- bir alan türü, metot parametresi ya da koleksiyon eleman türü olarak kullanmak yaygın olarak önerilmez.$$, $$claude-code@anthropic.com$$, '2026-09-02 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'optional'
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
    ($$Yalnızca bir metot parametresi olarak, asla dönüş türü olarak değil.$$, FALSE, 0),
    ($$Yalnızca bir metot dönüş türü olarak -- bir alan türü, metot parametresi ya da koleksiyon eleman türü olarak kullanmak yaygın olarak önerilmez.$$, TRUE, 1),
    ($$Eksik bir değere sahip olabilecek her sınıfta bir alan türü olarak.$$, FALSE, 2),
    ($$Elemanlar eksik olabildiğinde bir List'in eleman türü olarak.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'optional'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
