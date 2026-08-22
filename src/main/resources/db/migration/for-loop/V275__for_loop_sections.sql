INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Temel for Döngüsü Sözdizimi', 'ForLoopBasicsExample', 1
FROM topic WHERE slug = 'for-loop';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'break ile Döngüden Çıkmak', 'BreakExample', 2
FROM topic WHERE slug = 'for-loop';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'continue ile Bir Adımı Atlamak', 'ContinueExample', 3
FROM topic WHERE slug = 'for-loop';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Sonsuz Döngüler', 'InfiniteLoopExample', 4
FROM topic WHERE slug = 'for-loop';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Birden Fazla Değişkenle for', 'MultipleVariablesForExample', 5
FROM topic WHERE slug = 'for-loop';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'for Döngüsüyle Dizi Üzerinde Gezinme', 'ArrayIterationForExample', 6
FROM topic WHERE slug = 'for-loop';
