-- Interface konusu, 9-20. bölümler (Private Metotlar, Diamond Problem ve Çözümü,
-- Interface vs Abstract Class, Functional Interface ve Lambda, Sealed Interface,
-- Gerçek Dünya Kullanım Alanları, Best Practices, Yaygın Hatalar, Özet) ile iki mini
-- proje ekinin (Plugin Registry, Event Bus) örnek metadata'sı. Dosyaların kendisi
-- examples/interface/ altında; bağlantı, önceki konularda olduğu gibi slug + example_name
-- convention'ıyla kurulur.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Private Metotlar (Java 9)', 'PrivateMethodExample', 9
FROM topic WHERE slug = 'interface';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Diamond Problem ve Çözümü', 'DiamondProblemExample', 10
FROM topic WHERE slug = 'interface';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Functional Interface ve Lambda', 'FunctionalInterfaceExample', 11
FROM topic WHERE slug = 'interface';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Sealed Interface (Java 17)', 'SealedInterfaceExample', 12
FROM topic WHERE slug = 'interface';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Comparable ile Gerçek Dünya Örneği', 'ComparableImplementationExample', 13
FROM topic WHERE slug = 'interface';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Plugin Registry', 'PluginRegistry', 14
FROM topic WHERE slug = 'interface';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Plugin Registry Kullanımı', 'PluginRegistryDemo', 15
FROM topic WHERE slug = 'interface';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Event Bus', 'EventBus', 16
FROM topic WHERE slug = 'interface';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Event Bus Kullanımı', 'EventBusDemo', 17
FROM topic WHERE slug = 'interface';
