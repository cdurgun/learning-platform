INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Temel İç İçe for Döngüsü', 'NestedForBasicsExample', 1
FROM topic WHERE slug = 'nested-loops';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '2 Boyutlu Diziyle Çalışma', 'TwoDArrayExample', 2
FROM topic WHERE slug = 'nested-loops';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'İç İçe Döngülerde break', 'BreakInNestedLoopExample', 3
FROM topic WHERE slug = 'nested-loops';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'İç İçe Döngülerde continue', 'ContinueInNestedLoopExample', 4
FROM topic WHERE slug = 'nested-loops';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Etiketli break ve continue (Labeled break/continue)', 'LabeledBreakContinueExample', 5
FROM topic WHERE slug = 'nested-loops';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Performans: Neden O(n²)?', 'NestedLoopPerformanceExample', 6
FROM topic WHERE slug = 'nested-loops';
