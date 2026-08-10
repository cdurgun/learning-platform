-- Spring Boot Auto-Configuration & Properties konusu, ilk yarı örnekler:
-- @SpringBootApplication'ın kompozisyonu, @Conditional ailesi
-- (@ConditionalOnClass/@ConditionalOnMissingBean), kendi auto-configuration'ımızı
-- yazmak, @Value ve @ConfigurationProperties (validasyon dahil). Dosyaların kendisi
-- examples/autoconfiguration-properties/ altında.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@SpringBootApplication: Üç Anotasyonun Birleşimi', 'SpringBootApplicationExample', 1
FROM topic WHERE slug = 'autoconfiguration-properties';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@ConditionalOnClass: Sınıf Classpath''te Varsa', 'ConditionalOnClassExample', 2
FROM topic WHERE slug = 'autoconfiguration-properties';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@ConditionalOnMissingBean: Kullanıcı Kendi Bean''ini Tanımladıysa', 'ConditionalOnMissingBeanExample', 3
FROM topic WHERE slug = 'autoconfiguration-properties';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Kendi Auto-Configuration''ımızı Yazmak', 'CustomAutoConfigurationExample', 4
FROM topic WHERE slug = 'autoconfiguration-properties';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@Value ile Tekil Property Enjeksiyonu', 'ValueInjectionExample', 5
FROM topic WHERE slug = 'autoconfiguration-properties';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@ConfigurationProperties ile Gruplanmış Property''ler', 'ConfigurationPropertiesExample', 6
FROM topic WHERE slug = 'autoconfiguration-properties';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@ConfigurationProperties Validasyonu', 'ConfigurationPropertiesValidationExample', 7
FROM topic WHERE slug = 'autoconfiguration-properties';
