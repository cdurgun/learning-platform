-- Transaction Management konusu, kalan örnekler: TransactionTemplate,
-- @TransactionalEventListener/AFTER_COMMIT, ve iki mini proje eki (Para Transferi,
-- Sipariş İşleme). Dosyaların kendisi examples/transaction-management/ altında.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Programmatic Transactions: TransactionTemplate', 'TransactionTemplateExample', 8
FROM topic WHERE slug = 'transaction-management';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Transactional Events: @TransactionalEventListener ve AFTER_COMMIT', 'TransactionalEventListenerExample', 9
FROM topic WHERE slug = 'transaction-management';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Para Transferi (Base)', 'MoneyTransferApp', 10
FROM topic WHERE slug = 'transaction-management';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Para Transferi (Demo)', 'MoneyTransferDemo', 11
FROM topic WHERE slug = 'transaction-management';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Sipariş İşleme (Base)', 'OrderProcessingApp', 12
FROM topic WHERE slug = 'transaction-management';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Sipariş İşleme (Demo)', 'OrderProcessingDemo', 13
FROM topic WHERE slug = 'transaction-management';
