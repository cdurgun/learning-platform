-- Dependency Injection ve IoC konusu, kalan örnekler: Test Edilebilirlik, Spring Olmadan
-- Elle Bağımlılık Enjeksiyonu, Spring'in DI'ı Nasıl Otomatikleştirdiği önizlemesi ve iki
-- mini proje eki (Çok Kanallı Bildirim Dağıtıcısı, Ödeme İşlemcisi). Dosyaların kendisi
-- examples/dependency-injection/ altında.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Test Edilebilirlik: Sahte (Fake) Implementasyon', 'TestableOrderServiceExample', 8
FROM topic WHERE slug = 'dependency-injection';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Composition Root', 'CompositionRootExample', 9
FROM topic WHERE slug = 'dependency-injection';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Spring Annotation''larıyla Önizleme', 'SpringPreviewExample', 10
FROM topic WHERE slug = 'dependency-injection';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Çok Kanallı Bildirim Dağıtıcısı (Base)', 'NotificationDispatcher', 11
FROM topic WHERE slug = 'dependency-injection';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Çok Kanallı Bildirim Dağıtıcısı (Demo)', 'NotificationDispatcherDemo', 12
FROM topic WHERE slug = 'dependency-injection';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Ödeme İşlemcisi (Base)', 'PaymentProcessor', 13
FROM topic WHERE slug = 'dependency-injection';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Ödeme İşlemcisi (Demo)', 'PaymentProcessorDemo', 14
FROM topic WHERE slug = 'dependency-injection';
