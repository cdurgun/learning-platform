-- Promotion-style migration linking TR llm-capabilities-and-limitations quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no OpenAI,
-- no AI Judge). No selection/omission -- the entire TR batch is linked.


-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'llm-capabilities-and-limitations')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, aşağıdakilerden hangisi modern LLM'lerin gerçek bir gücüdür?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, aşağıdakilerden hangisi modern LLM'lerin gerçek bir gücüdür?$$,
           NULL, NULL,
           $$Bu, dersin açık güçlü yön listesine uyar (metin dönüştürme, kod taslağı hazırlama/açıklama, genel bilgi soru-cevabı, talimat takibi, few-shot örüntü eşleştirme); garantili gerçek doğruluk, canlı gerçek zamanlı olay erişimi ve garantili doğru aritmetik, LLM'lerin güvenilir şekilde YAPAMADIĞI şeyler olarak açıkça belirtilir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'llm-capabilities-and-limitations'
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
    ($$Şu anda gerçekleşen olaylara canlı, gerçek zamanlı erişime sahip olmak$$, FALSE, 0),
    ($$Her seferinde kesin, garantili doğru çok adımlı aritmetik işlemler yapmak$$, FALSE, 1),
    ($$Metni dönüştürmek -- özetlemek, çevirmek ve farklı bir tonda yeniden yazmak -- diğer şeylerin yanı sıra$$, TRUE, 2),
    ($$Sorulan her soruda gerçeğe uygun doğru cevapları garanti etmek$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'llm-capabilities-and-limitations'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'llm-capabilities-and-limitations')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, LLM'lerde hallucination neden gerçekleşir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, LLM'lerde hallucination neden gerçekleşir?$$,
           NULL, NULL,
           $$Bu, dersin doğrudan nedensel açıklamasına uyar: pretraining, doğrulanmış değil, olası (plausible) bir sonraki token'ı tahmin etmeyi optimize eder ve yerleşik bir gerçek-kontrolcüsü yoktur; ders, hallucination'ın yapısal olduğunu ve her LLM'de bir dereceye kadar bulunduğunu açıkça belirtir, nadir bir hata değildir, yalnızca adversarial durumlarda olmaz ve kasıtlı bir aldatma değildir (modelin niyeti yoktur).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'llm-capabilities-and-limitations'
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
    ($$Bu, yalnızca az sayıda kötü inşa edilmiş modeli etkileyen, nadir görülen bir yazılım hatasıdır$$, FALSE, 0),
    ($$Yalnızca bir kullanıcı modeli kasıtlı olarak adversarial prompt'larla kandırmaya çalıştığında olur$$, FALSE, 1),
    ($$Model kullanıcıya kasıtlı olarak yalan söylediği için olur$$, FALSE, 2),
    ($$Pretraining, doğrulanmış değil, olası (plausible) bir sonraki token'ı tahmin etmeyi optimize eder -- üretilen metni gerçek bilgiyle karşılaştıran yerleşik bir mekanizma yoktur$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'llm-capabilities-and-limitations'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'llm-capabilities-and-limitations')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Knowledge cutoff'u Mart 2024 olan bir LLM'e, Haziran 2024'te gerçekleşen bir olay hakkında soru soruluyor. Ne olabileceğinin en doğru tanımı nedir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Knowledge cutoff'u Mart 2024 olan bir LLM'e, Haziran 2024'te gerçekleşen bir olay hakkında soru soruluyor. Ne olabileceğinin en doğru tanımı nedir?$$,
           NULL, NULL,
           $$Bu derse birebir uyar: knowledge cutoff ve hallucination genellikle birlikte ortaya çıkar, ve bir modelin kendi bilgi boşluğuna dair güvenilir bir öz-farkındalığı garanti edilmez; ders, yerleşik bir gerçek zamanlı internet araması ya da kendini güncelleyen bir cutoff tarif etmez.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'llm-capabilities-and-limitations'
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
    ($$Model ya bilmediğini söyleyebilir ya da -- daha kötüsü -- kendi bilgi boşluğunu güvenilir şekilde tanıyacak yerleşik bir yolu olmadığı için, olası görünen ama uydurma bir cevabı hallucinate edebilir$$, TRUE, 0),
    ($$Model her zaman doğru şekilde bu olay hakkında bilgisi olmadığını söyleyecektir$$, FALSE, 1),
    ($$Model, cevabı bulmak için gerçek zamanlı olarak otomatik olarak interneti arar$$, FALSE, 2),
    ($$Modelin knowledge cutoff'u, olay gerçekleştiği anda kendini otomatik olarak günceller$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'llm-capabilities-and-limitations'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'llm-capabilities-and-limitations')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir LLM, çok adımlı bir mantık bulmacası için kendinden emin, tutarlı görünen adım adım bir açıklama üretiyor, ama nihai cevap yanlış. Bu ders, bunun neden olabileceği konusunda ne söylüyor?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir LLM, çok adımlı bir mantık bulmacası için kendinden emin, tutarlı görünen adım adım bir açıklama üretiyor, ama nihai cevap yanlış. Bu ders, bunun neden olabileceği konusunda ne söylüyor?$$,
           NULL, NULL,
           $$Bu derse uyar: akıl yürütmeye benzeyen çıktı, öğrenilmiş kalıplara dayanan üretilmiş metindir, bir hesap makinesi ya da derleyicinin çalıştırdığı gibi resmi olarak doğrulanmış bir süreç değildir, bu yüzden kendinden emin, tutarlı açıklamalarla bile hatalar oluşabilir; ders, chain-of-thought tekniklerinin buna rağmen ölçülebilir şekilde yardımcı olduğunu açıkça belirtir (yani işe yaramaz değildir) ve herhangi bir adım-sayısı eşiğinden bahsetmez.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'llm-capabilities-and-limitations'
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
    ($$Bu, chain-of-thought prompting'in işe yaramaz olduğu ve asla kullanılmaması gerektiği anlamına gelir$$, FALSE, 0),
    ($$Model, öğrenilmiş kalıplara dayanarak, tek seferde bir token olacak şekilde adım adım akıl yürütmeye benzeyen metin üretir -- bir hesap makinesi veya derleyicinin çalıştırdığı gibi resmi olarak doğrulanmış bir mantıksal süreç değildir$$, TRUE, 1),
    ($$Bu aslında hiç gerçekleşemez -- chain-of-thought akıl yürütme resmi olarak doğrulanmıştır ve doğruluğu garantilidir$$, FALSE, 2),
    ($$Bu yalnızca bulmaca 100'den fazla adım içerdiğinde olur$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'llm-capabilities-and-limitations'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'llm-capabilities-and-limitations')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Kimse bunu amaçlamamış olsa bile, bir LLM çıktısında neden önyargıları veya stereotipleri yeniden üretebilir?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Kimse bunu amaçlamamış olsa bile, bir LLM çıktısında neden önyargıları veya stereotipleri yeniden üretebilir?$$,
           NULL, NULL,
           $$Bu derse doğrudan uyar: önyargı, kendisi de kaynaklarındaki gerçek önyargıları yansıtan, devasa bir gerçek insan yazımı metin örnekleminden istatistiksel örüntüler öğrenmenin bir sonucudur; bu bilinçli bir niyet değildir, yalnızca küçük veri kümeleriyle sınırlı değildir (büyük modeller de eğitim verisini yansıtmaya devam eder) ve ayrı bir mimari hata değildir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'llm-capabilities-and-limitations'
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
    ($$Önyargı yalnızca tek, küçük bir veri kümesiyle eğitilmiş LLM'lerde görülür, büyük ölçekli modellerde asla görülmez$$, FALSE, 0),
    ($$Önyargı, eğitim verisiyle ilgisizdir ve model mimarisindeki ayrı, ilgisiz bir hatadan kaynaklanır$$, FALSE, 1),
    ($$Model, kendisi de kaynaklarındaki gerçek önyargıları ve dengesizlikleri yansıtan, devasa bir gerçek insan yazımı metin örnekleminden istatistiksel örüntüler öğrenir$$, TRUE, 2),
    ($$Model, daha insansı görünmek için bilerek önyargılı olmayı seçer$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'llm-capabilities-and-limitations'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'llm-capabilities-and-limitations')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu ders, hallucination, knowledge cutoff, akıl yürütme hataları ve önyargıyı, bunları ayrı ve ilgisiz hatalar olarak ele almak yerine ortak tek bir kök nedene bağlıyor. Bu ortak kök neden nedir?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu ders, hallucination, knowledge cutoff, akıl yürütme hataları ve önyargıyı, bunları ayrı ve ilgisiz hatalar olarak ele almak yerine ortak tek bir kök nedene bağlıyor. Bu ortak kök neden nedir?$$,
           NULL, NULL,
           $$Bu, dersin açık 'Bu Kısıtlamalar Neden Var' yeniden çerçevelemesine uyar; ders ayrıca ölçeğin her kısıtlamayı düzeltmediğini, tek başına prompt kalitesinin hallucination gibi yapısal sorunları açıklamadığını belirtir ve bu kısıtlamaların hiçbiri tamamen çözülmüş olarak tarif edilmez.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'llm-capabilities-and-limitations'
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
    ($$Dördü de yetersiz model boyutundan kaynaklanır ve model basitçe büyütülürse ortadan kalkar$$, FALSE, 0),
    ($$Dördü de kullanıcıların kötü yapılandırılmış prompt'lar yazmasından kaynaklanır$$, FALSE, 1),
    ($$Dördü de yalnızca eski modellerde görülür ve her modern LLM'de tamamen çözülmüştür$$, FALSE, 2),
    ($$Bir LLM, pretraining sırasında öğrenilen istatistiksel örüntülere dayanarak olası (plausible) metni tahmin eder; yerleşik bir gerçek-kontrolcüsü, resmi mantık motoru, canlı veri bağlantısı veya önyargı düzeltme süreci yoktur$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'llm-capabilities-and-limitations'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'llm-capabilities-and-limitations')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, LLM kısıtlamaları ve çıktılarının doğrulanmasıyla ilgili aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, LLM kısıtlamaları ve çıktılarının doğrulanmasıyla ilgili aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (akıcı çıktıya asla otomatik olarak güvenilmemesi; sonraki kategorilerin modeli tamamen 'düzeltmek' yerine kısıtlamaların etrafından dolaşacak şekilde tasarlanması); ders, bir modelin kendi bilgi boşluğunu güvenilir şekilde bildirmekten çok olası bir tahmin üretmeye daha yatkın olduğunu açıkça belirtir, bu yüzden doğrulanmamış güven güvenli değildir, ve bu kısıtlamaları ilgisiz ayrı hatalar değil, ortak tek bir kök nedeni paylaşan şeyler olarak yeniden çerçeveler.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'llm-capabilities-and-limitations'
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
    ($$Akıcı, kendinden emin görünen bir cevap asla otomatik olarak doğru kabul edilmemelidir -- spesifik gerçekler, tarihler, alıntılar ve sayılar doğrulanmalıdır$$, TRUE, 0),
    ($$Bu kursun Tools & MCP ve AI Agents gibi sonraki kategorileri, altta yatan modeli tamamen 'düzeltmeye' çalışmak yerine, güncel bilgi sağlayıp çıktıları doğrulayarak bu kısıtlamaların etrafından dolaşacak şekilde tasarlanmıştır$$, TRUE, 1),
    ($$Bir model, bilgisi olmadığında güvenilir şekilde 'bilmiyorum' deme olasılığı çok yüksektir, bu yüzden doğrulanmamış cevaplara genellikle güvenilebilir$$, FALSE, 2),
    ($$Hallucination, akıl yürütme hataları ve önyargı, her biri ayrı ayrı anlaşılıp düzeltilmesi gereken tamamen ilgisiz üç başarısızlık modudur$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'llm-capabilities-and-limitations'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
