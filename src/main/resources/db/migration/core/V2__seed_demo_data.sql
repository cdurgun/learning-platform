-- Demo verisi: Faz 2'de tamamen dolduracağımız "Enum" konusunun iskeleti.
-- Bilerek TR = yayında, EN = taslak olarak kuruldu; böylece "eksik çeviri" fallback
-- ekranını gerçek veriyle test edebiliyoruz.

INSERT INTO course (name, slug)
VALUES ('Java', 'java');

INSERT INTO category (course_id, name, slug)
SELECT id, 'Java Basics', 'java-basics'
FROM course
WHERE slug = 'java';

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'enum', 'BEGINNER', 15, 1
FROM category
WHERE slug = 'java-basics';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Enum',
       'Java''da sabit değer kümelerini tip güvenli şekilde tanımlama.',
       'Java Enum Nedir? | Örneklerle Anlatım',
       'Java''da enum kullanımı; constructor, method ve gerçek dünya örnekleriyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'enum';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Enum',
       'A type-safe way to define a fixed set of constants in Java.',
       'What is a Java Enum? | With Examples',
       'Learn Java enums with constructors, methods, and real-world examples.',
       false
FROM topic
WHERE slug = 'enum';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Basic Enum', 'BasicEnum', 1
FROM topic
WHERE slug = 'enum';
