-- Threads konusu, 9-12. bölümler (Thread Communication: wait/notify/notifyAll, Atomic
-- Sınıflar, Locks: ReentrantLock, Deadlock) ile iki mini proje ekinin (Thread-Safe Banka
-- Hesabı, Producer/Consumer) örnek metadata'sı. Dosyaların kendisi examples/threads/
-- altında; bağlantı, önceki konularda olduğu gibi slug + example_name convention'ıyla
-- kurulur.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Thread Communication: wait/notify/notifyAll', 'WaitNotifyExample', 9
FROM topic WHERE slug = 'threads';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Atomic Sınıflar (CAS)', 'AtomicExample', 10
FROM topic WHERE slug = 'threads';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Locks: ReentrantLock', 'ReentrantLockExample', 11
FROM topic WHERE slug = 'threads';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Deadlock', 'DeadlockExample', 12
FROM topic WHERE slug = 'threads';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Thread-Safe Banka Hesabı', 'BankAccount', 13
FROM topic WHERE slug = 'threads';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Thread-Safe Banka Hesabı Kullanımı', 'BankAccountDemo', 14
FROM topic WHERE slug = 'threads';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Producer/Consumer', 'ProducerConsumer', 15
FROM topic WHERE slug = 'threads';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Producer/Consumer Kullanımı', 'ProducerConsumerDemo', 16
FROM topic WHERE slug = 'threads';
