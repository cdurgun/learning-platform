-- Faz 17: Spring Core kategorisine beşinci konu -- Transaction Management. Önceki
-- dört konu (Dependency Injection, Spring IoC Container, Component Scanning,
-- Auto-Configuration & Properties) planlanan dörtlüyü tamamlamıştı; kullanıcı isteğiyle
-- bu, bonus bir beşinci konu olarak ekleniyor. @Transactional'ın proxy tabanlı mekanizması,
-- rollback kuralları (checked/unchecked exception ayrımı), propagation (REQUIRED/
-- REQUIRES_NEW), self-invocation tuzağı, isolation levels, readOnly, TransactionTemplate,
-- @TransactionalEventListener/AFTER_COMMIT, ve JPA entegrasyonu (dirty checking, lazy
-- loading -- bu projenin gerçek @ManyToOne(LAZY) alanlarıyla ve TopicRepository'nin
-- gerçek join fetch kullanımıyla grounded) işleniyor.
--
-- Spring IoC Container ve Auto-Configuration & Properties ile aynı ADVANCED zorlukta
-- işaretlendi. Sandbox'ta gerçek bir Postgres bağlantısı olmadığı için, canlı kod
-- örnekleri gerçek bir veritabanı yerine elle yazılmış, AbstractPlatformTransactionManager'dan
-- türeyen minik bir PlatformTransactionManager (LedgerTransactionInfra.java) kullanıyor --
-- Dependency Injection dersindeki "elle simüle container" tekniğinin bir benzeri.
-- Isolation levels, PostgreSQL isolation, dirty checking, lazy loading ve testing
-- transactions bölümleri gerçek eşzamanlı transaction/DB gerektirdiği için kavramsal
-- (Kısa Bakış ya da bu projenin gerçek kaynak koduna referansla), canlı kod örneği yok.
--
-- Şimdilik yalnızca iskelet (topic + çeviriler) var -- estimated_minutes buna göre
-- düşük tutuldu. Kullanıcı kararıyla önce yalnızca TR tamamlanacak.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'transaction-management', 'ADVANCED', 5, 5
FROM category
WHERE slug = 'spring-core';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Transaction Management',
       '@Transactional''ın proxy tabanlı mekanizması, rollback kuralları, propagation (REQUIRED/REQUIRES_NEW), self-invocation tuzağı, isolation levels, readOnly, TransactionTemplate ve @TransactionalEventListener.',
       'Spring Transaction Management Nedir? | @Transactional Örneklerle Anlatım',
       'Spring''de @Transactional''ın proxy tabanlı çalışma mekanizması, rollback kuralları (checked/unchecked exception), propagation türleri (REQUIRED, REQUIRES_NEW), self-invocation tuzağı, isolation levels, readOnly, TransactionTemplate ve @TransactionalEventListener gerçek dünya örnekleriyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'transaction-management';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Transaction Management',
       'The proxy-based mechanism behind @Transactional, rollback rules, propagation (REQUIRED/REQUIRES_NEW), the self-invocation pitfall, isolation levels, readOnly, TransactionTemplate, and @TransactionalEventListener.',
       'What Is Spring Transaction Management? | @Transactional With Examples',
       'Learn how @Transactional''s proxy-based mechanism works in Spring, rollback rules (checked vs. unchecked exceptions), propagation types (REQUIRED, REQUIRES_NEW), the self-invocation pitfall, isolation levels, readOnly, TransactionTemplate, and @TransactionalEventListener, with real-world examples.',
       false
FROM topic
WHERE slug = 'transaction-management';
