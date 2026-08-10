-- Faz 16: Spring Core kategorisinin dördüncü ve planlanan son konusu -- Spring Boot
-- Auto-Configuration & Properties. Component Scanning dersinde bean'lerin nasıl
-- bulunduğunu, Spring IoC Container dersinde nasıl tanımlandığını gördük -- bu konu
-- @SpringBootApplication/@EnableAutoConfiguration'ın perde arkasını, application.yml'den
-- property okumayı (@Value/@ConfigurationProperties), @Profile'ı ve ApplicationEvent'i
-- işliyor. "Spring Boot'ta ApplicationContext (Kısa Bakış)" (Spring IoC Container dersi)
-- ve "Bu Projenin Kendi Sınıfları: Gerçek Bir Component Scanning Örneği" (Component
-- Scanning dersi) bölümlerinde buna zaten ileri referans verilmişti.
--
-- Spring IoC Container ile aynı ADVANCED zorlukta işaretlendi -- @Conditional ailesi,
-- property kaynak önceliği gibi framework-içi mekanizmalar, DI/Component Scanning'den
-- daha derin.
--
-- Şimdilik yalnızca iskelet (topic + çeviriler) var -- estimated_minutes buna göre
-- düşük tutuldu, içerik önceki konularda yaptığımız gibi kademeli olarak eklenecek.
-- Kullanıcı kararıyla bu kez TR ve EN aynı oturumda, art arda tamamlanacak.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'autoconfiguration-properties', 'ADVANCED', 5, 4
FROM category
WHERE slug = 'spring-core';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Spring Boot Auto-Configuration ve Properties',
       '@SpringBootApplication, @Conditional ailesi (@ConditionalOnClass/@ConditionalOnMissingBean/@ConditionalOnProperty), @Value, @ConfigurationProperties, @Profile ve ApplicationEvent/@EventListener.',
       'Spring Boot Auto-Configuration ve Properties Nedir? | Örneklerle Anlatım',
       'Spring Boot''ta @SpringBootApplication''ın perde arkası, @Conditional ailesiyle auto-configuration mekanizması, @Value ve @ConfigurationProperties ile property okuma, @Profile ile ortama özel yapılandırma ve ApplicationEvent/@EventListener gerçek dünya örnekleriyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'autoconfiguration-properties';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Spring Boot Auto-Configuration & Properties',
       '@SpringBootApplication, the @Conditional family (@ConditionalOnClass/@ConditionalOnMissingBean/@ConditionalOnProperty), @Value, @ConfigurationProperties, @Profile, and ApplicationEvent/@EventListener.',
       'What Are Spring Boot Auto-Configuration & Properties? | With Examples',
       'Learn what powers @SpringBootApplication in Spring Boot, how the @Conditional family drives auto-configuration, reading properties with @Value and @ConfigurationProperties, environment-specific configuration with @Profile, and ApplicationEvent/@EventListener, with real-world examples.',
       false
FROM topic
WHERE slug = 'autoconfiguration-properties';
