-- Faz 71, Wave 2: "llm-capabilities-and-limitations" konusunun topic_translation
-- kayıtları. TR yayında (published=true), EN standart iki adımlı yayın deseniyle
-- önce published=false ekleniyor (bkz. V242/V243/V244'teki aynı desen). Bu, "Large
-- Language Models" kategorisinin planlanan dördüncü ve SON topic'i -- bu migration'la
-- Wave 2'nin içerik yazımı tamamlanıyor (yayına alma V246'da ayrı bir adım).

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'tr', 'LLM Yetenekleri ve Sınırlamaları',
       'LLM''lerin gerçekten güçlü olduğu alanlar, hallucination''ın neden olduğu, knowledge cutoff''un etkisi, akıl yürütme sınırları, ve eğitim verisindeki bias''ın nasıl yeniden üretildiği.',
       'LLM Yetenekleri ve Sınırlamaları — Large Language Models',
       'LLM''lerin yetenek ve sınırlamalarını öğrenin: gerçek güçlü yönler, hallucination, knowledge cutoff, akıl yürütme sınırları, ve eğitim verisindeki bias.',
       true
FROM topic
WHERE slug = 'llm-capabilities-and-limitations';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'en', 'LLM Capabilities and Limitations',
       'What LLMs are genuinely strong at, why hallucination happens, the effect of knowledge cutoff, reasoning limits, and how bias in training data gets reproduced.',
       'LLM Capabilities and Limitations — Large Language Models',
       'Learn LLM capabilities and limitations: genuine strengths, hallucination, knowledge cutoff, reasoning limits, and bias in training data.',
       false
FROM topic
WHERE slug = 'llm-capabilities-and-limitations';
