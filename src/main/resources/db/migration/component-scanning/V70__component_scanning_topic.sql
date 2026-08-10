-- Faz 15: Spring Core kategorisinin üçüncü konusu -- Component Scanning &
-- Configuration. Spring IoC Container dersinde bean tanımlamanın tek yolu olarak
-- gördüğümüz @Configuration/@Bean'i (Java Config), bu derste ikinci yol olan
-- @Component taramasıyla (ve @Service/@Repository/@Controller stereotype'larıyla)
-- karşılaştırıyoruz -- "Bean Tanımlama: @Bean ile Java Config" ve "Bean Adlandırma ve
-- Birden Fazla Bean" bölümlerinde buna zaten ileri referans verilmişti.
--
-- Interface/Dependency Injection ile aynı INTERMEDIATE zorlukta işaretlendi --
-- Spring IoC Container'daki kadar derin framework-içi mekanizma (BeanPostProcessor,
-- proxy tabanlı @Lazy) yok, çoğunlukla bir annotation kataloğu ve ne zaman hangisini
-- kullanacağına dair tasarım kararları. Spring Boot Auto-Configuration & Properties
-- (bir sonraki Spring Core konusu), burada öğrenilen component scanning'in Spring
-- Boot'un kendisi tarafından nasıl otomatik tetiklendiğini (@SpringBootApplication)
-- işleyecek.
--
-- Şimdilik yalnızca iskelet (topic + çeviriler) var -- estimated_minutes buna göre
-- düşük tutuldu, içerik önceki konularda yaptığımız gibi kademeli olarak eklenecek.
-- Kullanıcı kararıyla bu fazda önce yalnızca TR tamamlanacak.

INSERT INTO topic (category_id, slug, difficulty, estimated_minutes, sort_order)
SELECT id, 'component-scanning', 'INTERMEDIATE', 5, 3
FROM category
WHERE slug = 'spring-core';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'tr',
       'Component Scanning ve Configuration',
       '@Component/@Service/@Repository/@Controller stereotype''ları, @ComponentScan, @Autowired (field/setter/constructor), @Qualifier ve @Primary.',
       'Spring Component Scanning ve Configuration Nedir? | Örneklerle Anlatım',
       'Spring''de @Component/@Service/@Repository/@Controller stereotype''ları, @ComponentScan ile paket tarama, @Autowired ile field/setter/constructor injection, birden fazla bean''i @Qualifier ve @Primary ile çözme gerçek dünya örnekleriyle anlatılıyor.',
       true
FROM topic
WHERE slug = 'component-scanning';

INSERT INTO topic_translation (topic_id, language, title, summary, seo_title, seo_description, published)
SELECT id,
       'en',
       'Component Scanning & Configuration',
       '@Component/@Service/@Repository/@Controller stereotypes, @ComponentScan, @Autowired (field/setter/constructor), @Qualifier, and @Primary.',
       'What Are Component Scanning & Configuration in Spring? | With Examples',
       'Learn Spring''s @Component/@Service/@Repository/@Controller stereotypes, package scanning with @ComponentScan, field/setter/constructor injection with @Autowired, and resolving multiple beans with @Qualifier and @Primary, with real-world examples.',
       false
FROM topic
WHERE slug = 'component-scanning';
