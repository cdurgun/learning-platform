-- `persistence-context-and-locking` konusu, 6 örneğin tamamı. Kod
-- yorumları ve açıklama metinleri İNGİLİZCE yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Entity Yaşam Döngüsü', 'EntityLifecycleExample', 1
FROM topic WHERE slug = 'persistence-context-and-locking';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'First-Level Cache', 'FirstLevelCacheExample', 2
FROM topic WHERE slug = 'persistence-context-and-locking';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'persist(), merge() ve detach()', 'PersistMergeDetachExample', 3
FROM topic WHERE slug = 'persistence-context-and-locking';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Flush Zamanlaması', 'FlushTimingExample', 4
FROM topic WHERE slug = 'persistence-context-and-locking';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@Version ile Optimistic Locking', 'OptimisticLockingExample', 5
FROM topic WHERE slug = 'persistence-context-and-locking';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@Lock ile Pessimistic Locking', 'PessimisticLockingExample', 6
FROM topic WHERE slug = 'persistence-context-and-locking';
