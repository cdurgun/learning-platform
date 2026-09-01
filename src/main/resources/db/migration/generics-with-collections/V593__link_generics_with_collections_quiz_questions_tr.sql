-- Promotion-style migration linking TR generics-with-collections quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.

-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generics-with-collections')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`List<T>`, `Set<T>` ve `Map<K, V>` için hangi ifade doğrudur?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$`List<T>`, `Set<T>` ve `Map<K, V>` için hangi ifade doğrudur?$$,
           NULL, NULL,
           $$List<T>, Set<T> ve Map<K, V>, "Generics'e Giriş"te işlenen tam olarak aynı mekanizmayla inşa edilmiş, kendileri de sıradan generic türlerdir -- List'in elemanları için bir tür parametresi vardır, Map'in ise ikisi vardır.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generics-with-collections'
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
    ($$Herhangi bir özel generic sınıfla aynı mekanizmayla inşa edilmiş, sıradan generic türlerdir.$$, TRUE, 0),
    ($$Kullanıcı tanımlı generic sınıflardan farklı bir mekanizma kullanan özel dil yapılarıdır.$$, FALSE, 1),
    ($$Yalnızca Map gerçekten generic'tir; List ve Set içeride raw Object referansları saklar.$$, FALSE, 2),
    ($$List<T> ve Set<T>, tüm koleksiyonlar arasında tam olarak aynı T tür parametresini paylaşır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generics-with-collections'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: MULTIPLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generics-with-collections')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir `Map<String, Integer>` bildiriliyor ve kod, bir Integer value beklenirken bir String geçirerek `map.put("defter", "elli")` çağırmayı deniyor. Aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir `Map<String, Integer>` bildiriliyor ve kod, bir Integer value beklenirken bir String geçirerek `map.put("defter", "elli")` çağırmayı deniyor. Aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$"Generics'e Giriş"teki derleme-zamanı kontrolü, her koleksiyon işlemine -- add, put, get -- uygulanır, yalnızca oluşturmaya değil. Bir Integer beklenirken "elli" geçirmek derleme zamanında reddedilir, çünkü Map<String, Integer>'ın put'u bir Integer value bekler.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generics-with-collections'
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
    ($$Çağrı derlenmez, çünkü put(String, Integer) value için bir Integer bekler.$$, TRUE, 0),
    ($$Derleme-zamanı kontrolü yalnızca oluşturmaya değil, her koleksiyon işlemine uygulanır.$$, TRUE, 1),
    ($$Çağrı derlenir, ve uyuşmazlık ancak daha sonra bir ClassCastException olarak ortaya çıkar.$$, FALSE, 2),
    ($$Map.put, bildirilen tür argümanlarından bağımsız olarak value için her zaman düz bir Object kabul eder.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generics-with-collections'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generics-with-collections')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod derlendiğinde ne olur?$$
      AND code_snippet = $$static void sayiEkle(List<Object> liste) {
    liste.add(99);
}

public class Ornek {
    public static void main(String[] args) {
        List<String> kelimeler = new ArrayList<>();
        sayiEkle(kelimeler);
    }
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu kod derlendiğinde ne olur?$$,
           $$static void sayiEkle(List<Object> liste) {
    liste.add(99);
}

public class Ornek {
    public static void main(String[] args) {
        List<String> kelimeler = new ArrayList<>();
        sayiEkle(kelimeler);
    }
}$$, $$java$$,
           $$List<String>'in bir List<Object> beklenen yerde geçirilmesine izin verilseydi, sayiEkle(...), çağıranın yalnızca String'lerden oluştuğuna inandığı bir listeye bir Integer ekleyebilirdi -- tür sisteminin daha sonra yakalamanın hiçbir yolu olmayan, bozulmuş bir söz. Değişmezlik tam olarak bunu önler: sayiEkle(kelimeler) derleme zamanında reddedilir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generics-with-collections'
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
    ($$Derlenmez -- sayiEkle(kelimeler) reddedilir, çünkü List<String>, List<Object> değildir.$$, TRUE, 0),
    ($$Derlenir ve kelimeler'e 99'u ekler, bir List<String>'e bir Integer karıştırır.$$, FALSE, 1),
    ($$Derlenir ama sayiEkle çalıştığında ClassCastException fırlatır.$$, FALSE, 2),
    ($$Derlenir çünkü String ve Object kalıtım yoluyla ilişkilidir.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generics-with-collections'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generics-with-collections')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod ne yazdırır?$$
      AND code_snippet = $$List<Integer> puanlar = new ArrayList<>();
puanlar.add(100);
System.out.println(puanlar.getClass().getSimpleName());$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu kod ne yazdırır?$$,
           $$List<Integer> puanlar = new ArrayList<>();
puanlar.add(100);
System.out.println(puanlar.getClass().getSimpleName());$$, $$java$$,
           $$Diamond operatörü, <>, bir constructor'ın tür argümanını atandığı değişkenden çıkarır -- bir List<Integer> değişkenine atanan new ArrayList<>(), bir ArrayList<Integer> olur. Çalışma zamanında sınıf yalnızca ArrayList'tir (erasure, tür argümanının getSimpleName()'de görünmemesi demektir).$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generics-with-collections'
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
    ($$ArrayList$$, TRUE, 0),
    ($$ArrayList<Integer>$$, FALSE, 1),
    ($$List$$, FALSE, 2),
    ($$Derleme hatası -- diamond operatörü sol tarafta açık bir tür argümanı gerektirir.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generics-with-collections'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generics-with-collections')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$`var isimler = List.of("Ada", "Mert");` ifadesinde `isimler` hangi türe sahiptir?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$`var isimler = List.of("Ada", "Mert");` ifadesinde `isimler` hangi türe sahiptir?$$,
           NULL, NULL,
           $$var, değişkenin kendi türünü sağ taraftaki her neyse ondan çıkarır -- var isimler = List.of("Ada", "Mert"), isimler'e, tamamen List.of(...)'un argümanlarından çıkarılan List<String> türünü verir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generics-with-collections'
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
    ($$List<String>, tamamen List.of(...)'un argümanlarından çıkarılır.$$, TRUE, 0),
    ($$List<Object>, çünkü var her zaman en genel türe genişler.$$, FALSE, 1),
    ($$var'ın kendisi, sonradan herhangi bir atamayı kabul eden, gerçekten türsüz bir değişken.$$, FALSE, 2),
    ($$List<char[]>, çünkü var metin literallerini bir dizi olarak ele alır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generics-with-collections'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: CODE_OUTPUT)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generics-with-collections')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kod derlendiğinde ne olur?$$
      AND code_snippet = $$Map<Integer, String> ogrenciler = new HashMap<>();
ogrenciler.put(101, "Elif");
ogrenciler.put("102", "Can");$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kod derlendiğinde ne olur?$$,
           $$Map<Integer, String> ogrenciler = new HashMap<>();
ogrenciler.put(101, "Elif");
ogrenciler.put("102", "Can");$$, $$java$$,
           $$Bir Map<K, V>'nin tür güvenliği key'leri ve value'ları birbirinden bağımsız olarak kapsar -- put(...), hem kendi key türüne hem value türüne göre kontrol edilir. ogrenciler.put("102", "Can") başarısız olur çünkü "102" (bir String), Map<Integer, String> için geçerli bir key değildir.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generics-with-collections'
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
    ($$Derlenmez -- "102", Map<Integer, String> için geçerli bir key türü değildir.$$, TRUE, 0),
    ($$Derlenir, çünkü "102" herhangi bir tür için geçerli bir key'e otomatik dönüşür.$$, FALSE, 1),
    ($$Derlenir ama çalışma zamanında ClassCastException fırlatır.$$, FALSE, 2),
    ($$Derlenir çünkü Map yalnızca value türünü kontrol eder, key türünü değil.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generics-with-collections'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'generics-with-collections')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre `var` hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre `var` hakkında aşağıdakilerden hangileri doğrudur? (Uygun olan hepsini seçin)$$,
           NULL, NULL,
           $$var, bir değişkenin tüm bildirilen türünü başlatıcısından çıkarır -- yalnızca türü YAZMA ihtiyacını kaldırır; derleyici, sanki açıkça yazılmış gibi onu aynen zorlamaya devam eder. Değişkenin türünü daha az sıkı yapmaz.$$, $$claude-code@anthropic.com$$, '2026-09-01 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'generics-with-collections'
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
    ($$Yalnızca türü açıkça yazma ihtiyacını kaldırır -- derleyici onu aynen zorlamaya devam eder.$$, TRUE, 0),
    ($$Değişkenin tüm türünü derleme zamanında başlatıcısından çıkarır.$$, TRUE, 1),
    ($$Değişkenin türünü daha az sıkı yapar, sonradan daha fazla değerin atanmasına izin verir.$$, FALSE, 2),
    ($$O değişken için derleme-zamanı tür kontrolünü tamamen kaldırır.$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'generics-with-collections'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
