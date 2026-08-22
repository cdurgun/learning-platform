-- Faz 80, Wave 4: "AI Agents" kategorisinin dört topic'inin (what-is-an-ai-agent,
-- agent-planning-and-reasoning, controlling-agent-behavior, building-an-ai-agent)
-- EN çevirileri V254/V255/V256/V257'de published=false olarak eklenmişti; TR/EN
-- içerik ve SEO metni bu oturumda birlikte yazılıp gözden geçirildiği için
-- (Faz 72'deki V252, Faz 70/71'deki V240/V246 ile aynı desen), hepsi burada tek
-- bir migration'la published=true'ya çevriliyor.

UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id IN (
      SELECT t.id
      FROM topic t
      JOIN category c ON t.category_id = c.id
      WHERE c.slug = 'ai-agents'
  );
