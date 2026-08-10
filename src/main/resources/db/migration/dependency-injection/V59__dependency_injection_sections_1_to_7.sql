-- Dependency Injection ve IoC konusu, 1-7. örnekler (Sıkı Bağlılık Problemi, Inversion of
-- Control, Sözleşmeye Karşı Programlamak, Constructor/Setter/Field Injection, Neden
-- Constructor Injection Öneriliyor?) için örnek metadata'sı. Dosyaların kendisi
-- examples/dependency-injection/ altında; bağlantı, önceki konularda olduğu gibi slug +
-- example_name convention'ıyla kurulur.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Sıkı Bağlılık (Tight Coupling) Problemi', 'TightlyCoupledOrderService', 1
FROM topic WHERE slug = 'dependency-injection';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Elle Factory ile Inversion of Control', 'ManualFactoryExample', 2
FROM topic WHERE slug = 'dependency-injection';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Arayüz Üzerinden Dependency Injection', 'NotificationSenderExample', 3
FROM topic WHERE slug = 'dependency-injection';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Constructor Injection', 'ConstructorInjectionExample', 4
FROM topic WHERE slug = 'dependency-injection';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Setter Injection', 'SetterInjectionExample', 5
FROM topic WHERE slug = 'dependency-injection';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Field Injection (Reflection ile Simülasyon)', 'FieldInjectionExample', 6
FROM topic WHERE slug = 'dependency-injection';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Fail-Fast Constructor Injection', 'ImmutableOrderService', 7
FROM topic WHERE slug = 'dependency-injection';
