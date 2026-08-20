-- Faz 72, Wave 3: "mcp-architecture" konusunun topic_translation kayıtları. TR
-- yayında, EN iki adımlı yayın deseniyle önce published=false. Kategorinin üçüncü
-- topic'i -- JSON-RPC 2.0 mesaj biçimini, stdio/Streamable HTTP transport'larını,
-- initialize/discover/invoke bağlantı yaşam döngüsünü, ve capability negotiation'ı
-- kapsıyor; dördüncü topic'teki in-memory transport örneğinin neden o şekilde
-- kurulduğunu bu derste açıklıyor.

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'tr', 'MCP Mimarisi',
       'MCP''nin mesaj biçimi olan JSON-RPC 2.0, stdio ve Streamable HTTP transport''ları, initialize/discover/invoke bağlantı yaşam döngüsü, ve capability negotiation.',
       'MCP Mimarisi — Tools & MCP',
       'MCP mimarisini öğrenin: JSON-RPC 2.0 mesaj biçimi, stdio/Streamable HTTP transport''ları, bağlantı yaşam döngüsü, ve capability negotiation.',
       true
FROM topic
WHERE slug = 'mcp-architecture';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'en', 'MCP Architecture',
       'The JSON-RPC 2.0 message format MCP uses, the stdio and Streamable HTTP transports, the initialize/discover/invoke connection lifecycle, and capability negotiation.',
       'MCP Architecture — Tools & MCP',
       'Learn MCP architecture: the JSON-RPC 2.0 message format, stdio/Streamable HTTP transports, the connection lifecycle, and capability negotiation.',
       false
FROM topic
WHERE slug = 'mcp-architecture';
