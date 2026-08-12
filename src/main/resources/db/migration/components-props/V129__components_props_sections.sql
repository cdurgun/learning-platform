-- Components & Props kategorisinin üç topic'i, 13 örneğin tamamı. Dosyaların kendisi
-- examples/components/, examples/props/, examples/component-composition/ altında.

-- Components (4 örnek)
INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Fonksiyon Olarak Component Yazmak', 'FunctionComponentExample', 1
FROM topic WHERE slug = 'components';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Component''i Kullanmak (Render Etmek)', 'UsingComponentExample', 2
FROM topic WHERE slug = 'components';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Component İsimlendirme Kuralı', 'ComponentNamingExample', 3
FROM topic WHERE slug = 'components';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Yeniden Kullanılabilir Component''ler', 'ReusableButtonExample', 4
FROM topic WHERE slug = 'components';

-- Props (4 örnek)
INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Parent''tan Child''a Veri Göndermek', 'BasicPropsExample', 1
FROM topic WHERE slug = 'props';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Birden Fazla Prop Kullanmak', 'MultiplePropsExample', 2
FROM topic WHERE slug = 'props';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Destructuring ile Props Okumak', 'PropsDestructuringExample', 3
FROM topic WHERE slug = 'props';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Varsayılan Değerler (Default Props)', 'DefaultPropsExample', 4
FROM topic WHERE slug = 'props';

-- Component Composition (5 örnek)
INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'children Prop''u Nedir?', 'ChildrenPropExample', 1
FROM topic WHERE slug = 'component-composition';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'İç İçe Component''ler (Nested Components)', 'NestedComponentsExample', 2
FROM topic WHERE slug = 'component-composition';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Composition vs Inheritance (Kısa Bakış)', 'CompositionVsInheritanceExample', 3
FROM topic WHERE slug = 'component-composition';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Card Component''i — Parçalar', 'CardBase', 4
FROM topic WHERE slug = 'component-composition';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Card Component''i — Kullanım', 'CardDemo', 5
FROM topic WHERE slug = 'component-composition';
