-- Promotion batch
-- Topic: mcp-architecture (language: en x7, tr x7)
-- Generated: 2026-09-04 (this migration file's authoring date)
--
-- Like every prior question-promotion batch in this project, these 14
-- questions were hand-authored and independently self-reviewed directly
-- inside a Claude Code session, grounded strictly in content/en/mcp-architecture.md
-- and content/tr/mcp-architecture.md -- NOT produced by n8n, NOT judged by any
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
           $$What wire format does MCP use for messages exchanged between a client and a server?$$,
           NULL, NULL,
           $$The lesson is explicit that MCP does not invent its own message format -- it adopts JSON-RPC 2.0, a small, pre-existing, general-purpose, text-based format unrelated to MCP itself, as its wire format.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'mcp-architecture'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$JSON-RPC 2.0 -- a pre-existing, general-purpose message format that MCP adopted rather than inventing its own$$, TRUE, 0 FROM new_question_en1
        UNION ALL SELECT id, $$A custom binary format designed specifically and exclusively for MCP$$, FALSE, 1 FROM new_question_en1
        UNION ALL SELECT id, $$Plain, unstructured text with no defined message shape$$, FALSE, 2 FROM new_question_en1
        UNION ALL SELECT id, $$XML-RPC, an XML-based predecessor format that MCP replaced$$, FALSE, 3 FROM new_question_en1;

-- Pair 1 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$MCP, bir client ile bir server arasında değiş tokuş edilen mesajlar için hangi tel (wire) formatını kullanır?$$,
           NULL, NULL,
           $$Ders açıktır: MCP kendi mesaj formatını icat etmez -- MCP'nin kendisiyle ilgisi olmayan, küçük, önceden var olan, genel amaçlı, metin tabanlı bir format olan JSON-RPC 2.0'ı tel formatı olarak benimser.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'mcp-architecture'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Tanımlı bir mesaj şekli olmayan, düz, yapılandırılmamış metin$$, FALSE, 0 FROM new_question_tr1
        UNION ALL SELECT id, $$MCP'nin yerini aldığı, XML tabanlı bir öncül format olan XML-RPC$$, FALSE, 1 FROM new_question_tr1
        UNION ALL SELECT id, $$JSON-RPC 2.0 -- MCP'nin kendi formatını icat etmek yerine benimsediği, önceden var olan, genel amaçlı bir mesaj formatı$$, TRUE, 2 FROM new_question_tr1
        UNION ALL SELECT id, $$Özellikle ve yalnızca MCP için tasarlanmış özel bir ikili (binary) format$$, FALSE, 3 FROM new_question_tr1;

-- Pair 2 / EN (SINGLE_CHOICE, BEGINNER)
WITH new_question_en2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$According to this lesson, what are the two most common transports for carrying MCP's JSON-RPC messages?$$,
           NULL, NULL,
           $$The lesson names stdio (client launches the server as a local subprocess, messages travel over standard input/output) and Streamable HTTP (server runs as an independent, possibly remote process reachable over HTTP) as the two most common transports.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'mcp-architecture'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bluetooth and USB$$, FALSE, 0 FROM new_question_en2
        UNION ALL SELECT id, $$stdio and Streamable HTTP$$, TRUE, 1 FROM new_question_en2
        UNION ALL SELECT id, $$WebSockets and gRPC$$, FALSE, 2 FROM new_question_en2
        UNION ALL SELECT id, $$FTP and SMTP$$, FALSE, 3 FROM new_question_en2;

-- Pair 2 / TR (SINGLE_CHOICE, BEGINNER)
WITH new_question_tr2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER',
           'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, MCP'nin JSON-RPC mesajlarını taşıyan en yaygın iki transport nedir?$$,
           NULL, NULL,
           $$Ders, en yaygın iki transport olarak stdio'yu (client, server'ı yerel bir alt süreç olarak başlatır, mesajlar standart girdi/çıktı üzerinden taşınır) ve Streamable HTTP'yi (server, HTTP üzerinden ulaşılabilen bağımsız, muhtemelen uzak bir süreç olarak çalışır) adlandırır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'mcp-architecture'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$WebSockets ve gRPC$$, FALSE, 0 FROM new_question_tr2
        UNION ALL SELECT id, $$FTP ve SMTP$$, FALSE, 1 FROM new_question_tr2
        UNION ALL SELECT id, $$Bluetooth ve USB$$, FALSE, 2 FROM new_question_tr2
        UNION ALL SELECT id, $$stdio ve Streamable HTTP$$, TRUE, 3 FROM new_question_tr2;

-- Pair 3 / EN (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_en3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Given this JSON-RPC 2.0 request MCP would send to invoke a tool, what does the "method" field's value indicate is happening?$$,
           $${
  "jsonrpc": "2.0",
  "id": 1,
  "method": "tools/call",
  "params": {
    "name": "get_capital_city",
    "arguments": { "country": "Japan" }
  }
}$$, $$json$$,
           $$The "method" field's value, "tools/call", identifies this as an invocation request -- the client is asking the server to actually run the named tool (get_capital_city) with the given arguments, as opposed to a discovery request like "tools/list".$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'mcp-architecture'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$This is the server's response, returning the result of a tool call back to the client$$, FALSE, 0 FROM new_question_en3
        UNION ALL SELECT id, $$This is an initialize request establishing the protocol version between client and server$$, FALSE, 1 FROM new_question_en3
        UNION ALL SELECT id, $$This is a tool invocation request -- the client is asking the server to actually run the get_capital_city tool with the given arguments$$, TRUE, 2 FROM new_question_en3
        UNION ALL SELECT id, $$This is a discovery request asking the server to list all of its available tools$$, FALSE, 3 FROM new_question_en3;

-- Pair 3 / TR (CODE_OUTPUT, INTERMEDIATE)
WITH new_question_tr3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$MCP'nin bir aracı çağırmak için göndereceği bu JSON-RPC 2.0 isteği göz önüne alındığında, 'method' alanının değeri neyin olduğunu gösterir?$$,
           $${
  "jsonrpc": "2.0",
  "id": 7,
  "method": "tools/call",
  "params": {
    "name": "hesapla_toplam",
    "arguments": { "sayilar": [3, 5, 9] }
  }
}$$, $$json$$,
           $$'method' alanının değeri olan 'tools/call', bunu bir çağırma (invocation) isteği olarak tanımlar -- client, sunucudan verilen argümanlarla adı geçen aracı (hesapla_toplam) gerçekten çalıştırmasını ister, 'tools/list' gibi bir keşif isteğinin aksine.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'mcp-architecture'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bu bir araç çağırma isteğidir -- client, sunucudan hesapla_toplam aracını verilen argümanlarla gerçekten çalıştırmasını ister$$, TRUE, 0 FROM new_question_tr3
        UNION ALL SELECT id, $$Bu, sunucudan mevcut tüm araçlarını listelemesini isteyen bir keşif isteğidir$$, FALSE, 1 FROM new_question_tr3
        UNION ALL SELECT id, $$Bu, bir araç çağrısının sonucunu client'a geri döndüren sunucunun yanıtıdır$$, FALSE, 2 FROM new_question_tr3
        UNION ALL SELECT id, $$Bu, client ile sunucu arasında protokol versiyonunu belirleyen bir initialize isteğidir$$, FALSE, 3 FROM new_question_tr3;

-- Pair 4 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Put the three phases of an MCP connection's lifecycle in the correct order, as this lesson describes them.$$,
           NULL, NULL,
           $$The lesson lays out the lifecycle as Initialize (agree on protocol version and capabilities) first, then Discover (tools/list, resources/list, prompts/list), then Invoke (tools/call, resources/read) -- a single connection typically runs one initialize phase, then repeats discovery and invocation many times.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'mcp-architecture'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Discover, then Initialize, then Invoke$$, FALSE, 0 FROM new_question_en4
        UNION ALL SELECT id, $$Invoke, then Discover, then Initialize$$, FALSE, 1 FROM new_question_en4
        UNION ALL SELECT id, $$Discover, then Invoke, then Initialize$$, FALSE, 2 FROM new_question_en4
        UNION ALL SELECT id, $$Initialize, then Discover, then Invoke$$, TRUE, 3 FROM new_question_en4;

-- Pair 4 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu dersin anlattığı şekliyle, bir MCP bağlantısının yaşam döngüsünün üç aşamasını doğru sıraya koyun.$$,
           NULL, NULL,
           $$Ders, yaşam döngüsünü önce Initialize (protokol versiyonu ve yetenekler üzerinde anlaşma), sonra Discover (tools/list, resources/list, prompts/list), sonra Invoke (tools/call, resources/read) şeklinde sıralar -- tek bir bağlantı genellikle bir kez initialize aşaması çalıştırır, sonra keşif ve çağırmayı birçok kez tekrarlar.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'mcp-architecture'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Önce Discover, sonra Invoke, sonra Initialize$$, FALSE, 0 FROM new_question_tr4
        UNION ALL SELECT id, $$Önce Initialize, sonra Discover, sonra Invoke$$, TRUE, 1 FROM new_question_tr4
        UNION ALL SELECT id, $$Önce Discover, sonra Initialize, sonra Invoke$$, FALSE, 2 FROM new_question_tr4
        UNION ALL SELECT id, $$Önce Invoke, sonra Discover, sonra Initialize$$, FALSE, 3 FROM new_question_tr4;

-- Pair 5 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$During the initialize phase, a client and server each declare which optional MCP features they actually support (for example, whether the server supports resources at all). What is this called, and why does it exist?$$,
           NULL, NULL,
           $$This is called capability negotiation, and it exists because not every host or server needs every MCP feature -- a minimal server that only exposes tools doesn't need to implement resource support, and a client only prepares for the capabilities a given server actually declares.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'mcp-architecture'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Capability negotiation -- it exists because not every host or server needs to support every MCP feature$$, TRUE, 0 FROM new_question_en5
        UNION ALL SELECT id, $$Tool discovery -- it exists so the client can learn the names of all available tools$$, FALSE, 1 FROM new_question_en5
        UNION ALL SELECT id, $$Transport selection -- it exists so the client can choose between stdio and Streamable HTTP$$, FALSE, 2 FROM new_question_en5
        UNION ALL SELECT id, $$Authentication -- it exists so the server can verify the client's identity before allowing any connection$$, FALSE, 3 FROM new_question_en5;

-- Pair 5 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Initialize aşamasında, bir client ve server, hangi opsiyonel MCP özelliklerini gerçekten desteklediklerini (örneğin, sunucunun resource'ları hiç destekleyip desteklemediğini) her biri ayrı ayrı belirtir. Buna ne denir ve neden vardır?$$,
           NULL, NULL,
           $$Buna capability negotiation (yetenek müzakeresi) denir ve her host ya da server'ın her MCP özelliğine ihtiyacı olmadığı için vardır -- yalnızca araç sunan minimal bir server resource desteği uygulamak zorunda değildir, ve bir client yalnızca belirli bir server'ın gerçekten belirttiği yeteneklere hazırlanır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'mcp-architecture'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Transport selection -- client'ın stdio ile Streamable HTTP arasında seçim yapması için vardır$$, FALSE, 0 FROM new_question_tr5
        UNION ALL SELECT id, $$Authentication -- server'ın herhangi bir bağlantıya izin vermeden önce client'ın kimliğini doğrulaması için vardır$$, FALSE, 1 FROM new_question_tr5
        UNION ALL SELECT id, $$Capability negotiation -- her host ya da server'ın her MCP özelliğini desteklemesi gerekmediği için vardır$$, TRUE, 2 FROM new_question_tr5
        UNION ALL SELECT id, $$Tool discovery -- client'ın mevcut tüm araçların adlarını öğrenmesi için vardır$$, FALSE, 3 FROM new_question_tr5;

-- Pair 6 / EN (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_en6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$This course's hands-on example connects its client and server using an in-memory transport instead of stdio or Streamable HTTP. According to this lesson, why?$$,
           NULL, NULL,
           $$The lesson explicitly frames the in-memory transport as a deliberate simplification for a self-contained, runnable lesson -- both sides run in the same process, exchanging the exact same JSON-RPC messages, and the lesson explicitly states a production setup almost always uses stdio or Streamable HTTP instead.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'mcp-architecture'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$In-memory transport is required whenever a server exposes more than one tool$$, FALSE, 0 FROM new_question_en6
        UNION ALL SELECT id, $$It's a deliberate simplification to keep the hands-on example self-contained and runnable -- production setups almost always use stdio or Streamable HTTP instead$$, TRUE, 1 FROM new_question_en6
        UNION ALL SELECT id, $$In-memory transport is the recommended production standard for all real MCP deployments$$, FALSE, 2 FROM new_question_en6
        UNION ALL SELECT id, $$stdio and Streamable HTTP are both deprecated and no longer supported by the MCP specification$$, FALSE, 3 FROM new_question_en6;

-- Pair 6 / TR (SINGLE_CHOICE, INTERMEDIATE)
WITH new_question_tr6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE',
           'PUBLISHED', 'CLAUDE',
           $$Bu kursun uygulamalı örneği, client ve server'ını stdio ya da Streamable HTTP yerine bir in-memory transport kullanarak bağlıyor. Bu derse göre, neden?$$,
           NULL, NULL,
           $$Ders, in-memory transport'u, kendi kendine yeten, çalıştırılabilir bir ders için bilinçli bir basitleştirme olarak açıkça çerçeveler -- her iki taraf da aynı süreç içinde çalışır, tam olarak aynı JSON-RPC mesajlarını değiş tokuş eder, ve ders bir production kurulumunun neredeyse her zaman bunun yerine stdio ya da Streamable HTTP kullandığını açıkça belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'mcp-architecture'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$In-memory transport, tüm gerçek MCP dağıtımları için önerilen production standardıdır$$, FALSE, 0 FROM new_question_tr6
        UNION ALL SELECT id, $$stdio ve Streamable HTTP'nin ikisi de kullanımdan kaldırılmıştır ve artık MCP spesifikasyonu tarafından desteklenmemektedir$$, FALSE, 1 FROM new_question_tr6
        UNION ALL SELECT id, $$Bir server birden fazla araç sunduğunda in-memory transport zorunludur$$, FALSE, 2 FROM new_question_tr6
        UNION ALL SELECT id, $$Uygulamalı örneği kendi kendine yeten ve çalıştırılabilir tutmak için bilinçli bir basitleştirmedir -- production kurulumları neredeyse her zaman bunun yerine stdio ya da Streamable HTTP kullanır$$, TRUE, 3 FROM new_question_tr6;

-- Pair 7 / EN (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_en7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'en', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Which of the following statements about MCP architecture, as covered in this lesson, are correct? (Select all that apply)$$,
           NULL, NULL,
           $$A and B are directly stated in the lesson (a JSON-RPC response carries a matching id with either a result or an error; which transport is used is invisible to the tool-calling logic, and a tool's name/description/behavior are identical regardless of transport); the lesson explicitly says a connection typically runs discovery and invocation many times after a single initialize phase, not the reverse, and the connection lifecycle applies across stdio, Streamable HTTP, and in-memory transports alike, not only to in-memory ones.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'mcp-architecture'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$A single MCP connection typically runs the initialize phase many times, once before every single discovery or invocation$$, FALSE, 0 FROM new_question_en7
        UNION ALL SELECT id, $$The initialize/discover/invoke lifecycle only applies to connections using the in-memory transport, not stdio or Streamable HTTP$$, FALSE, 1 FROM new_question_en7
        UNION ALL SELECT id, $$A JSON-RPC 2.0 response carries an id matching the request, along with either a result or an error$$, TRUE, 2 FROM new_question_en7
        UNION ALL SELECT id, $$A tool's name, description, and behavior are identical regardless of which transport (stdio, Streamable HTTP, or in-memory) carries the messages$$, TRUE, 3 FROM new_question_en7;

-- Pair 7 / TR (MULTIPLE_CHOICE, ADVANCED)
WITH new_question_tr7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED',
           'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, MCP mimarisi hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (bir JSON-RPC yanıtının isteğe uyan bir id ile birlikte ya bir result ya da bir error taşıması; hangi transport'un kullanıldığının tool-calling mantığı için görünmez olması, ve bir aracın adının/açıklamasının/davranışının transport'tan bağımsız olarak aynı olması); ders, bir bağlantının genellikle tek bir initialize aşamasından sonra keşif ve çağırmayı birçok kez tekrarladığını açıkça belirtir, tersini değil, ve initialize/discover/invoke yaşam döngüsü yalnızca in-memory transport'a değil, stdio ve Streamable HTTP'ye de aynı şekilde uygulanır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic WHERE slug = 'mcp-architecture'
    RETURNING id
)
INSERT INTO question_option (question_id, option_text, is_correct, sort_order)
    SELECT id, $$Bir JSON-RPC 2.0 yanıtı, isteğe uyan bir id ile birlikte ya bir result ya da bir error taşır$$, TRUE, 0 FROM new_question_tr7
        UNION ALL SELECT id, $$Bir aracın adı, açıklaması ve davranışı, mesajları hangi transport (stdio, Streamable HTTP ya da in-memory) taşırsa taşısın aynıdır$$, TRUE, 1 FROM new_question_tr7
        UNION ALL SELECT id, $$Tek bir MCP bağlantısı genellikle initialize aşamasını, her keşif veya çağırmadan önce bir kez olmak üzere birçok kez çalıştırır$$, FALSE, 2 FROM new_question_tr7
        UNION ALL SELECT id, $$Initialize/discover/invoke yaşam döngüsü yalnızca in-memory transport kullanan bağlantılara uygulanır, stdio ya da Streamable HTTP'ye değil$$, FALSE, 3 FROM new_question_tr7;
