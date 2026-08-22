-- Faz 80, Wave 4: "AI Agents" -- "ai" kursunun dorduncu kategorisi (sort_order=4),
-- "ai-fundamentals" (Faz 70), "large-language-models" (Faz 71) ve "tools-mcp"
-- (Faz 72-74) kategorilerinin ardindan. Kullanicinin onayladigi 4 topic'lik plan,
-- "Tools & MCP"nin "3 kavramsal + 1 uygulamali" desenini tekrarliyor: agent kavrami
-- ve agent loop -> planlama/akil yurutme kaliplari (ReAct, plan-and-execute,
-- reflection) -> davranisi kontrol etmek (guardrail, human-in-the-loop,
-- observability) -> TypeScript'te gercek bir agent loop insa etmek (onceki
-- kategorideki GeoFactsServer.ts MCP tool'larini gercekten cagiran, deterministik
-- ve acikca simule edilmis bir "mock model" kullanan, kullanicinin AskUserQuestion
-- ile onayladigi tasarim).

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'AI Agents', 'ai-agents', 4
FROM course
WHERE slug = 'ai';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'what-is-an-ai-agent', 'INTERMEDIATE', 18, 1
FROM category
WHERE slug = 'ai-agents';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'agent-planning-and-reasoning', 'INTERMEDIATE', 20, 2
FROM category
WHERE slug = 'ai-agents';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'controlling-agent-behavior', 'INTERMEDIATE', 18, 3
FROM category
WHERE slug = 'ai-agents';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'building-an-ai-agent', 'INTERMEDIATE', 30, 4
FROM category
WHERE slug = 'ai-agents';
