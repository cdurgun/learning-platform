-- Faz 72, Wave 3: "Tools & MCP" kategorisinin dört topic'inin (tools-and-function-calling,
-- introduction-to-mcp, mcp-architecture, building-an-mcp-server) EN çevirileri
-- V248/V249/V250/V251'de published=false olarak eklenmişti; TR/EN içerik ve SEO metni bu
-- oturumda birlikte yazılıp gözden geçirildiği için (AI Fundamentals'taki V240,
-- Large Language Models'taki V246 ile aynı desen), hepsi burada tek bir migration'la
-- published=true'ya çevriliyor.

UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id IN (
      SELECT t.id
      FROM topic t
      JOIN category c ON t.category_id = c.id
      WHERE c.slug = 'tools-mcp'
  );
