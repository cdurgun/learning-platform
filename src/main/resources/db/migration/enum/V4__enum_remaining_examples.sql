-- Faz 2 devamı: kalan bölümler için (Metotlar, Interface, Abstract Method, EnumSet,
-- EnumMap, Singleton, Strategy Pattern, Gerçek Dünya Örnekleri) örnek metadata'sı.
-- Dosyaların kendisi examples/enum/ altında; bağlantı slug + example_name convention'ıyla.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Instance Metodu (DayWithMethod)', 'DayWithMethod', 4
FROM topic WHERE slug = 'enum';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Arayüz İmplementasyonu (TrafficLight)', 'InterfaceExample', 5
FROM topic WHERE slug = 'enum';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Soyut Metot / Sabite Özel Gövde (Operation)', 'AbstractMethodExample', 6
FROM topic WHERE slug = 'enum';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'EnumSet Kullanımı', 'EnumSetExample', 7
FROM topic WHERE slug = 'enum';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'EnumMap Kullanımı', 'EnumMapExample', 8
FROM topic WHERE slug = 'enum';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Singleton Deseni (ConfigurationManager)', 'SingletonExample', 9
FROM topic WHERE slug = 'enum';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Strategy Pattern (ShippingStrategy)', 'StrategyPatternExample', 10
FROM topic WHERE slug = 'enum';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Gerçek Dünya Örneği: Sipariş Durum Makinesi', 'RealWorldExample', 11
FROM topic WHERE slug = 'enum';
