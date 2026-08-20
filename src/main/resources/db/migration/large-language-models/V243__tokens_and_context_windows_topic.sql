-- Faz 71, Wave 2: "tokens-and-context-windows" konusunun topic_translation kayıtları.
-- TR yayında (published=true), EN standart iki adımlı yayın deseniyle önce
-- published=false ekleniyor (bkz. V242'deki aynı desen).

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'tr', 'Token''lar ve Context Window''lar',
       'Token''ların ve tokenization''ın ne olduğu, context window''un sert sınırı, context dolduğunda ne olduğu, ve truncation/summarization/retrieval ile sınırlı context''i yönetme stratejileri.',
       'Token''lar ve Context Window''lar — Large Language Models',
       'Token''lar ve context window''lar hakkında öğrenin: tokenization, context window sınırları, context dolduğunda ne olduğu, ve truncation/summarization/retrieval stratejileri.',
       true
FROM topic
WHERE slug = 'tokens-and-context-windows';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'en', 'Tokens and Context Windows',
       'What tokens and tokenization are, the hard limit of the context window, what happens when context fills up, and truncation/summarization/retrieval strategies for managing limited context.',
       'Tokens and Context Windows — Large Language Models',
       'Learn about tokens and context windows: tokenization, context window limits, what happens when context fills up, and truncation/summarization/retrieval strategies.',
       false
FROM topic
WHERE slug = 'tokens-and-context-windows';
