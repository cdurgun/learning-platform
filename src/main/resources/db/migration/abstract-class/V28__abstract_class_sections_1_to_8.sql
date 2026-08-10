-- Abstract Class konusu, 1-8. bölümler (İlk Abstract Class'ını Yazmak, Abstract Class vs
-- Concrete Class, Abstract Metotlar, Concrete Metotlar, Alanlar, Constructor'lar, Override
-- Etmek ve Polimorfizm, Modifier ve Erişim Kuralları) için örnek metadata'sı. Dosyaların
-- kendisi examples/abstract-class/ altında; bağlantı, önceki konularda olduğu gibi slug +
-- example_name convention'ıyla kurulur.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'İlk Abstract Class Örneği', 'FirstAbstractClass', 1
FROM topic WHERE slug = 'abstract-class';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Abstract Class vs Concrete Class', 'AbstractVsConcreteExample', 2
FROM topic WHERE slug = 'abstract-class';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Çok Seviyeli Abstract Class Hiyerarşisi', 'AbstractMethodExample', 3
FROM topic WHERE slug = 'abstract-class';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Concrete (Somut) Metotlar', 'ConcreteMethodExample', 4
FROM topic WHERE slug = 'abstract-class';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Instance Alanları (protected)', 'FieldsExample', 5
FROM topic WHERE slug = 'abstract-class';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Abstract Class Constructor''ı ve super()', 'ConstructorExample', 6
FROM topic WHERE slug = 'abstract-class';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Override Etmek ve Polimorfizm', 'OverridingAndPolymorphismExample', 7
FROM topic WHERE slug = 'abstract-class';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Abstract Metotlarda Modifier Kuralları', 'ModifierRulesExample', 8
FROM topic WHERE slug = 'abstract-class';
