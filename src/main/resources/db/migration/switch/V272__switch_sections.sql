INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Klasik switch Sözdizimi', 'SwitchBasicsExample', 1
FROM topic WHERE slug = 'switch';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Fall-Through: break Unutmanın Bedeli', 'FallThroughExample', 2
FROM topic WHERE slug = 'switch';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Modern Ok (Arrow) Sözdizimi', 'ArrowSwitchExample', 3
FROM topic WHERE slug = 'switch';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'switch İfadesi ve yield', 'SwitchExpressionExample', 4
FROM topic WHERE slug = 'switch';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Birden Fazla Etiket ve Kapsayıcılık (Exhaustiveness)', 'MultipleLabelsAndDefaultExample', 5
FROM topic WHERE slug = 'switch';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'switch ile String ve Enum Üzerinde Çalışmak', 'SwitchOnStringAndEnumExample', 6
FROM topic WHERE slug = 'switch';
