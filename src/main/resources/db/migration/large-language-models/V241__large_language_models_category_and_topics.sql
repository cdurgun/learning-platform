-- Faz 71, Wave 2: "ai" kursuna ikinci kategori -- "Large Language Models"
-- (category.sort_order=2, ai-fundamentals'tan sonra). Kullanıcı onayladığı ~7
-- kategori/~30 topic'lik planın ikinci durağı; bu kategori, AI Fundamentals'ın
-- "Generative AI" dersindeki "Large Language Models: A Preview" bölümünün
-- doğrudan devamı -- LLM'lerin nasıl çalıştığı, context/prompting kavramları,
-- ve yetenek/sınırlamaları derinlemesine ele alınıyor. AI Fundamentals'ın aksine
-- bu kategori BİLİNÇLİ OLARAK INTERMEDIATE -- önceki kategorinin (AI/ML/DL/GenAI
-- haritası, training/inference, transformer mimarisi) bilindiği varsayılıyor.
-- Kullanıcı onayıyla belirlenen içerik ilkesi (matematiksel derinlikten kaçın,
-- kavramsal/pratik netliği önceliklendir) burada da geçerli; bu dört topic de
-- AI Fundamentals'taki gibi BİLİNÇLİ OLARAK kod İÇERMİYOR -- gerçek çalıştırılabilir
-- Node/TypeScript kodu (LLM API çağrıları dahil) ilk kez "Tools & MCP" kategorisinde
-- gelecek, kullanıcı onayladığı Node/TypeScript stack kararı orada devreye girecek.

INSERT INTO category (course_id, name, slug, sort_order)
SELECT id, 'Large Language Models', 'large-language-models', 2
FROM course
WHERE slug = 'ai';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'how-llms-work', 'INTERMEDIATE', 20, 1
FROM category
WHERE slug = 'large-language-models';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'tokens-and-context-windows', 'INTERMEDIATE', 18, 2
FROM category
WHERE slug = 'large-language-models';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'prompting-and-prompt-engineering', 'INTERMEDIATE', 20, 3
FROM category
WHERE slug = 'large-language-models';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'llm-capabilities-and-limitations', 'INTERMEDIATE', 20, 4
FROM category
WHERE slug = 'large-language-models';
