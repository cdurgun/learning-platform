-- Promotion batch
-- Topic: building-an-mcp-server (language: en x7, tr x7)
-- Generated: 2026-09-04 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these 14
-- questions were hand-authored and independently self-reviewed directly
-- inside a Claude Code session, grounded strictly in content/en/building-an-mcp-server.md
-- and content/tr/building-an-mcp-server.md -- NOT produced by n8n, NOT judged by any
-- external AI API, and NOT ingested via /api/internal/questions/ingest.
--
-- Strict 50/50 EN/TR split (7+7) organized as 7 CONCEPT PAIRS -- each EN
-- question has a TR counterpart testing the exact same concept, but
-- independently authored (different framing/options/examples), not a
-- translation. Every question whose answer depends on shown code is typed
-- CODE_OUTPUT (never SINGLE_CHOICE/MULTIPLE_CHOICE with a code_snippet
-- attached) -- fragments/quiz.html only renders code_snippet for
-- CODE_OUTPUT questions, per the bug found and fixed in
-- try-catch-finally/V573.
--
-- Each question's 4 options are written with the correct answer at a
-- deterministic, varied position, computed via
-- (pair_num + version + lang_shift) % 4 -- per the bug found and fixed at
-- question-promotion/V598 (always-A bias) and refined again in the Spring
-- Data JPA batch (parity-locked EN/TR offsets).
--
-- source = 'CLAUDE' / reviewed_by = 'claude-code@anthropic.com' / status =
-- 'PUBLISHED' directly. topic_id resolved by Topic.slug; question_option
-- rows reference the newly generated id via a WITH ... RETURNING id CTE.
--
-- Duplicate-promotion safety: N/A -- this batch was never ingested into
-- development, so no dev ids exist for these 14 questions at all.


-- Pair 1 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Why must "type": "module" remain in package.json for this lesson's MCP server project?$$,
           NULL, NULL,
           $$The lesson is explicit: without "type": "module", Node treats compiled output as CommonJS, and the top-level await used throughout RunServerWithClient.ts fails to run -- it is not an optional stylistic setting.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'building-an-mcp-server'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Without it, Node treats compiled output as CommonJS, and the top-level await used in RunServerWithClient.ts fails to run$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$It's purely a stylistic convention with no functional effect on how the code runs$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$It's required only if the project uses the calculate_sum tool specifically$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$It tells npm to install packages faster by skipping dependency resolution$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu dersin MCP server projesinde package.json'da neden "type": "module" satırı kalmalıdır?$$,
           NULL, NULL,
           $$Ders açıktır: bu olmadan, Node derlenmiş çıktıyı CommonJS olarak ele alır, ve RunServerWithClient.ts boyunca kullanılan top-level await çalışmayı başaramaz -- bu opsiyonel, biçimsel bir ayar değildir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'building-an-mcp-server'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bu yalnızca proje özellikle calculate_sum aracını kullandığında gereklidir$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$Bu, npm'e bağımlılık çözümlemesini atlayarak paketleri daha hızlı kurmasını söyler$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$Bu olmadan, Node derlenmiş çıktıyı CommonJS olarak ele alır, ve RunServerWithClient.ts'de kullanılan top-level await çalışmayı başaramaz$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Bu, kodun çalışma şekli üzerinde hiçbir işlevsel etkisi olmayan, tamamen biçimsel bir kuraldır$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$In GeoFactsServer.ts, what three parts does server.registerTool() give each tool, matching the pattern from "Tools and Function Calling"?$$,
           NULL, NULL,
           $$The lesson states registerTool() gives each tool exactly the three parts "Defining a Tool: Name, Description, and Schema" described -- a name, a description, and a zod-based parameter schema.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'building-an-mcp-server'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A class name, a constructor, and a set of getters/setters$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$A name, a description, and a zod-based parameter schema$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$A name, a version number, and a list of dependencies$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$A URL, an HTTP method, and a request body$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$GeoFactsServer.ts'de, server.registerTool(), 'Tools and Function Calling'daki kalıba uyacak şekilde her araca hangi üç parçayı verir?$$,
           NULL, NULL,
           $$Ders, registerTool()'un her araca 'Defining a Tool: Name, Description, and Schema'nın tarif ettiği tam olarak üç parçayı verdiğini belirtir -- bir ad, bir açıklama ve zod tabanlı bir parametre şeması.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'building-an-mcp-server'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir ad, bir versiyon numarası ve bir bağımlılık listesi$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$Bir URL, bir HTTP metodu ve bir request body$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Bir sınıf adı, bir constructor ve bir dizi getter/setter$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$Bir ad, bir açıklama ve zod tabanlı bir parametre şeması$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this tool handler from GeoFactsServer.ts, what does calling get_capital_city with country="Turkey" return?$$,
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
           $$"Turkey" is present in the CAPITALS map with the value "Ankara", so the capital branch runs and returns the text "The capital of Turkey is Ankara." with no isError flag -- the isError:true path only triggers for a country missing from the map.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'building-an-mcp-server'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$An unhandled exception is thrown, since Turkey is not explicitly checked before the lookup$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$content: [{ type: "text", text: "Turkey" }]  (the country name echoed back unchanged)$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$content: [{ type: "text", text: "The capital of Turkey is Ankara." }]  (no isError)$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$content: [{ type: "text", text: "No capital known for \"Turkey\"." }], isError: true$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
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
    FROM topic WHERE slug = 'building-an-mcp-server'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$content: [{ type: "text", text: "The capital of France is Paris." }]  (isError yok)$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$content: [{ type: "text", text: "No capital known for \"France\"." }], isError: true$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$France, aramadan önce açıkça kontrol edilmediği için işlenmemiş bir exception fırlatılır$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$content: [{ type: "text", text: "France" }]  (ülke adı değişmeden geri yansıtılır)$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$In RunServerWithClient.ts, the client calls client.listTools() before calling any tool. What does the console output show for this line, based on the two tools GeoFactsServer.ts registers?$$,
           $$const toolList = await client.listTools();
console.log("Tools discovered by client:", toolList.tools.map((t) => t.name));$$, $$typescript$$,
           $$The lesson's shown, actually-run output for this exact line is: Tools discovered by client: [ 'get_capital_city', 'calculate_sum' ] -- this is the tools/list discovery step, proving the client learned both tool names from the server over the protocol rather than having them hardcoded.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'building-an-mcp-server'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Tools discovered by client: [ ]  (an empty list, since no tool has been called yet)$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Tools discovered by client: [ 'GeoFactsServer', 'RunServerWithClient' ]  (the file names)$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$This line throws an error, since listTools() cannot run before the first callTool()$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Tools discovered by client: [ 'get_capital_city', 'calculate_sum' ]$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$RunServerWithClient.ts'de, client herhangi bir aracı çağırmadan önce client.listTools()'u çağırıyor. GeoFactsServer.ts'nin kaydettiği iki araca dayanarak, bu satır için konsol çıktısı ne gösterir?$$,
           $$const toolList = await client.listTools();
console.log("Tools discovered by client:", toolList.tools.map((t) => t.name));$$, $$typescript$$,
           $$Dersin gösterdiği, gerçekten çalıştırılmış çıktı bu tam satır için şudur: Tools discovered by client: [ 'get_capital_city', 'calculate_sum' ] -- bu tools/list keşif adımıdır ve client'ın her iki araç adını da sabit kodlanmış olarak değil, protokol üzerinden server'dan öğrendiğini kanıtlar.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'building-an-mcp-server'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bu satır bir hata fırlatır, çünkü listTools() ilk callTool()'dan önce çalışamaz$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Tools discovered by client: [ 'get_capital_city', 'calculate_sum' ]$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Tools discovered by client: [ ]  (henüz hiçbir araç çağrılmadığı için boş bir liste)$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Tools discovered by client: [ 'GeoFactsServer', 'RunServerWithClient' ]  (dosya adları)$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$get_capital_city returns isError: true with a clear message when asked about "Wakanda", a country not in CAPITALS, instead of throwing an exception or guessing an answer. According to this lesson, why is this a good pattern?$$,
           NULL, NULL,
           $$The lesson states this gives the model something concrete to work with instead of an opaque failure -- it's a direct application of the idea, from "Tools and Function Calling", that the tool-calling loop should hand the model something concrete even when a tool fails, rather than crashing or silently making up a wrong answer.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'building-an-mcp-server'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It gives the model something concrete to work with instead of an opaque failure, rather than crashing or silently making up a wrong answer$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$It makes the tool run measurably faster than throwing an exception would$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$It's required by the MCP specification for every single tool without exception$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$It prevents the client from ever being able to call this tool again in the same session$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$get_capital_city, CAPITALS'te olmayan bir ülke olan "Wakanda" sorulduğunda, bir exception fırlatmak ya da bir cevap tahmin etmek yerine, açık bir mesajla isError: true döndürüyor. Bu derse göre, bu neden iyi bir kalıptır?$$,
           NULL, NULL,
           $$Ders, bunun modele opak bir başarısızlık yerine üzerinde çalışabileceği somut bir şey verdiğini belirtir -- bu, 'Tools and Function Calling'deki, tool-calling loop'unun bir araç başarısız olduğunda bile modele somut bir şey vermesi gerektiği, çökmemesi ya da sessizce yanlış bir cevap uydurmaması gerektiği fikrinin doğrudan bir uygulamasıdır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'building-an-mcp-server'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$İstisnasız her tek araç için MCP spesifikasyonu tarafından zorunlu kılınır$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Client'ın aynı oturumda bu aracı bir daha asla çağıramamasını sağlar$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Modele opak bir başarısızlık yerine üzerinde çalışabileceği somut bir şey verir, çökmek ya da sessizce yanlış bir cevap uydurmak yerine$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Aracın, bir exception fırlatmaktan ölçülebilir şekilde daha hızlı çalışmasını sağlar$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Why do imports from the SDK in this lesson's TypeScript files need an explicit ".js" extension (e.g., "@modelcontextprotocol/sdk/server/mcp.js"), even though the source files are ".ts"?$$,
           NULL, NULL,
           $$The lesson states this is specifically because the SDK ships as native ESM, and the "module": "NodeNext" / "moduleResolution": "NodeNext" settings in tsconfig.json require that .js extension even from .ts source files -- omitting it produces a module-not-found error at compile time.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'building-an-mcp-server'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$It's a purely cosmetic convention with no effect on whether the code compiles$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$Because the SDK ships as native ESM, and NodeNext module resolution requires the .js extension even from .ts source files$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$Because TypeScript files are always secretly renamed to .js before being saved to disk$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$Because the zod library requires all its dependencies to use the .js extension specifically$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu dersin TypeScript dosyalarındaki SDK import'ları, kaynak dosyalar ".ts" olmasına rağmen neden açık bir ".js" uzantısına (örn. "@modelcontextprotocol/sdk/server/mcp.js") ihtiyaç duyar?$$,
           NULL, NULL,
           $$Ders, bunun özellikle SDK'nın native ESM olarak dağıtılmasından kaynaklandığını, ve tsconfig.json'daki "module": "NodeNext" / "moduleResolution": "NodeNext" ayarlarının bu .js uzantısını .ts kaynak dosyalarından bile gerektirdiğini belirtir -- bunu atlamak derleme zamanında bir modül-bulunamadı hatası üretir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'building-an-mcp-server'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Çünkü TypeScript dosyaları diske kaydedilmeden önce her zaman gizlice .js olarak yeniden adlandırılır$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$Çünkü zod kütüphanesi tüm bağımlılıklarının özellikle .js uzantısını kullanmasını gerektirir$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Bu, kodun derlenip derlenmeyeceği üzerinde hiçbir etkisi olmayan, tamamen kozmetik bir kuraldır$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Çünkü SDK native ESM olarak dağıtılır, ve NodeNext modül çözümlemesi .js uzantısını .ts kaynak dosyalarından bile gerektirir$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about moving this lesson's demo to a real deployment are correct, according to "From This Demo to a Real Deployment"? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (only the transport changes -- connecting to StdioServerTransport instead of the in-memory transport -- while GeoFactsServer.ts's tool definitions and behavior stay completely unchanged, and this is exactly why the server definition is kept in its own createGeoFactsServer() function separate from the demo's transport wiring); the tool logic in GeoFactsServer.ts does not need to be rewritten for a real deployment, and the server does not need to run in-process together with the host application in a real setup.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'building-an-mcp-server'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$The tool definitions and their behavior in GeoFactsServer.ts need to be substantially rewritten before they can work in a real deployment$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$In a real deployment, the server must run in the exact same process as the host application, just as it does in this lesson's in-memory demo$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$Only the transport changes -- for example, connecting server to a StdioServerTransport instead of the in-memory transport used in the demo$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$Keeping the server definition in its own function, separate from the demo's transport wiring, is what makes it reusable for a real deployment$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$'From This Demo to a Real Deployment'a göre, bu dersin demosunu gerçek bir dağıtıma taşımakla ilgili aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (yalnızca transport değişir -- server'ı in-memory transport yerine bir StdioServerTransport'a bağlamak -- GeoFactsServer.ts'nin araç tanımları ve davranışı ise tamamen değişmeden kalır, ve server tanımının kendi createGeoFactsServer() fonksiyonunda, demonun transport bağlantısından ayrı tutulmasının tam nedeni budur); GeoFactsServer.ts'deki araç mantığının gerçek bir dağıtım için yeniden yazılmasına gerek yoktur, ve gerçek bir kurulumda server'ın host uygulamasıyla aynı süreçte çalışması gerekmez.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'building-an-mcp-server'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Yalnızca transport değişir -- örneğin, server'ı demoda kullanılan in-memory transport yerine bir StdioServerTransport'a bağlamak$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Server tanımını, demonun transport bağlantısından ayrı, kendi fonksiyonunda tutmak, onu gerçek bir dağıtım için yeniden kullanılabilir kılan şeydir$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$GeoFactsServer.ts'deki araç tanımlarının ve davranışının, gerçek bir dağıtımda çalışabilmesi için önemli ölçüde yeniden yazılması gerekir$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Gerçek bir dağıtımda, server, tıpkı bu dersin in-memory demosunda olduğu gibi, host uygulamasıyla birebir aynı süreçte çalışmalıdır$$, FALSE, 3 FROM new_question_tr7;
