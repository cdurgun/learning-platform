-- `lists` konusu, 6 örneğin tamamı -- hepsi bu sandbox'ta javac+java ile gerçekten
-- derlenip çalıştırılarak doğrulandı (bkz. V201'deki not).
--
-- GERÇEK ÖLÇÜM: ArrayListVsLinkedListExample.java, ısıtılmış (warmed-up -- Faz 47'deki
-- ısıtma dersinin burada da uygulanması) bir ölçümle ArrayList/LinkedList arasındaki
-- get()/add(0,...) performans farkını gösteriyor: 20.000 elemanlı listede 3.000 kez
-- get(middle), ArrayList'te ölçülemeyecek kadar hızlı (0 ms), LinkedList'te ~48 ms;
-- 20.000 kez add(0,...) ise ArrayList'te ~16-17 ms, LinkedList'te ~1 ms -- beklenen
-- O(1)/O(n) farkını gerçek çalıştırmayla doğruluyor.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Temel List İşlemleri', 'ListBasicsExample', 1
FROM topic WHERE slug = 'lists';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'ArrayList ve LinkedList Performans Karşılaştırması', 'ArrayListVsLinkedListExample', 2
FROM topic WHERE slug = 'lists';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Immutable List''ler', 'ListOfImmutableExample', 3
FROM topic WHERE slug = 'lists';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Iterator ve ListIterator', 'IteratorExample', 4
FROM topic WHERE slug = 'lists';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Sıralama', 'SortingExample', 5
FROM topic WHERE slug = 'lists';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'subList() ve toArray()', 'SubListAndToArrayExample', 6
FROM topic WHERE slug = 'lists';
