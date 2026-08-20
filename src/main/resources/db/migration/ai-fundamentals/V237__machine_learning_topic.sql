-- Faz 70, Wave 1: "machine-learning" konusunun topic_translation kayıtları. TR yayında
-- (published=true), EN standart iki adımlı yayın deseniyle önce published=false
-- ekleniyor (bkz. V236'daki aynı desen).

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'tr', 'Machine Learning',
       'Machine Learning''in gerçekte ne olduğu -- training ve inference farkı, supervised/unsupervised/reinforcement öğrenme türleri, ve overfitting/underfitting''in eğitimi nasıl yanlış gösterebileceği.',
       'Machine Learning Nedir? — Yapay Zeka Temelleri',
       'Machine Learning''in temellerini öğrenin: training ve inference farkı, supervised/unsupervised/reinforcement öğrenme türleri, feature ve label kavramları, overfitting ve underfitting.',
       true
FROM topic
WHERE slug = 'machine-learning';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id, 'en', 'Machine Learning',
       'What Machine Learning actually is -- the difference between training and inference, the three types of learning (supervised, unsupervised, reinforcement), and how overfitting and underfitting can make training go wrong.',
       'What Is Machine Learning? — AI Fundamentals',
       'Learn the fundamentals of Machine Learning: training vs. inference, supervised/unsupervised/reinforcement learning, features and labels, and overfitting vs. underfitting.',
       false
FROM topic
WHERE slug = 'machine-learning';
