-- Promotion-style migration linking TR wildcards quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'wildcards')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Java generics'te bir wildcard (`?`) için hangi ifade doğrudur?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Java generics'te bir wildcard (`?`) için hangi ifade doğrudur?$$,
           NULL, NULL,
           $$Bir wildcard, generic bir türün belirli bir kullanımında bilinmeyen bir tür argümanının yerini tutar. Bir tür parametresinden (T) farklı olarak, bir wildcard hiçbir zaman bir isim almaz ve yeni generic sınıflar ya da metotlar bildirmek için asla kullanılmaz -- yalnızca generic bir tür kullanılırken görünür.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'wildcards'
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
    ($$Generic bir türün bir kullanım noktasında bilinmeyen bir tür argümanının yerini tutar; asla bir isim almaz ya da yeni bir generic sınıf/metot bildirmek için kullanılmaz.$$, TRUE, 0),
    ($$Generic bir sınıf üzerinde bildirilebilen isimlendirilmiş bir tür parametresidir.$$, FALSE, 1),
    ($$Bir tür argümanı olarak her zaman Object ile aynı anlama gelir.$$, FALSE, 2),
    ($$Yalnızca bir metodun dönüş türünde kullanılabilir, parametre türünde asla kullanılamaz.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'wildcards'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'wildcards')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod derlendiğinde ne olur?$$
      AND code_snippet = $$static double sayilariTopla(List<Number> sayilar) {
    double toplam = 0;
    for (Number n : sayilar) toplam += n.doubleValue();
    return toplam;
}

public class Ornek {
    public static void main(String[] args) {
        List<Double> ondaliklar = List.of(1.5, 2.5);
        System.out.println(sayilariTopla(ondaliklar));
    }
}$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod derlendiğinde ne olur?$$,
           $$static double sayilariTopla(List<Number> sayilar) {
    double toplam = 0;
    for (Number n : sayilar) toplam += n.doubleValue();
    return toplam;
}

public class Ornek {
    public static void main(String[] args) {
        List<Double> ondaliklar = List.of(1.5, 2.5);
        System.out.println(sayilariTopla(ondaliklar));
    }
}$$, $$java$$,
           $$Java generics değişmezdir: Double bir Number OLSA bile, List<Double>, bir List<Number> DEĞİLDİR -- ikisi tamamen ilgisiz iki tür olarak ele alınır. sayilariTopla(List<Number> sayilar), yalnızca tam olarak List<Number> olan bir parametreyi kabul eder, bu yüzden bir List<Double> geçirmek doğrudan reddedilir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'wildcards'
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
    ($$Derlenmez -- List<Double>, Double bir Number OLSA bile bir List<Number> değildir.$$, TRUE, 0),
    ($$Derlenir ve 4.0 yazdırır.$$, FALSE, 1),
    ($$Derlenir ama çalışma zamanında ClassCastException fırlatır.$$, FALSE, 2),
    ($$Derlenir ve elemanlar genişletilemediği için 0.0 yazdırır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'wildcards'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'wildcards')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir metot bir `List<?>` parametresi kabul ediyor, üzerinde `.size()` çağırıyor, sonra aynı parametre üzerinde `.add("yeni eleman")` çağırmayı deniyor. Ne olur?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir metot bir `List<?>` parametresi kabul ediyor, üzerinde `.size()` çağırıyor, sonra aynı parametre üzerinde `.add("yeni eleman")` çağırmayı deniyor. Ne olur?$$,
           NULL, NULL,
           $$Düz <?>, ne Object'in ötesinde anlamlı bir get'e ne de herhangi bir add'e izin verir -- derleyicinin listenin gerçek eleman türünü bilmesinin bir yolu yoktur, bu yüzden add(...) çağrısı reddedilir, size() ise sorunsuz derlenir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'wildcards'
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
    ($$add(...) çağrısı derlenmez, çünkü derleyicinin listenin gerçek eleman türünü bilmesinin bir yolu yoktur.$$, TRUE, 0),
    ($$Her iki çağrı da derlenir -- List<?>, yazma açısından List<Object> gibi davranır.$$, FALSE, 1),
    ($$Her iki çağrı da derlenmez, çünkü size() de bilinen bir eleman türü gerektirir.$$, FALSE, 2),
    ($$add(...) çağrısı derlenir ama çalışma zamanında sessizce hiçbir şey yapmaz.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'wildcards'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'wildcards')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod derlendiğinde ne olur?$$
      AND code_snippet = $$static double ortalamaHesapla(List<? extends Number> sayilar) {
    double toplam = 0;
    for (Number n : sayilar) toplam += n.doubleValue();
    sayilar.add(1);
    return toplam / sayilar.size();
}$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu kod derlendiğinde ne olur?$$,
           $$static double ortalamaHesapla(List<? extends Number> sayilar) {
    double toplam = 0;
    for (Number n : sayilar) toplam += n.doubleValue();
    sayilar.add(1);
    return toplam / sayilar.size();
}$$, $$java$$,
           $$List<? extends Number>, yalnızca GÜVENLİ bir şekilde okumana izin verir (her eleman en azından bir Number olmayı garanti eder). GÜVENLİ OLMAYAN şey eklemektir: derleyicinin listenin gerçek eleman türünü bilmesinin bir yolu yoktur (özellikle bir List<Double> olabilir), bu yüzden sayilar.add(1) reddedilir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'wildcards'
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
    ($$Derlenmez -- sayilar.add(1), bir List<? extends Number> üzerinde izin verilmez.$$, TRUE, 0),
    ($$Derlenir ve listeye 1'i de ekleyip ortalamayı döner.$$, FALSE, 1),
    ($$Yalnızca çağıran özellikle bir List<Integer> geçirirse derlenir.$$, FALSE, 2),
    ($$Derlenir ama add(1) çalışma zamanında ClassCastException fırlatır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'wildcards'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'wildcards')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod derlendiğinde ne olur?$$
      AND code_snippet = $$static void ikidenOnaEkle(List<? super Integer> liste) {
    for (int i = 2; i <= 10; i += 2) liste.add(i);
    Integer ilk = liste.get(0);
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu kod derlendiğinde ne olur?$$,
           $$static void ikidenOnaEkle(List<? super Integer> liste) {
    for (int i = 2; i <= 10; i += 2) liste.add(i);
    Integer ilk = liste.get(0);
}$$, $$java$$,
           $$List<? super Integer>, liste gerçekte Integer'ın hangi süper türünü tutuyor olursa olsun bir Integer'ı GÜVENLİ bir şekilde yazmana izin verir. GÜVENLİ OLMAYAN şey belirli bir türü geri okumaktır: derleyici yalnızca listenin Integer'ın BİR süper türünü tuttuğunu garanti eder, bu Object kadar geniş olabilir, bu yüzden liste.get(0) yalnızca Object olarak ele alınabilir -- doğrudan bir Integer değişkenine atamak derlenmez.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'wildcards'
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
    ($$Derlenmez -- liste.get(0), Object döner, bu doğrudan bir Integer değişkenine atanamaz.$$, TRUE, 0),
    ($$Derlenir ve ilk'e 2 atar.$$, FALSE, 1),
    ($$Bunun yerine liste.add(i) satırında derlenmez, çünkü listenin gerçek türü bilinmez.$$, FALSE, 2),
    ($$Derlenir ama get(0) çağrıldığında ClassCastException fırlatır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'wildcards'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'wildcards')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir metot bir `List<T>` parametresine yalnızca eleman YAZAR, hiçbir zaman ondan okumaz. PECS'e göre hangi wildcard formunu kullanmalı?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir metot bir `List<T>` parametresine yalnızca eleman YAZAR, hiçbir zaman ondan okumaz. PECS'e göre hangi wildcard formunu kullanmalı?$$,
           NULL, NULL,
           $$PECS: "Producer Extends, Consumer Super." Parametrelenmiş bir tür yalnızca senden değer TÜKETİYORSA (yalnızca ona yazıyorsan), super kullan -- tam olarak addOneToFive(...)'ın oynadığı rol.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'wildcards'
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
    ($$List<? super T> -- bir tüketicidir, bu yüzden super uygulanır.$$, TRUE, 0),
    ($$List<? extends T> -- bir üreticidir, bu yüzden extends uygulanır.$$, FALSE, 1),
    ($$List<?> -- sınırsız bir wildcard, çünkü metot hiç okumaz.$$, FALSE, 2),
    ($$Hiç wildcard olmadan List<T>, çünkü PECS yalnızca-yazan parametrelere hiç uygulanmaz.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'wildcards'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'wildcards')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre wildcard kullanımıyla ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre wildcard kullanımıyla ilgili aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$copy(List<? extends T> src, List<? super T> dest), AYNI ANDA HER İKİ role de ihtiyaç duyar: src bir üreticidir (extends), dest bir tüketicidir (super). Bir wildcard bir dönüş türüne asla eklenmemelidir -- her çağıranı bilinmeyen bir türle uğraşmaya zorlar, PECS'in hiçbir faydası olmadan.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'wildcards'
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
    ($$Bir listeden okuyup başka bir listeye yazan bir metot, kaynak için extends, hedef için super kullanabilir.$$, TRUE, 0),
    ($$Bir wildcard bir metodun dönüş türüne asla eklenmemelidir.$$, TRUE, 1),
    ($$List<? super T>, listeden belirli bir T'yi güvenilir biçimde geri okumak için kullanılabilir.$$, FALSE, 2),
    ($$Bir parametrenin aynı belirli türle hem okunması hem yazılması gerekiyorsa, wildcard yine de doğru araçtır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'wildcards'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
