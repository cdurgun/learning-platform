-- stream-fundamentals konusu, 6 örneğin tamamı -- hepsi bu sandbox'ta javac+java ile
-- gerçekten derlenip çalıştırılarak doğrulandı (bkz. V185'teki not).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Stream Oluşturma', 'StreamCreationExample', 1
FROM topic WHERE slug = 'stream-fundamentals';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'filter() ve map()', 'FilterMapExample', 2
FROM topic WHERE slug = 'stream-fundamentals';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'flatMap()', 'FlatMapExample', 3
FROM topic WHERE slug = 'stream-fundamentals';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'distinct(), sorted(), peek()', 'DistinctSortedPeekExample', 4
FROM topic WHERE slug = 'stream-fundamentals';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'limit() ve skip()', 'LimitSkipExample', 5
FROM topic WHERE slug = 'stream-fundamentals';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Lazy Evaluation ve Tek Kullanımlık Stream', 'LazyEvaluationExample', 6
FROM topic WHERE slug = 'stream-fundamentals';
