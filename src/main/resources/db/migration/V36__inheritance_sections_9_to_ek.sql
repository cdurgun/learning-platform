-- Inheritance konusu, 9-13. bölümler (Upcasting, Downcasting ve instanceof, Çoklu
-- Kalıtımın Olmayışı, Inheritance vs Composition, Gerçek Dünya Örnekleri) ile iki mini
-- proje ekinin (Employee Hiyerarşisi, Vehicle Hiyerarşisi) örnek metadata'sı. Dosyaların
-- kendisi examples/inheritance/ altında; bağlantı, önceki konularda olduğu gibi slug +
-- example_name convention'ıyla kurulur.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Upcasting', 'UpcastingExample', 9
FROM topic WHERE slug = 'inheritance';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Downcasting ve instanceof', 'DowncastingExample', 10
FROM topic WHERE slug = 'inheritance';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Çoklu Kalıtım ve Diamond Problem', 'DiamondProblemExample', 11
FROM topic WHERE slug = 'inheritance';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Inheritance vs Composition', 'CompositionVsInheritanceExample', 12
FROM topic WHERE slug = 'inheritance';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Gerçek Dünya Örneği: İstisna Hiyerarşisi', 'RealWorldHierarchyExample', 13
FROM topic WHERE slug = 'inheritance';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Employee Hiyerarşisi', 'EmployeeHierarchy', 14
FROM topic WHERE slug = 'inheritance';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Employee Hiyerarşisi Kullanımı', 'EmployeeHierarchyDemo', 15
FROM topic WHERE slug = 'inheritance';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Vehicle Hiyerarşisi', 'VehicleHierarchy', 16
FROM topic WHERE slug = 'inheritance';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Vehicle Hiyerarşisi Kullanımı', 'VehicleHierarchyDemo', 17
FROM topic WHERE slug = 'inheritance';
