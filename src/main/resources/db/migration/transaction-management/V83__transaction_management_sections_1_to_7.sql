-- Transaction Management konusu, ilk yarı örnekler: paylaşılan Ledger/LedgerTransactionManager
-- altyapısı, temel @Transactional kullanımı, rollback kuralları, self-invocation tuzağı,
-- propagation (REQUIRED/REQUIRES_NEW) ve readOnly. Dosyaların kendisi
-- examples/transaction-management/ altında.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Paylaşılan Altyapı: Ledger ve LedgerTransactionManager', 'LedgerTransactionInfra', 1
FROM topic WHERE slug = 'transaction-management';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@Transactional: En Basit Kullanım', 'TransactionalBasicExample', 2
FROM topic WHERE slug = 'transaction-management';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Rollback Kuralları: RuntimeException vs Checked Exception', 'RollbackRulesExample', 3
FROM topic WHERE slug = 'transaction-management';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Self-Invocation Tuzağı', 'SelfInvocationExample', 4
FROM topic WHERE slug = 'transaction-management';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Propagation: REQUIRED (Varsayılan)', 'PropagationRequiredExample', 5
FROM topic WHERE slug = 'transaction-management';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Propagation: REQUIRES_NEW', 'PropagationRequiresNewExample', 6
FROM topic WHERE slug = 'transaction-management';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'readOnly = true: Ne İşe Yarar, Ne İşe Yaramaz', 'ReadOnlyExample', 7
FROM topic WHERE slug = 'transaction-management';
