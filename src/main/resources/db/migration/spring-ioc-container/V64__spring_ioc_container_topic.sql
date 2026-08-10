-- Faz 14: Spring Core kategorisinin ikinci konusu -- Spring IoC Container & Bean
-- Lifecycle. Dependency Injection & IoC dersinde elle yaptığımız composition root'u,
-- bu kez gerçek bir Spring container'ının (BeanFactory/ApplicationContext) nasıl
-- otomatikleştirdiğini işliyor -- "Spring'in DI'ı Nasıl Otomatikleştirdiği (Kısa
-- Bakış)" bölümünde buna zaten ileri referans verilmişti.
--
-- Bu konu, projenin kendi bağımlılığı (spring-boot-starter-web -> spring-context)
-- üzerinden gerçek Spring API'lerini (AnnotationConfigApplicationContext,
-- BeanPostProcessor, @Lazy, @PostConstruct/@PreDestroy) kullanıyor -- Reflection/
-- Threads gibi framework/JVM içi mekanizmayı gösterdiği için ADVANCED işaretlendi
-- (Dependency Injection & IoC'nin INTERMEDIATE'ından bir adım daha derin).
-- Component Scanning & Configuration (bir sonraki Spring Core konusu) burada
-- kullanılan @Configuration/@Bean'i, @Component taramasıyla karşılaştırarak
-- derinleştirecek.
--
-- Şimdilik yalnızca iskelet (topic + çeviriler) var -- estimated_minutes buna göre
-- düşük tutuldu, içerik önceki konularda yaptığımız gibi kademeli olarak eklenecek.
-- Kullanıcı kararıyla bu fazda önce yalnızca TR tamamlanacak.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'spring-ioc-container', 'ADVANCED', 5, 2
FROM category
WHERE slug = 'spring-core';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Spring IoC Container ve Bean Yaşam Döngüsü',
       'BeanFactory/ApplicationContext, bean lifecycle, @PostConstruct/@PreDestroy, bean scope''ları, @Lazy ve circular dependency çözümü.',
       'Spring IoC Container ve Bean Yaşam Döngüsü Nedir? | Örneklerle Anlatım',
       'Spring''in IoC container''ı; BeanFactory ve ApplicationContext farkı, bean yaşam döngüsü, @PostConstruct/@PreDestroy, singleton/prototype scope, @Lazy ve circular dependency çözümü gerçek dünya örnekleriyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'spring-ioc-container';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Spring IoC Container & Bean Lifecycle',
       'BeanFactory/ApplicationContext, the bean lifecycle, @PostConstruct/@PreDestroy, bean scopes, @Lazy, and resolving circular dependencies.',
       'What Is the Spring IoC Container & Bean Lifecycle? | With Examples',
       'Learn Spring''s IoC container: the difference between BeanFactory and ApplicationContext, the bean lifecycle, @PostConstruct/@PreDestroy, singleton/prototype scope, @Lazy, and resolving circular dependencies with real-world examples.',
       false
FROM topic
WHERE slug = 'spring-ioc-container';
