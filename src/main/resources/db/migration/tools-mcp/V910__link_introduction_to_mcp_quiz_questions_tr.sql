-- Promotion-style migration linking TR introduction-to-mcp quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.


-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-mcp')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, Model Context Protocol (MCP) nedir?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, Model Context Protocol (MCP) nedir?$$,
           NULL, NULL,
           $$MCP, bir AI uygulamasının harici araçlara, veri kaynaklarına ve prompt şablonlarına nasıl bağlandığını standartlaştıran açık bir protokoldür -- tool-calling loop'unu değiştirmez, onun sunucu tarafını standartlaştırır, böylece aynı araç uygulaması herhangi bir MCP uyumlu uygulama tarafından yeniden kullanılabilir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'introduction-to-mcp'
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
    ($$Önceki derste anlatılan tool-calling loop'unun yerini alan bir değişiklik$$, FALSE, 0),
    ($$Yalnızca AI agent'lar yazmak için kullanılan bir programlama dili$$, FALSE, 1),
    ($$Bir AI uygulamasının harici araçlara, veri kaynaklarına ve prompt şablonlarına nasıl bağlandığını standartlaştıran açık bir protokol$$, TRUE, 2),
    ($$Tool calling için optimize edilmiş belirli bir büyük dil modeli$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-mcp'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-mcp')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, MCP neden var? Hangi problemi çözer?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, MCP neden var? Hangi problemi çözer?$$,
           NULL, NULL,
           $$Ortak bir standart olmadan, M uygulamayı N araca/veri kaynağına bağlamak birçok ayrı, özel entegrasyon gerektirir; MCP bu mimariyi standartlaştırır, böylece bir araç ya da veri kaynağı bir sunucu olarak bir kez uygulanır ve herhangi bir MCP uyumlu uygulama ona değiştirilmeden bağlanabilir -- genellikle 'M x N -> M + N' olarak özetlenir (basitleştirilmiş bir zihinsel model, kesin bir formül değil).$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'introduction-to-mcp'
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
    ($$Modelin ağırlıklarını sıkıştırarak LLM inference'ını hızlandırır$$, FALSE, 0),
    ($$Araçların bir ad, açıklama veya parametre şemasına sahip olma ihtiyacını ortadan kaldırır$$, FALSE, 1),
    ($$Bir modelin cevaplarının her zaman gerçeğe uygun olduğunu garanti eder$$, FALSE, 2),
    ($$Her AI uygulaması ile her araç veya veri kaynağı arasında ayrı, özel bir entegrasyon ihtiyacını azaltır, genellikle 'M x N -> M + N' olarak özetlenir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-mcp'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: SINGLE_CHOICE)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-mcp')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$MCP'nin host/client/server modelinde 'host' nedir?$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$MCP'nin host/client/server modelinde 'host' nedir?$$,
           NULL, NULL,
           $$Host, kişinin gerçekten etkileşime girdiği AI uygulamasıdır (bir sohbet uygulaması, bir IDE, özel bir agent) -- LLM ile konuşmaktan ve MCP'nin ne zaman kullanılacağına karar vermekten sorumludur; araçları sunan ayrı program (bu server'dır) ya da içteki bağlantı bileşeni (bu client'tır) değildir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'introduction-to-mcp'
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
    ($$Kişinin gerçekten etkileşime girdiği, LLM ile konuşmaktan ve MCP'nin ne zaman kullanılacağına karar vermekten sorumlu AI uygulaması$$, TRUE, 0),
    ($$Bağlanan herhangi bir client'a araç, veri veya prompt şablonu sunan ayrı program$$, FALSE, 1),
    ($$Tam olarak bir server'a birebir bağlantı sürdüren iç bileşen$$, FALSE, 2),
    ($$LLM'nin ağırlıklarının depolandığı fiziksel makine veya bulut örneği$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-mcp'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-mcp')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir host uygulaması aynı anda üç farklı MCP server'a ulaşması gerekiyor. Bu derse göre, bu iç yapıda nasıl çalışır?$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir host uygulaması aynı anda üç farklı MCP server'a ulaşması gerekiyor. Bu derse göre, bu iç yapıda nasıl çalışır?$$,
           NULL, NULL,
           $$Ders, bir client'ın tam olarak bir server'a birebir bağlantı sürdürdüğünü belirtir -- üç farklı server'a ulaşması gereken bir host, her bağlantı için bir tane olmak üzere iç yapısında üç client çalıştırır; bu tek bir client'ın üç bağlantıyı jonglörlük yapması değildir, ve üç ayrı host gerektirdiği anlamına da gelmez.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'introduction-to-mcp'
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
    ($$Bu mümkün değildir -- bir host aynı anda yalnızca bir MCP server'a bağlanabilir$$, FALSE, 0),
    ($$Host, her client tam olarak bir server'a birebir bağlantı sürdürdüğü için, her server bağlantısı için bir tane olmak üzere iç yapısında üç client çalıştırır$$, TRUE, 1),
    ($$Host, üç server bağlantısını aynı anda jonglörlük yapan tek bir client çalıştırır$$, FALSE, 2),
    ($$Bu, server başına bir tane olmak üzere tamamen ayrı üç host uygulaması gerektirir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-mcp'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-mcp')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, bir MCP server, kendisini sonunda hangi host uygulamasının veya hangi altta yatan LLM'nin çağıracağını bilmesi gerekir mi?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, bir MCP server, kendisini sonunda hangi host uygulamasının veya hangi altta yatan LLM'nin çağıracağını bilmesi gerekir mi?$$,
           NULL, NULL,
           $$Ders açıkça, bir server'ın kendisiyle hangi host'un konuştuğunu ya da host'un hangi altta yatan LLM'yi kullandığını bilmediğini ya da umursamadığını, yalnızca protokolü konuştuğunu belirtir -- bu ayrım, 'bir kere yaz, her yerde kullan' özelliğinin çalışmasını sağlar.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'introduction-to-mcp'
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
    ($$Evet, ama yalnızca LLM için, host uygulaması için değil$$, FALSE, 0),
    ($$Evet, ama yalnızca host uygulaması için, altta yatan LLM için değil$$, FALSE, 1),
    ($$Hayır -- bir server, kendisini kimin çağırdığını (host ya da LLM) bilmez ya da umursamaz, yalnızca protokolü konuşur$$, TRUE, 2),
    ($$Evet -- bir server, belirli bir host uygulaması ve LLM kombinasyonu için özel olarak inşa edilmelidir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-mcp'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-mcp')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bir MCP server, host uygulamasına belirli bir dosyanın içeriğini sunuyor; model bunu okuyabilir ama bu hiçbir hesaplama içermez ve hiçbir eylem gerçekleştirmez. Bu derse göre, bu hangi primitive'tir?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bir MCP server, host uygulamasına belirli bir dosyanın içeriğini sunuyor; model bunu okuyabilir ama bu hiçbir hesaplama içermez ve hiçbir eylem gerçekleştirmez. Bu derse göre, bu hangi primitive'tir?$$,
           NULL, NULL,
           $$Ders, bir resource'u, bir URI ile tanımlanan, host'un içine çekebileceği okunabilir veri olarak tanımlar; bu okunur (çalıştırılmaz) ve bir eylem gerçekleştirmek yerine bilgi sağlar -- bir araçtan (bir eylem ya da hesaplama gerçekleştiren çalıştırılabilir fonksiyon) ve bir prompt'tan (yeniden kullanılabilir bir prompt şablonu) farklıdır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'introduction-to-mcp'
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
    ($$Bir tool -- çünkü bir server'ın client'a sunduğu her şey tool sayılır$$, FALSE, 0),
    ($$Bir prompt -- çünkü modelin bir yanıt üretirken kullanacağı bir bilgidir$$, FALSE, 1),
    ($$MCP'nin hiçbir primitive'i bu durumu kapsamaz -- özel, standart olmayan bir genişletme gerektirir$$, FALSE, 2),
    ($$Bir resource -- okunur (çalıştırılmaz) ve bir eylem gerçekleştirmek yerine bilgi sağlar$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-mcp'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'introduction-to-mcp')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, MCP hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, MCP hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (MCP, bir modelin bir aracı ne zaman ve nasıl kullanacağına nasıl karar verdiğini değiştirmeden, araçların keşfini ve çağrılmasını standartlaştırır; bir server, üç primitive'in (tool, resource, prompt) hepsini sunmak zorunda olmadan yalnızca birini sunmakta serbesttir); MCP, bir server'a bağlanan her AI uygulamasının birebir aynı altta yatan LLM'yi kullanmasını gerektirmez (server'lar LLM'den bağımsızdır, LLM'yi kısıtlamaz), ve önceki derste anlatılan tool-calling loop'unun ve tool use fikrinin yerini almaz.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'introduction-to-mcp'
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
    ($$MCP, bir modelin bir aracı ne zaman ve nasıl kullanacağına kendi kendine nasıl karar verdiğini değiştirmeden, araçların nasıl keşfedildiğini ve çağrıldığını standartlaştırır$$, TRUE, 0),
    ($$Belirli bir MCP server, üç primitive'in (tool, resource, prompt) hepsini sunmak zorunda kalmadan yalnızca birini sunmakta serbesttir$$, TRUE, 1),
    ($$MCP, bir server'a bağlanan her AI uygulamasının birebir aynı altta yatan LLM'yi kullanmasını gerektirir$$, FALSE, 2),
    ($$MCP, önceki derste anlatılan tool-calling loop'unun ve tool use fikrinin yerini alır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'introduction-to-mcp'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
