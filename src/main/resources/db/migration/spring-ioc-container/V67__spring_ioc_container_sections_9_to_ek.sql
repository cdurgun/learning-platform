-- Spring IoC Container & Bean Lifecycle konusu, kalan örnekler: Bean Scope (Singleton/
-- Prototype), Lazy Initialization, Circular Dependency ve iki mini proje eki
-- (Container Yönetimli Bir Rezervasyon Sistemi, Denetimli Sipariş Sistemi). Dosyaların
-- kendisi examples/spring-ioc-container/ altında.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Bean Scope: Singleton (Varsayılan)', 'SingletonScopeExample', 9
FROM topic WHERE slug = 'spring-ioc-container';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Bean Scope: Prototype', 'PrototypeScopeExample', 10
FROM topic WHERE slug = 'spring-ioc-container';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Lazy Initialization: @Lazy', 'LazyInitializationExample', 11
FROM topic WHERE slug = 'spring-ioc-container';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Circular Dependency: @Lazy ile Çözüm', 'CircularDependencyExample', 12
FROM topic WHERE slug = 'spring-ioc-container';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Container Yönetimli Bir Rezervasyon Sistemi (Base)', 'ReservationSystem', 13
FROM topic WHERE slug = 'spring-ioc-container';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Container Yönetimli Bir Rezervasyon Sistemi (Demo)', 'ReservationSystemDemo', 14
FROM topic WHERE slug = 'spring-ioc-container';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Denetimli Sipariş Sistemi (Base)', 'AuditedOrderSystem', 15
FROM topic WHERE slug = 'spring-ioc-container';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Mini Proje: Denetimli Sipariş Sistemi (Demo)', 'AuditedOrderSystemDemo', 16
FROM topic WHERE slug = 'spring-ioc-container';
