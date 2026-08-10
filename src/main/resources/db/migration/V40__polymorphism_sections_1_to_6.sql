-- Polymorphism konusu, 1-6. bölümler (Compile-Time vs Runtime Polymorphism, Method
-- Overloading, Overload Çözümleme Kuralları, Covariant Return Type, Polymorphism vs
-- Inheritance, Interface ve Abstract Class ile Polymorphism) için örnek metadata'sı.
-- Dosyaların kendisi examples/polymorphism/ altında; bağlantı, önceki konularda olduğu
-- gibi slug + example_name convention'ıyla kurulur.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Compile-Time vs Runtime Polymorphism', 'PolymorphismOverviewExample', 1
FROM topic WHERE slug = 'polymorphism';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Method Overloading', 'OverloadingExample', 2
FROM topic WHERE slug = 'polymorphism';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Overload Çözümleme Kuralları', 'OverloadResolutionExample', 3
FROM topic WHERE slug = 'polymorphism';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Covariant Return Type', 'CovariantReturnTypeExample', 4
FROM topic WHERE slug = 'polymorphism';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Polymorphism vs Inheritance', 'PolymorphismVsInheritanceExample', 5
FROM topic WHERE slug = 'polymorphism';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Comparable ile Interface Polymorphism''i', 'ComparableExample', 6
FROM topic WHERE slug = 'polymorphism';
