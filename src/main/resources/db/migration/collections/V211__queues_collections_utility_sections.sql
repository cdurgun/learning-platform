-- `queues-collections-utility` konusu, 6 örneğin tamamı -- hepsi bu sandbox'ta
-- javac+java ile gerçekten derlenip çalıştırılarak doğrulandı (bkz. V210'daki
-- not). Kod yorumları ve println() çıktı metinleri İNGİLİZCE yazıldı (bkz. Faz
-- 53 -- örnek dosyalar dile göre ayrılmadığı için tek kaynak her iki dilde de
-- doğru görünmeli).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Queue Temelleri', 'QueueBasicsExample', 1
FROM topic WHERE slug = 'queues-collections-utility';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Deque: Her İki Uçtan Erişim', 'DequeExample', 2
FROM topic WHERE slug = 'queues-collections-utility';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'ArrayDeque''ı Stack Olarak Kullanmak', 'ArrayDequeAsStackExample', 3
FROM topic WHERE slug = 'queues-collections-utility';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'ArrayDeque vs LinkedList Performans', 'ArrayDequeVsLinkedListPerformanceExample', 4
FROM topic WHERE slug = 'queues-collections-utility';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'PriorityQueue', 'PriorityQueueExample', 5
FROM topic WHERE slug = 'queues-collections-utility';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Collections Yardımcı Sınıfı', 'CollectionsUtilityExample', 6
FROM topic WHERE slug = 'queues-collections-utility';
