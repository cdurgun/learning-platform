-- Faz 72, Wave 3: "introduction-to-mcp" konusunun topic_translation kayıtları.
-- TR yayında, EN iki adımlı yayın deseniyle önce published=false. Kategorinin ikinci
-- topic'i -- Model Context Protocol'ün ne olduğunu, N×M entegrasyon probleminin neden
-- var olduğunu, host/client/server rollerini, ve tools/resources/prompts primitive'lerini
-- kavramsal olarak kuruyor.

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'tr', 'MCP''ye Giriş',
       'Model Context Protocol (MCP) nedir, hangi N×M entegrasyon problemini çözer, host/client/server rolleri, ve bir server''ın sunabileceği tools/resources/prompts primitive''leri.',
       'MCP''ye Giriş — Tools & MCP',
       'Model Context Protocol (MCP)''ye giriş: çözdüğü N×M entegrasyon problemi, host/client/server rolleri, ve tools/resources/prompts primitive''leri.',
       true
FROM topic
WHERE slug = 'introduction-to-mcp';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'en', 'Introduction to MCP',
       'What the Model Context Protocol (MCP) is, the N x M integration problem it solves, the host/client/server roles, and the tools/resources/prompts primitives a server can expose.',
       'Introduction to MCP — Tools & MCP',
       'An introduction to the Model Context Protocol (MCP): the N x M integration problem it solves, host/client/server roles, and tools/resources/prompts.',
       false
FROM topic
WHERE slug = 'introduction-to-mcp';
