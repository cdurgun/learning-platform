-- Faz 8: Enum, Record, Reflection ve Interface'ten sonraki beşinci Java Basics konusu:
-- Abstract Class. Interface dersindeki "Abstract Class vs Interface" bölümünün tam
-- karşı tarafı olarak tasarlandı; instance alanları, constructor ve Template Method
-- Pattern içerdiği için Record'la aynı INTERMEDIATE zorluğunda işaretlendi. Şimdilik
-- yalnızca iskelet (topic + çeviriler) var — estimated_minutes buna göre düşük tutuldu,
-- içerik önceki konularda yaptığımız gibi kademeli olarak eklenecek.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'abstract-class', 'INTERMEDIATE', 5, 5
FROM category
WHERE slug = 'java-basics';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Abstract Class',
       'Java''da ortak durum ve davranışı paylaşan soyut sınıflar; constructor, Template Method Pattern ve abstract class vs interface karşılaştırması.',
       'Java Abstract Class Nedir? | Örneklerle Anlatım',
       'Java''da abstract class kullanımı; soyut/concrete metotlar, constructor, Template Method Pattern, abstract class vs interface ve gerçek dünya örnekleriyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'abstract-class';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Abstract Class',
       'Abstract classes that share common state and behavior in Java; constructors, the Template Method pattern, and abstract class vs interface.',
       'What is a Java Abstract Class? | With Examples',
       'Learn Java abstract classes: abstract/concrete methods, constructors, the Template Method pattern, abstract class vs interface, and real-world examples.',
       false
FROM topic
WHERE slug = 'abstract-class';
