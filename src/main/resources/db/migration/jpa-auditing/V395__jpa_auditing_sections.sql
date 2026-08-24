-- `jpa-auditing` konusu, 5 örneğin tamamı. Kod yorumları ve açıklama
-- metinleri İNGİLİZCE yazıldı (bkz. Faz 53).

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Elle Zaman Damgası Sorunu', 'ManualTimestampProblemExample', 1
FROM topic WHERE slug = 'jpa-auditing';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@CreatedDate ve @LastModifiedDate', 'AuditedEntityExample', 2
FROM topic WHERE slug = 'jpa-auditing';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@EnableJpaAuditing ile Bağlamak', 'EnableJpaAuditingExample', 3
FROM topic WHERE slug = 'jpa-auditing';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@CreatedBy/@LastModifiedBy ve AuditorAware', 'CreatedByLastModifiedByExample', 4
FROM topic WHERE slug = 'jpa-auditing';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@MappedSuperclass ile Paylaşmak', 'MappedSuperclassAuditingExample', 5
FROM topic WHERE slug = 'jpa-auditing';
