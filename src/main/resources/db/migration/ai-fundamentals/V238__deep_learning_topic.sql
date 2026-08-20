-- Faz 70, Wave 1: "deep-learning" konusunun topic_translation kayıtları. TR yayında
-- (published=true), EN standart iki adımlı yayın deseniyle önce published=false
-- ekleniyor (bkz. V236/V237'deki aynı desen).

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'tr', 'Deep Learning',
       'Neural network''lerin nasıl yapılandırıldığı -- katmanlar, ağırlıklar, aktivasyon fonksiyonları -- ve backpropagation ile eğitim, ve CNN/RNN/transformer mimarilerine kısa bir bakış.',
       'Deep Learning Nedir? — Yapay Zeka Temelleri',
       'Deep Learning''in temellerini öğrenin: neural network''lerin yapısı, ağırlıklar ve aktivasyon fonksiyonları, backpropagation ile eğitim, ve CNN/RNN/transformer mimarilerine kısa bir bakış.',
       true
FROM topic
WHERE slug = 'deep-learning';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'en', 'Deep Learning',
       'How neural networks are structured -- layers, weights, activation functions -- how training works via backpropagation, and a brief look at CNN/RNN/transformer architectures.',
       'What Is Deep Learning? — AI Fundamentals',
       'Learn the fundamentals of Deep Learning: how neural networks are structured, weights and activation functions, training via backpropagation, and a brief look at CNN/RNN/transformer architectures.',
       false
FROM topic
WHERE slug = 'deep-learning';
