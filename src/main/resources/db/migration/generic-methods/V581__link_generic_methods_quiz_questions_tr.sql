-- Promotion-style migration linking TR generic-methods quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generic-methods')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Generic bir metodun tür parametresi, metot bildiriminde nerede görünür?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Generic bir metodun tür parametresi, metot bildiriminde nerede görünür?$$,
           NULL, NULL,
           $$Tür parametresi bir kez, açılı parantezler içinde, dönüş türünden hemen önce görünür -- static <T> T firstElement(...). Yalnızca metoda aittir, çevresindeki sınıfın generic olup olmamasından bağımsızdır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generic-methods'
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
    ($$Açılı parantezler içinde, dönüş türünden hemen önce.$$, TRUE, 0),
    ($$Açılı parantezler içinde, metot adından hemen sonra.$$, FALSE, 1),
    ($$Çevreleyen sınıfta zaten bildirilmiş bir tür parametresiyle eşleşmelidir.$$, FALSE, 2),
    ($$Parametre listesinin sonunda, son parametreden sonra.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generic-methods'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generic-methods')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$class Yardimci {
    static <T> T ilkEleman(List<T> liste) {
        return liste.get(0);
    }
}

public class Ornek {
    public static void main(String[] args) {
        List<String> isimler = List.of("Deniz", "Kaya");
        List<Integer> puanlar = List.of(75, 60);
        String ilkIsim = Yardimci.ilkEleman(isimler);
        Integer ilkPuan = Yardimci.ilkEleman(puanlar);
        System.out.println(ilkIsim + " " + ilkPuan);
    }
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class Yardimci {
    static <T> T ilkEleman(List<T> liste) {
        return liste.get(0);
    }
}

public class Ornek {
    public static void main(String[] args) {
        List<String> isimler = List.of("Deniz", "Kaya");
        List<Integer> puanlar = List.of(75, 60);
        String ilkIsim = Yardimci.ilkEleman(isimler);
        Integer ilkPuan = Yardimci.ilkEleman(puanlar);
        System.out.println(ilkIsim + " " + ilkPuan);
    }
}$$, $$java$$,
           $$Derleyici, her çağrı noktasında geçirilen argümandan T'yi tamamen kendi başına çıkarır -- Yardimci.ilkEleman(isimler), T'yi String olarak çıkarırken, Yardimci.ilkEleman(puanlar), aynı metotta T'yi Integer olarak çıkarır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generic-methods'
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
    ($$Deniz 75$$, TRUE, 0),
    ($$Deniz Deniz$$, FALSE, 1),
    ($$Derleme hatası -- ilkEleman'ın T'si iki çağrı arasında belirsizdir.$$, FALSE, 2),
    ($$75 Deniz$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generic-methods'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generic-methods')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`Yardimci.<String>ilkEleman(isimler)` gibi bir "tür tanığı" (type witness) nedir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`Yardimci.<String>ilkEleman(isimler)` gibi bir "tür tanığı" (type witness) nedir?$$,
           NULL, NULL,
           $$Tür tanığı, generic bir metodun çağrı noktasında sağlanan, çıkarımı geçersiz kılan açık bir tür argümanıdır -- günlük kodda nadiren gereklidir, yalnızca derleyicinin türü kendi başına çıkaramadığı nadir durumlar için vardır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generic-methods'
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
    ($$Çağrı noktasında sağlanan, çıkarımı geçersiz kılan açık bir tür argümanı -- günlük kodda nadiren gereklidir.$$, TRUE, 0),
    ($$Her generic metot çağrısında zorunlu olan bir bildirim.$$, FALSE, 1),
    ($$Çıkarılan türün gerçek argümanla eşleştiğini doğrulayan bir çalışma zamanı kontrolü.$$, FALSE, 2),
    ($$Generic bir metodun hangi türü beklediğini belgeleyen bir yorum.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generic-methods'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generic-methods')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$class Yardimci {
    static <A, B> String ciftiAcikla(A anahtar, B deger) {
        return anahtar + " -> " + deger;
    }
}

public class Ornek {
    public static void main(String[] args) {
        System.out.println(Yardimci.ciftiAcikla("sehir", "Ankara"));
        System.out.println(Yardimci.ciftiAcikla(7, true));
    }
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class Yardimci {
    static <A, B> String ciftiAcikla(A anahtar, B deger) {
        return anahtar + " -> " + deger;
    }
}

public class Ornek {
    public static void main(String[] args) {
        System.out.println(Yardimci.ciftiAcikla("sehir", "Ankara"));
        System.out.println(Yardimci.ciftiAcikla(7, true));
    }
}$$, $$java$$,
           $$ciftiAcikla(A anahtar, B deger), her çağrıda A ve B'yi birbirinden bağımsız olarak çıkarır -- ciftiAcikla("sehir", "Ankara") ve ciftiAcikla(7, true), ikisi de aynı metodun geçerli, birbiriyle ilgisiz kullanımlarıdır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generic-methods'
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
    ($$sehir -> Ankara
7 -> true$$, TRUE, 0),
    ($$Derleme hatası -- A ve B her çağrıda aynı tür olmak zorundadır.$$, FALSE, 1),
    ($$sehir -> Ankara
sehir -> Ankara$$, FALSE, 2),
    ($$Derleme hatası -- ciftiAcikla her A/B çifti için yalnızca bir kez çağrılabilir.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generic-methods'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generic-methods')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$class Kap<T> {
    private T deger;
    Kap(T deger) { this.deger = deger; }
    <U> String birlestir(U diger) {
        return deger + "+" + diger;
    }
}

public class Ornek {
    public static void main(String[] args) {
        Kap<String> k = new Kap<>("X");
        System.out.println(k.birlestir(5));
        System.out.println(k.birlestir(3.14));
    }
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class Kap<T> {
    private T deger;
    Kap(T deger) { this.deger = deger; }
    <U> String birlestir(U diger) {
        return deger + "+" + diger;
    }
}

public class Ornek {
    public static void main(String[] args) {
        Kap<String> k = new Kap<>("X");
        System.out.println(k.birlestir(5));
        System.out.println(k.birlestir(3.14));
    }
}$$, $$java$$,
           $$Kap<T>, T'yi bir kez, tüm instance için String olarak sabitler. Ama birlestir'in U'su her çağrıda yeni baştan belirlenir, T'den tamamen bağımsız olarak -- aynı Kap<String> instance'ı birlestir'i önce bir Integer, sonra bir Double ile çağırır, her çağrı kendi U'sunu alır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generic-methods'
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
    ($$X+5
X+3.14$$, TRUE, 0),
    ($$Derleme hatası -- U, String olan T ile eşleşmek zorundadır.$$, FALSE, 1),
    ($$X+5
İkinci çağrıda derleme hatası, U zaten Integer'a bağlanmıştı.$$, FALSE, 2),
    ($$5+X
3.14+X$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generic-methods'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generic-methods')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir metot, dönüş türünden önce bir `<T>` olmadan `static T sonEleman(List<T> liste) { ... }` şeklinde yazılıyor. Sonuç ne olur?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir metot, dönüş türünden önce bir `<T>` olmadan `static T sonEleman(List<T> liste) { ... }` şeklinde yazılıyor. Sonuç ne olur?$$,
           NULL, NULL,
           $$Dönüş türünden önceki <T> bildirimini unutup static T sonEleman(...) yazmak derlenmez, çünkü T'yi tanıtan hiçbir şey olmadığı için bildirilmemiş bir tür olur.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generic-methods'
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
    ($$Derlenmez -- dönüş türünden önceki <T> atlandığı için T bildirilmemiştir.$$, TRUE, 0),
    ($$Derlenir ve static <T> T sonEleman(List<T> liste) ile birebir aynı davranır.$$, FALSE, 1),
    ($$Derlenir, T'yi Object'in bir takma adı olarak ele alır.$$, FALSE, 2),
    ($$Derlenir ama ilk çağrıda bir exception fırlatır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generic-methods'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generic-methods')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre aşağıdakilerden hangileri önerilen Best Practices'tir? (Uygun olan hepsini seçin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre aşağıdakilerden hangileri önerilen Best Practices'tir? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$Generic davranış bir sınıfın tutacağı bütün bir durum ailesine değil tek bir işleme aitse generic bir sınıf yerine generic bir metodu tercih et; tür çıkarımının işini yapmasına izin ver, derleyici gerçekten çıkaramadığında açık bir tür tanığına başvur.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generic-methods'
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
    ($$Davranış bir durum ailesine değil tek bir işleme aitse, generic bir sınıf yerine generic bir metodu tercih et.$$, TRUE, 0),
    ($$Tür çıkarımının işini yapmasına izin ver -- derleyici gerçekten çıkaramadığında açık bir tür tanığı kullan.$$, TRUE, 1),
    ($$Tür parametresini açık hale getirmek için her generic metot çağrısına bir tür tanığı ekle.$$, FALSE, 2),
    ($$Metotlarından biri bir tür parametresine ihtiyaç duyduğunda tüm sınıfı generic yap.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generic-methods'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
