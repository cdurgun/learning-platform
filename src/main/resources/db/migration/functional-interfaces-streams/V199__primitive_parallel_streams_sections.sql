-- primitive-parallel-streams konusu, 6 örneğin tamamı -- hepsi bu sandbox'ta javac+java
-- ile gerçekten derlenip çalıştırılarak doğrulandı (bkz. V198'deki not, özellikle
-- ParallelOverheadExample.java'nın ısıtma/warmup keşfi ve ParallelPitfallExample.java'nın
-- gerçek veri yarışı gözlemi).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'IntStream Oluşturmak', 'IntStreamCreationExample', 1
FROM topic WHERE slug = 'primitive-parallel-streams';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Boxing ve mapToInt()', 'BoxingMapToIntExample', 2
FROM topic WHERE slug = 'primitive-parallel-streams';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Parallel Stream Temelleri', 'ParallelBasicsExample', 3
FROM topic WHERE slug = 'primitive-parallel-streams';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'forEach() vs forEachOrdered()', 'ParallelOrderingExample', 4
FROM topic WHERE slug = 'primitive-parallel-streams';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Thread-Safe Olmayan Paylaşılan Durum Tuzağı', 'ParallelPitfallExample', 5
FROM topic WHERE slug = 'primitive-parallel-streams';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Isıtılmış Performans Ölçümü', 'ParallelOverheadExample', 6
FROM topic WHERE slug = 'primitive-parallel-streams';
