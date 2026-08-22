-- Faz 80, Wave 4: "agent-planning-and-reasoning" konusunun topic_translation
-- kayıtları. TR yayında, EN published=false. "What Is an AI Agent?"ın agent
-- loop'unun "karar ver" adımına derinlemesine iniyor: ReAct, plan-and-execute,
-- reflection, ve termination (adım sınırı korkuluğuna, sıradaki topic olan
-- "Controlling Agent Behavior"a forward-reference ile).

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'tr', 'Agent Planlama ve Akıl Yürütme Kalıpları',
       'Bir agent''ın "karar ver" adımının somut kalıpları: ReAct, plan-and-execute, reflection, ve bir loop''un ne zaman durması gerektiği.',
       'Agent Planlama ve Akıl Yürütme Kalıpları — AI Agents',
       'Agent planlama kalıplarını öğrenin: ReAct, plan-and-execute, reflection, ve termination (ne zaman durulacağı).',
       true
FROM topic
WHERE slug = 'agent-planning-and-reasoning';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'en', 'Agent Planning and Reasoning Patterns',
       'Concrete patterns for an agent''s "decide" step: ReAct, plan-and-execute, reflection, and when a loop should actually stop.',
       'Agent Planning and Reasoning Patterns — AI Agents',
       'Learn agent planning patterns: ReAct, plan-and-execute, reflection, and termination (knowing when to stop).',
       false
FROM topic
WHERE slug = 'agent-planning-and-reasoning';
