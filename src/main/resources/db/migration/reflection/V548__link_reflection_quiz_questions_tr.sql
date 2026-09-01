-- Promotion-style migration linking TR Reflection quiz questions to the
-- topic's fixed quiz created in reflection/V546 -- same pattern as V547.
-- All 7 TR questions from question-promotion/V545 (hand-authored and
-- self-reviewed -- no n8n, no OpenAI, no AI Judge, and NOT translations of
-- the EN set -- each independently authored to test the same concept as
-- its EN counterpart with different classes/fields/methods or framing).

-- Question 1/7 (Pair 1 TR, quiz position 1, type: CODE_OUTPUT)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'reflection')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$Class<?> a = Integer.valueOf(5).getClass();
Class<?> b = Integer.class;
System.out.println(a == b);$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$Class<?> a = Integer.valueOf(5).getClass();
Class<?> b = Integer.class;
System.out.println(a == b);$$, $$java$$,
           $$JVM, her sınıf/classloader çifti için yalnızca bir tane Class örneği tutar -- obj.getClass() ve Tip.class her zaman aynı nesneyi döner, bu yüzden equals() çağırmadan bile a == b true olur.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'reflection'
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
    ($$Bir istisna fırlatır.$$, FALSE, 2),
    ($$Sonuç her çalıştırmada farklı olabilir.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'reflection'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: MULTIPLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'reflection')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$getFields() ve getDeclaredFields() hakkında aşağıdaki ifadelerden hangileri doğrudur?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$getFields() ve getDeclaredFields() hakkında aşağıdaki ifadelerden hangileri doğrudur?$$, NULL, NULL,
           $$getDeclaredFields(), erişim belirleyicisi ne olursa olsun yalnızca o sınıfın kendi alanlarını döner; getFields() ise üst sınıflardan miras alınanlar dahil yalnızca public alanları döner. İki metot da miras/erişim eksenlerinde birbirinin tersi davranır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'reflection'
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
    ($$getDeclaredFields(), erişim belirleyicisi ne olursa olsun, yalnızca o sınıfın kendi içinde tanımlanan alanları döner.$$, TRUE, 0),
    ($$getFields(), üst sınıflardan miras alınanlar dahil, yalnızca public alanları döner.$$, TRUE, 1),
    ($$getFields(), sınıfın kendi private alanlarını da içerir.$$, FALSE, 2),
    ($$getDeclaredFields(), üst sınıftan miras alınan alanları da içerir.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'reflection'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'reflection')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Hiçbir metot tanımlamayan boş bir sınıf üzerinde getMethods() çağırdığınızda neden boş olmayan bir dizi dönmesi beklenir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Hiçbir metot tanımlamayan boş bir sınıf üzerinde getMethods() çağırdığınızda neden boş olmayan bir dizi dönmesi beklenir?$$, NULL, NULL,
           $$getMethods(), Object sınıfından miras alınan toString(), equals(), hashCode() gibi public metotları da içerir -- bu yüzden basit bir sınıf için bile liste beklenenden büyük çıkar.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'reflection'
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
    ($$Çünkü getMethods(), Object sınıfından miras alınan toString(), equals(), hashCode() gibi public metotları da içerir.$$, TRUE, 0),
    ($$Çünkü derleyici her sınıf için otomatik olarak sentetik accessor metotları üretir.$$, FALSE, 1),
    ($$Çünkü getMethods(), hiç metot bulunamazsa hata fırlatır.$$, FALSE, 2),
    ($$Çünkü Java her sınıfın en az bir public metot tanımlamasını zorunlu kılar.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'reflection'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'reflection')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Class.newInstance() metodunun Java 9'dan beri deprecated olmasının gerekçeleri arasında aşağıdakilerden hangisi yer alır?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Class.newInstance() metodunun Java 9'dan beri deprecated olmasının gerekçeleri arasında aşağıdakilerden hangisi yer alır?$$, NULL, NULL,
           $$Class.newInstance(), constructor'ın checked exception'larını sarmalamadan doğrudan fırlatır (derleyicinin checked-exception kontrolünü atlar) ve private/protected constructor'lar için erişim kontrolünü Constructor.newInstance() kadar tutarlı uygulamaz.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'reflection'
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
    ($$Constructor'ın checked exception'larını sarmalamadan doğrudan fırlatır ve private/protected constructor'lar için erişim kontrolünü Constructor.newInstance() kadar tutarlı uygulamaz.$$, TRUE, 0),
    ($$Constructor.newInstance()'a göre önemli ölçüde daha yavaştır.$$, FALSE, 1),
    ($$Package-private constructor'a sahip sınıflar için nesne oluşturamaz.$$, FALSE, 2),
    ($$Java 9'da tamamen kaldırılmıştır, artık derlenmez.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'reflection'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: CODE_OUTPUT)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'reflection')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$class Bolucu {
    public int bol(int a, int b) {
        return a / b;
    }
}

Method m = Bolucu.class.getMethod("bol", int.class, int.class);
try {
    m.invoke(new Bolucu(), 20, 0);
} catch (ArithmeticException e) {
    System.out.println("ArithmeticException yakalandi");
} catch (java.lang.reflect.InvocationTargetException e) {
    System.out.println("InvocationTargetException yakalandi");
}$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$class Bolucu {
    public int bol(int a, int b) {
        return a / b;
    }
}

Method m = Bolucu.class.getMethod("bol", int.class, int.class);
try {
    m.invoke(new Bolucu(), 20, 0);
} catch (ArithmeticException e) {
    System.out.println("ArithmeticException yakalandi");
} catch (java.lang.reflect.InvocationTargetException e) {
    System.out.println("InvocationTargetException yakalandi");
}$$, $$java$$,
           $$Method.invoke(), çağrılan metodun kendi istisnasının doğrudan dışarı sızmasına asla izin vermez -- her zaman InvocationTargetException içine sarmalar. bol() içinde fırlatılan ArithmeticException ilk catch bloğuyla eşleşmez, bu yüzden InvocationTargetException catch bloğuna düşer.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'reflection'
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
    ($$ArithmeticException yakalandi$$, FALSE, 0),
    ($$InvocationTargetException yakalandi$$, TRUE, 1),
    ($$Program yakalanmamış bir istisnayla çöker.$$, FALSE, 2),
    ($$Her iki mesaj da yazdırılır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'reflection'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'reflection')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır? (setAccessible(true) çağrısı yapılmadığını varsayın.)$$
      AND code_snippet = $$class Gizli {
    private String kod = "9876";
}

Field f = Gizli.class.getDeclaredField("kod");
try {
    Object deger = f.get(new Gizli());
    System.out.println(deger);
} catch (IllegalAccessException e) {
    System.out.println("erisim reddedildi");
}$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır? (setAccessible(true) çağrısı yapılmadığını varsayın.)$$,
           $$class Gizli {
    private String kod = "9876";
}

Field f = Gizli.class.getDeclaredField("kod");
try {
    Object deger = f.get(new Gizli());
    System.out.println(deger);
} catch (IllegalAccessException e) {
    System.out.println("erisim reddedildi");
}$$, $$java$$,
           $$Önce setAccessible(true) çağrılmadan, private bir alanı reflection ile okumak IllegalAccessException fırlatır -- bu çağrıyı unutmak en yaygın reflection hatalarından biridir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'reflection'
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
    ($$9876$$, FALSE, 0),
    ($$erisim reddedildi$$, TRUE, 1),
    ($$Program yakalanmamış bir istisnayla çöker.$$, FALSE, 2),
    ($$null$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'reflection'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'reflection')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir annotation'ı reflection ile okumaya çalıştığınızda isAnnotationPresent() her zaman false dönüyor, ama kod hatasız derleniyor ve annotation kaynak kodda görünüyor. Bunun en olası nedeni nedir?$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir annotation'ı reflection ile okumaya çalıştığınızda isAnnotationPresent() her zaman false dönüyor, ama kod hatasız derleniyor ve annotation kaynak kodda görünüyor. Bunun en olası nedeni nedir?$$, NULL, NULL,
           $$Annotation tanımında @Retention(RetentionPolicy.RUNTIME) eksik (ya da varsayılan CLASS düzeyinde bırakılmış) -- bu yüzden annotation derlenmiş sınıf dosyasında kalsa da JVM çalışırken reflection'a görünmez.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'reflection'
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
    ($$Annotation tanımında @Retention(RetentionPolicy.RUNTIME) eksik (ya da varsayılan CLASS düzeyinde bırakılmış).$$, TRUE, 0),
    ($$isAnnotationPresent() metodu yanlış çağrılmıştır, parametre sırası ters.$$, FALSE, 1),
    ($$Annotation'ın hedef (target) tipi yanlış tanımlanmıştır.$$, FALSE, 2),
    ($$Reflection API'si yalnızca sınıf düzeyinde annotation okuyabilir, metot düzeyinde okuyamaz.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'reflection'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
