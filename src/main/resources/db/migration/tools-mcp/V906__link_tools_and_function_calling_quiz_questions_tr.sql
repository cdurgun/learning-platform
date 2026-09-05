-- Promotion-style migration linking TR tools-and-function-calling quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.


-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'tools-and-function-calling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Tool use (function calling) tam olarak nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Tool use (function calling) tam olarak nedir?$$,
           NULL, NULL,
           $$Tool use, modelin bir fonksiyon adı ve argümanları belirten yapılandırılmış bir istek üretmesi, ve modelin DIŞINDAKİ bir programın bunu gerçekten çalıştırıp sonucu döndürmesi kalıbıdır; modelin kendisi asla kod çalıştırmaz ya da doğrudan bir ağa/veritabanına dokunmaz.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'tools-and-function-calling'
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
    ($$Modelin bir fonksiyonun sonucuna dayanarak kendi eğitim ağırlıklarını yeniden yazmasını sağlayan bir özellik$$, FALSE, 0),
    ($$Modelin çıktısını nasıl ürettiğiyle ilgisi olmayan, satıcıya özgü bir sohbet özelliği$$, FALSE, 1),
    ($$Modelin belirli bir fonksiyonu çağırmak için yapılandırılmış bir istek ürettiği, ve bunu dışarıdaki bir programın gerçekten çalıştırıp sonucunu döndürdüğü bir kalıp$$, TRUE, 2),
    ($$Modelin veri almak için doğrudan bir veritabanına veya ağa bağlandığı bir kalıp$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'tools-and-function-calling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'tools-and-function-calling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, tool use neden var?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, tool use neden var?$$,
           NULL, NULL,
           $$Tool use, modeli büyüterek ya da farklı eğiterek düzeltmeye çalışmak yerine, yapısal LLM kısıtlarının (knowledge cutoff, gerçekleri doğrulayamama, güvenilir hesap yapamama) etrafından dolaşmak için vardır -- güncel, kesin ya da gerçek bir eylem gerektiren her şey için model tahmin etmek yerine bir aracın çalıştırılmasını ister.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'tools-and-function-calling'
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
    ($$Hesaplamayı harici sunuculara aktararak modelin eğitim sürecini hızlandırmak için$$, FALSE, 0),
    ($$Modelin kendi knowledge cutoff'unu zaman içinde kalıcı olarak güncelleyebilmesini sağlamak için$$, FALSE, 1),
    ($$Bir context window'a olan ihtiyacı tamamen ortadan kaldırmak için$$, FALSE, 2),
    ($$Güncel, kesin ya da gerçek bir eylem gerektiren her şey için, yapısal LLM kısıtlarının (knowledge cutoff, güvenilmez hesaplama, context dışına erişememe) etrafından dolaşmak için$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'tools-and-function-calling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'tools-and-function-calling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Tool-calling loop'ta, gerçek fonksiyonu (bir API çağırmak, bir veritabanını sorgulamak, kod çalıştırmak) gerçekte kim çalıştırır?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Tool-calling loop'ta, gerçek fonksiyonu (bir API çağırmak, bir veritabanını sorgulamak, kod çalıştırmak) gerçekte kim çalıştırır?$$,
           NULL, NULL,
           $$Ders açıktır: loop'un 4. adımı her zaman modeli barındıran uygulama tarafından, modelin doğrudan erişimi olmayan sıradan uygulama koduyla gerçekleştirilir -- model, loop'un hiçbir adımında hiçbir şeyi kendisi çalıştırmaz.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'tools-and-function-calling'
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
    ($$Modeli barındıran uygulama -- modelin kendisi loop içinde hiçbir şeyi hiç çalıştırmaz$$, TRUE, 0),
    ($$Bir tool call gerektiğine karar verdikten sonra modelin kendisi$$, FALSE, 1),
    ($$Tool call ile otomatik olarak tetiklenen modelin eğitim altyapısı$$, FALSE, 2),
    ($$O turda hangisi daha hızlı yanıt veriyorsa, model ya da uygulama$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'tools-and-function-calling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'tools-and-function-calling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir geliştirici bir aracı "getData" adıyla ve "veri alır" açıklamasıyla adlandırıyor. Bu derse göre, en olası pratik sonuç nedir?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir geliştirici bir aracı "getData" adıyla ve "veri alır" açıklamasıyla adlandırıyor. Bu derse göre, en olası pratik sonuç nedir?$$,
           NULL, NULL,
           $$Ders, açıklama kalitesinin modelin doğru aracı seçip seçmemesindeki en önemli sinyallerden biri olduğunu belirtir -- belirsiz bir açıklama, modelin spesifik bir açıklamaya göre çok daha sık yanlış tahmin etmesine yol açar; modelin her zaman başarısız olacağını, her zaman doğru seçeceğini ya da isimlerin/şemanın hiç önemli olmadığını iddia etmez.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'tools-and-function-calling'
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
    ($$Doğru araç seçimini yalnızca parametre şeması belirlediği için bunun pratik bir etkisi yoktur$$, FALSE, 0),
    ($$Belirsiz bir açıklama modele fazla bir şey vermediği için, modelin bu aracı ne zaman ya da nasıl kullanacağı konusunda yanlış tahmin etme olasılığı artar$$, TRUE, 1),
    ($$Model her koşulda bu aracı çağırmakta her zaman başarısız olur$$, FALSE, 2),
    ($$Yalnızca araç adları seçimi tamamen belirlediği için, model bu aracı yine de her zaman doğru seçer$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'tools-and-function-calling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'tools-and-function-calling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir model bir aracı çağırıyor, bir sonuç alıyor ve ardından, sonunda cevap vermeden önce ilk sonuçtaki bilgiyi kullanarak ikinci bir aracı çağırması gerektiğine karar veriyor. Bu, tool-calling loop hakkında neyi ortaya koyar?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir model bir aracı çağırıyor, bir sonuç alıyor ve ardından, sonunda cevap vermeden önce ilk sonuçtaki bilgiyi kullanarak ikinci bir aracı çağırması gerektiğine karar veriyor. Bu, tool-calling loop hakkında neyi ortaya koyar?$$,
           NULL, NULL,
           $$Ders açıkça, loop'un nihai bir cevaptan önce birden fazla tur çalışabileceğini ve her gidiş-dönüşün modelin context'inden daha fazlasını tükettiğini belirtir -- tam olarak bir çağrıyla sınırlı değildir, bedavaya çalışmaz, ve bu tek başına sistemin bir agent haline geldiği anlamına gelmez (devam eden bir alışverişle yürütülen, tool call kullanan tek bir konuşma, bu kursta daha sonra ele alınan kendi kendini yönlendiren agent loop'undan farklıdır).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'tools-and-function-calling'
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
    ($$Model ilk sonucu zaten gördüğü için, aynı loop içindeki ek tool call'lar hiç ekstra context tüketmez$$, FALSE, 0),
    ($$Birden fazla tool call yapması tek başına sistemin bir agent haline geldiği anlamına gelir$$, FALSE, 1),
    ($$Loop, nihai bir cevaptan önce birden fazla tur çalışabilir ve her gidiş-dönüş modelin context'inden daha fazlasını tüketir$$, TRUE, 2),
    ($$Bu bir hatadır -- tool-calling loop bir konuşma başına yalnızca tam olarak bir kez çalışmalıdır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'tools-and-function-calling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'tools-and-function-calling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir chatbot, kullanıcı sorduğunda, aksi takdirde sıradan olan bir konuşma içinde tek bir tool call kullanarak bugünün havasını sorguluyor. Bu dersin 'Tool Use vs. Agents' bölümüne göre, bu bir agent midir?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir chatbot, kullanıcı sorduğunda, aksi takdirde sıradan olan bir konuşma içinde tek bir tool call kullanarak bugünün havasını sorguluyor. Bu dersin 'Tool Use vs. Agents' bölümüne göre, bu bir agent midir?$$,
           NULL, NULL,
           $$Ders açıkça, her agent'ın tool use'a dayandığını ama tersinin doğru olmadığını belirtir -- aksi takdirde sıradan olan bir konuşma içinde bir aracı tek seferlik kullanmak tek başına bir agent değildir; bir agent, birden çok adımı planlayan ve loop'u bir miktar özerklikle sürdüren daha geniş bir sistemdir, bu da 'AI Agents' kategorisinde ayrıca ele alınır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'tools-and-function-calling'
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
    ($$Evet -- bir aracın herhangi bir kullanımı, tek seferlik bile olsa, bir sistemi otomatik olarak agent yapar$$, FALSE, 0),
    ($$Evet, ama yalnızca tool call hava durumu gibi canlı, güncel veri içerdiği için$$, FALSE, 1),
    ($$Hayır -- tool use ve agent'lar birbiriyle hiçbir ortak yanı olmayan, tamamen ilgisiz mekanizmalardır$$, FALSE, 2),
    ($$Hayır -- aksi takdirde sıradan olan bir konuşma içindeki tek bir tool call tek başına bir agent değildir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'tools-and-function-calling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'tools-and-function-calling')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, tool use / function calling hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, tool use / function calling hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (modelin hiçbir şeyi kendisi hiç çalıştırmaması, yalnızca istemesi; bir aracın ad, açıklama ve parametre şemasıyla tanımlanması); model, bir aracın gerekip gerekmediğine, uygulamanın kaynak kodunu doğrudan okuyarak değil, kendisine verilen konuşma metnine ve araç açıklamalarına dayanarak karar verir, ve tool use tek başına bir agent olmakla aynı şey değildir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'tools-and-function-calling'
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
    ($$Model bir aracı asla kendisi çalıştırmaz -- yapılandırılmış bir istek üretir, ve modeli barındıran uygulama gerçek fonksiyonu çalıştırır$$, TRUE, 0),
    ($$Bir araç, modele üç parçayla tanımlanır: bir ad, bir açıklama ve bir parametre şeması$$, TRUE, 1),
    ($$Model, bir aracın gerekip gerekmediğine, modeli barındıran uygulamanın kaynak kodunu doğrudan okuyarak karar verir$$, FALSE, 2),
    ($$Bir aracı kullanmak, tek başına, başka hiçbir ayrım olmadan bir agent olmakla tamamen aynı şeydir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'tools-and-function-calling'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
