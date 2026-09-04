-- Promotion-style migration linking TR deep-learning quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.


-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'deep-learning')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$'Deep Learning' ifadesindeki 'deep' (derin) kelimesi neyi ifade eder?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$'Deep Learning' ifadesindeki 'deep' (derin) kelimesi neyi ifade eder?$$,
           NULL, NULL,
           $$'Derin', sinir ağı mimarisinin birçok üst üste yığılmış gizli katmana sahip olmasını ifade eder; çıktının felsefi derinliğiyle, eğitim süresiyle ya da kullanıcının matematik bilgisiyle bir ilgisi yoktur.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'deep-learning'
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
    ($$Eğitim sürecinin son derece uzun sürmesini$$, FALSE, 0),
    ($$Modelleri kullanmak için derin matematik bilgisi gerektirmesini$$, FALSE, 1),
    ($$Kullanılan sinir ağlarının birçok üst üste yığılmış gizli katmana sahip olmasını$$, TRUE, 2),
    ($$Modellerin felsefi açıdan derin çıktılar üretmesini$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'deep-learning'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: CODE_OUTPUT)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'deep-learning')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir node, x1=2 ve x2=1 girdilerini, w1=3 ve w2=-1 ağırlıklarını (bias=0) alıyor ve ReLU aktivasyon fonksiyonunu (ReLU(x) = max(0, x)) kullanıyor. Node'un çıktısı nedir?$$
      AND code_snippet = $$agirlikli_toplam = (x1 * w1) + (x2 * w2) + bias
                  = (2 * 3) + (1 * -1) + 0
                  = 6 - 1
                  = 5
cikti = ReLU(agirlikli_toplam)$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir node, x1=2 ve x2=1 girdilerini, w1=3 ve w2=-1 ağırlıklarını (bias=0) alıyor ve ReLU aktivasyon fonksiyonunu (ReLU(x) = max(0, x)) kullanıyor. Node'un çıktısı nedir?$$,
           $$agirlikli_toplam = (x1 * w1) + (x2 * w2) + bias
                  = (2 * 3) + (1 * -1) + 0
                  = 6 - 1
                  = 5
cikti = ReLU(agirlikli_toplam)$$, $$text$$,
           $$Ağırlıklı toplam (2*3)+(1*-1)+0 = 5'tir; ReLU(5) = max(0, 5) = 5, çünkü 5 zaten pozitiftir ve değiştirilmeden geçer -- diğer seçenekler ReLU'yu ya da aritmetiği yanlış uyguluyor.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'deep-learning'
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
    ($$0, çünkü ReLU pozitif girdiler için her zaman 0 döndürür$$, FALSE, 0),
    ($$-1, çünkü negatif ağırlık w2 baskın gelir$$, FALSE, 1),
    ($$6, çünkü ReLU en yakın girdi değerine yukarı yuvarlar$$, FALSE, 2),
    ($$5, çünkü ReLU pozitif ağırlıklı toplamları değiştirmeden geçirir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'deep-learning'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'deep-learning')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Eğitim sırasında bir sinir ağı bir tahmin yapar, bunu doğru cevapla karşılaştırır ve gelecekteki hatayı azaltmak için ağırlıklarını hafifçe ayarlar. Bu ağırlık ayarlamasını mümkün kılan, birlikte çalışan iki mekanizma hangileridir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Eğitim sırasında bir sinir ağı bir tahmin yapar, bunu doğru cevapla karşılaştırır ve gelecekteki hatayı azaltmak için ağırlıklarını hafifçe ayarlar. Bu ağırlık ayarlamasını mümkün kılan, birlikte çalışan iki mekanizma hangileridir?$$,
           NULL, NULL,
           $$Bir loss function hatayı ölçer, backpropagation her ağırlığın bu hataya ne kadar katkıda bulunduğunu hesaplar ve gradient descent bu bilgiyi kullanarak ağırlıkları hatayı azaltacak şekilde ayarlar -- mekanizma çifti budur; diğer çiftler ilgisiz kavramları adlandırır (tokenization/attention LLM'lere aittir, overfitting/underfitting ise eğitim mekanizması değil ML değerlendirme konularıdır).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'deep-learning'
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
    ($$Backpropagation ve gradient descent$$, TRUE, 0),
    ($$Forward pass ve inference$$, FALSE, 1),
    ($$Tokenization ve attention$$, FALSE, 2),
    ($$Overfitting ve underfitting$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'deep-learning'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'deep-learning')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, hangi sinir ağı türü özellikle görüntüleri işlemek için uygundur?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, hangi sinir ağı türü özellikle görüntüleri işlemek için uygundur?$$,
           NULL, NULL,
           $$Ders özellikle görüntüler için CNN'i (Convolutional Neural Network) adlandırır; RNN sıralı veri için tarif edilmiştir, Transformer ise attention aracılığıyla metin/LLM'lerin temeli olarak ele alınır (özellikle görüntüler için değil), ve 'tüm türler görüntüleri eşit iyi işler' ifadesi dersin açık tür ayrımlarıyla çelişir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'deep-learning'
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
    ($$Hiçbiri -- tüm sinir ağı türleri görüntüleri eşit derecede iyi işler$$, FALSE, 0),
    ($$CNN (Convolutional Neural Network)$$, TRUE, 1),
    ($$RNN (Recurrent Neural Network)$$, FALSE, 2),
    ($$Yalnızca Transformer$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'deep-learning'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'deep-learning')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$RNN'ler bir diziyi adım adım işlerken, Transformer'lar attention kullanarak tüm diziyi paralel olarak işleyebilir. Bu derse göre, bu farkın temel pratik sonucu nedir?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$RNN'ler bir diziyi adım adım işlerken, Transformer'lar attention kullanarak tüm diziyi paralel olarak işleyebilir. Bu derse göre, bu farkın temel pratik sonucu nedir?$$,
           NULL, NULL,
           $$Ders, Transformer'ların paralelleştirilebilir olduğunu (adım adım işleyen RNN'lerin aksine) ve bunun neredeyse her modern LLM'nin temelini oluşturmalarının bir nedeni olduğunu belirtir; RNN daha doğru değil, aşılmış (superseded) olarak tarif edilir ve RNN'nin alanı görüntüler değil sıralı verilerdir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'deep-learning'
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
    ($$İki mimari arasında pratik açıdan anlamlı bir fark yoktur$$, FALSE, 0),
    ($$RNN'ler yalnızca görüntü işleme için kullanılır$$, FALSE, 1),
    ($$Transformer'lar daha paralelleştirilebilirdir, bu da neredeyse her modern LLM'nin temelini oluşturmalarının bir nedenidir$$, TRUE, 2),
    ($$RNN'ler görevden bağımsız olarak her zaman Transformer'lardan daha doğrudur$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'deep-learning'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'deep-learning')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, sinir ağları zaten biliniyor olmasına rağmen, deep learning'in büyük atılımlarının onlarca yıl önce değil de neden yaklaşık 2012'de gerçekleştiğini asıl açıklayan nedir?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, sinir ağları zaten biliniyor olmasına rağmen, deep learning'in büyük atılımlarının onlarca yıl önce değil de neden yaklaşık 2012'de gerçekleştiğini asıl açıklayan nedir?$$,
           NULL, NULL,
           $$Ders, ~2012 dönüm noktasını hem yeterince büyük veri kümelerinin hem de yeterince güçlü GPU işlem gücünün aşağı yukarı aynı dönemde gereken ölçeğe ulaşmasına bağlar; sinir ağları 2012'den çok önce vardı, böyle bir araştırma yasağı hiç olmadı ve ReLU'nun hesaplanabilirliği tarihsel bir engel değildi.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'deep-learning'
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
    ($$Sinir ağları ancak 2012'de icat edildi$$, FALSE, 0),
    ($$Hükümetler 2012'ye kadar sinir ağı araştırmalarını yasakladı$$, FALSE, 1),
    ($$ReLU aktivasyon fonksiyonları 2012'den önce matematiksel olarak hesaplanamıyordu$$, FALSE, 2),
    ($$Hem yeterince büyük veri kümeleri hem de yeterince güçlü GPU işlem gücü, aşağı yukarı aynı dönemde gereken ölçeğe ulaştı$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'deep-learning'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'deep-learning')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, deep learning ve sinir ağları hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, deep learning ve sinir ağları hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derse doğrudan uyar (node hesaplama mekaniği; 2017'de tanıtılan, attention tabanlı Transformer'ın neredeyse her LLM'nin temeli olması); RNN, güncel önerilen state-of-the-art değil, aşılmış (superseded) olarak tarif edilir, ve katmanlar arası kademeli soyutlama fikri (kenardan kavrama) derste açıkça sezgisel olarak işaretlenmiştir, matematiksel olarak garanti edilmiş bir özellik değil.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'deep-learning'
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
    ($$Bir node'un çıktısı, girdilerinin ağırlıklı toplamına bias eklenip bir aktivasyon fonksiyonundan geçirilmesiyle hesaplanır$$, TRUE, 0),
    ($$2017'de tanıtılan ve attention'a dayanan Transformer mimarisi, neredeyse her modern LLM'nin temelini oluşturur$$, TRUE, 1),
    ($$RNN'ler, tüm yeni sıralı-veri projeleri için önerilen güncel state-of-the-art mimaridir$$, FALSE, 2),
    ($$Bir ağdaki daha derin katmanların, 'kenar'a karşı 'kavram' gibi her zaman daha yüksek seviyeli soyutlamaları temsil ettiği matematiksel olarak kanıtlanmıştır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'deep-learning'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
