-- Faz 71, Wave 2: "Large Language Models" kategorisinin dört topic'inin (how-llms-work,
-- tokens-and-context-windows, prompting-and-prompt-engineering,
-- llm-capabilities-and-limitations) EN çevirileri V242/V243/V244/V245'te
-- published=false olarak eklenmişti; TR/EN içerik ve SEO metni bu oturumda birlikte
-- yazılıp gözden geçirildiği için (AI Fundamentals'taki V240 ile aynı desen), hepsi
-- burada tek bir migration'la published=true'ya çevriliyor.

UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id IN (
      SELECT t.id
      FROM topic t
      JOIN category c ON t.category_id = c.id
      WHERE c.slug = 'large-language-models'
  );
