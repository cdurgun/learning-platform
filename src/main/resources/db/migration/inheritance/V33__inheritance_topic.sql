-- Faz 9: Abstract Class'tan sonraki altıncı Java Basics konusu: Inheritance. Abstract
-- Class ve Interface derslerinin zaten kullandığı extends/super/@Override mekanizmasının
-- kendisini temelden ele alıyor; field hiding, diamond problem ve composition vs
-- inheritance gibi Record/Interface/Abstract Class'la aynı derinlikte konular içerdiği
-- için INTERMEDIATE zorluğunda işaretlendi. Şimdilik yalnızca iskelet (topic + çeviriler)
-- var -- estimated_minutes buna göre düşük tutuldu, içerik önceki konularda yaptığımız
-- gibi kademeli olarak eklenecek.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'inheritance', 'INTERMEDIATE', 5, 6
FROM category
WHERE slug = 'java-basics';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Inheritance',
       'Java''da kalıtım (inheritance); extends, constructor zinciri, method overriding, field hiding, upcasting/downcasting ve composition vs inheritance karşılaştırması.',
       'Java Inheritance (Kalıtım) Nedir? | Örneklerle Anlatım',
       'Java''da inheritance kullanımı; extends, super, constructor zinciri, method overriding, field hiding, Object sınıfı, upcasting/downcasting, diamond problem ve composition vs inheritance gerçek dünya örnekleriyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'inheritance';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Inheritance',
       'Inheritance in Java; extends, the constructor chain, method overriding, field hiding, upcasting/downcasting, and composition vs inheritance.',
       'What is Java Inheritance? | With Examples',
       'Learn Java inheritance: extends, super, the constructor chain, method overriding, field hiding, the Object class, upcasting/downcasting, the diamond problem, and composition vs inheritance with real-world examples.',
       false
FROM topic
WHERE slug = 'inheritance';
