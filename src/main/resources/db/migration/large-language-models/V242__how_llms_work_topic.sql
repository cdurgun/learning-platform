-- Faz 71, Wave 2: "how-llms-work" konusunun topic_translation kayıtları. TR yayında
-- (published=true), EN standart iki adımlı yayın deseniyle önce published=false
-- ekleniyor (bkz. AI Fundamentals'taki V236-V239 aynı desen).

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'tr', 'Large Language Model''ler Nasıl Çalışır?',
       'LLM''lerin mekanik olarak ne olduğu, pretraining ve knowledge cutoff, base model ile instruction-tuned model farkı, ve in-context learning ile context kavramına ilk bakış.',
       'Large Language Model''ler Nasıl Çalışır? — Large Language Models',
       'Large Language Model''lerin nasıl çalıştığını öğrenin: pretraining, knowledge cutoff, base model ve instruction-tuned model farkı, in-context learning, ve context kavramına ilk bakış.',
       true
FROM topic
WHERE slug = 'how-llms-work';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'en', 'How Large Language Models Work',
       'What an LLM mechanically is, pretraining and knowledge cutoff, the difference between base and instruction-tuned models, and a first look at in-context learning and context.',
       'How Large Language Models Work — Large Language Models',
       'Learn how Large Language Models work: pretraining, knowledge cutoff, base vs. instruction-tuned models, in-context learning, and a first look at context.',
       false
FROM topic
WHERE slug = 'how-llms-work';
