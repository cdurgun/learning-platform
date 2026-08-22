-- Faz 80, Wave 4: "building-an-ai-agent" konusunun topic_translation
-- kayıtları. TR yayında, EN published=false. "AI Agents" kategorisinin son ve
-- tek uygulamalı topic'i -- kullanıcının AskUserQuestion ile onayladığı
-- "mock model + gerçek MCP tool" tasarımıyla: karar adımı (decideNextAction())
-- deterministik ve açıkça "(simulated)" etiketli, ama agent loop'un kendisi,
-- her tool call, ve MCP iletişimi gerçek -- "Building an MCP Server"daki
-- GeoFactsServer.ts'yi değiştirmeden yeniden kullanarak. Kod (GeoFactsServer.ts,
-- AgentLoop.ts, RunAgentDemo.ts) gerçekten npm install + npx tsc + node ile
-- derlenip çalıştırılarak, lessondaki tüm çıktı gerçek terminal çıktısıyla
-- birebir eşleşecek şekilde doğrulandı.

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'tr', 'TypeScript ile Bir AI Agent Oluşturma',
       'Gerçek, çalışan bir agent loop inşa edin: deterministik, açıkça simüle edilmiş bir karar adımı, "Building an MCP Server"daki gerçek MCP tool''larını gerçekten çağırıyor.',
       'TypeScript ile Bir AI Agent Oluşturma — AI Agents',
       'TypeScript''te gerçek bir agent loop inşa edin: simüle edilmiş bir karar adımı, gerçek MCP tool call''ları, ve bir adım sınırı korkuluğu.',
       true
FROM topic
WHERE slug = 'building-an-ai-agent';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'en', 'Building an AI Agent in TypeScript',
       'Build a real, running agent loop: a deterministic, explicitly simulated decision step genuinely calling the real MCP tools from "Building an MCP Server."',
       'Building an AI Agent in TypeScript — AI Agents',
       'Build a real agent loop in TypeScript: a simulated decision step, real MCP tool calls, and a step-limit guardrail.',
       false
FROM topic
WHERE slug = 'building-an-ai-agent';
