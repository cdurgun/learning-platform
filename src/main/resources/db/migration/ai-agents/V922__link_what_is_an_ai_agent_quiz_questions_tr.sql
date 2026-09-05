-- Promotion-style migration linking TR what-is-an-ai-agent quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.


-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-an-ai-agent')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bir AI agent nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir AI agent nedir?$$,
           NULL, NULL,
           $$Ders, bir AI agent'ı, bir veya daha fazla model çağrısı artı tool use etrafında kurulu, bir hedefi, sırayla ne yapacağına tekrar tekrar karar vererek, bir eylem gerçekleştirerek, sonucu gözlemleyerek ve tekrar karar vererek, hedef karşılanana ya da durmaya karar verene kadar sürdüren bir sistem olarak tanımlar.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-an-ai-agent'
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
    ($$Bir soruyu yanıtlamak için bir sonuç döndüren tek bir tool call$$, FALSE, 0),
    ($$Bir modeli reinforcement learning görevlerinde eğitmek için kullanılan bir veri kümesi$$, FALSE, 1),
    ($$Bir hedefi, sırayla ne yapacağına tekrar tekrar karar vererek, bir eylem gerçekleştirerek, sonucu gözlemleyerek ve tekrar karar vererek sürdüren bir sistem$$, TRUE, 2),
    ($$Büyük bir dil modeli kullanarak soruları yanıtlayabilen herhangi bir chatbot$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-an-ai-agent'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-an-ai-agent')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu dersin 'Why Does It Exist?' bölümüne göre, AI agent'lar neden var?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu dersin 'Why Does It Exist?' bölümüne göre, AI agent'lar neden var?$$,
           NULL, NULL,
           $$Ders, agent'ların, gerekli adımların ve kaç tanesine ihtiyaç olduğunun ancak önceki adımlar çalıştıkça belirlenebildiği problemleri ele almak için var olduğunu belirtir -- bunlar, bir isteğin gittiği, bir sonucun geldiği ve her bir sonraki adımı hâlâ bir insanın yönlendirdiği sıradan tool-calling loop'una uymaz.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-an-ai-agent'
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
    ($$Tek bir tool call'ın olması gerekenden daha hızlı çalışmasını sağlamak için$$, FALSE, 0),
    ($$Araçların bir ad, açıklama ya da parametre şemasına sahip olma ihtiyacını ortadan kaldırmak için$$, FALSE, 1),
    ($$Her hedefin tam olarak tek bir adımda tamamlanmasını garanti etmek için$$, FALSE, 2),
    ($$Gerekli adımların ve kaç tanesine ihtiyaç olduğunun ancak önceki adımlar çalıştıkça belirlenebildiği problemleri ele almak için$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-an-ai-agent'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-an-ai-agent')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu dersin tarif ettiği agent loop'unun üç adımını doğru sıraya koyun.$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu dersin tarif ettiği agent loop'unun üç adımını doğru sıraya koyun.$$,
           NULL, NULL,
           $$Ders, loop'u Observe (hedefe ve o ana kadar olan her şeye bakmak), Decide (tam olarak bir sonraki adıma karar vermek), Act (varsa seçilen eylemi gerçekleştirmek) olarak adlandırır -- bu sırayla, tekrar ederek.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-an-ai-agent'
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
    ($$Önce Observe, sonra Decide, sonra Act$$, TRUE, 0),
    ($$Önce Decide, sonra Act, sonra Observe$$, FALSE, 1),
    ($$Önce Act, sonra Observe, sonra Decide$$, FALSE, 2),
    ($$Önce Decide, sonra Observe, sonra Act$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-an-ai-agent'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-an-ai-agent')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Sıradan bir chatbot, kullanıcı sorduğunda bugünün havasını sorguluyor, sonra konuşma normal şekilde devam ediyor. Bu derse göre, bu tek seferlik sorgulama chatbot'u bir agent yapar mı?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Sıradan bir chatbot, kullanıcı sorduğunda bugünün havasını sorguluyor, sonra konuşma normal şekilde devam ediyor. Bu derse göre, bu tek seferlik sorgulama chatbot'u bir agent yapar mı?$$,
           NULL, NULL,
           $$Ders, bir aracı tek bir istek/yanıt alışverişi içinde tek seferlik kullanmanın bir şeyi agent yapan şey olmadığını belirtir -- sorulduğunda bugünün havasını sorgulayan sıradan bir chatbot, bunu yaparak bir agent haline gelmez; bir sistemi agent yapan şey, loop'un sistemin kendi kontrolü altında birden çok adım boyunca çalışmasıdır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-an-ai-agent'
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
    ($$Hayır, ama yalnızca hava durumu sorguları özellikle agent tanımından hariç tutulduğu için$$, FALSE, 0),
    ($$Hayır -- bir aracı tek bir istek/yanıt alışverişi içinde tek seferlik kullanmak bir sistemi agent yapmaz$$, TRUE, 1),
    ($$Evet -- bağlamdan bağımsız olarak herhangi bir tool call, bir sistemi otomatik olarak agent olarak nitelendirir$$, FALSE, 2),
    ($$Evet, ama yalnızca hava durumu verisi canlı, güncel bir bilgi aracı sayıldığı için$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-an-ai-agent'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-an-ai-agent')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$'The Autonomy Spectrum'a göre, 'agent' tek, sabit bir bağımsızlık miktarını mı ifade eder, yoksa başka bir şeyi mi?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$'The Autonomy Spectrum'a göre, 'agent' tek, sabit bir bağımsızlık miktarını mı ifade eder, yoksa başka bir şeyi mi?$$,
           NULL, NULL,
           $$Ders açıkça, 'agent'ın tek, sabit bir bağımsızlık miktarını ifade etmediğini belirtir -- bir spektrumu adlandırır, bir insanın önceden etkili biçimde senaryolaştırdığı her kararı olan bir sistemden, tamamen kendi başına birçok karar-eylem döngüsü çalıştıran bir sisteme kadar; çoğu pratik agent bu uçlar arasında bir yerde durur.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-an-ai-agent'
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
    ($$Yalnızca hiçbir şekilde insan katılımı gerektirmeyen sistemlere uygulanır$$, FALSE, 0),
    ($$Yalnızca bir insanın gerçekten her tek kararı onayladığı sistemlere uygulanır$$, FALSE, 1),
    ($$Bir spektrumu adlandırır -- tamamen insan tarafından senaryolaştırılmış davranıştan tamamen özerk, çok adımlı davranışa kadar, çoğu pratik agent arada bir yerde$$, TRUE, 2),
    ($$Her agent'ın sahip olması gereken tek, sabit, evrensel bir bağımsızlık miktarını tanımlar$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-an-ai-agent'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-an-ai-agent')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu ders, agent loop'u ile 'Tools and Function Calling'deki 'The Tool-Calling Loop' arasındaki ilişkiyi nasıl tanımlar?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu ders, agent loop'u ile 'Tools and Function Calling'deki 'The Tool-Calling Loop' arasındaki ilişkiyi nasıl tanımlar?$$,
           NULL, NULL,
           $$Ders, agent loop'unu açıkça 'The Tool-Calling Loop'un doğrudan bir genellemesi' olarak adlandırır -- bir kez çalışıp durmak yerine, aynı observe-decide-act döngüsü, hedef karşılanana ya da bir güvenlik sınırına ulaşılana kadar, sistemin kendi kontrolü altında tekrar eder.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-an-ai-agent'
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
    ($$İki loop, tesadüfen bazı kelime dağarcığını paylaşan, tamamen ilgisiz mekanizmalardır$$, FALSE, 0),
    ($$Agent loop, tool-calling loop'un yerini tamamen alır ve agent'lar için tool call'ları gereksiz kılar$$, FALSE, 1),
    ($$Tool-calling loop, agent loop'unun üzerine inşa edilmiş, daha sonra eklenmiş daha gelişmiş bir eklentidir$$, FALSE, 2),
    ($$Agent loop, tool-calling loop'un doğrudan bir genellemesidir -- bir kez çalışmak yerine aynı döngü sistemin kendi kontrolü altında tekrar eder$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-an-ai-agent'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'what-is-an-ai-agent')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, AI agent'lar hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, AI agent'lar hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (agent loop'unu sıradan tool use'tan ayıran üç şey: sıranın önceden sabitlenmemiş olması, adım sayısının önceden bilinmemesi, ve her kararın bir önceki adımda olanlardan bilgi alması; ve bir agent'ın model tarafından yönlendirilen karar vermesinin hâlâ 'LLM Capabilities and Limitations'daki aynı akıl yürütme kısıtlarına sahip aynı türden bir model olması); bir agent'ın kendi karar adımı hâlâ bir model çağrısıyla yapılır, bir insan tarafından önceden birebir sabit kodlanmaz, ve bu derste daha fazla özerkliğin otomatik olarak daha iyi olduğu hiç belirtilmez.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'what-is-an-ai-agent'
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
    ($$Tek bir tool call'a kıyasla, bir agent'ın karar sırası önceden sabitlenmemiştir, adım sayısı önceden bilinmez, ve her karar bir önceki adımda olanlardan bilgi alır$$, TRUE, 0),
    ($$Bir agent'ın karar vermesi hâlâ 'Reasoning Limits'te ele alınan aynı türden bir model tarafından yapılır -- bir dizi tool call'ı planlamak bu altta yatan kısıtları ortadan kaldırmaz$$, TRUE, 1),
    ($$Bir agent'ın attığı her adım, tıpkı tek bir tool call'da olduğu gibi, önceden bir insan tarafından karar verilir$$, FALSE, 2),
    ($$Daha fazla özerklik bir agent için her zaman daha iyidir, çünkü bu, hiçbir adımın bir insana geri yönlendirilmediği anlamına gelir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'what-is-an-ai-agent'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
