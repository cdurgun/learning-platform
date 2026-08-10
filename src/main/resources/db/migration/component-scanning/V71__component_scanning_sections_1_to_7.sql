-- Component Scanning & Configuration konusu, 1-7. örnekler (@Component, Bean
-- Adlandırmasını Özelleştirmek, @Service/@Repository/@Controller, @ComponentScan,
-- Field/Setter/Constructor ile @Autowired, @Qualifier) için örnek metadata'sı.
-- Dosyaların kendisi examples/component-scanning/ altında.

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@Component: Temel Stereotype', 'ComponentAnnotationExample', 1
FROM topic WHERE slug = 'component-scanning';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Bean Adlandırmasını Özelleştirmek', 'CustomBeanNameExample', 2
FROM topic WHERE slug = 'component-scanning';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@Service, @Repository, @Controller Stereotype''ları', 'StereotypeAnnotationsExample', 3
FROM topic WHERE slug = 'component-scanning';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@ComponentScan: Paket Tarama ve Filtreleme', 'ComponentScanConfigExample', 4
FROM topic WHERE slug = 'component-scanning';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Field Injection ile @Autowired', 'AutowiredFieldExample', 5
FROM topic WHERE slug = 'component-scanning';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, 'Setter ve Constructor ile @Autowired', 'AutowiredConstructorSetterExample', 6
FROM topic WHERE slug = 'component-scanning';

INSERT INTO code_example (topic_id, title, example_name, sort_order)
SELECT id, '@Qualifier ile Belirsizliği Çözmek', 'QualifierExample', 7
FROM topic WHERE slug = 'component-scanning';
