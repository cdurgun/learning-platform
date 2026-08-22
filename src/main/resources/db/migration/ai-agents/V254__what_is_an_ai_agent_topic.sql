-- Faz 80, Wave 4: "what-is-an-ai-agent" konusunun topic_translation kayıtları.
-- TR yayında (published=true), EN standart iki adımlı yayın deseniyle önce
-- published=false ekleniyor (bkz. V248/V254 gibi önceki wave'lerdeki aynı desen).
-- "AI Agents" kategorisinin İLK topic'i -- daha önce birkaç dersten (tools-and-
-- function-calling, machine-learning, generative-ai) yalnızca forward-reference
-- edilen "agent" kavramını nihayet tanımlıyor: agent loop, tek bir tool call'dan
-- farkı, ve otonomi spektrumu.

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'tr', 'Bir AI Agent Nedir?',
       'Bir AI agent''i tanımlayan şey: gözlemle-karar ver-eyleme geç loop''u, tek bir tool call''dan farkı, ve otonomi spektrumu.',
       'Bir AI Agent Nedir? — AI Agents',
       'AI agent kavramını öğrenin: agent loop, bir tool call''i agent''tan ayıran şey, ve otonomi spektrumu.',
       true
FROM topic
WHERE slug = 'what-is-an-ai-agent';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'en', 'What Is an AI Agent?',
       'What defines an AI agent: the observe-decide-act loop, how it differs from a single tool call, and the autonomy spectrum.',
       'What Is an AI Agent? — AI Agents',
       'Learn what an AI agent is: the agent loop, what separates a tool call from an agent, and the autonomy spectrum.',
       false
FROM topic
WHERE slug = 'what-is-an-ai-agent';
