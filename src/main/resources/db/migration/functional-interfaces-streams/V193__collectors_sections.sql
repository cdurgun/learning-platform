-- collectors konusu, 6 örneğin tamamı -- hepsi bu sandbox'ta javac+java ile gerçekten
-- derlenip çalıştırılarak doğrulandı (bkz. V192'deki not).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'toList() ve toSet()', 'ToListToSetExample', 1
FROM topic WHERE slug = 'collectors';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'joining()', 'JoiningExample', 2
FROM topic WHERE slug = 'collectors';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'groupingBy()', 'GroupingByExample', 3
FROM topic WHERE slug = 'collectors';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'groupingBy() ile Downstream Collector', 'GroupingByDownstreamExample', 4
FROM topic WHERE slug = 'collectors';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'partitioningBy()', 'PartitioningByExample', 5
FROM topic WHERE slug = 'collectors';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'toMap()', 'ToMapExample', 6
FROM topic WHERE slug = 'collectors';
