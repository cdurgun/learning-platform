-- Promotion-style migration linking TR building-an-ai-agent quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.


-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'building-an-ai-agent')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$'What's Real and What's Simulated in This Lesson'a göre, bu dersin agent'ının hangi kısmı gerçekten değil, simüle edilmiş olarak çalışır?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$'What's Real and What's Simulated in This Lesson'a göre, bu dersin agent'ının hangi kısmı gerçekten değil, simüle edilmiş olarak çalışır?$$,
           NULL, NULL,
           $$Ders açıktır: agent loop'unun kendisi, her tool call ve step limit hepsi gerçektir -- yalnızca karar adımı, decideNextAction(), simüle edilmiştir: iki sabit metin kalıbını tanıyan, kendi çıktısında açıkça (simulated) olarak etiketlenen küçük, tamamen deterministik, elle yazılmış bir fonksiyon.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'building-an-ai-agent'
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
    ($$Step limit -- bu dersin kodunda hiçbir yerde gerçekten zorunlu kılınmaz$$, FALSE, 0),
    ($$Observe-decide-act döngüsünün kendisi dahil tüm agent loop'u$$, FALSE, 1),
    ($$Karar adımı, decideNextAction() -- kendi çıktısında (simulated) olarak etiketlenen deterministik, elle yazılmış bir yerine geçen$$, TRUE, 2),
    ($$get_capital_city ve calculate_sum'a yapılan tool call'lar -- bunlar sahtedir ve asla gerçekten server'a ulaşmaz$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'building-an-ai-agent'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'building-an-ai-agent')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, runAgentLoop()'un maxSteps parametresi neyi garanti eder?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, runAgentLoop()'un maxSteps parametresi neyi garanti eder?$$,
           NULL, NULL,
           $$runAgentLoop(), maxSteps yinelemesine kadar sıradan, sınırlı bir for loop çalıştırır; maxSteps'e bir nihai cevap olmadan ulaşılırsa, loop sonsuza kadar devam etmek yerine stoppedByStepLimit true olarak geri döner -- bu, sınırlı bir loop olarak uygulanan, 'Controlling Agent Behavior'daki step-limit güvencesidir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'building-an-ai-agent'
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
    ($$Karar adımının o kadar adım içinde her zaman doğru bir nihai cevap üreteceğini garanti eder$$, FALSE, 0),
    ($$GeoFactsServer.ts'nin sunmasına izin verilen maksimum araç sayısını belirler$$, FALSE, 1),
    ($$Agent'ın aynı anda bağlanmasına izin verilen ayrı MCP server sayısını belirler$$, FALSE, 2),
    ($$Loop'un çalıştırabileceği decide-act yinelemesi sayısını sınırlar, bir nihai cevaba ulaşılmazsa sonsuza kadar dönmek yerine durmasını (stoppedByStepLimit: true) zorunlu kılar$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'building-an-ai-agent'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'building-an-ai-agent')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Aşağıdaki decideNextAction() mantığı ve "Fransa'nın başkenti nedir?" hedef metni (şimdilik boş bir history ile) göz önüne alındığında, ne yapmaya karar verir?$$
      AND code_snippet = $$const countryMatch = goal.match(/capital of (\w+)/i);
if (countryMatch && !alreadyCalled("get_capital_city")) {
  const country = countryMatch[1];
  return {
    thought: `(simulated) Goal asks for the capital of "${country}". Plan: call get_capital_city.`,
    toolCall: { name: "get_capital_city", arguments: { country } },
  };
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Aşağıdaki decideNextAction() mantığı ve "Fransa'nın başkenti nedir?" hedef metni (şimdilik boş bir history ile) göz önüne alındığında, ne yapmaya karar verir?$$,
           $$const countryMatch = goal.match(/capital of (\w+)/i);
if (countryMatch && !alreadyCalled("get_capital_city")) {
  const country = countryMatch[1];
  return {
    thought: `(simulated) Goal asks for the capital of "${country}". Plan: call get_capital_city.`,
    toolCall: { name: "get_capital_city", arguments: { country } },
  };
}$$, $$typescript$$,
           $$Not: bu regex İngilizce 'capital of X' kalıbını arar; Türkçe 'Fransa'nın başkenti nedir?' bu kalıpla eşleşmez, bu yüzden countryMatch null olur ve bu if bloğu hiç çalışmaz -- fonksiyon sum kontrolüne geçer, o da eşleşmez, ve sonunda (simulated) bir finalAnswer üretir (henüz hiçbir tool sonucu toplanmadığı için 'no tool results were gathered').$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'building-an-ai-agent'
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
    ($$countryMatch null olur (regex yalnızca İngilizce 'capital of X' kalıbını arar), if bloğu atlanır ve fonksiyon sonunda (simulated) bir finalAnswer üretir$$, TRUE, 0),
    ($$Regex Türkçe metinleri de otomatik olarak tanıyacak şekilde tasarlandığı için get_capital_city için bir toolCall döndürür$$, FALSE, 1),
    ($$"Fransa" argümanıyla get_capital_city için bir toolCall döndürür, çünkü regex dile duyarsızdır$$, FALSE, 2),
    ($$Bir exception fırlatır, çünkü fonksiyon yalnızca İngilizce girdiyle çağrılabilir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'building-an-ai-agent'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'building-an-ai-agent')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu dersin "Japonya'nın başkenti nedir ve 12, 30 ve 8'in toplamı nedir?" hedefine karşı maxSteps=5 ile yaptığı gerçek, gözlemlenmiş çalıştırmada, izin sonundaki son iki satır ne gösterir?$$
      AND code_snippet = $$const result = await runAgentLoop(client, goal, 5);
// ...
console.log(`Final answer: ${result.finalAnswer}`);
console.log(`Stopped by step limit: ${result.stoppedByStepLimit}`);$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu dersin "Japonya'nın başkenti nedir ve 12, 30 ve 8'in toplamı nedir?" hedefine karşı maxSteps=5 ile yaptığı gerçek, gözlemlenmiş çalıştırmada, izin sonundaki son iki satır ne gösterir?$$,
           $$const result = await runAgentLoop(client, goal, 5);
// ...
console.log(`Final answer: ${result.finalAnswer}`);
console.log(`Stopped by step limit: ${result.stoppedByStepLimit}`);$$, $$typescript$$,
           $$Dersin gerçek, doğrulanmış çıktısı şununla biter: Final answer: The capital of Japan is Tokyo. Sum: 50 / Stopped by step limit: false -- her iki alt-hedef de izin verilen 5 adımın 2'si içinde gerçek tool call'larla çözüldü, bu yüzden loop step limit tarafından durdurulmaya zorlanmak yerine kendi kararıyla sonuçlandı.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'building-an-ai-agent'
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
    ($$Final answer: No capital known for "Japan". / Stopped by step limit: false$$, FALSE, 0),
    ($$Final answer: The capital of Japan is Tokyo. Sum: 50 / Stopped by step limit: false$$, TRUE, 1),
    ($$Final answer: (step limit reached before a final answer was produced) / Stopped by step limit: true$$, FALSE, 2),
    ($$Final answer: The capital of Japan is Tokyo. Sum: 50 / Stopped by step limit: true$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'building-an-ai-agent'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'building-an-ai-agent')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Hedef "Wakanda'nın başkenti nedir?" olarak değiştirilip yeniden çalıştırılıyor. 'Trying the Error Path'e göre, GeoFactsServer.ts'nin isError: true sonucuna ne olur?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Hedef "Wakanda'nın başkenti nedir?" olarak değiştirilip yeniden çalıştırılıyor. 'Trying the Error Path'e göre, GeoFactsServer.ts'nin isError: true sonucuna ne olur?$$,
           NULL, NULL,
           $$Ders, runAgentLoop()'un çökmediğini ya da hatayı özel olarak ele almadığını doğrular -- gerçek hata sonucu, diğer herhangi bir tool sonucu gibi history'nin bir parçası olur, ve decideNextAction()'ın (simulated) nihai-cevap adımı bunu olduğu gibi bildirir, "Final answer: No capital known for 'Wakanda'." üretir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'building-an-ai-agent'
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
    ($$Hata sessizce atılır, ve loop bunun yerine uydurma bir başkent bildirir$$, FALSE, 0),
    ($$Hiçbir tool call denenmeden step limit'e hemen ulaşılır$$, FALSE, 1),
    ($$Diğer herhangi bir tool sonucu gibi history'nin bir parçası olur, ve loop çökmeden bunu nihai cevapta olduğu gibi bildirir$$, TRUE, 2),
    ($$runAgentLoop(), isError: true olan bir tool sonucunu ele almanın bir yolu olmadığı için hemen çöker$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'building-an-ai-agent'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'building-an-ai-agent')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$'What Would Change With a Real Model'a göre, bu dersin demosundan bir production agent'a geçmek için gereken tek değişiklik nedir?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$'What Would Change With a Real Model'a göre, bu dersin demosundan bir production agent'a geçmek için gereken tek değişiklik nedir?$$,
           NULL, NULL,
           $$Ders, decideNextAction()'ı gerçek bir LLM çağrısıyla değiştirmenin gereken tek değişiklik olduğunu belirtir -- runAgentLoop(), GeoFactsServer.ts ve RunAgentDemo.ts'deki MCP bağlantısı, hiçbiri kararın nasıl verildiğine bağlı olmadığı için birebir aynı kalır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'building-an-ai-agent'
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
    ($$runAgentLoop()'u tamamen yeniden yazmak, çünkü sınırlı bir for loop gerçek bir dil modeliyle çalışamaz$$, FALSE, 0),
    ($$GeoFactsServer.ts'nin araçlarını tamamen farklı olanlarla değiştirmek, çünkü gerçek dağıtımlar demo araçlarını yeniden kullanamaz$$, FALSE, 1),
    ($$MCP'nin tools/call mekanizmasından tamamen farklı, MCP olmayan bir tool çağırma protokolüne geçmek$$, FALSE, 2),
    ($$decideNextAction()'ı gerçek bir LLM çağrısıyla değiştirmek -- runAgentLoop(), GeoFactsServer.ts ve MCP bağlantısı birebir aynı kalır$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'building-an-ai-agent'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'building-an-ai-agent')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu dersin agent implementasyonu hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu dersin agent implementasyonu hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (GeoFactsServer.ts'nin 'Building an MCP Server'dan tamamen değişmeden yeniden kullanılması, bir MCP server'ın çağıranının tek bir tool call mı yoksa tam bir agent loop mu olduğu hakkında hiçbir fikri olmadığını kanıtlar; ve decideNextAction()'ın ürettiği her thought metninin, yazdırılan hiçbir şeyin gerçek model akıl yürütmesiyle karıştırılmaması için özellikle harfi harfine '(simulated)' metniyle başlaması); decideNextAction() açıkça küçük, deterministik, regex tabanlı bir fonksiyondur -- basitleştirilmiş bir dil modeli değildir -- ve tam olarak iki sabit kalıbı tanır, açık uçlu/genel amaçlı bir hedef kümesini değil.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'building-an-ai-agent'
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
    ($$GeoFactsServer.ts, 'Building an MCP Server'dan tamamen değişmeden yeniden kullanılır -- bir MCP server, çağıranının tek bir tool call mı yoksa tam bir agent loop mu olduğu hakkında hiçbir fikre sahip değildir$$, TRUE, 0),
    ($$decideNextAction()'ın ürettiği her thought metni, yazdırılan hiçbir şeyin gerçek model akıl yürütmesiyle karıştırılmaması için harfi harfine '(simulated)' metniyle başlar$$, TRUE, 1),
    ($$decideNextAction(), iki sabit kodlanmış metin kalıbının ötesinde hedefleri anlayabilen, basitleştirilmiş, genel amaçlı bir dil modelidir$$, FALSE, 2),
    ($$decideNextAction(), bu dersin tarif ettiği iki spesifik kalıpla sınırlı kalmadan, açık uçlu, sınırsız çeşitlilikte hedef ifadesini tanıyabilir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'building-an-ai-agent'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
