-- `task-execution-and-scheduling` konusu, 7 örneğin tamamı. Kod yorumları
-- ve açıklama metinleri İNGİLİZCE yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'ThreadPoolTaskExecutor Yapılandırması', 'ThreadPoolTaskExecutorConfigExample', 1
FROM topic WHERE slug = 'task-execution-and-scheduling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@Async ve @EnableAsync', 'AsyncServiceExample', 2
FROM topic WHERE slug = 'task-execution-and-scheduling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Self-Invocation Tuzağı', 'SelfInvocationPitfallExample', 3
FROM topic WHERE slug = 'task-execution-and-scheduling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Fixed Rate, Fixed Delay ve Initial Delay', 'ScheduledFixedRateDelayExample', 4
FROM topic WHERE slug = 'task-execution-and-scheduling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Cron İfadeleri', 'ScheduledCronExample', 5
FROM topic WHERE slug = 'task-execution-and-scheduling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Scheduled Görevler İçin Özel Thread Pool', 'SchedulerThreadPoolConfigExample', 6
FROM topic WHERE slug = 'task-execution-and-scheduling';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Pratik Örnek: Async + Scheduled Birlikte', 'PracticalAsyncAndScheduledExample', 7
FROM topic WHERE slug = 'task-execution-and-scheduling';
