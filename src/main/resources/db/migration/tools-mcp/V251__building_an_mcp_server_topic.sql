-- Faz 72, Wave 3: "building-an-mcp-server" konusunun topic_translation kayıtları.
-- TR yayında, EN iki adımlı yayın deseniyle önce published=false. "Tools & MCP"
-- kategorisinin dördüncü ve SON topic'i -- bu migration'la Wave 3'ün içerik yazımı
-- tamamlanıyor (yayına alma V252'de ayrı bir adım). Kullanıcı onaylı Node/TypeScript
-- stack kararının ilk kez devreye girdiği ders: gerçek npm install + tsc + node ile
-- bu sandbox'ta uçtan uca doğrulanmış @modelcontextprotocol/sdk (1.30.0) kullanan bir
-- MCP server/client örneği içeriyor (examples/building-an-mcp-server/GeoFactsServer.ts,
-- RunServerWithClient.ts).

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'tr', 'TypeScript ile MCP Sunucusu Oluşturma',
       'Resmi TypeScript SDK''sıyla gerçek, çalıştırılabilir bir MCP server ve client inşa etme: proje kurulumu, registerTool ile tool tanımlama, in-memory transport üzerinden bağlanma, ve gerçek çıktı.',
       'TypeScript ile MCP Sunucusu Oluşturma — Tools & MCP',
       '@modelcontextprotocol/sdk ile gerçek bir MCP server/client oluşturmayı öğrenin: proje kurulumu, registerTool, in-memory transport, ve gerçek, doğrulanmış çıktı.',
       true
FROM topic
WHERE slug = 'building-an-mcp-server';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'en', 'Building an MCP Server',
       'Building a real, runnable MCP server and client with the official TypeScript SDK: project setup, defining tools with registerTool, connecting over an in-memory transport, and real output.',
       'Building an MCP Server — Tools & MCP',
       'Learn to build a real MCP server/client with @modelcontextprotocol/sdk: project setup, registerTool, an in-memory transport, and real, verified output.',
       false
FROM topic
WHERE slug = 'building-an-mcp-server';
