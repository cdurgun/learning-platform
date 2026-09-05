-- Promotion-style migration linking TR building-an-mcp-server quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.


-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'building-an-mcp-server')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu dersin MCP server projesinde package.json'da neden "type": "module" satırı kalmalıdır?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu dersin MCP server projesinde package.json'da neden "type": "module" satırı kalmalıdır?$$,
           NULL, NULL,
           $$Ders açıktır: bu olmadan, Node derlenmiş çıktıyı CommonJS olarak ele alır, ve RunServerWithClient.ts boyunca kullanılan top-level await çalışmayı başaramaz -- bu opsiyonel, biçimsel bir ayar değildir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'building-an-mcp-server'
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
    ($$Bu yalnızca proje özellikle calculate_sum aracını kullandığında gereklidir$$, FALSE, 0),
    ($$Bu, npm'e bağımlılık çözümlemesini atlayarak paketleri daha hızlı kurmasını söyler$$, FALSE, 1),
    ($$Bu olmadan, Node derlenmiş çıktıyı CommonJS olarak ele alır, ve RunServerWithClient.ts'de kullanılan top-level await çalışmayı başaramaz$$, TRUE, 2),
    ($$Bu, kodun çalışma şekli üzerinde hiçbir işlevsel etkisi olmayan, tamamen biçimsel bir kuraldır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'building-an-mcp-server'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'building-an-mcp-server')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$GeoFactsServer.ts'de, server.registerTool(), 'Tools and Function Calling'daki kalıba uyacak şekilde her araca hangi üç parçayı verir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$GeoFactsServer.ts'de, server.registerTool(), 'Tools and Function Calling'daki kalıba uyacak şekilde her araca hangi üç parçayı verir?$$,
           NULL, NULL,
           $$Ders, registerTool()'un her araca 'Defining a Tool: Name, Description, and Schema'nın tarif ettiği tam olarak üç parçayı verdiğini belirtir -- bir ad, bir açıklama ve zod tabanlı bir parametre şeması.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'building-an-mcp-server'
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
    ($$Bir ad, bir versiyon numarası ve bir bağımlılık listesi$$, FALSE, 0),
    ($$Bir URL, bir HTTP metodu ve bir request body$$, FALSE, 1),
    ($$Bir sınıf adı, bir constructor ve bir dizi getter/setter$$, FALSE, 2),
    ($$Bir ad, bir açıklama ve zod tabanlı bir parametre şeması$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'building-an-mcp-server'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'building-an-mcp-server')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$GeoFactsServer.ts'deki bu araç handler'ı göz önüne alındığında, get_capital_city'yi country="France" ile çağırmak neyi döndürür?$$
      AND code_snippet = $$const CAPITALS: Record<string, string> = {
  France: "Paris",
  Japan: "Tokyo",
  Turkey: "Ankara",
};

async ({ country }) => {
  const capital = CAPITALS[country];
  if (!capital) {
    return {
      content: [{ type: "text", text: `No capital known for "${country}".` }],
      isError: true,
    };
  }
  return { content: [{ type: "text", text: `The capital of ${country} is ${capital}.` }] };
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$GeoFactsServer.ts'deki bu araç handler'ı göz önüne alındığında, get_capital_city'yi country="France" ile çağırmak neyi döndürür?$$,
           $$const CAPITALS: Record<string, string> = {
  France: "Paris",
  Japan: "Tokyo",
  Turkey: "Ankara",
};

async ({ country }) => {
  const capital = CAPITALS[country];
  if (!capital) {
    return {
      content: [{ type: "text", text: `No capital known for "${country}".` }],
      isError: true,
    };
  }
  return { content: [{ type: "text", text: `The capital of ${country} is ${capital}.` }] };
}$$, $$typescript$$,
           $$"France" CAPITALS haritasında "Paris" değeriyle mevcuttur, bu yüzden başkent dalı çalışır ve isError bayrağı olmadan "The capital of France is Paris." metnini döndürür -- isError:true yolu yalnızca haritada olmayan bir ülke için tetiklenir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'building-an-mcp-server'
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
    ($$content: [{ type: "text", text: "The capital of France is Paris." }]  (isError yok)$$, TRUE, 0),
    ($$content: [{ type: "text", text: "No capital known for \"France\"." }], isError: true$$, FALSE, 1),
    ($$France, aramadan önce açıkça kontrol edilmediği için işlenmemiş bir exception fırlatılır$$, FALSE, 2),
    ($$content: [{ type: "text", text: "France" }]  (ülke adı değişmeden geri yansıtılır)$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'building-an-mcp-server'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: CODE_OUTPUT)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'building-an-mcp-server')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$RunServerWithClient.ts'de, client herhangi bir aracı çağırmadan önce client.listTools()'u çağırıyor. GeoFactsServer.ts'nin kaydettiği iki araca dayanarak, bu satır için konsol çıktısı ne gösterir?$$
      AND code_snippet = $$const toolList = await client.listTools();
console.log("Tools discovered by client:", toolList.tools.map((t) => t.name));$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$RunServerWithClient.ts'de, client herhangi bir aracı çağırmadan önce client.listTools()'u çağırıyor. GeoFactsServer.ts'nin kaydettiği iki araca dayanarak, bu satır için konsol çıktısı ne gösterir?$$,
           $$const toolList = await client.listTools();
console.log("Tools discovered by client:", toolList.tools.map((t) => t.name));$$, $$typescript$$,
           $$Dersin gösterdiği, gerçekten çalıştırılmış çıktı bu tam satır için şudur: Tools discovered by client: [ 'get_capital_city', 'calculate_sum' ] -- bu tools/list keşif adımıdır ve client'ın her iki araç adını da sabit kodlanmış olarak değil, protokol üzerinden server'dan öğrendiğini kanıtlar.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'building-an-mcp-server'
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
    ($$Bu satır bir hata fırlatır, çünkü listTools() ilk callTool()'dan önce çalışamaz$$, FALSE, 0),
    ($$Tools discovered by client: [ 'get_capital_city', 'calculate_sum' ]$$, TRUE, 1),
    ($$Tools discovered by client: [ ]  (henüz hiçbir araç çağrılmadığı için boş bir liste)$$, FALSE, 2),
    ($$Tools discovered by client: [ 'GeoFactsServer', 'RunServerWithClient' ]  (dosya adları)$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'building-an-mcp-server'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'building-an-mcp-server')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$get_capital_city, CAPITALS'te olmayan bir ülke olan "Wakanda" sorulduğunda, bir exception fırlatmak ya da bir cevap tahmin etmek yerine, açık bir mesajla isError: true döndürüyor. Bu derse göre, bu neden iyi bir kalıptır?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$get_capital_city, CAPITALS'te olmayan bir ülke olan "Wakanda" sorulduğunda, bir exception fırlatmak ya da bir cevap tahmin etmek yerine, açık bir mesajla isError: true döndürüyor. Bu derse göre, bu neden iyi bir kalıptır?$$,
           NULL, NULL,
           $$Ders, bunun modele opak bir başarısızlık yerine üzerinde çalışabileceği somut bir şey verdiğini belirtir -- bu, 'Tools and Function Calling'deki, tool-calling loop'unun bir araç başarısız olduğunda bile modele somut bir şey vermesi gerektiği, çökmemesi ya da sessizce yanlış bir cevap uydurmaması gerektiği fikrinin doğrudan bir uygulamasıdır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'building-an-mcp-server'
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
    ($$İstisnasız her tek araç için MCP spesifikasyonu tarafından zorunlu kılınır$$, FALSE, 0),
    ($$Client'ın aynı oturumda bu aracı bir daha asla çağıramamasını sağlar$$, FALSE, 1),
    ($$Modele opak bir başarısızlık yerine üzerinde çalışabileceği somut bir şey verir, çökmek ya da sessizce yanlış bir cevap uydurmak yerine$$, TRUE, 2),
    ($$Aracın, bir exception fırlatmaktan ölçülebilir şekilde daha hızlı çalışmasını sağlar$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'building-an-mcp-server'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'building-an-mcp-server')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu dersin TypeScript dosyalarındaki SDK import'ları, kaynak dosyalar ".ts" olmasına rağmen neden açık bir ".js" uzantısına (örn. "@modelcontextprotocol/sdk/server/mcp.js") ihtiyaç duyar?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu dersin TypeScript dosyalarındaki SDK import'ları, kaynak dosyalar ".ts" olmasına rağmen neden açık bir ".js" uzantısına (örn. "@modelcontextprotocol/sdk/server/mcp.js") ihtiyaç duyar?$$,
           NULL, NULL,
           $$Ders, bunun özellikle SDK'nın native ESM olarak dağıtılmasından kaynaklandığını, ve tsconfig.json'daki "module": "NodeNext" / "moduleResolution": "NodeNext" ayarlarının bu .js uzantısını .ts kaynak dosyalarından bile gerektirdiğini belirtir -- bunu atlamak derleme zamanında bir modül-bulunamadı hatası üretir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'building-an-mcp-server'
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
    ($$Çünkü TypeScript dosyaları diske kaydedilmeden önce her zaman gizlice .js olarak yeniden adlandırılır$$, FALSE, 0),
    ($$Çünkü zod kütüphanesi tüm bağımlılıklarının özellikle .js uzantısını kullanmasını gerektirir$$, FALSE, 1),
    ($$Bu, kodun derlenip derlenmeyeceği üzerinde hiçbir etkisi olmayan, tamamen kozmetik bir kuraldır$$, FALSE, 2),
    ($$Çünkü SDK native ESM olarak dağıtılır, ve NodeNext modül çözümlemesi .js uzantısını .ts kaynak dosyalarından bile gerektirir$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'building-an-mcp-server'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'building-an-mcp-server')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$'From This Demo to a Real Deployment'a göre, bu dersin demosunu gerçek bir dağıtıma taşımakla ilgili aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$'From This Demo to a Real Deployment'a göre, bu dersin demosunu gerçek bir dağıtıma taşımakla ilgili aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (yalnızca transport değişir -- server'ı in-memory transport yerine bir StdioServerTransport'a bağlamak -- GeoFactsServer.ts'nin araç tanımları ve davranışı ise tamamen değişmeden kalır, ve server tanımının kendi createGeoFactsServer() fonksiyonunda, demonun transport bağlantısından ayrı tutulmasının tam nedeni budur); GeoFactsServer.ts'deki araç mantığının gerçek bir dağıtım için yeniden yazılmasına gerek yoktur, ve gerçek bir kurulumda server'ın host uygulamasıyla aynı süreçte çalışması gerekmez.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'building-an-mcp-server'
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
    ($$Yalnızca transport değişir -- örneğin, server'ı demoda kullanılan in-memory transport yerine bir StdioServerTransport'a bağlamak$$, TRUE, 0),
    ($$Server tanımını, demonun transport bağlantısından ayrı, kendi fonksiyonunda tutmak, onu gerçek bir dağıtım için yeniden kullanılabilir kılan şeydir$$, TRUE, 1),
    ($$GeoFactsServer.ts'deki araç tanımlarının ve davranışının, gerçek bir dağıtımda çalışabilmesi için önemli ölçüde yeniden yazılması gerekir$$, FALSE, 2),
    ($$Gerçek bir dağıtımda, server, tıpkı bu dersin in-memory demosunda olduğu gibi, host uygulamasıyla birebir aynı süreçte çalışmalıdır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'building-an-mcp-server'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
