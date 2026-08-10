-- Faz 10: Inheritance'tan sonraki yedinci Java Basics konusu: Polymorphism. Inheritance
-- dersinin zaten kapsadığı upcasting/downcasting/method overriding/dynamic dispatch
-- konularını tekrar etmiyor -- bilinçli olarak daha yalın tutuldu ve yalnızca yeni
-- açılara (method overloading, overload çözümleme kuralları, covariant return type,
-- polymorphism vs inheritance ayrımı, composition + strategy pattern) odaklanıyor.
-- INTERMEDIATE zorluğunda, Interface/Abstract Class/Inheritance'la aynı seviyede.
-- Şimdilik yalnızca iskelet (topic + çeviriler) var -- estimated_minutes buna göre düşük
-- tutuldu, içerik önceki konularda yaptığımız gibi kademeli olarak eklenecek.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'polymorphism', 'INTERMEDIATE', 5, 7
FROM category
WHERE slug = 'java-basics';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Polymorphism',
       'Java''da çok biçimlilik (polymorphism); method overloading, overload çözümleme kuralları, covariant return type, polymorphism vs inheritance ve composition ile Strategy Pattern.',
       'Java Polymorphism (Çok Biçimlilik) Nedir? | Örneklerle Anlatım',
       'Java''da polymorphism kullanımı; compile-time (overloading) ve runtime (overriding) polymorphism, overload çözümleme kuralları, covariant return type, instanceof tasarım rehberliği, composition ile Strategy Pattern ve gerçek dünya örnekleriyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'polymorphism';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Polymorphism',
       'Polymorphism in Java; method overloading, overload resolution rules, covariant return types, polymorphism vs inheritance, and the Strategy pattern via composition.',
       'What is Java Polymorphism? | With Examples',
       'Learn Java polymorphism: compile-time (overloading) vs runtime (overriding) polymorphism, overload resolution rules, covariant return types, instanceof design guidance, the Strategy pattern via composition, and real-world examples.',
       false
FROM topic
WHERE slug = 'polymorphism';
