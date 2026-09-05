-- Promotion-style migration linking TR mcp-architecture quiz questions to the
-- topic's fixed quiz created in this topic's quiz-shell migration -- same
-- NOT EXISTS/ON CONFLICT DO NOTHING pattern used by every prior quiz-link
-- migration in this project. All 7 TR questions from this topic's
-- promotion migration (hand-authored and self-reviewed -- no n8n, no
-- external AI API, no AI Judge). No selection/omission -- the entire
-- TR batch is linked.


-- Question 1/7 (Pair 1 TR, quiz position 1, type: SINGLE_CHOICE)
WITH existing_q1 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'mcp-architecture')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$MCP, bir client ile bir server arasında değiş tokuş edilen mesajlar için hangi tel (wire) formatını kullanır?$$
),
inserted_q1 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$MCP, bir client ile bir server arasında değiş tokuş edilen mesajlar için hangi tel (wire) formatını kullanır?$$,
           NULL, NULL,
           $$Ders açıktır: MCP kendi mesaj formatını icat etmez -- MCP'nin kendisiyle ilgisi olmayan, küçük, önceden var olan, genel amaçlı, metin tabanlı bir format olan JSON-RPC 2.0'ı tel formatı olarak benimser.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'mcp-architecture'
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
    ($$Tanımlı bir mesaj şekli olmayan, düz, yapılandırılmamış metin$$, FALSE, 0),
    ($$MCP'nin yerini aldığı, XML tabanlı bir öncül format olan XML-RPC$$, FALSE, 1),
    ($$JSON-RPC 2.0 -- MCP'nin kendi formatını icat etmek yerine benimsediği, önceden var olan, genel amaçlı bir mesaj formatı$$, TRUE, 2),
    ($$Özellikle ve yalnızca MCP için tasarlanmış özel bir ikili (binary) format$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q1.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q1.id, 1
FROM target_q1
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'mcp-architecture'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 2/7 (Pair 2 TR, quiz position 2, type: SINGLE_CHOICE)
WITH existing_q2 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'mcp-architecture')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derse göre, MCP'nin JSON-RPC mesajlarını taşıyan en yaygın iki transport nedir?$$
),
inserted_q2 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'BEGINNER', 'PUBLISHED', 'CLAUDE',
           $$Bu derse göre, MCP'nin JSON-RPC mesajlarını taşıyan en yaygın iki transport nedir?$$,
           NULL, NULL,
           $$Ders, en yaygın iki transport olarak stdio'yu (client, server'ı yerel bir alt süreç olarak başlatır, mesajlar standart girdi/çıktı üzerinden taşınır) ve Streamable HTTP'yi (server, HTTP üzerinden ulaşılabilen bağımsız, muhtemelen uzak bir süreç olarak çalışır) adlandırır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'mcp-architecture'
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
    ($$WebSockets ve gRPC$$, FALSE, 0),
    ($$FTP ve SMTP$$, FALSE, 1),
    ($$Bluetooth ve USB$$, FALSE, 2),
    ($$stdio ve Streamable HTTP$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q2.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q2.id, 2
FROM target_q2
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'mcp-architecture'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 3/7 (Pair 3 TR, quiz position 3, type: CODE_OUTPUT)
WITH existing_q3 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'mcp-architecture')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$MCP'nin bir aracı çağırmak için göndereceği bu JSON-RPC 2.0 isteği göz önüne alındığında, 'method' alanının değeri neyin olduğunu gösterir?$$
      AND code_snippet = $${
  "jsonrpc": "2.0",
  "id": 7,
  "method": "tools/call",
  "params": {
    "name": "hesapla_toplam",
    "arguments": { "sayilar": [3, 5, 9] }
  }
}$$
),
inserted_q3 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'CODE_OUTPUT', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
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
    FROM topic
    WHERE slug = 'mcp-architecture'
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
    ($$Bu bir araç çağırma isteğidir -- client, sunucudan hesapla_toplam aracını verilen argümanlarla gerçekten çalıştırmasını ister$$, TRUE, 0),
    ($$Bu, sunucudan mevcut tüm araçlarını listelemesini isteyen bir keşif isteğidir$$, FALSE, 1),
    ($$Bu, bir araç çağrısının sonucunu client'a geri döndüren sunucunun yanıtıdır$$, FALSE, 2),
    ($$Bu, client ile sunucu arasında protokol versiyonunu belirleyen bir initialize isteğidir$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q3.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q3.id, 3
FROM target_q3
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'mcp-architecture'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 4/7 (Pair 4 TR, quiz position 4, type: SINGLE_CHOICE)
WITH existing_q4 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'mcp-architecture')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu dersin anlattığı şekliyle, bir MCP bağlantısının yaşam döngüsünün üç aşamasını doğru sıraya koyun.$$
),
inserted_q4 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu dersin anlattığı şekliyle, bir MCP bağlantısının yaşam döngüsünün üç aşamasını doğru sıraya koyun.$$,
           NULL, NULL,
           $$Ders, yaşam döngüsünü önce Initialize (protokol versiyonu ve yetenekler üzerinde anlaşma), sonra Discover (tools/list, resources/list, prompts/list), sonra Invoke (tools/call, resources/read) şeklinde sıralar -- tek bir bağlantı genellikle bir kez initialize aşaması çalıştırır, sonra keşif ve çağırmayı birçok kez tekrarlar.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'mcp-architecture'
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
    ($$Önce Discover, sonra Invoke, sonra Initialize$$, FALSE, 0),
    ($$Önce Initialize, sonra Discover, sonra Invoke$$, TRUE, 1),
    ($$Önce Discover, sonra Initialize, sonra Invoke$$, FALSE, 2),
    ($$Önce Invoke, sonra Discover, sonra Initialize$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q4.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q4.id, 4
FROM target_q4
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'mcp-architecture'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 5/7 (Pair 5 TR, quiz position 5, type: SINGLE_CHOICE)
WITH existing_q5 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'mcp-architecture')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Initialize aşamasında, bir client ve server, hangi opsiyonel MCP özelliklerini gerçekten desteklediklerini (örneğin, sunucunun resource'ları hiç destekleyip desteklemediğini) her biri ayrı ayrı belirtir. Buna ne denir ve neden vardır?$$
),
inserted_q5 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Initialize aşamasında, bir client ve server, hangi opsiyonel MCP özelliklerini gerçekten desteklediklerini (örneğin, sunucunun resource'ları hiç destekleyip desteklemediğini) her biri ayrı ayrı belirtir. Buna ne denir ve neden vardır?$$,
           NULL, NULL,
           $$Buna capability negotiation (yetenek müzakeresi) denir ve her host ya da server'ın her MCP özelliğine ihtiyacı olmadığı için vardır -- yalnızca araç sunan minimal bir server resource desteği uygulamak zorunda değildir, ve bir client yalnızca belirli bir server'ın gerçekten belirttiği yeteneklere hazırlanır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'mcp-architecture'
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
    ($$Transport selection -- client'ın stdio ile Streamable HTTP arasında seçim yapması için vardır$$, FALSE, 0),
    ($$Authentication -- server'ın herhangi bir bağlantıya izin vermeden önce client'ın kimliğini doğrulaması için vardır$$, FALSE, 1),
    ($$Capability negotiation -- her host ya da server'ın her MCP özelliğini desteklemesi gerekmediği için vardır$$, TRUE, 2),
    ($$Tool discovery -- client'ın mevcut tüm araçların adlarını öğrenmesi için vardır$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q5.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q5.id, 5
FROM target_q5
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'mcp-architecture'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 6/7 (Pair 6 TR, quiz position 6, type: SINGLE_CHOICE)
WITH existing_q6 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'mcp-architecture')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu kursun uygulamalı örneği, client ve server'ını stdio ya da Streamable HTTP yerine bir in-memory transport kullanarak bağlıyor. Bu derse göre, neden?$$
),
inserted_q6 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'SINGLE_CHOICE', 'INTERMEDIATE', 'PUBLISHED', 'CLAUDE',
           $$Bu kursun uygulamalı örneği, client ve server'ını stdio ya da Streamable HTTP yerine bir in-memory transport kullanarak bağlıyor. Bu derse göre, neden?$$,
           NULL, NULL,
           $$Ders, in-memory transport'u, kendi kendine yeten, çalıştırılabilir bir ders için bilinçli bir basitleştirme olarak açıkça çerçeveler -- her iki taraf da aynı süreç içinde çalışır, tam olarak aynı JSON-RPC mesajlarını değiş tokuş eder, ve ders bir production kurulumunun neredeyse her zaman bunun yerine stdio ya da Streamable HTTP kullandığını açıkça belirtir.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'mcp-architecture'
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
    ($$In-memory transport, tüm gerçek MCP dağıtımları için önerilen production standardıdır$$, FALSE, 0),
    ($$stdio ve Streamable HTTP'nin ikisi de kullanımdan kaldırılmıştır ve artık MCP spesifikasyonu tarafından desteklenmemektedir$$, FALSE, 1),
    ($$Bir server birden fazla araç sunduğunda in-memory transport zorunludur$$, FALSE, 2),
    ($$Uygulamalı örneği kendi kendine yeten ve çalıştırılabilir tutmak için bilinçli bir basitleştirmedir -- production kurulumları neredeyse her zaman bunun yerine stdio ya da Streamable HTTP kullanır$$, TRUE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q6.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q6.id, 6
FROM target_q6
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'mcp-architecture'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;

-- Question 7/7 (Pair 7 TR, quiz position 7, type: MULTIPLE_CHOICE)
WITH existing_q7 AS (
    SELECT id FROM question
    WHERE topic_id = (SELECT id FROM topic WHERE slug = 'mcp-architecture')
      AND language = 'tr'
      AND status = 'PUBLISHED'
      AND question = $$Bu derste anlatılanlara göre, MCP mimarisi hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$
),
inserted_q7 AS (
    INSERT INTO question (topic_id, language, type, difficulty, status, source,
                           question, code_snippet, code_language, explanation,
                           reviewed_by, reviewed_at, created_at, updated_at)
    SELECT id, 'tr', 'MULTIPLE_CHOICE', 'ADVANCED', 'PUBLISHED', 'CLAUDE',
           $$Bu derste anlatılanlara göre, MCP mimarisi hakkında aşağıdaki ifadelerden hangileri doğrudur? (Uygun olan tüm seçenekleri işaretleyin)$$,
           NULL, NULL,
           $$A ve B derste doğrudan belirtilir (bir JSON-RPC yanıtının isteğe uyan bir id ile birlikte ya bir result ya da bir error taşıması; hangi transport'un kullanıldığının tool-calling mantığı için görünmez olması, ve bir aracın adının/açıklamasının/davranışının transport'tan bağımsız olarak aynı olması); ders, bir bağlantının genellikle tek bir initialize aşamasından sonra keşif ve çağırmayı birçok kez tekrarladığını açıkça belirtir, tersini değil, ve initialize/discover/invoke yaşam döngüsü yalnızca in-memory transport'a değil, stdio ve Streamable HTTP'ye de aynı şekilde uygulanır.$$, $$claude-code@anthropic.com$$, '2026-09-04 00:00:00',
           now(), now()
    FROM topic
    WHERE slug = 'mcp-architecture'
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
    ($$Bir JSON-RPC 2.0 yanıtı, isteğe uyan bir id ile birlikte ya bir result ya da bir error taşır$$, TRUE, 0),
    ($$Bir aracın adı, açıklaması ve davranışı, mesajları hangi transport (stdio, Streamable HTTP ya da in-memory) taşırsa taşısın aynıdır$$, TRUE, 1),
    ($$Tek bir MCP bağlantısı genellikle initialize aşamasını, her keşif veya çağırmadan önce bir kez olmak üzere birçok kez çalıştırır$$, FALSE, 2),
    ($$Initialize/discover/invoke yaşam döngüsü yalnızca in-memory transport kullanan bağlantılara uygulanır, stdio ya da Streamable HTTP'ye değil$$, FALSE, 3)
        ) AS v(option_text, is_correct, sort_order)
    WHERE target_q7.newly_inserted
    RETURNING 1
)
INSERT INTO quiz_question_link (quiz_id, question_id, position)
SELECT quiz.id, target_q7.id, 7
FROM target_q7
         JOIN quiz ON TRUE
         JOIN topic t ON t.id = quiz.topic_id
WHERE t.slug = 'mcp-architecture'
  AND quiz.language = 'tr'
  AND quiz.slug = 'default'
ON CONFLICT (quiz_id, question_id) DO NOTHING;
