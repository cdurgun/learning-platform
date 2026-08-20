-- Faz 71, Wave 2: "prompting-and-prompt-engineering" konusunun topic_translation
-- kayıtları. TR yayında (published=true), EN standart iki adımlı yayın deseniyle
-- önce published=false ekleniyor (bkz. V242/V243'teki aynı desen).

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'tr', 'Prompting and Prompt Engineering',
       'Prompt yapısı (system/user/assistant rolleri), zero-shot ve few-shot prompting, etkili prompt yazma pratikleri, ve chain-of-thought gibi yaygın prompting tekniklerine giriş.',
       'Prompting and Prompt Engineering — Large Language Models',
       'Prompting ve prompt engineering''i öğrenin: system/user/assistant rolleri, zero-shot ve few-shot prompting, etkili prompt yazma pratikleri, ve chain-of-thought gibi teknikler.',
       true
FROM topic
WHERE slug = 'prompting-and-prompt-engineering';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'en', 'Prompting and Prompt Engineering',
       'Prompt structure (system/user/assistant roles), zero-shot and few-shot prompting, effective prompt-writing practices, and an introduction to common techniques like chain-of-thought.',
       'Prompting and Prompt Engineering — Large Language Models',
       'Learn prompting and prompt engineering: system/user/assistant roles, zero-shot and few-shot prompting, effective prompt-writing practices, and techniques like chain-of-thought.',
       false
FROM topic
WHERE slug = 'prompting-and-prompt-engineering';
