-- Promotion-style migration linking TR how-llms-work quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.


-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'how-llms-work')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir Large Language Model (LLM), mekanik olarak nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bir Large Language Model (LLM), mekanik olarak nedir?$$,
           NULL, NULL,
           $$Bu, dersin tanımıyla birebir örtüşür: önceki metin göz önüne alındığında bir sonraki token'ı tahmin etmek için devasa ölçekte eğitilmiş, transformer tabanlı bir sinir ağı; diğer seçenekler ilgisiz, öğrenmeye dayanmayan sistemleri tarif eder (elle yazılmış kurallar, arama veritabanı, arama motoru).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'how-llms-work'
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
    ($$Yaygın sorulara önceden yazılmış cevapları arayan bir veritabanı$$, FALSE, 0),
    ($$Var olan web sayfalarını getirip sıralayan bir arama motoru$$, FALSE, 1),
    ($$Önceki metin göz önüne alındığında bir sonraki token'ı tahmin etmek için devasa ölçekte eğitilmiş, transformer tabanlı bir sinir ağı$$, TRUE, 2),
    ($$Dil için binlerce elle yazılmış if/else ifadesine sahip, kurala dayalı bir sistem$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'how-llms-work'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'how-llms-work')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$LLM'lerden önce, NLP sistemleri neden genellikle her görev (çeviri, duygu analizi, özetleme) için ayrı bir model gerektiriyordu?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$LLM'lerden önce, NLP sistemleri neden genellikle her görev (çeviri, duygu analizi, özetleme) için ayrı bir model gerektiriyordu?$$,
           NULL, NULL,
           $$Bu derse uyar: dar (narrow) yapay zeka yaklaşımında her görevin kendi etiketlenmiş veri kümesine ve eğitim sürecine ihtiyacı vardı; LLM'ler bunu birçok görevi ele alabilen tek bir önceden eğitilmiş genel modelle değiştirdi -- diğer seçenekler yanlış ya da uydurmadır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'how-llms-work'
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
    ($$Çünkü bilgisayarlar fiziksel olarak birden fazla model türü çalıştıramıyordu$$, FALSE, 0),
    ($$Çünkü dilin kendisi görevler arasında tamamen değişir$$, FALSE, 1),
    ($$Çünkü tek bir genel model inşa etmek teknik olarak her zaman imkansız olmuştur$$, FALSE, 2),
    ($$Çünkü dar (narrow) yapay zeka yaklaşımında her görevin kendi etiketlenmiş veri kümesine ve eğitim sürecine ihtiyacı vardı$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'how-llms-work'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'how-llms-work')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Pretraining sırasında bir modele devasa miktarda metin gösterilir ve her bir parça için bir sonraki token'ı tahmin etmesi istenir; yanlış tahmin edince ağırlıkları ayarlanır. Bu derse göre bu süreç modele neyi öğretir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Pretraining sırasında bir modele devasa miktarda metin gösterilir ve her bir parça için bir sonraki token'ı tahmin etmesi istenir; yanlış tahmin edince ağırlıkları ayarlanır. Bu derse göre bu süreç modele neyi öğretir?$$,
           NULL, NULL,
           $$Ders, dilbilgisini, gerçekleri (knowledge cutoff'una kadar), akıl yürütme kalıplarını ve hatta programlama dillerini, bir sonraki token'ı tahmin etmede daha iyi olmanın yan etkisi olarak açıkça listeler; sohbet yeteneği ise özellikle sonraki bir aşamadan (instruction tuning) gelir, pretraining'den değil -- bu yüzden yalnızca 'yazım/noktalama' ya da 'hiçbir yararlı şey' değildir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'how-llms-work'
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
    ($$Dilbilgisini, dünya hakkındaki gerçekleri (knowledge cutoff'una kadar), yaygın akıl yürütme kalıplarını ve hatta programlama dillerini -- hepsi bir sonraki token'ı tahmin etmede daha iyi olmanın yan etkisi olarak$$, TRUE, 0),
    ($$Yalnızca yazım ve noktalama kurallarını, başka hiçbir şeyi$$, FALSE, 1),
    ($$Yalnızca karşılıklı bir sohbet yürütmeyi, çünkü bu açık eğitim hedefidir$$, FALSE, 2),
    ($$Hiçbir yararlı şeyi, çünkü pretraining ilgisiz bir hazırlık adımı olarak tanımlanır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'how-llms-work'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'how-llms-work')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$'Bu e-postayı özetle' talimatı verildiğinde, ham bir temel (base) model (pretraining sonrası başka bir eğitim almamış) gerçekten özetlemek yerine başka ilgisiz talimatlardan oluşan bir liste ile devam edebilir. Bu neden olur ve genellikle bunu ne düzeltir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$'Bu e-postayı özetle' talimatı verildiğinde, ham bir temel (base) model (pretraining sonrası başka bir eğitim almamış) gerçekten özetlemek yerine başka ilgisiz talimatlardan oluşan bir liste ile devam edebilir. Bu neden olur ve genellikle bunu ne düzeltir?$$,
           NULL, NULL,
           $$Bu, dersin base model ile instruction-tuned model ayrımına doğrudan uyar: bir base model yalnızca metni akıcı biçimde sürdürür, instruction tuning (ek bir eğitim aşaması) ise bunun yerine talimatları güvenilir şekilde takip etmeyi öğretir; bu 'bozuk bir model' değildir, talimat takibi varsayılan olarak evrensel değildir ve context window boyutuyla ilgisi yoktur.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'how-llms-work'
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
    ($$Çözüm, modele daha büyük bir context window vermektir$$, FALSE, 0),
    ($$Bir base model yalnızca metni akıcı biçimde sürdürür; instruction tuning (ek bir eğitim aşaması), bir modele bunun yerine talimatları güvenilir şekilde takip etmeyi öğretir$$, TRUE, 1),
    ($$Model bozuktur ve farklı bir veriyle sıfırdan yeniden eğitilmesi gerekir$$, FALSE, 2),
    ($$Bu aslında base modellerin başına hiç gelmez -- tüm modeller varsayılan olarak talimatları eşit derecede iyi takip eder$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'how-llms-work'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'how-llms-work')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir kullanıcı bir konuşma içinde bir LLM'e uydurma bir kelime öğretiyor ve model, hiçbir yeniden eğitim gerçekleşmeden, aynı konuşmanın ilerleyen kısmında bu kelimeyi doğru şekilde kullanıyor. Bu davranışı ne açıklar?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir kullanıcı bir konuşma içinde bir LLM'e uydurma bir kelime öğretiyor ve model, hiçbir yeniden eğitim gerçekleşmeden, aynı konuşmanın ilerleyen kısmında bu kelimeyi doğru şekilde kullanıyor. Bu davranışı ne açıklar?$$,
           NULL, NULL,
           $$Ders, in-context learning'i, sıfır ağırlık değişikliğiyle bir konuşma içinde davranışı uyarlamak olarak açıkça tanımlar; bu, o ana kadarki tüm konuşmanın her yanıtta girdi olarak yeniden beslenmesiyle olur -- diğer seçenekler dersin açıkça dışladığı mekanizmaları tarif eder (kalıcı ağırlık güncellemeleri, sessiz yeniden eğitim, kalıcı bir bellek veritabanı).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'how-llms-work'
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
    ($$Modeli çalıştıran şirket, her mesajdan sonra onu sessizce yeniden eğitir$$, FALSE, 0),
    ($$Modelin, konuşmalar sırasında yazdığı ayrı, kalıcı bir bellek veritabanı vardır$$, FALSE, 1),
    ($$In-context learning: modelin ağırlıkları hiç değişmez; bunun yerine, o ana kadarki tüm konuşma her yanıtta girdi olarak yeniden beslenir ve dondurulmuş, önceden eğitilmiş model örüntüyü tanır$$, TRUE, 2),
    ($$Modelin ağırlıkları konuşma sırasında gerçek zamanlı olarak kalıcı şekilde güncellenir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'how-llms-work'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'how-llms-work')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, 'context' (bağlam) nedir ve neden önemlidir?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, 'context' (bağlam) nedir ve neden önemlidir?$$,
           NULL, NULL,
           $$Ders, context'i geniş şekilde tanımlar (talimatlar, arka plan bilgisi, konuşma geçmişi ve o ana kadar üretilmiş metin) ve inference sırasında hiçbir öğrenme gerçekleşmediği için, inference zamanında bir LLM'nin davranışının şekillendirilebileceği TEK kanal olduğunu belirtir -- diğer seçenekler bu tanımı daraltır ya da yanlış yerleştirir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'how-llms-work'
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
    ($$Context yalnızca system prompt'tur, modelin gördüğü başka hiçbir şey değildir$$, FALSE, 0),
    ($$Context, modelin yalnızca pretraining sırasında sorguladığı ayrı bir veritabanıdır$$, FALSE, 1),
    ($$Context yalnızca görüntü üretim modelleri için önemlidir, metin tabanlı LLM'ler için değil$$, FALSE, 2),
    ($$Context, modelin bir sonraki token'ı üretmeden önce gerçekten gördüğü tüm metindir ve inference zamanında bir LLM'nin davranışının şekillendirilebileceği tek kanaldır$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'how-llms-work'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'how-llms-work')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, LLM'lerin nasıl çalıştığıyla ilgili aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, LLM'lerin nasıl çalıştığıyla ilgili aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (knowledge cutoff'un pretraining verisinin toplandığı zamanın doğrudan bir sonucu olması; scaling law'ların boyut/veri/compute birlikte arttıkça performansın öngörülebilir şekilde iyileşmesini tanımlaması); instruction tuning, devreye almadan önce tamamlanan bir eğitim-zamanı aşamasıdır, her konuşma sırasında canlı gerçekleşen bir şey değildir (bu, in-context learning'dir), ve base ile instruction-tuned modellerin farklı davrandığı açıkça belirtilir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'how-llms-work'
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
    ($$Bir modelin knowledge cutoff'u, keyfi bir kısıtlama değil, pretraining verisinin ne zaman toplandığının doğrudan bir sonucudur$$, TRUE, 0),
    ($$Scaling law'lar, model boyutu, veri ve compute birlikte arttıkça performansın genellikle iyileştiği gözlemlenen örüntüyü tanımlar$$, TRUE, 1),
    ($$Instruction tuning, her kullanıcı konuşması sırasında gerçek zamanlı ve sürekli olarak gerçekleşir$$, FALSE, 2),
    ($$Bir base model ile instruction-tuned bir model, instruction tuning gözle görülür hiçbir şeyi değiştirmediği için davranış açısından her zaman aynıdır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'how-llms-work'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
