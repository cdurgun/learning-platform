-- Faz 72, Wave 3: "tools-and-function-calling" konusunun topic_translation
-- kayıtları. TR yayında (published=true), EN standart iki adımlı yayın deseniyle
-- önce published=false ekleniyor (bkz. V240/V242-V245'teki aynı desen). "Tools & MCP"
-- kategorisinin İLK topic'i -- LLM'lerin tek başına yapamadığı şeyleri gerçek koda
-- bağlayan tool use/function calling mekanizmasını kod İÇERMEDEN kavramsal olarak
-- kuruyor (gerçek kod dördüncü topic'te gelecek).

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'tr', 'Tools and Function Calling',
       'Bir LLM''in gerçek kod çalıştırmasını isteyebilmesini sağlayan tool use/function calling mekanizması: tool-calling loop, bir tool''u tanımlamak, ve tool use''un bir "agent"tan farkı.',
       'Tools and Function Calling — Tools & MCP',
       'Tool use / function calling''ı öğrenin: tool-calling loop, bir tool''u name/description/schema ile tanımlamak, ve tool use ile agent arasındaki fark.',
       true
FROM topic
WHERE slug = 'tools-and-function-calling';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'en', 'Tools and Function Calling',
       'The tool use / function calling mechanism that lets an LLM request real code execution: the tool-calling loop, defining a tool, and how tool use differs from an "agent."',
       'Tools and Function Calling — Tools & MCP',
       'Learn tool use / function calling: the tool-calling loop, defining a tool with name/description/schema, and how tool use differs from an agent.',
       false
FROM topic
WHERE slug = 'tools-and-function-calling';
