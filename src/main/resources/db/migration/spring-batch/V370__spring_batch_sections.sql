-- `spring-batch` konusu, 4 örneğin tamamı. Kod yorumları ve açıklama
-- metinleri İNGİLİZCE yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Minimal Job ve Step Yapılandırması', 'OrderImportJobConfig', 1
FROM topic WHERE slug = 'spring-batch';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'ItemReader, ItemProcessor, ItemWriter', 'OrderImportComponents', 2
FROM topic WHERE slug = 'spring-batch';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@Scheduled ile Job Başlatma (JobParameters)', 'ScheduledOrderImportLauncher', 3
FROM topic WHERE slug = 'spring-batch';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Fault Tolerance: Skip ve Retry', 'FaultTolerantImportStepConfig', 4
FROM topic WHERE slug = 'spring-batch';
