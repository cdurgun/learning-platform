-- terminal-operations konusu, 6 örneğin tamamı -- hepsi bu sandbox'ta javac+java ile
-- gerçekten derlenip çalıştırılarak doğrulandı (bkz. V189'daki not, özellikle
-- ShortCircuitExample.java'daki count()/peek() keşfi).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'forEach()', 'ForEachExample', 1
FROM topic WHERE slug = 'terminal-operations';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'reduce()', 'ReduceExample', 2
FROM topic WHERE slug = 'terminal-operations';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'count(), min(), max()', 'CountMinMaxExample', 3
FROM topic WHERE slug = 'terminal-operations';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'findFirst(), findAny(), anyMatch/allMatch/noneMatch', 'FindMatchExample', 4
FROM topic WHERE slug = 'terminal-operations';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'toList() ve toArray()', 'ToListToArrayExample', 5
FROM topic WHERE slug = 'terminal-operations';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Kısa Devre ve count() Optimizasyonu', 'ShortCircuitExample', 6
FROM topic WHERE slug = 'terminal-operations';
