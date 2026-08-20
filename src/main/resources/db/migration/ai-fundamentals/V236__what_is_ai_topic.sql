-- Faz 70, Wave 1: "what-is-ai" konusunun topic_translation kayıtları. TR yayında
-- (published=true), EN standart iki adımlı yayın deseniyle önce published=false
-- ekleniyor -- içerik/SEO metni onaylandıktan sonra ayrı bir migration ile true'ya
-- çevrilecek (bkz. V124'teki aynı desen, ve CLAUDE.md'deki "iki adımlı yayın" kuralı).

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'tr', 'Yapay Zeka Nedir?',
       'Yapay zekanın gerçekte ne anlama geldiğine dair net bir harita -- dar ve genel yapay zeka, geleneksel yazılımdan farkı, ve Machine Learning, Deep Learning, Generative AI''ın birbiriyle ilişkisi.',
       'Yapay Zeka Nedir? — Yapay Zeka Temelleri',
       'Yapay zekanın gerçekte ne anlama geldiğini öğrenin: dar ve genel yapay zeka, yapay zekanın geleneksel kural tabanlı yazılımdan farkı, kısa bir tarihçe ve Machine Learning, Deep Learning, Generative AI''ın birbiriyle ilişkisi.',
       true
FROM topic
WHERE slug = 'what-is-ai';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'en', 'What Is Artificial Intelligence?',
       'A clear map of what AI actually means -- narrow vs. general AI, how it differs from traditional software, and where Machine Learning, Deep Learning, and Generative AI fit.',
       'What Is Artificial Intelligence? — AI Fundamentals',
       'Learn what artificial intelligence actually means: narrow vs. general AI, how AI differs from traditional rule-based software, a brief history, and how Machine Learning, Deep Learning, and Generative AI relate to each other.',
       false
FROM topic
WHERE slug = 'what-is-ai';
