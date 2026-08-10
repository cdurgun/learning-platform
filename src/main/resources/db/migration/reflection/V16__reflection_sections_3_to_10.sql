-- Reflection konusu, 3-10. bölümler (Class Nesnesi Elde Etmek, Sınıf Bilgisini
-- İncelemek, Alanları Okumak, Metotları Okumak, Constructor'ları Okumak, Nesneleri
-- Dinamik Oluşturmak, Metotları Dinamik Çağırmak, Private Alan/Metotlara Erişmek) için
-- örnek metadata'sı. Dosyaların kendisi examples/reflection/ altında; bağlantı, enum ve
-- record konularında olduğu gibi slug + example_name convention'ıyla kurulur.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Class Nesnesi Elde Etmenin Üç Yolu', 'ThreeWaysToGetClass', 1
FROM topic WHERE slug = 'reflection';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Sınıf Bilgisini İnceleme', 'ClassInfoExample', 2
FROM topic WHERE slug = 'reflection';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'getFields() vs getDeclaredFields()', 'FieldsExample', 3
FROM topic WHERE slug = 'reflection';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'getMethods() vs getDeclaredMethods()', 'MethodsExample', 4
FROM topic WHERE slug = 'reflection';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Constructor İmzalarını Keşfetme', 'ConstructorsExample', 5
FROM topic WHERE slug = 'reflection';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'newInstance() ile Dinamik Nesne Oluşturma', 'DynamicObjectCreation', 6
FROM topic WHERE slug = 'reflection';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'invoke() ile Dinamik Metot Çağırma', 'DynamicMethodInvocation', 7
FROM topic WHERE slug = 'reflection';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'setAccessible() ile Private Erişim', 'PrivateAccessExample', 8
FROM topic WHERE slug = 'reflection';
