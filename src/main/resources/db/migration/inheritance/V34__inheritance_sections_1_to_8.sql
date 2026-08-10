-- Inheritance konusu, 1-8. bölümler (Alt Sınıf Oluşturma ve Temel Terminoloji,
-- Constructor'lar ve super(), Method Overriding, super Anahtar Kelimesi, Erişim
-- Belirleyicilerin Etkisi, Field Hiding vs Method Overriding, final Sınıf ve final Metod,
-- Object Sınıfı) için örnek metadata'sı. Dosyaların kendisi examples/inheritance/
-- altında; bağlantı, önceki konularda olduğu gibi slug + example_name convention'ıyla
-- kurulur.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Alt Sınıf Oluşturma ve Temel Terminoloji', 'FirstInheritanceExample', 1
FROM topic WHERE slug = 'inheritance';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Constructor''lar ve super() Zinciri', 'ConstructorChainExample', 2
FROM topic WHERE slug = 'inheritance';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Method Overriding ve Dynamic Dispatch', 'MethodOverridingExample', 3
FROM topic WHERE slug = 'inheritance';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'super Anahtar Kelimesinin Üç Kullanımı', 'SuperKeywordExample', 4
FROM topic WHERE slug = 'inheritance';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Erişim Belirleyicilerin Inheritance Üzerindeki Etkisi', 'AccessModifiersExample', 5
FROM topic WHERE slug = 'inheritance';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Field Hiding vs Method Overriding', 'FieldHidingExample', 6
FROM topic WHERE slug = 'inheritance';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'final Sınıf ve final Metod', 'FinalClassAndMethodExample', 7
FROM topic WHERE slug = 'inheritance';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Object Sınıfı: toString, equals, hashCode', 'ObjectClassExample', 8
FROM topic WHERE slug = 'inheritance';
