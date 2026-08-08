-- Enum'dan sonraki ikinci Java Basics konusu: Record. Şimdilik yalnızca 1. bölüm
-- (Introduction) yazıldı — estimated_minutes buna göre düşük tutuldu, içerik büyüdükçe
-- Enum'da yaptığımız gibi güncellenecek.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'records', 'INTERMEDIATE', 5, 2
FROM category
WHERE slug = 'java-basics';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Record',
       'Java''da sabit (immutable) veri taşıyıcıları tek satırda tanımlama.',
       'Java Record Nedir? | Örneklerle Anlatım',
       'Java''da record kullanımı; constructor, immutability ve gerçek dünya örnekleriyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'records';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Record',
       'Defining immutable data carriers in a single line in Java.',
       'What is a Java Record? | With Examples',
       'Learn Java records with constructors, immutability, and real-world examples.',
       false
FROM topic
WHERE slug = 'records';
