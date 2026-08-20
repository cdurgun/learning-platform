-- Faz 70, Wave 1: "generative-ai" konusunun topic_translation kayıtları. TR yayında
-- (published=true), EN standart iki adımlı yayın deseniyle önce published=false
-- ekleniyor (bkz. V236/V237/V238'deki aynı desen). Bu, "AI Fundamentals"
-- kategorisinin planlanan dördüncü ve SON topic'i -- bu migration'la Wave 1'in
-- içerik yazımı tamamlanıyor (yayına alma V240'ta ayrı bir adım).

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'tr', 'Generative AI',
       'Generative AI''ın discriminative modellerden farkı, metin/görüntü üreten modellerin nasıl çalıştığı, Large Language Model''lere kısa bir önizleme, ve akıcılık ile doğruluk arasındaki kritik ayrım.',
       'Generative AI Nedir? — Yapay Zeka Temelleri',
       'Generative AI''ın temellerini öğrenin: discriminative ve generative modeller arasındaki fark, metin ve görüntü üretiminin nasıl çalıştığı, Large Language Model''lere önizleme, akıcılık ile doğruluk ayrımı.',
       true
FROM topic
WHERE slug = 'generative-ai';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'en', 'Generative AI',
       'How Generative AI differs from discriminative models, how text/image generation actually works, a preview of Large Language Models, and the critical distinction between fluency and correctness.',
       'What Is Generative AI? — AI Fundamentals',
       'Learn the fundamentals of Generative AI: the difference between discriminative and generative models, how text and image generation works, a preview of Large Language Models, and fluency vs. correctness.',
       false
FROM topic
WHERE slug = 'generative-ai';
