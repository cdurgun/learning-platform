-- Faz 70, Wave 1: "AI Fundamentals" kategorisinin dört topic'inin (what-is-ai,
-- machine-learning, deep-learning, generative-ai) EN çevirileri V236/V237/V238/V239'da
-- published=false olarak eklenmişti; TR/EN içerik ve SEO metni bu oturumda birlikte
-- yazılıp gözden geçirildiği için (react-fundamentals/V124+V127'deki standart iki
-- adımlı desenle aynı), hepsi burada tek bir migration'la published=true'ya çevriliyor.

UPDATE topic_translation
SET published = true
WHERE language = 'en'
  AND topic_id IN (
      SELECT t.id
      FROM topic t
      JOIN category c ON t.category_id = c.id
      WHERE c.slug = 'ai-fundamentals'
  );
