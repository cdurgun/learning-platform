-- Interface konusu, 1-8. bölümler (İlk Interface'ini Yazmak, Soyut Metotlar, Constant
-- Alanlar, Interface Implement Etmek, Çoklu Interface Implement Etmek, Interface'in
-- Interface'i Genişletmesi, Default Metotlar, Static Metotlar) için örnek metadata'sı.
-- Dosyaların kendisi examples/interface/ altında; bağlantı, önceki konularda olduğu gibi
-- slug + example_name convention'ıyla kurulur.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'İlk Interface Örneği', 'FirstInterface', 1
FROM topic WHERE slug = 'interface';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Soyut Metotların Örtük Modifier''ları', 'AbstractMethodExample', 2
FROM topic WHERE slug = 'interface';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Interface Sabitleri (public static final)', 'InterfaceConstantsExample', 3
FROM topic WHERE slug = 'interface';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Interface Implementasyonu ve Polimorfizm', 'ShapeImplementationExample', 4
FROM topic WHERE slug = 'interface';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Çoklu Interface Implementasyonu', 'MultipleInterfaceExample', 5
FROM topic WHERE slug = 'interface';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Interface''in Interface''i Genişletmesi', 'InterfaceExtendsExample', 6
FROM topic WHERE slug = 'interface';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Default Metotlar (Java 8)', 'DefaultMethodExample', 7
FROM topic WHERE slug = 'interface';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Static Metotlar (Java 8)', 'StaticMethodExample', 8
FROM topic WHERE slug = 'interface';
