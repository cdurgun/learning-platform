-- Threads konusu, 1-8. bölümler (Thread Oluşturma: Thread Sınıfını Extend Etmek, Thread
-- Oluşturma: Runnable Implement Etmek, Thread Lifecycle, Thread Metotları, Daemon
-- Thread'ler, Race Condition, Synchronization, volatile Anahtar Kelimesi) için örnek
-- metadata'sı. Dosyaların kendisi examples/threads/ altında; bağlantı, önceki konularda
-- olduğu gibi slug + example_name convention'ıyla kurulur.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Thread Sınıfını Extend Etmek', 'ExtendThreadExample', 1
FROM topic WHERE slug = 'threads';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Runnable Implement Etmek', 'RunnableExample', 2
FROM topic WHERE slug = 'threads';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Thread Lifecycle', 'ThreadLifecycleExample', 3
FROM topic WHERE slug = 'threads';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Thread Metotları: start/join/sleep/interrupt', 'ThreadMethodsExample', 4
FROM topic WHERE slug = 'threads';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Daemon Thread''ler', 'DaemonThreadExample', 5
FROM topic WHERE slug = 'threads';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Race Condition', 'RaceConditionExample', 6
FROM topic WHERE slug = 'threads';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Synchronization ile Race Condition Çözümü', 'SynchronizationExample', 7
FROM topic WHERE slug = 'threads';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'volatile ile Bellek Görünürlüğü', 'VolatileExample', 8
FROM topic WHERE slug = 'threads';
