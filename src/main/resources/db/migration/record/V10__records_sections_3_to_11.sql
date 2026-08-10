-- Record konusu, 3-11. bölümler (Record vs Class, Bileşenler, Üretilen Üyeler,
-- Immutability, Constructors, Özel Metotlar, Static Üyeler, Arayüz İmplementasyonu,
-- Nested Records) için örnek metadata'sı. Dosyaların kendisi examples/records/ altında;
-- bağlantı, enum konusunda olduğu gibi slug + example_name convention'ıyla kurulur.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Record vs Class: Klasik Sınıf (PersonClassic)', 'PersonClassic', 3
FROM topic WHERE slug = 'records';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Record vs Class: Record Karşılığı (PersonRecord)', 'PersonRecord', 4
FROM topic WHERE slug = 'records';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Generic Record (Pair)', 'PairExample', 5
FROM topic WHERE slug = 'records';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'equals() ve double/NaN Semantiği', 'EqualsSemanticsExample', 6
FROM topic WHERE slug = 'records';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Shallow Immutability Tuzağı (Team)', 'TeamMutableTrap', 7
FROM topic WHERE slug = 'records';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Compact Constructor ile Savunmacı Kopya', 'TeamDefensiveCopy', 8
FROM topic WHERE slug = 'records';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Compact Constructor ile Doğrulama (PersonValidated)', 'PersonValidated', 9
FROM topic WHERE slug = 'records';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Ek Constructor / Canonical''a Delegasyon', 'PersonOverloadedConstructor', 10
FROM topic WHERE slug = 'records';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Özel Metotlar (Rectangle)', 'RectangleExample', 11
FROM topic WHERE slug = 'records';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Static Factory ve Sabitler (PointWithFactory)', 'PointWithFactory', 12
FROM topic WHERE slug = 'records';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Comparable İmplementasyonu', 'ComparablePointExample', 13
FROM topic WHERE slug = 'records';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'İç İçe Record''lar (Employee + Address)', 'NestedRecordExample', 14
FROM topic WHERE slug = 'records';
